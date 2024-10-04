Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BD5C146D65
	for <kvmarm@lists.linux.dev>; Fri,  4 Oct 2024 11:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728040051; cv=none; b=KjVQfCZfRXcrCyJxj3lrBRCKKYUI7NmBFytMB0fESMaCmmzX0FoAehaxB6gHC8CmuStkmjgkx2O9u6QW1UdbZCHna8GxM51+NDNPKIWuBPa8HKIGyjdDDGk5syuXlv9+b40FjWc7YeAUeRQgbh9SE9V1EMCDPFE731huK1iP0fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728040051; c=relaxed/simple;
	bh=lvAFRrAvV61DK02zhIfZSuqbpLDFLfg5FHthRssraJM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=I4v555OYgg5Il4P4TgZd6cHVksVKSsFNQUFILew73W4wVjwsxZQLmhcsANWUSEvuLPx8tf0rX+FFmzgH1v8V4Gok0sDGdzmccTDzYuo/caIyIS4qZPOBfknUz2IwTUGuHhqQ/qh0H7eeniMABPDfGwdpgNPKntjjyreMP2Y0HG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B7290497;
	Fri,  4 Oct 2024 04:07:53 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 95D263F640;
	Fri,  4 Oct 2024 04:07:22 -0700 (PDT)
From: Joey Gouly <joey.gouly@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: anshuman.khandual@arm.com,
	james.morse@arm.com,
	joey.gouly@arm.com,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jing Zhang <jingzhangos@google.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH v4 1/7] arm64: head.S: Initialise MPAM EL2 registers and disable traps
Date: Fri,  4 Oct 2024 12:07:08 +0100
Message-Id: <20241004110714.2051604-2-joey.gouly@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241004110714.2051604-1-joey.gouly@arm.com>
References: <20241004110714.2051604-1-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: James Morse <james.morse@arm.com>

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
Signed-off-by: Joey Gouly <joey.gouly@arm.com>
---
 arch/arm64/include/asm/el2_setup.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
index e0ffdf13a18b..2a84a3d05834 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -220,6 +220,21 @@
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
@@ -237,6 +252,7 @@
 	__init_el2_stage2
 	__init_el2_gicv3
 	__init_el2_hstr
+	__init_el2_mpam
 	__init_el2_nvhe_idregs
 	__init_el2_cptr
 	__init_el2_fgt
-- 
2.25.1

