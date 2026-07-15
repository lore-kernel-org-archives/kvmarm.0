Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F33BD435A93
	for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 10:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784113166; cv=none; b=aa93iVjGOy6WGLjtn68mwuVPRUXbSBrQ5Cmak2DjCCOvi/IeNepFktKq3jhXALJSbSblKNGgF+sN45DvdvalgQ5pstAPp+GgESJQzHwf8W8Ic+npa6Fn6pA9SDM/KZVmIfyXybexF68c9oUJ81SIyL7KG1VvTXgAKhWujFie13A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784113166; c=relaxed/simple;
	bh=4OjBHDmKbCvGY7qA9l3tQoefpNpkWncfIs0AlOgV18Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=h7PHl6X2a++mpVQ7Gs3Gt/rFlL+2pjWARo+SWvLYpYE0jCgfKXGTro7NXDzqOoYsvoLQZXCgde4d0DAtq+lRn4tTjqQLglz3TB5r4l6JbGQgObu1/S9WY1XusBw7IEKjDKB3cANihycLWQvff6Brh32NfO4eJDx9P6kYBK+TSOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=LwfLK6Xa; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Wr8I4U2P; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=LwfLK6Xa; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Wr8I4U2P; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="LwfLK6Xa";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Wr8I4U2P";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="LwfLK6Xa";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Wr8I4U2P"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DBE453E31;
	Wed, 15 Jul 2026 10:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784113162; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Zom0HCqvV9ymBQMnU5opsJOC+sxs/ZJDLNegrm+5oqU=;
	b=LwfLK6XaYjuvKbqFl8jd8+1qSoaE6jDiORGlue/ymFEzT0h0C4mbyoidK33KqLrvaRFbge
	ZBJGcZpk10AaYpXS6P80v43tAy/dMl+QcZKNOApHWkHAxhB9gV+OK6JXu5KAOBMwPbIL/7
	37S4HTe1jQg2NeWlIKnkdvhzGw8/aCA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784113162;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Zom0HCqvV9ymBQMnU5opsJOC+sxs/ZJDLNegrm+5oqU=;
	b=Wr8I4U2PNE9TkJ5xKU2jZYxQf3LsRNmBBB0Pm1Y+76gFdO7MfcJipz6I0hG9l13TmFDMO+
	ordCan90Cu9EotBQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=LwfLK6Xa;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Wr8I4U2P
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784113162; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Zom0HCqvV9ymBQMnU5opsJOC+sxs/ZJDLNegrm+5oqU=;
	b=LwfLK6XaYjuvKbqFl8jd8+1qSoaE6jDiORGlue/ymFEzT0h0C4mbyoidK33KqLrvaRFbge
	ZBJGcZpk10AaYpXS6P80v43tAy/dMl+QcZKNOApHWkHAxhB9gV+OK6JXu5KAOBMwPbIL/7
	37S4HTe1jQg2NeWlIKnkdvhzGw8/aCA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784113162;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Zom0HCqvV9ymBQMnU5opsJOC+sxs/ZJDLNegrm+5oqU=;
	b=Wr8I4U2PNE9TkJ5xKU2jZYxQf3LsRNmBBB0Pm1Y+76gFdO7MfcJipz6I0hG9l13TmFDMO+
	ordCan90Cu9EotBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 369F6779AD;
	Wed, 15 Jul 2026 10:59:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /biiCgpoV2reeAAAD6G6ig
	(envelope-from <clopez@suse.de>); Wed, 15 Jul 2026 10:59:22 +0000
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
Subject: [PATCH v6 0/2] KVM: arm64: vgic: Fix racy LPI release and re-registration handling
Date: Wed, 15 Jul 2026 12:51:36 +0200
Message-ID: <20260715105137.3973823-3-clopez@suse.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: DBE453E31
X-Spam-Flag: NO
X-Spam-Score: -3.51
X-Spam-Level: 
X-Spamd-Result: default: False [-3.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:dkim];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

Fix a couple of potential issues that could arise from racy LPI release
and re-registration for the same INTID.

The issue fixed in patch 1 can manifest itself through either a
leaked LPI structure, or a prematurely deleted LPI. The issue fixed
in patch 2 could materialize as a spurious -ENOMEM failure when
registering an LPI.

v6:
* Remove pending_release in patch 1, preventing use-after-free and/or
  spurious WARNs.
* Avoid lock inversion via xa_release() (Sashiko).

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

 arch/arm64/kvm/vgic/vgic-its.c | 25 +++++++++++++++++--------
 arch/arm64/kvm/vgic/vgic.c     | 18 ++++++++----------
 include/kvm/arm_vgic.h         |  3 ---
 3 files changed, 25 insertions(+), 21 deletions(-)


base-commit: 1ee27dacbe5dc4def481794d899d67b0d4570094
-- 
2.51.0

