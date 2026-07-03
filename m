Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E59933B951
	for <kvmarm@lists.linux.dev>; Fri,  3 Jul 2026 11:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783076568; cv=none; b=tH9zYN+KMlmE55UmlcaO4y1XSWljWi0UJNxEom0lQ10UYAlvg2Ir7E2TaIei9AR5CEuOhS7i39oloVWsLPXbkERPFK7RicGHLfDxrPaf2p14M6C+NOP0441V1/6Qc7S5eT8+9+bBUvnoJblvZztkPk26M6CB4owTZqe/W8Z4krQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783076568; c=relaxed/simple;
	bh=D18ibp70N1lueT6EbT3wXabuep3VCo7WEa+reapGatg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HmcWsM/H7br2wIFQZe3mIJw+A0bmIG/+Qh5mG5DgZ6gj3Vu2MNtoXknRkHkz6AetKKjZuwPCyDZWdPBrYhm+3bZQPbTnsfc7mFv1AXQz5BROZ1GVc0DLd3cGnLcWjzRu5FCYOg4F4yQwGQqpiWtNxJD31gp1VKaAgBZ6wv1a3MQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=pU42T875; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=xEPt59no; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=pU42T875; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=xEPt59no; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="pU42T875";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="xEPt59no";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="pU42T875";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="xEPt59no"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C223B74889;
	Fri,  3 Jul 2026 11:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783076565; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VHCxXWPnzYyjoLRwh7NLGv9YF8OLiGlKRXFEoR8cvTk=;
	b=pU42T875IpVerDwTOSSzWpMZWkJdSQ6/VWCz8pVkgC37xIhuXY+nIBQHf24k+nTzRLZgIY
	XtKmqC5YkU0za3h4fEQtfrcPa4vbiOg4C0rOgSkVqyWLcfiKH0oOHg2vnAGF9CVadKnNJp
	mwnFQOuoLaiMnYSUxMp/l92J9E6Zsn4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783076565;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VHCxXWPnzYyjoLRwh7NLGv9YF8OLiGlKRXFEoR8cvTk=;
	b=xEPt59nozeBqLUF1U09HJZtkA3qCXYHO0WD18ffsB0kuyb4mlk7zegQ1oSb1sCsvNZGjo+
	TMdeePZL/WafucAA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=pU42T875;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=xEPt59no
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783076565; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VHCxXWPnzYyjoLRwh7NLGv9YF8OLiGlKRXFEoR8cvTk=;
	b=pU42T875IpVerDwTOSSzWpMZWkJdSQ6/VWCz8pVkgC37xIhuXY+nIBQHf24k+nTzRLZgIY
	XtKmqC5YkU0za3h4fEQtfrcPa4vbiOg4C0rOgSkVqyWLcfiKH0oOHg2vnAGF9CVadKnNJp
	mwnFQOuoLaiMnYSUxMp/l92J9E6Zsn4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783076565;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VHCxXWPnzYyjoLRwh7NLGv9YF8OLiGlKRXFEoR8cvTk=;
	b=xEPt59nozeBqLUF1U09HJZtkA3qCXYHO0WD18ffsB0kuyb4mlk7zegQ1oSb1sCsvNZGjo+
	TMdeePZL/WafucAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 10ABC779AC;
	Fri,  3 Jul 2026 11:02:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WBxiAdWWR2pMTwAAD6G6ig
	(envelope-from <clopez@suse.de>); Fri, 03 Jul 2026 11:02:45 +0000
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
Subject: [PATCH v3 1/2] KVM: arm64: vgic: Fix race between LPI release and re-registration
Date: Fri,  3 Jul 2026 13:01:29 +0200
Message-ID: <20260703110130.2609872-3-clopez@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260703110130.2609872-2-clopez@suse.de>
References: <20260703110130.2609872-2-clopez@suse.de>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spamd-Result: default: False [-3.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_TWELVE(0.00)[12];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:dkim,suse.de:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: C223B74889
X-Spam-Score: -3.51

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

To fix the deferred release path, since the refcount drop must happen
under a raw spinlock, the same solution does not work. Instead, update
vgic_add_lpi(), so that if it evicts a non-NULL refcount=0 LPI from the
xarray, it takes on the responsibility of releasing it. If this happens,
vgic_release_deleted_lpis() will iterate the xarray normally and will
simply not find the already released structure.

Reported-by: Claude:claude-opus-4-6
Fixes: 3a08a6ca7c37 ("KVM: arm64: vgic-v3: Use bare refcount for VGIC LPIs")
Fixes: d54594accf73 ("KVM: arm64: vgic-v3: Erase LPIs from xarray outside of raw spinlocks")
Signed-off-by: Carlos López <clopez@suse.de>
---
 arch/arm64/kvm/vgic/vgic-its.c | 10 +++++++++-
 arch/arm64/kvm/vgic/vgic.c     | 10 ++++++----
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 67d107e9a77d..577286069368 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -116,7 +116,15 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
 		kfree(irq);
 		irq = oldirq;
 	} else {
-		ret = xa_err(__xa_store(&dist->lpi_xa, intid, irq, 0));
+		/*
+		 * The entry is either empty or contains a dead LPI (refcount=0)
+		 * from the deferred release path, pending cleanup by
+		 * vgic_release_deleted_lpis(). Evict and free it if present.
+		 */
+		oldirq = __xa_store(&dist->lpi_xa, intid, irq, 0);
+		ret = xa_err(oldirq);
+		if (!ret && oldirq)
+			kfree_rcu(oldirq, rcu);
 	}
 
 	xa_unlock_irqrestore(&dist->lpi_xa, flags);
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 5a4768d8cd4f..cc09e0c45b46 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -167,12 +167,14 @@ void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq)
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
-- 
2.51.0

