Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABBD137CD29
	for <kvmarm@lists.linux.dev>; Wed, 15 Apr 2026 11:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776254182; cv=none; b=ibKD6b782m9lb2GMmDKc4YPWnXWCsynmDXmw87nYMhI319Z0FrkMHaGpwCxq29QNoG3mQg+3RM55HEoB9UwhgeX6zOtGXewlFRSaKwYvxM5Oj8eedC7OA8VCHrv0LPRDtF9gzD09EC5QwIAuZjuZQn9i35EFYLs/zeufb27gjKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776254182; c=relaxed/simple;
	bh=3GpnxZCnP3owOfN9/6GKMUYj5IThL0sP1V0fxRFMcbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iBDzEIzxPYfPyY2LKvOQD+uThttRPEFnWIfL7WBpDkMviho2mHCiK+cwvHoHL6cxSMLdJrkqvIc3SLzRyW8XY+Jgbmy9q9mzfId53mIuGcLw3c8U4x///bQEntH8jHvWu9S0TdId0Ccyqhpj/DhUb2cWeVZ3gpG09Qke6aGif10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d2njVw4e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d2njVw4e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D139C19424;
	Wed, 15 Apr 2026 11:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776254182;
	bh=3GpnxZCnP3owOfN9/6GKMUYj5IThL0sP1V0fxRFMcbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d2njVw4eigEg9mSxeee0opXf34CTcAMoiv2SoqtfnusruC1h+FMMYjRudo/EuBFmS
	 N7ZXRYq7/Yx1vHnepMZflfLV28RPN8VYv/MSTH1Ks0DSiRlXxiYbdOZTjKh21ASQ4I
	 Tqw4uOO+t0JcdVpasjEvKzOS5OiJ1IJF2msPy972KEM4EKphtv/6kcq+t1ihlvlc0J
	 rJOeLRyv5nfdmWj6wXjE3F3kGYvvZ5ETHuNdJwkTY87Zhxx1+R3uYiiOKBMQl/emkQ
	 FC00cF5BrqKLVp8SKSVXUAV8OkFl02xT/dxIqY1oGyJg1Y4mcUuP9To6Wuy7nOzXwK
	 zE10jILtfiauA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wCyqy-0000000Bqsi-2DGS;
	Wed, 15 Apr 2026 11:56:20 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sascha Bischoff <sascha.bischoff@arm.com>
Subject: [PATCH 07/18] KVM: arm64: vgic-v5: Drop defensive checks from vgic_v5_ppi_queue_irq_unlock()
Date: Wed, 15 Apr 2026 12:55:48 +0100
Message-ID: <20260415115559.2227718-8-maz@kernel.org>
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

