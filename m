Received: from mta1.migadu.com (out-33.mta1.migadu.com [95.215.58.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6388C416CFA
	for <kvmarm@lists.linux.dev>; Fri, 21 Aug 2026 06:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787294703; cv=none; b=mFrVVaquDTZRZe/xN7e0vq3BsXI5jJtS/Xe0rLc9fpHJbaWzLFx7+bUgKDv6k1kehmxliGT8bM2rQvXvq0ZGsFnxoxk4hVIRouBAD+q87CowYV+kw3SZnHGzMqs65ScO9eL4guETpKDBdwPycnSoTjABOV8eNVn4E9RS/u9Fh8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787294703; c=relaxed/simple;
	bh=s01m9l8EYn7yXOYXD4CsQkn4QNAqwH/gr7B+G//pUqA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pgatjmypzqMK41tLTouaWhRf7YdStLCohUOuPcpnkHnySoJVUPkAuQaLGmVRpmrmbdP48iT5JUSbKUeMo3iAUuHV1xdasFv+G1Rt4/NbipyPuyBKa2oZNTGbq8d41SWhLHseAHofkuTPSv7ah9LevyQBeVY06Kz2NuGgLuOeFP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YYBaX/8o; arc=none smtp.client-ip=95.215.58.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YYBaX/8o"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=s01m9l8EYn7yXOYXD4CsQkn4QNAqwH/gr7B+G//pUqA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787294700; v=1; x=1787899500;
 b=YYBaX/8oFq2LooNBO1OCp7sEYSAVQo7G89Ire0i3o/ERYRddb+mjVw3557Gb165+pqd1byx/
 EtKVilFxs5nIvPC+EB7L3RNSX6djfr35a5qUwqo7XTu/Rnrya1E0GeOZhX8TuaUs7mXS49QqX/P
 sZcV9gcNzXpVoxnQkhKH5Hlc=
X-Envelope-To: kvmarm@lists.linux.dev
Received: from claudy.lan (37.156.72.212)
	by smtp.migadu.com with ESMTPS id 22874c4fdda4c102;
	Fri, 21 Aug 2026 06:45:00 +0000
X-Mizu-Trace-ID: 22874c4fdda4c102
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
Subject: [PATCH v2 2/4] Revert "KVM: arm64: vgic-its: Don't save collections the table cannot hold"
Date: Fri, 21 Aug 2026 07:44:43 +0100
Message-Id: <20260821064445.615838-3-fuad.tabba@linux.dev>
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

This reverts commit 9b10fb74e4b661543d188701bd4d024fc5c18f58.

Freeing the collections when GITS_BASER<coll> changes removes the state
this check rejected: vgic_its_cmd_handle_mapi(),
vgic_its_cmd_handle_mapc() and vgic_its_restore_cte() all validate the
ID against the current table before allocating, and the table can no
longer change under the list. What remains is a collection whose entry
is not backed by a memslot, which the write fails on anyway, so the
check costs a save userspace should be able to issue reliably and buys
nothing.

The reverted commit credited the check with bounding the walk as well.
It stays bounded without it: collection IDs are unique and each is below
the table's capacity, so the list cannot be longer than the table.

Suggested-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/all/87ecg9owwa.wl-maz@kernel.org/
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-its.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index d5ede640812c4..f702ac31b8b1b 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -2537,9 +2537,6 @@ static int vgic_its_save_collection_table(struct vgic_its *its)
 	max_size = GITS_BASER_NR_PAGES(baser) * SZ_64K;
 
 	list_for_each_entry(collection, &its->collection_list, coll_list) {
-		if (!vgic_its_check_id(its, baser, collection->collection_id, NULL))
-			return -EINVAL;
-
 		ret = vgic_its_save_cte(its, collection, gpa);
 		if (ret)
 			return ret;
-- 
2.39.5

