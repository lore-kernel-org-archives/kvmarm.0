Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98AC184FCE
	for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 22:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713566365; cv=none; b=iAXMgj7+lSGtsNSNRf4+vwX//2UsHIABV5mVhUU1zqTApbJPIk/5Yj+uNEgtnfsO2DZ4yjJe5w40a3wJIKX/W2B8GgFLOd+i/pJBolJOb6qLJFwB45N21TYhJiEWJ6zJqwo+Uc6zWYwkIOAHmVVTHV320l5/CaYs5n7FKH9QheU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713566365; c=relaxed/simple;
	bh=ex6sleJ4AOuNMEANXFt2zw4iHpeO/mhzIhh50aGJdLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YB+DjeYPqMudBcbKwg2B5/fxCGjfsfxE13wSYe4VqxfwwY261uOfklGW9jsrz0pLZmED1pRbTk9gVhIX8gX8tSiwRlNtnSEd0vXGC9rtLUAYpZczM6liXnTu8xojoKB3R1+IyRf6bD9Mk+MnoPvOai9CFdEtv+NEZ3DoQGHyttg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ORP5mmyH; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ORP5mmyH"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1713566362;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IlsyU5Oa9/QxxvIUOlfRjQh9pWrtSX/zjg7AZVK8nmE=;
	b=ORP5mmyHAN6wCN9jL7epAP2SsYSkTvowsTelpT8iYWJgWGPjA4unav4l/cpVZjJKm2QDmB
	lCmPOEh6mMCPphvmQf0mvIDs2EjLtiLlPkbhGGuuFc95vs6vtiSawPT0/ZBl1udw559yn3
	Foc9U3DJQMY/e27tN7YuY6pmm2TN9hc=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 07/19] KVM: arm64: vgic-its: Scope translation cache invalidations to an ITS
Date: Fri, 19 Apr 2024 22:38:30 +0000
Message-ID: <20240419223842.951452-8-oliver.upton@linux.dev>
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

As the current LPI translation cache is global, the corresponding
invalidation helpers are also globally-scoped. In anticipation of
constructing a translation cache per ITS, add a helper for scoped cache
invalidations.

We still need to support global invalidations when LPIs are toggled on
a redistributor, as a property of the translation cache is that all
stored LPIs are known to be delieverable.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-its.c     | 45 ++++++++++++++++++++++--------
 arch/arm64/kvm/vgic/vgic-mmio-v3.c |  2 +-
 arch/arm64/kvm/vgic/vgic.h         |  2 +-
 3 files changed, 35 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 441134ad674e..4afd42b6a16c 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -23,6 +23,8 @@
 #include "vgic.h"
 #include "vgic-mmio.h"
 
+static struct kvm_device_ops kvm_arm_vgic_its_ops;
+
 static int vgic_its_save_tables_v0(struct vgic_its *its);
 static int vgic_its_restore_tables_v0(struct vgic_its *its);
 static int vgic_its_commit_v0(struct vgic_its *its);
@@ -616,7 +618,7 @@ static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
 	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
 }
 
-void vgic_its_invalidate_cache(struct kvm *kvm)
+static void vgic_its_invalidate_cache(struct vgic_its *its)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
 	struct vgic_translation_cache_entry *cte;
@@ -639,6 +641,24 @@ void vgic_its_invalidate_cache(struct kvm *kvm)
 	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
 }
 
+void vgic_its_invalidate_all_caches(struct kvm *kvm)
+{
+	struct kvm_device *dev;
+	struct vgic_its *its;
+
+	rcu_read_lock();
+
+	list_for_each_entry_rcu(dev, &kvm->devices, vm_node) {
+		if (dev->ops != &kvm_arm_vgic_its_ops)
+			continue;
+
+		its = dev->private;
+		vgic_its_invalidate_cache(its);
+	}
+
+	rcu_read_unlock();
+}
+
 int vgic_its_resolve_lpi(struct kvm *kvm, struct vgic_its *its,
 			 u32 devid, u32 eventid, struct vgic_irq **irq)
 {
@@ -826,7 +846,7 @@ static int vgic_its_cmd_handle_discard(struct kvm *kvm, struct vgic_its *its,
 		 * don't bother here since we clear the ITTE anyway and the
 		 * pending state is a property of the ITTE struct.
 		 */
-		vgic_its_invalidate_cache(kvm);
+		vgic_its_invalidate_cache(its);
 
 		its_free_ite(kvm, ite);
 		return 0;
@@ -863,7 +883,7 @@ static int vgic_its_cmd_handle_movi(struct kvm *kvm, struct vgic_its *its,
 	ite->collection = collection;
 	vcpu = collection_to_vcpu(kvm, collection);
 
-	vgic_its_invalidate_cache(kvm);
+	vgic_its_invalidate_cache(its);
 
 	return update_affinity(ite->irq, vcpu);
 }
@@ -1110,7 +1130,8 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
 }
 
 /* Requires the its_lock to be held. */
-static void vgic_its_free_device(struct kvm *kvm, struct its_device *device)
+static void vgic_its_free_device(struct kvm *kvm, struct vgic_its *its,
+				 struct its_device *device)
 {
 	struct its_ite *ite, *temp;
 
@@ -1122,7 +1143,7 @@ static void vgic_its_free_device(struct kvm *kvm, struct its_device *device)
 	list_for_each_entry_safe(ite, temp, &device->itt_head, ite_list)
 		its_free_ite(kvm, ite);
 
-	vgic_its_invalidate_cache(kvm);
+	vgic_its_invalidate_cache(its);
 
 	list_del(&device->dev_list);
 	kfree(device);
@@ -1134,7 +1155,7 @@ static void vgic_its_free_device_list(struct kvm *kvm, struct vgic_its *its)
 	struct its_device *cur, *temp;
 
 	list_for_each_entry_safe(cur, temp, &its->device_list, dev_list)
-		vgic_its_free_device(kvm, cur);
+		vgic_its_free_device(kvm, its, cur);
 }
 
 /* its lock must be held */
@@ -1193,7 +1214,7 @@ static int vgic_its_cmd_handle_mapd(struct kvm *kvm, struct vgic_its *its,
 	 * by removing the mapping and re-establishing it.
 	 */
 	if (device)
-		vgic_its_free_device(kvm, device);
+		vgic_its_free_device(kvm, its, device);
 
 	/*
 	 * The spec does not say whether unmapping a not-mapped device
@@ -1224,7 +1245,7 @@ static int vgic_its_cmd_handle_mapc(struct kvm *kvm, struct vgic_its *its,
 
 	if (!valid) {
 		vgic_its_free_collection(its, coll_id);
-		vgic_its_invalidate_cache(kvm);
+		vgic_its_invalidate_cache(its);
 	} else {
 		struct kvm_vcpu *vcpu;
 
@@ -1395,7 +1416,7 @@ static int vgic_its_cmd_handle_movall(struct kvm *kvm, struct vgic_its *its,
 		vgic_put_irq(kvm, irq);
 	}
 
-	vgic_its_invalidate_cache(kvm);
+	vgic_its_invalidate_cache(its);
 
 	return 0;
 }
@@ -1747,7 +1768,7 @@ static void vgic_mmio_write_its_ctlr(struct kvm *kvm, struct vgic_its *its,
 
 	its->enabled = !!(val & GITS_CTLR_ENABLE);
 	if (!its->enabled)
-		vgic_its_invalidate_cache(kvm);
+		vgic_its_invalidate_cache(its);
 
 	/*
 	 * Try to process any pending commands. This function bails out early
@@ -1880,7 +1901,7 @@ void vgic_lpi_translation_cache_destroy(struct kvm *kvm)
 	struct vgic_dist *dist = &kvm->arch.vgic;
 	struct vgic_translation_cache_entry *cte, *tmp;
 
-	vgic_its_invalidate_cache(kvm);
+	vgic_its_invalidate_all_caches(kvm);
 
 	list_for_each_entry_safe(cte, tmp,
 				 &dist->lpi_translation_cache, entry) {
@@ -2372,7 +2393,7 @@ static int vgic_its_restore_dte(struct vgic_its *its, u32 id,
 
 	ret = vgic_its_restore_itt(its, dev);
 	if (ret) {
-		vgic_its_free_device(its->dev->kvm, dev);
+		vgic_its_free_device(its->dev->kvm, its, dev);
 		return ret;
 	}
 
diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index c15ee1df036a..a3983a631b5a 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -277,7 +277,7 @@ static void vgic_mmio_write_v3r_ctlr(struct kvm_vcpu *vcpu,
 			return;
 
 		vgic_flush_pending_lpis(vcpu);
-		vgic_its_invalidate_cache(vcpu->kvm);
+		vgic_its_invalidate_all_caches(vcpu->kvm);
 		atomic_set_release(&vgic_cpu->ctlr, 0);
 	} else {
 		ctlr = atomic_cmpxchg_acquire(&vgic_cpu->ctlr, 0,
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 060dfd96b41f..e5cda1eb4bcf 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -337,7 +337,7 @@ struct vgic_its *vgic_msi_to_its(struct kvm *kvm, struct kvm_msi *msi);
 int vgic_its_inject_cached_translation(struct kvm *kvm, struct kvm_msi *msi);
 void vgic_lpi_translation_cache_init(struct kvm *kvm);
 void vgic_lpi_translation_cache_destroy(struct kvm *kvm);
-void vgic_its_invalidate_cache(struct kvm *kvm);
+void vgic_its_invalidate_all_caches(struct kvm *kvm);
 
 /* GICv4.1 MMIO interface */
 int vgic_its_inv_lpi(struct kvm *kvm, struct vgic_irq *irq);
-- 
2.44.0.769.g3c40516874-goog

