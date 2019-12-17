Return-Path: <SRS0=Hq6c=2H=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DD82C2D0D4
	for <kvmarm@archiver.kernel.org>; Tue, 17 Dec 2019 20:40:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0C7692176D
	for <kvmarm@archiver.kernel.org>; Tue, 17 Dec 2019 20:40:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0C7692176D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BA3ED4A7F0;
	Tue, 17 Dec 2019 15:40:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id k0iX+HgumKzl; Tue, 17 Dec 2019 15:40:57 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6BBA94ACB8;
	Tue, 17 Dec 2019 15:40:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9475B4AC80
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Dec 2019 15:40:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7QgEeIw-7j7H for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Dec 2019 15:40:46 -0500 (EST)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7C6B64A7E4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Dec 2019 15:40:45 -0500 (EST)
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
 by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384;
 17 Dec 2019 12:40:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,326,1571727600"; d="scan'208";a="389952584"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
 by orsmga005.jf.intel.com with ESMTP; 17 Dec 2019 12:40:42 -0800
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: James Hogan <jhogan@kernel.org>, Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Marc Zyngier <maz@kernel.org>
Subject: [PATCH v4 04/19] KVM: PPC: Move memslot memory allocation into
 prepare_memory_region()
Date: Tue, 17 Dec 2019 12:40:26 -0800
Message-Id: <20191217204041.10815-5-sean.j.christopherson@intel.com>
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

Allocate the rmap array during kvm_arch_prepare_memory_region() to pave
the way for removing kvm_arch_create_memslot() altogether.  Moving PPC's
memory allocation only changes the order of kernel memory allocations
between PPC and common KVM code.

No functional change intended.

Acked-by: Paul Mackerras <paulus@ozlabs.org>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/powerpc/include/asm/kvm_ppc.h | 11 ++++-------
 arch/powerpc/kvm/book3s.c          | 12 ++++--------
 arch/powerpc/kvm/book3s_hv.c       | 25 ++++++++++++-------------
 arch/powerpc/kvm/book3s_pr.c       | 11 ++---------
 arch/powerpc/kvm/booke.c           |  9 ++-------
 arch/powerpc/kvm/powerpc.c         |  4 ++--
 6 files changed, 26 insertions(+), 46 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
index 3d2f871241a8..4df042355356 100644
--- a/arch/powerpc/include/asm/kvm_ppc.h
+++ b/arch/powerpc/include/asm/kvm_ppc.h
@@ -203,12 +203,10 @@ extern void kvmppc_core_destroy_vm(struct kvm *kvm);
 extern void kvmppc_core_free_memslot(struct kvm *kvm,
 				     struct kvm_memory_slot *free,
 				     struct kvm_memory_slot *dont);
-extern int kvmppc_core_create_memslot(struct kvm *kvm,
-				      struct kvm_memory_slot *slot,
-				      unsigned long npages);
 extern int kvmppc_core_prepare_memory_region(struct kvm *kvm,
 				struct kvm_memory_slot *memslot,
-				const struct kvm_userspace_memory_region *mem);
+				const struct kvm_userspace_memory_region *mem,
+				enum kvm_mr_change change);
 extern void kvmppc_core_commit_memory_region(struct kvm *kvm,
 				const struct kvm_userspace_memory_region *mem,
 				const struct kvm_memory_slot *old,
@@ -281,7 +279,8 @@ struct kvmppc_ops {
 	void (*flush_memslot)(struct kvm *kvm, struct kvm_memory_slot *memslot);
 	int (*prepare_memory_region)(struct kvm *kvm,
 				     struct kvm_memory_slot *memslot,
-				     const struct kvm_userspace_memory_region *mem);
+				     const struct kvm_userspace_memory_region *mem,
+				     enum kvm_mr_change change);
 	void (*commit_memory_region)(struct kvm *kvm,
 				     const struct kvm_userspace_memory_region *mem,
 				     const struct kvm_memory_slot *old,
@@ -295,8 +294,6 @@ struct kvmppc_ops {
 	void (*mmu_destroy)(struct kvm_vcpu *vcpu);
 	void (*free_memslot)(struct kvm_memory_slot *free,
 			     struct kvm_memory_slot *dont);
-	int (*create_memslot)(struct kvm_memory_slot *slot,
-			      unsigned long npages);
 	int (*init_vm)(struct kvm *kvm);
 	void (*destroy_vm)(struct kvm *kvm);
 	int (*get_smmu_info)(struct kvm *kvm, struct kvm_ppc_smmu_info *info);
diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index 58a59ee998e2..2480150646ae 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -815,12 +815,6 @@ void kvmppc_core_free_memslot(struct kvm *kvm, struct kvm_memory_slot *free,
 	kvm->arch.kvm_ops->free_memslot(free, dont);
 }
 
-int kvmppc_core_create_memslot(struct kvm *kvm, struct kvm_memory_slot *slot,
-			       unsigned long npages)
-{
-	return kvm->arch.kvm_ops->create_memslot(slot, npages);
-}
-
 void kvmppc_core_flush_memslot(struct kvm *kvm, struct kvm_memory_slot *memslot)
 {
 	kvm->arch.kvm_ops->flush_memslot(kvm, memslot);
@@ -828,9 +822,11 @@ void kvmppc_core_flush_memslot(struct kvm *kvm, struct kvm_memory_slot *memslot)
 
 int kvmppc_core_prepare_memory_region(struct kvm *kvm,
 				struct kvm_memory_slot *memslot,
-				const struct kvm_userspace_memory_region *mem)
+				const struct kvm_userspace_memory_region *mem,
+				enum kvm_mr_change change)
 {
-	return kvm->arch.kvm_ops->prepare_memory_region(kvm, memslot, mem);
+	return kvm->arch.kvm_ops->prepare_memory_region(kvm, memslot, mem,
+							change);
 }
 
 void kvmppc_core_commit_memory_region(struct kvm *kvm,
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index dc53578193ee..b265d7511f3f 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4466,20 +4466,20 @@ static void kvmppc_core_free_memslot_hv(struct kvm_memory_slot *free,
 	}
 }
 
-static int kvmppc_core_create_memslot_hv(struct kvm_memory_slot *slot,
-					 unsigned long npages)
-{
-	slot->arch.rmap = vzalloc(array_size(npages, sizeof(*slot->arch.rmap)));
-	if (!slot->arch.rmap)
-		return -ENOMEM;
-
-	return 0;
-}
-
 static int kvmppc_core_prepare_memory_region_hv(struct kvm *kvm,
-					struct kvm_memory_slot *memslot,
-					const struct kvm_userspace_memory_region *mem)
+					struct kvm_memory_slot *slot,
+					const struct kvm_userspace_memory_region *mem,
+					enum kvm_mr_change change)
 {
+	unsigned long npages = mem->memory_size >> PAGE_SHIFT;
+
+	if (change == KVM_MR_CREATE) {
+		slot->arch.rmap = vzalloc(array_size(npages,
+					  sizeof(*slot->arch.rmap)));
+		if (!slot->arch.rmap)
+			return -ENOMEM;
+	}
+
 	return 0;
 }
 
@@ -5537,7 +5537,6 @@ static struct kvmppc_ops kvm_ops_hv = {
 	.set_spte_hva = kvm_set_spte_hva_hv,
 	.mmu_destroy  = kvmppc_mmu_destroy_hv,
 	.free_memslot = kvmppc_core_free_memslot_hv,
-	.create_memslot = kvmppc_core_create_memslot_hv,
 	.init_vm =  kvmppc_core_init_vm_hv,
 	.destroy_vm = kvmppc_core_destroy_vm_hv,
 	.get_smmu_info = kvm_vm_ioctl_get_smmu_info_hv,
diff --git a/arch/powerpc/kvm/book3s_pr.c b/arch/powerpc/kvm/book3s_pr.c
index ce4fcf76e53e..fc0d9432013f 100644
--- a/arch/powerpc/kvm/book3s_pr.c
+++ b/arch/powerpc/kvm/book3s_pr.c
@@ -1940,7 +1940,8 @@ static void kvmppc_core_flush_memslot_pr(struct kvm *kvm,
 
 static int kvmppc_core_prepare_memory_region_pr(struct kvm *kvm,
 					struct kvm_memory_slot *memslot,
-					const struct kvm_userspace_memory_region *mem)
+					const struct kvm_userspace_memory_region *mem,
+					enum kvm_mr_change change)
 {
 	return 0;
 }
@@ -1960,13 +1961,6 @@ static void kvmppc_core_free_memslot_pr(struct kvm_memory_slot *free,
 	return;
 }
 
-static int kvmppc_core_create_memslot_pr(struct kvm_memory_slot *slot,
-					 unsigned long npages)
-{
-	return 0;
-}
-
-
 #ifdef CONFIG_PPC64
 static int kvm_vm_ioctl_get_smmu_info_pr(struct kvm *kvm,
 					 struct kvm_ppc_smmu_info *info)
@@ -2111,7 +2105,6 @@ static struct kvmppc_ops kvm_ops_pr = {
 	.set_spte_hva = kvm_set_spte_hva_pr,
 	.mmu_destroy  = kvmppc_mmu_destroy_pr,
 	.free_memslot = kvmppc_core_free_memslot_pr,
-	.create_memslot = kvmppc_core_create_memslot_pr,
 	.init_vm = kvmppc_core_init_vm_pr,
 	.destroy_vm = kvmppc_core_destroy_vm_pr,
 	.get_smmu_info = kvm_vm_ioctl_get_smmu_info_pr,
diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
index be9a45874194..cf2845e147c5 100644
--- a/arch/powerpc/kvm/booke.c
+++ b/arch/powerpc/kvm/booke.c
@@ -1806,15 +1806,10 @@ void kvmppc_core_free_memslot(struct kvm *kvm, struct kvm_memory_slot *free,
 {
 }
 
-int kvmppc_core_create_memslot(struct kvm *kvm, struct kvm_memory_slot *slot,
-			       unsigned long npages)
-{
-	return 0;
-}
-
 int kvmppc_core_prepare_memory_region(struct kvm *kvm,
 				      struct kvm_memory_slot *memslot,
-				      const struct kvm_userspace_memory_region *mem)
+				      const struct kvm_userspace_memory_region *mem,
+				      enum kvm_mr_change change)
 {
 	return 0;
 }
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 416fb3d2a1d0..b0e6b33b476d 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -694,7 +694,7 @@ void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *free,
 int kvm_arch_create_memslot(struct kvm *kvm, struct kvm_memory_slot *slot,
 			    unsigned long npages)
 {
-	return kvmppc_core_create_memslot(kvm, slot, npages);
+	return 0;
 }
 
 int kvm_arch_prepare_memory_region(struct kvm *kvm,
@@ -702,7 +702,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 				   const struct kvm_userspace_memory_region *mem,
 				   enum kvm_mr_change change)
 {
-	return kvmppc_core_prepare_memory_region(kvm, memslot, mem);
+	return kvmppc_core_prepare_memory_region(kvm, memslot, mem, change);
 }
 
 void kvm_arch_commit_memory_region(struct kvm *kvm,
-- 
2.24.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
