Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 205CB24EAB1
	for <kvmarm@lists.linux.dev>; Tue,  2 Jun 2026 07:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780386745; cv=none; b=lSs1h3DVqoAxXJhst5G938+DStZTdwMixnEQI8E1fvyON7CCK1HaaaDM64Q3vvxdN3Y83lO5+2csi6pH26YbvIcfxKQ2uPNK3c92JQfvviqaGZkaiaQsiysbDvjtz7MDUOrPtsMztlrLusez520bgsiF/cR4v2BoTyvYBMgNeto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780386745; c=relaxed/simple;
	bh=eiSYb56ISqHiWW85Bez4/clFZUsfcUNxHe8kRpVIXmQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=mQCcIwUqfdvAhxVGlOPdLm4UWTEd1C7UDUm/7sGgcAv/Y3399fwcOpm5yW+zISR0Oraue0KGGKNKXZab8Rf7KuV7XjtDiqun7pnbjdI7sLnVYM5cc01yrOcOOJ9GZqMnuslsCzu8VpY1PIyI5oP+vu0jIEhvnxAg8G5nhs8Tbwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CPksQNNn; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CPksQNNn"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-842358aaf36so851184b3a.2
        for <kvmarm@lists.linux.dev>; Tue, 02 Jun 2026 00:52:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780386743; x=1780991543; darn=lists.linux.dev;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hP2LSLOcJwd8pqW0+7W9R4omsBDhLT1ZDgtaEvUzbZw=;
        b=CPksQNNngh4HlLTRaC5wnuIzos6C9Vd7r89Lx6UEwpfjJAdoY8cV3s5fxGBpdBc8mr
         V4txTzJyDUCoEqvGaYWWWiyNVai9TsuObtHX+1hqyKOqsHmaj7I0toG/VeKaWZcPwNI1
         3/jhgS4of2xK1j/SGpd1MWAjS1FZgmFXKaRhvfyLYF1T41+MvclcIEFCNEaH9GFhOV/r
         QGzoz1FFzfual2i6w4B/PTLTQKBFhrvWbfKdDNobg5oz9s+bo5fTwO5sUjhzYcfClX08
         FwGfk6BN+wzJEBMMkiy0l4kZ8WZ9P2k/2B2vn0UVFlsk6ImQqaIj5HlmFWsbc1DNf4qo
         FnqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780386743; x=1780991543;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hP2LSLOcJwd8pqW0+7W9R4omsBDhLT1ZDgtaEvUzbZw=;
        b=srCO4RVr/+g9cGq0spskw0zlb+E0An6ohgv3wk4D3kzdFPOwpQk4gKrleXm5wFTnYP
         +CrRW0fOlKV2E45mL29R22o7JkY3aM8kPZzH5udOas69LWp29vzYqX+Dyr9m1z//yGR/
         OtQt2E4Yl814x7N4t/2LWwXUVsKqDEPv9dHQ4+cDYnc3P2NbUofPB/dQxYua0+cMQozW
         X+pESCJJ2qBSQP9DPXr1jzyu6PcrMedK6Zr3lQwdWcGgTxWkUG5hSSQiZRXcEvHs7Kig
         mGFBCaBsJIzpVlU37sk2F9Zij9G1wKX6DGXgTOrfUDKvMDkN3zufiG3qIN6LeF2bZCpJ
         EXKg==
X-Forwarded-Encrypted: i=1; AFNElJ9IqjFeqSPZLQtRHz9WZtBehzRYd0VLTR0zFf/GeCfFNlS0mOa7GXBp66cwIKru/NCQT8EGlP4=@lists.linux.dev
X-Gm-Message-State: AOJu0YyOMXlkTGo8gR2m9Sk/3BTlkXRoQvrfYM8CYXpvxLPaY2l6yNYo
	Z61BzU1Vr72i92rAM2nav1KG2He7jJmLySIUWPbMEE5oQlbBtycP+5iH
X-Gm-Gg: Acq92OGeLEt97KrszQkRz0CQwsYXhsJ+J0n9ILml+WpNFfiO994qLPP2zg+gQy3xHDu
	53cCyni+3+Jc4o6gIn5IDXZBnl4KjAPjLB0mBQhNKKixYN+sAefnaHlG6OOrJM59ka/KL817I7p
	PfjdsF2fTwhsPmuMsKpkgH3eLAChnpjO3Kj3KYnvLvz3QE357IUO7zpLKt90lxdr87jEryV2xMu
	1oejTq/D1jmDiTAtDo9MUBZbEOvN5oQJOoUHg9XatRojnMqpFY5GRbZl3NENfihQXmsSjMubC+I
	trTFtMM+a4YnGS26H0RlKhHEMR/vId2/DHL9ISyvMqDmF07Ft35D3+IOiX8spfN5Bb4pjcU88TK
	Mv4AJ1R/p8UwzLG1rxVyjg2O+v6rrhfrOlU0XrRhaTv/lGvR6wtMPAzh/4qNbFXuTOM9W6B5Q36
	3cnXYri8ZhAmR7vHd/ubqysnQX7EA9HYTojeuU+NEBVEvkDo60fKQzRp/myfiA5ua3
X-Received: by 2002:a05:6a00:3cd3:b0:835:6388:655d with SMTP id d2e1a72fcca58-84225401e17mr12812962b3a.14.1780386743362;
        Tue, 02 Jun 2026 00:52:23 -0700 (PDT)
Received: from v4bel ([58.123.110.97])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8423dc9f361sm7534426b3a.24.2026.06.02.00.52.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 00:52:22 -0700 (PDT)
Date: Tue, 2 Jun 2026 16:52:18 +0900
From: Hyunwoo Kim <imv4bel@gmail.com>
To: maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com,
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, kees@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	imv4bel@gmail.com
Subject: [PATCH v2] KVM: arm64: vgic-its: Serialize translation cache
 invalidation under its_lock
Message-ID: <ah6Lsi4MfKUU6wBR@v4bel>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

vgic_its_invalidate_cache() walks the per-ITS translation cache with
xa_for_each() and drops the cache's reference on each entry with
vgic_put_irq().

It must be called with its_lock held. The ITS command handlers and the
ITS teardown path hold it, but two paths that also invalidate the cache do
not: the GITS_CTLR write path holds only cmd_lock, and the path that
clears EnableLPIs in a redistributor's GICR_CTLR holds neither lock. Two
contexts without a common lock, such as two vCPUs clearing EnableLPIs or
an EnableLPIs clear racing an ITS command, can drain the same cache at
once. If both observe an entry, erase it and then put it, the single
reference the cache holds on that entry is dropped more than once, and the
entry can be freed while an ITE still maps it.

Take its_lock in the two paths that lacked it: the GITS_CTLR write path
and vgic_its_invalidate_all_caches(), which clears EnableLPIs. Since
vgic_its_invalidate_all_caches() now takes a mutex, it can no longer walk
kvm->devices under rcu_read_lock(), so walk it under kvm->lock instead.
With its_lock held across every invalidation, each entry is erased and put
by a single context, so the cache reference is dropped exactly once.

Cc: stable@vger.kernel.org
Fixes: 8201d1028caa ("KVM: arm64: vgic-its: Maintain a translation cache per ITS")
Suggested-by: Oliver Upton <oupton@kernel.org>
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
---
Changes in v2:
- Serialize the invalidation under its_lock as suggested by Oliver,
  instead of v1's gating of the put on the xa_erase() return value.
- v1: https://lore.kernel.org/all/ah2c5lu4JbUg7dj-@v4bel/
---
 arch/arm64/kvm/vgic/vgic-its.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 1d7e5d560af4..4bf60fa5bd7c 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -596,6 +596,8 @@ static void vgic_its_invalidate_cache(struct vgic_its *its)
 	struct vgic_irq *irq;
 	unsigned long idx;
 
+	lockdep_assert_held(&its->its_lock);
+
 	xa_for_each(&its->translation_cache, idx, irq) {
 		xa_erase(&its->translation_cache, idx);
 		vgic_put_irq(kvm, irq);
@@ -607,17 +609,16 @@ void vgic_its_invalidate_all_caches(struct kvm *kvm)
 	struct kvm_device *dev;
 	struct vgic_its *its;
 
-	rcu_read_lock();
+	guard(mutex)(&kvm->lock);
 
-	list_for_each_entry_rcu(dev, &kvm->devices, vm_node) {
+	list_for_each_entry(dev, &kvm->devices, vm_node) {
 		if (dev->ops != &kvm_arm_vgic_its_ops)
 			continue;
 
 		its = dev->private;
+		guard(mutex)(&its->its_lock);
 		vgic_its_invalidate_cache(its);
 	}
-
-	rcu_read_unlock();
 }
 
 int vgic_its_resolve_lpi(struct kvm *kvm, struct vgic_its *its,
@@ -1725,8 +1726,10 @@ static void vgic_mmio_write_its_ctlr(struct kvm *kvm, struct vgic_its *its,
 		goto out;
 
 	its->enabled = !!(val & GITS_CTLR_ENABLE);
-	if (!its->enabled)
+	if (!its->enabled) {
+		guard(mutex)(&its->its_lock);
 		vgic_its_invalidate_cache(its);
+	}
 
 	/*
 	 * Try to process any pending commands. This function bails out early
-- 
2.43.0

