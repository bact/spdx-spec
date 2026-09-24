# Conformance

## Overview

This clause specifies conformance for two kinds of subjects:

- **SPDX data**: a set of SPDX elements, typically serialized in a file,
  that describes a system and its components.
  Conformance of SPDX data is specified in
  [Conformance of SPDX data](#conformance-of-spdx-data).
- **Software**: a program that produces, consumes, or validates SPDX data.
  Conformance of software is specified in
  [Conformance of software](#conformance-of-software).

The SPDX model is organized in two ways, which this clause keeps distinct:

- A **namespace** is a named set of classes, properties, vocabularies, and
  individuals of the SPDX model, such as the Core namespace or the Software
  namespace.
  The IRI of a namespace is of the form
  `https://spdx.org/rdf/3/terms/{Namespacename}`.
- A **profile** is a named set of requirements that uses the definitions of
  one or more namespaces and may add restrictions on them.
  SPDX data may declare conformance to a profile,
  and software may support a profile as a compliance point.
  The profiles are specified in [Profiles](#profiles).

Several profiles have the same name as the namespace they are built on,
for example the Software profile and the Software namespace.
They are still distinct: a namespace defines terms,
and a profile states requirements on their use.

## Alternate notation for some conformance requirements

This document contains more than a few cardinality assertions, each of which
indicates the minimum and maximum number of times a property may appear.
These are represented by using "minCount" and "maxCount" respectively.
The absolute minimum number of occurrences is zero (0),
while for an unbounded maximum number of occurrences a star (\*) is being used.

Here are some examples:

- minCount: 1
- maxCount: *
- Cardinality: 0..1
- Cardinality: 0..*
- Cardinality: 1..1
- Cardinality: 1..*

Each of these assertions can easily be understood as to whether a feature is
required, and if so, how many occurrences are required; also, whether a feature
is permitted, and if so, in what number. As this is the format long familiar to
the SPDX community, it has been preserved in this document.

## Normative text and machine-readable artifacts

This specification is published together with machine-readable artifacts that
express its requirements in a form that software can process:
the ontology and its SHACL shapes, the JSON-LD context, and the JSON schema.
The normative text of this specification and these artifacts are intended
to agree.

Some requirements of this specification are not expressed in the artifacts.
Some of these cannot be expressed in the languages the artifacts use;
others could be, but have not yet been implemented in the artifacts.
Successful validation against the artifacts therefore does not by itself
establish that SPDX data conforms to this specification.

Where the normative text of this specification and an artifact disagree,
the text prevails.

## Conformance of SPDX data

### Base conformance

SPDX data conforms to this specification when:

- every object in the data conforms to the definition of its class,
  including the definitions of its properties,
  as specified in the namespaces of this specification;
- the data conforms to the serialization format in which it is expressed,
  as specified in [Model and serializations](serializations.md); and
- the data satisfies all other requirements of this specification
  that apply to it.

SPDX data conforms to the version of this specification identified by the
specVersion property of its CreationInfo.

SPDX data is not required to use every namespace.
It may use the classes and properties of any namespace of this specification,
and it conforms as long as what it uses is used as specified.

### Declared profile conformance

An ElementCollection, such as an SpdxDocument, may declare, using its
profileConformance property, one or more profiles that it conforms to.
When it does, the collection and every Element it contains shall conform to
the requirements of each declared profile, in addition to base conformance.

Every ElementCollection conforms to the Core profile,
whether or not it declares it.

SPDX data that uses the classes and properties of a namespace is not required
to declare conformance to a profile built on that namespace.
For example, SPDX data may contain a Package from the Software namespace
without declaring profileConformance to the Software profile;
it is then required to meet base conformance only.

## Profiles

This specification defines the following fourteen profiles.
The Core profile is mandatory. All others are optional.

| Profile          | Profile identifier                     | Namespaces used                                  |
| ---------------- | -------------------------------------- | ------------------------------------------------ |
| Core             | `core`                                 | Core                                             |
| Software         | `software`                             | Core, Software                                   |
| Security         | `security`                             | Core, Security                                   |
| Licensing        | `simpleLicensing`, `expandedLicensing` | Core, SimpleLicensing, ExpandedLicensing         |
| Dataset          | `dataset`                              | Core, Software, Dataset                          |
| AI               | `ai`                                   | Core, Software, AI                               |
| Build            | `build`                                | Core, Build                                      |
| Lite             | `lite`                                 | Core, Software, SimpleLicensing                  |
| Extension        | `extension`                            | Core, Extension                                  |
| Hardware         | `hardware`                             | Core, Hardware                                   |
| Service          | `service`                              | Core, Service                                    |
| SupplyChain      | `supplyChain`                          | Core, SupplyChain                                |
| Operations       | `operations`                           | Core, Operations                                 |
| FunctionalSafety | `functionalSafety`                     | Core, FunctionalSafety                           |

The profile identifiers are the entries of the ProfileIdentifierType
vocabulary.

### Core profile

The Core profile uses the classes, properties, and vocabularies of the Core
namespace, which are usable by all other profiles.
Although the Core namespace is somewhat extensive, the required properties are
rather minimal to allow maximum flexibility while meeting minimum SBOM
requirements.

Together with the Software profile, the Core profile provides a baseline of
functionality that facilitates interchange of the bills of materials
information produced by tools supporting SPDX.

### Software profile

The Software profile conveys information about software,
using the Software namespace.

### Security profile

The Security profile conveys security-related information,
using the Security namespace.
This includes information about software vulnerabilities that may exist,
the severity of those vulnerabilities, and a mechanism to express how a
vulnerability may affect a specific software element, including whether a fix
is available.

### Licensing profile

The Licensing profile conveys licensing and intellectual property information,
including the SPDX License Expression syntax and references to the
[SPDX License List](https://spdx.org/licenses/).

It uses two namespaces, which allow the same information to be expressed in
different ways:

- the SimpleLicensing namespace, which expresses licenses as
  [license expression](annexes/spdx-license-expressions.md) strings; and
- the ExpandedLicensing namespace, which expresses license expressions as
  fully parsed objects.

The Licensing profile adds the restriction that every software Artifact
shall have a Relationship of type `hasConcludedLicense`.

### Dataset profile

The Dataset profile conveys information about the datasets used in an AI
system or other applications, using the Dataset namespace.
This includes dataset names, versions, sources, associated metadata,
licensing information, and a description or summary of a dataset,
including its characteristics and statistical information, and its
structure, format, content, and properties.

The DatasetPackage class of the Dataset namespace is a subclass of the Package
class of the Software namespace; the profile therefore uses the Software
namespace.

### AI profile

The AI profile conveys information about software components and
dependencies associated with artificial intelligence and machine learning
(AI/ML) models and systems, using the AI namespace.
This includes the software frameworks, libraries, and other components used to
build or deploy an AI system, along with information about their versions,
licenses, and security and ethical considerations.

The AIPackage class of the AI namespace is a subclass of the Package class of
the Software namespace; the profile therefore uses the Software namespace.

### Build profile

The Build profile conveys information about how software is generated and
transformed, using the Build namespace.
This includes the inputs, outputs, procedures and instructions, environments,
and actors of the build process, along with the associated evidence.

### Lite profile

The Lite profile conveys the minimum set of information required for license
compliance in the software supply chain, including the creation of the SBOM,
package lists with licensing and other related items, and their relationships.

The Lite profile does not have a namespace of its own.
It adds restrictions on the use of the Core, Software, and SimpleLicensing
namespaces, which are specified in [SPDX Lite](annexes/spdx-lite.md).

### Extension profile

The Extension profile conveys extended, tailored information that goes beyond
the standard SPDX, using the Extension namespace, in three ways:

- Support profile-based extended characterization of Elements. Enables
  specification and expression of Element characterization extensions within
  any namespace of SPDX without requiring changes to other namespaces
  and without requiring local subclassing of remote classes
  (which could inhibit ecosystem interoperability in some cases).

- Support extension of SPDX by adopting individuals or communities with Element
  characterization details uniquely specialized to their particular context.
  Enables adopting individuals or communities to utilize SPDX expressive
  capabilities along with expressing more arcane Element characterization
  details specific to them and not appropriate for standardization across SPDX.

- Support structured capture of expressive solutions for gaps in SPDX coverage
  from real-world use. Enables adopting individuals or communities to express
  Element characterization details they require that are not currently defined
  in SPDX but likely should be. Enables a practical pipeline that identifies
  gaps in SPDX that should be filled, expresses solutions to those gaps in a
  way that allows the identifying adopters to use the extended solutions with
  SPDX and does not conflict with current SPDX, can be clearly detected among
  the SPDX content exchange ecosystem, provides a clear and structured
  definition of gap solution that can be used as submission for revision to the
  SPDX standard.

The Extension namespace defines the abstract Extension class serving as the
base for all defined Extension subclasses.
Extended information is used between cooperating parties that understand the
form of the extension and can produce and consume its non-standard content.

### Hardware profile

The Hardware profile conveys information about physical and virtual hardware,
using the Hardware namespace.
This includes part numbers, serial and batch numbers, dimensions, and hazards.

### Service profile

The Service profile conveys information about software provided as a service,
using the Service namespace.

### SupplyChain profile

The SupplyChain profile conveys events and processes associated with the
lifecycle of a product, including its creation, transportation, usage, and
decommissioning, using the SupplyChain namespace.

### Operations profile

The Operations profile conveys the business and technical operations context
of an Element, using the Operations namespace.
This includes deliverables and operational assessments,
such as export control assessments.

### FunctionalSafety profile

The FunctionalSafety profile conveys information about artifacts created,
verified, and maintained during the safety lifecycle of a system,
using the FunctionalSafety namespace.
This includes safety-related artifacts, the links between them,
and their verification.

## Conformance of software

### Roles

Software may take one or more of the following roles with respect to SPDX data:

- A **producer** creates or modifies SPDX data and serializes it.
- A **consumer** reads serialized SPDX data and processes it.
- A **validator** determines whether SPDX data conforms to this specification.

### Compliance points

Each profile is a compliance point for software.
Software conforms to this specification at the compliance point of a profile
when, for the roles it takes:

- as a producer, the SPDX data it produces conforms to this specification,
  including the requirements of that profile when the data declares
  conformance to it;
- as a consumer, it can read SPDX data that conforms to this specification
  and uses the namespaces of that profile, in at least one of the SPDX
  serialization formats, and interprets that data as specified; and
- as a validator, it reports SPDX data that does not conform to this
  specification, or to the requirements of that profile, as nonconformant.

Conformance at the Core profile compliance point is mandatory for software
that conforms at any other compliance point.
Conformance at a compliance point entails support for the namespaces that the
profile uses, as listed in [Profiles](#profiles), and for no other namespace.

Software is not required to conform at every compliance point.

### Declaring supported profiles

Software that claims conformance to this specification shall state,
in its documentation, the roles it takes and the compliance points at which it
conforms.
Each compliance point shall be named using its profile identifier
(for example, `core`, `software`, `hardware`).
Because the Core profile compliance point is mandatory,
every such statement includes `core`.

The profiles listed in this statement are the software's
*supported profiles*.
All other profiles defined by this specification are its
*unsupported profiles*.

Software shall not declare, in SPDX data it produces, profileConformance to a
profile that is not one of its supported profiles, unless it copies the
declaration unchanged from input data whose content it preserves as described
below.

### Processing unsupported content

SPDX data may contain classes, properties, and vocabulary entries defined in
namespaces that none of the processing software's supported profiles uses.
This is referred to as *unsupported content*.

Content that is not defined in any namespace of this specification is not
unsupported content, and is outside the scope of this clause.

#### Consuming unsupported content

Software that consumes SPDX data:

- shall not reject SPDX data solely because it contains unsupported content;
- shall continue to process the content of the data that is not unsupported
  content;
- shall treat an instance of an unsupported class that is a subclass of
  Element as an Element, so that references to it from other content
  (for example, the `to` property of a Relationship) remain resolvable
  by its spdxId;
- may ignore unsupported properties of an instance of a supported class.

Software may reject SPDX data that contains unsupported content
when its user explicitly requests this.
In that case, it shall report that the data was rejected because it contains
unsupported content,
not because the data does not conform to this specification.

#### Preserving unsupported content

Software that outputs SPDX data derived from its input
(for example, when converting, merging, filtering, or re-serializing)
should preserve unsupported content unchanged.

If the software does not preserve all unsupported content, it shall:

- not copy into its output a profileConformance declaration for a profile
  whose content it did not preserve; and
- signal incomplete processing as described below.

#### Validating unsupported content

Software that validates SPDX data shall distinguish between content that
it has found not to conform to this specification and content that it has
not validated because it is unsupported content.
It shall not report unsupported content as conformant or as nonconformant.

If the SPDX data declares profileConformance to an unsupported profile,
the software shall report that conformance to that profile was not verified.

#### Signaling incomplete processing

Software that encounters unsupported content shall make this known to its
user, for example in its output log or its report.
The report should identify the namespaces of the unsupported content,
and may identify the unsupported classes and properties encountered.

Software that outputs SPDX data without preserving all unsupported content
should also record this within the output data, so that downstream consumers
are aware of it.
One way to do so is to add an Annotation, with an annotationType of `other`,
to the SpdxDocument of the output, whose statement identifies the namespaces
whose content was omitted.

#### Example (informative)

A tool supports the Core and Software profiles.
It reads the following SPDX data (the SpdxDocument and CreationInfo are
omitted for brevity):

```json
{
  "@context": "https://spdx.org/rdf/3.1/spdx-context.jsonld",
  "@graph": [
    {
      "type": "Organization",
      "spdxId": "https://example.com/org/acme",
      "creationInfo": "_:creationinfo",
      "name": "ACME"
    },
    {
      "type": "hardware_PhysicalHardware",
      "spdxId": "https://example.com/hw/board-1",
      "creationInfo": "_:creationinfo",
      "name": "Controller board",
      "hardware_partNumber": "CB-1000",
      "hardware_productAgent": "https://example.com/org/acme"
    },
    {
      "type": "software_Package",
      "spdxId": "https://example.com/sw/firmware",
      "creationInfo": "_:creationinfo",
      "name": "Controller firmware",
      "software_packageVersion": "2.4.0"
    },
    {
      "type": "Relationship",
      "spdxId": "https://example.com/rel/1",
      "creationInfo": "_:creationinfo",
      "from": "https://example.com/hw/board-1",
      "relationshipType": "contains",
      "to": ["https://example.com/sw/firmware"]
    }
  ]
}
```

The `hardware_PhysicalHardware` object is unsupported content,
because it is defined in the Hardware namespace, which neither the Core nor
the Software profile uses.
The tool:

- processes the Organization, the software Package, and the Relationship;
- treats `https://example.com/hw/board-1` as an Element of an unsupported
  class, so that the Relationship still resolves and the tool can report that
  the firmware is contained in another Element;
- reports to its user that content of the Hardware namespace was encountered
  and not processed;
- if it writes the data out again, keeps the `hardware_PhysicalHardware` object
  unchanged; if it drops that object instead, it does not declare
  profileConformance to `hardware` in its output and adds an Annotation
  stating that content of the Hardware namespace was omitted.

A validator that supports the same profiles reports the Package and the
Relationship as validated and the `hardware_PhysicalHardware` object as not
validated. It does not report the data as invalid.

## Trademark compliance

To be designated an SPDX document, a file shall comply with the requirements of the SPDX Trademark
License, as stated in the [SPDX Trademark Page](https://spdx.dev/trademark).

The official copyright notice that shall be used with any verbatim reproduction and/or distribution of
this SPDX Specification 3.1 is:

"Official SPDX® Specification 3.1 Copyright © 2010–2026 Linux Foundation and its Contributors.
Licensed under the Community Specification License 1.0. All other rights are expressly reserved."

The official copyright notice that shall be used with any non-verbatim reproduction and/or distribution
of this SPDX Specification 3.1, including without limitation any partial use or combining this SPDX
Specification with another work, is:

"This is not an official SPDX Specification. Portions herein have been reproduced from SPDX®
Specification 3.1 found at spdx.dev. These portions are Copyright © 2010–2026 Linux Foundation and
its Contributors, and are licensed under the Community Specification License 1.0 by the
Linux Foundation and its Contributors. All other rights are expressly reserved by Linux Foundation and
its Contributors."
