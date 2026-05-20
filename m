Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 614C73BED7E
	for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 09:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779268816; cv=none; b=Dh100w4j68JBV0Pvc57Z5DuCp4MfY65Jkcw9WmS76xZh345KOuzSXV0Ay6ohpv/fDY7el1c2Rc8cNaOuz/TTtgZ7GoqOIEKQDMoQduG51IEDv/tgnVBc2inAgeEtgDRXX+rjhXd9zcqNRdO06REvBeLmiMdzC2xHRiTBAGgtIMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779268816; c=relaxed/simple;
	bh=3GpnxZCnP3owOfN9/6GKMUYj5IThL0sP1V0fxRFMcbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DxDJ7OxzhlcaCtqRl8GqPWG2BqAyGfaCysNF2iMPpFGpo4+5ADdHcI2r8e+JftwEPOWeeYbRJwDmAhRzPXsnRRLkSYFjWdSb1uTyFjfkzOwL84Dm3aUsZ7k0weglBFRVoNM+4m774D5+kJVTaedGixN3FzOQvtFIsXgscqFGQ54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FJJHQXUm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FJJHQXUm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 589BD1F0089C;
	Wed, 20 May 2026 09:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779268813;
	bh=Yp8TJvgYk4dUAnyYuq90MCPQ++6cQcyfGHV+/YigiLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FJJHQXUmD+Y82FRqKen8WEDYl5pm32pATNjpbfiuvDZS3JzftrEIqvSv35iSNJ5hR
	 qaE5yfKKCRXlL4N1pyxhxMqrEUCSG2cUA8eR0BaA49+s6lmVzdvlN8CV239dbduMTp
	 KTh5CLGmCoa7UQ3+AqubeIAOccmZ8jm27YXCM2mIcfRLnler2rHV+zxitodRJv9yfB
	 aDYg2GCPdXoGaxFpWkuE0eb6Z+69cwwd/++6WrXpkdtZ5wShCegNXis4y+NIeL8BIN
	 2ZgC1LrAQY5HBQOHlVuSWfOx4V4/9zDd3kF71lV3aRZvkBVKYJwhXZw2N5iFL+zJ7G
	 IRP0/vjSnCfxw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wPd63-00000004IaV-2emc;
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
Subject: [PATCH v2 07/18] KVM: arm64: vgic-v5: Drop defensive checks from vgic_v5_ppi_queue_irq_unlock()
Date: Wed, 20 May 2026 10:19:38 +0100
Message-ID: <20260520091949.542365-8-maz@kernel.org>
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

vgic_v5_ppi_queue_irq_unlock() performs a bunch of sanity checks
that are pretty pointless as there is no code path that can
result in these invariants to be violated. And if they are, a nice
crash is just as instructive than a warning.

Drop what is evidently debug code and simplify the whole thing.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-v5.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 757484d2493b2..7916bd8d564ef 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -238,9 +238,9 @@ static u32 vgic_v5_get_effective_priority_mask(struct kvm_vcpu *vcpu)
 
 /*
  * For GICv5, the PPIs are mostly directly managed by the hardware. We (the
- * hypervisor) handle the pending, active, enable state save/restore, but don't
- * need the PPIs to be queued on a per-VCPU AP list. Therefore, sanity check the
- * state, unlock, and return.
+ * hypervisor) handle the pending, active, enable state save/restore, but
+ * don't need the PPIs to be queued on a per-VCPU AP list. Therefore,
+ * unlock, kick the vcpu and return.
  */
 bool vgic_v5_ppi_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq,
 				  unsigned long flags)
@@ -250,12 +250,7 @@ bool vgic_v5_ppi_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq,
 
 	lockdep_assert_held(&irq->irq_lock);
 
-	if (WARN_ON_ONCE(!__irq_is_ppi(KVM_DEV_TYPE_ARM_VGIC_V5, irq->intid)))
-		goto out_unlock_fail;
-
 	vcpu = irq->target_vcpu;
-	if (WARN_ON_ONCE(!vcpu))
-		goto out_unlock_fail;
 
 	raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
 
@@ -264,11 +259,6 @@ bool vgic_v5_ppi_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq,
 	kvm_vcpu_kick(vcpu);
 
 	return true;
-
-out_unlock_fail:
-	raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
-
-	return false;
 }
 
 /*
-- 
2.47.3

