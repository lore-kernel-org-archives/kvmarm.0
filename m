Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31BC0442FA7
	for <kvmarm@lists.linux.dev>; Mon, 10 Aug 2026 20:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786395115; cv=none; b=gB8tn+PBq4/EV7/3+7b3lPw8J5N6e0tI2yhqp9WII9JtK0+i/Wf8J0HKIZgHsKSzTEl+pZDYV6uvpSi0IV9ue+x2s/UqAfvY1a+Qopfd02BkWgBrq4hbmNBsu22kcEAE+eql/DNL9pBsxRJs7oFl6tKwEsfq+5O2MyKMyQzx4Ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786395115; c=relaxed/simple;
	bh=+00wwLx2iD8NqUqVubsawzy5FD696qdsjH5gps6fsU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hPCZ3Iur84p91huftLtNH0GaG+Al0/jGSzaeREB5hgN0NTbwDnYcqUU8FHaMdpafW54dwXfyHGG4NTjAvtujcCCBlzZ9ZI9fvFG4Gx+6IYxQEHnIxSYfWMl8SJNup6aIXtf2a4oz1HQtI2jJlc71SFpAGOprJKfBDFwc78C2rOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=g34esSVb; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="g34esSVb"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 929A61655;
	Mon, 10 Aug 2026 13:51:49 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A27EA3F673;
	Mon, 10 Aug 2026 13:51:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786395113; bh=+00wwLx2iD8NqUqVubsawzy5FD696qdsjH5gps6fsU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g34esSVbwgvbpFnxNBpR1Me1bmsksw0WYXt0Sq2xiR4AT3vfjPITtqT56LaFKP/RB
	 QKtAiNOmsH1OF4L1utKZU8Q+ej6AIMcG9Exk7XpM2YkOUJmO9IpGxXYpfNcCzf3Mc6
	 sajgsFgdsiv8DS4sLiamM19Dv6DOy1LCb2CK+QL4=
From: Wei-Lin Chang <weilin.chang@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Itaru Kitayama <itaru.kitayama@fujitsu.com>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH v5 2/6] KVM: arm64: nv: Introduce guest stage-2 tracking structures
Date: Mon, 10 Aug 2026 21:50:34 +0100
Message-ID: <20260810205038.118843-3-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260810205038.118843-1-weilin.chang@arm.com>
References: <20260810205038.118843-1-weilin.chang@arm.com>
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
 arch/arm64/kvm/mmu.c              | 30 ++++++++++++++++++++++++++++++
 arch/arm64/kvm/nested.c           |  1 +
 3 files changed, 48 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index bae2c4f92ef5..0695c4ef93f1 100644
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
index 336dd8f7e8ab..59b4f583240e 100644
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
 
@@ -1122,10 +1125,32 @@ void stage2_unmap_vm(struct kvm *kvm)
 	srcu_read_unlock(&kvm->srcu, idx);
 }
 
+static void guest_s2_tracking_destroy(struct kvm_s2_mmu *mmu,
+				      struct rb_root_cached *tree)
+{
+	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
+	struct kvm_guest_s2_mapping *mapping;
+	struct interval_tree_node *node;
+
+	while ((node = interval_tree_iter_first(tree, 0, ULONG_MAX))) {
+		interval_tree_remove(node, tree);
+
+		if (!kvm_is_nested_s2_mmu(kvm, mmu)) {
+			mapping = container_of(node, struct kvm_guest_s2_mapping,
+					       canonical);
+			/* The canonical MMU is destroyed after the nested MMUs. */
+			kfree(mapping);
+		}
+
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
@@ -1138,12 +1163,17 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
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
+	guest_s2_tracking_destroy(mmu, &mappings_tree);
 }
 
 static void hyp_mc_free_fn(void *addr, void *mc)
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index dfb96edbdc43..744aacba61ae 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -49,6 +49,7 @@ void kvm_init_nested(struct kvm *kvm)
 	kvm->arch.nested_mmus = NULL;
 	kvm->arch.nested_mmus_size = 0;
 	atomic_set(&kvm->arch.vncr_map_count, 0);
+	spin_lock_init(&kvm->arch.guest_s2_tracking_lock);
 }
 
 static int init_nested_s2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu)
-- 
2.43.0

