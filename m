Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 849EB3624D5
	for <kvmarm@lists.linux.dev>; Mon,  2 Mar 2026 11:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772452636; cv=none; b=Pot15mLCj9ocoAhTRJS/WWWphHUBlnqbrVu7NvACIP56YOwoZQCa1gVryRtQOGr5poZrIwaHo5rm1fqChCzodrAzUr9uzFJ09MEKPAOeQK8yc4qnQ9ZqqSPgB3lzq6Jluc7cFlpGRlYqp2IxDKkSN3qXq6e+F7IIVF+3wxJ1fUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772452636; c=relaxed/simple;
	bh=iyw2TSh9hsLIDznqHzkKeFTHAPUdkwANM4EQTv+NzyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H2St+qy1QIizyboJd3h3xoMByUszjLFTLwn9f+UU0zSZoh3Zn/KysGMkSizkYeIJIX2/lzwbrhgkIaE9Eou/EnjOeewtEGmY+Yneb1rXoMsVBj7RbmYUjPAAupjfGjNB642x1xeZkmX07HRXhKld3ltsuiJZyVLWn5ooOcqpkio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ayADbHKt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ayADbHKt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67254C2BCAF;
	Mon,  2 Mar 2026 11:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772452636;
	bh=iyw2TSh9hsLIDznqHzkKeFTHAPUdkwANM4EQTv+NzyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ayADbHKt7x6QgfqmDNpDoqKBnRtI/VmJdcADs6Di3mPnHBlUMCo7dcck0W7WGpUS3
	 gPGVG0IrFLG6hBaIWJKx8EG/Z4MO2GMZCdTLboa6zuhAg+vhGSTQ/+4s8ykK7PT/L2
	 acFUvYW02N4kQO7o6Wc3CF9w926LT+4EC1wUj1FqZBccKE/9H6hVqfw2sAugropJ6d
	 xdT2yvIDa60cCW+DmkTeH0xf6BsSPExJ14Os3/Qk5RbIA1UNT0TIx7OQI5QbH6lcC5
	 BtIldsGo+80ZyS2knK65LnGmglYmzyMpCSO6uwt7nGMLhzhqYLIjaIVR7wKMoEr+tU
	 iKZAANAVkj6mA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vx1ti-0000000FDFJ-1pMJ;
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
Subject: [PATCH v2 07/11] arm64: Convert CONFIG_ARM64_GCS to FTR_CONFIG()
Date: Mon,  2 Mar 2026 11:56:48 +0000
Message-ID: <20260302115653.1517326-8-maz@kernel.org>
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
index cf1e53aa8e475..ab0a7d72608d4 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -308,7 +308,7 @@ static const struct arm64_ftr_bits ftr_id_aa64pfr0[] = {
 
 static const struct arm64_ftr_bits ftr_id_aa64pfr1[] = {
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR1_EL1_DF2_SHIFT, 4, 0),
-	ARM64_FTR_BITS(FTR_VISIBLE_IF_IS_ENABLED(CONFIG_ARM64_GCS),
+	ARM64_FTR_BITS(FTR_CONFIG(CONFIG_ARM64_GCS, VISIBLE, ALL_HIDDEN),
 		       FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR1_EL1_GCS_SHIFT, 4, 0),
 	S_ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR1_EL1_MTE_frac_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_CONFIG(CONFIG_ARM64_SME, VISIBLE, ALL_HIDDEN),
-- 
2.47.3

