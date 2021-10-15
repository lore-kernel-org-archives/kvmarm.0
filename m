Return-Path: <SRS0=poro=PD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87B62C433F5
	for <kvmarm@archiver.kernel.org>; Fri, 15 Oct 2021 16:14:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 251D2611C1
	for <kvmarm@archiver.kernel.org>; Fri, 15 Oct 2021 16:14:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 251D2611C1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C3FAA4B150;
	Fri, 15 Oct 2021 12:14:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 76IkugokasXr; Fri, 15 Oct 2021 12:14:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CECCB4B161;
	Fri, 15 Oct 2021 12:14:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C9B7F4B150
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Oct 2021 12:14:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id F540ZPgfiyuS for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Oct 2021 12:14:49 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 458084B11F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Oct 2021 12:14:49 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F148411D4;
 Fri, 15 Oct 2021 09:14:48 -0700 (PDT)
Received: from merodach.members.linode.com (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 327693F66F;
 Fri, 15 Oct 2021 09:14:48 -0700 (PDT)
From: James Morse <james.morse@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu
Subject: [RFC PATCH 1/7] KVM: arm64: Detect and enable PBHA for stage2
Date: Fri, 15 Oct 2021 16:14:10 +0000
Message-Id: <20211015161416.2196-2-james.morse@arm.com>
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

Page Based Hardware Attributes (PBHA, aka HPDS2) allow a page table entry
to specify up to four bits that can be used by the hardware for some
implementation defined purpose.

This is a problem for KVM guests as the host may swap guest memory using
a different combination of PBHA bits than the guest used when writing the
data. Without knowing what the PBHA bits do, its not possible to know if
this will corrupt the guest's data.

The arm-arm doesn't describe how the PBHA bits are combined between stage1
and stage2. Arm's Cortex CPUs appear to all do the same thing: stage2 wins.

Enable PBHA for stage2, where the configured value is zero. This has no
effect if PBHA isn't in use. On Cortex cores that have the 'stage2 wins'
behaviour, this disables whatever the guest may be doing. For any other
core with a sensible combination policy, it should be harmless.

Signed-off-by: James Morse <james.morse@arm.com>
---
I've checked the TRMs for Neoverse-N1, and Cortexs: A76, A77, A78 and X1.
They all have this 'stage2 wins' behaviour. The behaviour isn't documented
by A510 or A710's TRM.
---
 arch/arm64/include/asm/kvm_arm.h     | 1 +
 arch/arm64/include/asm/kvm_pgtable.h | 9 +++++++++
 arch/arm64/kernel/cpufeature.c       | 9 +++++++++
 arch/arm64/kvm/hyp/pgtable.c         | 9 +++++++++
 arch/arm64/tools/cpucaps             | 1 +
 5 files changed, 29 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 327120c0089f..bab7f0ad3724 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -126,6 +126,7 @@
 #define VTCR_EL2_VS_SHIFT	19
 #define VTCR_EL2_VS_8BIT	(0 << VTCR_EL2_VS_SHIFT)
 #define VTCR_EL2_VS_16BIT	(1 << VTCR_EL2_VS_SHIFT)
+#define VTCR_EL2_PBHA_MASK	GENMASK(28, 25)
 
 #define VTCR_EL2_T0SZ(x)	TCR_T0SZ(x)
 
diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 027783829584..678bff4bfd7f 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -125,6 +125,10 @@ enum kvm_pgtable_stage2_flags {
  * @KVM_PGTABLE_PROT_SW1:	Software bit 1.
  * @KVM_PGTABLE_PROT_SW2:	Software bit 2.
  * @KVM_PGTABLE_PROT_SW3:	Software bit 3.
+ * @KVM_PGTABLE_PROT_PBHA0:	Page-Based Hardware Attribute 0.
+ * @KVM_PGTABLE_PROT_PBHA1:	Page-Based Hardware Attribute 1.
+ * @KVM_PGTABLE_PROT_PBHA2:	Page-Based Hardware Attribute 2.
+ * @KVM_PGTABLE_PROT_PBHA3:	Page-Based Hardware Attribute 3.
  */
 enum kvm_pgtable_prot {
 	KVM_PGTABLE_PROT_X			= BIT(0),
@@ -137,6 +141,11 @@ enum kvm_pgtable_prot {
 	KVM_PGTABLE_PROT_SW1			= BIT(56),
 	KVM_PGTABLE_PROT_SW2			= BIT(57),
 	KVM_PGTABLE_PROT_SW3			= BIT(58),
+
+	KVM_PGTABLE_PROT_PBHA0			= BIT(59),
+	KVM_PGTABLE_PROT_PBHA1			= BIT(60),
+	KVM_PGTABLE_PROT_PBHA2			= BIT(61),
+	KVM_PGTABLE_PROT_PBHA3			= BIT(62),
 };
 
 #define KVM_PGTABLE_PROT_RW	(KVM_PGTABLE_PROT_R | KVM_PGTABLE_PROT_W)
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index f8a3067d10c6..8694f9dec5e5 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2328,6 +2328,15 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.matches = has_cpuid_feature,
 		.min_field_value = 1,
 	},
+	{
+		.capability = ARM64_HAS_PBHA,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.sys_reg = SYS_ID_AA64MMFR1_EL1,
+		.sign = FTR_UNSIGNED,
+		.field_pos = ID_AA64MMFR1_HPD_SHIFT,
+		.matches = has_cpuid_feature,
+		.min_field_value = 2,
+	},
 	{},
 };
 
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index f8ceebe4982e..7bd90ea1c61f 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -540,6 +540,15 @@ u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift)
 	 */
 	vtcr |= VTCR_EL2_HA;
 
+	/*
+	 * Enable PBHA for stage2 on systems that support it. The configured
+	 * value will always be 0, which is defined as the safe default
+	 * setting. On Cortex cores, enabling PBHA for stage2 effectively
+	 * disables it for stage1.
+	 */
+	if (cpus_have_final_cap(ARM64_HAS_PBHA))
+		vtcr = FIELD_PREP(VTCR_EL2_PBHA_MASK, 0xf);
+
 	/* Set the vmid bits */
 	vtcr |= (get_vmid_bits(mmfr1) == 16) ?
 		VTCR_EL2_VS_16BIT :
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 49305c2e6dfd..132596d8b518 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -28,6 +28,7 @@ HAS_LSE_ATOMICS
 HAS_NO_FPSIMD
 HAS_NO_HW_PREFETCH
 HAS_PAN
+HAS_PBHA
 HAS_RAS_EXTN
 HAS_RNG
 HAS_SB
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
