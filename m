Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FB7F32AAC5
	for <kvmarm@lists.linux.dev>; Wed, 15 Apr 2026 11:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776254182; cv=none; b=AYgNPVgl0r5F3qya4EhU1CfwDdq3sYLnfoHLUveLE26GZ+3zE90E7Txlo4KDGO/OznYvkT4xRH6L9nJ2vN0dLqMVeRwYiNkCuZPRjExJqGuUlKibIypaeyRKhtMfihmjPjkZ4skKxM+mlvdpFZX+K6b+jyEmRD0/DdNpA87X7z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776254182; c=relaxed/simple;
	bh=ciZEV3bdUIhbO6JXRIfwr1Ls+d1o4OxEStrk1ecfBEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lyaJUNdwblVgrnQ832otggouPg4aA79anm4NS7n9BD0xNSntVZ/Vz17XEkEBfXRrXzatq9cJUDwNAhkPChgvKfSUkngeGVq1fmqkfc+BL5wghTnvvW2jGK9umrYs0dndZMWUCZkIbBSIIvt4C3emoY9IYcI2uVe4/QVwCuH8qrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jUkzyCku; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jUkzyCku"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAED7C2BCB7;
	Wed, 15 Apr 2026 11:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776254182;
	bh=ciZEV3bdUIhbO6JXRIfwr1Ls+d1o4OxEStrk1ecfBEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jUkzyCkuyeWXJrd7wnZRRqvRtdX+lexgYqYJ7OjQRmh5BAkAmeZ17LMuabVc0B9xP
	 8dPwPIN+HLDCv8DLYupnFs4Dv8Tvi6F3qr76PdSmvzTuIUXkJAEob5TJbkQ9uNBcax
	 jY8bUqWzDE9gsC8HTmt3QgXDmYnCyeQ+SqDuOrT/Dz3zaJ309JK2SIj7IZ7jqsl7HA
	 g4eWGqScfFXYOUFbV0wC5V7uvnCZmvBsVq0ix3WUy+4tXjaB4GV1K0aw+Zcfz3Umaw
	 +72AJ11sK48OirLThanLeVNLm159TWjk4m+ByHT4zgA+8FP9T9PfFSEwoUbdv7AB1G
	 q8y8HA3COWsvg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wCyqx-0000000Bqsi-3wpH;
	Wed, 15 Apr 2026 11:56:20 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sascha Bischoff <sascha.bischoff@arm.com>
Subject: [PATCH 04/18] KVM: arm64: vgic-v5: Drop pointless ARM64_HAS_GICV5_CPUIF check
Date: Wed, 15 Apr 2026 12:55:45 +0100
Message-ID: <20260415115559.2227718-5-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260415115559.2227718-1-maz@kernel.org>
References: <20260415115559.2227718-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, sascha.bischoff@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

vgic_v5_get_implemented_ppis() can only be called when we have
a GICv5, by construction.

Remove the pointless check against ARM64_HAS_GICV5_CPUIF.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-v5.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 4d62b1c31fe8b..0101ec3f55283 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -18,9 +18,6 @@
  */
 static void vgic_v5_get_implemented_ppis(void)
 {
-	if (!cpus_have_final_cap(ARM64_HAS_GICV5_CPUIF))
-		return;
-
 	/*
 	 * If we have KVM, we have EL2, which means that we have support for the
 	 * EL1 and EL2 Physical & Virtual timers.
-- 
2.47.3

