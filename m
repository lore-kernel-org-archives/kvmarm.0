Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D7893D171C
	for <kvmarm@lists.linux.dev>; Fri,  3 Jul 2026 12:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783081664; cv=none; b=ikYechdsbOEBSQsoQAS36gH/vSmwsRwH4FeePsiDGijtMWqcVkspWAVJnEJhcfw5VfdXBti1gOgN5Z+8UXW/rcz/tK63Hr2ItsE1Ey9BFWDabz2CXsPZYWwPRvsNEiD+JKk25S1ilxXg1UGs3wqIfZD22P0NZnNT56WEkg6Hht8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783081664; c=relaxed/simple;
	bh=3SJ0wgrGLJoSIKRq3JnLtG8Mcus0f7pVzGn04CIM1Y4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VMQDT7C2CMnX9Zb8OL2kjLmEyLw2UIbJyv2XPatxCBfOfjbxkM/01tX29fEQsoccWy0v2RuNxnd57jKGVZVGk8hVkfznZwIDyl+V+4ACTqOHXneO9g6CJ534f6/kHoZH7okcLvlVxzP6Xz4lYqqqw2AhmlHCco3vpmpsFQiGc9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=SDXhQoDl; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=zGjIiGPJ; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=SDXhQoDl; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=zGjIiGPJ; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="SDXhQoDl";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="zGjIiGPJ";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="SDXhQoDl";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="zGjIiGPJ"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1DF4F7488C;
	Fri,  3 Jul 2026 12:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783081657; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=biosK3lOfbNV5gPf8PkSrrDXTwtDCzEN6gEcCVZoCig=;
	b=SDXhQoDlLrwrApXxN6U3+Ee3hFlmEGShX/5oVrbTGLhBDBuy7toG0AE/VG71LguignZPsa
	2jBAXpibEvHbFVPUbPwfrFZVyn/wBlFV5zGEEgVrli87Rt5U7ooCOEfkF1D+tOwyAvdywm
	CAMkMkVYcFXy31YNwFua4HpMte38eWY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783081657;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=biosK3lOfbNV5gPf8PkSrrDXTwtDCzEN6gEcCVZoCig=;
	b=zGjIiGPJvLwR8bfaRiNl1uDoF01feLP/dLIv8PCKfCjjzW9utuXvCU51XlHY07c2RFFuPS
	oclvFSWWfruC23BQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783081657; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=biosK3lOfbNV5gPf8PkSrrDXTwtDCzEN6gEcCVZoCig=;
	b=SDXhQoDlLrwrApXxN6U3+Ee3hFlmEGShX/5oVrbTGLhBDBuy7toG0AE/VG71LguignZPsa
	2jBAXpibEvHbFVPUbPwfrFZVyn/wBlFV5zGEEgVrli87Rt5U7ooCOEfkF1D+tOwyAvdywm
	CAMkMkVYcFXy31YNwFua4HpMte38eWY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783081657;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=biosK3lOfbNV5gPf8PkSrrDXTwtDCzEN6gEcCVZoCig=;
	b=zGjIiGPJvLwR8bfaRiNl1uDoF01feLP/dLIv8PCKfCjjzW9utuXvCU51XlHY07c2RFFuPS
	oclvFSWWfruC23BQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 542C2779AA;
	Fri,  3 Jul 2026 12:27:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id GABAEbiqR2rGIwAAD6G6ig
	(envelope-from <clopez@suse.de>); Fri, 03 Jul 2026 12:27:36 +0000
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
Subject: [PATCH v4 2/2] KVM: arm64: vgic: Mitigate potential LPI registration failure
Date: Fri,  3 Jul 2026 14:26:01 +0200
Message-ID: <20260703122601.2617577-4-clopez@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260703122601.2617577-2-clopez@suse.de>
References: <20260703122601.2617577-2-clopez@suse.de>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -7.30
X-Spamd-Result: default: False [-7.30 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.994];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid]
X-Spam-Level: 

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
index 577286069368..327418477c51 100644
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
 		if (!ret && oldirq)
 			kfree_rcu(oldirq, rcu);
-- 
2.51.0

