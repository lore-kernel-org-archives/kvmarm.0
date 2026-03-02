Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC5F13630AE
	for <kvmarm@lists.linux.dev>; Mon,  2 Mar 2026 11:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772452636; cv=none; b=tU6sT3LFRxlrawtG9URGCPez6dAC15/fHj2w7BOriaOP9tMboi7t6CRteToWUnVPxC5Pb9RTaTbmP8ivCtO7cNdCo7T/XRE6HGvsplfX7lFt4o4C12M7SC2UGLWo/QMRe3Qdz3gP8frLKgAHXuP8ahkshnSfcWLBDs1VfLraH84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772452636; c=relaxed/simple;
	bh=6QMOHcncUwOcL5HADPQFuLPwDpOhb5X4dCv7+gTCwSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hjJveCQlxPwLqQA2pe+LnqEIQnSjl1Jkwwy8CA90fegcy0nFM06SJ0KlZrkvqD7k92WiyQxDeWlXTOV57/tD4c8aU/qDrWnmlYN6Hkh1Ps51aTsm67IHNgM/xgNoPGpfLznak786gwp6XMTs4NM5GI4CZ/IllAI3dWVeFo9ubR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FozNS7gX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FozNS7gX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DF64C2BC86;
	Mon,  2 Mar 2026 11:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772452636;
	bh=6QMOHcncUwOcL5HADPQFuLPwDpOhb5X4dCv7+gTCwSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FozNS7gXtLu4xwHbGJsJ/tLrE9iGYPi93ecz01D5jzemyXAOEF4KhMVkjKxcerlYG
	 XzTm+NqLPukHTvukllqBg2k1Cla/KYsQdjlZnfo4hqCu0q2Dlf3LIbkViyBwnAuNR0
	 acdIofoeXw/xV2F6h64eXfUyDIc37efeTIP26j32HMnEBDmRJU1nwN36vj1y1KbPZO
	 cENAyvoNG5dDBiSdkaK5GMnNT9H//p81rp7Ngal5tvbfdC68tKuS8CHzqY5UKSXNa7
	 +yTKI4ORDlHcvmLHbUYeSzs8c1Qndv0oKdFaf86GMjihKjGlwmHKspq7gfB8ons7kc
	 Ip0iCLGTForNQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vx1ti-0000000FDFJ-3iff;
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
Subject: [PATCH v2 09/11] arm64: Convert CONFIG_ARM64_POE to FTR_CONFIG()
Date: Mon,  2 Mar 2026 11:56:50 +0000
Message-ID: <20260302115653.1517326-10-maz@kernel.org>
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

While CONFIG_ARM64_POE=n prevents userspace from using S1POE,
the sanitised ID registers still advertise the feature.

Make it clear that nothing in the kernel should rely on this by
marking the feature as hidden for all when CONFIG_ARM64_POE=n.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kernel/cpufeature.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index a56d242fe1489..1af5f5b0c48a7 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -504,7 +504,7 @@ static const struct arm64_ftr_bits ftr_id_aa64mmfr2[] = {
 };
 
 static const struct arm64_ftr_bits ftr_id_aa64mmfr3[] = {
-	ARM64_FTR_BITS(FTR_VISIBLE_IF_IS_ENABLED(CONFIG_ARM64_POE),
+	ARM64_FTR_BITS(FTR_CONFIG(CONFIG_ARM64_POE, VISIBLE, ALL_HIDDEN),
 		       FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64MMFR3_EL1_S1POE_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64MMFR3_EL1_S1PIE_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR3_EL1_SCTLRX_SHIFT, 4, 0),
-- 
2.47.3

