Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C53538657D
	for <kvmarm@lists.linux.dev>; Thu,  9 Jul 2026 14:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783608253; cv=none; b=PhHs9qf7rQnOZatnEFt8b0xPbV105UhKWFtehxhESi3qt/5dpbQJ381J7HCkINoLQzIAf+PgSO2nF9CB1PrWY8VMNVgl9FuYS/TYDBgwH9eqOwRCyhC9JrkUi99cG1JbP3FIy1nMigY43BU4FTb+pEkBSWRGTckKLjruyjLW55s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783608253; c=relaxed/simple;
	bh=qhhxOCDrC6XktS1ApgaRpU3x/+IZtzX5wfQ5VIN23lM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oVG/2Wes2tRgUbAeiQ2sPfLzhtv3rRE7S2BwxEopGf3W5slvYmXymFMcjjjkPty/lmPkNihrbuFx1ElT9hMSbtC5N4357lYtR31Z140AowIPeHXSYd0KxWvMu8NcIzSkYbuAz0Agm/V2mzDziRsXRfUWKoMSvAkmvhonv1IZg08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=hd8yRHCv; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=M8Y3SXPw; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=hd8yRHCv; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=M8Y3SXPw; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="hd8yRHCv";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="M8Y3SXPw";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="hd8yRHCv";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="M8Y3SXPw"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6923675F8B;
	Thu,  9 Jul 2026 14:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783608245; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wBh94n/OQm/LgeI3R7ai8Zi4YxVO3ijv1f0zpHORLT4=;
	b=hd8yRHCvntCQec1DCtfpoNG+YjdnPZNaSdhWyKWqWDdVMfHW8JCt7QphwyeFxNsrsXygb2
	+xgBfVcKqg6UiOggkSpEDwzxGoWwncYDjRNtLdnZ3xtHazCx2YQNso8gPLpUwfPIzYVU2h
	2d9I+4MDaB0oXYFYQkZhSKox2iK21hI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783608245;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wBh94n/OQm/LgeI3R7ai8Zi4YxVO3ijv1f0zpHORLT4=;
	b=M8Y3SXPwE5WNgpB8v9nSKRHUUApRfWtwnUR5dk/fzpm6IwPN6pm3vHYlM7LfbxXOuqM9AC
	4q0uwe34Ku44foAg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783608245; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wBh94n/OQm/LgeI3R7ai8Zi4YxVO3ijv1f0zpHORLT4=;
	b=hd8yRHCvntCQec1DCtfpoNG+YjdnPZNaSdhWyKWqWDdVMfHW8JCt7QphwyeFxNsrsXygb2
	+xgBfVcKqg6UiOggkSpEDwzxGoWwncYDjRNtLdnZ3xtHazCx2YQNso8gPLpUwfPIzYVU2h
	2d9I+4MDaB0oXYFYQkZhSKox2iK21hI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783608245;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wBh94n/OQm/LgeI3R7ai8Zi4YxVO3ijv1f0zpHORLT4=;
	b=M8Y3SXPwE5WNgpB8v9nSKRHUUApRfWtwnUR5dk/fzpm6IwPN6pm3vHYlM7LfbxXOuqM9AC
	4q0uwe34Ku44foAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BF434779AC;
	Thu,  9 Jul 2026 14:44:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wIsULLSzT2pfegAAD6G6ig
	(envelope-from <clopez@suse.de>); Thu, 09 Jul 2026 14:44:04 +0000
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
Subject: [PATCH v5 1/2] KVM: arm64: vgic: Fix race between LPI release and re-registration
Date: Thu,  9 Jul 2026 16:42:24 +0200
Message-ID: <20260709144225.3433646-3-clopez@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260709144225.3433646-2-clopez@suse.de>
References: <20260709144225.3433646-2-clopez@suse.de>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -3.30
X-Spamd-Result: default: False [-3.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid]
X-Spam-Level: 

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
 arch/arm64/kvm/vgic/vgic-its.c | 15 ++++++++++++++-
 arch/arm64/kvm/vgic/vgic.c     | 10 ++++++----
 2 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 67d107e9a77d..468533245727 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -116,7 +116,20 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
 		kfree(irq);
 		irq = oldirq;
 	} else {
-		ret = xa_err(__xa_store(&dist->lpi_xa, intid, irq, 0));
+		/*
+		 * The entry is either empty or contains a dead LPI (refcount=0)
+		 * from the deferred release path, pending cleanup by
+		 * vgic_release_deleted_lpis(). Evict and free it if present.
+		 * Make sure that the assumption that the IRQ is pending release
+		 * holds before freeing it, as otherwise someone else could still
+		 * hold a pointer to the evicted struct.
+		 */
+		oldirq = __xa_store(&dist->lpi_xa, intid, irq, 0);
+		ret = xa_err(oldirq);
+		if (!ret && oldirq &&
+		    !WARN_ON_ONCE(refcount_read(&oldirq->refcount) ||
+				  !oldirq->pending_release))
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

