Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3517B4AEBD9
	for <kvmarm@lists.linux.dev>; Tue, 15 Sep 2026 15:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789487021; cv=none; b=ePkV3WxdLgATVbFb2ZuT4+e+p9f5xzRyj5tKy7Lbcb+2hyt6Y/JNP8HfWHcanmQKznmcpsvPtCbnVhs16r94mGEkW3d66WrkVdevnHWORof3eXoWDtfOWPP3cgMUyivEG9wykS4sysesE7RcOMHIkiGWTuGQmEHVnwdf4dl9q7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789487021; c=relaxed/simple;
	bh=tfSyeTEKhMgIr2WJ2UOq+ZLRU580pd9eUWgwdsIJlT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iTmC3TkMaKMAW7cNvK56eADTQ5XhD1F+58Mh3bftqemwPpLFvyRp5ts+kroJ3f+lSNdk+DGeqLMr4QMWjGd6dUXliOuKIB6SHN9LCBpHyxOQRGX5I2e3nSuhDgSzpexv3I3UnL/sBFQUWkB1yvHtd/sdKO/WRI5E4DfiUDqqhoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=BttJjvIg; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="BttJjvIg"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9F349169E;
	Tue, 15 Sep 2026 08:43:33 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A630B3F882;
	Tue, 15 Sep 2026 08:43:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789487017; bh=tfSyeTEKhMgIr2WJ2UOq+ZLRU580pd9eUWgwdsIJlT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BttJjvIg/rpdGLg/BCbqiUIZvf9gneIEp6IsL8+WZGUrRw7/aaYlwoR0NnwpSYuvv
	 zLu4fSGaj6PiOoTyWIjUxlEfFULgzxz41h9ODxukVWtdmFBPc55et/hID76TU9f46K
	 gdYcRIulRp0fJUc+e7erQ/6cHKgcUId9tCPjaAs4=
From: Wei-Lin Chang <weilin.chang@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Itaru Kitayama <itaru.kitayama@fujitsu.com>,
	Wang Han <wanghan@linux.alibaba.com>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH v6 5/7] KVM: arm64: nv: Avoid full shadow stage-2 unmap
Date: Tue, 15 Sep 2026 16:43:03 +0100
Message-ID: <20260915154305.3852871-6-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260915154305.3852871-1-weilin.chang@arm.com>
References: <20260915154305.3852871-1-weilin.chang@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With guest stage-2 tracking in place, we can improve MMU notifier unmaps
from unmapping all existing shadow stage-2 mappings to only unmapping
the ones affected by the given canonical IPA range.

Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
---
 arch/arm64/include/asm/kvm_nested.h |  2 ++
 arch/arm64/kvm/mmu.c                |  7 ++--
 arch/arm64/kvm/nested.c             | 50 +++++++++++++++++++++++++++--
 3 files changed, 53 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 954f532bc11b..0f899addafa8 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -171,6 +171,8 @@ extern int kvm_s2_handle_perm_fault(struct kvm_vcpu *vcpu,
 				    struct kvm_s2_trans *trans);
 extern int kvm_inject_s2_fault(struct kvm_vcpu *vcpu, u64 esr_el2);
 extern void kvm_nested_s2_wp(struct kvm *kvm);
+extern void kvm_nested_unmap_cipa_range(struct kvm *kvm, gpa_t cipa,
+					size_t unmap_size, bool may_block);
 extern void kvm_nested_s2_unmap(struct kvm *kvm, bool may_block);
 extern void kvm_nested_s2_flush(struct kvm *kvm);
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index c46e92d67f04..b8ba2d09ed96 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2525,8 +2525,9 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 	__unmap_stage2_range(&kvm->arch.mmu, range->start << PAGE_SHIFT,
 			     (range->end - range->start) << PAGE_SHIFT,
 			     range->may_block);
-
-	kvm_nested_s2_unmap(kvm, range->may_block);
+	kvm_nested_unmap_cipa_range(kvm, range->start << PAGE_SHIFT,
+				    (range->end - range->start) << PAGE_SHIFT,
+				    range->may_block);
 	return false;
 }
 
@@ -2808,7 +2809,7 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 
 	write_lock(&kvm->mmu_lock);
 	kvm_stage2_unmap_range(&kvm->arch.mmu, gpa, size, true);
-	kvm_nested_s2_unmap(kvm, true);
+	kvm_nested_unmap_cipa_range(kvm, gpa, size, true);
 	write_unlock(&kvm->mmu_lock);
 }
 
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 92a9a32f9f2b..4cbb4f1b8b35 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -906,9 +906,8 @@ void kvm_remove_guest_s2_mappings(struct kvm_s2_mmu *mmu, gpa_t nipa,
 	gpa_t nipa_end = nipa + size - 1;
 
 	/*
-	 * Guest s2 tracking interval trees are only accessed while holding the
-	 * mmu_lock, hence we don't have to take guest_s2_tracking_lock if the
-	 * mmu_lock is held for write.
+	 * See kvm_nested_unmap_cipa_range() for why guest_s2_tracking_lock
+	 * isn't taken here.
 	 */
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
@@ -1342,6 +1341,51 @@ void kvm_nested_s2_wp(struct kvm *kvm)
 	kvm_invalidate_vncr_ipa(kvm, 0, BIT(kvm->arch.mmu.pgt->ia_bits));
 }
 
+void kvm_nested_unmap_cipa_range(struct kvm *kvm, gpa_t cipa, size_t unmap_size,
+				 bool may_block)
+{
+	gpa_t cipa_end = cipa + unmap_size - 1;
+	struct kvm_guest_s2_mapping *mapping;
+	struct interval_tree_node *node;
+	size_t mapping_size;
+
+	/*
+	 * Guest s2 tracking interval trees are only accessed while holding the
+	 * mmu_lock, hence we don't have to take guest_s2_tracking_lock if the
+	 * mmu_lock is held for write. This saves us from having to manually
+	 * lock/unlock guest_s2_tracking_lock below around
+	 * cond_resched_rwlock_write().
+	 */
+	lockdep_assert_held_write(&kvm->mmu_lock);
+
+	if (!kvm->arch.nested_mmus_size)
+		return;
+
+	while ((node = interval_tree_iter_first(&kvm->arch.mmu.guest_s2_mappings,
+						cipa, cipa_end))) {
+		mapping = container_of(node, struct kvm_guest_s2_mapping, canonical);
+		mapping_size = mapping->nested.last - mapping->nested.start + 1;
+
+		/* We could race against MMU teardown, which frees mmu->pgt. */
+		if (mapping->nested_mmu->pgt) {
+			if (WARN_ON_ONCE(kvm_pgtable_stage2_unmap(mapping->nested_mmu->pgt,
+								  mapping->nested.start,
+								  mapping_size)))
+				return;
+
+			interval_tree_remove(&mapping->nested,
+					     &mapping->nested_mmu->guest_s2_mappings);
+		}
+		interval_tree_remove(node, &kvm->arch.mmu.guest_s2_mappings);
+		kfree(mapping);
+
+		if (may_block)
+			cond_resched_rwlock_write(&kvm->mmu_lock);
+	}
+
+	kvm_invalidate_vncr_ipa(kvm, cipa, cipa + unmap_size);
+}
+
 void kvm_nested_s2_unmap(struct kvm *kvm, bool may_block)
 {
 	int i;
-- 
2.43.0

