Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D6F83603DA
	for <kvmarm@lists.linux.dev>; Thu,  9 Jul 2026 14:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783608247; cv=none; b=CEFrolb+Gf+3GuuMKBi7MkiWT0ln/gBv2PyfAlFNGRY4eNyP1EsgMMgVA2C32+HSxn3s2aKmXli24ARtfYUcyd55+jP3hK3wUoHVvdkmnJnrhUtP6X/NiP2rpYvERfsF7yLAgx9DuIFzpMafUbkpRq6EJbJAfvhYSDU4AXrLEqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783608247; c=relaxed/simple;
	bh=iASjvH0DSSpapnhZQALk35tuFPSCQqdQBjwrJKnrE1o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=cbZiqqJKOMSM58aqJxQtVmCeY1gVDH19JGaKnCGAgyoBW7VKVRrb3KvLZjgiExEIzTqP+6a/8Zm0jeh/CzBythYbmRtEhUw/JCvDACBD6XIw/vN7SlqiXiBjvNJEXp1sKxIaIEQNVEQ7iTIHOLppWSzZDpKe2y8vqhdx5d0dhfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=SYvmG25x; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=3WvxJkl6; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=SYvmG25x; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=3WvxJkl6; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="SYvmG25x";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="3WvxJkl6";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="SYvmG25x";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="3WvxJkl6"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7524375F8A;
	Thu,  9 Jul 2026 14:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783608244; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=HmS06PlS1xlxxnryRjlMyokhmm0qxQ/VfthHKXtpbNw=;
	b=SYvmG25xrqtTRrcuKXp6sy0s9V+bSPt8iIWU9fUYK6M1aKcInH0bTveL1WmibWltaMHs7E
	tJGlRzMKkimnBl2JCck9TbF0r66tNcb5MywxjfPmyMm/4mmvpKojLvLbi4/X1Ger2juxFz
	kHziwnAS+iTuQfNmNzI9l3Kj8RajMCI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783608244;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=HmS06PlS1xlxxnryRjlMyokhmm0qxQ/VfthHKXtpbNw=;
	b=3WvxJkl6s8LBedvgHECjbnpJgAHMrJKfy4OwO7oiHUnM9LrvFXu0MGKgXPrVONQWEOYhEq
	Kg6CzXKg6z4pspCQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=SYvmG25x;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=3WvxJkl6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783608244; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=HmS06PlS1xlxxnryRjlMyokhmm0qxQ/VfthHKXtpbNw=;
	b=SYvmG25xrqtTRrcuKXp6sy0s9V+bSPt8iIWU9fUYK6M1aKcInH0bTveL1WmibWltaMHs7E
	tJGlRzMKkimnBl2JCck9TbF0r66tNcb5MywxjfPmyMm/4mmvpKojLvLbi4/X1Ger2juxFz
	kHziwnAS+iTuQfNmNzI9l3Kj8RajMCI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783608244;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=HmS06PlS1xlxxnryRjlMyokhmm0qxQ/VfthHKXtpbNw=;
	b=3WvxJkl6s8LBedvgHECjbnpJgAHMrJKfy4OwO7oiHUnM9LrvFXu0MGKgXPrVONQWEOYhEq
	Kg6CzXKg6z4pspCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C9B1B779AA;
	Thu,  9 Jul 2026 14:44:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id snaRLrOzT2pfegAAD6G6ig
	(envelope-from <clopez@suse.de>); Thu, 09 Jul 2026 14:44:03 +0000
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
Subject: [PATCH v5 0/2] KVM: arm64: vgic: Fix racy LPI release and re-registration handling
Date: Thu,  9 Jul 2026 16:42:23 +0200
Message-ID: <20260709144225.3433646-2-clopez@suse.de>
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
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_TWELVE(0.00)[12];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:mid,suse.de:dkim];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 7524375F8A
X-Spam-Score: -3.51

Fix a couple of potential issues that could arise from racy LPI release
and re-registration for the same INTID.

The issue fixed in patch 1 can manifest itself through either a
leaked LPI structure, or a prematurely deleted LPI. The issue fixed
in patch 2 could materialize as a spurious -ENOMEM failure when
registering an LPI.

v5:
* Make sure evicted IRQs on the registration path are pending
  release (Oliver Upton).

v4:
* Add __GFP_ACCOUNT to patch 2 (Sashiko).

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

 arch/arm64/kvm/vgic/vgic-its.c | 16 +++++++++++++++-
 arch/arm64/kvm/vgic/vgic.c     | 10 ++++++----
 2 files changed, 21 insertions(+), 5 deletions(-)


base-commit: 1ee27dacbe5dc4def481794d899d67b0d4570094
-- 
2.51.0

