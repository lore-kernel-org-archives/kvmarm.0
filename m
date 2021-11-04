Return-Path: <SRS0=oZIB=PX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4AD2C433F5
	for <kvmarm@archiver.kernel.org>; Thu,  4 Nov 2021 00:26:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5A9F9611CA
	for <kvmarm@archiver.kernel.org>; Thu,  4 Nov 2021 00:26:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5A9F9611CA
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A8884B1A4;
	Wed,  3 Nov 2021 20:26:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id alRlyY+1p07J; Wed,  3 Nov 2021 20:26:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 441D64B13D;
	Wed,  3 Nov 2021 20:26:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C21404B13E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 20:26:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ygzC2AFHVMA0 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Nov 2021 20:26:23 -0400 (EDT)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1F7BA4B14C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 20:26:23 -0400 (EDT)
Received: by mail-pl1-f201.google.com with SMTP id
 y13-20020a1709029b8d00b0013dc7c668e2so1918095plp.16
 for <kvmarm@lists.cs.columbia.edu>; Wed, 03 Nov 2021 17:26:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=/RvGHTt4E3c4iVv3wsterupSlbh/I++vTjsd+nrbZTE=;
 b=HyykrtCCmq3kCamMD/Tm7VvDgqmDnoEsE+g1eeqH4NbqmVOGEIPXEF0p44V12K+tKv
 cuhUnPrZGQP5wZ3hLK+/1RKT0txi5xKCd+JuqAuxM/FmVqFBME7pAC+KWpd37Sadnmeu
 lG6JAvLtVSbJb1He7sVTN3iqT2jXaXZ9aCFU0nSIjt20mOePuQMygvc8lEwJBvVIqi6I
 K5uhrd/Mr5VKCjgNFfaDRg+gQDzGFZRQLuV3piNS1sOT1VVHqP+YMJNc8a7c9S8QvZA6
 4wHieFDZfoFTOKF1jdxfARHJJ/0OEyKmgNBjIBCXoaMWWRQ2moanjPbmOrNTixvUNha5
 SCMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=/RvGHTt4E3c4iVv3wsterupSlbh/I++vTjsd+nrbZTE=;
 b=kEuMKVKtiBoKew+mo3ekfEDLkIKFojN3uPh0XXmEcA1ye2aPnh6gXUes8gmAHW9Jv2
 vZdlMY+JKhYjHtUr3dJEHnWyjE5U4YR8LMNjf5HdW/oXLxEUtI/q//MQOQtGrQze8LhO
 il2KC0ecn4ARrMLoGcbkQhCWKwBT5+w4eYenIn6EiOnbYCmFh5o4YVXhb33rnnLi3p0s
 +A1dXpxJIEwFccg+y64c+joB8mu+MK664U3FeweJ2U4KbmGAHD0etm7GH/QQAQJj8dL9
 +bKZ3JWXMA7V82OJX5O/OdhVshN3rrXhZALiNBjpuBp2+Ita+IcMENBOvxudMQZX3MZM
 Ac4A==
X-Gm-Message-State: AOAM530DtHKOlXOdT0Awi/cj7CQjAkcFq8jRrXITU76dyPupLBHhVZ5P
 k1sWIUB5DJ16WsPR2QdNclNnIEuA5B4=
X-Google-Smtp-Source: ABdhPJzUTstetgr7LfAz4PUuI3fkJrGKDFjmFGhXU/D+Ufl0+b4ADI76LnvXO52LyVNOIFV+GAz+aYo+l4Q=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:9348:b0:141:5862:28b4
 with SMTP id
 g8-20020a170902934800b00141586228b4mr41368996plp.17.1635985582257; Wed, 03
 Nov 2021 17:26:22 -0700 (PDT)
Date: Thu,  4 Nov 2021 00:25:15 +0000
In-Reply-To: <20211104002531.1176691-1-seanjc@google.com>
Message-Id: <20211104002531.1176691-15-seanjc@google.com>
Mime-Version: 1.0
References: <20211104002531.1176691-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH v5.5 14/30] KVM: Stop passing kvm_userspace_memory_region to
 arch memslot hooks
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

Drop the @mem param from kvm_arch_{prepare,commit}_memory_region() now
that its use has been removed in all architectures.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kvm/mmu.c       | 2 --
 arch/mips/kvm/mips.c       | 2 --
 arch/powerpc/kvm/powerpc.c | 2 --
 arch/riscv/kvm/mmu.c       | 2 --
 arch/s390/kvm/kvm-s390.c   | 2 --
 arch/x86/kvm/x86.c         | 2 --
 include/linux/kvm_host.h   | 2 --
 virt/kvm/kvm_main.c        | 9 ++++-----
 8 files changed, 4 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 21213cba7c47..a76718388cbd 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1463,7 +1463,6 @@ int kvm_mmu_init(u32 *hyp_va_bits)
 }
 
 void kvm_arch_commit_memory_region(struct kvm *kvm,
-				   const struct kvm_userspace_memory_region *mem,
 				   struct kvm_memory_slot *old,
 				   const struct kvm_memory_slot *new,
 				   enum kvm_mr_change change)
@@ -1486,7 +1485,6 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 }
 
 int kvm_arch_prepare_memory_region(struct kvm *kvm,
-				   const struct kvm_userspace_memory_region *mem,
 				   const struct kvm_memory_slot *old,
 				   struct kvm_memory_slot *new,
 				   enum kvm_mr_change change)
diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index b7aa8fa4a5fb..47b7dc149032 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -233,7 +233,6 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 }
 
 int kvm_arch_prepare_memory_region(struct kvm *kvm,
-				   const struct kvm_userspace_memory_region *mem,
 				   const struct kvm_memory_slot *old,
 				   struct kvm_memory_slot *new,
 				   enum kvm_mr_change change)
@@ -242,7 +241,6 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 }
 
 void kvm_arch_commit_memory_region(struct kvm *kvm,
-				   const struct kvm_userspace_memory_region *mem,
 				   struct kvm_memory_slot *old,
 				   const struct kvm_memory_slot *new,
 				   enum kvm_mr_change change)
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 59342237e046..52ab1782b257 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -706,7 +706,6 @@ void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
 }
 
 int kvm_arch_prepare_memory_region(struct kvm *kvm,
-				   const struct kvm_userspace_memory_region *mem,
 				   const struct kvm_memory_slot *old,
 				   struct kvm_memory_slot *new,
 				   enum kvm_mr_change change)
@@ -715,7 +714,6 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 }
 
 void kvm_arch_commit_memory_region(struct kvm *kvm,
-				   const struct kvm_userspace_memory_region *mem,
 				   struct kvm_memory_slot *old,
 				   const struct kvm_memory_slot *new,
 				   enum kvm_mr_change change)
diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index db5230ec6951..0732867d398c 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -456,7 +456,6 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 }
 
 void kvm_arch_commit_memory_region(struct kvm *kvm,
-				const struct kvm_userspace_memory_region *mem,
 				struct kvm_memory_slot *old,
 				const struct kvm_memory_slot *new,
 				enum kvm_mr_change change)
@@ -471,7 +470,6 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 }
 
 int kvm_arch_prepare_memory_region(struct kvm *kvm,
-				   const struct kvm_userspace_memory_region *mem,
 				   const struct kvm_memory_slot *old,
 				   struct kvm_memory_slot *new,
 				   enum kvm_mr_change change)
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index e69ad13612d9..81f90891db0f 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -5016,7 +5016,6 @@ vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
 
 /* Section: memory related */
 int kvm_arch_prepare_memory_region(struct kvm *kvm,
-				   const struct kvm_userspace_memory_region *mem,
 				   const struct kvm_memory_slot *old,
 				   struct kvm_memory_slot *new,
 				   enum kvm_mr_change change)
@@ -5044,7 +5043,6 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 }
 
 void kvm_arch_commit_memory_region(struct kvm *kvm,
-				const struct kvm_userspace_memory_region *mem,
 				struct kvm_memory_slot *old,
 				const struct kvm_memory_slot *new,
 				enum kvm_mr_change change)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c68e7de9f116..80e726f73dd7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11727,7 +11727,6 @@ void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen)
 }
 
 int kvm_arch_prepare_memory_region(struct kvm *kvm,
-				   const struct kvm_userspace_memory_region *mem,
 				   const struct kvm_memory_slot *old,
 				   struct kvm_memory_slot *new,
 				   enum kvm_mr_change change)
@@ -11831,7 +11830,6 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 }
 
 void kvm_arch_commit_memory_region(struct kvm *kvm,
-				const struct kvm_userspace_memory_region *mem,
 				struct kvm_memory_slot *old,
 				const struct kvm_memory_slot *new,
 				enum kvm_mr_change change)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f8e79cf7584f..2ef946e94a73 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -826,12 +826,10 @@ int __kvm_set_memory_region(struct kvm *kvm,
 void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot);
 void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen);
 int kvm_arch_prepare_memory_region(struct kvm *kvm,
-				const struct kvm_userspace_memory_region *mem,
 				const struct kvm_memory_slot *old,
 				struct kvm_memory_slot *new,
 				enum kvm_mr_change change);
 void kvm_arch_commit_memory_region(struct kvm *kvm,
-				const struct kvm_userspace_memory_region *mem,
 				struct kvm_memory_slot *old,
 				const struct kvm_memory_slot *new,
 				enum kvm_mr_change change);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 389243120435..9c75691b98ba 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1535,7 +1535,6 @@ static void kvm_copy_memslots_arch(struct kvm_memslots *to,
 }
 
 static int kvm_set_memslot(struct kvm *kvm,
-			   const struct kvm_userspace_memory_region *mem,
 			   struct kvm_memory_slot *new,
 			   enum kvm_mr_change change)
 {
@@ -1621,7 +1620,7 @@ static int kvm_set_memslot(struct kvm *kvm,
 		old.as_id = new->as_id;
 	}
 
-	r = kvm_arch_prepare_memory_region(kvm, mem, &old, new, change);
+	r = kvm_arch_prepare_memory_region(kvm, &old, new, change);
 	if (r)
 		goto out_slots;
 
@@ -1637,7 +1636,7 @@ static int kvm_set_memslot(struct kvm *kvm,
 	else if (change == KVM_MR_CREATE)
 		kvm->nr_memslot_pages += new->npages;
 
-	kvm_arch_commit_memory_region(kvm, mem, &old, new, change);
+	kvm_arch_commit_memory_region(kvm, &old, new, change);
 
 	/* Free the old memslot's metadata.  Note, this is the full copy!!! */
 	if (change == KVM_MR_DELETE)
@@ -1722,7 +1721,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		new.id = id;
 		new.as_id = as_id;
 
-		return kvm_set_memslot(kvm, mem, &new, KVM_MR_DELETE);
+		return kvm_set_memslot(kvm, &new, KVM_MR_DELETE);
 	}
 
 	new.as_id = as_id;
@@ -1785,7 +1784,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 			bitmap_set(new.dirty_bitmap, 0, new.npages);
 	}
 
-	r = kvm_set_memslot(kvm, mem, &new, change);
+	r = kvm_set_memslot(kvm, &new, change);
 	if (r)
 		goto out_bitmap;
 
-- 
2.33.1.1089.g2158813163f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
