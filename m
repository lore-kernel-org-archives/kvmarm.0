Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7598E318BB8;
	Thu,  2 Jul 2026 16:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783008184; cv=none; b=sbfSWrgwSvL8OisZghDPoQVAcg1gxPudlXAFQDLYicuZxfvaROi8SFiA2zw1eHfqhJzGy0RU0Os8842vYeA32c6MCGfwPWoMBGMeb6raz63b0gSyW1RacSylmBMYkA6AWjPu0q3+ZS8r9s7IVSU6/6h4Do7dlj1pZUnNUvC8ZZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783008184; c=relaxed/simple;
	bh=JZF1hmXV4cFDalm6HnT0iaROTVAoZE37X/FB0a36Uxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=et28wbxTJKFLNpCofkptcEl+l7kpaKvdWIOMZAuIKKLZd3+E49v2AR3qM+a/gEma+hy0DAA2CAilyl3AauZu+biintLTtxEfIsYTDMmyyIQg/WDaRXgLCWDBfV3vlW2YfQx0JWbaJMcOXZ1QGLP0LIcwORbm/9DjqwECAxrqAXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nCGDwg6i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nCGDwg6i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 502E11F00A3D;
	Thu,  2 Jul 2026 16:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783008182;
	bh=AhyYZoRfqIfREPPS8CErWw/Y/QryBhe2Y1Mvp9CHj5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nCGDwg6iioeowZpjTP2NcDBrG7S4z6F626DLFOOTNVR23dKxzR1AP23Xlvh3oc46I
	 LTUYvmwmLd1yTGErJCxXAyoO5xy+O6G5iyIFKhR6Jc0tlXsfv12gBgHUYVua1g8HxY
	 c0JKHXAvX5O5wWxpEc+VrFU5aPkckObYt5SXffTKFSphY2Qya6Uy+JbcURgZ0FfoyT
	 4BdZpCSJp9NUDiZgn0R38aTF3R4lbC9uJdEDalm2+0d41yzr8fujpZPpgOzrDwQzsw
	 xKQRSi5hf3RZg/Y6foPEYbTgSGy9ciV1FZXS3WUkyoflZBC9IsiYsrzErtYlUUqfHJ
	 Bfofy4PSKsnig==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wfJsS-00000000ojd-2EGx;
	Thu, 02 Jul 2026 16:03:00 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 12/28] arm64: Add FEAT_NV2p1 detection
Date: Thu,  2 Jul 2026 17:02:32 +0100
Message-ID: <20260702160248.1377250-13-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260702160248.1377250-1-maz@kernel.org>
References: <20260702160248.1377250-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Add the necessary NV2p1 probing to the cpufeature infrastructure.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kernel/cpufeature.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 9a22df0c5120f..c9c124b0ccc8e 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2620,6 +2620,13 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 			{ /* Sentinel */ }
 		},
 	},
+	{
+		.desc = "FEAT_NV2p1",
+		.capability = ARM64_HAS_NV2P1,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.matches = has_cpuid_feature,
+		ARM64_CPUID_FIELDS(ID_AA64MMFR4_EL1, NV_frac, NV2P1)
+	},
 	{
 		.capability = ARM64_HAS_32BIT_EL0_DO_NOT_USE,
 		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
-- 
2.47.3

