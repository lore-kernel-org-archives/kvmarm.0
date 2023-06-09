Received: from out-55.mta0.migadu.com (out-55.mta0.migadu.com [91.218.175.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 843D723403
	for <kvmarm@lists.linux.dev>; Fri,  9 Jun 2023 22:01:17 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1686348075;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QffNQ8PwW07AvO1bgOe/KOc535PWheP8HU3uyYnPhpQ=;
	b=QCEWPqxpWlsFB3NrL4mpoZHVgC6D+wwqoICtrJUiG1BcCI+g50MvCxiAmK+89mEwsTtchG
	sgg3nIwjaRA26wyiVnziLLNOmFWMS0GLfLkaFxrIeqjnH4mLXD6GXYgiqQHHfIwOrp41+W
	BPZgisVvHOM4dQ5D9A7dd9NIRiq8UAI=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	Darren Hart <darren@os.amperecomputing.com>,
	D Scott Phillips <scott@os.amperecomputing.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	stable@vger.kernel.org
Subject: [PATCH 1/3] arm64: errata: Mitigate Ampere1 erratum AC03_CPU_38 at stage-2
Date: Fri,  9 Jun 2023 22:01:02 +0000
Message-ID: <20230609220104.1836988-2-oliver.upton@linux.dev>
In-Reply-To: <20230609220104.1836988-1-oliver.upton@linux.dev>
References: <20230609220104.1836988-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

AmpereOne has an erratum in its implementation of FEAT_HAFDBS that
required disabling the feature on the design. This was done by reporting
the feature as not implemented in the ID register, although the
corresponding control bits were not actually RES0. This does not align
well with the requirements of the architecture, which mandates these
bits be RES0 if HAFDBS isn't implemented.

The kernel's use of stage-1 is unaffected, as the HA and HD bits are
only set if HAFDBS is detected in the ID register. KVM, on the other
hand, relies on the RES0 behavior at stage-2 to use the same value for
VTCR_EL2 on any cpu in the system. Mitigate the non-RES0 behavior by
leaving VTCR_EL2.HA clear on affected systems.

Cc: stable@vger.kernel.org
Cc: D Scott Phillips <scott@os.amperecomputing.com>
Cc: Darren Hart <darren@os.amperecomputing.com>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 Documentation/arm64/silicon-errata.rst |  3 +++
 arch/arm64/Kconfig                     | 17 +++++++++++++++++
 arch/arm64/kernel/cpu_errata.c         |  7 +++++++
 arch/arm64/kvm/hyp/pgtable.c           | 14 +++++++++++---
 arch/arm64/tools/cpucaps               |  1 +
 5 files changed, 39 insertions(+), 3 deletions(-)

diff --git a/Documentation/arm64/silicon-errata.rst b/Documentation/arm64/silicon-errata.rst
index 9e311bc43e05..cd46e2b20a81 100644
--- a/Documentation/arm64/silicon-errata.rst
+++ b/Documentation/arm64/silicon-errata.rst
@@ -52,6 +52,9 @@ stable kernels.
 | Allwinner      | A64/R18         | UNKNOWN1        | SUN50I_ERRATUM_UNKNOWN1     |
 +----------------+-----------------+-----------------+-----------------------------+
 +----------------+-----------------+-----------------+-----------------------------+
+| Ampere         | AmpereOne       | AC03_CPU_38     | AMPERE_ERRATUM_AC03_CPU_38  |
++----------------+-----------------+-----------------+-----------------------------+
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A510     | #2457168        | ARM64_ERRATUM_2457168       |
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A510     | #2064142        | ARM64_ERRATUM_2064142       |
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index b1201d25a8a4..f853af10142b 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -406,6 +406,23 @@ menu "Kernel Features"
 
 menu "ARM errata workarounds via the alternatives framework"
 
+config AMPERE_ERRATUM_AC03_CPU_38
+        bool "AmpereOne: AC03_CPU_38: Certain bits in the Virtualization Translation Control Register and Translation Control Registers do not follow RES0 semantics"
+	default y
+	help
+	  This option adds an alternative code sequence to work around Ampere
+	  erratum AC03_CPU_38 on AmpereOne.
+
+	  The affected design reports FEAT_HAFDBS as not implemented in
+	  ID_AA64MMFR1_EL1.HAFDBS, but (V)TCR_ELx.{HA,HD} are not RES0
+	  as required by the architecture.
+
+	  The workaround forces KVM to explicitly set VTCR_EL2.HA to 0,
+	  which avoids enabling unadvertised hardware Access Flag management
+	  at stage-2.
+
+	  If unsure, say Y.
+
 config ARM64_WORKAROUND_CLEAN_CACHE
 	bool
 
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 307faa2b4395..be66e94a21bd 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -729,6 +729,13 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		MIDR_FIXED(MIDR_CPU_VAR_REV(1,1), BIT(25)),
 		.cpu_enable = cpu_clear_bf16_from_user_emulation,
 	},
+#endif
+#ifdef CONFIG_AMPERE_ERRATUM_AC03_CPU_38
+	{
+		.desc = "AmpereOne erratum AC03_CPU_38",
+		.capability = ARM64_WORKAROUND_AMPERE_AC03_CPU_38,
+		ERRATA_MIDR_ALL_VERSIONS(MIDR_AMPERE1),
+	},
 #endif
 	{
 	}
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 3d61bd3e591d..9b5c8e6c08a0 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -609,10 +609,18 @@ u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift)
 #ifdef CONFIG_ARM64_HW_AFDBM
 	/*
 	 * Enable the Hardware Access Flag management, unconditionally
-	 * on all CPUs. The features is RES0 on CPUs without the support
-	 * and must be ignored by the CPUs.
+	 * on all CPUs. In systems that have asymmetric support for the feature
+	 * this allows KVM to leverage hardware support on the subset of cores
+	 * that implement the feature.
+	 *
+	 * The architecture requires VTCR_EL2.HA to be RES0 (thus ignored by
+	 * hardware) on implementations that do not advertise support for the
+	 * feature. As such, setting HA unconditionally is safe, unless you
+	 * happen to be running on a design that has unadvertised support for
+	 * HAFDBS. Here be dragons.
 	 */
-	vtcr |= VTCR_EL2_HA;
+	if (!cpus_have_final_cap(ARM64_WORKAROUND_AMPERE_AC03_CPU_38))
+		vtcr |= VTCR_EL2_HA;
 #endif /* CONFIG_ARM64_HW_AFDBM */
 
 	/* Set the vmid bits */
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 40ba95472594..9f9a2d6652eb 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -77,6 +77,7 @@ WORKAROUND_2077057
 WORKAROUND_2457168
 WORKAROUND_2645198
 WORKAROUND_2658417
+WORKAROUND_AMPERE_AC03_CPU_38
 WORKAROUND_TRBE_OVERWRITE_FILL_MODE
 WORKAROUND_TSB_FLUSH_FAILURE
 WORKAROUND_TRBE_WRITE_OUT_OF_RANGE
-- 
2.41.0.162.gfafddb0af9-goog

