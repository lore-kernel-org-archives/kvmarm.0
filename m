Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D05432BAE6
	for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 22:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713566373; cv=none; b=ur4eTFJCdJxnSwQoJzTtQkrUQlkMJcRmHeSdZwHQpBJKVHnlh5vhpF4pgjuakTKGSD8pR+fTue/5fTz9GllsQuxl8CTv9TOGZEfZiaNDBhF7Ofem1ByFsczu+IZJNOpE2esmPcFwvpcqiq7Pau96UE7Pd4E3slNTV7y5WqGhrR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713566373; c=relaxed/simple;
	bh=fdo8/lJOkW/4zB7Gw653yGNrR4LG6EbqCwLN24xB7vU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uKjWm1Wl7Xs2inf4c4zAot9kZTlQaH1mg6ukXIWeuOAKQT434XTktmKyHRZq6Yyz7EkqGemVouWUFnoPPR3xYoOwjM5CADWOmFiOAeOOWx+H2aGZDZxTZFGnnkSDvY53GiAv7zSxDiGAKsnjHmPCeuwEtwzz2j7XUMgo3hUvFBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RqsrpGOV; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RqsrpGOV"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1713566370;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iaI3NoH2waGkYo08H+XxFK0Z1rT4oTp2Sn+doSLQWbY=;
	b=RqsrpGOVq7uiQp86TTB36AeTgkEG6qNirRSUn3q9EkkiuAo6iHN73qRVyLctDnlGxnctWT
	aal6wR3I6nBI3oK6HiydRC/yrbFSPg4uD1a08xDi0XmTk/puLJVqc9z+YZFgXKU3sHzokx
	HNGsBV9i0rA1E2aMriBAnZWB3eddiFk=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 12/19] KVM: arm64: vgic-its: Get rid of the lpi_list_lock
Date: Fri, 19 Apr 2024 22:38:35 +0000
Message-ID: <20240419223842.951452-13-oliver.upton@linux.dev>
In-Reply-To: <20240419223842.951452-1-oliver.upton@linux.dev>
References: <20240419223842.951452-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The last genuine use case for the lpi_list_lock was the global LPI
translation cache, which has been removed in favor of a per-ITS xarray.
Remove a layer from the locking puzzle by getting rid of it.

vgic_add_lpi() still has a critical section that needs to protect
against the insertion of other LPIs; change it to take the LPI xarray's
xa_lock to retain this property.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-init.c |  1 -
 arch/arm64/kvm/vgic/vgic-its.c  | 17 ++++++-----------
 arch/arm64/kvm/vgic/vgic.c      |  5 ++---
 include/kvm/arm_vgic.h          |  3 ---
 4 files changed, 8 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 6ee42f395253..aee6083d0da6 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -53,7 +53,6 @@ void kvm_vgic_early_init(struct kvm *kvm)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
 
-	raw_spin_lock_init(&dist->lpi_list_lock);
 	xa_init_flags(&dist->lpi_xa, XA_FLAGS_LOCK_IRQ);
 }
 
diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index f0287414fa75..be364a8d14a6 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -69,7 +69,7 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
 	irq->target_vcpu = vcpu;
 	irq->group = 1;
 
-	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);
+	xa_lock_irqsave(&dist->lpi_xa, flags);
 
 	/*
 	 * There could be a race with another vgic_add_lpi(), so we need to
@@ -84,14 +84,14 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
 		goto out_unlock;
 	}
 
-	ret = xa_err(xa_store(&dist->lpi_xa, intid, irq, 0));
+	ret = xa_err(__xa_store(&dist->lpi_xa, intid, irq, 0));
 	if (ret) {
 		xa_release(&dist->lpi_xa, intid);
 		kfree(irq);
 	}
 
 out_unlock:
-	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
+	xa_unlock_irqrestore(&dist->lpi_xa, flags);
 
 	if (ret)
 		return ERR_PTR(ret);
@@ -543,11 +543,8 @@ static struct vgic_irq *__vgic_its_check_cache(struct kvm *kvm, phys_addr_t db,
 static struct vgic_irq *vgic_its_check_cache(struct kvm *kvm, phys_addr_t db,
 					     u32 devid, u32 eventid)
 {
-	struct vgic_dist *dist = &kvm->arch.vgic;
 	struct vgic_irq *irq;
-	unsigned long flags;
 
-	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);
 	rcu_read_lock();
 
 	irq = __vgic_its_check_cache(kvm, db, devid, eventid);
@@ -555,7 +552,6 @@ static struct vgic_irq *vgic_its_check_cache(struct kvm *kvm, phys_addr_t db,
 		irq = NULL;
 
 	rcu_read_unlock();
-	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
 
 	return irq;
 }
@@ -565,7 +561,6 @@ static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
 				       struct vgic_irq *irq)
 {
 	unsigned long cache_key = vgic_its_cache_key(devid, eventid);
-	struct vgic_dist *dist = &kvm->arch.vgic;
 	unsigned long flags;
 	phys_addr_t db;
 
@@ -576,7 +571,7 @@ static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
 	if (xa_reserve_irq(&its->translation_cache, cache_key, GFP_KERNEL_ACCOUNT))
 		return;
 
-	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);
+	xa_lock_irqsave(&its->translation_cache, flags);
 	rcu_read_lock();
 
 	/*
@@ -595,10 +590,10 @@ static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
 	lockdep_assert_held(&its->its_lock);
 	vgic_get_irq_kref(irq);
 
-	xa_store(&its->translation_cache, cache_key, irq, 0);
+	__xa_store(&its->translation_cache, cache_key, irq, 0);
 out:
 	rcu_read_unlock();
-	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
+	xa_unlock_irqrestore(&its->translation_cache, flags);
 }
 
 static void vgic_its_invalidate_cache(struct vgic_its *its)
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index e3ee1bc1214a..d0c59b51a6b0 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -29,9 +29,8 @@ struct vgic_global kvm_vgic_global_state __ro_after_init = {
  *       its->cmd_lock (mutex)
  *         its->its_lock (mutex)
  *           vgic_cpu->ap_list_lock		must be taken with IRQs disabled
- *             kvm->lpi_list_lock		must be taken with IRQs disabled
- *               vgic_dist->lpi_xa.xa_lock	must be taken with IRQs disabled
- *                 vgic_irq->irq_lock		must be taken with IRQs disabled
+ *             vgic_dist->lpi_xa.xa_lock	must be taken with IRQs disabled
+ *               vgic_irq->irq_lock		must be taken with IRQs disabled
  *
  * As the ap_list_lock might be taken from the timer interrupt handler,
  * we have to disable IRQs before taking this lock and everything lower
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 276082db9ae6..493b1f1c6bf7 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -280,9 +280,6 @@ struct vgic_dist {
 	 */
 	u64			propbaser;
 
-	/* Protects the lpi_list. */
-	raw_spinlock_t		lpi_list_lock;
-
 #define LPI_XA_MARK_DEBUG_ITER	XA_MARK_0
 	struct xarray		lpi_xa;
 
-- 
2.44.0.769.g3c40516874-goog

