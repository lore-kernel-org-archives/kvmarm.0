Return-Path: <SRS0=oZIB=PX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E685FC433F5
	for <kvmarm@archiver.kernel.org>; Thu,  4 Nov 2021 00:26:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 83C2B611CA
	for <kvmarm@archiver.kernel.org>; Thu,  4 Nov 2021 00:26:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 83C2B611CA
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3521D4B10D;
	Wed,  3 Nov 2021 20:26:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id txCxHjQAWjyn; Wed,  3 Nov 2021 20:26:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 781964B19F;
	Wed,  3 Nov 2021 20:26:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 903B54B12E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 20:26:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uGFByQSdVXMI for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Nov 2021 20:26:14 -0400 (EDT)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A09D34B0C2
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 20:26:12 -0400 (EDT)
Received: by mail-pl1-f201.google.com with SMTP id
 k9-20020a170902c40900b001421e921ccaso1431977plk.22
 for <kvmarm@lists.cs.columbia.edu>; Wed, 03 Nov 2021 17:26:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=tLQvwVMFuRU1rudmVd+Ot8DGDwWCKV2XWE4z9OvxcSI=;
 b=aidjRg109rDQhcbEOaDvYUP/J6xeFiJXWQHPB/9inpIU47CGJj4EB+RwhcIG070Mie
 lVHTfvEeNG2Brzpgw8EZNdAVeUVZ4nNqCUo0Ix5XLJ0H18oJo/2rFOKMzl6fWLSJY191
 J6xXKGp+3siToXIqVebLKzjgDI+yAMnV78lg50hWKNPX/pVq2TrOflawSIczG+Lqobke
 Z0ZzafsHPcdo8PEDuhw/rn2m58dsopFaT3sRkFsFmilo83Ii5s7nnixu4BD3y0cdffxJ
 kzs8TJbXMv5IItYIkJSv/EhZBtHn1F5Yu5VOIhoRSGmVNkoq+MSSDwRM5budJwMaPSM5
 i1ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=tLQvwVMFuRU1rudmVd+Ot8DGDwWCKV2XWE4z9OvxcSI=;
 b=VJSRQXNUE8fPNEhsoRVdkAwBXHuJY4pyIDjGWqejEKB1Us78Ccr02/vGMs0LuweaXx
 wJa4t1KGzcQNgWM4xfLoKbGFDP+yyG3+SjQVOo169KOllzf37b7qeCQdcWwaRBRK9QY5
 lNVGgoGi6vaeEIDESprL/HDi8kePQ619lZL3+BOLWOYvq1YKZ2kzNREQbXN5ieHyoUMJ
 FB870NMBkb9P9Pk0+Y6bFck+25Gt4rSpPFkiB8ofCUTcooOxvY7OILe4yLdfPprUt+nW
 DFtsiJzPPh8TpEu9xGJqYAuW+5EO13HPUdXbLw3llku4dYiARqr/ZXOiALlbIaOImEIP
 RQ1Q==
X-Gm-Message-State: AOAM532LrrDawDuPLsZ9wwWV1HvKkQvtuTfnHUY610HUuUS5jxuep4v0
 k1Sv91W5jLMcMaJcXomeQ07WOucl+EI=
X-Google-Smtp-Source: ABdhPJwCsMzZuRxv6iw0pTuYU4/wjVIfD1uNyeuH4Gna3eUrPsMPSwpB1c5wUSrPuzkGj84qqgXi63hO2s0=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1484:b0:48c:2e58:8d39
 with SMTP id
 v4-20020a056a00148400b0048c2e588d39mr11085289pfu.13.1635985571770; Wed, 03
 Nov 2021 17:26:11 -0700 (PDT)
Date: Thu,  4 Nov 2021 00:25:09 +0000
In-Reply-To: <20211104002531.1176691-1-seanjc@google.com>
Message-Id: <20211104002531.1176691-9-seanjc@google.com>
Mime-Version: 1.0
References: <20211104002531.1176691-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH v5.5 08/30] KVM: arm64: Use "new" memslot instead of userspace
 memory region
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

Get the slot ID, hva, etc... from the "new" memslot instead of the
userspace memory region when preparing/committing a memory region.  This
will allow a future commit to drop @mem from the prepare/commit hooks
once all architectures convert to using "new".

Opportunistically wait to get the hva begin+end until after filtering out
the DELETE case in anticipation of a future commit passing NULL for @new
when deleting a memslot.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kvm/mmu.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index cc41eadfbbf4..21213cba7c47 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1473,14 +1473,14 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 	 * allocated dirty_bitmap[], dirty pages will be tracked while the
 	 * memory slot is write protected.
 	 */
-	if (change != KVM_MR_DELETE && mem->flags & KVM_MEM_LOG_DIRTY_PAGES) {
+	if (change != KVM_MR_DELETE && new->flags & KVM_MEM_LOG_DIRTY_PAGES) {
 		/*
 		 * If we're with initial-all-set, we don't need to write
 		 * protect any pages because they're all reported as dirty.
 		 * Huge pages and normal pages will be write protect gradually.
 		 */
 		if (!kvm_dirty_log_manual_protect_and_init_set(kvm)) {
-			kvm_mmu_wp_memory_region(kvm, mem->slot);
+			kvm_mmu_wp_memory_region(kvm, new->id);
 		}
 	}
 }
@@ -1491,8 +1491,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 				   struct kvm_memory_slot *new,
 				   enum kvm_mr_change change)
 {
-	hva_t hva = mem->userspace_addr;
-	hva_t reg_end = hva + mem->memory_size;
+	hva_t hva, reg_end;
 	int ret = 0;
 
 	if (change != KVM_MR_CREATE && change != KVM_MR_MOVE &&
@@ -1506,6 +1505,9 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	if ((new->base_gfn + new->npages) > (kvm_phys_size(kvm) >> PAGE_SHIFT))
 		return -EFAULT;
 
+	hva = new->userspace_addr;
+	reg_end = hva + (new->npages << PAGE_SHIFT);
+
 	mmap_read_lock(current->mm);
 	/*
 	 * A memory region could potentially cover multiple VMAs, and any holes
-- 
2.33.1.1089.g2158813163f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
