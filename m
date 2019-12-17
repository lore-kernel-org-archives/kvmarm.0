Return-Path: <SRS0=Hq6c=2H=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5DE9C2D0CD
	for <kvmarm@archiver.kernel.org>; Tue, 17 Dec 2019 20:41:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8304424650
	for <kvmarm@archiver.kernel.org>; Tue, 17 Dec 2019 20:41:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8304424650
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D1964A944;
	Tue, 17 Dec 2019 15:41:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id L1ILlj4Ve39i; Tue, 17 Dec 2019 15:41:00 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B14294AECF;
	Tue, 17 Dec 2019 15:40:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DD7F24A54B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Dec 2019 15:40:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id a93hToXwVwK2 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Dec 2019 15:40:46 -0500 (EST)
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5F67D4A610
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Dec 2019 15:40:45 -0500 (EST)
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
 by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384;
 17 Dec 2019 12:40:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,326,1571727600"; d="scan'208";a="389952612"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
 by orsmga005.jf.intel.com with ESMTP; 17 Dec 2019 12:40:43 -0800
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: James Hogan <jhogan@kernel.org>, Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Marc Zyngier <maz@kernel.org>
Subject: [PATCH v4 13/19] KVM: Simplify kvm_free_memslot() and all its
 descendents
Date: Tue, 17 Dec 2019 12:40:35 -0800
Message-Id: <20191217204041.10815-14-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191217204041.10815-1-sean.j.christopherson@intel.com>
References: <20191217204041.10815-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Cc: linux-arm-kernel@lists.infradead.org, Wanpeng Li <wanpengli@tencent.com>,
 =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
 kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 Joerg Roedel <joro@8bytes.org>, Cornelia Huck <cohuck@redhat.com>,
 linux-mips@vger.kernel.org,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org,
 Vitaly Kuznetsov <vkuznets@redhat.com>, kvmarm@lists.cs.columbia.edu,
 Jim Mattson <jmattson@google.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Now that all callers of kvm_free_memslot() pass NULL for @dont, remove
the param from the top-level routine and all arch's implementations.

No functional change intended.

Tested-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/mips/include/asm/kvm_host.h      |  2 +-
 arch/powerpc/include/asm/kvm_ppc.h    |  6 ++----
 arch/powerpc/kvm/book3s.c             |  5 ++---
 arch/powerpc/kvm/book3s_hv.c          |  9 +++------
 arch/powerpc/kvm/book3s_pr.c          |  3 +--
 arch/powerpc/kvm/booke.c              |  3 +--
 arch/powerpc/kvm/powerpc.c            |  5 ++---
 arch/s390/include/asm/kvm_host.h      |  2 +-
 arch/x86/include/asm/kvm_page_track.h |  3 +--
 arch/x86/kvm/mmu/page_track.c         | 15 ++++++---------
 arch/x86/kvm/x86.c                    | 21 ++++++++-------------
 include/linux/kvm_host.h              |  3 +--
 virt/kvm/arm/mmu.c                    |  3 +--
 virt/kvm/kvm_main.c                   | 18 +++++++-----------
 14 files changed, 37 insertions(+), 61 deletions(-)

diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
index 41204a49cf95..2c343c346b79 100644
--- a/arch/mips/include/asm/kvm_host.h
+++ b/arch/mips/include/asm/kvm_host.h
@@ -1133,7 +1133,7 @@ extern unsigned long kvm_mips_get_ramsize(struct kvm *kvm);
 static inline void kvm_arch_hardware_unsetup(void) {}
 static inline void kvm_arch_sync_events(struct kvm *kvm) {}
 static inline void kvm_arch_free_memslot(struct kvm *kvm,
-		struct kvm_memory_slot *free, struct kvm_memory_slot *dont) {}
+					 struct kvm_memory_slot *slot) {}
 static inline void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen) {}
 static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
 static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
index 4df042355356..033501d65340 100644
--- a/arch/powerpc/include/asm/kvm_ppc.h
+++ b/arch/powerpc/include/asm/kvm_ppc.h
@@ -201,8 +201,7 @@ extern void kvm_free_hpt_cma(struct page *page, unsigned long nr_pages);
 extern int kvmppc_core_init_vm(struct kvm *kvm);
 extern void kvmppc_core_destroy_vm(struct kvm *kvm);
 extern void kvmppc_core_free_memslot(struct kvm *kvm,
-				     struct kvm_memory_slot *free,
-				     struct kvm_memory_slot *dont);
+				     struct kvm_memory_slot *slot);
 extern int kvmppc_core_prepare_memory_region(struct kvm *kvm,
 				struct kvm_memory_slot *memslot,
 				const struct kvm_userspace_memory_region *mem,
@@ -292,8 +291,7 @@ struct kvmppc_ops {
 	int (*test_age_hva)(struct kvm *kvm, unsigned long hva);
 	void (*set_spte_hva)(struct kvm *kvm, unsigned long hva, pte_t pte);
 	void (*mmu_destroy)(struct kvm_vcpu *vcpu);
-	void (*free_memslot)(struct kvm_memory_slot *free,
-			     struct kvm_memory_slot *dont);
+	void (*free_memslot)(struct kvm_memory_slot *slot);
 	int (*init_vm)(struct kvm *kvm);
 	void (*destroy_vm)(struct kvm *kvm);
 	int (*get_smmu_info)(struct kvm *kvm, struct kvm_ppc_smmu_info *info);
diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index 2480150646ae..b1c9b4d11b2a 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -809,10 +809,9 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log)
 	return kvm->arch.kvm_ops->get_dirty_log(kvm, log);
 }
 
-void kvmppc_core_free_memslot(struct kvm *kvm, struct kvm_memory_slot *free,
-			      struct kvm_memory_slot *dont)
+void kvmppc_core_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
 {
-	kvm->arch.kvm_ops->free_memslot(free, dont);
+	kvm->arch.kvm_ops->free_memslot(slot);
 }
 
 void kvmppc_core_flush_memslot(struct kvm *kvm, struct kvm_memory_slot *memslot)
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index b265d7511f3f..04d5b7cf874f 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4457,13 +4457,10 @@ static int kvm_vm_ioctl_get_dirty_log_hv(struct kvm *kvm,
 	return r;
 }
 
-static void kvmppc_core_free_memslot_hv(struct kvm_memory_slot *free,
-					struct kvm_memory_slot *dont)
+static void kvmppc_core_free_memslot_hv(struct kvm_memory_slot *slot)
 {
-	if (!dont || free->arch.rmap != dont->arch.rmap) {
-		vfree(free->arch.rmap);
-		free->arch.rmap = NULL;
-	}
+	vfree(slot->arch.rmap);
+	slot->arch.rmap = NULL;
 }
 
 static int kvmppc_core_prepare_memory_region_hv(struct kvm *kvm,
diff --git a/arch/powerpc/kvm/book3s_pr.c b/arch/powerpc/kvm/book3s_pr.c
index fc0d9432013f..d2ee00bc7077 100644
--- a/arch/powerpc/kvm/book3s_pr.c
+++ b/arch/powerpc/kvm/book3s_pr.c
@@ -1955,8 +1955,7 @@ static void kvmppc_core_commit_memory_region_pr(struct kvm *kvm,
 	return;
 }
 
-static void kvmppc_core_free_memslot_pr(struct kvm_memory_slot *free,
-					struct kvm_memory_slot *dont)
+static void kvmppc_core_free_memslot_pr(struct kvm_memory_slot *slot)
 {
 	return;
 }
diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
index cf2845e147c5..a22ff567724a 100644
--- a/arch/powerpc/kvm/booke.c
+++ b/arch/powerpc/kvm/booke.c
@@ -1801,8 +1801,7 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log)
 	return -ENOTSUPP;
 }
 
-void kvmppc_core_free_memslot(struct kvm *kvm, struct kvm_memory_slot *free,
-			      struct kvm_memory_slot *dont)
+void kvmppc_core_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
 {
 }
 
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 6fd61b9dd783..587d51f420e2 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -685,10 +685,9 @@ long kvm_arch_dev_ioctl(struct file *filp,
 	return -EINVAL;
 }
 
-void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *free,
-			   struct kvm_memory_slot *dont)
+void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
 {
-	kvmppc_core_free_memslot(kvm, free, dont);
+	kvmppc_core_free_memslot(kvm, slot);
 }
 
 int kvm_arch_prepare_memory_region(struct kvm *kvm,
diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 02f4c21c57f6..ecb50d88347d 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -917,7 +917,7 @@ static inline void kvm_arch_sync_events(struct kvm *kvm) {}
 static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
 static inline void kvm_arch_free_memslot(struct kvm *kvm,
-		struct kvm_memory_slot *free, struct kvm_memory_slot *dont) {}
+					 struct kvm_memory_slot *slot) {}
 static inline void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen) {}
 static inline void kvm_arch_flush_shadow_all(struct kvm *kvm) {}
 static inline void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include/asm/kvm_page_track.h
index 172f9749dbb2..87bd6025d91d 100644
--- a/arch/x86/include/asm/kvm_page_track.h
+++ b/arch/x86/include/asm/kvm_page_track.h
@@ -49,8 +49,7 @@ struct kvm_page_track_notifier_node {
 void kvm_page_track_init(struct kvm *kvm);
 void kvm_page_track_cleanup(struct kvm *kvm);
 
-void kvm_page_track_free_memslot(struct kvm_memory_slot *free,
-				 struct kvm_memory_slot *dont);
+void kvm_page_track_free_memslot(struct kvm_memory_slot *slot);
 int kvm_page_track_create_memslot(struct kvm_memory_slot *slot,
 				  unsigned long npages);
 
diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index 3521e2d176f2..d125ec379c79 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -19,17 +19,14 @@
 
 #include "mmu.h"
 
-void kvm_page_track_free_memslot(struct kvm_memory_slot *free,
-				 struct kvm_memory_slot *dont)
+void kvm_page_track_free_memslot(struct kvm_memory_slot *slot)
 {
 	int i;
 
-	for (i = 0; i < KVM_PAGE_TRACK_MAX; i++)
-		if (!dont || free->arch.gfn_track[i] !=
-		      dont->arch.gfn_track[i]) {
-			kvfree(free->arch.gfn_track[i]);
-			free->arch.gfn_track[i] = NULL;
-		}
+	for (i = 0; i < KVM_PAGE_TRACK_MAX; i++) {
+		kvfree(slot->arch.gfn_track[i]);
+		slot->arch.gfn_track[i] = NULL;
+	}
 }
 
 int kvm_page_track_create_memslot(struct kvm_memory_slot *slot,
@@ -48,7 +45,7 @@ int kvm_page_track_create_memslot(struct kvm_memory_slot *slot,
 	return 0;
 
 track_free:
-	kvm_page_track_free_memslot(slot, NULL);
+	kvm_page_track_free_memslot(slot);
 	return -ENOMEM;
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5f890812fac3..50bef3195533 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9675,27 +9675,22 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	kvm_hv_destroy_vm(kvm);
 }
 
-void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *free,
-			   struct kvm_memory_slot *dont)
+void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
 {
 	int i;
 
 	for (i = 0; i < KVM_NR_PAGE_SIZES; ++i) {
-		if (!dont || free->arch.rmap[i] != dont->arch.rmap[i]) {
-			kvfree(free->arch.rmap[i]);
-			free->arch.rmap[i] = NULL;
-		}
+		kvfree(slot->arch.rmap[i]);
+		slot->arch.rmap[i] = NULL;
+
 		if (i == 0)
 			continue;
 
-		if (!dont || free->arch.lpage_info[i - 1] !=
-			     dont->arch.lpage_info[i - 1]) {
-			kvfree(free->arch.lpage_info[i - 1]);
-			free->arch.lpage_info[i - 1] = NULL;
-		}
+		kvfree(slot->arch.lpage_info[i - 1]);
+		slot->arch.lpage_info[i - 1] = NULL;
 	}
 
-	kvm_page_track_free_memslot(free, dont);
+	kvm_page_track_free_memslot(slot);
 }
 
 static int kvm_alloc_memslot_metadata(struct kvm_memory_slot *slot,
@@ -9887,7 +9882,7 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 
 	/* Free the arrays associated with the old memslot. */
 	if (change == KVM_MR_MOVE)
-		kvm_arch_free_memslot(kvm, old, NULL);
+		kvm_arch_free_memslot(kvm, old);
 }
 
 void kvm_arch_flush_shadow_all(struct kvm *kvm)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 7d86dbb467f7..8343ac5ee7a8 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -672,8 +672,7 @@ int kvm_set_memory_region(struct kvm *kvm,
 			  const struct kvm_userspace_memory_region *mem);
 int __kvm_set_memory_region(struct kvm *kvm,
 			    const struct kvm_userspace_memory_region *mem);
-void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *free,
-			   struct kvm_memory_slot *dont);
+void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot);
 void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen);
 int kvm_arch_prepare_memory_region(struct kvm *kvm,
 				struct kvm_memory_slot *memslot,
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 4941746929ab..c49a3d5baad2 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -2353,8 +2353,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	return ret;
 }
 
-void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *free,
-			   struct kvm_memory_slot *dont)
+void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
 {
 }
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 50e5aec0c15c..2fa40c3e7961 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -583,18 +583,14 @@ static void kvm_destroy_dirty_bitmap(struct kvm_memory_slot *memslot)
 	memslot->dirty_bitmap = NULL;
 }
 
-/*
- * Free any memory in @free but not in @dont.
- */
-static void kvm_free_memslot(struct kvm *kvm, struct kvm_memory_slot *free,
-			      struct kvm_memory_slot *dont)
+static void kvm_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
 {
-	if (!dont || free->dirty_bitmap != dont->dirty_bitmap)
-		kvm_destroy_dirty_bitmap(free);
+	kvm_destroy_dirty_bitmap(slot);
 
-	kvm_arch_free_memslot(kvm, free, dont);
+	kvm_arch_free_memslot(kvm, slot);
 
-	free->npages = 0;
+	slot->flags = 0;
+	slot->npages = 0;
 }
 
 static void kvm_free_memslots(struct kvm *kvm, struct kvm_memslots *slots)
@@ -605,7 +601,7 @@ static void kvm_free_memslots(struct kvm *kvm, struct kvm_memslots *slots)
 		return;
 
 	kvm_for_each_memslot(memslot, slots)
-		kvm_free_memslot(kvm, memslot, NULL);
+		kvm_free_memslot(kvm, memslot);
 
 	kvfree(slots);
 }
@@ -1063,7 +1059,7 @@ static int kvm_delete_memslot(struct kvm *kvm,
 	if (r)
 		return r;
 
-	kvm_free_memslot(kvm, old, NULL);
+	kvm_free_memslot(kvm, old);
 	return 0;
 }
 
-- 
2.24.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
