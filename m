Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D311A3093CF
	for <kvmarm@lists.linux.dev>; Fri,  3 Jul 2026 12:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783081658; cv=none; b=qC400rjB6O2F//SVNWyijy4gM5MzXRSmYsQv3A0H6DPlt23JxuuT/chMsGgCIj2BgNUpcVZdq/35r9WYCkG+moFE6uOezkZGcmwlKANuoZ7NLEy6ipr4f8Y16iytfePEx0tcqI/aPZqmI+j+Tv05JdmdHERMOcqQTn1ppgbCX/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783081658; c=relaxed/simple;
	bh=DNuhKED9jVnRH6pdAbcp2KLbjx0rKbaFTkcHdLkr8oY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=nSkKCt0P+WfarqiRA2wCwCzZaUekCHrTOfX87iyBMKPTwHw4sIAPCntQISmBVaFNRC+nDI/+uviZU8OkG1SQprba5jqqMZVovjFv4i0jc1zSBTpPjI8WJ7uCW992RTBEoROA1yzxJ6a2moZ0pzaPQM/hwA6gxAGhhr6424CRgF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=0AMLsZcU; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=sJv+21uc; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=0AMLsZcU; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=sJv+21uc; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="0AMLsZcU";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="sJv+21uc";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="0AMLsZcU";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="sJv+21uc"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 077C572B71;
	Fri,  3 Jul 2026 12:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783081655; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=z0l//AzH2HTZT5yTyy4Dvdztx+UanKNGZzbJYyisHgU=;
	b=0AMLsZcUNV2HQ/hEY7zLJFcidNm+mTIiNPKnT/MQgSzLWkA36TCiy2Ut0hq3TExlu71cSx
	JLl9jd6ZNnHv/vhh2ujzfkgBHam9Ps1BUBWrHTgK/ejvc6E/V8r6GBEUfhG1sOTTCFZ5CK
	+DTzSTHao+Kgeo5i+uHJTCuqvq1VFDA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783081655;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=z0l//AzH2HTZT5yTyy4Dvdztx+UanKNGZzbJYyisHgU=;
	b=sJv+21ucU8geHw4xoPX1fzF4rdBpGZkiOwmGRj+1SmzoRrYVvk712GtqjKvO/wBZZYMe6y
	0KbHfyeZU7/uqJCA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783081655; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=z0l//AzH2HTZT5yTyy4Dvdztx+UanKNGZzbJYyisHgU=;
	b=0AMLsZcUNV2HQ/hEY7zLJFcidNm+mTIiNPKnT/MQgSzLWkA36TCiy2Ut0hq3TExlu71cSx
	JLl9jd6ZNnHv/vhh2ujzfkgBHam9Ps1BUBWrHTgK/ejvc6E/V8r6GBEUfhG1sOTTCFZ5CK
	+DTzSTHao+Kgeo5i+uHJTCuqvq1VFDA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783081655;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=z0l//AzH2HTZT5yTyy4Dvdztx+UanKNGZzbJYyisHgU=;
	b=sJv+21ucU8geHw4xoPX1fzF4rdBpGZkiOwmGRj+1SmzoRrYVvk712GtqjKvO/wBZZYMe6y
	0KbHfyeZU7/uqJCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 383EE779AA;
	Fri,  3 Jul 2026 12:27:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1L7SCLaqR2rGIwAAD6G6ig
	(envelope-from <clopez@suse.de>); Fri, 03 Jul 2026 12:27:34 +0000
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
Subject: [PATCH v4 0/2] KVM: arm64: vgic: Fix racy LPI release and re-registration handling
Date: Fri,  3 Jul 2026 14:25:59 +0200
Message-ID: <20260703122601.2617577-2-clopez@suse.de>
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
X-Spam-Score: -3.30
X-Spamd-Result: default: False [-3.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.993];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid]
X-Spam-Level: 

Fix a couple of potential issues that could arise from racy LPI release
and re-registration for the same INTID.

The issue fixed in patch 1 can manifest itself through either a
leaked LPI structure, or a prematurely deleted LPI. The issue fixed
in patch 2 could materialize as a spurious -ENOMEM failure when
registering an LPI.

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

 arch/arm64/kvm/vgic/vgic-its.c | 11 ++++++++++-
 arch/arm64/kvm/vgic/vgic.c     | 10 ++++++----
 2 files changed, 16 insertions(+), 5 deletions(-)


base-commit: 1ee27dacbe5dc4def481794d899d67b0d4570094
-- 
2.51.0

