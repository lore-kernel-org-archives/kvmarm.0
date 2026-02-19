Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7F783090C5
	for <kvmarm@lists.linux.dev>; Thu, 19 Feb 2026 19:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771530948; cv=none; b=aC/5HgoViFGiapKjy+AwgnPov0YzUsB7R/2vK1NKExirRfnO5ksUnqJGO/inOazlSHe+Dss5F7lGrvYHw9B0qIsQAV/jmlJyRdOcgt5+C25EsBR/eFTaHHDr/z64zqZTNY50AoEs8hqgiO0+6eEpYC72oYsNLLtJdH0nVXQWOyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771530948; c=relaxed/simple;
	bh=76pmomQArMSLAs0L9uu/C5/0Ws+wcuhfAoo5l+smieU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=prJew0NuWWXcVvMR41fs+oc6sSukeMkx0o7tjh8SCDp2KX77uBhpUnpDhWtYJex6c6Y8bLS5XhIWqfHMMeK9JX3FdoBCE8rmADwI4VXl+2gI8Hhb1cn/z5gKeJR/W1XAvBjv5y7NOE1/nOebvF4HPl0jzNHoKXLZM5f6ylEefw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c5yaJDA1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c5yaJDA1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80202C2BCB2;
	Thu, 19 Feb 2026 19:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771530948;
	bh=76pmomQArMSLAs0L9uu/C5/0Ws+wcuhfAoo5l+smieU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c5yaJDA16Ben7hnWrS2YYGKC0e0z2Y92GzaHDQRL+Xja3Nvy2RfceAIpILDz4mvUq
	 9KMVNAF1dAUN5Z7xfzcwKVZ/6HywXFbn55ZRCujYm3lMjbl7oV8tSLoYSWat1CUw7g
	 D2+Sy6T0UlThiK26V+PDgRx0iw4Au5DCVUC1PnN2ijjb8vHFVXssFzxV1lY19Npo7t
	 g/OHU0c/LgxBeY7eyQMOp9ygTTeR+kr22nTmrzReQGDnyOLR8oEjipFEEy9EfCQxIk
	 Q1bEoYPlOFTJ03EcU84F+FODg3hOvJbnxvkyE8+y7A2mkfb7la956nxcRuNdipdTLN
	 4K+y1QG54MV6Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vtA7m-0000000CGHL-1oen;
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
Subject: [PATCH 5/9] arm64: Convert CONFIG_ARM64_GCS to FTR_CONFIG()
Date: Thu, 19 Feb 2026 19:55:28 +0000
Message-ID: <20260219195533.2455736-6-maz@kernel.org>
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

While CONFIG_ARM64_GCS=n prevents userspace from using GCS,
the sanitised ID registers still advertise the feature.

Make it clear that nothing in the kernel should rely on this by
marking the feature as hidden for all when CONFIG_ARM64_GCS=n.

This is functionnaly equivalent to using arm64.nogcs on the kernel
command-line.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kernel/cpufeature.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 3d7083280cdde..ca4aae48ace66 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -307,7 +307,7 @@ static const struct arm64_ftr_bits ftr_id_aa64pfr0[] = {
 
 static const struct arm64_ftr_bits ftr_id_aa64pfr1[] = {
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR1_EL1_DF2_SHIFT, 4, 0),
-	ARM64_FTR_BITS(FTR_VISIBLE_IF_IS_ENABLED(CONFIG_ARM64_GCS),
+	ARM64_FTR_BITS(FTR_CONFIG(CONFIG_ARM64_GCS, VISIBLE, ALL_HIDDEN),
 		       FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR1_EL1_GCS_SHIFT, 4, 0),
 	S_ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR1_EL1_MTE_frac_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_CONFIG(CONFIG_ARM64_SME, VISIBLE, ALL_HIDDEN),
-- 
2.47.3

