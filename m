Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 079C136CDE2
	for <kvmarm@lists.linux.dev>; Fri,  5 Sep 2025 14:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757082110; cv=none; b=ZCfO/HcYi8Vmc6Ueyaw7IUcMiCi7JGKfXlIkhQqxPfBnijeQQ3P6b7YXEmzQJBn1ugqdfbLIa/IawnIAZTJ/11ouONDpy3qjvzRifFPMM+Xs8YwiSv9OWwIqC++Eu0W7O47qtodOREWVbhuVagCxxDqa1vWQg82K0keAhJOvjZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757082110; c=relaxed/simple;
	bh=55uBsZB1md/Tazk+1w5pxVnebaodjxJ/PCqyjHao1i4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=T+u+B1/8lcsCO6KeLXysGPvAOUNqmrg8ZPchbtYx1d7/IDJjuIy6GbAi6BJZQyCqwECwzouu+cBgflSeB93FUyb1fiK97jfSY2H1sLtdEvtRkcA5yL6wwt0ywbBvlRXTW7pYQ35ASQblsFCXyTWmKFGfmo0G+RtVY+WzRTUh/yA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kvSb68wg; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kvSb68wg"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757082105;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ubv04+Za4XcjTywDEhBUkgQ8HI3GZfQeKq3U7VPz0QE=;
	b=kvSb68wg9h0bjd5qGJMOKTyu3/HfrSuz5fKHdU2M8q5IkCezsWdR0RbTBkvn14AP4cY7U8
	aF1lJHO3t3gIJ21h5wIMTlGexfjrN1zZHxLUqhzvtLW9ijERRKU6oQbNKc48YkSsZQ9c2I
	mZc7gHzYeudjMwA5PeaNAnHAKwHC+ck=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ben Horgan <ben.horgan@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 3/6] KVM: arm64: Spin off release helper from vgic_put_irq()
Date: Fri,  5 Sep 2025 03:05:28 -0700
Message-Id: <20250905100531.282980-4-oliver.upton@linux.dev>
In-Reply-To: <20250905100531.282980-1-oliver.upton@linux.dev>
References: <20250905100531.282980-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Spin off the release implementation from vgic_put_irq() to prepare for a
more involved fix for lock ordering such that it may be unnested from
raw spinlocks. This has the minor functional change of doing call_rcu()
behind the xa_lock although it shouldn't be consequential.

Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index a1d6fab895c4..ec4d70936a5b 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -114,22 +114,32 @@ struct vgic_irq *vgic_get_vcpu_irq(struct kvm_vcpu *vcpu, u32 intid)
 	return vgic_get_irq(vcpu->kvm, intid);
 }
 
+static void vgic_release_lpi_locked(struct vgic_dist *dist, struct vgic_irq *irq)
+{
+	lockdep_assert_held(&dist->lpi_xa.xa_lock);
+	__xa_erase(&dist->lpi_xa, irq->intid);
+	kfree_rcu(irq, rcu);
+}
+
+static __must_check bool __vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq)
+{
+	if (irq->intid < VGIC_MIN_LPI)
+		return false;
+
+	return refcount_dec_and_test(&irq->refcount);
+}
+
 void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
 	unsigned long flags;
 
-	if (irq->intid < VGIC_MIN_LPI)
-		return;
-
-	if (!refcount_dec_and_test(&irq->refcount))
+	if (!__vgic_put_irq(kvm, irq))
 		return;
 
 	xa_lock_irqsave(&dist->lpi_xa, flags);
-	__xa_erase(&dist->lpi_xa, irq->intid);
+	vgic_release_lpi_locked(dist, irq);
 	xa_unlock_irqrestore(&dist->lpi_xa, flags);
-
-	kfree_rcu(irq, rcu);
 }
 
 void vgic_flush_pending_lpis(struct kvm_vcpu *vcpu)
-- 
2.39.5

