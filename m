Received: from mta0.migadu.com (out-205.mta0.migadu.com [91.218.175.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5EFA4EFFD6
	for <kvmarm@lists.linux.dev>; Thu, 17 Sep 2026 16:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789662058; cv=none; b=s6XyCUEy5/7teZoNrnlpT3kHkHiwXtWLMyWx4xsU01rDsfjtNLs6tGYXzrMtvKBqcbWhQHCNLPH578E8z1H7rrudWR1slhNZykk4TawSv7MpD6Tc9ofyyzd3J8V61eL9gu6SzaLmDcx4AL0/P+BKTFODfnIzyP0gQv9NxLQ5tvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789662058; c=relaxed/simple;
	bh=4ZCPZ+9Q6roBF3CJHBhT63aw+NcWPYPDK3zziyG/hEY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=sGBgxyE9AeBn/2ty/MNEZHlt2A5xhmEinhbbZTsJ9+tsJpyzTRl1+y/lXA1xcF1iyTVPz0zOmBCukW7ih8b/Vp4SgqZJ44M5Bfpa907Z0CO+hz1YORDuCNJejBw6OMUSPCwnM2r9dr00FF7Wvyc/SxI1NzeqtUXyQO59inZmGW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EXmNWqV0; arc=none smtp.client-ip=91.218.175.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EXmNWqV0"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=4ZCPZ+9Q6roBF3CJHBhT63aw+NcWPYPDK3zziyG/hEY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789662053; v=1; x=1790266853;
 b=EXmNWqV0qoEYJqOslp9DcBmEO6pIsDiDtyEwlar36I/6lUppACfue4Q4EpgBpO0lyJMS8vgk
 4JkDCtaZUcSK7TmB3LNj3myRy22XF21bMS+YRognHUI0G2wcLH0Bec8WgaE/AdL+lsStYLhS/e3
 om+ZJbDYPLblb/YN3omLwUbM=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id efb44d216b9e5b22;
	Thu, 17 Sep 2026 16:20:21 +0000
X-Mizu-Trace-ID: efb44d216b9e5b22
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Hyunwoo Kim <imv4bel@gmail.com>,
	Eric Auger <eauger@redhat.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Sascha Bischoff <sascha.bischoff@arm.com>,
	Sebastian Ene <sebastianene@google.com>,
	Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: arm64: vgic-its: Update GITS_CTLR.Enabled under its_lock
Date: Thu, 17 Sep 2026 17:20:20 +0100
Message-Id: <20260917162020.1612577-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

vgic_mmio_write_its_ctlr() clears its->enabled and invalidates the
translation cache under cmd_lock, but vgic_its_resolve_lpi() tests the
bit and populates the cache under its_lock. An injection that passed
the test before the disable can cache its translation after the
invalidation, and the cached path then injects from a disabled ITS.

Commit 13031fb6b835 ("KVM: arm64: vgic-its: Drop the translation cache
reference only for the erased entry") made the concurrent invalidations
safe but left this window open. The linked v2 closed it, and Oliver
withdrew his own diff there over a kvm->lock/vcpu->mutex inversion in
its vgic_its_invalidate_all_caches() hunk.

Take its_lock around the store and the invalidation, nested under
cmd_lock as the command handlers do. This is the v2's GITS_CTLR half,
widened to cover the store, and it has no such inversion.

Fixes: 8201d1028caa ("KVM: arm64: vgic-its: Maintain a translation cache per ITS")
Reported-by: Hyunwoo Kim <imv4bel@gmail.com>
Link: https://lore.kernel.org/ah6Lsi4MfKUU6wBR@v4bel/
Cc: stable@vger.kernel.org
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---

Notes:
    Based on v7.3-rc3, applies cleanly to kvmarm/fixes.
    
    Picking up the fix Marc was worried had stalled [1]. Unlike the v2's
    GITS_CTLR hunk [2], the its->enabled store is inside the locked section
    too, so the enable test in vgic_its_resolve_lpi() is serialized by the
    lock rather than by store order.
    
    vgic_its_invalidate_all_caches(), the GICR_CTLR.EnableLPIs path, is
    left as is: it can take neither kvm->lock (it runs with vcpu->mutex
    held) nor config_lock (the userspace GICR_CTLR route already holds it).
    It belongs to the locking cleanup Oliver deferred as a long-term fix
    when he withdrew the v2 [3].
    
    [1] https://lore.kernel.org/861pbr6emw.wl-maz@kernel.org/
    [2] https://lore.kernel.org/ah6Lsi4MfKUU6wBR@v4bel/
    [3] https://lore.kernel.org/ah9KeH8bFl8NOveO@kernel.org/

 arch/arm64/kvm/vgic/vgic-its.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 9e782a4fea7e5..70b4acf1bf81d 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -1738,9 +1738,15 @@ static void vgic_mmio_write_its_ctlr(struct kvm *kvm, struct vgic_its *its,
 		 !(its->cbaser & GITS_CBASER_VALID)))
 		goto out;
 
+	/*
+	 * vgic_its_resolve_lpi() tests the enable bit and populates the
+	 * translation cache under its_lock.
+	 */
+	mutex_lock(&its->its_lock);
 	its->enabled = !!(val & GITS_CTLR_ENABLE);
 	if (!its->enabled)
 		vgic_its_invalidate_cache(its);
+	mutex_unlock(&its->its_lock);
 
 	/*
 	 * Try to process any pending commands. This function bails out early

base-commit: fd73f4a6659897191fa0d40695fe370925dd3780
-- 
2.39.5

