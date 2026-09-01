Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B764E48A8A6
	for <kvmarm@lists.linux.dev>; Tue,  1 Sep 2026 17:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788282973; cv=none; b=q7NHBAlEPTIkZlkRIFWzrwrypjdSCSPxdV4q7t9zfYUNY08aae8sCwjPR3YKBJlq/9bJKV4uLwhOuWMLqiDogrGQFVrF/FZHWmT7o/hsM+QYEBDwGx0JPRTFNp+PV8cAW5PsxBR/kmFHdVyvEKSSHUvZ595QHGn3sDpHXKh4WIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788282973; c=relaxed/simple;
	bh=cUkDq0mjr3TsA7BpjTcTYdqNjWROCRQ9y+M5Y07ELLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AcG2LVOhjpzeU4Tnj3xYJgGwoZTr3qY720fu6jCa7aEDp8W0hdZ8TfdL8iMVcnrRXlwtZzNS48DY2/JvbMGduQLzkvCXDUT4S3ZMdMkhzOw2dnzF9XoKFTg/NM7YmT/SHNiWSTfrE+/MbuELOgATxxlHpe74IVt2pHv/FR91AdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Nt9Elcsv; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Nt9Elcsv"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 20A731CE0;
	Tue,  1 Sep 2026 10:16:07 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D902A3F7D8;
	Tue,  1 Sep 2026 10:16:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788282970; bh=cUkDq0mjr3TsA7BpjTcTYdqNjWROCRQ9y+M5Y07ELLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nt9Elcsvd3jZ+LcqUqz1b+KB9JX1ovs+EflajajcYUOxxMmm27aBQ9hPb61JgRE1h
	 C8n5H+fQF0osMb4k1W0lZn7okuI3B0i5oBIL/EvgSymIg17RJup5E+mLzQHi818l29
	 E3grDL3AYL4u1r42PQTWxIhJfjfF12WXGAo7F/lw=
From: Leonardo Bras <leo.bras@arm.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Leonardo Bras <leo.bras@arm.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Tian Zheng <zhengtian10@huawei.com>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 3/5] KVM: arm64: Introduce a dedicated walker for stage2 write-protect
Date: Tue,  1 Sep 2026 18:15:54 +0100
Message-ID: <20260901171558.2674031-4-leo.bras@arm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260901171558.2674031-1-leo.bras@arm.com>
References: <20260901171558.2674031-1-leo.bras@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1978; i=leo.bras@arm.com; h=from:subject; bh=cUkDq0mjr3TsA7BpjTcTYdqNjWROCRQ9y+M5Y07ELLk=; b=owGbwMvMwCX2pizjszvTwvWMp9WSGLKms839fqptm9uuVyxG3C8UWvP+Z230rRcKjkyzP3Mxl 8WR03BFRykLgxgXg6yYIovso/mreL5PyThy5ccCmDmsTCBDGLg4BWAiiiUM/0x4nv4SvsdpK7Zn ju37c39F1q6wulF7tm25x+Sj/1Zu/sjB8Jtd9s2qFrdzCeXz0x69q5i/Zp9rgXyi710tJZ/Lq48 FlfABAA==
X-Developer-Key: i=leo.bras@arm.com; a=openpgp; fpr=36E6C95AE0F111CC5B6F4D2E688C33F8A0C5B0C5
Content-Transfer-Encoding: 8bit

The new walker cleans the dirty bit on leaf entries, as well as clean
the DBM bit in blocks so it still faults for lazy hugepage splitting when
we enable FEAT_HDBSS in future patches.

With disabled HDBSS, there should be no change in faulting behavior.

Signed-off-by: Leonardo Bras <leo.bras@arm.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 2ff33d3e371e..2849c136f366 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1287,26 +1287,44 @@ static int stage2_update_leaf_attrs(struct kvm_pgtable *pgt, u64 addr,
 		return ret;
 
 	if (orig_pte)
 		*orig_pte = data.pte;
 
 	if (level)
 		*level = data.level;
 	return 0;
 }
 
+static int stage2_wrprotect_walker(const struct kvm_pgtable_visit_ctx *ctx,
+				   enum kvm_pgtable_walk_flags visit)
+{
+	kvm_pte_t new = ctx->old & ~KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
+
+	/* We remove DBM on blocks so they can fault and get split */
+	if (ctx->level < KVM_PGTABLE_LAST_LEVEL)
+		new &= ~KVM_PTE_LEAF_ATTR_HI_S2_DBM;
+
+	if (kvm_pte_valid(ctx->old) && ctx->old != new)
+		WRITE_ONCE(*ctx->ptep, new);
+
+	return 0;
+}
+
+
 int kvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size)
 {
-	return stage2_update_leaf_attrs(pgt, addr, size, 0,
-					KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W,
-					NULL, NULL,
-					KVM_PGTABLE_WALK_IGNORE_EAGAIN);
+	struct kvm_pgtable_walker walker = {
+		.cb	= stage2_wrprotect_walker,
+		.flags	= KVM_PGTABLE_WALK_LEAF,
+	};
+
+	return kvm_pgtable_walk(pgt, addr, size, &walker);
 }
 
 void kvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr,
 				enum kvm_pgtable_walk_flags flags)
 {
 	int ret;
 
 	ret = stage2_update_leaf_attrs(pgt, addr, 1, KVM_PTE_LEAF_ATTR_LO_S2_AF, 0,
 				       NULL, NULL, flags);
 	if (!ret)
-- 
2.55.0

