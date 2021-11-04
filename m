Return-Path: <SRS0=oZIB=PX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C367C433FE
	for <kvmarm@archiver.kernel.org>; Thu,  4 Nov 2021 00:26:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D22F4611EE
	for <kvmarm@archiver.kernel.org>; Thu,  4 Nov 2021 00:26:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D22F4611EE
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 81BB34B125;
	Wed,  3 Nov 2021 20:26:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eXGPWwIR1eZL; Wed,  3 Nov 2021 20:26:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 26AB54B0C2;
	Wed,  3 Nov 2021 20:26:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C08B54B125
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 20:26:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 61YJ3QwF1nai for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Nov 2021 20:26:21 -0400 (EDT)
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com
 [209.85.210.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ADEB64B0B3
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 20:26:21 -0400 (EDT)
Received: by mail-pf1-f201.google.com with SMTP id
 c207-20020a621cd8000000b0048060050cfeso2355257pfc.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 03 Nov 2021 17:26:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=Knv6NX4aNDEtvlXPSeSH4G0VJXSoyW8J2lqqVusFeB0=;
 b=WAj+5pKSlToue5x/Xjp3tHAY8zkyEMkATjMwSDKkSLNc+c15nQO/y3IMeoonW+8TGW
 IJ//NVTbf9iDd83CZGqogcbVBJFAwkAWutEaX8OHtmK98GraXTwQmiojDJlfjgAF0LlZ
 VKLj3H4JJK4O+dXU8VVJcJqNhuhyRpmQ/xKaWsc+4pgLXjw9U6El3bcpe+Md5lqvOckG
 VcaHEmfZpm2lQzXxITOF5vpCwMpKOib5Ate7AUJbu3BfwOJ4sMpJbFl+NTQugIzCKWHz
 Bu63CaoNp5DbWRkc48ITeWB0/vQjNJnW0r5KU3r+tAHLd4I7Sk2VhJyHE/A1d5epjjc8
 jySg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=Knv6NX4aNDEtvlXPSeSH4G0VJXSoyW8J2lqqVusFeB0=;
 b=o9LrXdlCGeFka8dZFjn2PdFPemyxo4DJx7D1eat30AL7mrqcC78illRK32IhewmbmA
 vcJxpGb/w/h4ZfkszyDt+SEvFJKAX1qYKlXU0ZYJizueQEP5YfIUkQgqT90zSOm91JIS
 l0nLqlb7yyiV0QYbveUGZgqdL8Xf/3FNHAsLRcd5CKP6YaTLto5ZoIfpbJeVnJrLBDPG
 Ttf7VvyodIRzvhpDnu1iYabuB7wx/wmW48/LeAeYOokPTym6lirRyN6N0z7Xm141b3If
 Z72epmlldEPjjcLCKb2kgMzgYb1a37eUQcEioScKDBXu1l5Oo7rytLKNX/v/X2+I8CBA
 IkBg==
X-Gm-Message-State: AOAM533HtSjxvE1cDyt55YhYzJl3WbseQs350VBmc7S0RxHaXcd/UyYb
 3eW8dHyx6246J64uFFHihk+oTRnRZdU=
X-Google-Smtp-Source: ABdhPJycWJt6vZswesjO49ykEcHeMjmquF3AfKfwc6UF1QVg1hQjUz6uw6WOUx1iNerGeq81ot/R29ZJDgQ=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:c3:: with SMTP id
 v3mr252380pjd.0.1635985580217; Wed, 03 Nov 2021 17:26:20 -0700 (PDT)
Date: Thu,  4 Nov 2021 00:25:14 +0000
In-Reply-To: <20211104002531.1176691-1-seanjc@google.com>
Message-Id: <20211104002531.1176691-14-seanjc@google.com>
Mime-Version: 1.0
References: <20211104002531.1176691-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH v5.5 13/30] KVM: RISC-V: Use "new" memslot instead of
 userspace memory region
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

Opportunistically wait to get the various "new" values until after
filtering out the DELETE case in anticipation of a future commit passing
NULL for @new when deleting a memslot.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/riscv/kvm/mmu.c | 34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index 3a00c2df7640..db5230ec6951 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -466,18 +466,19 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 	 * allocated dirty_bitmap[], dirty pages will be tracked while
 	 * the memory slot is write protected.
 	 */
-	if (change != KVM_MR_DELETE && mem->flags & KVM_MEM_LOG_DIRTY_PAGES)
-		stage2_wp_memory_region(kvm, mem->slot);
+	if (change != KVM_MR_DELETE && new->flags & KVM_MEM_LOG_DIRTY_PAGES)
+		stage2_wp_memory_region(kvm, new->id);
 }
 
 int kvm_arch_prepare_memory_region(struct kvm *kvm,
-				struct kvm_memory_slot *memslot,
-				const struct kvm_userspace_memory_region *mem,
-				enum kvm_mr_change change)
+				   const struct kvm_userspace_memory_region *mem,
+				   const struct kvm_memory_slot *old,
+				   struct kvm_memory_slot *new,
+				   enum kvm_mr_change change)
 {
-	hva_t hva = mem->userspace_addr;
-	hva_t reg_end = hva + mem->memory_size;
-	bool writable = !(mem->flags & KVM_MEM_READONLY);
+	hva_t hva, reg_end, size;
+	gpa_t base_gpa;
+	bool writable;
 	int ret = 0;
 
 	if (change != KVM_MR_CREATE && change != KVM_MR_MOVE &&
@@ -488,10 +489,15 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	 * Prevent userspace from creating a memory region outside of the GPA
 	 * space addressable by the KVM guest GPA space.
 	 */
-	if ((memslot->base_gfn + memslot->npages) >=
-	    (stage2_gpa_size >> PAGE_SHIFT))
+	if ((new->base_gfn + new->npages) >= (stage2_gpa_size >> PAGE_SHIFT))
 		return -EFAULT;
 
+	hva = new->userspace_addr;
+	size = new->npages << PAGE_SHIFT;
+	reg_end = hva + size;
+	base_gpa = new->base_gfn << PAGE_SHIFT;
+	writable = !(new->flags & KVM_MEM_READONLY);
+
 	mmap_read_lock(current->mm);
 
 	/*
@@ -527,15 +533,14 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 		vm_end = min(reg_end, vma->vm_end);
 
 		if (vma->vm_flags & VM_PFNMAP) {
-			gpa_t gpa = mem->guest_phys_addr +
-				    (vm_start - mem->userspace_addr);
+			gpa_t gpa = base_gpa + (vm_start - hva);
 			phys_addr_t pa;
 
 			pa = (phys_addr_t)vma->vm_pgoff << PAGE_SHIFT;
 			pa += vm_start - vma->vm_start;
 
 			/* IO region dirty page logging not allowed */
-			if (memslot->flags & KVM_MEM_LOG_DIRTY_PAGES) {
+			if (new->flags & KVM_MEM_LOG_DIRTY_PAGES) {
 				ret = -EINVAL;
 				goto out;
 			}
@@ -553,8 +558,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 
 	spin_lock(&kvm->mmu_lock);
 	if (ret)
-		stage2_unmap_range(kvm, mem->guest_phys_addr,
-				   mem->memory_size, false);
+		stage2_unmap_range(kvm, base_gpa, size, false);
 	spin_unlock(&kvm->mmu_lock);
 
 out:
-- 
2.33.1.1089.g2158813163f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
