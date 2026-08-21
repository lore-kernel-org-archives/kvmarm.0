Received: from mta1.migadu.com (out-28.mta1.migadu.com [95.215.58.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69AB6415B8C
	for <kvmarm@lists.linux.dev>; Fri, 21 Aug 2026 06:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787294700; cv=none; b=ZcZIqPnEdmQmjiYdFC3LGpbeF9UPRttOOpsH5PBNQjY/2QxqWcOyUpnXPLHIwpOhguSOvw7OJN9ZiHM0ALuKAC1GxRXKeWc2FS6nv3IZ0vwDSi3mWX8UY8iZC0I7y8jz0mXF7ckioKqLV278sydZrXu1Za7Pii5cxxBSAwJu+BE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787294700; c=relaxed/simple;
	bh=ANW+Z5vBE34Npmai57MGv7FNNjJXI8weYqTeGPekhFI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DOIemP5hR/9idFNNGgCgggKwLAFD7vBnoGFqssTQc96f1HiVYthdD09wHvdkhbhPInuK++E6o0CCN8Lt2l/fEy4Lscb4QwYzmuubchwC/Gv4vscKNItz6yADlAZvxlB5nRI3Lsnn/HpQHoXrrfJoMz9Kra1ldT59dSd+VyzSVSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=e3LMqpyh; arc=none smtp.client-ip=95.215.58.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="e3LMqpyh"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=ANW+Z5vBE34Npmai57MGv7FNNjJXI8weYqTeGPekhFI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787294695; v=1; x=1787899495;
 b=e3LMqpyhwn8hLPEW2CRjzoMPiPCKdlQGKZIfdNzp+czCqa6tfs+R4U+PDu5r3R+T4FPKRB9b
 sNItbJQS669zUBtfjJ02LTbJJ3lghTR/CIZJc9m1f8ivru0on1x3S4WD35N6sSKl1LOTDagFA5I
 saYBJyHFsFcwA3echh2hKrBk=
X-Envelope-To: kvmarm@lists.linux.dev
Received: from claudy.lan (37.156.72.212)
	by smtp.migadu.com with ESMTPS id 9de2999b3da40509;
	Fri, 21 Aug 2026 06:44:55 +0000
X-Mizu-Trace-ID: 9de2999b3da40509
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Eric Auger <eauger@redhat.com>,
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
Subject: [PATCH v2 1/4] KVM: arm64: vgic-its: Free the caches when GITS_BASER changes
Date: Fri, 21 Aug 2026 07:44:42 +0100
Message-Id: <20260821064445.615838-2-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260821064445.615838-1-fuad.tabba@linux.dev>
References: <20260821064445.615838-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A guest that disables the ITS and re-points or shrinks GITS_BASER<n>
with VALID still set keeps the devices and collections it mapped
against the old table, as KVM frees them only when VALID is cleared.
The contents of the table are IMPLEMENTATION DEFINED, so a write that
gives GITS_BASER<n> a different address or size may lose whatever the
old value described. Free the list whenever the stored value changes,
and drop the translation cache with it.

The cache is not empty just because the ITS is disabled: its->enabled
is written under the cmd_lock, while vgic_its_resolve_lpi() tests it
under the its_lock, so an injection can still cache an entry after the
ITS was disabled. Hence the invalidation inside the its_lock section.

Test for a change rather than a write: its_restore_enable() rewrites
GITS_BASER<n> from its probe-time cache on resume, and KVM reports
GITS_TYPER.HCC as 0, so nothing re-maps the boot CPU's collection
afterwards.

Fixes: 36d6961c2b481 ("KVM: arm/arm64: vgic-its: Free caches when GITS_BASER Valid bit is cleared")
Suggested-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/all/87ecg9owwa.wl-maz@kernel.org/
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-its.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index f6538b1976f9b..d5ede640812c4 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -1649,7 +1649,7 @@ static void vgic_mmio_write_its_baser(struct kvm *kvm,
 				      unsigned long val)
 {
 	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
-	u64 entry_size, table_type;
+	u64 old, entry_size, table_type;
 	u64 reg, *regptr, clearbits = 0;
 
 	/* When GITS_CTLR.Enable is 1, we ignore write accesses. */
@@ -1672,7 +1672,9 @@ static void vgic_mmio_write_its_baser(struct kvm *kvm,
 		return;
 	}
 
-	reg = update_64bit_reg(*regptr, addr & 7, len, val);
+	old = *regptr;
+
+	reg = update_64bit_reg(old, addr & 7, len, val);
 	reg &= ~GITS_BASER_RO_MASK;
 	reg &= ~clearbits;
 
@@ -1682,7 +1684,8 @@ static void vgic_mmio_write_its_baser(struct kvm *kvm,
 
 	*regptr = reg;
 
-	if (!(reg & GITS_BASER_VALID)) {
+	/* The ITS driver rewrites an unchanged GITS_BASER<n> on resume. */
+	if (reg != old) {
 		/* Take the its_lock to prevent a race with a save/restore */
 		mutex_lock(&its->its_lock);
 		switch (table_type) {
@@ -1693,6 +1696,8 @@ static void vgic_mmio_write_its_baser(struct kvm *kvm,
 			vgic_its_free_collection_list(kvm, its);
 			break;
 		}
+		/* A concurrent injection may have cached a translation. */
+		vgic_its_invalidate_cache(its);
 		mutex_unlock(&its->its_lock);
 	}
 }
-- 
2.39.5

