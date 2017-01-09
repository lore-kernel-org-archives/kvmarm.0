From: Jintack Lim <jintack@cs.columbia.edu>
Subject: [RFC 41/55] KVM: arm/arm64: Unmap/flush shadow stage 2 page tables
Date: Mon,  9 Jan 2017 01:24:37 -0500
Message-ID: <1483943091-1364-42-git-send-email-jintack@cs.columbia.edu>
References: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D82C40187
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:49 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FwFm6G+F-U7Z for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Jan 2017 01:24:47 -0500 (EST)
Received: from outprodmail01.cc.columbia.edu (outprodmail01.cc.columbia.edu
 [128.59.72.39])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 04CAD402EC
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:43 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail01.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096Q9v8018089
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:26:24 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id 9D53082
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:26:24 -0500 (EST)
Received: from sendprodmail04.cc.columbia.edu (sendprodmail04.cc.columbia.edu
 [128.59.72.16]) by hazelnut (Postfix) with ESMTP id 742BC83
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:26:24 -0500 (EST)
Received: from mail-qt0-f198.google.com (mail-qt0-f198.google.com
 [209.85.216.198])
 by sendprodmail04.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096QOZp005586
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:26:24 -0500
Received: by mail-qt0-f198.google.com with SMTP id a29so74191556qtb.6
 for <kvmarm@lists.cs.columbia.edu>; Sun, 08 Jan 2017 22:26:24 -0800 (PST)
In-Reply-To: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, vladimir.murzin@arm.com, suzuki.poulose@arm.com, mark.rutland@arm.com, james.morse@arm.com, lorenzo.pieralisi@arm.com, kevin.brodsky@arm.com, wcohen@redhat.com, shankerd@codeaurora.org, geoff@infradead.org, andre.przywara@arm.com, eric.auger@redhat.com, anna-maria@linutronix.de, shihwei@cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

Unmap/flush shadow stage 2 page tables for the nested VMs as well as the
stage 2 page table for the guest hypervisor.

Note: A bunch of the code in mmu.c relating to MMU notifiers is
currently dealt with in an extremely abrupt way, for example by clearing
out an entire shadow stage-2 table.  Probably we can do smarter with
some sort of rmap structure.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
---
 arch/arm/include/asm/kvm_mmu.h   |  7 ++++
 arch/arm/kvm/arm.c               |  6 ++-
 arch/arm/kvm/mmu.c               | 11 +++++
 arch/arm64/include/asm/kvm_mmu.h | 13 ++++++
 arch/arm64/kvm/mmu-nested.c      | 90 ++++++++++++++++++++++++++++++++++++----
 5 files changed, 117 insertions(+), 10 deletions(-)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index 1b3309c..ae3aa39 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -230,6 +230,13 @@ static inline unsigned int kvm_get_vmid_bits(void)
 	return 8;
 }
 
+static inline void kvm_nested_s2_unmap(struct kvm_vcpu *vcpu) { }
+static inline int kvm_nested_s2_init(struct kvm_vcpu *vcpu) { return 0; }
+static inline void kvm_nested_s2_teardown(struct kvm_vcpu *vcpu) { }
+static inline void kvm_nested_s2_all_vcpus_wp(struct kvm *kvm) { }
+static inline void kvm_nested_s2_all_vcpus_unmap(struct kvm *kvm) { }
+static inline void kvm_nested_s2_all_vcpus_flush(struct kvm *kvm) { }
+
 static inline u64 kvm_get_vttbr(struct kvm_s2_vmid *vmid,
 				struct kvm_s2_mmu *mmu)
 {
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 6fa5754..dc2795f 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -191,6 +191,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 
 	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
 		if (kvm->vcpus[i]) {
+			kvm_nested_s2_teardown(kvm->vcpus[i]);
 			kvm_arch_vcpu_free(kvm->vcpus[i]);
 			kvm->vcpus[i] = NULL;
 		}
@@ -333,6 +334,7 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.hw_mmu = mmu;
 	vcpu->arch.hw_vttbr = kvm_get_vttbr(&mmu->vmid, mmu);
+	kvm_nested_s2_init(vcpu);
 
 	return 0;
 }
@@ -871,8 +873,10 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
 	 * Ensure a rebooted VM will fault in RAM pages and detect if the
 	 * guest MMU is turned off and flush the caches as needed.
 	 */
-	if (vcpu->arch.has_run_once)
+	if (vcpu->arch.has_run_once) {
 		stage2_unmap_vm(vcpu->kvm);
+		kvm_nested_s2_unmap(vcpu);
+	}
 
 	vcpu_reset_hcr(vcpu);
 
diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index 98b42e8..1677a87 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -416,6 +416,8 @@ static void stage2_flush_vm(struct kvm *kvm)
 	kvm_for_each_memslot(memslot, slots)
 		stage2_flush_memslot(&kvm->arch.mmu, memslot);
 
+	kvm_nested_s2_all_vcpus_flush(kvm);
+
 	spin_unlock(&kvm->mmu_lock);
 	srcu_read_unlock(&kvm->srcu, idx);
 }
@@ -1240,6 +1242,7 @@ void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot)
 
 	spin_lock(&kvm->mmu_lock);
 	kvm_stage2_wp_range(kvm, &kvm->arch.mmu, start, end);
+	kvm_nested_s2_all_vcpus_wp(kvm);
 	spin_unlock(&kvm->mmu_lock);
 	kvm_flush_remote_tlbs(kvm);
 }
@@ -1278,6 +1281,7 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 		gfn_t gfn_offset, unsigned long mask)
 {
 	kvm_mmu_write_protect_pt_masked(kvm, slot, gfn_offset, mask);
+	kvm_nested_s2_all_vcpus_wp(kvm);
 }
 
 static void coherent_cache_guest_page(struct kvm_vcpu *vcpu, kvm_pfn_t pfn,
@@ -1604,6 +1608,7 @@ static int handle_hva_to_gpa(struct kvm *kvm,
 static int kvm_unmap_hva_handler(struct kvm *kvm, gpa_t gpa, void *data)
 {
 	kvm_unmap_stage2_range(&kvm->arch.mmu, gpa, PAGE_SIZE);
+	kvm_nested_s2_all_vcpus_unmap(kvm);
 	return 0;
 }
 
@@ -1642,6 +1647,7 @@ static int kvm_set_spte_handler(struct kvm *kvm, gpa_t gpa, void *data)
 	 * through this calling path.
 	 */
 	stage2_set_pte(&kvm->arch.mmu, NULL, gpa, pte, 0);
+	kvm_nested_s2_all_vcpus_unmap(kvm);
 	return 0;
 }
 
@@ -1675,6 +1681,8 @@ static int kvm_age_hva_handler(struct kvm *kvm, gpa_t gpa, void *data)
 	if (pte_none(*pte))
 		return 0;
 
+	/* TODO: Handle nested_mmu structures here as well */
+
 	return stage2_ptep_test_and_clear_young(pte);
 }
 
@@ -1694,6 +1702,8 @@ static int kvm_test_age_hva_handler(struct kvm *kvm, gpa_t gpa, void *data)
 	if (!pte_none(*pte))		/* Just a page... */
 		return pte_young(*pte);
 
+	/* TODO: Handle nested_mmu structures here as well */
+
 	return 0;
 }
 
@@ -1959,6 +1969,7 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 
 	spin_lock(&kvm->mmu_lock);
 	kvm_unmap_stage2_range(&kvm->arch.mmu, gpa, size);
+	kvm_nested_s2_all_vcpus_unmap(kvm);
 	spin_unlock(&kvm->mmu_lock);
 }
 
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index fdc9327..e4d5d54 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -328,6 +328,12 @@ static inline unsigned int kvm_get_vmid_bits(void)
 struct kvm_nested_s2_mmu *get_nested_mmu(struct kvm_vcpu *vcpu, u64 vttbr);
 struct kvm_s2_mmu *vcpu_get_active_s2_mmu(struct kvm_vcpu *vcpu);
 bool handle_vttbr_update(struct kvm_vcpu *vcpu, u64 vttbr);
+void kvm_nested_s2_unmap(struct kvm_vcpu *vcpu);
+int kvm_nested_s2_init(struct kvm_vcpu *vcpu);
+void kvm_nested_s2_teardown(struct kvm_vcpu *vcpu);
+void kvm_nested_s2_all_vcpus_wp(struct kvm *kvm);
+void kvm_nested_s2_all_vcpus_unmap(struct kvm *kvm);
+void kvm_nested_s2_all_vcpus_flush(struct kvm *kvm);
 #else
 static inline struct kvm_nested_s2_mmu *get_nested_mmu(struct kvm_vcpu *vcpu,
 						       u64 vttbr)
@@ -343,6 +349,13 @@ static inline bool handle_vttbr_update(struct kvm_vcpu *vcpu, u64 vttbr)
 {
 	return false;
 }
+
+static inline void kvm_nested_s2_unmap(struct kvm_vcpu *vcpu) { }
+static inline int kvm_nested_s2_init(struct kvm_vcpu *vcpu) { return 0; }
+static inline void kvm_nested_s2_teardown(struct kvm_vcpu *vcpu) { }
+static inline void kvm_nested_s2_all_vcpus_wp(struct kvm *kvm) { }
+static inline void kvm_nested_s2_all_vcpus_unmap(struct kvm *kvm) { }
+static inline void kvm_nested_s2_all_vcpus_flush(struct kvm *kvm) { }
 #endif
 
 static inline u64 kvm_get_vttbr(struct kvm_s2_vmid *vmid,
diff --git a/arch/arm64/kvm/mmu-nested.c b/arch/arm64/kvm/mmu-nested.c
index 0811d94..b22b78c 100644
--- a/arch/arm64/kvm/mmu-nested.c
+++ b/arch/arm64/kvm/mmu-nested.c
@@ -1,6 +1,7 @@
 /*
  * Copyright (C) 2016 - Columbia University
  * Author: Jintack Lim <jintack@cs.columbia.edu>
+ * Author: Christoffer Dall <cdall@cs.columbia.edu>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -22,6 +23,86 @@
 #include <asm/kvm_mmu.h>
 #include <asm/kvm_nested.h>
 
+
+/* expects kvm->mmu_lock to be held */
+void kvm_nested_s2_all_vcpus_wp(struct kvm *kvm)
+{
+	int i;
+	struct kvm_vcpu *vcpu;
+	struct kvm_nested_s2_mmu *nested_mmu;
+	struct list_head *nested_mmu_list;
+
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		if (need_resched() || spin_needbreak(&kvm->mmu_lock))
+			cond_resched_lock(&kvm->mmu_lock);
+
+		nested_mmu_list = &vcpu->kvm->arch.nested_mmu_list;
+		list_for_each_entry_rcu(nested_mmu, nested_mmu_list, list)
+			kvm_stage2_wp_range(kvm, &nested_mmu->mmu,
+				    0, KVM_PHYS_SIZE);
+	}
+}
+
+/* expects kvm->mmu_lock to be held */
+void kvm_nested_s2_all_vcpus_unmap(struct kvm *kvm)
+{
+	int i;
+	struct kvm_vcpu *vcpu;
+	struct kvm_nested_s2_mmu *nested_mmu;
+	struct list_head *nested_mmu_list;
+
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		if (need_resched() || spin_needbreak(&kvm->mmu_lock))
+			cond_resched_lock(&kvm->mmu_lock);
+
+		nested_mmu_list = &vcpu->kvm->arch.nested_mmu_list;
+		list_for_each_entry_rcu(nested_mmu, nested_mmu_list, list)
+			kvm_unmap_stage2_range(&nested_mmu->mmu,
+				       0, KVM_PHYS_SIZE);
+	}
+}
+
+void kvm_nested_s2_all_vcpus_flush(struct kvm *kvm)
+{
+	int i;
+	struct kvm_vcpu *vcpu;
+	struct kvm_nested_s2_mmu *nested_mmu;
+	struct list_head *nested_mmu_list;
+
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		if (need_resched() || spin_needbreak(&kvm->mmu_lock))
+			cond_resched_lock(&kvm->mmu_lock);
+
+		nested_mmu_list = &vcpu->kvm->arch.nested_mmu_list;
+		list_for_each_entry_rcu(nested_mmu, nested_mmu_list, list)
+			kvm_stage2_flush_range(&nested_mmu->mmu,
+				       0, KVM_PHYS_SIZE);
+	}
+}
+
+void kvm_nested_s2_unmap(struct kvm_vcpu *vcpu)
+{
+	struct kvm_nested_s2_mmu *nested_mmu;
+	struct list_head *nested_mmu_list = &vcpu->kvm->arch.nested_mmu_list;
+
+	list_for_each_entry_rcu(nested_mmu, nested_mmu_list, list)
+		kvm_unmap_stage2_range(&nested_mmu->mmu, 0, KVM_PHYS_SIZE);
+}
+
+int kvm_nested_s2_init(struct kvm_vcpu *vcpu)
+{
+	return 0;
+}
+
+void kvm_nested_s2_teardown(struct kvm_vcpu *vcpu)
+{
+	struct kvm_nested_s2_mmu *nested_mmu;
+	struct list_head *nested_mmu_list = &vcpu->kvm->arch.nested_mmu_list;
+
+	list_for_each_entry_rcu(nested_mmu, nested_mmu_list, list)
+		__kvm_free_stage2_pgd(&nested_mmu->mmu);
+}
+
 struct kvm_nested_s2_mmu *get_nested_mmu(struct kvm_vcpu *vcpu, u64 vttbr)
 {
 	struct kvm_nested_s2_mmu *mmu;
@@ -89,15 +170,6 @@ static struct kvm_nested_s2_mmu *create_nested_mmu(struct kvm_vcpu *vcpu,
 	return nested_mmu;
 }
 
-static void kvm_nested_s2_unmap(struct kvm_vcpu *vcpu)
-{
-	struct kvm_nested_s2_mmu *nested_mmu;
-	struct list_head *nested_mmu_list = &vcpu->kvm->arch.nested_mmu_list;
-
-	list_for_each_entry_rcu(nested_mmu, nested_mmu_list, list)
-		kvm_unmap_stage2_range(&nested_mmu->mmu, 0, KVM_PHYS_SIZE);
-}
-
 bool handle_vttbr_update(struct kvm_vcpu *vcpu, u64 vttbr)
 {
 	struct kvm_nested_s2_mmu *nested_mmu;
-- 
1.9.1
