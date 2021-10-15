Return-Path: <SRS0=poro=PD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FF9AC433FE
	for <kvmarm@archiver.kernel.org>; Fri, 15 Oct 2021 16:14:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 20A50611CE
	for <kvmarm@archiver.kernel.org>; Fri, 15 Oct 2021 16:14:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 20A50611CE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C191D4B175;
	Fri, 15 Oct 2021 12:14:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JB63IPccvH-z; Fri, 15 Oct 2021 12:14:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 194FB4B161;
	Fri, 15 Oct 2021 12:14:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A5C54B128
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Oct 2021 12:14:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wj8BhFR5wAWD for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Oct 2021 12:14:53 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E7714B16E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Oct 2021 12:14:52 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3D47711D4;
 Fri, 15 Oct 2021 09:14:52 -0700 (PDT)
Received: from merodach.members.linode.com (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 72FFC3F66F;
 Fri, 15 Oct 2021 09:14:51 -0700 (PDT)
From: James Morse <james.morse@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu
Subject: [RFC PATCH 3/7] dt-bindings: arm: Add binding for Page Based Hardware
 Attributes
Date: Fri, 15 Oct 2021 16:14:12 +0000
Message-Id: <20211015161416.2196-4-james.morse@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211015161416.2196-1-james.morse@arm.com>
References: <20211015161416.2196-1-james.morse@arm.com>
MIME-Version: 1.0
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

ARM CPUs with the FEAT_HPDS2 feature allow an IMPLEMENTATION DEFINED
hardware attribute to be encoded in the leaf page table entries and
sent with any transaction that makes an access via that entry.

Some designs are using these bits as a hint to the system-cache
that it should apply a particular policy to this access. e.g. to
prioritise the caching of particular workload data.

The arm-arm doesn't define what these bits mean. Implementations
could use this to encrypt, or otherwise corrupt data. Setting an
'incorrect' value may lead to correctness or coherency issues.
The arm-arm only defines '0' as a safe default value.

As there are only four bits, it is likely these will be combined
and treated as a four-bit value by some hardware. This binding
expects values. Using values allows firmware to describe that two
bits should not be set at the same time.

To allow these hints to be used, add a way of describing which
values only have a performance impact, and which can only be
used if all mappings use the same PBHA value. This goes in the
cpus node binding, as it must be the same for all CPUs.

Signed-off-by: James Morse <james.morse@arm.com>
---
 .../devicetree/bindings/arm/cpus.yaml         | 91 +++++++++++++++++++
 1 file changed, 91 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/cpus.yaml

diff --git a/Documentation/devicetree/bindings/arm/cpus.yaml b/Documentation/devicetree/bindings/arm/cpus.yaml
new file mode 100644
index 000000000000..326e393d4de1
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/cpus.yaml
@@ -0,0 +1,91 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: "http://devicetree.org/schemas/arm/cpus.yaml#"
+$schema: "http://devicetree.org/meta-schemas/core.yaml#"
+
+title: CPUS, a container for CPU subnodes
+
+description: |
+  The device tree allows to describe the layout of CPUs in a system through
+  the "cpus" node, which in turn contains a number of subnodes (ie "cpu")
+  defining properties for every CPU.
+
+  Properties of the CPU integration that are common to all CPUs can be described
+  in the cpus node.
+
+  ARM CPUs with the FEAT_HPDS2 feature allow an IMPLEMENTATION DEFINED
+  hardware attribute to be encoded in the leaf page table entries and
+  sent with any transaction that makes an access via that entry.
+
+  Four bits are used in the page-tables. It is likely the individual bits will
+  be combined and used a a four bit value. The impact of any particular value is
+  up to the implementation.
+
+  0 is defined as a 'safe default setting' that behaves as if the feature
+  were not implemented. Other values may be unsafe, having coherency or
+  correctness issues leading to data-corruption or deadlock.
+
+  This binding lists the additional values that only have a performance cost
+  (or benefit), and values that can only be used if all mappings have the same
+  PBHA value.
+  For both cases, all affected values should be listed. If setting bit-2
+  requires no aliases, then the values 2, 4, 6 etc should be listed.
+
+  A hypervisor can only control individual bits, and may choose to only enable
+  bits that can only be used to build other performance-only values.
+  e.g. the value 5 is listed, but enabling bit-0 and bit-2 would allow a guest
+  to configure the values 1 or 4 too. If these 'decomposed' values only
+  affected performance, they should also be listed.
+
+  The list does not need to be in numeric order, but a hypervisor may make use
+  of the order when enabling bits.
+
+  The presence of a 'arm,pbha-no-aliases' property indicates that higher
+  exception levels and secure-world firmware do not have a mapping of any memory
+  in the memory node or UEFI memory map, other than those with a reserved-memory
+  entry or EFIReserved memory attribute.
+  Firmware mappings created based on requests from the normal world do not use
+  any of the arm,pbha-no-aliases values, or take the PBHA value to use as an
+  argument.
+
+properties:
+  $nodename:
+    const: cpus
+
+  arm,pbha-performance-only:
+    $ref: /schemas/types.yaml#/definitions/uint8-array
+    description: PBHA values that only affect performance
+    minItems: 1
+    maxItems: 15
+    items:
+      maximum: 15
+
+  arm,pbha-no-aliases:
+    $ref: /schemas/types.yaml#/definitions/uint8-array
+    description: PBHA values that must only be used if all mappings have the
+                   same value.
+    minItems: 1
+    maxItems: 15
+    items:
+      maximum: 15
+
+
+additionalProperties: true
+
+examples:
+  -|
+  /{
+    cpus {
+      arm,pbha-performance-only = /bits/ 8 <0x01 0x05 0x09>;
+      arm,pbha-no-aliases = /bits/ 8 <0x02 0x04 0x06 0x08>;
+
+      cpu@0 {
+        device_type = "cpu";
+        compatible = "arm,cortex-a57";
+        ...
+      };
+
+    };
+  };
+...
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
