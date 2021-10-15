Return-Path: <SRS0=poro=PD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D360C433F5
	for <kvmarm@archiver.kernel.org>; Fri, 15 Oct 2021 16:14:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9589461053
	for <kvmarm@archiver.kernel.org>; Fri, 15 Oct 2021 16:14:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9589461053
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D2F734B150;
	Fri, 15 Oct 2021 12:14:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id o9i4bmPTe2fF; Fri, 15 Oct 2021 12:14:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 914AE4B154;
	Fri, 15 Oct 2021 12:14:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1248E4B150
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Oct 2021 12:14:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RCBLV0ejEtxf for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Oct 2021 12:14:36 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9DE2D4B11F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Oct 2021 12:14:36 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 68B2C11D4;
 Fri, 15 Oct 2021 09:14:35 -0700 (PDT)
Received: from merodach.members.linode.com (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9CC923F66F;
 Fri, 15 Oct 2021 09:14:34 -0700 (PDT)
From: James Morse <james.morse@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu
Subject: [RFC PATCH 0/7] arm64: mm: Prototype to allow drivers to request PBHA
 values
Date: Fri, 15 Oct 2021 16:14:09 +0000
Message-Id: <20211015161416.2196-1-james.morse@arm.com>
X-Mailer: git-send-email 2.20.1
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

Hello!

Do you have hardware that uses PBHA? If so, what does the SoC do in response to
which bits, and what workload needs that behaviour?

This series is a start at trying to work out what linux needs to support to makeuse of existing SoCs using PBHA.


PBHA is a feature that adds an extra four bits to each read or write transaction
for the SoC implementer to do - whatever they like with! An obvious example
would be a hint for whether the access should allocate (or not) in the system
cache. The hint would allow better performance for some SoC specific workloads.

The arm-arm doesn't define what the bits do, only where in the page tables they
come from. It also doesn't define how these bits are combined between stage1
and stage2.

It appears that all of Arm's Cortex cores with the feature do the stage1+stage2
combining in the same way. (stage2 wins). Patch 1 turns PBHA on for stage2,
where KVM only generates the safe default value. This stops KVM guests from
using PBHA on Cortex cores. It should be harmless for any core that does not
behave like this.


The remaining patches allow firmware to describe which PBHA bits only affect
performance, and which have dangerous side effects like encryption or other
forms of corruption, that would mean the OS has to ensure all aliases are
removed.

The lists exist to allow an OS to avoid the cost of rewriting aliases when that
isn't necessary, and for KVM to determine which bits it can enable for a guest:
KVM uses the 'performance only' list to try and enable the corresponding bits
for KVM guests - but only if they can't be used to generate a value not in the
list.
This depends on knowing the CPU implements the 'stage2 wins' behaviour. I've
listed the CPUs whose TRMs describe this behaviour, and asked for other TRMs to
be updated to say what the behaviour is.

A pgprot_pbha() helper is added to allow drivers to request the 'performance
only' kind of PBHA bit for a mapping.


Supporting the 'no aliases' kind is much more involved. I've not tried to do
this. (do we need to?)

I don't have a platform that uses any of this, so I can't detect whether or not
the PBHA values were generated with the read/writes.


Thanks,

James Morse (7):
  KVM: arm64: Detect and enable PBHA for stage2
  dt-bindings: Rename the description of cpu nodes cpu.yaml
  dt-bindings: arm: Add binding for Page Based Hardware Attributes
  arm64: cpufeature: Enable PBHA bits for stage1
  arm64: mm: Add pgprot_pbha() to allow drivers to request PBHA values
  KVM: arm64: Configure PBHA bits for stage2
  Documentation: arm64: Describe the support and expectations for PBHA

 Documentation/arm64/index.rst                 |   1 +
 Documentation/arm64/pbha.rst                  |  86 +++
 .../devicetree/bindings/arm/cpu.yaml          | 544 ++++++++++++++++
 .../devicetree/bindings/arm/cpus.yaml         | 591 ++----------------
 arch/arm64/Kconfig                            |  13 +
 arch/arm64/include/asm/cpufeature.h           |   1 +
 arch/arm64/include/asm/cputype.h              |   4 +
 arch/arm64/include/asm/kvm_arm.h              |   1 +
 arch/arm64/include/asm/kvm_pgtable.h          |   9 +
 arch/arm64/include/asm/pgtable-hwdef.h        |   5 +
 arch/arm64/include/asm/pgtable.h              |  12 +
 arch/arm64/kernel/cpufeature.c                | 196 ++++++
 arch/arm64/kernel/image-vars.h                |   3 +
 arch/arm64/kvm/hyp/pgtable.c                  |  15 +-
 arch/arm64/tools/cpucaps                      |   3 +
 15 files changed, 961 insertions(+), 523 deletions(-)
 create mode 100644 Documentation/arm64/pbha.rst
 create mode 100644 Documentation/devicetree/bindings/arm/cpu.yaml

-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
