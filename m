Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9DAD3BED4A
	for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 09:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779268814; cv=none; b=KmZbn0eDFoF+LhFew/EhSa20Mp0bXNPBvTJ0SEePh2CU8PIZUqdb9ZmqoIhrQAkDiRu6T/8O8QfaO8EkpJ35YQYrvHXsNkrVbBzc8lgtHjwCQucnUTxkAPVwWz5YIM8KnJbVdMjQ762+ul7ngensSkmn4+s+wVfqvd/aJyWro5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779268814; c=relaxed/simple;
	bh=ciZEV3bdUIhbO6JXRIfwr1Ls+d1o4OxEStrk1ecfBEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a4W0HQHSpcBN/IoDyM0cYcy3pUdt+NMITL4JJ9wLKIzGm1xVJ3vdct6Wgt0E+osyv9cqD2XOa3uIc+c2JUAQlbyfdRcO/Mym9qLmoo2v6G8EpkmfkiSK3AwrrHr0yC6UlgLiJz7DFBq3z2sEUuICHGlc+W7IE4RD+2GdIRrq39w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FHXlUFiy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FHXlUFiy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0B491F00896;
	Wed, 20 May 2026 09:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779268812;
	bh=PfYfEUmSJJu99KFkME4QJcDO9qLVgas+BeL74XBcbcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FHXlUFiy7h8ZDtjBYutiTRQH/JGcB8N+40Nyh+N1/RKip39QIEes+m3sz8mxNibcV
	 i9o53ToA+5yUgUr9x6cGAQbhyZsysQ8TnRVmklMFfdFNbkAeum8J0ljeRU2YSyUbAR
	 qBwrpudcNdk8+ZvMuKhp7r6+8EMOMnKW32VNfhf7omauJF0uvdtFr69/Rq3jZPRM0Z
	 XbZjIyvwi6Lubtj+INeyrcHZEhpFnnzF7PzIbQzbPoku6z9WTVNSPz1F99fQnIJtbh
	 //heNy+RDJrfp9NFSkHMBWpuQU7ctjht1ZjnNga1aCtsXEZfCsumg9iZY3H4cCiK2Z
	 tSass20ifJwFQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wPd62-00000004IaV-4AW1;
	Wed, 20 May 2026 09:20:11 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sascha Bischoff <sascha.bischoff@arm.com>
Subject: [PATCH v2 04/18] KVM: arm64: vgic-v5: Drop pointless ARM64_HAS_GICV5_CPUIF check
Date: Wed, 20 May 2026 10:19:35 +0100
Message-ID: <20260520091949.542365-5-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260520091949.542365-1-maz@kernel.org>
References: <20260520091949.542365-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, sascha.bischoff@arm.com
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

