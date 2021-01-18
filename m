Return-Path: <SRS0=ax30=GV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAC23C433DB
	for <kvmarm@archiver.kernel.org>; Mon, 18 Jan 2021 17:31:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3691A22CA0
	for <kvmarm@archiver.kernel.org>; Mon, 18 Jan 2021 17:31:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3691A22CA0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A9C04B28E;
	Mon, 18 Jan 2021 12:31:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hWMGVZ0B3UM7; Mon, 18 Jan 2021 12:31:04 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A63E4B2B3;
	Mon, 18 Jan 2021 12:31:04 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E5F834B2A7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jan 2021 12:31:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gJZ4V3Z3yPjj for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jan 2021 12:31:01 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A799D4B28E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jan 2021 12:31:01 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3048A31B;
 Mon, 18 Jan 2021 09:31:01 -0800 (PST)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.195.35])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D343E3F719;
 Mon, 18 Jan 2021 09:30:59 -0800 (PST)
From: Andre Przywara <andre.przywara@arm.com>
To: Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>
Subject: [RFC PATCH] KVM: arm64: Avoid unconditional PMU register access
Date: Mon, 18 Jan 2021 17:30:54 +0000
Message-Id: <20210118173054.188160-1-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

The ARM PMU is an optional CPU feature, so we should consult the CPUID
registers before accessing any PMU related registers.
However the KVM code accesses some PMU registers (PMUSERENR_EL0 and
PMSEL_EL0) unconditionally, when activating the traps.
This wasn't a problem so far, because every(?) silicon implements the
PMU, with KVM guests being the lone exception, and those never ran
KVM host code.

As this is about to change with nested virt, we need to guard PMU
register accesses with a proper CPU feature check.

Add a new CPU capability, which marks whether we have at least the basic
PMUv3 registers available. Use that in the KVM VHE code to check before
accessing the PMU registers.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
Hi,

not sure a new CPU capability isn't a bit over the top here, and we should
use a simple static key instead?

Cheers,
Andre

 arch/arm64/include/asm/cpucaps.h        |  3 ++-
 arch/arm64/kernel/cpufeature.c          | 10 ++++++++++
 arch/arm64/kvm/hyp/include/hyp/switch.h |  9 ++++++---
 3 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index b77d997b173b..e3a002583c43 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -66,7 +66,8 @@
 #define ARM64_WORKAROUND_1508412		58
 #define ARM64_HAS_LDAPR				59
 #define ARM64_KVM_PROTECTED_MODE		60
+#define ARM64_HAS_PMUV3				61
 
-#define ARM64_NCAPS				61
+#define ARM64_NCAPS				62
 
 #endif /* __ASM_CPUCAPS_H */
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index e99eddec0a46..54d23d38322d 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2154,6 +2154,16 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.matches = has_cpuid_feature,
 		.min_field_value = 1,
 	},
+	{
+		.desc = "ARM PMUv3 support",
+		.capability = ARM64_HAS_PMUV3,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.sys_reg = SYS_ID_AA64DFR0_EL1,
+		.sign = FTR_SIGNED,
+		.field_pos = ID_AA64DFR0_PMUVER_SHIFT,
+		.matches = has_cpuid_feature,
+		.min_field_value = 1,
+	},
 	{},
 };
 
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 84473574c2e7..622baf7b7371 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -90,15 +90,18 @@ static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
 	 * counter, which could make a PMXEVCNTR_EL0 access UNDEF at
 	 * EL1 instead of being trapped to EL2.
 	 */
-	write_sysreg(0, pmselr_el0);
-	write_sysreg(ARMV8_PMU_USERENR_MASK, pmuserenr_el0);
+	if (cpus_have_final_cap(ARM64_HAS_PMUV3)) {
+		write_sysreg(0, pmselr_el0);
+		write_sysreg(ARMV8_PMU_USERENR_MASK, pmuserenr_el0);
+	}
 	write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
 }
 
 static inline void __deactivate_traps_common(void)
 {
 	write_sysreg(0, hstr_el2);
-	write_sysreg(0, pmuserenr_el0);
+	if (cpus_have_final_cap(ARM64_HAS_PMUV3))
+		write_sysreg(0, pmuserenr_el0);
 }
 
 static inline void ___activate_traps(struct kvm_vcpu *vcpu)
-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
