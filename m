Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE52DC433F5
	for <kvmarm@archiver.kernel.org>; Tue, 25 Jan 2022 15:38:33 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9AE9149EE2;
	Tue, 25 Jan 2022 10:38:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UzE5XpuwDRoC; Tue, 25 Jan 2022 10:38:32 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F12049EC5;
	Tue, 25 Jan 2022 10:38:32 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 77CB549ECA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Jan 2022 10:38:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id knMrhhGAFoVm for <kvmarm@lists.cs.columbia.edu>;
 Tue, 25 Jan 2022 10:38:29 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A141A49ED1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Jan 2022 10:38:28 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 157CAD6E;
 Tue, 25 Jan 2022 07:38:28 -0800 (PST)
Received: from eglon.cambridge.arm.com (eglon.cambridge.arm.com [10.1.196.218])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id ECFC93F793;
 Tue, 25 Jan 2022 07:38:26 -0800 (PST)
From: James Morse <james.morse@arm.com>
To: kvmarm@lists.cs.columbia.edu,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH 4/4] KVM: arm64: Workaround Cortex-A510's single-step and PAC
 trap errata
Date: Tue, 25 Jan 2022 15:38:03 +0000
Message-Id: <20220125153803.549084-5-james.morse@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220125153803.549084-1-james.morse@arm.com>
References: <20220125153803.549084-1-james.morse@arm.com>
MIME-Version: 1.0
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 Marc Zyngier <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>
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

Cortex-A510's erratum #2077057 causes SPSR_EL2 to be corrupted when
single-stepping authenticated ERET instructions. A single step is
expected, but a pointer authentication trap is taken instead. The
erratum causes SPSR_EL1 to be copied to SPSR_EL2, which could allow
EL1 to cause a return to EL2 with a guest controlled ELR_EL2.

Because the conditions require an ERET into active-not-pending state,
this is only a problem for the EL2 when EL2 is stepping EL1. In this case
the previous SPSR_EL2 value is preserved in struct kvm_vcpu, and can be
restored.

Cc: stable@vger.kernel.org # ${GITHASHHERE}: arm64: Add Cortex-A510 CPU part definition
Cc: stable@vger.kernel.org
Signed-off-by: James Morse <james.morse@arm.com>
---
 Documentation/arm64/silicon-errata.rst  |  2 ++
 arch/arm64/Kconfig                      | 16 ++++++++++++++++
 arch/arm64/kernel/cpu_errata.c          |  8 ++++++++
 arch/arm64/kvm/hyp/include/hyp/switch.h | 24 +++++++++++++++++++++---
 arch/arm64/tools/cpucaps                |  1 +
 5 files changed, 48 insertions(+), 3 deletions(-)

diff --git a/Documentation/arm64/silicon-errata.rst b/Documentation/arm64/silicon-errata.rst
index 5342e895fb60..ac1ae34564c9 100644
--- a/Documentation/arm64/silicon-errata.rst
+++ b/Documentation/arm64/silicon-errata.rst
@@ -92,6 +92,8 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A77      | #1508412        | ARM64_ERRATUM_1508412       |
 +----------------+-----------------+-----------------+-----------------------------+
+| ARM            | Cortex-A510     | #2077057        | ARM64_ERRATUM_2077057       |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A710     | #2119858        | ARM64_ERRATUM_2119858       |
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A710     | #2054223        | ARM64_ERRATUM_2054223       |
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 6978140edfa4..02b542ec18c8 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -670,6 +670,22 @@ config ARM64_ERRATUM_1508412
 config ARM64_WORKAROUND_TRBE_OVERWRITE_FILL_MODE
 	bool
 
+config ARM64_ERRATUM_2077057
+	bool "Cortex-A510: 2077057: workaround software-step corrupting SPSR_EL2"
+	help
+	  This option adds the workaround for ARM Cortex-A510 erratum 2077057.
+	  Affected Cortex-A510 may corrupt SPSR_EL2 when the a step exception is
+	  expected, but a Pointer Authentication trap is taken instead. The
+	  erratum causes SPSR_EL1 to be copied to SPSR_EL2, which could allow
+	  EL1 to cause a return to EL2 with a guest controlled ELR_EL2.
+
+	  This can only happen when EL2 is stepping EL1.
+
+	  When these conditions occur, the SPSR_EL2 value is unchanged from the
+	  previous guest entry, and can be restored from the in-memory copy.
+
+	  If unsure, say Y.
+
 config ARM64_ERRATUM_2119858
 	bool "Cortex-A710: 2119858: workaround TRBE overwriting trace data in FILL mode"
 	default y
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 9e1c1aef9ebd..04a014c63251 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -597,6 +597,14 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		.type = ARM64_CPUCAP_WEAK_LOCAL_CPU_FEATURE,
 		CAP_MIDR_RANGE_LIST(trbe_write_out_of_range_cpus),
 	},
+#endif
+#ifdef CONFIG_ARM64_ERRATUM_2077057
+	{
+		.desc = "ARM erratum 2077057",
+		.capability = ARM64_WORKAROUND_2077057,
+		.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
+		ERRATA_MIDR_REV_RANGE(MIDR_CORTEX_A510, 0, 0, 2),
+	},
 #endif
 	{
 	}
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 331dd10821df..93bf140cc972 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -409,6 +409,8 @@ static inline bool kvm_hyp_handle_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
  */
 static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
+	u8 esr_ec;
+
 	/*
 	 * Save PSTATE early so that we can evaluate the vcpu mode
 	 * early on.
@@ -421,13 +423,13 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 	 */
 	early_exit_filter(vcpu, exit_code);
 
-	if (ARM_EXCEPTION_CODE(*exit_code) != ARM_EXCEPTION_IRQ)
+	if (ARM_EXCEPTION_CODE(*exit_code) != ARM_EXCEPTION_IRQ) {
 		vcpu->arch.fault.esr_el2 = read_sysreg_el2(SYS_ESR);
+		esr_ec = kvm_vcpu_trap_get_class(vcpu);
+	}
 
 	if (ARM_SERROR_PENDING(*exit_code) &&
 	    ARM_EXCEPTION_CODE(*exit_code) != ARM_EXCEPTION_IRQ) {
-		u8 esr_ec = kvm_vcpu_trap_get_class(vcpu);
-
 		/*
 		 * HVC already have an adjusted PC, which we need to
 		 * correct in order to return to after having injected
@@ -440,6 +442,22 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 			write_sysreg_el2(read_sysreg_el2(SYS_ELR) - 4, SYS_ELR);
 	}
 
+	/*
+	 * Check for the conditions of Cortex-A510's #2077057. When these occur
+	 * SPSR_EL2 can't be trusted, but isn't needed either as it is
+	 * unchanged from the value in vcpu_gp_regs(vcpu)->pstate.
+	 * Did we just take a PAC exception when a step exception was expected?
+	 */
+	if (IS_ENABLED(CONFIG_ARM64_ERRATUM_2077057) &&
+	    cpus_have_const_cap(ARM64_WORKAROUND_2077057) &&
+	    ARM_EXCEPTION_CODE(*exit_code) != ARM_EXCEPTION_IRQ &&
+	    esr_ec == ESR_ELx_EC_PAC &&
+	    vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP) {
+		/* Active-not-pending? */
+		if (*vcpu_cpsr(vcpu) & DBG_SPSR_SS)
+			write_sysreg_el2(*vcpu_cpsr(vcpu), SYS_SPSR);
+	}
+
 	/*
 	 * We're using the raw exception code in order to only process
 	 * the trap if no SError is pending. We will come back to the
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 870c39537dd0..2e7cd3fecca6 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -55,6 +55,7 @@ WORKAROUND_1418040
 WORKAROUND_1463225
 WORKAROUND_1508412
 WORKAROUND_1542419
+WORKAROUND_2077057
 WORKAROUND_TRBE_OVERWRITE_FILL_MODE
 WORKAROUND_TSB_FLUSH_FAILURE
 WORKAROUND_TRBE_WRITE_OUT_OF_RANGE
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
