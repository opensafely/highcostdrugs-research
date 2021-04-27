
# Import functions

from cohortextractor import (
    StudyDefinition, 
    patients, 
    codelist_from_csv
)

# Import codelists

adalimumab_codes = codelist_from_csv(
    "codelists/opensafely-high-cost-drugs-adalimumab.csv", system="highcostdrugs", column="olddrugname"
)

# Specifiy study defeinition

study = StudyDefinition(
    # Configure the expectations framework
    default_expectations={
        "date": {"earliest": "1900-01-01", "latest": "today"},
        "rate": "exponential_increase",
    },
    # This line defines the study population
    population=patients.registered_with_one_practice_between(
        "2020-01-01", "2020-03-31"
    ),

    # https://github.com/opensafely/risk-factors-research/issues/49
    age=patients.age_as_of(
        "2020-03-01",
        return_expectations={
            "rate": "universal",
            "int": {"distribution": "population_ages"},
        },
    ),
    
    # https://github.com/opensafely/risk-factors-research/issues/46
    sex=patients.sex(
        return_expectations={
            "rate": "universal",
            "category": {"ratios": {"M": 0.49, "F": 0.51}},
        }
    ),

    # https://github.com/opensafely/risk-factors-research/issues/44
    stp=patients.registered_practice_as_of(
        "2020-03-01",
        returning="stp_code",
        return_expectations={
            "rate": "universal",
            "category": {"ratios": {"STP1": 0.5, "STP2": 0.5}},
        },
    ),

    #https://github.com/opensafely-core/cohort-extractor/blob/819b1ca256d4c0f3ff2fca68389cc846417a021c/cohortextractor/patients.py#L1731-L1765
    prescribed_adalimumab=patients.with_high_cost_drugs(
                drug_name_matches= adalimumab_codes,
                between = ["2019-10-01", "2020-03-31"],
                find_first_match_in_period=True,
                returning="binary_flag",
                return_expectations={"incidence": 0.05,},
            )
)
