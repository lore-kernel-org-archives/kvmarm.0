Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E05E74437C
	for <kvmarm@lists.linux.dev>; Thu,  7 Dec 2023 15:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 12D851570;
	Thu,  7 Dec 2023 07:09:08 -0800 (PST)
Received: from eglon.cambridge.arm.com (eglon.cambridge.arm.com [10.1.197.60])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 26F1E3F762;
	Thu,  7 Dec 2023 07:08:21 -0800 (PST)
From: James Morse <james.morse@arm.com>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	James Morse <james.morse@arm.com>
Subject: [PATCH v2 1/4] arm64: head.S: Initialise MPAM EL2 registers and disable traps
Date: Thu,  7 Dec 2023 15:08:01 +0000
Message-Id: <20231207150804.3425468-2-james.morse@arm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231207150804.3425468-1-james.morse@arm.com>
References: <20231207150804.3425468-1-james.morse@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add code to head.S's el2_setup to detect MPAM and disable any EL2 traps.
This register resets to an unknown value, setting it to the default
parititons/pmg before we enable the MMU is the best thing to do.

Kexec/kdump will depend on this if the previous kernel left the CPU
configured with a restrictive configuration.

If linux is booted at the highest implemented exception level el2_setup
will clear the enable bit, disabling MPAM.

This code can't be enabled until a subsequent patch adds the Kconfig
and cpufeature boiler plate.

Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/arm64/include/asm/el2_setup.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
index b7afaa026842..fb4ea2a94e10 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -208,6 +208,21 @@
 	msr	spsr_el2, x0
 .endm
 
+.macro __init_el2_mpam
+#ifdef CONFIG_ARM64_MPAM
+	/* Memory Partitioning And Monitoring: disable EL2 traps */
+	mrs	x1, id_aa64pfr0_el1
+	ubfx	x0, x1, #ID_AA64PFR0_EL1_MPAM_SHIFT, #4
+	cbz	x0, .Lskip_mpam_\@		// skip if no MPAM
+	msr_s	SYS_MPAM2_EL2, xzr		// use the default partition
+						// and disable lower traps
+	mrs_s	x0, SYS_MPAMIDR_EL1
+	tbz	x0, #17, .Lskip_mpam_\@		// skip if no MPAMHCR reg
+	msr_s	SYS_MPAMHCR_EL2, xzr		// clear TRAP_MPAMIDR_EL1 -> EL2
+.Lskip_mpam_\@:
+#endif /* CONFIG_ARM64_MPAM */
+.endm
+
 /**
  * Initialize EL2 registers to sane values. This should be called early on all
  * cores that were booted in EL2. Note that everything gets initialised as
@@ -225,6 +240,7 @@
 	__init_el2_stage2
 	__init_el2_gicv3
 	__init_el2_hstr
+	__init_el2_mpam
 	__init_el2_nvhe_idregs
 	__init_el2_cptr
 	__init_el2_fgt
-- 
2.39.2

