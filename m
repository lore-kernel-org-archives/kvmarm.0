Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 507534AE8B6
	for <kvmarm@lists.linux.dev>; Tue, 15 Sep 2026 15:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789487013; cv=none; b=iVspBG7r94WaXPjMZNdNnnFplwWOXkjnZkXwZ+IyywNdzTv3V7WhuD4VmHSKB7U5ElX/GDsMg2AQ6SGhcyltUyeKhFQTNh7UHzpQX5t4yLZqGdNR60ZbX8Xgy8QlGQO9IbWU/4pPGbSohSrTq4txvBg4v9l4XvXxiJWW3/bX3jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789487013; c=relaxed/simple;
	bh=eZi0YOrnOLSovTu30sPts42LqDHKJiClC5gUuLSflSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HUKu3lHLSDkm9o3v97m/jOx/6tiGJXzhlJsfEhesl0xvWhFt2LpJa/4+FWgUQtlDggdPmwSYb/h1EXNjgoo4gSYQlve3vebqEBzMeBDZoc4iasnYplGGAy1hYoNtF9FtsXC2OY1c59FKJjzGHJBg7RxY67d4NB0Jv/3+HXBaIN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=HTmx64G9; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="HTmx64G9"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E88A8169E;
	Tue, 15 Sep 2026 08:43:24 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EB8B73F882;
	Tue, 15 Sep 2026 08:43:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789487008; bh=eZi0YOrnOLSovTu30sPts42LqDHKJiClC5gUuLSflSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HTmx64G9LOeaRQY06AYRfv2R9UcGo7zFxMq21gHcUf+6r9pEwBDPHJW0uGwC/2f6t
	 aiR/3AhQeu3xbxabtRQSt457EnzjWt0jFzaPF3fboYdMOR4Il9+rQE6bkNL798KR5A
	 sbvHwAjIe9ezOBTK4X+K//kIJkzbNi4nXapUk98M=
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
Subject: [PATCH v6 2/7] KVM: arm64: nv: Introduce guest stage-2 tracking structures
Date: Tue, 15 Sep 2026 16:43:00 +0100
Message-ID: <20260915154305.3852871-3-weilin.chang@arm.com>
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

In order to avoid unmapping all shadow stage-2 mappings when KVM
receives a MMU notifier unmap call, we have to keep track of the
canonical IPA -> nested IPA relationship of the shadow mappings
created. This essentially means tracking the guest's stage-2.

To do this, represent each mapping by struct kvm_guest_s2_mapping. It
stores the mapping's canonical IPA range and the nested IPA range using
two interval tree nodes. Both nodes will be inserted into their
respective interval trees called guest_s2_mappings. The canonical IPA
ranges will be stored in the tree within the canonical MMU, and the
nested IPA ranges will be stored in the corresponding nested MMU's tree.

For example:

struct kvm_guest_s2_mapping mapping1, mapping2;

    ---------------------> mapping2.canonical
    |                      mapping1.canonical
    |                          ^   (both stored in canonical mmu's tree)
    |                          |
--*****-----------------------*****----------- CIPA
   \\\\\                      |||||                  mapping1.nested_mmu
    \\\\\                     \\\\\                            |
     \\\\\                     \\\\\                           v
------\\\\\---------------------*****--------- NIPA #1 (nested mmu #1)
       \\\\\                      |
        \\\\\                     -> mapping1.nested
         \\\\\                       (stored in nested mmu #1's tree)
          \\\\\
-----------*****------------------------------ NIPA #2 (nested mmu #2)
             |                                                 ^
             -> mapping2.nested                                |
                (stored in nested mmu #2's tree)   mapping2.nested_mmu

Using the trees we can look up nodes in either of the IPA spaces, and
for each node, find the corresponding range in the other IPA space from
the other node in the enclosing kvm_guest_s2_mapping.

Define kvm_guest_s2_mapping and the interval tree here. Guest stage-2
mapping tracking will come in subsequent patches.

Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
---
 arch/arm64/include/asm/kvm_host.h | 17 +++++++++++++++++
 arch/arm64/kvm/mmu.c              | 24 ++++++++++++++++++++++++
 arch/arm64/kvm/nested.c           |  1 +
 3 files changed, 42 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index cd9b9d2462f9..365ec57d6d7a 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -14,6 +14,7 @@
 #include <linux/arm-smccc.h>
 #include <linux/bitmap.h>
 #include <linux/types.h>
+#include <linux/interval_tree.h>
 #include <linux/jump_label.h>
 #include <linux/kvm_types.h>
 #include <linux/maple_tree.h>
@@ -150,6 +151,16 @@ struct kvm_vmid {
 	atomic64_t id;
 };
 
+/*
+ * Record of a guest stage-2 mapping, storing canonical and nested IPA
+ * ranges. Both ranges have the same size.
+ */
+struct kvm_guest_s2_mapping {
+	struct interval_tree_node canonical;
+	struct interval_tree_node nested;
+	struct kvm_s2_mmu *nested_mmu;
+};
+
 struct kvm_s2_mmu {
 	struct kvm_vmid vmid;
 
@@ -227,6 +238,9 @@ struct kvm_s2_mmu {
 	 */
 	bool	pending_unmap;
 
+	/* Guest s2 mapping records indexed in this MMU's IPA space. */
+	struct rb_root_cached guest_s2_mappings;
+
 	/*
 	 *  0: Nobody is currently using this, check vttbr for validity
 	 * >0: Somebody is actively using this.
@@ -326,6 +340,9 @@ struct kvm_arch {
 	size_t nested_mmus_size;
 	int nested_mmus_next;
 
+	/* Guest s2 tracking trees access serialization. */
+	spinlock_t guest_s2_tracking_lock;
+
 	/* Interrupt controller */
 	struct vgic_dist	vgic;
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 671e2941d619..061cd1e09af2 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -7,6 +7,7 @@
 #include <linux/acpi.h>
 #include <linux/mman.h>
 #include <linux/kvm_host.h>
+#include <linux/interval_tree.h>
 #include <linux/io.h>
 #include <linux/hugetlb.h>
 #include <linux/sched/signal.h>
@@ -1033,6 +1034,8 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
 
 	mmu->pgd_phys = __pa(pgt->pgd);
 
+	mmu->guest_s2_mappings = RB_ROOT_CACHED;
+
 	if (kvm_is_nested_s2_mmu(kvm, mmu))
 		kvm_init_nested_s2_mmu(mmu);
 
@@ -1122,10 +1125,25 @@ void stage2_unmap_vm(struct kvm *kvm)
 	srcu_read_unlock(&kvm->srcu, idx);
 }
 
+static void guest_s2_tracking_destroy(struct rb_root_cached *tree)
+{
+	struct kvm_guest_s2_mapping *mapping;
+	struct interval_tree_node *node;
+
+	while ((node = interval_tree_iter_first(tree, 0, ULONG_MAX))) {
+		interval_tree_remove(node, tree);
+		mapping = container_of(node, struct kvm_guest_s2_mapping,
+				       canonical);
+		kfree(mapping);
+		cond_resched();
+	}
+}
+
 void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
 {
 	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
 	struct kvm_pgtable *pgt = NULL;
+	struct rb_root_cached mappings_tree;
 
 	write_lock(&kvm->mmu_lock);
 	pgt = mmu->pgt;
@@ -1138,12 +1156,18 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
 	if (kvm_is_nested_s2_mmu(kvm, mmu))
 		kvm_init_nested_s2_mmu(mmu);
 
+	mappings_tree = mmu->guest_s2_mappings;
+	mmu->guest_s2_mappings = RB_ROOT_CACHED;
+
 	write_unlock(&kvm->mmu_lock);
 
 	if (pgt) {
 		kvm_stage2_destroy(pgt);
 		kfree(pgt);
 	}
+
+	if (!kvm_is_nested_s2_mmu(kvm, mmu))
+		guest_s2_tracking_destroy(&mappings_tree);
 }
 
 static void hyp_mc_free_fn(void *addr, void *mc)
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index d60f6f69e293..b7bed02e38f7 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -52,6 +52,7 @@ int kvm_init_nested(struct kvm *kvm)
 					      GFP_KERNEL_ACCOUNT);
 	kvm->arch.nested_mmus_size = 0;
 	atomic_set(&kvm->arch.vncr_tlb_count, 0);
+	spin_lock_init(&kvm->arch.guest_s2_tracking_lock);
 
 	return kvm->arch.nested_mmus ? 0 : -ENOMEM;
 }
-- 
2.43.0

