Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C4095576B
	for <kvmarm@lists.linux.dev>; Tue, 27 Feb 2024 22:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709073796; cv=none; b=sm9tUJrwMORxRJymSGdpjhJnqe1s7lbEM7AXEP8UuSKXH3JPuVrf3sy7YOfFVHbuwabZdWVxJeDa7jOm+/S9JKcSpGYQqIV7WS6aG+jw98TReSeEVi/mwKek7Kxg40s6ri1c41J6Fbftb9x/pcp+vXLUsxtmZ0SyJoWm4NDO/rE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709073796; c=relaxed/simple;
	bh=qtPYpFA9/vBe2QENjI+cRP2L2D0WWxltHcC2LPhPLHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I43o5q7R/h4/3DuQCdb3WVBtMECXZfunP1tieDrdUp2KF6HZ9LzpDvvC2j1+8BX26aBQwlsNNJ56sem+QLJ1uD6OAjnOPdtEPYjgg2fLn9Qol8zdPE24PDNcGzZwAzAxs5T0HVWvVpSn3ilIInryBMnUF4FPgzHZE6Z9sYoYuYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=M02vOo2W; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="M02vOo2W"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709073792;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7qxcQYDoAI1vrcUxGnBm12WpfegWeBjQHPlLRYeL8IM=;
	b=M02vOo2Wy5UsUTwNXB6BjfFIm6oGy2HJqDQC96IjdmWXXBoEepHOG6d2s/AEgrrjpKyqyZ
	uXN2ZKiPR65EZIilaETYXaeGRp9qnxin+VDL3e2wNDk1sLsi4KuSnWF2uu55/eRhWLsjEK
	Teik3NkvR9b5rLePaTOegQ47DaYEX34=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 07/20] KVM: arm64: vgic-its: Scope translation cache invalidations to an ITS
Date: Tue, 27 Feb 2024 22:42:36 +0000
Message-ID: <20240227224249.2209194-8-oliver.upton@linux.dev>
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
index 577353ab98d3..81f173694761 100644
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
@@ -614,7 +616,7 @@ static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
 	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
 }
 
-void vgic_its_invalidate_cache(struct kvm *kvm)
+static void vgic_its_invalidate_cache(struct vgic_its *its)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
 	struct vgic_translation_cache_entry *cte;
@@ -637,6 +639,24 @@ void vgic_its_invalidate_cache(struct kvm *kvm)
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
@@ -824,7 +844,7 @@ static int vgic_its_cmd_handle_discard(struct kvm *kvm, struct vgic_its *its,
 		 * don't bother here since we clear the ITTE anyway and the
 		 * pending state is a property of the ITTE struct.
 		 */
-		vgic_its_invalidate_cache(kvm);
+		vgic_its_invalidate_cache(its);
 
 		its_free_ite(kvm, ite);
 		return 0;
@@ -861,7 +881,7 @@ static int vgic_its_cmd_handle_movi(struct kvm *kvm, struct vgic_its *its,
 	ite->collection = collection;
 	vcpu = collection_to_vcpu(kvm, collection);
 
-	vgic_its_invalidate_cache(kvm);
+	vgic_its_invalidate_cache(its);
 
 	return update_affinity(ite->irq, vcpu);
 }
@@ -1108,7 +1128,8 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
 }
 
 /* Requires the its_lock to be held. */
-static void vgic_its_free_device(struct kvm *kvm, struct its_device *device)
+static void vgic_its_free_device(struct kvm *kvm, struct vgic_its *its,
+				 struct its_device *device)
 {
 	struct its_ite *ite, *temp;
 
@@ -1120,7 +1141,7 @@ static void vgic_its_free_device(struct kvm *kvm, struct its_device *device)
 	list_for_each_entry_safe(ite, temp, &device->itt_head, ite_list)
 		its_free_ite(kvm, ite);
 
-	vgic_its_invalidate_cache(kvm);
+	vgic_its_invalidate_cache(its);
 
 	list_del(&device->dev_list);
 	kfree(device);
@@ -1132,7 +1153,7 @@ static void vgic_its_free_device_list(struct kvm *kvm, struct vgic_its *its)
 	struct its_device *cur, *temp;
 
 	list_for_each_entry_safe(cur, temp, &its->device_list, dev_list)
-		vgic_its_free_device(kvm, cur);
+		vgic_its_free_device(kvm, its, cur);
 }
 
 /* its lock must be held */
@@ -1191,7 +1212,7 @@ static int vgic_its_cmd_handle_mapd(struct kvm *kvm, struct vgic_its *its,
 	 * by removing the mapping and re-establishing it.
 	 */
 	if (device)
-		vgic_its_free_device(kvm, device);
+		vgic_its_free_device(kvm, its, device);
 
 	/*
 	 * The spec does not say whether unmapping a not-mapped device
@@ -1222,7 +1243,7 @@ static int vgic_its_cmd_handle_mapc(struct kvm *kvm, struct vgic_its *its,
 
 	if (!valid) {
 		vgic_its_free_collection(its, coll_id);
-		vgic_its_invalidate_cache(kvm);
+		vgic_its_invalidate_cache(its);
 	} else {
 		struct kvm_vcpu *vcpu;
 
@@ -1391,7 +1412,7 @@ static int vgic_its_cmd_handle_movall(struct kvm *kvm, struct vgic_its *its,
 		vgic_put_irq(kvm, irq);
 	}
 
-	vgic_its_invalidate_cache(kvm);
+	vgic_its_invalidate_cache(its);
 
 	return 0;
 }
@@ -1743,7 +1764,7 @@ static void vgic_mmio_write_its_ctlr(struct kvm *kvm, struct vgic_its *its,
 
 	its->enabled = !!(val & GITS_CTLR_ENABLE);
 	if (!its->enabled)
-		vgic_its_invalidate_cache(kvm);
+		vgic_its_invalidate_cache(its);
 
 	/*
 	 * Try to process any pending commands. This function bails out early
@@ -1876,7 +1897,7 @@ void vgic_lpi_translation_cache_destroy(struct kvm *kvm)
 	struct vgic_dist *dist = &kvm->arch.vgic;
 	struct vgic_translation_cache_entry *cte, *tmp;
 
-	vgic_its_invalidate_cache(kvm);
+	vgic_its_invalidate_all_caches(kvm);
 
 	list_for_each_entry_safe(cte, tmp,
 				 &dist->lpi_translation_cache, entry) {
@@ -2368,7 +2389,7 @@ static int vgic_its_restore_dte(struct vgic_its *its, u32 id,
 
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
2.44.0.rc1.240.g4c46232300-goog

