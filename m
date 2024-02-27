Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44C7555788
	for <kvmarm@lists.linux.dev>; Tue, 27 Feb 2024 22:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709073793; cv=none; b=APUI89BL0PmKENriom+jjqpPjEoiFhCYqW+op5jhDzzGpc4dkY0NxmtVF+bDhpQii4oQEgz7C01E98x5INP+cn5Bb3xlBry/BpO/BMqVOAETJ4o2IBepWsx/+qE0ySdMg9yiD9qOnCuggp5wv2zMysEBhQfRiq5yKNdeu3jBiRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709073793; c=relaxed/simple;
	bh=TELorIMvcJmDrfHn6a6i49g0qzE0kOmdsIVUrWmZbW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ldvuBrTiNHW8Mdc317mk3DWxhxyOAVDO8BrlMnA5f1jOYtqW2qM1lXBHbSXz/f2GuhxCkjcho4fdg75UJATee0Cg4zh9YZCRE8X+fy8Zjdxg9MRS+Sa/R9bjrgXM9FygF0FWK2SnXgcGMTASHexkrV/WwAppBmMlv+MdJfoKfOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KZwPmJZf; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KZwPmJZf"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709073789;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dYs1RYduhtqYXvXZapQ2iahghuyVmu0pwRRG8reLxVU=;
	b=KZwPmJZfHgy0pksza3KbKooxznRMUIzjRu/NEbRNZ+LwkAeNyfvjeRBAvG1dVF7B0VlxzB
	8I1SKwjClKm+RMctrZhmLt+9aTLogah06G2Usuc5qP/pERxWYg4ktSeVTZOReOi/T9R1kJ
	7gd5LtNrBUR9cFIJ2+dUu7lj3ihGhwk=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 05/20] KVM: arm64: vgic-debug: Use an xarray mark for debug iterator
Date: Tue, 27 Feb 2024 22:42:34 +0000
Message-ID: <20240227224249.2209194-6-oliver.upton@linux.dev>
In-Reply-To: <20240227224249.2209194-1-oliver.upton@linux.dev>
References: <20240227224249.2209194-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The vgic debug iterator is the final user of vgic_copy_lpi_list(), but
is a bit more complicated to transition to something else. Use a mark
in the LPI xarray to record the indices 'known' to the debug iterator.
Protect against the LPIs from being freed by associating an additional
reference with the xarray mark.

Rework iter_next() to let the xarray walk 'drive' the iteration after
visiting all of the SGIs, PPIs, and SPIs.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-debug.c | 82 +++++++++++++++++++++++---------
 arch/arm64/kvm/vgic/vgic-its.c   |  4 +-
 arch/arm64/kvm/vgic/vgic.h       |  1 +
 include/kvm/arm_vgic.h           |  2 +
 4 files changed, 64 insertions(+), 25 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-debug.c b/arch/arm64/kvm/vgic/vgic-debug.c
index 389025ce7749..bcbc8c986b1d 100644
--- a/arch/arm64/kvm/vgic/vgic-debug.c
+++ b/arch/arm64/kvm/vgic/vgic-debug.c
@@ -28,27 +28,65 @@ struct vgic_state_iter {
 	int nr_lpis;
 	int dist_id;
 	int vcpu_id;
-	int intid;
+	unsigned long intid;
 	int lpi_idx;
-	u32 *lpi_array;
 };
 
-static void iter_next(struct vgic_state_iter *iter)
+static void iter_next(struct kvm *kvm, struct vgic_state_iter *iter)
 {
+	struct vgic_dist *dist = &kvm->arch.vgic;
+
 	if (iter->dist_id == 0) {
 		iter->dist_id++;
 		return;
 	}
 
+	/*
+	 * Let the xarray drive the iterator after the last SPI, as the iterator
+	 * has exhausted the sequentially-allocated INTID space.
+	 */
+	if (iter->intid >= (iter->nr_spis + VGIC_NR_PRIVATE_IRQS - 1)) {
+		if (iter->lpi_idx < iter->nr_lpis)
+			xa_find_after(&dist->lpi_xa, &iter->intid,
+				      VGIC_LPI_MAX_INTID,
+				      LPI_XA_MARK_DEBUG_ITER);
+		iter->lpi_idx++;
+		return;
+	}
+
 	iter->intid++;
 	if (iter->intid == VGIC_NR_PRIVATE_IRQS &&
 	    ++iter->vcpu_id < iter->nr_cpus)
 		iter->intid = 0;
+}
 
-	if (iter->intid >= (iter->nr_spis + VGIC_NR_PRIVATE_IRQS)) {
-		if (iter->lpi_idx < iter->nr_lpis)
-			iter->intid = iter->lpi_array[iter->lpi_idx];
-		iter->lpi_idx++;
+static int iter_mark_lpis(struct kvm *kvm)
+{
+	struct vgic_dist *dist = &kvm->arch.vgic;
+	struct vgic_irq *irq;
+	unsigned long intid;
+	int nr_lpis = 0;
+
+	xa_for_each(&dist->lpi_xa, intid, irq) {
+		if (!vgic_try_get_irq_kref(irq))
+			continue;
+
+		xa_set_mark(&dist->lpi_xa, intid, LPI_XA_MARK_DEBUG_ITER);
+		nr_lpis++;
+	}
+
+	return nr_lpis;
+}
+
+static void iter_unmark_lpis(struct kvm *kvm)
+{
+	struct vgic_dist *dist = &kvm->arch.vgic;
+	struct vgic_irq *irq;
+	unsigned long intid;
+
+	xa_for_each(&dist->lpi_xa, intid, irq) {
+		xa_clear_mark(&dist->lpi_xa, intid, LPI_XA_MARK_DEBUG_ITER);
+		vgic_put_irq(kvm, irq);
 	}
 }
 
@@ -61,15 +99,12 @@ static void iter_init(struct kvm *kvm, struct vgic_state_iter *iter,
 
 	iter->nr_cpus = nr_cpus;
 	iter->nr_spis = kvm->arch.vgic.nr_spis;
-	if (kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3) {
-		iter->nr_lpis = vgic_copy_lpi_list(kvm, NULL, &iter->lpi_array);
-		if (iter->nr_lpis < 0)
-			iter->nr_lpis = 0;
-	}
+	if (kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3)
+		iter->nr_lpis = iter_mark_lpis(kvm);
 
 	/* Fast forward to the right position if needed */
 	while (pos--)
-		iter_next(iter);
+		iter_next(kvm, iter);
 }
 
 static bool end_of_vgic(struct vgic_state_iter *iter)
@@ -114,7 +149,7 @@ static void *vgic_debug_next(struct seq_file *s, void *v, loff_t *pos)
 	struct vgic_state_iter *iter = kvm->arch.vgic.iter;
 
 	++*pos;
-	iter_next(iter);
+	iter_next(kvm, iter);
 	if (end_of_vgic(iter))
 		iter = NULL;
 	return iter;
@@ -134,13 +169,14 @@ static void vgic_debug_stop(struct seq_file *s, void *v)
 
 	mutex_lock(&kvm->arch.config_lock);
 	iter = kvm->arch.vgic.iter;
-	kfree(iter->lpi_array);
+	iter_unmark_lpis(kvm);
 	kfree(iter);
 	kvm->arch.vgic.iter = NULL;
 	mutex_unlock(&kvm->arch.config_lock);
 }
 
-static void print_dist_state(struct seq_file *s, struct vgic_dist *dist)
+static void print_dist_state(struct seq_file *s, struct vgic_dist *dist,
+			     struct vgic_state_iter *iter)
 {
 	bool v3 = dist->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3;
 
@@ -149,7 +185,7 @@ static void print_dist_state(struct seq_file *s, struct vgic_dist *dist)
 	seq_printf(s, "vgic_model:\t%s\n", v3 ? "GICv3" : "GICv2");
 	seq_printf(s, "nr_spis:\t%d\n", dist->nr_spis);
 	if (v3)
-		seq_printf(s, "nr_lpis:\t%d\n", atomic_read(&dist->lpi_count));
+		seq_printf(s, "nr_lpis:\t%d\n", iter->nr_lpis);
 	seq_printf(s, "enabled:\t%d\n", dist->enabled);
 	seq_printf(s, "\n");
 
@@ -236,7 +272,7 @@ static int vgic_debug_show(struct seq_file *s, void *v)
 	unsigned long flags;
 
 	if (iter->dist_id == 0) {
-		print_dist_state(s, &kvm->arch.vgic);
+		print_dist_state(s, &kvm->arch.vgic, iter);
 		return 0;
 	}
 
@@ -246,11 +282,13 @@ static int vgic_debug_show(struct seq_file *s, void *v)
 	if (iter->vcpu_id < iter->nr_cpus)
 		vcpu = kvm_get_vcpu(kvm, iter->vcpu_id);
 
+	/*
+	 * Expect this to succeed, as iter_mark_lpis() takes a reference on
+	 * every LPI to be visited.
+	 */
 	irq = vgic_get_irq(kvm, vcpu, iter->intid);
-	if (!irq) {
-		seq_printf(s, "       LPI %4d freed\n", iter->intid);
-		return 0;
-	}
+	if (WARN_ON_ONCE(!irq))
+		return -EINVAL;
 
 	raw_spin_lock_irqsave(&irq->irq_lock, flags);
 	print_irq_state(s, irq, vcpu);
diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index ba97fbe3aeab..28b132aaeef3 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -316,8 +316,6 @@ static int update_lpi_config(struct kvm *kvm, struct vgic_irq *irq,
 	return 0;
 }
 
-#define GIC_LPI_MAX_INTID	((1 << INTERRUPT_ID_BITS_ITS) - 1)
-
 /*
  * Create a snapshot of the current LPIs targeting @vcpu, so that we can
  * enumerate those LPIs without holding any lock.
@@ -347,7 +345,7 @@ int vgic_copy_lpi_list(struct kvm *kvm, struct kvm_vcpu *vcpu, u32 **intid_ptr)
 	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);
 	rcu_read_lock();
 
-	xas_for_each(&xas, irq, GIC_LPI_MAX_INTID) {
+	xas_for_each(&xas, irq, VGIC_LPI_MAX_INTID) {
 		if (i == irq_count)
 			break;
 		/* We don't need to "get" the IRQ, as we hold the list lock. */
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 0c2b82de8fa3..e0c77e1bd9f6 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -16,6 +16,7 @@
 
 #define INTERRUPT_ID_BITS_SPIS	10
 #define INTERRUPT_ID_BITS_ITS	16
+#define VGIC_LPI_MAX_INTID	((1 << INTERRUPT_ID_BITS_ITS) - 1)
 #define VGIC_PRI_BITS		5
 
 #define vgic_irq_is_sgi(intid) ((intid) < VGIC_NR_SGIS)
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 47035946648e..8eb72721dac1 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -276,6 +276,8 @@ struct vgic_dist {
 
 	/* Protects the lpi_list. */
 	raw_spinlock_t		lpi_list_lock;
+
+#define LPI_XA_MARK_DEBUG_ITER	XA_MARK_0
 	struct xarray		lpi_xa;
 	atomic_t		lpi_count;
 
-- 
2.44.0.rc1.240.g4c46232300-goog

