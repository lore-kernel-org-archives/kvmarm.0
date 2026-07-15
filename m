Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3F19437475
	for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 10:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784113167; cv=none; b=np4epjgYw8XaH9mKadnZiwiIx0/wg2tvyAKJAnUmwFeDvqG2xSpRPjnBNkRikOpsw05aq/AqEXkWL58Pnv5AugREHWBy172enxdlnzqN9NFoHfj8mUTvun022KvOenTPaMKrN9i5+/Jo5+2Zpd4iNgv9dDnW5KjGvUDubqTNmzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784113167; c=relaxed/simple;
	bh=ELJW7YlyNAtD6lZ6kJJZ+s8o7HPvtjuL2v8KPqIKPFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X5y0SPqyJlzI64jDxmNW5j8hlLLNgji/qfWUCIlxDvzYoq3FrV1EHk7FYyCk4HC/jTEs63XveqZ/uL+Zyoy5FO2qzDyfmUU1z6qumVoTaMhYC8o1TFOX5QMVhiHaNmIgKKsVn/8Ki54h0HuWk5PA8dc0xC7aVz5dqbTcY3Zhifg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=d9IV3LHX; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ZFlsK3sB; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=m1jXFtoX; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=hu5yr+SE; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="d9IV3LHX";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ZFlsK3sB";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="m1jXFtoX";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="hu5yr+SE"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DE39978373;
	Wed, 15 Jul 2026 10:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784113164; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ub1xEUiERA6LK0AoCGyXqyJPlNdNRIjkR+1FYTShN8A=;
	b=d9IV3LHXhLOIQCaS7BLN5hZGyB8q9Y4kXa4dwWs8CTLrY5qGrF24rZEAq74RCWVPi+nEHd
	UnRa0hFXE0hwA2TYQjks6PJNd7jLslnV4lbr3zQsCkVBImDmerSWIv6pKV/VMlRQXcE7oj
	Xu+2p6dsCh5noPliokCzWNgm3Q4Z6yo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784113164;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ub1xEUiERA6LK0AoCGyXqyJPlNdNRIjkR+1FYTShN8A=;
	b=ZFlsK3sB5x0I5BCKmwbHfSTeqrNgyZ1urctFKmeEkBSdg/QC32mSARUsyZd46no+7tmd7L
	K/DPhtVmIHyIboBw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=m1jXFtoX;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=hu5yr+SE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784113163; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ub1xEUiERA6LK0AoCGyXqyJPlNdNRIjkR+1FYTShN8A=;
	b=m1jXFtoXwqhUmCoWNc02N/+O3AOaoJtLwKcAK4vtmWGG7WJ2dACghTNkSB4LeAqn8GbnF/
	ZzmltSLCvvwZslUCLwPfUI+m1CRdH9WsN4HMIs1xazWBgs0ynt4tCOXV3Ezza71ide/sQg
	3KxjpxuGXqLJMyeOalD+yEfSe1DakNU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784113163;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ub1xEUiERA6LK0AoCGyXqyJPlNdNRIjkR+1FYTShN8A=;
	b=hu5yr+SEbOPkEa1pY+BHmpjuGfkvjzEkKrGJaveDZ4GlwQahSyodDshCFd/j1WtH/+/vTY
	FAh5zPy7LR4EFdAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3F4E5779AD;
	Wed, 15 Jul 2026 10:59:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2LfMDAtoV2reeAAAD6G6ig
	(envelope-from <clopez@suse.de>); Wed, 15 Jul 2026 10:59:23 +0000
From: =?UTF-8?q?Carlos=20L=C3=B3pez?= <clopez@suse.de>
To: kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: maz@kernel.org,
	oupton@kernel.org,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	=?UTF-8?q?Carlos=20L=C3=B3pez?= <clopez@suse.de>
Subject: [PATCH v6 1/2] KVM: arm64: vgic: Fix race between LPI release and re-registration
Date: Wed, 15 Jul 2026 12:51:37 +0200
Message-ID: <20260715105137.3973823-4-clopez@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260715105137.3973823-3-clopez@suse.de>
References: <20260715105137.3973823-3-clopez@suse.de>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: DE39978373
X-Spam-Flag: NO
X-Spam-Score: -3.51
X-Spam-Level: 
X-Spamd-Result: default: False [-3.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_TWELVE(0.00)[12];
	RCVD_TLS_ALL(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,suse.de:email,suse.de:mid];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

Fix a potential race between decrementing an LPI's reference count and
evicting that structure from the LPI xarray.

LPI structures are maintained in the VGIC LPI xarray (dist->lpi_xa).
When the reference count of an LPI structure drops to zero,
vgic_release_lpi_locked() removes the structure from the xarray and
frees it under the xarray lock.

However, the release of an LPI can race with a concurrent LPI
re-registration with the same INTID via vgic_add_lpi() on another CPU,
since the reference count drop and the xarray eviction are not performed
in a single atomic step. This can happen e.g. if the guest issues a
DISCARD while the LPI is still referenced from a vCPU's active-pending
list (ap_list), and the same INTID is re-mapped via MAPTI.

Particularly, vgic_release_lpi_locked() is called from two distinct
paths: direct release via vgic_put_irq(), and deferred release via
vgic_release_deleted_lpis(). During direct release, the issue can result
in deleting a newly registered LPI from the xarray:

  CPU0 (Releasing LPI)                    CPU1 (Adding new LPI)
  ====================                    =====================
  vgic_put_irq()
      __vgic_put_irq()
          refcount_dec_and_test()
                                          vgic_add_lpi()
                                              xa_lock_irqsave()
                                              old_irq = xa_load(.., intid)
                                              vgic_try_get_irq_ref(old_irq) == false
                        new IRQ inserted -->  __xa_store(.., intid, ..)
                                              xa_unlock_irqrestore()
  xa_lock_irqsave();
  vgic_release_lpi_locked()
      __xa_erase(.., irq->intid)   <-- BUG: new IRQ is erased
      kfree_rcu(old_irq)

During the deferred release path, the old IRQ can be leaked:

  CPU0 (Releasing LPI)                    CPU1 (Adding new LPI)
  ====================                    =====================
  vgic_put_irq_norelease()
      __vgic_put_irq()
          refcount_dec_and_test()
      irq->pending_release = true
                                          vgic_add_lpi()
                                              xa_lock_irqsave()
                                              old_irq = xa_load(.., intid)
                                              vgic_try_get_irq_ref(oldirq) == false
                 BUG: old IRQ overwritten --> __xa_store(.., intid, ..)
                                              xa_unlock_irqrestore()

  vgic_release_deleted_lpis()
      xa_lock_irqsave()
      xa_for_each() { .. } <-- old IRQ with pending_release = true
                               is gone, so it cannot be released

To fix the direct release path, move the reference count drop inside
the xarray lock, making sure that vgic_add_lpi() never encounters the
to-be-released LPI.

In the deferred release path, the refcount drop must happen under a raw
spinlock, so the xarray lock cannot be grabbed, and the same solution
does not work. Instead, update vgic_add_lpi(), so that if it evicts
an LPI from the xarray, it takes on the responsibility of freeing it.
Consequently, an LPI may now be freed concurrently after a deferred
release drops the refcount, so accessing the pending_release field is no
longer safe from use-after-free. Delete all uses of the flag, and update
vgic_release_deleted_lpis() to identify orphaned LPIs purely based on
their refcount.

Reported-by: Claude:claude-opus-4-6
Fixes: 3a08a6ca7c37 ("KVM: arm64: vgic-v3: Use bare refcount for VGIC LPIs")
Fixes: d54594accf73 ("KVM: arm64: vgic-v3: Erase LPIs from xarray outside of raw spinlocks")
Signed-off-by: Carlos López <clopez@suse.de>
---
 arch/arm64/kvm/vgic/vgic-its.c | 24 ++++++++++++++++--------
 arch/arm64/kvm/vgic/vgic.c     | 18 ++++++++----------
 include/kvm/arm_vgic.h         |  3 ---
 3 files changed, 24 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 67d107e9a77d..2240bdf20c92 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -116,18 +116,26 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
 		kfree(irq);
 		irq = oldirq;
 	} else {
-		ret = xa_err(__xa_store(&dist->lpi_xa, intid, irq, 0));
-	}
-
-	xa_unlock_irqrestore(&dist->lpi_xa, flags);
+		/*
+		 * The entry is either empty or contains a dead LPI (refcount=0)
+		 * from the deferred release path, pending cleanup by
+		 * vgic_release_deleted_lpis(). Evict and free it if present.
+		 */
+		oldirq = __xa_store(&dist->lpi_xa, intid, irq, 0);
+		ret = xa_err(oldirq);
+		if (ret) {
+			xa_unlock_irqrestore(&dist->lpi_xa, flags);
+			kfree(irq);
 
-	if (ret) {
-		xa_release(&dist->lpi_xa, intid);
-		kfree(irq);
+			return ERR_PTR(ret);
+		}
 
-		return ERR_PTR(ret);
+		if (oldirq && !WARN_ON_ONCE(refcount_read(&oldirq->refcount)))
+			kfree_rcu(oldirq, rcu);
 	}
 
+	xa_unlock_irqrestore(&dist->lpi_xa, flags);
+
 	/*
 	 * We "cache" the configuration table entries in our struct vgic_irq's.
 	 * However we only have those structs for mapped IRQs, so we read in
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 5a4768d8cd4f..eea9db2bac4a 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -146,11 +146,7 @@ static __must_check bool __vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq)
 
 static __must_check bool vgic_put_irq_norelease(struct kvm *kvm, struct vgic_irq *irq)
 {
-	if (!__vgic_put_irq(kvm, irq))
-		return false;
-
-	irq->pending_release = true;
-	return true;
+	return __vgic_put_irq(kvm, irq);
 }
 
 void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq)
@@ -167,12 +163,14 @@ void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq)
 		guard(spinlock_irqsave)(&dist->lpi_xa.xa_lock);
 	}
 
-	if (!__vgic_put_irq(kvm, irq))
+	if (!irq_is_lpi(kvm, irq->intid))
 		return;
 
-	xa_lock_irqsave(&dist->lpi_xa, flags);
-	vgic_release_lpi_locked(dist, irq);
-	xa_unlock_irqrestore(&dist->lpi_xa, flags);
+	if (refcount_dec_and_lock_irqsave(&irq->refcount,
+					  &dist->lpi_xa.xa_lock, &flags)) {
+		vgic_release_lpi_locked(dist, irq);
+		xa_unlock_irqrestore(&dist->lpi_xa, flags);
+	}
 }
 
 static void vgic_release_deleted_lpis(struct kvm *kvm)
@@ -184,7 +182,7 @@ static void vgic_release_deleted_lpis(struct kvm *kvm)
 	xa_lock_irqsave(&dist->lpi_xa, flags);
 
 	xa_for_each(&dist->lpi_xa, intid, irq) {
-		if (irq->pending_release)
+		if (!refcount_read(&irq->refcount))
 			vgic_release_lpi_locked(dist, irq);
 	}
 
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index fe49fb56dc3c..cefddc9c621d 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -247,9 +247,6 @@ struct vgic_irq {
 					 * affinity reg (v3).
 					 */
 
-	bool pending_release:1;		/* Used for LPIs only, unreferenced IRQ
-					 * pending a release */
-
 	bool pending_latch:1;		/* The pending latch state used to calculate
 					 * the pending state for both level
 					 * and edge triggered IRQs. */
-- 
2.51.0

