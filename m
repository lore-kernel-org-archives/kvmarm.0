Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFDA03815D1
	for <kvmarm@lists.linux.dev>; Thu,  9 Jul 2026 14:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783608249; cv=none; b=R5nn//hWak/ohXkESRrHU5DWwNtrCQDA77iWnMw1AET4LKimwEvBrSDGJrG+t2Orwqr+aNaNgFuNel+ccy1Hy/mOMMCe92PYba9dQ1UWNhYeREv7J8VvwZgotZ+iHs72pw0/jfujAY//p4gq/WzU1Q4CNwNkyza3d8LGrCmGF+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783608249; c=relaxed/simple;
	bh=3HBty0mK2soeUzCus2sJZmd36ssqBx3cCIfS9feKENA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B9poX+52cFoonJ7QBgF04eDjynMCZrDHz5eucdeghHxXNwRFf+/ldBbtu47Mf2gYDVymvBMaHWtoeNnEq3McNihTzxQM3aLmwQ+f8oqQVkZV+LjrRTxlBQCD4QHxXAv8+xrA3zO+eZTiIsEaf5UcUpVvYFtEgJ+nfznua/MgW7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=kqKYXH4u; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=MyUlLMxO; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=kqKYXH4u; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=MyUlLMxO; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="kqKYXH4u";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="MyUlLMxO";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="kqKYXH4u";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="MyUlLMxO"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 599C176255;
	Thu,  9 Jul 2026 14:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783608246; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9hplwfazgwjRyCuU/Acr0FO9jpKguLICVnRSdjgXe3U=;
	b=kqKYXH4u3y0Iq5VIRMUinUwj8WjdwDPAkzh+3q1l4CwjC/x1LdXF/ZnS2IdSL2jftjs0He
	8vHiEf26Oo3fGJCW6lPOWfvTWDj4DPPtF9vWlOgl3Ai9FMpu1mnMErfveMvoIY4oUcGnBY
	VTjsdfCbpsV68NwcACUeIt7fIx4/tak=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783608246;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9hplwfazgwjRyCuU/Acr0FO9jpKguLICVnRSdjgXe3U=;
	b=MyUlLMxOklJZvIutkkUwC+u2dgohX1yKR5NBnDZOBcvKf3GjyC4FPg2cmjD3GbwfF73XAJ
	i1ZHCwfkcifCwsCg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=kqKYXH4u;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=MyUlLMxO
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783608246; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9hplwfazgwjRyCuU/Acr0FO9jpKguLICVnRSdjgXe3U=;
	b=kqKYXH4u3y0Iq5VIRMUinUwj8WjdwDPAkzh+3q1l4CwjC/x1LdXF/ZnS2IdSL2jftjs0He
	8vHiEf26Oo3fGJCW6lPOWfvTWDj4DPPtF9vWlOgl3Ai9FMpu1mnMErfveMvoIY4oUcGnBY
	VTjsdfCbpsV68NwcACUeIt7fIx4/tak=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783608246;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9hplwfazgwjRyCuU/Acr0FO9jpKguLICVnRSdjgXe3U=;
	b=MyUlLMxOklJZvIutkkUwC+u2dgohX1yKR5NBnDZOBcvKf3GjyC4FPg2cmjD3GbwfF73XAJ
	i1ZHCwfkcifCwsCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A360F779AA;
	Thu,  9 Jul 2026 14:44:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id EHhNJbWzT2pfegAAD6G6ig
	(envelope-from <clopez@suse.de>); Thu, 09 Jul 2026 14:44:05 +0000
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
Subject: [PATCH v5 2/2] KVM: arm64: vgic: Mitigate potential LPI registration failure
Date: Thu,  9 Jul 2026 16:42:25 +0200
Message-ID: <20260709144225.3433646-4-clopez@suse.de>
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
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 599C176255
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
	RCPT_COUNT_TWELVE(0.00)[13];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

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
index 468533245727..eda5692c178f 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -124,7 +124,8 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
 		 * holds before freeing it, as otherwise someone else could still
 		 * hold a pointer to the evicted struct.
 		 */
-		oldirq = __xa_store(&dist->lpi_xa, intid, irq, 0);
+		oldirq = __xa_store(&dist->lpi_xa, intid, irq,
+				    GFP_NOWAIT | __GFP_ACCOUNT);
 		ret = xa_err(oldirq);
 		if (!ret && oldirq &&
 		    !WARN_ON_ONCE(refcount_read(&oldirq->refcount) ||
-- 
2.51.0

