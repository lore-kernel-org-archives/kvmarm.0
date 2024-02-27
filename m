Received: from out-187.mta0.migadu.com (out-187.mta0.migadu.com [91.218.175.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B38C65576B
	for <kvmarm@lists.linux.dev>; Tue, 27 Feb 2024 22:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709073799; cv=none; b=YvKXvdpF2dX4G/Prm4ofkcnCLedcjVsOZT6ceflgx2E4Os5gms+5gj/T4FrZ2CpTweTBfvTEO63tYVrwJ/xZDmyYY9E9EX9Bp7Mt0d9rg+S2Ah4GvigpbQLTdyQUfEH74lLMI38R+4ROq5+T+zV9o1BnoXswQpLD8hgqusX6ORw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709073799; c=relaxed/simple;
	bh=HeGQwv8iIM3T5K6Mh8P2R1eEJkVRqPyUruvT1fMNjqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hEODpviSThp2sJpkiMYco9SwTno8LRYXo3uclAP1dHJDW2jUWK3pTB7O+Lt/r3WE4PIGA+a4ZbfF2UZyaVjzTVi05EGJDMALv7/C0KAuuDNG7kaIuZilxWnrNnHy1oLyqyoxDrQZ2VLaY8jhONKzakfJ7kLeSO/KN5VKgBI9DsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OLv8bMCy; arc=none smtp.client-ip=91.218.175.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OLv8bMCy"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709073796;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OePF7Pk/C04Q1HRZAW72THmE8YFTsLxAlXY5BqUXWEY=;
	b=OLv8bMCynDosCF17EiwTIWJ14FynlmvYf6+nJ2M6W3NqwQEw3BMUbgbAP9hcBINydfPTJy
	haolBdXHkQon+k/A8PTv5zvOFeCqn0jjPFycnUrXymVOLZfhyNmwyfwbyZ8u2h9ySubffc
	bkk0bYYHWx7z0dAK2p040b/+FNGUBuU=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 09/20] KVM: arm64: vgic-its: Maintain a translation cache per ITS
Date: Tue, 27 Feb 2024 22:42:38 +0000
Message-ID: <20240227224249.2209194-10-oliver.upton@linux.dev>
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

Within the context of a single ITS, it is possible to use an xarray to
cache the device ID & event ID translation to a particular irq
descriptor. Take advantage of this to build a translation cache capable
of fitting all valid translations for a given ITS.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-its.c | 26 +++++++++++++++++++++++++-
 include/kvm/arm_vgic.h         |  6 ++++++
 2 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index ea812f4137d9..0fc5891fc4a0 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -528,6 +528,11 @@ static struct vgic_its *__vgic_doorbell_to_its(struct kvm *kvm, gpa_t db)
 	return iodev->its;
 }
 
+static unsigned long vgic_its_cache_key(u32 devid, u32 eventid)
+{
+	return (((unsigned long)devid) << 32) | eventid;
+}
+
 static struct vgic_irq *__vgic_its_check_cache(struct vgic_dist *dist,
 					       phys_addr_t db,
 					       u32 devid, u32 eventid)
@@ -581,6 +586,7 @@ static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
 				       u32 devid, u32 eventid,
 				       struct vgic_irq *irq)
 {
+	unsigned long cache_key = vgic_its_cache_key(devid, eventid);
 	struct vgic_dist *dist = &kvm->arch.vgic;
 	struct vgic_translation_cache_entry *cte;
 	unsigned long flags;
@@ -590,6 +596,9 @@ static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
 	if (irq->hw)
 		return;
 
+	if (xa_reserve_irq(&its->translation_cache, cache_key, GFP_KERNEL_ACCOUNT))
+		return;
+
 	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);
 
 	if (unlikely(list_empty(&dist->lpi_translation_cache)))
@@ -622,6 +631,11 @@ static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
 	 */
 	lockdep_assert_held(&its->its_lock);
 	vgic_get_irq_kref(irq);
+	/*
+	 * Get a second ref for the ITS' translation cache. This will
+	 * disappear.
+	 */
+	vgic_get_irq_kref(irq);
 
 	cte->db		= db;
 	cte->devid	= devid;
@@ -631,6 +645,7 @@ static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
 	/* Move the new translation to the head of the list */
 	list_move(&cte->entry, &dist->lpi_translation_cache);
 
+	xa_store(&its->translation_cache, cache_key, irq, 0);
 out:
 	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
 }
@@ -639,7 +654,8 @@ static void vgic_its_invalidate_cache(struct vgic_its *its)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
 	struct vgic_translation_cache_entry *cte;
-	unsigned long flags;
+	unsigned long flags, idx;
+	struct vgic_irq *irq;
 
 	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);
 
@@ -656,6 +672,11 @@ static void vgic_its_invalidate_cache(struct vgic_its *its)
 	}
 
 	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
+
+	xa_for_each(&its->translation_cache, idx, irq) {
+		xa_erase(&its->translation_cache, idx);
+		vgic_put_irq(its->dev->kvm, irq);
+	}
 }
 
 void vgic_its_invalidate_all_caches(struct kvm *kvm)
@@ -1963,6 +1984,7 @@ static int vgic_its_create(struct kvm_device *dev, u32 type)
 
 	INIT_LIST_HEAD(&its->device_list);
 	INIT_LIST_HEAD(&its->collection_list);
+	xa_init_flags(&its->translation_cache, XA_FLAGS_LOCK_IRQ);
 
 	dev->kvm->arch.vgic.msis_require_devid = true;
 	dev->kvm->arch.vgic.has_its = true;
@@ -1993,6 +2015,8 @@ static void vgic_its_destroy(struct kvm_device *kvm_dev)
 
 	vgic_its_free_device_list(kvm, its);
 	vgic_its_free_collection_list(kvm, its);
+	vgic_its_invalidate_cache(its);
+	xa_destroy(&its->translation_cache);
 
 	mutex_unlock(&its->its_lock);
 	kfree(its);
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index ac7f15ec1586..0b027ed71dac 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -210,6 +210,12 @@ struct vgic_its {
 	struct mutex		its_lock;
 	struct list_head	device_list;
 	struct list_head	collection_list;
+
+	/*
+	 * Caches the (device_id, event_id) -> vgic_irq translation for
+	 * *deliverable* LPIs.
+	 */
+	struct xarray		translation_cache;
 };
 
 struct vgic_state_iter;
-- 
2.44.0.rc1.240.g4c46232300-goog

