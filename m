Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C13F224F2
	for <kvmarm@lists.linux.dev>; Tue, 13 Feb 2024 09:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707817208; cv=none; b=rtNvLdyS/vWRTq6VJthNaTOgrEIKUkbajBI8YO5vNzydrPK1znCg69BokHPikG80RxTdK6Oz3GcTYZyZE/UiVpU4f19hGP2BEbuGiml6eoTKsI8FWUfsTfEAvuzOcWgYMhpFD2zaJh57IUDA1SrFCg+JYlxKan0q7GCam7SZO/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707817208; c=relaxed/simple;
	bh=1X3y/+7kwIA1bPfJOn0Y/WTdRQy52Y2ta/su6GXyAHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L4rYMITm10FpKs/GPx5JVnDVK0T7r1t0e/2ocCBGrQSjWSqnc1goP7xgNqzx8hDkD29JHH3JGPsflWHV10lmLQT01FjU7SbZKR8EYPz8d4JFhwvECRt1VFwRrLR+q+c7T/xE/CMESdvbO1yR0jCV7KdzxVHMOs+sgDI3O81rzCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tspZWTRQ; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tspZWTRQ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1707817203;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iVvQT5/XmikRWyk9sSNpoveNMbrL0Bk4ezrgyqLcu50=;
	b=tspZWTRQsY42Ipgi4nXkPCl77D6pxRdd0dv7qUb22qs3s6nvFQYwES8NqQumcyZj8EpM7d
	iKxxt1GENHJpHFumHr5BW/iasdQ/dj3jNfR6WStKJNTjpZOCt6a9eSUX5s+CGWxAk4tptc
	2LrvdkzycAeYPES6xrPyBLmIlqc7/4c=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-kernel@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 15/23] KVM: arm64: vgic-its: Treat the LPI translation cache as an rculist
Date: Tue, 13 Feb 2024 09:39:54 +0000
Message-ID: <20240213093954.3961389-1-oliver.upton@linux.dev>
In-Reply-To: <20240213093250.3960069-1-oliver.upton@linux.dev>
References: <20240213093250.3960069-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Convert the LPI translation cache to an rculist such that readers can
walk it while only holding the RCU read lock.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-its.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 99042ecc9c85..55463eb84763 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -569,7 +569,7 @@ static struct vgic_irq *__vgic_its_check_cache(struct vgic_dist *dist,
 {
 	struct vgic_translation_cache_entry *cte;
 
-	list_for_each_entry(cte, &dist->lpi_translation_cache, entry) {
+	list_for_each_entry_rcu(cte, &dist->lpi_translation_cache, entry) {
 		/*
 		 * If we hit a NULL entry, there is nothing after this
 		 * point.
@@ -625,7 +625,7 @@ static struct vgic_translation_cache_entry *vgic_its_cache_victim(struct vgic_di
 	 * older entries in the case of a tie. Return the max usage count seen
 	 * during the scan to initialize the new cache entry.
 	 */
-	list_for_each_entry(cte, &dist->lpi_translation_cache, entry) {
+	list_for_each_entry_rcu(cte, &dist->lpi_translation_cache, entry) {
 		tmp = atomic64_read(&cte->usage_count);
 		max = max(max, tmp);
 
@@ -679,7 +679,7 @@ static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
 	if (dist->lpi_cache_count >= vgic_its_max_cache_size(kvm)) {
 		victim = vgic_its_cache_victim(dist, &usage);
 
-		list_del(&victim->entry);
+		list_del_rcu(&victim->entry);
 		dist->lpi_cache_count--;
 	}
 
@@ -697,7 +697,7 @@ static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
 	rcu_assign_pointer(new->irq, irq);
 
 	/* Move the new translation to the head of the list */
-	list_add(&new->entry, &dist->lpi_translation_cache);
+	list_add_rcu(&new->entry, &dist->lpi_translation_cache);
 	dist->lpi_cache_count++;
 
 out:
@@ -734,7 +734,7 @@ void vgic_its_invalidate_cache(struct kvm *kvm)
 	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);
 	rcu_read_lock();
 
-	list_for_each_entry(cte, &dist->lpi_translation_cache, entry) {
+	list_for_each_entry_rcu(cte, &dist->lpi_translation_cache, entry) {
 		/*
 		 * If we hit a NULL entry, there is nothing after this
 		 * point.
@@ -1981,7 +1981,7 @@ void vgic_lpi_translation_cache_destroy(struct kvm *kvm)
 
 	list_for_each_entry_safe(cte, tmp,
 				 &dist->lpi_translation_cache, entry) {
-		list_del(&cte->entry);
+		list_del_rcu(&cte->entry);
 		kfree(cte);
 	}
 }
-- 
2.43.0.687.g38aa6559b0-goog

