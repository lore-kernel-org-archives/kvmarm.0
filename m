Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A961133A9CB
	for <kvmarm@lists.linux.dev>; Fri,  3 Jul 2026 11:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783076567; cv=none; b=nI6q0S1DEyDM6CtR2HCKtLG7Bqi9dt+x6bZHeEib89+yPnzQ6Qeb2mZ6/bpsXryyYrkoPUtfeA3D7LBrP1y8ypUsGUW0CTcyCHQ/k0bJreckB8X4ElkO5uAIeGdwYzfEFoUh3B1i6MPA27hDXQXGieN+rlffWAq8xLA1JH4qh9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783076567; c=relaxed/simple;
	bh=75gRK26MYMEGtFN2QthkYAZUv8hizvyEcEXSwlP5cBU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=FpcsR9mlk9qe461uDXuT8R6CEZsPPzCBOkCRJ/jOZpvx/qbBN5+A3xoqBF4aNtMHMIdyR8x20MgeThkIYvAkEjeKZAx/tP/dELcPv+4smDhefMd/Q0Y0+0EuoaGRYymnK9qfFQ1DX203Sn6gzFvdQYxdGubc/B5bNUIaI1wOCIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=mH3vvDrO; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ukFMd8zQ; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=MWLhrO8v; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=95o3mJ2S; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="mH3vvDrO";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ukFMd8zQ";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="MWLhrO8v";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="95o3mJ2S"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C092D75B3B;
	Fri,  3 Jul 2026 11:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783076565; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=PGvbZD7ywqopLmUyxA8byM9CEoPluv6LQwI4b6n0Zo0=;
	b=mH3vvDrOkvClCa3gEN5igb4cmlXH5yjI43o1VmZ9Vbijj3zjm95fxHvzKTRmWY3XX4m1w2
	teEsEGnrgN2I53CypKp5GcwUb21QfEXdCiSPB461xwTUJo5M6c2612jrf4uBOu8Wa4m2nd
	Kv5Hcogc84ASsH5UsrXyiQkRyWiY9BM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783076565;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=PGvbZD7ywqopLmUyxA8byM9CEoPluv6LQwI4b6n0Zo0=;
	b=ukFMd8zQezzkN9v/CKDOgyaIH9kAmQsRHILMdzz8g0lzJrspi141k7AbKqq1ZBKNKqyXK0
	8oFpD4FNjyOqxoCQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=MWLhrO8v;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=95o3mJ2S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783076564; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=PGvbZD7ywqopLmUyxA8byM9CEoPluv6LQwI4b6n0Zo0=;
	b=MWLhrO8vsBF2Nv39fWIcIAo9rqR7XjjyWXeC5ixkJ7Xd9xrOxWOCJQ2oEOfLMMGiUvJOTt
	KoWRp8gZZJ9kivEJkzHLHkGrxxvMHk3OXdvtKtbAgEjgeRJKtAdGlWTTafkK/CUO5usqi9
	aWdrusJrqJo/ArcnmuZzo0Etwp36EbE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783076564;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=PGvbZD7ywqopLmUyxA8byM9CEoPluv6LQwI4b6n0Zo0=;
	b=95o3mJ2SoX28GelFVi3gXmNtwCRg7/t605XqN2AWPchheI7ngVjHgdXCFvbVr3J3X0HJ8m
	vO9UwBFtgGIRlyDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DF9CC779AA;
	Fri,  3 Jul 2026 11:02:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QGcuM9OWR2pMTwAAD6G6ig
	(envelope-from <clopez@suse.de>); Fri, 03 Jul 2026 11:02:43 +0000
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
Subject: [PATCH v3 0/2] KVM: arm64: vgic: Fix racy LPI release and re-registration handling
Date: Fri,  3 Jul 2026 13:01:28 +0200
Message-ID: <20260703110130.2609872-2-clopez@suse.de>
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
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: C092D75B3B
X-Spam-Score: -3.51

Fix a couple of potential issues that could arise from racy LPI release
and re-registration for the same INTID.

The issue fixed in patch 1 can manifest itself through either a
leaked LPI structure, or a prematurely deleted LPI. The issue fixed
in patch 2 could materialize as a spurious -ENOMEM failure when
registering an LPI.

v3:
* Use refcount_dec_and_lock_irqsave() instead of unconditionally
  grabbing the xarray lock in patch 1.
* Add patch 2.

v2:
* Address Sashiko's review. Fix the direct release path by decrementing
  the refcount under the xarray spinlock, preventing a UAF that would
  have been introduced in v1.

Carlos López (2):
  KVM: arm64: vgic: Fix race between LPI release and re-registration
  KVM: arm64: vgic: Mitigate potential LPI registration failure

 arch/arm64/kvm/vgic/vgic-its.c | 10 +++++++++-
 arch/arm64/kvm/vgic/vgic.c     | 10 ++++++----
 2 files changed, 15 insertions(+), 5 deletions(-)


base-commit: 1ee27dacbe5dc4def481794d899d67b0d4570094
-- 
2.51.0

