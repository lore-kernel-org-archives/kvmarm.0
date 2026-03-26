Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CEA64070F7;
	Thu, 26 Mar 2026 15:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774539339; cv=none; b=gEW7v+RWMvaxn96WzbNz8QHln9goDb0nIYvwkbX/u6AfgRLWTayl/Dq04cMoCqNsyA6F10l7dC9qxUuDWVFCYy6swvD6i02UYrYSbNFnsXvsfq66jcDSpTDUFB3AAvR1NiuCzxQpUxP/MSeWaAt//Q4Ex5grHrXiTHDIE/rbhtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774539339; c=relaxed/simple;
	bh=ySmf95sCaTpuq/j9vN9jvDmawClA6Um8zHS+321vTh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t9sl5RgrEZyNzwQpJJFZvG9hWecLKKCp14roOjagAecqRzYDTvhxz5zK2gTwUaxteKRSsd7poMK9gzbVm83c0+q3E8w2rs9wnMYJY9VEmtgvAq71+DIyQNK3apJPeXfcBfq6nVu/OrnmTAPOS1gqqJ0k68jjROUYNllt3alURuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i3ogVYIj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i3ogVYIj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5627BC2BCB1;
	Thu, 26 Mar 2026 15:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774539339;
	bh=ySmf95sCaTpuq/j9vN9jvDmawClA6Um8zHS+321vTh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i3ogVYIjI+opMtjyUhFsPrwJY/E0Jo2tshdeGkkpkK9eAQXtBn5EiYlNetxQj4v/q
	 6bTbGiv5RyLCQvf6igSxJ/bceKmXpxjPuB61ffGCvsn8ZecE+cKIjHgEVsa4dmYElu
	 qPzLSZWPlJCGuGT8Dd80YTuGDXkcdUUSo/mEjrzhjwUbnz2o9AiQZhZhKys9WO/Jhs
	 oJOjD84zAUMvNgEHu5eUcSrxJgruHkC0e7G1yCzXtjn9J1tFrlglCeQHPEI9z+1zYo
	 RvTFu4YFZqIQx1Kio6JSraN/nlaShr5RJaZ9VViScaA83cKBGwp1GcklJGDhpvzj46
	 3VBJFoWtvU6bA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w5mkD-000000060II-2FwC;
	Thu, 26 Mar 2026 15:35:37 +0000
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
Subject: [PATCH 15/15] KVM: arm64: Don't advertises GICv3 in ID_PFR1_EL1 if AArch32 isn't supported
Date: Thu, 26 Mar 2026 15:35:30 +0000
Message-ID: <20260326153530.3981879-16-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260326153530.3981879-1-maz@kernel.org>
References: <20260326153530.3981879-1-maz@kernel.org>
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

Although the AArch32 ID regs are architecturally UNKNOWN when AArch32
isn't supported at any EL, KVM makes a point in making them RAZ.

Therefore, advertising GICv3 in ID_PFR1_EL1 must be gated on AArch32
being supported at least at EL0.

Fixes: a258a383b9177 ("KVM: arm64: gic-v5: Sanitize ID_AA64PFR2_EL1.GCIE")
Reported-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-init.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index ecb0aea180327..5c684ecf79e66 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -700,7 +700,8 @@ void kvm_vgic_finalize_idregs(struct kvm *kvm)
 		break;
 	case KVM_DEV_TYPE_ARM_VGIC_V3:
 		aa64pfr0 |= SYS_FIELD_PREP_ENUM(ID_AA64PFR0_EL1, GIC, IMP);
-		pfr1 |= SYS_FIELD_PREP_ENUM(ID_PFR1_EL1, GIC, GICv3);
+		if (kvm_supports_32bit_el0())
+			pfr1 |= SYS_FIELD_PREP_ENUM(ID_PFR1_EL1, GIC, GICv3);
 		break;
 	case KVM_DEV_TYPE_ARM_VGIC_V5:
 		aa64pfr2 |= SYS_FIELD_PREP_ENUM(ID_AA64PFR2_EL1, GCIE, IMP);
-- 
2.47.3

