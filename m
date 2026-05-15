Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B75EA382F0A
	for <kvmarm@lists.linux.dev>; Fri, 15 May 2026 19:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778875159; cv=none; b=jRQKB0cgoXMxETTBapacEMMI0Z5AZHCbsI8xf3PGBCSbKuq6ueRxNcS5ZAGqeQdh9VemEJ7PVbivTy1uoqBdg0kd7+q8Nmy6uEms6816C8bx/69pTsBPGEQO2ppQ+3Kq1sXs/hwIy9zHiVB1yrmsh+xWhzB/kJ01pYrLT3vB+Qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778875159; c=relaxed/simple;
	bh=MLrBcCQTVm2GGFB/nArGSMcQpOlEmTb/IoWr+JN4CXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mESExxLpyZT8KwrnDRF5HrVk6e3lXa7a3f8RQqQqgyYEaUuMlPUwuEdnmkHPUqLV8WVQVTEy3zTqUGmuId5gesMqv4Tf9zQxzlCISZazVkASQe5362NXBgg3BBP/2JluRkU35/yceUPmGmUARtL+5QAmGk7F/qcvooev9Nuo0yQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=BV/yx3tn; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="BV/yx3tn"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0DC0035DE;
	Fri, 15 May 2026 12:59:12 -0700 (PDT)
Received: from devkitleo.cambridge.arm.com (devkitleo.cambridge.arm.com [10.1.196.90])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4D99C3F85F;
	Fri, 15 May 2026 12:59:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778875157; bh=MLrBcCQTVm2GGFB/nArGSMcQpOlEmTb/IoWr+JN4CXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BV/yx3tnCe6ZLdabikR0MI+TPmsk56L4qbqSRn50Xc6o/qYZmsp+LnGQwk+9bu3Xj
	 ZNcfxg2ZRSYKj9Any6zWhy8wdFCgRP3RRMy4511HxwpEl6uatwULP+EAikZlLEPRb1
	 ZG/Ap5R4stKXYaCtxz8xDnIsvTSfRKhLd6DyRAFM=
From: Leonardo Bras <leo.bras@arm.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	Leonardo Bras <leo.bras@arm.com>,
	Raghavendra Rao Ananta <rananta@google.com>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 1/2] KVM: arm64: Introduce S2 walker SKIP return options
Date: Fri, 15 May 2026 20:59:02 +0100
Message-ID: <20260515195904.2466381-2-leo.bras@arm.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515195904.2466381-1-leo.bras@arm.com>
References: <20260515195904.2466381-1-leo.bras@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3257; i=leo.bras@arm.com; h=from:subject; bh=MLrBcCQTVm2GGFB/nArGSMcQpOlEmTb/IoWr+JN4CXU=; b=owGbwMvMwCX2pizjszvTwvWMp9WSGLLYS7/PeVrkt7qmcOH89kCd9yvY9j1Om7VckePVpD9ei xPDr1Yd7ihlYRDjYpAVU2SRfTR/Fc/3KRlHrvxYADOHlQlkCAMXpwBMZN1Thv9V2yJK1/Iac53P /lDoMj0imemzqH637jHWiScv3p71RqWL4RdTehR3dHX9zNb7/+Rnzil543PkxpT2dXkaqzqD1Kq W3GEGAA==
X-Developer-Key: i=leo.bras@arm.com; a=openpgp; fpr=36E6C95AE0F111CC5B6F4D2E688C33F8A0C5B0C5
Content-Transfer-Encoding: 8bit

Introduce S2 walker return values:
- SKIP_CHILDREN: skip walking the children of the current node
- SKIP_SIBLINGS: skip waling the siblings of the current node

Also, modify __kvm_pgtable_visit() to fulfil the hing on above return
values. Current walkers should not be impacted

Signed-off-by: Leonardo Bras <leo.bras@arm.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 0c1defa5fb0f..4e43339522bb 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -12,20 +12,26 @@
 #include <asm/stage2_pgtable.h>
 
 struct kvm_pgtable_walk_data {
 	struct kvm_pgtable_walker	*walker;
 
 	const u64			start;
 	u64				addr;
 	const u64			end;
 };
 
+/* Positive walker return values point levels to skip */
+enum walker_return{
+	SKIP_CHILDREN = 1,
+	SKIP_SIBLINGS
+};
+
 static bool kvm_pgtable_walk_skip_bbm_tlbi(const struct kvm_pgtable_visit_ctx *ctx)
 {
 	return unlikely(ctx->flags & KVM_PGTABLE_WALK_SKIP_BBM_TLBI);
 }
 
 static bool kvm_pgtable_walk_skip_cmo(const struct kvm_pgtable_visit_ctx *ctx)
 {
 	return unlikely(ctx->flags & KVM_PGTABLE_WALK_SKIP_CMO);
 }
 
@@ -134,21 +140,21 @@ static bool kvm_pgtable_walk_continue(const struct kvm_pgtable_walker *walker,
 	 * update a PTE. In the context of a fault handler this is interpreted
 	 * as a signal to retry guest execution.
 	 *
 	 * Ignore the return code altogether for walkers outside a fault handler
 	 * (e.g. write protecting a range of memory) and chug along with the
 	 * page table walk.
 	 */
 	if (r == -EAGAIN)
 		return walker->flags & KVM_PGTABLE_WALK_IGNORE_EAGAIN;
 
-	return !r;
+	return r >= 0;
 }
 
 static int __kvm_pgtable_walk(struct kvm_pgtable_walk_data *data,
 			      struct kvm_pgtable_mm_ops *mm_ops, kvm_pteref_t pgtable, s8 level);
 
 static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
 				      struct kvm_pgtable_mm_ops *mm_ops,
 				      kvm_pteref_t pteref, s8 level)
 {
 	enum kvm_pgtable_walk_flags flags = data->walker->flags;
@@ -185,23 +191,29 @@ static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
 	 * into a newly installed or replaced table.
 	 */
 	if (reload) {
 		ctx.old = READ_ONCE(*ptep);
 		table = kvm_pte_table(ctx.old, level);
 	}
 
 	if (!kvm_pgtable_walk_continue(data->walker, ret))
 		goto out;
 
-	if (!table) {
-		data->addr = ALIGN_DOWN(data->addr, kvm_granule_size(level));
-		data->addr += kvm_granule_size(level);
+	if (!table || ret >= SKIP_CHILDREN) {
+		u64 size;
+
+		if (ret == SKIP_SIBLINGS)	/* Skip siblings */
+			size = kvm_granule_size(level - 1);
+		else				/* Skip children */
+			size = kvm_granule_size(level);
+
+		data->addr = ALIGN_DOWN(data->addr, size) + size;
 		goto out;
 	}
 
 	childp = (kvm_pteref_t)kvm_pte_follow(ctx.old, mm_ops);
 	ret = __kvm_pgtable_walk(data, mm_ops, childp, level + 1);
 	if (!kvm_pgtable_walk_continue(data->walker, ret))
 		goto out;
 
 	if (ctx.flags & KVM_PGTABLE_WALK_TABLE_POST)
 		ret = kvm_pgtable_visitor_cb(data, &ctx, KVM_PGTABLE_WALK_TABLE_POST);
-- 
2.54.0

