# About the Data
## COMP2420 Semester 1, 2022
## Assignment 2

The following document is designed to give you an introduction to the data you
are working with, including the references for data generation.

## Data Tables
The below table provides an outline of the data, broken down into the columns
the dataset features. Additional information regarding the schemas and sets used
will be provided next.


####  The CVSS data table
| Column Name    | Description    |
| :------------- | :------------- |
| cve_id         | The CVE identifier for the vulnerability |
| assigner       | The entity who assigned the CVE |
| description     | A description of the vulnerability |
| cwe_ids         | The CWE identifiers of the vulnerability. Note that there can be multiple cwe_id's attached to one cve_id |
| refs            | url links to the initial postings of the vulnerability |
| ref_names       | other information which provide more reference about the CVE |
| ref_sources     | other information which provide more reference about the CVE |
| ref_tags        | other information which provide more reference about the CVE |
| v3_attackVector | CVSSv3 field, identifier for how the vulnerability would be used in an attack |
| v3_attackComplexity | CVSSv3 field, identifier for the difficulty of performing an attack using the vulnerability |
| v3_privilegesRequired | CVSSv3 field, an identifier for the privileges required in the system to use the vulnerability successfully |
| v3_userInteraction | CVSSv3 field, an identifier for whether a user needs to actively interact for the vulnerability to be exploited or not |
| v3_scope | CVSSv3 field, an identifier for whether the scope of an item changes when using the vulnerability. e.g: whether a regular user becomes a superuser. |
| v3_confidentialityImpact | CVSSv3 field, identifier for the impact upon the confidentiality of information in the product/service after using the vulnerability |
| v3_integrityImpact | CVSSv3 field, identifier for the impact upon the integrity of information in the product/service after using the vulnerability |
| v3_availabilityImpact | CVSSv3, field, identifier for the impact upon the availability of information in the product/service after using the vulnerability |
| v3_exploitabilityScore | The Exploitability Score is a sub score of the CVSS Base Score |
| v3_impactScore | The Impact Score is a sub score of the CVSS Base Score |
| v3_baseScore | The CVSS score (out of 10) given to the vulnerability based on CVSS v3.1 |
| v3_baseSeverity | A textual representation of the numeric Base Score|

We only use the Base Metrics out of the [CVSS Metrics](https://www.first.org/cvss/v3-1/media/MetricGroups.svg). While there are additional metrics that can be applied, most are variants. Therefore, we will use the base metrics. The column names starting with 'v3_' are CVSS v3.1 metrics. Refer to the specification document  [CVSSv3.1 Guide](https://www.first.org/cvss/v3.1/specification-document) for more information on the metrics. 

####  The CVE to Configurations mapping table
| Column Name    | Description    |
| :------------- | :------------- |
| cve_id         | The CVE identifier for the vulnerability |
| vendor         | The name of the vendor who produces the product |
| product_name   | The name of the affected product       |
| version        | List of the affected product versions |

Recall that a CVE can affect multiple products and multiple software versions of a product.

####  The CWE to CAPECS mapping table
| Column Name    | Description    |
| :------------- | :------------- |
| cwe            | A unique CWE identifier |
| capecs         | The list of CAPEC identifiers associated with the given CWE id |

Recall that a single CWE identifier may be associated with multiple CAPEC identifiers.

## Schema Descriptions
In the tables above, a large number of schemas (such as CVE, CWE, CVSS) are referenced. The following is designed to give you an introduction to these systems and links for further reading as required.

#### The Common Vulnerability and Exposures (CVE) system
The CVE system is like a database that holds a number of the publicly known vulnerabilities that exist for software. It is the de-facto identifying system for publicly exposed vulnerabilities in systems, used by big tech companies such as  Apple, Microsoft, Google, Red Hat, etc. The CVE is a schema that allows the consistent storing of information regarding vulnerabilities.  More reading on the CVE is [here](https://www.cve.org/)

The CVE system was developed by [The MITRE Corporation](https://www.mitre.org/) almost 20 years ago, and is now the de-facto system for providing identifiers for vulnerabilities in various systems. 

CVE defines a vulnerability as, _"A weakness in the computational logic (e.g., code) found in software and hardware components that, when exploited, results in a negative impact to confidentiality, integrity, or availability"._ A CVE can affect multiple products and multiple software versions of a product.

However, the CVE system alone is incomplete, and extended by organisations such as the **National Vulnerability Database (NVD)**.

#### The Common Weakness Enumeration (CWE) system
There is another related system to CVE called the [Common Weakness Enumeration (CWE)](https://cwe.mitre.org), also developed by MITRE. CWE categorises types of software vulnerabilities whereas CVE is just a list of currently known vulnerabilities regarding specific systems and products (Camacho, 2021) .  Each CWE identifier is related to a specific type of weakness which will have its own unique characteristics, rather than specific instances of vulnerabilities within products or systems. 
The CWE's are broadly viewed in three categories:
- [by Software Development](https://cwe.mitre.org/data/definitions/699.html)
- [by Hardware Design](https://cwe.mitre.org/data/definitions/1194.html)
- [by Research Concepts](https://cwe.mitre.org/data/definitions/1000.html)

#### The Common Vulnerability Scoring System (CVSS)
CVSS is the de-facto scoring system for determining the impacts of vulnerabilities in the CVE system.  It is developed and maintained by the [National Vulnerability Database (NVD)](https://nvd.nist.gov).  All vulnerabilities in the NVD have been assigned a CVE identifier. Developed by the Forum of Incident Response and Security Teams (FIRST), the CVSS system is now in its 3<sup>rd</sup> major iteration (version 3).

#### Common Attack Pattern Enumeration and Classification (CAPEC):
Also of interest is the [Common Attack Pattern Enumeration and Classification (CAPEC) system](https://capec.mitre.org/).
Developed by leveraging CWE and CVE, CAPEC is a comprehensive dictionary and classification taxonomy of known attacks that can be used by analysts, developers, testers, and educators to advance community understanding and enhance defenses. (https://cve.mitre.org/cve_cwe_capec_relationships)
The CAPEC system was (also) developed by MITRE. This is currently linked through the CWE system.

## The Assignment Dataset: based on the Common Vulnerability Scoring System (CVSS) data
The assignment dataset is derived from a subset of the Common Vulnerability Scoring System (CVSS) data for the year 2020 available from the [National Vulnerability Database (NVD)](https://nvd.nist.gov). 

Note that while over 1000 CWE identifiers exist, only a small subset will be present within our dataset. This is due to the NVD using their own subset of them, which can be found on the [NVD website](https://nvd.nist.gov/vuln/categories).

We have further filtered the 2020 CVSS dataset by retaining only the records that relate to the Software Development viewpoint. In our dataset, each unique CVE is mapped to one or more CWE's and is given a vulnerability score that is assigned by the CVSS scoring system. 



## Miscellaneous References
- The CVSS data was originally scraped from the National Vulnerability Database and related sources on the 16<sup>th</sup> of February, 2022 and processed by Mindika Premachandra.
The dataset used in this assignment is restricted to a subset of the records.
Data sources:
    - CVSS data: https://nvd.nist.gov/feeds/json/cve/1.1/nvdcve-1.1-2020.json.zip
    - CWE data: https://cwe.mitre.org/data/downloads.html
    - CAPEC data: https://capec.mitre.org/data/index.html

## Authors
- This assignment was developed by Priscilla Kan John and Mindika Premachandra.
- Credit:  Part of this assignment is based on previous work by Alex Niven in COMP2420/6420.  We thank Alex for allowing us to use his work and build on it.