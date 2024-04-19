Received: from out-175.mta1.migadu.com (out-175.mta1.migadu.com [95.215.58.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB4FB84FCE
	for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 22:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713566368; cv=none; b=ENvR3RW/ooUbVVRqLcd5+Bf0mor89aAqcUI98w+/gftIuJ4w7CW43LRBRumCZk23kjTDKGtkXAtYXfKU507VBVW9sDValq80pmmwSQtEE9SUWUuPtYPd8nTRrFZBxtZKRbypcnQIngIqG6FYSrUD34ndezDeXMrPHZu6MJm2+2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713566368; c=relaxed/simple;
	bh=IfTRQSPxg6gFqurayFgfne+VpySjyEuyHx1DQvkKjUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OoKK1oXDZCP4QyLkxht2EgxO5IuZ2ZINjd96d3MB5GdUMoqEcgbt/0eb6+4e/j/52j9EBrrrzELq4ScIrJI2qFye1K4HNgVus1qBt7BfMLGcfPS3vlqk9rqN+PB3yZtphVduGIu5UfJi++rZonfsaKW/VznBvCeeZZkj9JdoMCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wWM5wDeB; arc=none smtp.client-ip=95.215.58.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wWM5wDeB"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1713566365;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6RwRxwcJT+mVhGScS/vIfWa4SdgqI+CJPgoR55WxzoY=;
	b=wWM5wDeBA7HzgOTUWiSXBJ0FsuAkYKTIJxn/nQgq89gm6joQHoGdwRcfzUDsT+IWkKO4Mw
	ExWAUtpeCdthT41LECqxPd7tOu1KnvWpeJCb8tl2iiJObCSLMGzgRarDywIUYED1hN2GQR
	EAzkle8K/O1Pf1OVrXUY2a+0ynkgyAI=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 09/19] KVM: arm64: vgic-its: Maintain a translation cache per ITS
Date: Fri, 19 Apr 2024 22:38:32 +0000
Message-ID: <20240419223842.951452-10-oliver.upton@linux.dev>
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
index be17a53d16ef..fd576377c084 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -530,6 +530,11 @@ static struct vgic_its *__vgic_doorbell_to_its(struct kvm *kvm, gpa_t db)
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
@@ -583,6 +588,7 @@ static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
 				       u32 devid, u32 eventid,
 				       struct vgic_irq *irq)
 {
+	unsigned long cache_key = vgic_its_cache_key(devid, eventid);
 	struct vgic_dist *dist = &kvm->arch.vgic;
 	struct vgic_translation_cache_entry *cte;
 	unsigned long flags;
@@ -592,6 +598,9 @@ static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
 	if (irq->hw)
 		return;
 
+	if (xa_reserve_irq(&its->translation_cache, cache_key, GFP_KERNEL_ACCOUNT))
+		return;
+
 	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);
 
 	if (unlikely(list_empty(&dist->lpi_translation_cache)))
@@ -624,6 +633,11 @@ static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
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
@@ -633,6 +647,7 @@ static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
 	/* Move the new translation to the head of the list */
 	list_move(&cte->entry, &dist->lpi_translation_cache);
 
+	xa_store(&its->translation_cache, cache_key, irq, 0);
 out:
 	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
 }
@@ -641,7 +656,8 @@ static void vgic_its_invalidate_cache(struct vgic_its *its)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
 	struct vgic_translation_cache_entry *cte;
-	unsigned long flags;
+	unsigned long flags, idx;
+	struct vgic_irq *irq;
 
 	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);
 
@@ -658,6 +674,11 @@ static void vgic_its_invalidate_cache(struct vgic_its *its)
 	}
 
 	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
+
+	xa_for_each(&its->translation_cache, idx, irq) {
+		xa_erase(&its->translation_cache, idx);
+		vgic_put_irq(its->dev->kvm, irq);
+	}
 }
 
 void vgic_its_invalidate_all_caches(struct kvm *kvm)
@@ -1967,6 +1988,7 @@ static int vgic_its_create(struct kvm_device *dev, u32 type)
 
 	INIT_LIST_HEAD(&its->device_list);
 	INIT_LIST_HEAD(&its->collection_list);
+	xa_init_flags(&its->translation_cache, XA_FLAGS_LOCK_IRQ);
 
 	dev->kvm->arch.vgic.msis_require_devid = true;
 	dev->kvm->arch.vgic.has_its = true;
@@ -1997,6 +2019,8 @@ static void vgic_its_destroy(struct kvm_device *kvm_dev)
 
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
2.44.0.769.g3c40516874-goog

