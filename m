Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9B254483BE
	for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 10:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784113172; cv=none; b=dU3yoDePRo1mETPmKAk3O+2+RJvCcrAkIsB3Y+y6hsqhUgodrMHTtSDyhwNPaJL8UeGIMtLwXocuCbDWlcI5T+2n+9bTjs6RRSelRkPnMT9bYqxkZrGIrXhOzASEmnCuiiqbe2P/GB6vaxPD3xo8ue/ucqoLkSEPfRWnaQKdXR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784113172; c=relaxed/simple;
	bh=WJ32j0CLkhKJhaDryc90Jc+BbzqGeXNaZD2vQ9H7+bA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uzOxD8XLTTP/ryJ038l6eWukIqCU2sLsv20uVPAECsjqWFKiN5GPJmsYXt2fYtIMYvJZ79vN4BknP+LOrLUEAPofCA+/4eia1oPp/NfyvrQablIdUwWOfVI3m6MC71FNUfs0h9lisKSClh2MwTjO4sdM4+d4ufZq2KA/lsCCXvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ti/dA1g3; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=EQA3QzEM; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ti/dA1g3; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=EQA3QzEM; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ti/dA1g3";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="EQA3QzEM";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ti/dA1g3";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="EQA3QzEM"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D01F23E2C;
	Wed, 15 Jul 2026 10:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784113164; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=we7lqF6l0Qar7m9x4y+leMPoOiIHvjnft51zpxljQgY=;
	b=ti/dA1g3X18nyqG7vhY2tRPVSYR5ylC7FgrZ9rdWpGiCK+ToUREAfgzmrZJxpDPeB2L1WQ
	vhN84cQ4UfUy9TQdbUM6U/ywHRUiw3rvkBF34D+a3QnycVpakUd4g4oMhSQlXobLJNcpcW
	qIkNRK8CP4BYLJ9Gyhn2/a7jZJRkTDo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784113164;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=we7lqF6l0Qar7m9x4y+leMPoOiIHvjnft51zpxljQgY=;
	b=EQA3QzEMogjuEJKyRgd1oCggHhTAcx1SpRrTMwYurGNhu8Ci0PV1C74P8OY8qs4lfjWYSv
	gjELzdQLTQ0uBnBA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="ti/dA1g3";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=EQA3QzEM
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784113164; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=we7lqF6l0Qar7m9x4y+leMPoOiIHvjnft51zpxljQgY=;
	b=ti/dA1g3X18nyqG7vhY2tRPVSYR5ylC7FgrZ9rdWpGiCK+ToUREAfgzmrZJxpDPeB2L1WQ
	vhN84cQ4UfUy9TQdbUM6U/ywHRUiw3rvkBF34D+a3QnycVpakUd4g4oMhSQlXobLJNcpcW
	qIkNRK8CP4BYLJ9Gyhn2/a7jZJRkTDo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784113164;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=we7lqF6l0Qar7m9x4y+leMPoOiIHvjnft51zpxljQgY=;
	b=EQA3QzEMogjuEJKyRgd1oCggHhTAcx1SpRrTMwYurGNhu8Ci0PV1C74P8OY8qs4lfjWYSv
	gjELzdQLTQ0uBnBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 237BC779AD;
	Wed, 15 Jul 2026 10:59:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QEnVBQxoV2reeAAAD6G6ig
	(envelope-from <clopez@suse.de>); Wed, 15 Jul 2026 10:59:24 +0000
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
	=?UTF-8?q?Carlos=20L=C3=B3pez?= <clopez@suse.de>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v6 2/2] KVM: arm64: vgic: Mitigate potential LPI registration failure
Date: Wed, 15 Jul 2026 12:51:38 +0200
Message-ID: <20260715105137.3973823-5-clopez@suse.de>
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
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RL17rns84hbggp9ounzx9knj39)];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:dkim,suse.de:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: D01F23E2C
X-Spam-Score: -3.51

Mitigate a potential failure when inserting a new LPI into the VGIC LPI
xarray.

When vgic_add_lpi() is preparing to register a new LPI, it pre-allocates
an xarray entry using xa_reserve_irq(), so that it can later perform the
insertion under the xarray lock without allocating.

However, since xa_reserve_irq() is called before acquiring such lock,
there is a potential race where xa_reserve_irq() observes a populated
entry, thus not performing the allocation, and another CPU removes that
entry before the xarray lock is grabbed to perform the insertion.

  CPU0 (Adding new LPI)                      CPU1 (Releasing LPI)
  =====================                      ===================
  vgic_add_lpi()
      /* Entry populated, does not allocate */
      xa_reserve_irq(.., intid, ..)
                                            vgic_release_deleted_lpis()
                                                xa_lock_irqsave()
                                                vgic_release_lpi_locked()
                          xarray node freed --> __xa_erase(.., intid)
                                                xa_unlock_irqrestore()
      xa_lock_irqsave()
      xa_load(.., intid) == NULL
      vgic_try_get_irq_ref(NULL) == false
      __xa_store(.., intid, irq, 0) <-- xarray node was freed, gfp=0
                                        cannot allocate, returns -ENOMEM

This can happen e.g. if the guest issues a DISCARD while the LPI is
still referenced from a vCPU's active-pending list (ap_list), and the
same INTID is re-mapped via MAPTI.

Mitigate this by passing GFP_NOWAIT to __xa_store(), so that the
allocation can happen under the lock in the rare case that this
condition is hit. Add __GFP_ACCOUNT as well to match xa_reserve_irq()'s
flags.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: 1d6f83f60f79 ("KVM: arm64: vgic: Store LPIs in an xarray")
Signed-off-by: Carlos López <clopez@suse.de>
---
 arch/arm64/kvm/vgic/vgic-its.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 2240bdf20c92..b59e0e0e1e82 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -121,7 +121,8 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
 		 * from the deferred release path, pending cleanup by
 		 * vgic_release_deleted_lpis(). Evict and free it if present.
 		 */
-		oldirq = __xa_store(&dist->lpi_xa, intid, irq, 0);
+		oldirq = __xa_store(&dist->lpi_xa, intid, irq,
+				    GFP_NOWAIT | __GFP_ACCOUNT);
 		ret = xa_err(oldirq);
 		if (ret) {
 			xa_unlock_irqrestore(&dist->lpi_xa, flags);
-- 
2.51.0

