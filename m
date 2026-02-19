Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ACD2305057
	for <kvmarm@lists.linux.dev>; Thu, 19 Feb 2026 19:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771530948; cv=none; b=Ma8iZCh+iaH9uprEt0YmvVZmfVZY7beTxGzN6XFYadkYsUIj5GIz+OowabnvY48XDZMEhhjmXrrdFeK3VolmiBU1o2fqnp5J6PNyw1/A7MzGa/EICjg56SdjeIB/KNCPDYyzuxJX4ynqbbkZ0GEJkIU0qTqc0e8xncy/P3T/IN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771530948; c=relaxed/simple;
	bh=R9ddcM0FhxsB3jJnj82FiB15M/HdE+9A3r4mtCkjeXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bOqL/mkgfmPxKCMWn3KBjnvZTPdLAS1mSM1NKKaoq83WIuUJE2Zt1ocq//IsJ6PCAEvdm4fosuCUXAszbhR54l5vK++TuLU6WAGjV/63pIrAV1C94N3SHXVuiEA5ozaZNu9JFXnLhpLn7rCG7iu8dgkWZPIjOtHwrvsXlh6+Lg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AxSJPV4l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AxSJPV4l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE19CC116D0;
	Thu, 19 Feb 2026 19:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771530947;
	bh=R9ddcM0FhxsB3jJnj82FiB15M/HdE+9A3r4mtCkjeXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AxSJPV4l/7H8ctQ/YCDTG9KodKJUxwse733VCDYM+XHxJDVtE4hx/LQ6AOfZ+JqAR
	 kh/C/lacOgJGveOdbkfehe4BcpnleS8pPwGzj3shHAyzlt/1tbTJQm+jNRdp+LMuFv
	 3ejSeNl86v6UPSox+axLpZDtJ6/LlmA3eCyasK0LurRjg9WnjC7BC4izB7TNKXaU0M
	 8CxvRBEIyskgDdmf2P2T90SlV0wGMvf8ixbNwlR9Iq9G08hdSer07l2NBGk4e6FaJH
	 dlrfUY3j1r/JyBPvflB8IZzJXBx8fCUPckxd4x1CJ0AVfsNUHn0jqyXpr6AONIybXN
	 ZBDTuoiWAzCDw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vtA7l-0000000CGHL-43J4;
	Thu, 19 Feb 2026 19:55:46 +0000
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
Subject: [PATCH 3/9] arm64: Convert CONFIG_ARM64_SVE to FTR_CONFIG()
Date: Thu, 19 Feb 2026 19:55:26 +0000
Message-ID: <20260219195533.2455736-4-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260219195533.2455736-1-maz@kernel.org>
References: <20260219195533.2455736-1-maz@kernel.org>
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
index 7ad124faae08e..9f631658de4b3 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -292,7 +292,7 @@ static const struct arm64_ftr_bits ftr_id_aa64pfr0[] = {
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR0_EL1_AMU_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR0_EL1_MPAM_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR0_EL1_SEL2_SHIFT, 4, 0),
-	ARM64_FTR_BITS(FTR_VISIBLE_IF_IS_ENABLED(CONFIG_ARM64_SVE),
+	ARM64_FTR_BITS(FTR_CONFIG(CONFIG_ARM64_SVE, VISIBLE, ALL_HIDDEN),
 				   FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR0_EL1_SVE_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR0_EL1_RAS_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR0_EL1_GIC_SHIFT, 4, 0),
@@ -330,29 +330,29 @@ static const struct arm64_ftr_bits ftr_id_aa64pfr2[] = {
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

