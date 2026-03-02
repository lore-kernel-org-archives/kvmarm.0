Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED4C83624D5
	for <kvmarm@lists.linux.dev>; Mon,  2 Mar 2026 11:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772452636; cv=none; b=aY0orF2fXam90l/EfG0WVhNclDT/M8wTWFm8wm8ZmsMMC2nkISDC0u9xDvtdQ89LwWS5DqDK+MCu4aR7w61mks5tS4UyZtdYFmXvdc+Gg5ZLix5+gVMJ/6FYFXRjuU5qHy7UXIumKw7jWrHKBQwRh5Xdy/qDgsmZE9R79ZmFjJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772452636; c=relaxed/simple;
	bh=deRj+9TylccUHPGZfWLldzliB/6yc9WG4BmX+5DwoFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GGgXJ7fc3irgsJvt4Hu6IPPayDBLl8Ep7ty2nlC1rtNrpRCSz3cdIQXUjrpnYzWV0OYslk3lPcPR9Z2H2Gje8xBoofu9VZx1FwHjvfZFV81C/iCZASVS2z29oEx2Lm17L/MSuvjloRlek/1QCMn6g2/9MxMRHpp/mzGeAEgWYu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=if0tEaq7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="if0tEaq7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBC1EC2BCB0;
	Mon,  2 Mar 2026 11:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772452635;
	bh=deRj+9TylccUHPGZfWLldzliB/6yc9WG4BmX+5DwoFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=if0tEaq7q++sSLV+ooiEE3K2Iuk1Loy9O7y2zNKJufn/ATtT9+fH8eJmPX6ITqkpQ
	 7+dJWzUcMFYKHSu2kEyiYUZmsyyZ9SINi1stVbUfYrIkFvF072XsTQ1Y9NlykF3lOB
	 J1PjQvrRQAZ0l6fRjFXHs72FTQ9d1hEUH6GI4xBteBzZBDR2hXeWXO5Wu7xIV162bp
	 YX24bzkJt+tdW/hS4K1SHFV/BQC4unuRgQ9H3wMdSO8dZbl4u13AO4foQPFIkswT52
	 AtChUMIQq3JAeiLof2zGKFSQrxpqAAqtVU+OlWNBvEMl/OuQHrIBCbLI9md+9gJKL+
	 mB8bXdUzdtWgg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vx1th-0000000FDFJ-48kJ;
	Mon, 02 Mar 2026 11:57:14 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 05/11] arm64: Convert CONFIG_ARM64_SVE to FTR_CONFIG()
Date: Mon,  2 Mar 2026 11:56:46 +0000
Message-ID: <20260302115653.1517326-6-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260302115653.1517326-1-maz@kernel.org>
References: <20260302115653.1517326-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, tabba@google.com, will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

While CONFIG_ARM64_SVE=n prevents userspace from using SVE,
the sanitised ID registers still advertise the feature.

Make it clear that nothing in the kernel should rely on this by
marking the feature as hidden for all when CONFIG_ARM64_SVE=n.

This is functionnaly equivalent to using arm64.nosve on the kernel
command-line.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kernel/cpufeature.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 0726c2a186028..b5b19f21709f1 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -293,7 +293,7 @@ static const struct arm64_ftr_bits ftr_id_aa64pfr0[] = {
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR0_EL1_AMU_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR0_EL1_MPAM_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR0_EL1_SEL2_SHIFT, 4, 0),
-	ARM64_FTR_BITS(FTR_VISIBLE_IF_IS_ENABLED(CONFIG_ARM64_SVE),
+	ARM64_FTR_BITS(FTR_CONFIG(CONFIG_ARM64_SVE, VISIBLE, ALL_HIDDEN),
 				   FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR0_EL1_SVE_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR0_EL1_RAS_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR0_EL1_GIC_SHIFT, 4, 0),
@@ -331,29 +331,29 @@ static const struct arm64_ftr_bits ftr_id_aa64pfr2[] = {
 };
 
 static const struct arm64_ftr_bits ftr_id_aa64zfr0[] = {
-	ARM64_FTR_BITS(FTR_VISIBLE_IF_IS_ENABLED(CONFIG_ARM64_SVE),
+	ARM64_FTR_BITS(FTR_CONFIG(CONFIG_ARM64_SVE, VISIBLE, ALL_HIDDEN),
 		       FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ZFR0_EL1_F64MM_SHIFT, 4, 0),
-	ARM64_FTR_BITS(FTR_VISIBLE_IF_IS_ENABLED(CONFIG_ARM64_SVE),
+	ARM64_FTR_BITS(FTR_CONFIG(CONFIG_ARM64_SVE, VISIBLE, ALL_HIDDEN),
 		       FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ZFR0_EL1_F32MM_SHIFT, 4, 0),
-	ARM64_FTR_BITS(FTR_VISIBLE_IF_IS_ENABLED(CONFIG_ARM64_SVE),
+	ARM64_FTR_BITS(FTR_CONFIG(CONFIG_ARM64_SVE, VISIBLE, ALL_HIDDEN),
 		       FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ZFR0_EL1_F16MM_SHIFT, 4, 0),
-	ARM64_FTR_BITS(FTR_VISIBLE_IF_IS_ENABLED(CONFIG_ARM64_SVE),
+	ARM64_FTR_BITS(FTR_CONFIG(CONFIG_ARM64_SVE, VISIBLE, ALL_HIDDEN),
 		       FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ZFR0_EL1_I8MM_SHIFT, 4, 0),
-	ARM64_FTR_BITS(FTR_VISIBLE_IF_IS_ENABLED(CONFIG_ARM64_SVE),
+	ARM64_FTR_BITS(FTR_CONFIG(CONFIG_ARM64_SVE, VISIBLE, ALL_HIDDEN),
 		       FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ZFR0_EL1_SM4_SHIFT, 4, 0),
-	ARM64_FTR_BITS(FTR_VISIBLE_IF_IS_ENABLED(CONFIG_ARM64_SVE),
+	ARM64_FTR_BITS(FTR_CONFIG(CONFIG_ARM64_SVE, VISIBLE, ALL_HIDDEN),
 		       FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ZFR0_EL1_SHA3_SHIFT, 4, 0),
-	ARM64_FTR_BITS(FTR_VISIBLE_IF_IS_ENABLED(CONFIG_ARM64_SVE),
+	ARM64_FTR_BITS(FTR_CONFIG(CONFIG_ARM64_SVE, VISIBLE, ALL_HIDDEN),
 		       FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ZFR0_EL1_B16B16_SHIFT, 4, 0),
-	ARM64_FTR_BITS(FTR_VISIBLE_IF_IS_ENABLED(CONFIG_ARM64_SVE),
+	ARM64_FTR_BITS(FTR_CONFIG(CONFIG_ARM64_SVE, VISIBLE, ALL_HIDDEN),
 		       FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ZFR0_EL1_BF16_SHIFT, 4, 0),
-	ARM64_FTR_BITS(FTR_VISIBLE_IF_IS_ENABLED(CONFIG_ARM64_SVE),
+	ARM64_FTR_BITS(FTR_CONFIG(CONFIG_ARM64_SVE, VISIBLE, ALL_HIDDEN),
 		       FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ZFR0_EL1_BitPerm_SHIFT, 4, 0),
-	ARM64_FTR_BITS(FTR_VISIBLE_IF_IS_ENABLED(CONFIG_ARM64_SVE),
+	ARM64_FTR_BITS(FTR_CONFIG(CONFIG_ARM64_SVE, VISIBLE, ALL_HIDDEN),
 		       FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ZFR0_EL1_EltPerm_SHIFT, 4, 0),
-	ARM64_FTR_BITS(FTR_VISIBLE_IF_IS_ENABLED(CONFIG_ARM64_SVE),
+	ARM64_FTR_BITS(FTR_CONFIG(CONFIG_ARM64_SVE, VISIBLE, ALL_HIDDEN),
 		       FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ZFR0_EL1_AES_SHIFT, 4, 0),
-	ARM64_FTR_BITS(FTR_VISIBLE_IF_IS_ENABLED(CONFIG_ARM64_SVE),
+	ARM64_FTR_BITS(FTR_CONFIG(CONFIG_ARM64_SVE, VISIBLE, ALL_HIDDEN),
 		       FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ZFR0_EL1_SVEver_SHIFT, 4, 0),
 	ARM64_FTR_END,
 };
-- 
2.47.3

