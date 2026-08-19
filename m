Received: from mta1.migadu.com (out-217.mta1.migadu.com [95.215.58.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 739E34432EB
	for <kvmarm@lists.linux.dev>; Wed, 19 Aug 2026 10:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787135311; cv=none; b=qHrhDkI9KmF4NtwSTM0ycvWfC39/pteuY3N3hkKJ4HYlguTvIxSF+LUwBkyVeqpRM7ZgaNuBrVnX8P2uw6nphyFdhp2zBH7KZgorKmTzpVRssYFDE7SDTEGMBbTWWhHpXggchsoqx5ICShRr81HP+LijqeF6Siw4a+U2x7or1cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787135311; c=relaxed/simple;
	bh=gt4LUz6h5wdD5n/G/j7Qa+IcB6A6stflUNl5aSZem7k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=n1ZJQv7BdBN14a06L8F0wAkgozqfvGww079rzkABFAknt6HzTcbUYrkq2BuVSh1OyutgluKHNwk7pIVsYIvuirUDgisP/kL/tzXhLr0PTbWdCihA43XxbyOSoXkvYi+uylC2AIGOvvqEfEgCbIQaE6axSFXdtpF4IkEtf7aW9kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FNX+dtOP; arc=none smtp.client-ip=95.215.58.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FNX+dtOP"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=gt4LUz6h5wdD5n/G/j7Qa+IcB6A6stflUNl5aSZem7k=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787135304; v=1; x=1787740104;
 b=FNX+dtOP+BMnAoZhYheV5rHOmQpLGCMD7bFh0Y93NzumSAJC5xEDiumMv4QHlzPC96jWB6Uu
 5qJzRkNhMvCu4LLTBcntTd1U2VoHmzJy1LTzIxbC0+YXj27FajBiR3yBsjfHW1Pg28NzV92qsPt
 gjDxVs2r6iYd88uVarg7NGyo=
X-Envelope-To: kvmarm@lists.linux.dev
Received: from claudy.lan (37.156.72.212)
	by smtp.migadu.com with ESMTPS id 1b7461c5e495a37b;
	Wed, 19 Aug 2026 10:28:24 +0000
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
Subject: [PATCH 2/4] Revert "KVM: arm64: vgic-its: Don't save collections the table cannot hold"
Date: Wed, 19 Aug 2026 11:28:07 +0100
Message-Id: <20260819102809.310708-3-fuad.tabba@linux.dev>
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
index 3339d9977af27..cc6ea5c3409ae 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -2535,9 +2535,6 @@ static int vgic_its_save_collection_table(struct vgic_its *its)
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

