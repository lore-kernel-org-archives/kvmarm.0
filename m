Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBEC684FCE
	for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 22:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713566370; cv=none; b=T6xwJj4ksmwKC0zkuWhf2/nHSHnCiWiwaia3bOUbRGVBYJUzvNNs+styfn3AeGT2dKrOChnf/Ho9IQs6wWWu5fRZxIK9hwkT9wCp/9fwiCJq1zaAIbjiFiPEL4LZhDNP139lgK7lFcCi8BXgHiiKrr6+1RHfSS+VMtueH0wdTY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713566370; c=relaxed/simple;
	bh=EgRDJnFGv4EEoQwoK9udsflKn58f82xiyMHn7z1KY0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hcIvVL8R7qXlQ3bTccXlW2efQXL4H8cpe7Yfpf2qWJ2VgkqvwkcY1vX7x2AGMF8aoHCR0mTQJWzLiiKVW5zXqrfzbl4A0Mf3dmOqg4KosVzW8U9MDzn06IfzaEnLltQhd7YMVV01mSSC89+fG3TM5qzQ73lqLoGmQ3kPyyVkZqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=L99XEPwJ; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="L99XEPwJ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1713566366;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cf2F4+B/19vknEsUPeaqIXoe24d8UHrnKH20GZz/Gtg=;
	b=L99XEPwJ6uSQnxxPvZSjljCGb50pcK2EF89Cykf+NBwrnxG5lbcaELKsGgTs/ibi7muTb+
	eW067EGNJrJDHgAuMZSNca2W38xpGf1y5yYUAMBn8lt3e0XkAbMG+Jk7ittzidIeaGoNYY
	WMUvSw4mLeqMGqapWn0OmU+lIqRoDZ4=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 10/19] KVM: arm64: vgic-its: Use the per-ITS translation cache for injection
Date: Fri, 19 Apr 2024 22:38:33 +0000
Message-ID: <20240419223842.951452-11-oliver.upton@linux.dev>
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

Everything is in place to switch to per-ITS translation caches. Start
using the per-ITS cache to avoid the lock serialization related to the
global translation cache.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-its.c | 40 +++++++++++-----------------------
 1 file changed, 13 insertions(+), 27 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index fd576377c084..7fb942f4f105 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -535,35 +535,17 @@ static unsigned long vgic_its_cache_key(u32 devid, u32 eventid)
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
@@ -574,11 +556,13 @@ static struct vgic_irq *vgic_its_check_cache(struct kvm *kvm, phys_addr_t db,
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
@@ -602,6 +586,7 @@ static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
 		return;
 
 	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);
+	rcu_read_lock();
 
 	if (unlikely(list_empty(&dist->lpi_translation_cache)))
 		goto out;
@@ -612,7 +597,7 @@ static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
 	 * already
 	 */
 	db = its->vgic_its_base + GITS_TRANSLATER;
-	if (__vgic_its_check_cache(dist, db, devid, eventid))
+	if (__vgic_its_check_cache(kvm, db, devid, eventid))
 		goto out;
 
 	/* Always reuse the last entry (LRU policy) */
@@ -649,6 +634,7 @@ static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
 
 	xa_store(&its->translation_cache, cache_key, irq, 0);
 out:
+	rcu_read_unlock();
 	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
 }
 
-- 
2.44.0.769.g3c40516874-goog

