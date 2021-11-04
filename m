Return-Path: <SRS0=oZIB=PX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75B02C433EF
	for <kvmarm@archiver.kernel.org>; Thu,  4 Nov 2021 00:26:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 241E1611CA
	for <kvmarm@archiver.kernel.org>; Thu,  4 Nov 2021 00:26:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 241E1611CA
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C57964B10B;
	Wed,  3 Nov 2021 20:26:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jObRFTgHvPC3; Wed,  3 Nov 2021 20:26:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B62204B093;
	Wed,  3 Nov 2021 20:26:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 79C954B13D
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 20:26:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rhYYUEewLB9C for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Nov 2021 20:26:17 -0400 (EDT)
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com
 [209.85.215.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1EED84B18F
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 20:26:16 -0400 (EDT)
Received: by mail-pg1-f202.google.com with SMTP id
 t75-20020a63784e000000b002993a9284b0so2383644pgc.11
 for <kvmarm@lists.cs.columbia.edu>; Wed, 03 Nov 2021 17:26:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=PjovHHKwir4eMxna9ALNlFgtKtfStcoQnuN5jUx4d74=;
 b=MzRIGZ00uU1v6jXFg7sOa49q0QiiJzIeJF0fsnZltmvZzCFhconYRc7Mql7/SxLGGe
 PQR/3RHhBtRSAtrokWdTMRIYSNfCjrzeqp/2pYl4nuIUdLA+tNXzlJj4UmkkkIK9LPqV
 7p7wAQ5d9Kyg2fkqIEMVil6Qgqe36g5ifelvyOMR/AYAS8U+ERKkQK+cGyQQZ8x89Oqo
 pR44zTX8U0CmR165/PWPO3esK4NT4i+1siE3vZY8sMARYj2xTKpTBhSVsLlYNqaeTVf1
 xDjmvGuKQEAXKpLgA0+7lW1H38uqGwX51Von2AgvBjNF1O3E3ZNcRPe20jLwzon1Y1yB
 H4FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=PjovHHKwir4eMxna9ALNlFgtKtfStcoQnuN5jUx4d74=;
 b=gnC+iGL57UuUpPil/n893675L03x8e1UhNe+GnXTNFVOZUQA8txLUbiYDqglPHXAAC
 ONkQ5HuUvVKFlsC6T5CozL94C8B8KLe/TcoWo3TxJzB8XD33571grLZPcjev7FneQUdw
 j9WD3XPxKpHB8UxsNvc+YwtELu7eYb8KrLPtnRj+EaNoviilmlpGWKFPlG6iuKZHh6uE
 LI7EAR93o4riFj7e2hBPVJd2jdj7mCWUsH3wEgCOthOtsutDJ+WF/9gRdHfFV/hDYqad
 meRQPkEtvmD4U40f4iP6l+Obl9QmV1DUpepaXL4PKFyy+nfnkwTMvsYgN5MA94FMmaUL
 +TXQ==
X-Gm-Message-State: AOAM531ny9gRCDoZT8KNQl5sL1LsUHWhtaKMHJ0O6XoisoZv5QBOK+Hw
 5s/y7Dm8BXt9p8CdPJmPRq9BS4i1ITM=
X-Google-Smtp-Source: ABdhPJzQ7YmaVSHBOjM7K350dhFQvaiNwSHal69feIXmb76g43+5TJfukiKupDeHK6Cfhk2S1QB6BJZI8TM=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:1643:: with SMTP id
 il3mr11048014pjb.182.1635985575294; Wed, 03 Nov 2021 17:26:15 -0700 (PDT)
Date: Thu,  4 Nov 2021 00:25:11 +0000
In-Reply-To: <20211104002531.1176691-1-seanjc@google.com>
Message-Id: <20211104002531.1176691-11-seanjc@google.com>
Mime-Version: 1.0
References: <20211104002531.1176691-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH v5.5 10/30] KVM: PPC: Avoid referencing userspace memory
 region in memslot updates
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, 
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Paul Mackerras <paulus@ozlabs.org>, 
 Anup Patel <anup.patel@wdc.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
 Atish Patra <atish.patra@wdc.com>, Ben Gardon <bgardon@google.com>,
 "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, linux-riscv@lists.infradead.org,
 Joerg Roedel <joro@8bytes.org>, kvmarm@lists.cs.columbia.edu,
 kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>, Cornelia Huck <cohuck@redhat.com>,
 linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
 Vitaly Kuznetsov <vkuznets@redhat.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Sean Christopherson <seanjc@google.com>
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

For PPC HV, get the number of pages directly from the new memslot instead
of computing the same from the userspace memory region, and explicitly
check for !DELETE instead of inferring the same when toggling mmio_update.
The motivation for these changes is to avoid referencing the @mem param
so that it can be dropped in a future commit.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/powerpc/include/asm/kvm_ppc.h |  4 ----
 arch/powerpc/kvm/book3s.c          |  6 ++----
 arch/powerpc/kvm/book3s_hv.c       | 12 +++---------
 arch/powerpc/kvm/book3s_pr.c       |  2 --
 arch/powerpc/kvm/booke.c           |  2 --
 arch/powerpc/kvm/powerpc.c         |  4 ++--
 6 files changed, 7 insertions(+), 23 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
index b01760dd1374..935c58dc38c4 100644
--- a/arch/powerpc/include/asm/kvm_ppc.h
+++ b/arch/powerpc/include/asm/kvm_ppc.h
@@ -200,12 +200,10 @@ extern void kvmppc_core_destroy_vm(struct kvm *kvm);
 extern void kvmppc_core_free_memslot(struct kvm *kvm,
 				     struct kvm_memory_slot *slot);
 extern int kvmppc_core_prepare_memory_region(struct kvm *kvm,
-				const struct kvm_userspace_memory_region *mem,
 				const struct kvm_memory_slot *old,
 				struct kvm_memory_slot *new,
 				enum kvm_mr_change change);
 extern void kvmppc_core_commit_memory_region(struct kvm *kvm,
-				const struct kvm_userspace_memory_region *mem,
 				struct kvm_memory_slot *old,
 				const struct kvm_memory_slot *new,
 				enum kvm_mr_change change);
@@ -275,12 +273,10 @@ struct kvmppc_ops {
 	int (*get_dirty_log)(struct kvm *kvm, struct kvm_dirty_log *log);
 	void (*flush_memslot)(struct kvm *kvm, struct kvm_memory_slot *memslot);
 	int (*prepare_memory_region)(struct kvm *kvm,
-				     const struct kvm_userspace_memory_region *mem,
 				     const struct kvm_memory_slot *old,
 				     struct kvm_memory_slot *new,
 				     enum kvm_mr_change change);
 	void (*commit_memory_region)(struct kvm *kvm,
-				     const struct kvm_userspace_memory_region *mem,
 				     struct kvm_memory_slot *old,
 				     const struct kvm_memory_slot *new,
 				     enum kvm_mr_change change);
diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index 8250e8308674..6d525285dbe8 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -847,21 +847,19 @@ void kvmppc_core_flush_memslot(struct kvm *kvm, struct kvm_memory_slot *memslot)
 }
 
 int kvmppc_core_prepare_memory_region(struct kvm *kvm,
-				      const struct kvm_userspace_memory_region *mem,
 				      const struct kvm_memory_slot *old,
 				      struct kvm_memory_slot *new,
 				      enum kvm_mr_change change)
 {
-	return kvm->arch.kvm_ops->prepare_memory_region(kvm, mem, old, new, change);
+	return kvm->arch.kvm_ops->prepare_memory_region(kvm, old, new, change);
 }
 
 void kvmppc_core_commit_memory_region(struct kvm *kvm,
-				const struct kvm_userspace_memory_region *mem,
 				struct kvm_memory_slot *old,
 				const struct kvm_memory_slot *new,
 				enum kvm_mr_change change)
 {
-	kvm->arch.kvm_ops->commit_memory_region(kvm, mem, old, new, change);
+	kvm->arch.kvm_ops->commit_memory_region(kvm, old, new, change);
 }
 
 bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 5bf763a74c22..4d40c1867be5 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4828,15 +4828,12 @@ static void kvmppc_core_free_memslot_hv(struct kvm_memory_slot *slot)
 }
 
 static int kvmppc_core_prepare_memory_region_hv(struct kvm *kvm,
-				const struct kvm_userspace_memory_region *mem,
 				const struct kvm_memory_slot *old,
 				struct kvm_memory_slot *new,
 				enum kvm_mr_change change)
 {
-	unsigned long npages = mem->memory_size >> PAGE_SHIFT;
-
 	if (change == KVM_MR_CREATE) {
-		new->arch.rmap = vzalloc(array_size(npages,
+		new->arch.rmap = vzalloc(array_size(new->npages,
 					  sizeof(*new->arch.rmap)));
 		if (!new->arch.rmap)
 			return -ENOMEM;
@@ -4848,20 +4845,17 @@ static int kvmppc_core_prepare_memory_region_hv(struct kvm *kvm,
 }
 
 static void kvmppc_core_commit_memory_region_hv(struct kvm *kvm,
-				const struct kvm_userspace_memory_region *mem,
 				struct kvm_memory_slot *old,
 				const struct kvm_memory_slot *new,
 				enum kvm_mr_change change)
 {
-	unsigned long npages = mem->memory_size >> PAGE_SHIFT;
-
 	/*
-	 * If we are making a new memslot, it might make
+	 * If we are creating or modifying a memslot, it might make
 	 * some address that was previously cached as emulated
 	 * MMIO be no longer emulated MMIO, so invalidate
 	 * all the caches of emulated MMIO translations.
 	 */
-	if (npages)
+	if (change != KVM_MR_DELETE)
 		atomic64_inc(&kvm->arch.mmio_update);
 
 	/*
diff --git a/arch/powerpc/kvm/book3s_pr.c b/arch/powerpc/kvm/book3s_pr.c
index 58d3ae4605c0..ca3bfba94fe4 100644
--- a/arch/powerpc/kvm/book3s_pr.c
+++ b/arch/powerpc/kvm/book3s_pr.c
@@ -1899,7 +1899,6 @@ static void kvmppc_core_flush_memslot_pr(struct kvm *kvm,
 }
 
 static int kvmppc_core_prepare_memory_region_pr(struct kvm *kvm,
-				const struct kvm_userspace_memory_region *mem,
 				const struct kvm_memory_slot *old,
 				struct kvm_memory_slot *new,
 				enum kvm_mr_change change)
@@ -1908,7 +1907,6 @@ static int kvmppc_core_prepare_memory_region_pr(struct kvm *kvm,
 }
 
 static void kvmppc_core_commit_memory_region_pr(struct kvm *kvm,
-				const struct kvm_userspace_memory_region *mem,
 				struct kvm_memory_slot *old,
 				const struct kvm_memory_slot *new,
 				enum kvm_mr_change change)
diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
index fcf9c1dbd442..25dcf079c713 100644
--- a/arch/powerpc/kvm/booke.c
+++ b/arch/powerpc/kvm/booke.c
@@ -1807,7 +1807,6 @@ void kvmppc_core_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
 }
 
 int kvmppc_core_prepare_memory_region(struct kvm *kvm,
-				      const struct kvm_userspace_memory_region *mem,
 				      const struct kvm_memory_slot *old,
 				      struct kvm_memory_slot *new,
 				      enum kvm_mr_change change)
@@ -1816,7 +1815,6 @@ int kvmppc_core_prepare_memory_region(struct kvm *kvm,
 }
 
 void kvmppc_core_commit_memory_region(struct kvm *kvm,
-				const struct kvm_userspace_memory_region *mem,
 				struct kvm_memory_slot *old,
 				const struct kvm_memory_slot *new,
 				enum kvm_mr_change change)
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index ca28e7acaae8..59342237e046 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -711,7 +711,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 				   struct kvm_memory_slot *new,
 				   enum kvm_mr_change change)
 {
-	return kvmppc_core_prepare_memory_region(kvm, mem, old, new, change);
+	return kvmppc_core_prepare_memory_region(kvm, old, new, change);
 }
 
 void kvm_arch_commit_memory_region(struct kvm *kvm,
@@ -720,7 +720,7 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 				   const struct kvm_memory_slot *new,
 				   enum kvm_mr_change change)
 {
-	kvmppc_core_commit_memory_region(kvm, mem, old, new, change);
+	kvmppc_core_commit_memory_region(kvm, old, new, change);
 }
 
 void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
-- 
2.33.1.1089.g2158813163f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
