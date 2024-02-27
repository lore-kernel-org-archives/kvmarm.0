Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F24055576B
	for <kvmarm@lists.linux.dev>; Tue, 27 Feb 2024 22:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709073801; cv=none; b=M4XjMhQJ30jcSrJ5ghOveAGPvmZhG9+bTlOOYl7ossmIVHvI3n8L9ULJpoWjEaexA9vxHC3AWR8YnmfV7PaLU6FCVj4attPIp5cQZVRFLwMPgsJ5yhOOGKp3Fl/B25MfP3laChMmGlCax4Mv+fl1HYu05OdgEyGvU1WvpeTTQFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709073801; c=relaxed/simple;
	bh=eSf5q3pyc8NbJI8KLjg5A8nAFmJXDl9n7yFmKGXJNhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=URqk1BKjs4cAwxahWnmEtfgfOmbc8MPggh3eY31X4qtUURb3TjqDALJj/DUFngaNqO2Om2XqbuBknKrrO2Lp6x9ACTSrFgjeH1NAxgRW2+bDNaSeXt+cAyL2SsUO51hv+Gh7cDV5JjEaWCgcCIpuLe4m+VTzVdjfz3UnimHL1Ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Kc/itVxk; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Kc/itVxk"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709073798;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bpHHZ/mV3vW85UJGMT+KiLhKPALJJ1g5lzOtXi5yj0k=;
	b=Kc/itVxkBA/ZuKXmnhxkcm7y0TYAoLyumt5z6Jowre91aDpm/2N0U6dBzqlSd5sO+cwwBr
	YiOBZXtRx1m+N4jji1q+tXJdvY/lnEGL22P1NjjvEO0CZX0HsYVtwAoyAL5rtY2e5TwA5s
	CryaqiA7o1w1Zdcu7OxOSp9TmO40Ero=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 10/20] KVM: arm64: vgic-its: Use the per-ITS translation cache for injection
Date: Tue, 27 Feb 2024 22:42:39 +0000
Message-ID: <20240227224249.2209194-11-oliver.upton@linux.dev>
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

Everything is in place to switch to per-ITS translation caches. Start
using the per-ITS cache to avoid the lock serialization related to the
global translation cache.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-its.c | 40 +++++++++++-----------------------
 1 file changed, 13 insertions(+), 27 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 0fc5891fc4a0..0e39e35c809e 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -533,35 +533,17 @@ static unsigned long vgic_its_cache_key(u32 devid, u32 eventid)
 	return (((unsigned long)devid) << 32) | eventid;
 }
 
-static struct vgic_irq *__vgic_its_check_cache(struct vgic_dist *dist,
-					       phys_addr_t db,
+static struct vgic_irq *__vgic_its_check_cache(struct kvm *kvm, phys_addr_t db,
 					       u32 devid, u32 eventid)
 {
-	struct vgic_translation_cache_entry *cte;
-
-	list_for_each_entry(cte, &dist->lpi_translation_cache, entry) {
-		/*
-		 * If we hit a NULL entry, there is nothing after this
-		 * point.
-		 */
-		if (!cte->irq)
-			break;
-
-		if (cte->db != db || cte->devid != devid ||
-		    cte->eventid != eventid)
-			continue;
-
-		/*
-		 * Move this entry to the head, as it is the most
-		 * recently used.
-		 */
-		if (!list_is_first(&cte->entry, &dist->lpi_translation_cache))
-			list_move(&cte->entry, &dist->lpi_translation_cache);
+	unsigned long cache_key = vgic_its_cache_key(devid, eventid);
+	struct vgic_its *its;
 
-		return cte->irq;
-	}
+	its = __vgic_doorbell_to_its(kvm, db);
+	if (IS_ERR(its))
+		return NULL;
 
-	return NULL;
+	return xa_load(&its->translation_cache, cache_key);
 }
 
 static struct vgic_irq *vgic_its_check_cache(struct kvm *kvm, phys_addr_t db,
@@ -572,11 +554,13 @@ static struct vgic_irq *vgic_its_check_cache(struct kvm *kvm, phys_addr_t db,
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);
+	rcu_read_lock();
 
-	irq = __vgic_its_check_cache(dist, db, devid, eventid);
+	irq = __vgic_its_check_cache(kvm, db, devid, eventid);
 	if (!vgic_try_get_irq_kref(irq))
 		irq = NULL;
 
+	rcu_read_unlock();
 	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
 
 	return irq;
@@ -600,6 +584,7 @@ static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
 		return;
 
 	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);
+	rcu_read_lock();
 
 	if (unlikely(list_empty(&dist->lpi_translation_cache)))
 		goto out;
@@ -610,7 +595,7 @@ static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
 	 * already
 	 */
 	db = its->vgic_its_base + GITS_TRANSLATER;
-	if (__vgic_its_check_cache(dist, db, devid, eventid))
+	if (__vgic_its_check_cache(kvm, db, devid, eventid))
 		goto out;
 
 	/* Always reuse the last entry (LRU policy) */
@@ -647,6 +632,7 @@ static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
 
 	xa_store(&its->translation_cache, cache_key, irq, 0);
 out:
+	rcu_read_unlock();
 	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
 }
 
-- 
2.44.0.rc1.240.g4c46232300-goog

