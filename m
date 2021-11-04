Return-Path: <SRS0=oZIB=PX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4409C433FE
	for <kvmarm@archiver.kernel.org>; Thu,  4 Nov 2021 00:26:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 567D7611EE
	for <kvmarm@archiver.kernel.org>; Thu,  4 Nov 2021 00:26:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 567D7611EE
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 013D64B190;
	Wed,  3 Nov 2021 20:26:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rBhWQrFc75+X; Wed,  3 Nov 2021 20:26:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D6E134B1A9;
	Wed,  3 Nov 2021 20:26:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B04E4B13E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 20:26:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Hr6vTSCLPlqI for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Nov 2021 20:26:30 -0400 (EDT)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1CD4B4B190
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 20:26:30 -0400 (EDT)
Received: by mail-pl1-f201.google.com with SMTP id
 q2-20020a170902dac200b001422673d86fso1025417plx.20
 for <kvmarm@lists.cs.columbia.edu>; Wed, 03 Nov 2021 17:26:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=gefeXeMu+9xCn+OiiZbsmvywIWNyuYY1aczHxfS7F84=;
 b=q1wAaFzQivbUaLWNpD28vIW6ok97J24IWOZtjc0+hsnIoFnhMyUWsnSfQKoqN3maJ3
 KBdBMOyYnFaTKZvkOTgijuDb8a1y6dTYyIvATTjrk50gQdXgdq0sK8P9D8VXqeBwIchM
 S4752LKzCwKCElggFGcp/0gCfncZSwTidehk3QlNJHjH4YdWFX4NP2+qFH0XmXIojpE7
 shl+78ytzLoTN1+DNy2u1aXGBjCw+SMXFRKxDeT2bHggWBTmy7o/SubcktQSj4/PZQou
 hwUcODvMGvNUFZIWK9EWYU9o0oSTlOaqrHSlqsc6GHFHSECGSUQyaSoW+8/pBlFiy+YJ
 LVDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=gefeXeMu+9xCn+OiiZbsmvywIWNyuYY1aczHxfS7F84=;
 b=BPBTiiGnMrznh0bkAx8KEJqc+74LnnnS6tMJw4UbENBZzvlD9ulq5tVBnZxtmRcWlu
 Vj4wWdu3Oj7cgJ7JiM+j66/6zr+erm8fR7cIKRb95fJetriHKn+BVY6NFb5v7SEeN2J+
 o5B/ntodHGyld68bdcs1FOvUHuhpPBeRT238nS4HZ94JgYSP04rBzWSYe/+9H19lG4jc
 6FjZiyLZElNpUdf6qq8xjSChdn0uL+cnqNo0QiaxMsXC9GB2MqxTVB42BpB8K+HPaTOK
 +CmJfn90Pz83yc8255wrSo+PEH0XEZ9ZlRK7uhKNx8JQSLL8Cu1YNCQxOpA24NBIFKUk
 xpHQ==
X-Gm-Message-State: AOAM531wu3IZmTBZQk9kKBmmtMXlCc33L9Ng8TgHE4az7orEm44k/I2M
 IisKuI+OCprcv5yslHXjJPGDbKcVMnk=
X-Google-Smtp-Source: ABdhPJwuRHtV9T3+KFXWyLxF72TgsEexvxCX5VCcTZ2sr7WXwUborCujSIBbaHyiH9gR1LJWc7GYuxnx26s=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a63:740e:: with SMTP id
 p14mr35995604pgc.329.1635985589285; 
 Wed, 03 Nov 2021 17:26:29 -0700 (PDT)
Date: Thu,  4 Nov 2021 00:25:19 +0000
In-Reply-To: <20211104002531.1176691-1-seanjc@google.com>
Message-Id: <20211104002531.1176691-19-seanjc@google.com>
Mime-Version: 1.0
References: <20211104002531.1176691-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH v5.5 18/30] KVM: Don't make a full copy of the old memslot in
 __kvm_set_memory_region()
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

Stop making a full copy of the old memslot in __kvm_set_memory_region()
now that metadata updates are handled by kvm_set_memslot(), i.e. now that
the old memslot's dirty bitmap doesn't need to be referenced after the
memslot and its pointer is modified/invalidated by kvm_set_memslot().

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 35 +++++++++++++----------------------
 1 file changed, 13 insertions(+), 22 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6c7bbc452dae..bbaa01afac43 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1715,8 +1715,8 @@ static int kvm_set_memslot(struct kvm *kvm,
 int __kvm_set_memory_region(struct kvm *kvm,
 			    const struct kvm_userspace_memory_region *mem)
 {
-	struct kvm_memory_slot old, new;
-	struct kvm_memory_slot *tmp;
+	struct kvm_memory_slot *old, *tmp;
+	struct kvm_memory_slot new;
 	enum kvm_mr_change change;
 	int as_id, id;
 	int r;
@@ -1746,25 +1746,16 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		return -EINVAL;
 
 	/*
-	 * Make a full copy of the old memslot, the pointer will become stale
-	 * when the memslots are re-sorted by update_memslots(), and the old
-	 * memslot needs to be referenced after calling update_memslots(), e.g.
-	 * to free its resources and for arch specific behavior.
+	 * Note, the old memslot (and the pointer itself!) may be invalidated
+	 * and/or destroyed by kvm_set_memslot().
 	 */
-	tmp = id_to_memslot(__kvm_memslots(kvm, as_id), id);
-	if (tmp) {
-		old = *tmp;
-		tmp = NULL;
-	} else {
-		memset(&old, 0, sizeof(old));
-		old.id = id;
-	}
+	old = id_to_memslot(__kvm_memslots(kvm, as_id), id);
 
 	if (!mem->memory_size) {
-		if (!old.npages)
+		if (!old || !old->npages)
 			return -EINVAL;
 
-		if (WARN_ON_ONCE(kvm->nr_memslot_pages < old.npages))
+		if (WARN_ON_ONCE(kvm->nr_memslot_pages < old->npages))
 			return -EIO;
 
 		memset(&new, 0, sizeof(new));
@@ -1784,7 +1775,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	if (new.npages > KVM_MEM_MAX_NR_PAGES)
 		return -EINVAL;
 
-	if (!old.npages) {
+	if (!old || !old->npages) {
 		change = KVM_MR_CREATE;
 
 		/*
@@ -1794,14 +1785,14 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		if ((kvm->nr_memslot_pages + new.npages) < kvm->nr_memslot_pages)
 			return -EINVAL;
 	} else { /* Modify an existing slot. */
-		if ((new.userspace_addr != old.userspace_addr) ||
-		    (new.npages != old.npages) ||
-		    ((new.flags ^ old.flags) & KVM_MEM_READONLY))
+		if ((new.userspace_addr != old->userspace_addr) ||
+		    (new.npages != old->npages) ||
+		    ((new.flags ^ old->flags) & KVM_MEM_READONLY))
 			return -EINVAL;
 
-		if (new.base_gfn != old.base_gfn)
+		if (new.base_gfn != old->base_gfn)
 			change = KVM_MR_MOVE;
-		else if (new.flags != old.flags)
+		else if (new.flags != old->flags)
 			change = KVM_MR_FLAGS_ONLY;
 		else /* Nothing to change. */
 			return 0;
-- 
2.33.1.1089.g2158813163f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
