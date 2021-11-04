Return-Path: <SRS0=oZIB=PX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1796FC433EF
	for <kvmarm@archiver.kernel.org>; Thu,  4 Nov 2021 00:26:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BED2D611C7
	for <kvmarm@archiver.kernel.org>; Thu,  4 Nov 2021 00:26:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org BED2D611C7
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6DF6E4B1BD;
	Wed,  3 Nov 2021 20:26:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id V4lX7qCUU4vF; Wed,  3 Nov 2021 20:26:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 433E04B1F6;
	Wed,  3 Nov 2021 20:26:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FF584A3A5
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 20:26:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vuqTSpjKj6u6 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Nov 2021 20:26:49 -0400 (EDT)
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com
 [209.85.215.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8C4084B1BD
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 20:26:49 -0400 (EDT)
Received: by mail-pg1-f202.google.com with SMTP id
 f15-20020a63f74f000000b002cc203e1ee6so2400800pgk.7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 03 Nov 2021 17:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=cwptNtKIDGBxPZN/2DV/RXa3ZTx9EN7Ut32v7IxrbNY=;
 b=kp5W0d4ZKAqTQCeZRqX3O+a/DAfCjKvi3mu4Tg7fQ3jvfDHMY9wuQ5slcGHjKHrpuA
 O41kLcfJOvm1lVdKYW85uy2oNREGu2MSv7jrDheS1753o05M2Y57yo4STeIs65Q2EHGK
 B5up0zB0VZ6L8ytxDvtb0VGTD9hy1sbsnk0DAyC3cwRi4JiDc+TXwSManxsjb2qDyn2O
 OiXBUS1i7vJaF7j3il7TVpDWNEF8CLeaquv4Bhyqc0YSiiB0sbOWzXDrq3GuqvjBYdoT
 il3fanhD0s/lcfunhrA5jBW1o7Wn+UmL0jWWhjPVM5Fv3i3nvUx16q/ebHR7bCXwY+na
 ZUjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=cwptNtKIDGBxPZN/2DV/RXa3ZTx9EN7Ut32v7IxrbNY=;
 b=T4kV5htnotkYuuJ+0iS5SNSlOE8uIkfArMgdf3vuYUXZ8qeigP/FjOcp86ZFL1SK9O
 U95QJDajaHRfGzDYL2jgDNvdu1AESThY861PzRiuC+OeKDDFJq4f7k0b9IoA5f4u2jpf
 aXxvoafp6T0U0SLj48afcCO1ik6tPVIVvvcE3DUtwKxvBoirRQvkOOUVh/4E51s8WXUM
 gbr0QQDk1vcoTHXciQkM3vTiOlUwsN990lJOkXW6DtkIZeANd4qSGJCY+0+YzYH+UtVV
 2kuc57xZ2DN5KPD9UpdEmYun+et7u309zZyx1UfshOXR6IJqlw2T9GCKCUlwgE1B3+ic
 agbA==
X-Gm-Message-State: AOAM531apXZb5kmUuXcEKPJp6+MUgdf4A7pIJVjv9r7pIPcoJK+yX7Pt
 fQ6UBvifK6wGyxWU3djqetDMPVegOxs=
X-Google-Smtp-Source: ABdhPJwR0Cgz5rdM3APhtKmfNq/3RdcWCCfmBz9ZLpAOZgawdF+Lq6eMD3AhC92nfdAaylW7AAzDiY84qhk=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1709:b0:481:203:d3bd
 with SMTP id
 h9-20020a056a00170900b004810203d3bdmr28140075pfc.58.1635985608753; Wed, 03
 Nov 2021 17:26:48 -0700 (PDT)
Date: Thu,  4 Nov 2021 00:25:30 +0000
In-Reply-To: <20211104002531.1176691-1-seanjc@google.com>
Message-Id: <20211104002531.1176691-30-seanjc@google.com>
Mime-Version: 1.0
References: <20211104002531.1176691-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH v5.5 29/30] KVM: Wait 'til the bitter end to initialize the
 "new" memslot
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

Initialize the "new" memslot in the !DELETE path only after the various
sanity checks have passed.  This will allow a future commit to allocate
@new dynamically without having to copy a memslot, and without having to
deal with freeing @new in error paths and in the "nothing to change" path
that's hiding in the sanity checks.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 37 ++++++++++++++++++++-----------------
 1 file changed, 20 insertions(+), 17 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d22e40225703..5cc0b50faa8c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1838,6 +1838,8 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	struct kvm_memory_slot new;
 	struct kvm_memslots *slots;
 	enum kvm_mr_change change;
+	unsigned long npages;
+	gfn_t base_gfn;
 	int as_id, id;
 	int r;
 
@@ -1864,6 +1866,8 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		return -EINVAL;
 	if (mem->guest_phys_addr + mem->memory_size < mem->guest_phys_addr)
 		return -EINVAL;
+	if ((mem->memory_size >> PAGE_SHIFT) > KVM_MEM_MAX_NR_PAGES)
+		return -EINVAL;
 
 	slots = __kvm_memslots(kvm, as_id);
 
@@ -1887,15 +1891,8 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		return kvm_set_memslot(kvm, old, &new, KVM_MR_DELETE);
 	}
 
-	new.as_id = as_id;
-	new.id = id;
-	new.base_gfn = mem->guest_phys_addr >> PAGE_SHIFT;
-	new.npages = mem->memory_size >> PAGE_SHIFT;
-	new.flags = mem->flags;
-	new.userspace_addr = mem->userspace_addr;
-
-	if (new.npages > KVM_MEM_MAX_NR_PAGES)
-		return -EINVAL;
+	base_gfn = (mem->guest_phys_addr >> PAGE_SHIFT);
+	npages = (mem->memory_size >> PAGE_SHIFT);
 
 	if (!old || !old->npages) {
 		change = KVM_MR_CREATE;
@@ -1904,27 +1901,33 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		 * To simplify KVM internals, the total number of pages across
 		 * all memslots must fit in an unsigned long.
 		 */
-		if ((kvm->nr_memslot_pages + new.npages) < kvm->nr_memslot_pages)
+		if ((kvm->nr_memslot_pages + npages) < kvm->nr_memslot_pages)
 			return -EINVAL;
 	} else { /* Modify an existing slot. */
-		if ((new.userspace_addr != old->userspace_addr) ||
-		    (new.npages != old->npages) ||
-		    ((new.flags ^ old->flags) & KVM_MEM_READONLY))
+		if ((mem->userspace_addr != old->userspace_addr) ||
+		    (npages != old->npages) ||
+		    ((mem->flags ^ old->flags) & KVM_MEM_READONLY))
 			return -EINVAL;
 
-		if (new.base_gfn != old->base_gfn)
+		if (base_gfn != old->base_gfn)
 			change = KVM_MR_MOVE;
-		else if (new.flags != old->flags)
+		else if (mem->flags != old->flags)
 			change = KVM_MR_FLAGS_ONLY;
 		else /* Nothing to change. */
 			return 0;
 	}
 
 	if ((change == KVM_MR_CREATE || change == KVM_MR_MOVE) &&
-	    kvm_check_memslot_overlap(slots, id, new.base_gfn,
-				      new.base_gfn + new.npages))
+	    kvm_check_memslot_overlap(slots, id, base_gfn, base_gfn + npages))
 		return -EEXIST;
 
+	new.as_id = as_id;
+	new.id = id;
+	new.base_gfn = base_gfn;
+	new.npages = npages;
+	new.flags = mem->flags;
+	new.userspace_addr = mem->userspace_addr;
+
 	return kvm_set_memslot(kvm, old, &new, change);
 }
 EXPORT_SYMBOL_GPL(__kvm_set_memory_region);
-- 
2.33.1.1089.g2158813163f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
