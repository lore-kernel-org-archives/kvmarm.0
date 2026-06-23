Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CDEB39021B
	for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 18:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782240128; cv=none; b=uXfSZHUupM6T/+mNxtYJ60yMZcFeSZIDSLwtfzIJqcFgGgUZfkomRtsAM9vdrCpHfYeSCxdDYUB/UPszH+c4m4zqPGm3VJR9qBLRIcKOZ9dxGEKtC5Gc9kWjV/oqKHAItxxSMUwUyh2e6l4bqXpDnqMe+FOXpf66cV+QJ+hya9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782240128; c=relaxed/simple;
	bh=YHOkh5za0F1YqE/EU4IrzPGj4Z3xM/pKnRkp08wkKfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OAPxnpzWJPn6AXwwCr0Gk/H7959cR+QQvkE0qIXnJiDya1hiwF4cI3veSE1QBUW9QLhNPvKHz43Yiv6OeQyWMsRN22DC6PxhHhBkfLL/ZAPbjvEIN+z4issyGYdy84660K3FSwmwmFiqEvp8Mw8rbcgPWfgmdG+JNB/vlVm8mEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XtBcKo7P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XtBcKo7P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A1B71F00A3E;
	Tue, 23 Jun 2026 18:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782240127;
	bh=Bjok2VStQryAn7GpLyMi6p4mJ0furAQDyEQZOH0gaeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XtBcKo7PztAOZzGqQm2/ciR5oywIrOn8CoMq9qNYnl7KgsCiDYrrg3vQY/QA6IFsm
	 q4UgohA8LozK4rd3Ru+tCu79cJAFf1upZaTRr9KFiRSdk+9UwJdDUp784nMUy2AkEr
	 mZgmV7Ld3yxb7K7FF1rWKUy8xRZcgM/IJ7NovXBIXQ5Qkz6UbSSRF6NxJms02aINNM
	 LZsNvsBXPYL7s10kMlZVjLwh6Podt2zfc9odSVclqwsZ2y729mshqz4V6HwlmRdk7o
	 3xujy5v2IhOXwNkwEASxoD6wDj9uE2rwqP1ax55PFfP6ZFeHFNusELhFQG9jV+Nde3
	 /fzyXZQijGB7Q==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 10/22] KVM: arm64: Plumb through access descriptor for stage-1
Date: Tue, 23 Jun 2026 11:41:49 -0700
Message-ID: <20260623184201.1518871-11-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260623184201.1518871-1-oupton@kernel.org>
References: <20260623184201.1518871-1-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Pass sufficient context to the stage-1 walk such that access-dependent
features like FEAT_HAFDBS can implement the correct behavior.

Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/include/asm/kvm_nested.h |  4 +++-
 arch/arm64/kvm/at.c                 | 32 ++++++++++++++++++++++-------
 arch/arm64/kvm/nested.c             | 10 ++++++---
 3 files changed, 35 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 71814c4aac3e..347d79fd350c 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -112,6 +112,8 @@ struct kvm_walk_access {
 		WALK_ACCESS_CMO,
 		WALK_ACCESS_AT,
 		WALK_ACCESS_S1PTW,
+		WALK_ACCESS_NV2,
+		WALK_ACCESS_NONARCH,
 	} type;
 
 	u64	ia;
@@ -357,7 +359,7 @@ static inline void fail_s1_walk(struct s1_walk_result *wr, u8 fst, bool s1ptw)
 }
 
 int __kvm_translate_va(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
-		       struct s1_walk_result *wr, u64 va);
+		       struct s1_walk_result *wr, struct kvm_walk_access *access);
 int __kvm_find_s1_desc_level(struct kvm_vcpu *vcpu, u64 va, u64 ipa,
 			     int *level);
 
diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 6930bc3bc86b..597e9cddfc7e 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -466,12 +466,13 @@ static void compute_s1_permissions(struct kvm_vcpu *vcpu,
 				   struct s1_walk_result *wr);
 
 static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
-		   struct s1_walk_result *wr, u64 va)
+		   struct s1_walk_result *wr, struct kvm_walk_access *access)
 {
-	u64 va_top, va_bottom, baddr, desc, new_desc, ipa;
+	u64 va_top, va_bottom, baddr, desc, new_desc, ipa, va;
 	struct kvm_s2_trans s2_trans = {};
 	int level, stride, ret;
 
+	va = access->ia;
 	level = wi->sl;
 	stride = wi->pgshift - 3;
 	baddr = wi->baddr;
@@ -1340,6 +1341,7 @@ static void compute_s1_permissions(struct kvm_vcpu *vcpu,
 
 static int handle_at_slow(struct kvm_vcpu *vcpu, u32 op, u64 vaddr, u64 *par)
 {
+	struct kvm_walk_access access = {};
 	struct s1_walk_result wr = {};
 	struct s1_walk_info wi = {};
 	bool perm_fail = false;
@@ -1357,9 +1359,21 @@ static int handle_at_slow(struct kvm_vcpu *vcpu, u32 op, u64 vaddr, u64 *par)
 	if (wr.level == S1_MMU_DISABLED)
 		goto compute_par;
 
+	access.type = WALK_ACCESS_AT;
+	access.ia = vaddr;
+	switch (op) {
+	case OP_AT_S1E1WP:
+	case OP_AT_S1E1W:
+	case OP_AT_S1E2W:
+	case OP_AT_S1E0W:
+		access.write = true;
+		break;
+	default:
+	}
+
 	idx = srcu_read_lock(&vcpu->kvm->srcu);
 
-	ret = walk_s1(vcpu, &wi, &wr, vaddr);
+	ret = walk_s1(vcpu, &wi, &wr, &access);
 
 	srcu_read_unlock(&vcpu->kvm->srcu, idx);
 
@@ -1683,11 +1697,11 @@ int __kvm_at_s12(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
  * set. The rest of the wi and wr should be 0-initialised.
  */
 int __kvm_translate_va(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
-		       struct s1_walk_result *wr, u64 va)
+		       struct s1_walk_result *wr, struct kvm_walk_access *access)
 {
 	int ret;
 
-	ret = setup_s1_walk(vcpu, wi, wr, va);
+	ret = setup_s1_walk(vcpu, wi, wr, access->ia);
 	if (ret)
 		return ret;
 
@@ -1697,7 +1711,7 @@ int __kvm_translate_va(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 		return 0;
 	}
 
-	return walk_s1(vcpu, wi, wr, va);
+	return walk_s1(vcpu, wi, wr, access);
 }
 
 struct desc_match {
@@ -1735,6 +1749,10 @@ int __kvm_find_s1_desc_level(struct kvm_vcpu *vcpu, u64 va, u64 ipa, int *level)
 		.as_el0	= false,
 		.pan	= false,
 	};
+	struct kvm_walk_access access = {
+		.type	= WALK_ACCESS_NONARCH,
+		.ia	= va,
+	};
 	struct s1_walk_result wr = {};
 	int ret;
 
@@ -1754,7 +1772,7 @@ int __kvm_find_s1_desc_level(struct kvm_vcpu *vcpu, u64 va, u64 ipa, int *level)
 	}
 
 	/* Walk the guest's PT, looking for a match along the way */
-	ret = walk_s1(vcpu, &wi, &wr, va);
+	ret = walk_s1(vcpu, &wi, &wr, &access);
 	switch (ret) {
 	case -EINTR:
 		/* We interrupted the walk on a match, return the level */
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 4f13f37e560b..54228db30371 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1425,6 +1425,7 @@ static u64 read_vncr_el2(struct kvm_vcpu *vcpu)
 
 static int kvm_translate_vncr(struct kvm_vcpu *vcpu, bool *is_gmem)
 {
+	struct kvm_walk_access access = {};
 	struct kvm_memory_slot *memslot;
 	bool write_fault, writable;
 	unsigned long mmu_seq;
@@ -1434,6 +1435,7 @@ static int kvm_translate_vncr(struct kvm_vcpu *vcpu, bool *is_gmem)
 	int ret;
 
 	vt = vcpu->arch.vncr_tlb;
+	write_fault = kvm_is_write_fault(vcpu);
 
 	/*
 	 * If we're about to walk the EL2 S1 PTs, we must invalidate the
@@ -1459,12 +1461,14 @@ static int kvm_translate_vncr(struct kvm_vcpu *vcpu, bool *is_gmem)
 
 	va =  read_vncr_el2(vcpu);
 
-	ret = __kvm_translate_va(vcpu, &vt->wi, &vt->wr, va);
+	access.type = WALK_ACCESS_NV2;
+	access.ia = va;
+	access.write = write_fault;
+
+	ret = __kvm_translate_va(vcpu, &vt->wi, &vt->wr, &access);
 	if (ret)
 		return ret;
 
-	write_fault = kvm_is_write_fault(vcpu);
-
 	mmu_seq = vcpu->kvm->mmu_invalidate_seq;
 	smp_rmb();
 
-- 
2.47.3

