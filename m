Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67A55131E53
	for <kvmarm@lists.linux.dev>; Wed, 24 Jan 2024 20:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706129384; cv=none; b=FlZqjTisfRK+FpqC+KB8w1XWRiz8xkThwAv79Xufid7GS0OuYaNmAUEmX9uOaMkQE/nwWjl+2VvkVq+FqIHdgN9S0/zsnNpP3lAgS1bFW7qaTOmjK7Kv/MF7VxN40M6rqiKzGX8toSVJYW2ywMdy1l+thigISIS8YgTEe3gBJzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706129384; c=relaxed/simple;
	bh=zn+NEwCWV2J3fnlNAv5UMIsfb2daqDGOeyb3cOTr5Hs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eS8ldBIWMlVa0LwqHHQCsGU3EPnhhYMXfkRSVmuI/a2CvkssRPhj2ti7+NCYLY/9mTTPJ0LIG3pYo07p1Rqj4mHoMPNCL0cc+Uho5H+zItN6Mn24fRChtIXKgCsdnod/7LARoP9pssfTZ3rX9lcZI9fEsBYNrbKHgK1BisO90yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=oOIhrA5D; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="oOIhrA5D"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706129380;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JSRHFG0+mRsPGBx4WvzyykyzgB4/zirusbi7pLa/qNU=;
	b=oOIhrA5D3lJg4GSUFQDL3QLVro9vo0pypba9bifO/3h2NcrwEERhgaf/6BMGpVfhsyoAK1
	LTDWMeu5jXahn7CDfs2JTb8E1TK3eoWSN+PggYvbylA1EAMAXbErepMD7O34yeg4Nwezip
	TViXME2XGctJrav32UkOpVt4lfq8wbk=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Jing Zhang <jingzhangos@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 10/15] KVM: arm64: vgic: Don't acquire the lpi_list_lock in vgic_put_irq()
Date: Wed, 24 Jan 2024 20:49:04 +0000
Message-ID: <20240124204909.105952-11-oliver.upton@linux.dev>
In-Reply-To: <20240124204909.105952-1-oliver.upton@linux.dev>
References: <20240124204909.105952-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The LPI xarray's xa_lock is sufficient for synchronizing writers when
freeing a given LPI. Furthermore, readers can only take a new reference
on an IRQ if it was already nonzero.

Stop taking the lpi_list_lock unnecessarily and get rid of
__vgic_put_lpi_locked().

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-its.c |  4 ++--
 arch/arm64/kvm/vgic/vgic.c     | 21 ++++-----------------
 arch/arm64/kvm/vgic/vgic.h     |  1 -
 3 files changed, 6 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 7219f4a0a93d..8c026a530018 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -645,7 +645,7 @@ static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
 	 * was in the cache, and increment it on the new interrupt.
 	 */
 	if (cte->irq)
-		__vgic_put_lpi_locked(kvm, cte->irq);
+		vgic_put_irq(kvm, cte->irq);
 
 	/*
 	 * The irq refcount is guaranteed to be nonzero while holding the
@@ -682,7 +682,7 @@ void vgic_its_invalidate_cache(struct kvm *kvm)
 		if (!cte->irq)
 			break;
 
-		__vgic_put_lpi_locked(kvm, cte->irq);
+		vgic_put_irq(kvm, cte->irq);
 		cte->irq = NULL;
 	}
 
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 7e0d84906a12..6b8f440ca0fd 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -110,13 +110,13 @@ static void vgic_irq_release(struct kref *ref)
 {
 }
 
-/*
- * Drop the refcount on the LPI. Must be called with lpi_list_lock held.
- */
-void __vgic_put_lpi_locked(struct kvm *kvm, struct vgic_irq *irq)
+void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
 
+	if (irq->intid < VGIC_MIN_LPI)
+		return;
+
 	if (!kref_put(&irq->refcount, vgic_irq_release))
 		return;
 
@@ -126,19 +126,6 @@ void __vgic_put_lpi_locked(struct kvm *kvm, struct vgic_irq *irq)
 	kfree_rcu(irq, rcu);
 }
 
-void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq)
-{
-	struct vgic_dist *dist = &kvm->arch.vgic;
-	unsigned long flags;
-
-	if (irq->intid < VGIC_MIN_LPI)
-		return;
-
-	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);
-	__vgic_put_lpi_locked(kvm, irq);
-	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
-}
-
 void vgic_flush_pending_lpis(struct kvm_vcpu *vcpu)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 20886f57416a..b0a2754eae93 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -180,7 +180,6 @@ vgic_get_mmio_region(struct kvm_vcpu *vcpu, struct vgic_io_device *iodev,
 		     gpa_t addr, int len);
 struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
 			      u32 intid);
-void __vgic_put_lpi_locked(struct kvm *kvm, struct vgic_irq *irq);
 void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq);
 bool vgic_get_phys_line_level(struct vgic_irq *irq);
 void vgic_irq_set_phys_pending(struct vgic_irq *irq, bool pending);
-- 
2.43.0.429.g432eaa2c6b-goog

