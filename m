Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C44F30ACF2
	for <kvmarm@lists.linux.dev>; Thu, 19 Feb 2026 19:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771530949; cv=none; b=dy11zZt4fxwV/1CCP7JO9ZEVfoG0EeJq+8jMu4nPtWFuRF0N3rNZEEmhskk6gBI3b2h3XOVh4e9t1rCrMnHCHcM+YHitO3Yczsrp+PRmjJ/X2gsF7npNfbWoSr7Y0hTWXBRcZPN7K2ozK3fGeq6nC9fhfTqjYRoVkBHM2Ngwm8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771530949; c=relaxed/simple;
	bh=Dm8iXGoUYwFq2X42OxblahVPVvptIpeIptfk63MDYOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jibCjCP/CIcKZWUIjNEAc6pZeK5dHD7/O3pflYkAWpPg9s4VLabBrgCXIbXTqO7ba1a7PjE3GHSfRPuc1uuasdFaEiSkTMV7dK9ktpKhlylWHQVInEVQbB5hyO6n11dcIf2nx7r6Ab9G+5Pemg9cbP2fMjXYzEIzVppzL5gSErA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ekOwrUHa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ekOwrUHa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3D4CC2BC86;
	Thu, 19 Feb 2026 19:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771530949;
	bh=Dm8iXGoUYwFq2X42OxblahVPVvptIpeIptfk63MDYOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ekOwrUHaRWCXIgLu6iMkmGCGiCMnwzDb2PqJslHaIiL1oS31+kVbsnVIq3w+TIBc7
	 0HtBdUTiSQntRn0h49jqFonAyxZxe2S/ALVLB6eRFIC1jpbI/Onrh1rpf6Ac2Xdo/h
	 wyzP79poM172C5hUwOg2FnzhPt77J6eer/Lcr/iWOOlHaCXK8BI5Sb1xzj+rEcv99E
	 kk7+M2cFfsDIKPt829WT9V/jvSQJiZjv5/JBZ8y77VHR/iSU1gnw/3qDSSgqntRYmS
	 JxAAESgujQUKEdAsA/eTkR8reLbIXz5WQMM3v439V6i15oP5kkqmxRHaNBlybG1BbB
	 7wdJgsRPmB7wg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vtA7m-0000000CGHL-3lca;
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
Subject: [PATCH 7/9] arm64: Convert CONFIG_ARM64_POE to FTR_CONFIG()
Date: Thu, 19 Feb 2026 19:55:30 +0000
Message-ID: <20260219195533.2455736-8-maz@kernel.org>
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

While CONFIG_ARM64_POE=n prevents userspace from using S1POE,
the sanitised ID registers still advertise the feature.

Make it clear that nothing in the kernel should rely on this by
marking the feature as hidden for all when CONFIG_ARM64_POE=n.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kernel/cpufeature.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 2b9d03c9564e6..8eb9dc35cdba4 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -503,7 +503,7 @@ static const struct arm64_ftr_bits ftr_id_aa64mmfr2[] = {
 };
 
 static const struct arm64_ftr_bits ftr_id_aa64mmfr3[] = {
-	ARM64_FTR_BITS(FTR_VISIBLE_IF_IS_ENABLED(CONFIG_ARM64_POE),
+	ARM64_FTR_BITS(FTR_CONFIG(CONFIG_ARM64_POE, VISIBLE, ALL_HIDDEN),
 		       FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64MMFR3_EL1_S1POE_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64MMFR3_EL1_S1PIE_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR3_EL1_SCTLRX_SHIFT, 4, 0),
-- 
2.47.3

