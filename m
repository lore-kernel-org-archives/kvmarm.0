Return-Path: <SRS0=TDzU=6W=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9FDDC35280
	for <kvmarm@archiver.kernel.org>; Fri,  8 May 2020 02:53:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 75B1B20731
	for <kvmarm@archiver.kernel.org>; Fri,  8 May 2020 02:53:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 75B1B20731
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CFD8C4B3D9;
	Thu,  7 May 2020 22:53:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DmOY9RXBTSuE; Thu,  7 May 2020 22:53:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B8FA4B403;
	Thu,  7 May 2020 22:53:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C7A3A4B11B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 May 2020 22:53:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wU0Okq-P6whm for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 May 2020 22:53:22 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 497204B509
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 May 2020 22:53:22 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C2A2E1FB;
 Thu,  7 May 2020 19:53:21 -0700 (PDT)
Received: from p8cg001049571a15.arm.com (unknown [10.163.73.155])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id D3C233F305;
 Thu,  7 May 2020 19:53:18 -0700 (PDT)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org
Subject: [PATCH V2] arm64/cpufeature: Validate hypervisor capabilities during
 CPU hotplug
Date: Fri,  8 May 2020 08:22:38 +0530
Message-Id: <1588906358-7845-1-git-send-email-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.7.4
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

This validates hypervisor capabilities like VMID width, IPA range for any
hot plug CPU against system finalized values. While here, it factors out
get_vmid_bits() for general use and also defines ID_AA64MMFR0_PARANGE_MASK.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: kvmarm@lists.cs.columbia.edu
Cc: linux-kernel@vger.kernel.org

Suggested-by: Suzuki Poulose <suzuki.poulose@arm.com>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
Changes in V2:

- Added is_hyp_mode_available() check per Marc
- Moved verify_kvm_capabilities() into cpufeature.c per Marc
- Added helper get_kvm_ipa_limit() to fetch kvm_ipa_limit per Marc
- Renamed kvm as hyp including the commit message per Marc

Changes in V1: (https://patchwork.kernel.org/patch/11532565/)

 arch/arm64/include/asm/cpufeature.h | 20 +++++++++++++++++
 arch/arm64/include/asm/kvm_mmu.h    |  2 +-
 arch/arm64/include/asm/sysreg.h     |  1 +
 arch/arm64/kernel/cpufeature.c      | 33 +++++++++++++++++++++++++++++
 arch/arm64/kvm/reset.c              | 11 ++++++++--
 5 files changed, 64 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index afe08251ff95..fbbb4d2216f0 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -745,6 +745,26 @@ static inline bool cpu_has_hw_af(void)
 extern bool cpu_has_amu_feat(int cpu);
 #endif
 
+static inline unsigned int get_vmid_bits(u64 mmfr1)
+{
+	int vmid_bits;
+
+	vmid_bits = cpuid_feature_extract_unsigned_field(mmfr1,
+						ID_AA64MMFR1_VMIDBITS_SHIFT);
+	if (vmid_bits == ID_AA64MMFR1_VMIDBITS_16)
+		return 16;
+
+	/*
+	 * Return the default here even if any reserved
+	 * value is fetched from the system register.
+	 */
+	return 8;
+}
+
+#ifdef CONFIG_KVM_ARM_HOST
+u32 get_kvm_ipa_limit(void);
+#endif
+
 #endif /* __ASSEMBLY__ */
 
 #endif
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 30b0e8d6b895..a7137e144b97 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -416,7 +416,7 @@ static inline unsigned int kvm_get_vmid_bits(void)
 {
 	int reg = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
 
-	return (cpuid_feature_extract_unsigned_field(reg, ID_AA64MMFR1_VMIDBITS_SHIFT) == 2) ? 16 : 8;
+	return get_vmid_bits(reg);
 }
 
 /*
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index c4ac0ac25a00..3510a4668970 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -705,6 +705,7 @@
 #define ID_AA64MMFR0_TGRAN16_SUPPORTED	0x1
 #define ID_AA64MMFR0_PARANGE_48		0x5
 #define ID_AA64MMFR0_PARANGE_52		0x6
+#define ID_AA64MMFR0_PARANGE_MASK	0x7
 
 #ifdef CONFIG_ARM64_PA_BITS_52
 #define ID_AA64MMFR0_PARANGE_MAX	ID_AA64MMFR0_PARANGE_52
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 9fac745aa7bb..7e5ff452574c 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2181,6 +2181,36 @@ static void verify_sve_features(void)
 	/* Add checks on other ZCR bits here if necessary */
 }
 
+#ifdef CONFIG_KVM_ARM_HOST
+void verify_hyp_capabilities(void)
+{
+	u64 safe_mmfr1, mmfr0, mmfr1;
+	int parange, ipa_max;
+	unsigned int safe_vmid_bits, vmid_bits;
+
+	safe_mmfr1 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
+	mmfr0 = read_cpuid(ID_AA64MMFR0_EL1);
+	mmfr1 = read_cpuid(ID_AA64MMFR1_EL1);
+
+	/* Verify VMID bits */
+	safe_vmid_bits = get_vmid_bits(safe_mmfr1);
+	vmid_bits = get_vmid_bits(mmfr1);
+	if (vmid_bits < safe_vmid_bits) {
+		pr_crit("CPU%d: VMID width mismatch\n", smp_processor_id());
+		cpu_die_early();
+	}
+
+	/* Verify IPA range */
+	parange = mmfr0 & ID_AA64MMFR0_PARANGE_MASK;
+	ipa_max = id_aa64mmfr0_parange_to_phys_shift(parange);
+	if (ipa_max < get_kvm_ipa_limit()) {
+		pr_crit("CPU%d: IPA range mismatch\n", smp_processor_id());
+		cpu_die_early();
+	}
+}
+#else	/* !CONFIG_KVM_ARM_HOST */
+static inline void verify_hyp_capabilities(void) { }
+#endif	/* CONFIG_KVM_ARM_HOST */
 
 /*
  * Run through the enabled system capabilities and enable() it on this CPU.
@@ -2206,6 +2236,9 @@ static void verify_local_cpu_capabilities(void)
 
 	if (system_supports_sve())
 		verify_sve_features();
+
+	if (is_hyp_mode_available())
+		verify_hyp_capabilities();
 }
 
 void check_local_cpu_capabilities(void)
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 30b7ea680f66..1131b112dda2 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -340,11 +340,17 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 	return ret;
 }
 
+u32 get_kvm_ipa_limit(void)
+{
+	return kvm_ipa_limit;
+}
+
 void kvm_set_ipa_limit(void)
 {
 	unsigned int ipa_max, pa_max, va_max, parange;
 
-	parange = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1) & 0x7;
+	parange = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1) &
+						ID_AA64MMFR0_PARANGE_MASK;
 	pa_max = id_aa64mmfr0_parange_to_phys_shift(parange);
 
 	/* Clamp the IPA limit to the PA size supported by the kernel */
@@ -406,7 +412,8 @@ int kvm_arm_setup_stage2(struct kvm *kvm, unsigned long type)
 		phys_shift = KVM_PHYS_SHIFT;
 	}
 
-	parange = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1) & 7;
+	parange = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1) &
+						ID_AA64MMFR0_PARANGE_MASK;
 	if (parange > ID_AA64MMFR0_PARANGE_MAX)
 		parange = ID_AA64MMFR0_PARANGE_MAX;
 	vtcr |= parange << VTCR_EL2_PS_SHIFT;
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
