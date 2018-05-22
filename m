From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 04/14] arm64: Add ARCH_WORKAROUND_2 probing
Date: Tue, 22 May 2018 16:06:38 +0100
Message-ID: <20180522150648.28297-5-marc.zyngier@arm.com>
References: <20180522150648.28297-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FC534A119
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 May 2018 10:57:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vVh4Sm4VDYGE for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 May 2018 10:56:53 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 99D644A100
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 May 2018 10:56:46 -0400 (EDT)
In-Reply-To: <20180522150648.28297-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Kees Cook <keescook@chromium.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>
List-Id: kvmarm@lists.cs.columbia.edu

As for Spectre variant-2, we rely on SMCCC 1.1 to provide the
discovery mechanism for detecting the SSBD mitigation.

A new capability is also allocated for that purpose, and a
config option.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/Kconfig               |  9 ++++++
 arch/arm64/include/asm/cpucaps.h |  3 +-
 arch/arm64/kernel/cpu_errata.c   | 69 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 80 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index eb2cf4938f6d..b2103b4df467 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -938,6 +938,15 @@ config HARDEN_EL2_VECTORS
 
 	  If unsure, say Y.
 
+config ARM64_SSBD
+	bool "Speculative Store Bypass Disable" if EXPERT
+	default y
+	help
+	  This enables mitigation of the bypassing of previous stores
+	  by speculative loads.
+
+	  If unsure, say Y.
+
 menuconfig ARMV8_DEPRECATED
 	bool "Emulate deprecated/obsolete ARMv8 instructions"
 	depends on COMPAT
diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index bc51b72fafd4..5b2facf786ba 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -48,7 +48,8 @@
 #define ARM64_HAS_CACHE_IDC			27
 #define ARM64_HAS_CACHE_DIC			28
 #define ARM64_HW_DBM				29
+#define ARM64_SSBD			30
 
-#define ARM64_NCAPS				30
+#define ARM64_NCAPS				31
 
 #endif /* __ASM_CPUCAPS_H */
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 0288d6cf560e..7fd6d5b001f5 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -250,6 +250,67 @@ void __init arm64_update_smccc_conduit(struct alt_instr *alt,
 
 	*updptr = cpu_to_le32(insn);
 }
+
+static void do_ssbd(bool state)
+{
+	switch (psci_ops.conduit) {
+	case PSCI_CONDUIT_HVC:
+		arm_smccc_1_1_hvc(ARM_SMCCC_ARCH_WORKAROUND_2, state, NULL);
+		break;
+
+	case PSCI_CONDUIT_SMC:
+		arm_smccc_1_1_smc(ARM_SMCCC_ARCH_WORKAROUND_2, state, NULL);
+		break;
+
+	default:
+		WARN_ON_ONCE(1);
+		break;
+	}
+}
+
+static bool has_ssbd_mitigation(const struct arm64_cpu_capabilities *entry,
+				    int scope)
+{
+	struct arm_smccc_res res;
+	bool supported = true;
+
+	WARN_ON(scope != SCOPE_LOCAL_CPU || preemptible());
+
+	if (psci_ops.smccc_version == SMCCC_VERSION_1_0)
+		return false;
+
+	/*
+	 * The probe function return value is either negative
+	 * (unsupported or mitigated), positive (unaffected), or zero
+	 * (requires mitigation). We only need to do anything in the
+	 * last case.
+	 */
+	switch (psci_ops.conduit) {
+	case PSCI_CONDUIT_HVC:
+		arm_smccc_1_1_hvc(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
+				  ARM_SMCCC_ARCH_WORKAROUND_2, &res);
+		if ((int)res.a0 != 0)
+			supported = false;
+		break;
+
+	case PSCI_CONDUIT_SMC:
+		arm_smccc_1_1_smc(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
+				  ARM_SMCCC_ARCH_WORKAROUND_2, &res);
+		if ((int)res.a0 != 0)
+			supported = false;
+		break;
+
+	default:
+		supported = false;
+	}
+
+	if (supported) {
+		__this_cpu_write(arm64_ssbd_callback_required, 1);
+		do_ssbd(true);
+	}
+
+	return supported;
+}
 #endif	/* CONFIG_ARM64_SSBD */
 
 #define CAP_MIDR_RANGE(model, v_min, r_min, v_max, r_max)	\
@@ -506,6 +567,14 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
 		ERRATA_MIDR_RANGE_LIST(arm64_harden_el2_vectors),
 	},
+#endif
+#ifdef CONFIG_ARM64_SSBD
+	{
+		.desc = "Speculative Store Bypass Disable",
+		.capability = ARM64_SSBD,
+		.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
+		.matches = has_ssbd_mitigation,
+	},
 #endif
 	{
 	}
-- 
2.14.2
