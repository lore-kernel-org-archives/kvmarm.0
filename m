Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BF4C3F7AA0;
	Wed,  1 Apr 2026 10:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775039794; cv=none; b=MGYG+BOLqOoDyeKUGJVkQilBvuHSBlFBBsAmUjQl3XJA7NrYYf+FAtS4Ep/bYJP0CIHBwltU+FCExJYP3AnpHlRa5p2DVttH/khpqFo9pU+mXT5x7eUECD2SebXMqGKSpfFcNEV8OACeeeNe+OoI5UEm7lhLBk/DAj7crFFkw8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775039794; c=relaxed/simple;
	bh=u28flmvfVSoY5WGICQjmC96Uju6XrphbLe7PuSo52T0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KjDdq871O0Y1rh3KLFL2PgO9j8Wtg6knL9H3yvy8PlNK1Mnm6hBIgkwbfFvVugeVhL5I1vvhOcwuOSEfCC3Ai5iyaNiHnjkbq8p96R6S13HF2p+E6x+f2HQhCxmH2Go/MKurw8edtO8L4cCg7dn41+nG+d5tVDzwIjtrBiJw1PU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=elt7qCMR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="elt7qCMR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DB13C2BCB4;
	Wed,  1 Apr 2026 10:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775039794;
	bh=u28flmvfVSoY5WGICQjmC96Uju6XrphbLe7PuSo52T0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=elt7qCMR3qVxj3RtKj0rM7ZVy9Jg2NPbEtSyZ7n2U/QotZu+EjEZq29KfhFKGu2K9
	 T10ieEKMaY+f4MolbnDyVJnygPvXdetRuiwmYSYyEs6YvGoyRTbYYjemuV9GJEz1WG
	 HRYstlrK4EpoMfiQDfKPtWmuU8RpeM4NiGzrWvR28Tb9wWfRulUKd/hSn9xzzcK3D5
	 ZxrNy8+aghDruPKfj+pKzmLiB05XZnGZOzMUuhxS2/22FXGNM7Aduv06yOz3fcwgpr
	 Kr25Fgq+TV3plpfGyM31N4584p94mAZxCcV78hJKsMBIz/Q9XQCTxlvguvnXl/B1Xo
	 ZFKz5icKJJZVQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w7sw4-00000007oRQ-1Enw;
	Wed, 01 Apr 2026 10:36:32 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sascha Bischoff <sascha.bischoff@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v2 14/16] KVM: arm64: Correctly plumb ID_AA64PFR2_EL1 into pkvm idreg handling
Date: Wed,  1 Apr 2026 11:36:09 +0100
Message-ID: <20260401103611.357092-15-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260401103611.357092-1-maz@kernel.org>
References: <20260401103611.357092-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, sascha.bischoff@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

While we now compute ID_AA64PFR2_EL1 to a glorious 0, we never use
that data and instead return the 0 that corresponds to an allocated
idreg. Not a big deal, but we might as well be consistent.

Reviewed-by: Sascha Bischoff <sascha.bischoff@arm.com>
Fixes: 5aefaf11f9af5 ("KVM: arm64: gic: Hide GICv5 for protected guests")
Link: https://sashiko.dev/#/patchset/20260319154937.3619520-1-sascha.bischoff%40arm.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/sys_regs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index b40fd01ebf329..be6f420388a14 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -439,7 +439,7 @@ static const struct sys_reg_desc pvm_sys_reg_descs[] = {
 	/* CRm=4 */
 	AARCH64(SYS_ID_AA64PFR0_EL1),
 	AARCH64(SYS_ID_AA64PFR1_EL1),
-	ID_UNALLOCATED(4,2),
+	AARCH64(SYS_ID_AA64PFR2_EL1),
 	ID_UNALLOCATED(4,3),
 	AARCH64(SYS_ID_AA64ZFR0_EL1),
 	ID_UNALLOCATED(4,5),
-- 
2.47.3

