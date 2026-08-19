Received: from mta1.migadu.com (out-210.mta1.migadu.com [95.215.58.210])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40CE742BC28
	for <kvmarm@lists.linux.dev>; Wed, 19 Aug 2026 10:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.210
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787135305; cv=none; b=ciX4D3NLC0oGKWj13nIisPGZPTE2qgB0ZhoIr2CSQI3uK8ZYfTmsxbx8ISKiVgQISKozg2coitNNXzH9LbNJ2l5jbzV6ikFgPjlWwyF5hSzpWLeea3nQzDXWpG8BChXGe+voDcD//V+2izZiJMC+69z1NmzaFBjwq4dPNf80774=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787135305; c=relaxed/simple;
	bh=slbtI8ZsA2D3ug2zqvheMAR9v743tseMWn7tlh89cVA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=meD8kIbXe237Wi5VEjWxZzB45MmS4iuZuU0x8NUyUtUGK4Q+kM+RC3Kttto9boTsf3wVIs4sSXYOHk23osEizqHHDP6vHhtTOalwr46p4ZDwNBkqQGbPBIZl187+tiZnCaF0vv+/l7gTtNrS+DBJcyHBiTlAAZkhwdKj/CYHR0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=v+Cthkpm; arc=none smtp.client-ip=95.215.58.210
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="v+Cthkpm"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=slbtI8ZsA2D3ug2zqvheMAR9v743tseMWn7tlh89cVA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787135299; v=1; x=1787740099;
 b=v+CthkpmbITqWA38uTEuHsk7fG/FKtHQP7KNT60LT6AqcHBUltxCGJ/nAdN5zHQbrUwrQscH
 Yi7IjLnzSKHNd7B3F81naG/Flh8mucrhqLA/2Z/+itOizc3vN4Du75s7PaXAxs6YttQIm0OMh3F
 w8+LEMaBLkwPigrjFB/uRGOw=
X-Envelope-To: kvmarm@lists.linux.dev
Received: from claudy.lan (37.156.72.212)
	by smtp.migadu.com with ESMTPS id 95476cbcfe529942;
	Wed, 19 Aug 2026 10:28:19 +0000
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Sascha Bischoff <sascha.bischoff@arm.com>,
	Sebastian Ene <sebastianene@google.com>,
	Eric Auger <eauger@redhat.com>,
	Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] KVM: arm64: vgic-its: Free the caches when GITS_BASER changes
Date: Wed, 19 Aug 2026 11:28:06 +0100
Message-Id: <20260819102809.310708-2-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260819102809.310708-1-fuad.tabba@linux.dev>
References: <20260819102809.310708-1-fuad.tabba@linux.dev>
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
The table format is not architected, so a write with a different value
is allowed to lose what it describes. Free the list whenever the
stored value changes.

Test for a change rather than a write: its_restore_enable() rewrites
GITS_BASER<n> from its probe-time cache on resume, and KVM reports
GITS_TYPER.HCC as 0, so nothing re-maps the boot CPU's collection
afterwards.

Fixes: 36d6961c2b481 ("KVM: arm/arm64: vgic-its: Free caches when GITS_BASER Valid bit is cleared")
Suggested-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/all/87ecg9owwa.wl-maz@kernel.org/
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-its.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index f6538b1976f9b..3339d9977af27 100644
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
-- 
2.39.5

