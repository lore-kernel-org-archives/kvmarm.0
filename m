Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C5B53B8BA2
	for <kvmarm@lists.linux.dev>; Mon, 30 Mar 2026 10:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774865254; cv=none; b=YDxA94FdQwfOqcP98kHCJ+UZyEK9TUUMDg1jpVlxRAU32/YUTK2kZwWhptQ4zeOP96mTN3Jt+t25QvwUxjJMX6xiQJQFKAcnCnhD6A0OKVXaHQAoHfj2Ny/E8L3wWtAAyKPHEnN345HdgYCtSL4fxYZHLIqNr7r8mOBYMjTl9Qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774865254; c=relaxed/simple;
	bh=Hj4nhQhUtz0V/rAJyYmuJZMMsBEFwCzLO0spoqPzVVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TNWgTFUd1Tyn82iKqGBGSY2hL1Y7NZOR7ydWPXyr1W9mlb+5CP3WmXXE61iE6f8PzcilEwVIUxhEMEGc5B4GxRQbwVehNH1Zko2IIBDceT4QnzXuILPrFt8KMVAXOhwjSZQmuyNv2LvoeYO5sf2cdHsZiP/NVU6b6/jL4mDi6Ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=GLST/jYJ; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="GLST/jYJ"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B96C71BF3;
	Mon, 30 Mar 2026 03:07:26 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 009403F915;
	Mon, 30 Mar 2026 03:07:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774865252; bh=Hj4nhQhUtz0V/rAJyYmuJZMMsBEFwCzLO0spoqPzVVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GLST/jYJt3trQbmMs39yHLvbetaOb8cmbHUbTH8Jox+3LbXrn9AI04AdAV1oT9Aih
	 XfNQferj6snrFKtDxgqcDGlCKj4XzuESpe4YFkS/3Bgfeh9/4wjklUxxRLBiAXtLKq
	 8KxatCzVUJhlj/SW/xV6sJTMpU1/ueWbRNtWqsJo=
From: Wei-Lin Chang <weilin.chang@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH 3/4] KVM: arm64: nv: Remove reverse map entries during TLBI handling
Date: Mon, 30 Mar 2026 11:06:32 +0100
Message-ID: <20260330100633.2817076-4-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260330100633.2817076-1-weilin.chang@arm.com>
References: <20260330100633.2817076-1-weilin.chang@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a guest hypervisor issues a TLBI for a specific IPA range, KVM
unmaps that range from all the effected shadow stage-2s. During this we
get the opportunity to remove the reverse map, and lower the probability
of creating polluted reverse map ranges at subsequent stage-2 faults.

However, the TLBI ranges are specified in nested IPA, so in order to
locate the affected ranges in the reverse map maple tree, which is a
mapping from canonical IPA to nested IPA, we can only iterate through
the entire tree and check each entry.

Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
---
 arch/arm64/include/asm/kvm_nested.h |  1 +
 arch/arm64/kvm/nested.c             | 29 +++++++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c           |  3 +++
 3 files changed, 33 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 4d09d567d7f9..376619cdc9d5 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -76,6 +76,7 @@ extern void kvm_s2_mmu_iterate_by_vmid(struct kvm *kvm, u16 vmid,
 				       const union tlbi_info *info,
 				       void (*)(struct kvm_s2_mmu *,
 						const union tlbi_info *));
+extern void kvm_remove_nested_revmap(struct kvm_s2_mmu *mmu, u64 addr, u64 size);
 extern int kvm_record_nested_revmap(gpa_t gpa, struct kvm_s2_mmu *mmu,
 				    gpa_t fault_gpa, size_t map_size);
 extern void kvm_vcpu_load_hw_mmu(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index c7d00cb40ba5..125fa21ca2e7 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -912,6 +912,35 @@ static int record_accel(struct kvm_s2_mmu *mmu, gpa_t gpa,
 	return mas_store_gfp(&mas, (void *)new_entry, GFP_KERNEL_ACCOUNT);
 }
 
+void kvm_remove_nested_revmap(struct kvm_s2_mmu *mmu, u64 addr, u64 size)
+{
+	/*
+	 * Iterate through the mt of this mmu, remove all unpolluted canonical
+	 * ipa ranges that maps to ranges that are strictly within
+	 * [addr, addr + size).
+	 */
+	struct maple_tree *mt = &mmu->nested_revmap_mt;
+	void *entry;
+	u64 nested_ipa, nested_ipa_end, addr_end = addr + size;
+	size_t revmap_size;
+
+	MA_STATE(mas, mt, 0, ULONG_MAX);
+
+	mas_for_each(&mas, entry, ULONG_MAX) {
+		if ((u64)entry & UNKNOWN_IPA)
+			continue;
+
+		revmap_size = mas.last - mas.index + 1;
+		nested_ipa = (u64)entry & NESTED_IPA_MASK;
+		nested_ipa_end = nested_ipa + revmap_size;
+
+		if (nested_ipa >= addr && nested_ipa_end <= addr_end) {
+			accel_clear_mmu_range(mmu, mas.index, revmap_size);
+			mas_erase(&mas);
+		}
+	}
+}
+
 int kvm_record_nested_revmap(gpa_t ipa, struct kvm_s2_mmu *mmu,
 			     gpa_t fault_ipa, size_t map_size)
 {
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index e1001544d4f4..c7af0eac9ee4 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -4006,6 +4006,7 @@ union tlbi_info {
 static void s2_mmu_unmap_range(struct kvm_s2_mmu *mmu,
 			       const union tlbi_info *info)
 {
+	kvm_remove_nested_revmap(mmu, info->range.start, info->range.size);
 	/*
 	 * The unmap operation is allowed to drop the MMU lock and block, which
 	 * means that @mmu could be used for a different context than the one
@@ -4104,6 +4105,8 @@ static void s2_mmu_unmap_ipa(struct kvm_s2_mmu *mmu,
 	max_size = compute_tlb_inval_range(mmu, info->ipa.addr);
 	base_addr &= ~(max_size - 1);
 
+	kvm_remove_nested_revmap(mmu, base_addr, max_size);
+
 	/*
 	 * See comment in s2_mmu_unmap_range() for why this is allowed to
 	 * reschedule.
-- 
2.43.0

