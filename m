Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0251053801
	for <kvmarm@lists.linux.dev>; Wed, 14 Feb 2024 13:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707916718; cv=none; b=gSTYDKyXPpRUdpFPYicaPMIxhYsL5YZMj+fKl0RWf4VxZlxoUdmrA6cMxTuKbDANCQBCCmydl81QS5fUoX2WeeZbTYO4RWs60aSbyYg1gybzh4lqu2W9HYzuzGVjJFx68cU9ooTk8fnNZ/5gwaNDZpEJpuegVQqgQKsZwA8qyg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707916718; c=relaxed/simple;
	bh=J3X8lZZSFMa0PvIa+xM8oJKc1hcPpunPUAIrZnCuPO8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XhLtGBV07wLd7Kscan1JlZGbz3OnYmDktkaWdb0T5B3PgoUzDIoGMTewiPPX0cM4G7JyIP6TNdCrpCCgO7oq7K6e4g9YsB7Tf5uiDdoP00yp5h2Yya5KmBGWZ23ty2JmI3LKTn4Vxq07r6c6zwxnoRhXOJKIWW4/1x5afhfC6l0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ec/wUggv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ec/wUggv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2896C43601;
	Wed, 14 Feb 2024 13:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707916717;
	bh=J3X8lZZSFMa0PvIa+xM8oJKc1hcPpunPUAIrZnCuPO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ec/wUggvvusrhVx/rrg+5qdppO6WNWrieAn7s4JfLzI4mZzAxzXGyVXqDIGeOgRBV
	 MPhHUcwW+zj8JlDr7o7zUs8jPH/+A+3QPWD7i8qwUNdZ+vLxJUW2HtxyRS5xyJ5595
	 Z/3IYc+zvFXaFFWzFGClTPyRKhXE6aTGsgyv/5COuLgJnG8xdZee17yL2vBU3nwHq+
	 tw7PrlywSbNlmyzZgJskthGLoLQGpBaoIRkJ4c1Lg6sBE5IlZd0u2c58KGJ+yINplk
	 Ey84V0uWILyBv1gZ7NADN4fzJAOhfa39l1V2UuFjf+1M+oMFfhYa/pl7LiIMh9AQI3
	 GC1Y3A+Z3NW8w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1raF9n-00394l-Sl;
	Wed, 14 Feb 2024 13:18:35 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v4 25/26] KVM: arm64: Snapshot all non-zero RES0/RES1 sysreg fields for later checking
Date: Wed, 14 Feb 2024 13:18:26 +0000
Message-Id: <20240214131827.2856277-26-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240214131827.2856277-1-maz@kernel.org>
References: <20240214131827.2856277-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, joey.gouly@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

As KVM now strongly relies on accurately handling the RES0/RES1 bits
on a number of paths, add a compile-time checker that will blow in
the face of the innocent bystander, should they try to sneak in an
update that changes any of these RES0/RES1 fields.

It is expected that such an update will come with the relevant
KVM update if needed.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/check-res-bits.h | 121 ++++++++++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c       |   3 +
 2 files changed, 124 insertions(+)
 create mode 100644 arch/arm64/kvm/check-res-bits.h

diff --git a/arch/arm64/kvm/check-res-bits.h b/arch/arm64/kvm/check-res-bits.h
new file mode 100644
index 000000000000..967b5d171d53
--- /dev/null
+++ b/arch/arm64/kvm/check-res-bits.h
@@ -0,0 +1,121 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2024 - Google LLC
+ * Author: Marc Zyngier <maz@kernel.org>
+ */
+
+#include <asm/sysreg-defs.h>
+
+/*
+ * WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING
+ *
+ * If any of these BUILD_BUG_ON() fails, that's because some bits that
+ * were reserved have gained some other meaning, and KVM needs to know
+ * about those.
+ *
+ * In such case, do *NOT* blindly change the assertion so that it
+ * passes, but also teach the rest of the code about the actual
+ * change.
+ *
+ * WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING
+ */
+static inline void check_res_bits(void)
+{
+	BUILD_BUG_ON(OSDTRRX_EL1_RES0		!= (GENMASK_ULL(63, 32)));
+	BUILD_BUG_ON(MDCCINT_EL1_RES0		!= (GENMASK_ULL(63, 31) | GENMASK_ULL(28, 0)));
+	BUILD_BUG_ON(MDSCR_EL1_RES0		!= (GENMASK_ULL(63, 36) | GENMASK_ULL(28, 28) | GENMASK_ULL(25, 24) | GENMASK_ULL(20, 20) | GENMASK_ULL(18, 16) | GENMASK_ULL(11, 7) | GENMASK_ULL(5, 1)));
+	BUILD_BUG_ON(OSDTRTX_EL1_RES0		!= (GENMASK_ULL(63, 32)));
+	BUILD_BUG_ON(OSECCR_EL1_RES0		!= (GENMASK_ULL(63, 32)));
+	BUILD_BUG_ON(OSLAR_EL1_RES0		!= (GENMASK_ULL(63, 1)));
+	BUILD_BUG_ON(ID_PFR0_EL1_RES0		!= (GENMASK_ULL(63, 32)));
+	BUILD_BUG_ON(ID_PFR1_EL1_RES0		!= (GENMASK_ULL(63, 32)));
+	BUILD_BUG_ON(ID_DFR0_EL1_RES0		!= (GENMASK_ULL(63, 32)));
+	BUILD_BUG_ON(ID_AFR0_EL1_RES0		!= (GENMASK_ULL(63, 16)));
+	BUILD_BUG_ON(ID_MMFR0_EL1_RES0		!= (GENMASK_ULL(63, 32)));
+	BUILD_BUG_ON(ID_MMFR1_EL1_RES0		!= (GENMASK_ULL(63, 32)));
+	BUILD_BUG_ON(ID_MMFR2_EL1_RES0		!= (GENMASK_ULL(63, 32)));
+	BUILD_BUG_ON(ID_MMFR3_EL1_RES0		!= (GENMASK_ULL(63, 32)));
+	BUILD_BUG_ON(ID_ISAR0_EL1_RES0		!= (GENMASK_ULL(63, 28)));
+	BUILD_BUG_ON(ID_ISAR1_EL1_RES0		!= (GENMASK_ULL(63, 32)));
+	BUILD_BUG_ON(ID_ISAR2_EL1_RES0		!= (GENMASK_ULL(63, 32)));
+	BUILD_BUG_ON(ID_ISAR3_EL1_RES0		!= (GENMASK_ULL(63, 32)));
+	BUILD_BUG_ON(ID_ISAR4_EL1_RES0		!= (GENMASK_ULL(63, 32)));
+	BUILD_BUG_ON(ID_ISAR5_EL1_RES0		!= (GENMASK_ULL(63, 32) | GENMASK_ULL(23, 20)));
+	BUILD_BUG_ON(ID_ISAR6_EL1_RES0		!= (GENMASK_ULL(63, 28)));
+	BUILD_BUG_ON(ID_MMFR4_EL1_RES0		!= (GENMASK_ULL(63, 32)));
+	BUILD_BUG_ON(MVFR0_EL1_RES0		!= (GENMASK_ULL(63, 32)));
+	BUILD_BUG_ON(MVFR1_EL1_RES0		!= (GENMASK_ULL(63, 32)));
+	BUILD_BUG_ON(MVFR2_EL1_RES0		!= (GENMASK_ULL(63, 8)));
+	BUILD_BUG_ON(ID_PFR2_EL1_RES0		!= (GENMASK_ULL(63, 12)));
+	BUILD_BUG_ON(ID_DFR1_EL1_RES0		!= (GENMASK_ULL(63, 8)));
+	BUILD_BUG_ON(ID_MMFR5_EL1_RES0		!= (GENMASK_ULL(63, 8)));
+	BUILD_BUG_ON(ID_AA64PFR1_EL1_RES0	!= (GENMASK_ULL(23, 20)));
+	BUILD_BUG_ON(ID_AA64PFR2_EL1_RES0	!= (GENMASK_ULL(63, 36) | GENMASK_ULL(31, 12)));
+	BUILD_BUG_ON(ID_AA64ZFR0_EL1_RES0	!= (GENMASK_ULL(63, 60) | GENMASK_ULL(51, 48) | GENMASK_ULL(39, 36) | GENMASK_ULL(31, 28) | GENMASK_ULL(15, 8)));
+	BUILD_BUG_ON(ID_AA64SMFR0_EL1_RES0	!= (GENMASK_ULL(62, 61) | GENMASK_ULL(51, 49) | GENMASK_ULL(31, 31) | GENMASK_ULL(27, 0)));
+	BUILD_BUG_ON(ID_AA64FPFR0_EL1_RES0	!= (GENMASK_ULL(63, 32) | GENMASK_ULL(27, 2)));
+	BUILD_BUG_ON(ID_AA64DFR0_EL1_RES0	!= (GENMASK_ULL(27, 24) | GENMASK_ULL(19, 16)));
+	BUILD_BUG_ON(ID_AA64DFR1_EL1_RES0	!= (GENMASK_ULL(63, 0)));
+	BUILD_BUG_ON(ID_AA64AFR0_EL1_RES0	!= (GENMASK_ULL(63, 32)));
+	BUILD_BUG_ON(ID_AA64AFR1_EL1_RES0	!= (GENMASK_ULL(63, 0)));
+	BUILD_BUG_ON(ID_AA64ISAR0_EL1_RES0	!= (GENMASK_ULL(3, 0)));
+	BUILD_BUG_ON(ID_AA64ISAR2_EL1_RES0	!= (GENMASK_ULL(47, 44)));
+	BUILD_BUG_ON(ID_AA64ISAR3_EL1_RES0	!= (GENMASK_ULL(63, 16)));
+	BUILD_BUG_ON(ID_AA64MMFR0_EL1_RES0	!= (GENMASK_ULL(55, 48)));
+	BUILD_BUG_ON(ID_AA64MMFR2_EL1_RES0	!= (GENMASK_ULL(47, 44)));
+	BUILD_BUG_ON(ID_AA64MMFR3_EL1_RES0	!= (GENMASK_ULL(51, 48)));
+	BUILD_BUG_ON(ID_AA64MMFR4_EL1_RES0	!= (GENMASK_ULL(63, 40) | GENMASK_ULL(35, 28) | GENMASK_ULL(3, 0)));
+	BUILD_BUG_ON(SCTLR_EL1_RES0		!= (GENMASK_ULL(17, 17)));
+	BUILD_BUG_ON(CPACR_ELx_RES0		!= (GENMASK_ULL(63, 30) | GENMASK_ULL(27, 26) | GENMASK_ULL(23, 22) | GENMASK_ULL(19, 18) | GENMASK_ULL(15, 0)));
+	BUILD_BUG_ON(SMPRI_EL1_RES0		!= (GENMASK_ULL(63, 4)));
+	BUILD_BUG_ON(ZCR_ELx_RES0		!= (GENMASK_ULL(63, 9)));
+	BUILD_BUG_ON(SMCR_ELx_RES0		!= (GENMASK_ULL(63, 32) | GENMASK_ULL(29, 9)));
+	BUILD_BUG_ON(GCSCR_ELx_RES0		!= (GENMASK_ULL(63, 10) | GENMASK_ULL(7, 7) | GENMASK_ULL(4, 1)));
+	BUILD_BUG_ON(GCSPR_ELx_RES0		!= (GENMASK_ULL(2, 0)));
+	BUILD_BUG_ON(GCSCRE0_EL1_RES0		!= (GENMASK_ULL(63, 11) | GENMASK_ULL(7, 6) | GENMASK_ULL(4, 1)));
+	BUILD_BUG_ON(ALLINT_RES0		!= (GENMASK_ULL(63, 14) | GENMASK_ULL(12, 0)));
+	BUILD_BUG_ON(PMSCR_EL1_RES0		!= (GENMASK_ULL(63, 8) | GENMASK_ULL(2, 2)));
+	BUILD_BUG_ON(PMSICR_EL1_RES0		!= (GENMASK_ULL(55, 32)));
+	BUILD_BUG_ON(PMSIRR_EL1_RES0		!= (GENMASK_ULL(63, 32) | GENMASK_ULL(7, 1)));
+	BUILD_BUG_ON(PMSFCR_EL1_RES0		!= (GENMASK_ULL(63, 19) | GENMASK_ULL(15, 4)));
+	BUILD_BUG_ON(PMSLATFR_EL1_RES0		!= (GENMASK_ULL(63, 16)));
+	BUILD_BUG_ON(PMSIDR_EL1_RES0		!= (GENMASK_ULL(63, 25) | GENMASK_ULL(7, 7)));
+	BUILD_BUG_ON(PMBLIMITR_EL1_RES0		!= (GENMASK_ULL(11, 6) | GENMASK_ULL(4, 3)));
+	BUILD_BUG_ON(PMBSR_EL1_RES0		!= (GENMASK_ULL(63, 32) | GENMASK_ULL(25, 20)));
+	BUILD_BUG_ON(PMBIDR_EL1_RES0		!= (GENMASK_ULL(63, 12) | GENMASK_ULL(7, 6)));
+	BUILD_BUG_ON(CONTEXTIDR_ELx_RES0	!= (GENMASK_ULL(63, 32)));
+	BUILD_BUG_ON(CCSIDR_EL1_RES0		!= (GENMASK_ULL(63, 32)));
+	BUILD_BUG_ON(CLIDR_EL1_RES0		!= (GENMASK_ULL(63, 47)));
+	BUILD_BUG_ON(CCSIDR2_EL1_RES0		!= (GENMASK_ULL(63, 24)));
+	BUILD_BUG_ON(GMID_EL1_RES0		!= (GENMASK_ULL(63, 4)));
+	BUILD_BUG_ON(SMIDR_EL1_RES0		!= (GENMASK_ULL(63, 32) | GENMASK_ULL(14, 12)));
+	BUILD_BUG_ON(CSSELR_EL1_RES0		!= (GENMASK_ULL(63, 5)));
+	BUILD_BUG_ON(CTR_EL0_RES0		!= (GENMASK_ULL(63, 38) | GENMASK_ULL(30, 30) | GENMASK_ULL(13, 4)));
+	BUILD_BUG_ON(CTR_EL0_RES1       	!= (GENMASK_ULL(31, 31)));
+	BUILD_BUG_ON(DCZID_EL0_RES0		!= (GENMASK_ULL(63, 5)));
+	BUILD_BUG_ON(SVCR_RES0			!= (GENMASK_ULL(63, 2)));
+	BUILD_BUG_ON(FPMR_RES0			!= (GENMASK_ULL(63, 38) | GENMASK_ULL(23, 23) | GENMASK_ULL(13, 9)));
+	BUILD_BUG_ON(HFGxTR_EL2_RES0		!= (GENMASK_ULL(51, 51)));
+	BUILD_BUG_ON(HFGITR_EL2_RES0		!= (GENMASK_ULL(63, 63) | GENMASK_ULL(61, 61)));
+	BUILD_BUG_ON(HDFGRTR_EL2_RES0		!= (GENMASK_ULL(49, 49) | GENMASK_ULL(42, 42) | GENMASK_ULL(39, 38) | GENMASK_ULL(21, 20) | GENMASK_ULL(8, 8)));
+	BUILD_BUG_ON(HDFGWTR_EL2_RES0		!= (GENMASK_ULL(63, 63) | GENMASK_ULL(59, 58) | GENMASK_ULL(51, 51) | GENMASK_ULL(47, 47) | GENMASK_ULL(43, 43) | GENMASK_ULL(40, 38) | GENMASK_ULL(34, 34) | GENMASK_ULL(30, 30) | GENMASK_ULL(22, 22) | GENMASK_ULL(9, 9) | GENMASK_ULL(6, 6)));
+	BUILD_BUG_ON(HAFGRTR_EL2_RES0		!= (GENMASK_ULL(63, 50) | GENMASK_ULL(16, 5)));
+	BUILD_BUG_ON(HCRX_EL2_RES0		!= (GENMASK_ULL(63, 25) | GENMASK_ULL(13, 12)));
+	BUILD_BUG_ON(DACR32_EL2_RES0		!= (GENMASK_ULL(63, 32)));
+	BUILD_BUG_ON(PMSCR_EL2_RES0		!= (GENMASK_ULL(63, 8) | GENMASK_ULL(2, 2)));
+	BUILD_BUG_ON(TCR2_EL1x_RES0		!= (GENMASK_ULL(63, 16) | GENMASK_ULL(13, 12) | GENMASK_ULL(9, 6)));
+	BUILD_BUG_ON(TCR2_EL2_RES0		!= (GENMASK_ULL(63, 16)));
+	BUILD_BUG_ON(LORSA_EL1_RES0		!= (GENMASK_ULL(63, 52) | GENMASK_ULL(15, 1)));
+	BUILD_BUG_ON(LOREA_EL1_RES0		!= (GENMASK_ULL(63, 52) | GENMASK_ULL(15, 0)));
+	BUILD_BUG_ON(LORN_EL1_RES0		!= (GENMASK_ULL(63, 8)));
+	BUILD_BUG_ON(LORC_EL1_RES0		!= (GENMASK_ULL(63, 10) | GENMASK_ULL(1, 1)));
+	BUILD_BUG_ON(LORID_EL1_RES0		!= (GENMASK_ULL(63, 24) | GENMASK_ULL(15, 8)));
+	BUILD_BUG_ON(ISR_EL1_RES0		!= (GENMASK_ULL(63, 11) | GENMASK_ULL(5, 0)));
+	BUILD_BUG_ON(ICC_NMIAR1_EL1_RES0	!= (GENMASK_ULL(63, 24)));
+	BUILD_BUG_ON(TRBLIMITR_EL1_RES0		!= (GENMASK_ULL(11, 7)));
+	BUILD_BUG_ON(TRBBASER_EL1_RES0		!= (GENMASK_ULL(11, 0)));
+	BUILD_BUG_ON(TRBSR_EL1_RES0		!= (GENMASK_ULL(63, 56) | GENMASK_ULL(25, 24) | GENMASK_ULL(19, 19) | GENMASK_ULL(16, 16)));
+	BUILD_BUG_ON(TRBMAR_EL1_RES0		!= (GENMASK_ULL(63, 12)));
+	BUILD_BUG_ON(TRBTRG_EL1_RES0		!= (GENMASK_ULL(63, 32)));
+	BUILD_BUG_ON(TRBIDR_EL1_RES0		!= (GENMASK_ULL(63, 12) | GENMASK_ULL(7, 6)));
+}
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 2cb69efac1dc..b5335e5a6e6e 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -31,6 +31,7 @@
 
 #include <trace/events/kvm.h>
 
+#include "check-res-bits.h"
 #include "sys_regs.h"
 
 #include "trace.h"
@@ -4021,6 +4022,8 @@ int __init kvm_sys_reg_table_init(void)
 	unsigned int i;
 	int ret = 0;
 
+	check_res_bits();
+
 	/* Make sure tables are unique and in order. */
 	valid &= check_sysreg_table(sys_reg_descs, ARRAY_SIZE(sys_reg_descs), false);
 	valid &= check_sysreg_table(cp14_regs, ARRAY_SIZE(cp14_regs), true);
-- 
2.39.2

