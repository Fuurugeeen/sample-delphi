#!/usr/bin/env python3
"""
Code validation script for Delphi Calculator project
Performs basic syntax and structure validation without compilation
"""

import os
import re
import sys
from pathlib import Path

def check_pascal_syntax(file_path):
    """Basic Pascal/Delphi syntax validation"""
    issues = []
    
    with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
        content = f.read()
        lines = content.split('\n')
    
    # Check for basic Pascal structure
    if not re.search(r'\bunit\s+\w+\s*;', content, re.IGNORECASE):
        if not re.search(r'\bprogram\s+\w+\s*;', content, re.IGNORECASE):
            issues.append("Missing unit or program declaration")
    
    # Check for interface section in units
    if re.search(r'\bunit\s+\w+\s*;', content, re.IGNORECASE):
        if not re.search(r'\binterface\b', content, re.IGNORECASE):
            issues.append("Unit missing interface section")
        if not re.search(r'\bimplementation\b', content, re.IGNORECASE):
            issues.append("Unit missing implementation section")
    
    # Check for unmatched begin/end
    begin_count = len(re.findall(r'\bbegin\b', content, re.IGNORECASE))
    end_count = len(re.findall(r'\bend\b', content, re.IGNORECASE))
    
    # Basic balance check (not perfect but helpful)
    if abs(begin_count - end_count) > 1:  # Allow for final 'end.'
        issues.append(f"Potential begin/end mismatch: {begin_count} begins, {end_count} ends")
    
    # Check for missing semicolons (basic check)
    procedure_lines = [i for i, line in enumerate(lines) 
                      if re.search(r'\bprocedure\s+\w+', line, re.IGNORECASE)]
    function_lines = [i for i, line in enumerate(lines) 
                     if re.search(r'\bfunction\s+\w+', line, re.IGNORECASE)]
    
    # Check uses clauses
    uses_matches = re.findall(r'\buses\s+(.*?);', content, re.IGNORECASE | re.DOTALL)
    for uses_clause in uses_matches:
        # Remove comments and whitespace
        uses_clause = re.sub(r'\{.*?\}', '', uses_clause)
        uses_clause = re.sub(r'//.*', '', uses_clause)
        units = [u.strip() for u in uses_clause.replace('\n', ' ').split(',')]
        for unit in units:
            if unit and not re.match(r'^[a-zA-Z][a-zA-Z0-9_.]*$', unit):
                issues.append(f"Suspicious unit name: {unit}")
    
    return issues

def check_test_structure(file_path):
    """Check DUnitX test structure"""
    issues = []
    
    with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
        content = f.read()
    
    # Check for DUnitX imports
    if 'TestFramework' in file_path:
        if not re.search(r'DUnitX\.TestFramework', content):
            issues.append("Missing DUnitX.TestFramework import")
    
    # Check for test fixture
    if not re.search(r'\[TestFixture\]', content):
        issues.append("Missing [TestFixture] attribute")
    
    # Check for test methods
    test_methods = re.findall(r'\[Test\]\s*procedure\s+(\w+)', content, re.IGNORECASE)
    if not test_methods:
        issues.append("No test methods found")
    else:
        print(f"  Found {len(test_methods)} test methods: {', '.join(test_methods)}")
    
    # Check for Setup/TearDown
    if re.search(r'\[Setup\]', content):
        print("  Found Setup method")
    if re.search(r'\[TearDown\]', content):
        print("  Found TearDown method")
    
    return issues

def validate_project_structure():
    """Validate overall project structure"""
    print("=== Project Structure Validation ===")
    
    base_dir = Path("..")
    required_files = [
        "Project1.dpr",
        "Unit1.pas", 
        "Unit1.dfm",
        "src/engines/CalculatorEngine.pas"
    ]
    
    missing_files = []
    for file_path in required_files:
        if not (base_dir / file_path).exists():
            missing_files.append(file_path)
    
    if missing_files:
        print(f"Missing required files: {missing_files}")
        return False
    else:
        print("All required files present")
        return True

def main():
    print("=== Delphi Calculator Project Code Validation ===\n")
    
    # Validate project structure
    if not validate_project_structure():
        print("Project structure validation failed")
        return 1
    
    # Find and validate Pascal files
    test_files = [
        "TestCalculatorEngine.pas",
        "TestCalculatorForm.pas", 
        "CalculatorTests.dpr"
    ]
    
    source_files = [
        "../src/engines/CalculatorEngine.pas",
        "../Unit1.pas"
    ]
    
    all_files = test_files + source_files
    total_issues = 0
    
    for file_path in all_files:
        if os.path.exists(file_path):
            print(f"\n--- Validating {file_path} ---")
            
            # Basic syntax check
            issues = check_pascal_syntax(file_path)
            
            # Special check for test files
            if "Test" in file_path and file_path.endswith('.pas'):
                test_issues = check_test_structure(file_path)
                issues.extend(test_issues)
            
            if issues:
                print(f"Issues found in {file_path}:")
                for issue in issues:
                    print(f"  - {issue}")
                total_issues += len(issues)
            else:
                print(f"✓ {file_path} looks good")
        else:
            print(f"✗ File not found: {file_path}")
            total_issues += 1
    
    print(f"\n=== Validation Summary ===")
    print(f"Total issues found: {total_issues}")
    
    if total_issues == 0:
        print("✓ Code validation passed! Project structure looks correct.")
        print("\nNext steps:")
        print("1. Open tests/CalculatorTests.dproj in RAD Studio")
        print("2. Build the project (Ctrl+F9)")
        print("3. Run tests (F9) or use Test Explorer")
    else:
        print("✗ Issues found. Please review and fix before testing.")
    
    return 0 if total_issues == 0 else 1

if __name__ == "__main__":
    try:
        os.chdir(os.path.dirname(__file__) or ".")
        sys.exit(main())
    except Exception as e:
        print(f"Validation script error: {e}")
        sys.exit(1)