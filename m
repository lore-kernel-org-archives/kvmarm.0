Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4A63C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 27 Jan 2022 12:21:21 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A02049F21;
	Thu, 27 Jan 2022 07:21:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id N1z0pz1YfScW; Thu, 27 Jan 2022 07:21:19 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B8F544A119;
	Thu, 27 Jan 2022 07:21:18 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C86E449F20
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Jan 2022 07:21:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id thBakDI3OjcE for <kvmarm@lists.cs.columbia.edu>;
 Thu, 27 Jan 2022 07:21:16 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 489F749F13
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Jan 2022 07:21:16 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B50FE11D4;
 Thu, 27 Jan 2022 04:21:15 -0800 (PST)
Received: from eglon.cambridge.arm.com (unknown [10.1.196.218])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9B6303F7D8;
 Thu, 27 Jan 2022 04:21:14 -0800 (PST)
From: James Morse <james.morse@arm.com>
To: kvmarm@lists.cs.columbia.edu,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 4/4] KVM: arm64: Workaround Cortex-A510's single-step and
 PAC trap errata
Date: Thu, 27 Jan 2022 12:20:52 +0000
Message-Id: <20220127122052.1584324-5-james.morse@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220127122052.1584324-1-james.morse@arm.com>
References: <20220127122052.1584324-1-james.morse@arm.com>
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
Changes since v1:
 * Moved the SPSR_EL2 fixup into a helper called earlier
 * Use final cap
 * Dropped the IS_ENABLED() check

 Documentation/arm64/silicon-errata.rst  |  2 ++
 arch/arm64/Kconfig                      | 16 ++++++++++++++++
 arch/arm64/kernel/cpu_errata.c          |  8 ++++++++
 arch/arm64/kvm/hyp/include/hyp/switch.h | 20 +++++++++++++++++++-
 arch/arm64/tools/cpucaps                |  1 +
 5 files changed, 46 insertions(+), 1 deletion(-)

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
index 331dd10821df..701cfb964905 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -402,6 +402,24 @@ static inline bool kvm_hyp_handle_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 	return false;
 }
 
+static inline void synchronize_vcpu_pstate(struct kvm_vcpu *vcpu, u64 *exit_code)
+{
+	/*
+	 * Check for the conditions of Cortex-A510's #2077057. When these occur
+	 * SPSR_EL2 can't be trusted, but isn't needed either as it is
+	 * unchanged from the value in vcpu_gp_regs(vcpu)->pstate.
+	 * Are we single-stepping the guest, and took a PAC exception from the
+	 * active-not-pending state?
+	 */
+	if (cpus_have_final_cap(ARM64_WORKAROUND_2077057)		&&
+	    vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP			&&
+	    *vcpu_cpsr(vcpu) & DBG_SPSR_SS				&&
+	    ESR_ELx_EC(read_sysreg_el2(SYS_ESR)) == ESR_ELx_EC_PAC)
+		write_sysreg_el2(*vcpu_cpsr(vcpu), SYS_SPSR);
+
+	vcpu->arch.ctxt.regs.pstate = read_sysreg_el2(SYS_SPSR);
+}
+
 /*
  * Return true when we were able to fixup the guest exit and should return to
  * the guest, false when we should restore the host state and return to the
@@ -413,7 +431,7 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 	 * Save PSTATE early so that we can evaluate the vcpu mode
 	 * early on.
 	 */
-	vcpu->arch.ctxt.regs.pstate = read_sysreg_el2(SYS_SPSR);
+	synchronize_vcpu_pstate(vcpu, exit_code);
 
 	/*
 	 * Check whether we want to repaint the state one way or
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
