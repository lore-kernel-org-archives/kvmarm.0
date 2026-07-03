Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43BBD23EAAD
	for <kvmarm@lists.linux.dev>; Fri,  3 Jul 2026 02:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783045224; cv=none; b=Y33JvJ8SSzT37Q/1pNRlO300HkcUaWHZM0ubsox8eQ+NKATXsP3VYHsVG6EPPSoi6w/yVcIkVZLoiQppps4H4jseHHDP9ZYQpBT2Joi1cbwiArDooL2JW+u26+wxJqT/ixF0cfhp8G6MgqjLoQG8pr2lj1+HG/VoBqCT65xd9g4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783045224; c=relaxed/simple;
	bh=IHOhk0SA/V4BNP9tuILeiCBCwW91JwnOFYtNZSrVn58=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=GY3Rv9+wML++SArCvV393k+xDGa5AZl79u4OhM286NMvTlno9mflJ+t6cFnTZl7U8UU7LdlpULoDRUivk7p7nfVKX/nkn58NEKs6Nake7n4rl1dsFCtLYhTsYUnFL7jq4599PQVFDDXcZUaT9PdnWMJUH72TFa8GzcZN7ZoaygY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=G6tUaFAz; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=y1au2qKf; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=G6tUaFAz; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=y1au2qKf; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="G6tUaFAz";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="y1au2qKf";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="G6tUaFAz";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="y1au2qKf"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5318875A83;
	Fri,  3 Jul 2026 02:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783045221; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Gy8PezjJJE9te+390RqXGx7PI/xRpzoFljabhjLAsNw=;
	b=G6tUaFAzNUdxTJwhuVhxrsKYE+I/L0G9cHjVgwf/6wfKAtmUg+GsLcFkGq3lseMOTn9Rxi
	xQ0YvZxXD3u7n+BNoSyGB6cfdbLqn5sY1r9Wsb5P8ZPA73Lt7h+jUd5PftXReylQ7BXr8w
	QAI6ERjvJ40S00Se20IerD9Sd9gXWNs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783045221;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Gy8PezjJJE9te+390RqXGx7PI/xRpzoFljabhjLAsNw=;
	b=y1au2qKfGWLqbDl6ZFhXFbTTrrep4rgnzMcm3UM0iuta9qok7DTzlgBX64zgupnMEEO4Ak
	Iby2/eze2C5EJ7Bw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=G6tUaFAz;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=y1au2qKf
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783045221; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Gy8PezjJJE9te+390RqXGx7PI/xRpzoFljabhjLAsNw=;
	b=G6tUaFAzNUdxTJwhuVhxrsKYE+I/L0G9cHjVgwf/6wfKAtmUg+GsLcFkGq3lseMOTn9Rxi
	xQ0YvZxXD3u7n+BNoSyGB6cfdbLqn5sY1r9Wsb5P8ZPA73Lt7h+jUd5PftXReylQ7BXr8w
	QAI6ERjvJ40S00Se20IerD9Sd9gXWNs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783045221;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Gy8PezjJJE9te+390RqXGx7PI/xRpzoFljabhjLAsNw=;
	b=y1au2qKfGWLqbDl6ZFhXFbTTrrep4rgnzMcm3UM0iuta9qok7DTzlgBX64zgupnMEEO4Ak
	Iby2/eze2C5EJ7Bw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A04EA779AA;
	Fri,  3 Jul 2026 02:20:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1/okJGQcR2qnXAAAD6G6ig
	(envelope-from <clopez@suse.de>); Fri, 03 Jul 2026 02:20:20 +0000
From: =?UTF-8?q?Carlos=20L=C3=B3pez?= <clopez@suse.de>
To: kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Carlos=20L=C3=B3pez?= <clopez@suse.de>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org (moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64))
Subject: [PATCH v2] KVM: arm64: vgic: Fix race between LPI release and re-registration
Date: Fri,  3 Jul 2026 04:15:08 +0200
Message-ID: <20260703021508.2593100-2-clopez@suse.de>
X-Mailer: git-send-email 2.51.0
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
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:dkim,suse.de:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 5318875A83
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
                                              xa_lock_irqsave(..);
                                              old_irq = xa_load(&dist->lpi_xa, intid);
                                              vgic_try_get_irq_ref(old_irq) == false
                        new IRQ inserted -->  __xa_store(&dist->lpi_xa, intid, ..)
                                              xa_unlock_irqrestore(..);
  xa_lock_irqsave(..);
  vgic_release_lpi_locked()
      __xa_erase(&dist->lpi_xa, irq->intid);   <-- BUG: new IRQ is erased
      kfree_rcu(old_irq)

During the deferred release path, the old IRQ can be leaked:

  CPU0 (Releasing LPI)                    CPU1 (Adding new LPI)
  ====================                    =====================
  vgic_put_irq_norelease()
      __vgic_put_irq()
          refcount_dec_and_test()
      irq->pending_release = true
                                          vgic_add_lpi()
                                              xa_lock_irqsave(..);
                                              old_irq = xa_load(&dist->lpi_xa, intid);
                                              vgic_try_get_irq_ref() == false
                 BUG: old IRQ overwritten --> __xa_store(&dist->lpi_xa, intid, ..)
                                              xa_unlock_irqrestore(..);

  vgic_release_deleted_lpis()
      xa_lock_irqsave(..);
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
v2:
* Address Sashiko's review. Fix the direct release path by decrementing the
  refcount under the xarray spinlock, preventing a UAF that would have been
  introduced in v1.
---
 arch/arm64/kvm/vgic/vgic-its.c | 10 +++++++++-
 arch/arm64/kvm/vgic/vgic.c     |  5 +++--
 2 files changed, 12 insertions(+), 3 deletions(-)

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
index 5a4768d8cd4f..c32e6c9777e5 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -167,11 +167,12 @@ void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq)
 		guard(spinlock_irqsave)(&dist->lpi_xa.xa_lock);
 	}
 
-	if (!__vgic_put_irq(kvm, irq))
+	if (!irq_is_lpi(kvm, irq->intid))
 		return;
 
 	xa_lock_irqsave(&dist->lpi_xa, flags);
-	vgic_release_lpi_locked(dist, irq);
+	if (refcount_dec_and_test(&irq->refcount))
+		vgic_release_lpi_locked(dist, irq);
 	xa_unlock_irqrestore(&dist->lpi_xa, flags);
 }
 

base-commit: 1ee27dacbe5dc4def481794d899d67b0d4570094
-- 
2.51.0

