Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19D781B219D
	for <kvmarm@lists.linux.dev>; Tue, 15 Oct 2024 13:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728999577; cv=none; b=YVr8iNo28FUWILiKtMYsMuv0hLeYCdE3TpVDblwEqNy6u7s4+mXQfenZ08v16mYvMJxZk8G/AA2GdIv7pMw5xoSHbPesxFc8dJPZUqrE/KXAQAsrfp9jWt4T6PgmxDWdaa4tNMKpPcwXgWar/SnNzE3cSobazTpF8g964zf4Hh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728999577; c=relaxed/simple;
	bh=Tj0o699vtgAFkMo8ZtqNSSnb1bT/SfThdIj2i3X9RjE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LSp2O9agxwJiHYqOwVXrLI+mq7YUKsL8bv5HTRE3P2ynC2sk1YI8r1dXOG//ZwzIvpG+fjkKiUDxl6zGAPZyI6feH7nmhlsLBH+Ct5zEQwgCsssbQHGjUH7vYYmoqvsfZlZqiVycE+d+K/JJYu/GDC1n5wCTRryKjDw2z3FyyYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 208471063;
	Tue, 15 Oct 2024 06:40:05 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9996D3F51B;
	Tue, 15 Oct 2024 06:39:33 -0700 (PDT)
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
Subject: [PATCH v5 2/7] arm64: head.S: Initialise MPAM EL2 registers and disable traps
Date: Tue, 15 Oct 2024 14:39:18 +0100
Message-Id: <20241015133923.3910916-3-joey.gouly@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241015133923.3910916-1-joey.gouly@arm.com>
References: <20241015133923.3910916-1-joey.gouly@arm.com>
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
index e0ffdf13a18b..1d7f377c61db 100644
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
+	tbz	x0, #MPAMIDR_EL1_HAS_HCR_SHIFT, .Lskip_mpam_\@	// skip if no MPAMHCR reg
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

