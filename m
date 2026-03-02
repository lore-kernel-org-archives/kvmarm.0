Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65443337BBD
	for <kvmarm@lists.linux.dev>; Mon,  2 Mar 2026 11:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772452636; cv=none; b=OOk1u80zgqVppKqZsdld1RshF+t8QI630ob6GZS854CIhUNTcgfRWoaNIla6VO7LIt1h/JQ0Ogbt6B7fMvjAuzKrOVJvMJ2D6OATZL5y4JYKQc0sFcUW+tImegyqZXsEoudxO2hepISUIohL7jULK5nLacfPNHEAgzPvl3VjEQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772452636; c=relaxed/simple;
	bh=PtCb+AGeMdfoyKHkSDqztVNHW735fXTAde49J9wah4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h6DweWqEpuQ6TiLfgEYzuF9QOKS/uwxxd2oxCwnlx8TztK3NH4h4r/plGjxIYRwyF8Lx1WQ2Ec8wqIBmsNasBbBlbi5hlTb5jdwM8mVc4LUVUcRmJiVLpX95iahX9lx1zfy8H21z37ZAZr52W5o+4wKOs1EjpnXSgbgNhkrh19k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FyF7J04b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FyF7J04b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C7CFC2BC86;
	Mon,  2 Mar 2026 11:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772452636;
	bh=PtCb+AGeMdfoyKHkSDqztVNHW735fXTAde49J9wah4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FyF7J04b4feJz7QRLjBrget2LV6XgUViIYViP9DRq0UUf5kazXuBnSsX2fBX51XzR
	 1kzh/DuEcO7BmO5zfRrSqmL8Lg4x8mlYw52/gjrAygN29S+jTH5f7L3lPwsVMO0yxF
	 r9vXqJVX0GTSj0mTi2/49uDci0e6/zh+/zN1J1zO0GBmP7MVAz0RxOGOO4prh26ahV
	 TMCOIFrvlTEbcVa505/w4wiJx9hDTh6pScOfCveZDKZMlTUE6pAYRQpgKqx/Z6/bRB
	 D9Y4mcCpB38xvWGwK8cauSARn4+ddIs5jA77gTrFn0gI8bKtNZe9IiDXVlYY5Fbu+n
	 8b6R4LKEgL+sQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vx1ti-0000000FDFJ-0tfS;
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
Subject: [PATCH v2 06/11] arm64: Convert CONFIG_ARM64_SME to FTR_CONFIG()
Date: Mon,  2 Mar 2026 11:56:47 +0000
Message-ID: <20260302115653.1517326-7-maz@kernel.org>
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

While CONFIG_ARM64_SME=n prevents userspace from using SME,
the sanitised ID registers still advertise the feature.

Make it clear that nothing in the kernel should rely on this by
marking the feature as hidden for all when CONFIG_ARM64_SME=n.

This is functionnaly equivalent to using arm64.nosme on the kernel
command-line.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kernel/cpufeature.c | 48 +++++++++++++++++-----------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index b5b19f21709f1..cf1e53aa8e475 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -311,7 +311,7 @@ static const struct arm64_ftr_bits ftr_id_aa64pfr1[] = {
 	ARM64_FTR_BITS(FTR_VISIBLE_IF_IS_ENABLED(CONFIG_ARM64_GCS),
 		       FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR1_EL1_GCS_SHIFT, 4, 0),
 	S_ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR1_EL1_MTE_frac_SHIFT, 4, 0),
-	ARM64_FTR_BITS(FTR_VISIBLE_IF_IS_ENABLED(CONFIG_ARM64_SME),
+	ARM64_FTR_BITS(FTR_CONFIG(CONFIG_ARM64_SME, VISIBLE, ALL_HIDDEN),
 		       FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR1_EL1_SME_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR1_EL1_MPAM_frac_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR1_EL1_RAS_frac_SHIFT, 4, 0),
@@ -359,51 +359,51 @@ static const struct arm64_ftr_bits ftr_id_aa64zfr0[] = {
 };
 
 static const struct arm64_ftr_bits ftr_id_aa64smfr0[] = {
-	ARM64_FTR_BITS(FTR_VISIBLE_IF_IS_ENABLED(CONFIG_ARM64_SME),
+	ARM64_FTR_BITS(FTR_CONFIG(CONFIG_ARM64_SME, VISIBLE, ALL_HIDDEN),
 		       FTR_STRICT, FTR_EXACT, ID_AA64SMFR0_EL1_FA64_SHIFT, 1, 0),
-	ARM64_FTR_BITS(FTR_VISIBLE_IF_IS_ENABLED(CONFIG_ARM64_SME),
+	ARM64_FTR_BITS(FTR_CONFIG(CONFIG_ARM64_SME, VISIBLE, ALL_HIDDEN),
 		       FTR_STRICT, FTR_EXACT, ID_AA64SMFR0_EL1_LUTv2_SHIFT, 1, 0),
-	ARM64_FTR_BITS(FTR_VISIBLE_IF_IS_ENABLED(CONFIG_ARM64_SME),
+	ARM64_FTR_BITS(FTR_CONFIG(CONFIG_ARM64_SME, VISIBLE, ALL_HIDDEN),
 		       FTR_STRICT, FTR_EXACT, ID_AA64SMFR0_EL1_SMEver_SHIFT, 4, 0),
-	ARM64_FTR_BITS(FTR_VISIBLE_IF_IS_ENABLED(CONFIG_ARM64_SME),
+	ARM64_FTR_BITS(FTR_CONFIG(CONFIG_ARM64_SME, VISIBLE, ALL_HIDDEN),
 		       FTR_STRICT, FTR_EXACT, ID_AA64SMFR0_EL1_I16I64_SHIFT, 4, 0),
-	ARM64_FTR_BITS(FTR_VISIBLE_IF_IS_ENABLED(CONFIG_ARM64_SME),
+	ARM64_FTR_BITS(FTR_CONFIG(CONFIG_ARM64_SME, VISIBLE, ALL_HIDDEN),
 		       FTR_STRICT, FTR_EXACT, ID_AA64SMFR0_EL1_F64F64_SHIFT, 1, 0),
-	ARM64_FTR_BITS(FTR_VISIBLE_IF_IS_ENABLED(CONFIG_ARM64_SME),
+	ARM64_FTR_BITS(FTR_CONFIG(CONFIG_ARM64_SME, VISIBLE, ALL_HIDDEN),
 		       FTR_STRICT, FTR_EXACT, ID_AA64SMFR0_EL1_I16I32_SHIFT, 4, 0),
-	ARM64_FTR_BITS(FTR_VISIBLE_IF_IS_ENABLED(CONFIG_ARM64_SME),
+	ARM64_FTR_BITS(FTR_CONFIG(CONFIG_ARM64_SME, VISIBLE, ALL_HIDDEN),
 		       FTR_STRICT, FTR_EXACT, ID_AA64SMFR0_EL1_B16B16_SHIFT, 1, 0),
-	ARM64_FTR_BITS(FTR_VISIBLE_IF_IS_ENABLED(CONFIG_ARM64_SME),
+	ARM64_FTR_BITS(FTR_CONFIG(CONFIG_ARM64_SME, VISIBLE, ALL_HIDDEN),
 		       FTR_STRICT, FTR_EXACT, ID_AA64SMFR0_EL1_F16F16_SHIFT, 1, 0),
-	ARM64_FTR_BITS(FTR_VISIBLE_IF_IS_ENABLED(CONFIG_ARM64_SME),
+	ARM64_FTR_BITS(FTR_CONFIG(CONFIG_ARM64_SME, VISIBLE, ALL_HIDDEN),
 		       FTR_STRICT, FTR_EXACT, ID_AA64SMFR0_EL1_F8F16_SHIFT, 1, 0),
-	ARM64_FTR_BITS(FTR_VISIBLE_IF_IS_ENABLED(CONFIG_ARM64_SME),
+	ARM64_FTR_BITS(FTR_CONFIG(CONFIG_ARM64_SME, VISIBLE, ALL_HIDDEN),
 		       FTR_STRICT, FTR_EXACT, ID_AA64SMFR0_EL1_F8F32_SHIFT, 1, 0),
-	ARM64_FTR_BITS(FTR_VISIBLE_IF_IS_ENABLED(CONFIG_ARM64_SME),
+	ARM64_FTR_BITS(FTR_CONFIG(CONFIG_ARM64_SME, VISIBLE, ALL_HIDDEN),
 		       FTR_STRICT, FTR_EXACT, ID_AA64SMFR0_EL1_I8I32_SHIFT, 4, 0),
-	ARM64_FTR_BITS(FTR_VISIBLE_IF_IS_ENABLED(CONFIG_ARM64_SME),
+	ARM64_FTR_BITS(FTR_CONFIG(CONFIG_ARM64_SME, VISIBLE, ALL_HIDDEN),
 		       FTR_STRICT, FTR_EXACT, ID_AA64SMFR0_EL1_F16F32_SHIFT, 1, 0),
-	ARM64_FTR_BITS(FTR_VISIBLE_IF_IS_ENABLED(CONFIG_ARM64_SME),
+	ARM64_FTR_BITS(FTR_CONFIG(CONFIG_ARM64_SME, VISIBLE, ALL_HIDDEN),
 		       FTR_STRICT, FTR_EXACT, ID_AA64SMFR0_EL1_B16F32_SHIFT, 1, 0),
-	ARM64_FTR_BITS(FTR_VISIBLE_IF_IS_ENABLED(CONFIG_ARM64_SME),
+	ARM64_FTR_BITS(FTR_CONFIG(CONFIG_ARM64_SME, VISIBLE, ALL_HIDDEN),
 		       FTR_STRICT, FTR_EXACT, ID_AA64SMFR0_EL1_BI32I32_SHIFT, 1, 0),
-	ARM64_FTR_BITS(FTR_VISIBLE_IF_IS_ENABLED(CONFIG_ARM64_SME),
+	ARM64_FTR_BITS(FTR_CONFIG(CONFIG_ARM64_SME, VISIBLE, ALL_HIDDEN),
 		       FTR_STRICT, FTR_EXACT, ID_AA64SMFR0_EL1_F32F32_SHIFT, 1, 0),
-	ARM64_FTR_BITS(FTR_VISIBLE_IF_IS_ENABLED(CONFIG_ARM64_SME),
+	ARM64_FTR_BITS(FTR_CONFIG(CONFIG_ARM64_SME, VISIBLE, ALL_HIDDEN),
 		       FTR_STRICT, FTR_EXACT, ID_AA64SMFR0_EL1_SF8FMA_SHIFT, 1, 0),
-	ARM64_FTR_BITS(FTR_VISIBLE_IF_IS_ENABLED(CONFIG_ARM64_SME),
+	ARM64_FTR_BITS(FTR_CONFIG(CONFIG_ARM64_SME, VISIBLE, ALL_HIDDEN),
 		       FTR_STRICT, FTR_EXACT, ID_AA64SMFR0_EL1_SF8DP4_SHIFT, 1, 0),
-	ARM64_FTR_BITS(FTR_VISIBLE_IF_IS_ENABLED(CONFIG_ARM64_SME),
+	ARM64_FTR_BITS(FTR_CONFIG(CONFIG_ARM64_SME, VISIBLE, ALL_HIDDEN),
 		       FTR_STRICT, FTR_EXACT, ID_AA64SMFR0_EL1_SF8DP2_SHIFT, 1, 0),
-	ARM64_FTR_BITS(FTR_VISIBLE_IF_IS_ENABLED(CONFIG_ARM64_SME),
+	ARM64_FTR_BITS(FTR_CONFIG(CONFIG_ARM64_SME, VISIBLE, ALL_HIDDEN),
 		       FTR_STRICT, FTR_EXACT, ID_AA64SMFR0_EL1_SBitPerm_SHIFT, 1, 0),
-	ARM64_FTR_BITS(FTR_VISIBLE_IF_IS_ENABLED(CONFIG_ARM64_SME),
+	ARM64_FTR_BITS(FTR_CONFIG(CONFIG_ARM64_SME, VISIBLE, ALL_HIDDEN),
 		       FTR_STRICT, FTR_EXACT, ID_AA64SMFR0_EL1_AES_SHIFT, 1, 0),
-	ARM64_FTR_BITS(FTR_VISIBLE_IF_IS_ENABLED(CONFIG_ARM64_SME),
+	ARM64_FTR_BITS(FTR_CONFIG(CONFIG_ARM64_SME, VISIBLE, ALL_HIDDEN),
 		       FTR_STRICT, FTR_EXACT, ID_AA64SMFR0_EL1_SFEXPA_SHIFT, 1, 0),
-	ARM64_FTR_BITS(FTR_VISIBLE_IF_IS_ENABLED(CONFIG_ARM64_SME),
+	ARM64_FTR_BITS(FTR_CONFIG(CONFIG_ARM64_SME, VISIBLE, ALL_HIDDEN),
 		       FTR_STRICT, FTR_EXACT, ID_AA64SMFR0_EL1_STMOP_SHIFT, 1, 0),
-	ARM64_FTR_BITS(FTR_VISIBLE_IF_IS_ENABLED(CONFIG_ARM64_SME),
+	ARM64_FTR_BITS(FTR_CONFIG(CONFIG_ARM64_SME, VISIBLE, ALL_HIDDEN),
 		       FTR_STRICT, FTR_EXACT, ID_AA64SMFR0_EL1_SMOP4_SHIFT, 1, 0),
 	ARM64_FTR_END,
 };
-- 
2.47.3

