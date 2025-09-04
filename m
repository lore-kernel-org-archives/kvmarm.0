Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31E6A29B8C2
	for <kvmarm@lists.linux.dev>; Thu,  4 Sep 2025 07:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756970914; cv=none; b=QobzfziuKxP4Q4Q1vvKIGtYY5pcQ1Gu1iNfQOU8n0fH8TbNr3yWc5d3ESvRPyyHmhikedInUZv6gdrx9evRbC9is/aZTbkgvuWw3gBkXJ4pr1PS9EJUn3pEcNbo90PmSnvhxY5YqDhPbhc0ipTxMkm15iTfbs2fYl6q46UUTA2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756970914; c=relaxed/simple;
	bh=qsd5+9IIvFzI4EFQ7XtANuAzs1cUdN3Y296M96sLMFI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QEuGVBJtnyUgJjf6E4Qb5vIbiPxoPqnvdwhHfiYs091kX0yJZ4I175Zr+Fs1PL90AaphMk/Vb1On2YSLllGUKEJRs4zVvgT8nJjHQSr/fMglgy++wYU7X+EirQKXvi5AqPzongPSj6ST9dhIPTnZULmcvs4U/hRM9GcxkdyaS2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jQWusyyK; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jQWusyyK"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756970908;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g1qicmn+DwaMBtIDCnzmRoebGKk4Po4de/YdJ3+9VAE=;
	b=jQWusyyK3XxSXFY7unKiWR+6XEl4ZNGDMnEaCzMUSrf9EG/0hNeuBUe3WphUygVWvGq8s3
	aD1Gd2zZjuI7fsLkZGQG63Sa/1wrGVPaMm9mjoA38qkumS328NmmleCK++98QuJFJaF2up
	lgaCufpBiPVhqChKhOLFsU+MZJ4sGbM=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 1/5] KVM: arm64: vgic-v3: Use bare refcount for VGIC LPIs
Date: Wed,  3 Sep 2025 23:23:44 -0700
Message-Id: <20250904062348.223976-2-oliver.upton@linux.dev>
In-Reply-To: <20250904062348.223976-1-oliver.upton@linux.dev>
References: <20250904062348.223976-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

KVM's use of krefs to manage LPIs isn't adding much, especially
considering vgic_irq_release() is a noop due to the lack of sufficient
context.

Switch to using a regular refcount in anticipation of adding a
meaningful release concept for LPIs.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-debug.c |  2 +-
 arch/arm64/kvm/vgic/vgic-init.c  |  4 ++--
 arch/arm64/kvm/vgic/vgic-its.c   |  8 ++++----
 arch/arm64/kvm/vgic/vgic-v4.c    |  2 +-
 arch/arm64/kvm/vgic/vgic.c       | 17 ++++-------------
 arch/arm64/kvm/vgic/vgic.h       |  8 ++++----
 include/kvm/arm_vgic.h           |  4 ++--
 7 files changed, 18 insertions(+), 27 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-debug.c b/arch/arm64/kvm/vgic/vgic-debug.c
index 2684f273d9e1..4c1209261b65 100644
--- a/arch/arm64/kvm/vgic/vgic-debug.c
+++ b/arch/arm64/kvm/vgic/vgic-debug.c
@@ -69,7 +69,7 @@ static int iter_mark_lpis(struct kvm *kvm)
 	int nr_lpis = 0;
 
 	xa_for_each(&dist->lpi_xa, intid, irq) {
-		if (!vgic_try_get_irq_kref(irq))
+		if (!vgic_try_get_irq_ref(irq))
 			continue;
 
 		xa_set_mark(&dist->lpi_xa, intid, LPI_XA_MARK_DEBUG_ITER);
diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 1e680ad6e863..4c777136ea5f 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -208,7 +208,7 @@ static int kvm_vgic_dist_init(struct kvm *kvm, unsigned int nr_spis)
 		raw_spin_lock_init(&irq->irq_lock);
 		irq->vcpu = NULL;
 		irq->target_vcpu = vcpu0;
-		kref_init(&irq->refcount);
+		refcount_set(&irq->refcount, 0);
 		switch (dist->vgic_model) {
 		case KVM_DEV_TYPE_ARM_VGIC_V2:
 			irq->targets = 0;
@@ -277,7 +277,7 @@ static int vgic_allocate_private_irqs_locked(struct kvm_vcpu *vcpu, u32 type)
 		irq->intid = i;
 		irq->vcpu = NULL;
 		irq->target_vcpu = vcpu;
-		kref_init(&irq->refcount);
+		refcount_set(&irq->refcount, 0);
 		if (vgic_irq_is_sgi(i)) {
 			/* SGIs */
 			irq->enabled = 1;
diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 7368c13f16b7..f162206adb48 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -99,7 +99,7 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
 	raw_spin_lock_init(&irq->irq_lock);
 
 	irq->config = VGIC_CONFIG_EDGE;
-	kref_init(&irq->refcount);
+	refcount_set(&irq->refcount, 1);
 	irq->intid = intid;
 	irq->target_vcpu = vcpu;
 	irq->group = 1;
@@ -111,7 +111,7 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
 	 * check that we don't add a second list entry with the same LPI.
 	 */
 	oldirq = xa_load(&dist->lpi_xa, intid);
-	if (vgic_try_get_irq_kref(oldirq)) {
+	if (vgic_try_get_irq_ref(oldirq)) {
 		/* Someone was faster with adding this LPI, lets use that. */
 		kfree(irq);
 		irq = oldirq;
@@ -547,7 +547,7 @@ static struct vgic_irq *vgic_its_check_cache(struct kvm *kvm, phys_addr_t db,
 	rcu_read_lock();
 
 	irq = xa_load(&its->translation_cache, cache_key);
-	if (!vgic_try_get_irq_kref(irq))
+	if (!vgic_try_get_irq_ref(irq))
 		irq = NULL;
 
 	rcu_read_unlock();
@@ -571,7 +571,7 @@ static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
 	 * its_lock, as the ITE (and the reference it holds) cannot be freed.
 	 */
 	lockdep_assert_held(&its->its_lock);
-	vgic_get_irq_kref(irq);
+	vgic_get_irq_ref(irq);
 
 	old = xa_store(&its->translation_cache, cache_key, irq, GFP_KERNEL_ACCOUNT);
 
diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
index 4d9343d2b0b1..548aec9d5a72 100644
--- a/arch/arm64/kvm/vgic/vgic-v4.c
+++ b/arch/arm64/kvm/vgic/vgic-v4.c
@@ -518,7 +518,7 @@ static struct vgic_irq *__vgic_host_irq_get_vlpi(struct kvm *kvm, int host_irq)
 		if (!irq->hw || irq->host_irq != host_irq)
 			continue;
 
-		if (!vgic_try_get_irq_kref(irq))
+		if (!vgic_try_get_irq_ref(irq))
 			return NULL;
 
 		return irq;
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index f5148b38120a..a1d6fab895c4 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -71,7 +71,7 @@ static struct vgic_irq *vgic_get_lpi(struct kvm *kvm, u32 intid)
 	rcu_read_lock();
 
 	irq = xa_load(&dist->lpi_xa, intid);
-	if (!vgic_try_get_irq_kref(irq))
+	if (!vgic_try_get_irq_ref(irq))
 		irq = NULL;
 
 	rcu_read_unlock();
@@ -114,15 +114,6 @@ struct vgic_irq *vgic_get_vcpu_irq(struct kvm_vcpu *vcpu, u32 intid)
 	return vgic_get_irq(vcpu->kvm, intid);
 }
 
-/*
- * We can't do anything in here, because we lack the kvm pointer to
- * lock and remove the item from the lpi_list. So we keep this function
- * empty and use the return value of kref_put() to trigger the freeing.
- */
-static void vgic_irq_release(struct kref *ref)
-{
-}
-
 void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
@@ -131,7 +122,7 @@ void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq)
 	if (irq->intid < VGIC_MIN_LPI)
 		return;
 
-	if (!kref_put(&irq->refcount, vgic_irq_release))
+	if (!refcount_dec_and_test(&irq->refcount))
 		return;
 
 	xa_lock_irqsave(&dist->lpi_xa, flags);
@@ -399,7 +390,7 @@ bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq,
 	 * now in the ap_list. This is safe as the caller must already hold a
 	 * reference on the irq.
 	 */
-	vgic_get_irq_kref(irq);
+	vgic_get_irq_ref(irq);
 	list_add_tail(&irq->ap_list, &vcpu->arch.vgic_cpu.ap_list_head);
 	irq->vcpu = vcpu;
 
@@ -657,7 +648,7 @@ static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
 
 			/*
 			 * This vgic_put_irq call matches the
-			 * vgic_get_irq_kref in vgic_queue_irq_unlock,
+			 * vgic_get_irq_ref in vgic_queue_irq_unlock,
 			 * where we added the LPI to the ap_list. As
 			 * we remove the irq from the list, we drop
 			 * also drop the refcount.
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index de1c1d3261c3..ac5f9c5d2b98 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -267,7 +267,7 @@ void vgic_v2_put(struct kvm_vcpu *vcpu);
 void vgic_v2_save_state(struct kvm_vcpu *vcpu);
 void vgic_v2_restore_state(struct kvm_vcpu *vcpu);
 
-static inline bool vgic_try_get_irq_kref(struct vgic_irq *irq)
+static inline bool vgic_try_get_irq_ref(struct vgic_irq *irq)
 {
 	if (!irq)
 		return false;
@@ -275,12 +275,12 @@ static inline bool vgic_try_get_irq_kref(struct vgic_irq *irq)
 	if (irq->intid < VGIC_MIN_LPI)
 		return true;
 
-	return kref_get_unless_zero(&irq->refcount);
+	return refcount_inc_not_zero(&irq->refcount);
 }
 
-static inline void vgic_get_irq_kref(struct vgic_irq *irq)
+static inline void vgic_get_irq_ref(struct vgic_irq *irq)
 {
-	WARN_ON_ONCE(!vgic_try_get_irq_kref(irq));
+	WARN_ON_ONCE(!vgic_try_get_irq_ref(irq));
 }
 
 void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu);
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 404883c7af6e..ed0e96031a65 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -8,8 +8,8 @@
 #include <linux/bits.h>
 #include <linux/kvm.h>
 #include <linux/irqreturn.h>
-#include <linux/kref.h>
 #include <linux/mutex.h>
+#include <linux/refcount.h>
 #include <linux/spinlock.h>
 #include <linux/static_key.h>
 #include <linux/types.h>
@@ -142,7 +142,7 @@ struct vgic_irq {
 	bool active;			/* not used for LPIs */
 	bool enabled;
 	bool hw;			/* Tied to HW IRQ */
-	struct kref refcount;		/* Used for LPIs */
+	refcount_t refcount;		/* Used for LPIs */
 	u32 hwintid;			/* HW INTID number */
 	unsigned int host_irq;		/* linux irq corresponding to hwintid */
 	union {
-- 
2.39.5

