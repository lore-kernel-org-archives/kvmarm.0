Return-Path: <SRS0=oZIB=PX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3863EC433EF
	for <kvmarm@archiver.kernel.org>; Thu,  4 Nov 2021 00:26:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DB8F7611ED
	for <kvmarm@archiver.kernel.org>; Thu,  4 Nov 2021 00:26:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org DB8F7611ED
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 87B904B1E4;
	Wed,  3 Nov 2021 20:26:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fJPDullITDpV; Wed,  3 Nov 2021 20:26:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1ED634B1CF;
	Wed,  3 Nov 2021 20:26:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 782FC4B10B
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 20:26:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id X0AT50Alnq7p for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Nov 2021 20:26:34 -0400 (EDT)
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com
 [209.85.215.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9228E4B14C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 20:26:33 -0400 (EDT)
Received: by mail-pg1-f201.google.com with SMTP id
 g26-20020a63521a000000b0029524f04f5aso2404517pgb.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 03 Nov 2021 17:26:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=h7EfkSVswSL3FymMNglXt58S7Vc0tx9NzVk9JdibdVk=;
 b=DBOeGcjhrXQwhK0FDOBounT9evoR1Uijermfpo2pBeH9R90xNB6NiKKYfJXt4+tgd/
 IJ6jypcgRe3jOg4zlXWx5eC1V32MNn6vaqHSQr5smH43RoADVpNyl0gwCePpvloc8Ypr
 F1pfRhWLlrBnkA1hdX3ERXkuM/PO79U9BEXqecoo3QkL6YdP7YHLNYC5NWI2JUA/rUmh
 xU//wrDCCMLfmQuyamdw2hMfy0zAoUq6wowZ4aj1Y2drElfwl5AaFtyY1b2PFE88cjJE
 QyDIm2njMA5AFpQT4XPba1500YCHFs+L2URKin8PC+/TgGc7BaLAMkj9Nt+raQ950oUC
 96+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=h7EfkSVswSL3FymMNglXt58S7Vc0tx9NzVk9JdibdVk=;
 b=iwjoDwlYlJBrDu7FNYrhVm/ivDasismGfdTySl6WZvawQA+FZuvsLBnaS6VRYCo6VJ
 T0Efi2zdh/UBLv7qcTJKhR4vKaoFFOrcOmQ8WFhLQJGaW4nqxoOmlQUoL0e2x+mUB1SR
 s0IBHBB9b1txD+am4B28kdmmo1q70UgrfRxzY8kRcyQnyiW2aXyYmYxPVOuL6sRdHXdC
 YJ4lYtJEDs2qqHafIb4y6k2R9N4UFoeWqpUzLPP++xl3jFZL3mE6io8MjNlkYiEJj5M2
 g+bRKPdrK9kojqaShp5Pp4riQZWcNBZ4/Ph0tVb71BozYNasRCdKdsM6dbSTJc1i8pt+
 ESTg==
X-Gm-Message-State: AOAM532B/egxYX6ns3EociG0ega3T7dgUuf6j//Bi1fywgztvNjjeyMF
 2NkIAq7yrUt9m7nk0jOnZDeYq3s+cec=
X-Google-Smtp-Source: ABdhPJxsxHfihcUwqJ9+RVNX21hbTOai5CGcJvQmgGN1uIZFdZGoK7dZESQoRGdygHMeGrtUc4zbFpEoUSY=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a63:83c2:: with SMTP id
 h185mr20757080pge.146.1635985592609; 
 Wed, 03 Nov 2021 17:26:32 -0700 (PDT)
Date: Thu,  4 Nov 2021 00:25:21 +0000
In-Reply-To: <20211104002531.1176691-1-seanjc@google.com>
Message-Id: <20211104002531.1176691-21-seanjc@google.com>
Mime-Version: 1.0
References: <20211104002531.1176691-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH v5.5 20/30] KVM: x86: Use nr_memslot_pages to avoid traversing
 the memslots array
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

From: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>

There is no point in recalculating from scratch the total number of pages
in all memslots each time a memslot is created or deleted.  Use KVM's
cached nr_memslot_pages to compute the default max number of MMU pages.

Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
[sean: use common KVM field and rework changelog accordingly]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  1 -
 arch/x86/kvm/mmu/mmu.c          | 24 ------------------------
 arch/x86/kvm/x86.c              | 11 ++++++++---
 3 files changed, 8 insertions(+), 28 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 88fce6ab4bbd..3fe155ece015 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1582,7 +1582,6 @@ void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
 				   const struct kvm_memory_slot *memslot);
 void kvm_mmu_zap_all(struct kvm *kvm);
 void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen);
-unsigned long kvm_mmu_calculate_default_mmu_pages(struct kvm *kvm);
 void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned long kvm_nr_mmu_pages);
 
 int load_pdptrs(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu, unsigned long cr3);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 354d2ca92df4..564781585fd2 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6141,30 +6141,6 @@ int kvm_mmu_module_init(void)
 	return ret;
 }
 
-/*
- * Calculate mmu pages needed for kvm.
- */
-unsigned long kvm_mmu_calculate_default_mmu_pages(struct kvm *kvm)
-{
-	unsigned long nr_mmu_pages;
-	unsigned long nr_pages = 0;
-	struct kvm_memslots *slots;
-	struct kvm_memory_slot *memslot;
-	int i;
-
-	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
-		slots = __kvm_memslots(kvm, i);
-
-		kvm_for_each_memslot(memslot, slots)
-			nr_pages += memslot->npages;
-	}
-
-	nr_mmu_pages = nr_pages * KVM_PERMILLE_MMU_PAGES / 1000;
-	nr_mmu_pages = max(nr_mmu_pages, KVM_MIN_ALLOC_MMU_PAGES);
-
-	return nr_mmu_pages;
-}
-
 void kvm_mmu_destroy(struct kvm_vcpu *vcpu)
 {
 	kvm_mmu_unload(vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4b0cb7390902..9a0440e22ede 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11837,9 +11837,14 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 				enum kvm_mr_change change)
 {
 	if (!kvm->arch.n_requested_mmu_pages &&
-	    (change == KVM_MR_CREATE || change == KVM_MR_DELETE))
-		kvm_mmu_change_mmu_pages(kvm,
-				kvm_mmu_calculate_default_mmu_pages(kvm));
+	    (change == KVM_MR_CREATE || change == KVM_MR_DELETE)) {
+		unsigned long nr_mmu_pages;
+
+		nr_mmu_pages = kvm->nr_memslot_pages * KVM_PERMILLE_MMU_PAGES;
+		nr_mmu_pages /= 1000;
+		nr_mmu_pages = max(nr_mmu_pages, KVM_MIN_ALLOC_MMU_PAGES);
+		kvm_mmu_change_mmu_pages(kvm, nr_mmu_pages);
+	}
 
 	kvm_mmu_slot_apply_flags(kvm, old, new, change);
 
-- 
2.33.1.1089.g2158813163f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
