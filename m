Return-Path: <SRS0=oZIB=PX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF8FAC433F5
	for <kvmarm@archiver.kernel.org>; Thu,  4 Nov 2021 00:26:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6F820611EF
	for <kvmarm@archiver.kernel.org>; Thu,  4 Nov 2021 00:26:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6F820611EF
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 20FF44B12E;
	Wed,  3 Nov 2021 20:26:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TKNtfQ0Pj9bO; Wed,  3 Nov 2021 20:26:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0BB5D4B13D;
	Wed,  3 Nov 2021 20:26:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3BB394B0CB
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 20:26:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VaxGn7hbCPaJ for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Nov 2021 20:26:20 -0400 (EDT)
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com
 [209.85.215.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8C3D34A3A5
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 20:26:19 -0400 (EDT)
Received: by mail-pg1-f201.google.com with SMTP id
 o1-20020a635d41000000b002bd97c0a03dso2407898pgm.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 03 Nov 2021 17:26:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=A6RNuBqUgsG4d2AkEOuVD6njvyuDvF4HW/gggxH+5XA=;
 b=OEQtzcgzg8iUsXNKyYwVPMo1zK+4Kr5qoKxGqBuItQV2mlefdBnexzTvsQV8x7tFLB
 DJ7N1H9zaKUjIJM9lgUrmNBtCvPaEhJRmE75YYyGNfGHftU+r7zpZ5tAJxYDGkRZ5UaN
 eCFKKjVPfyvAv1MPQ+W3cG8F1U785VZ2TB/bCNeburay+vZTg802nta3hX92M+l5e/kY
 v9PkejhG6TTnKgDhaZRjUpks89CX+RjAuwRAYXLN4sVhejbhHruqwLuHdy9a63l08zeG
 UQHlhHNETrOYUd9aJ76VJnvg16EQRO47SPl2LKCIPj/pp3bTuMRIyoksJkM8yu5B2mRm
 sSDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=A6RNuBqUgsG4d2AkEOuVD6njvyuDvF4HW/gggxH+5XA=;
 b=aRP5itH/JD+mk/TovLc6zCqoUT7NFewnybom+itFjGCI963XE7hIDBImIgNW1wbYG3
 QHU3CBSUU+nkbTDn83oUvZkVBAKIPhsVfSF1kGaP70Epo4eCWnTEgKdqnRgsS1Cydhva
 +JL5VF3NqmxNJ2WUdvXa5jFP8hDVI233WdePU62N5j1j+7yHlNsyQLWSlzYo1i62Fn+G
 MwOb/sjfmC4uYNUsmohT0VDNc9GW8OerErkbr93NWgI3MNmXP0VfAQYWD9ccumvjrhb1
 zF15PmRemEqg/zwjJ+65wLOe3Yqxn9aCh2nb/3uLars/rnZV8pYZDx05sR+3kzmgh95+
 Jj2w==
X-Gm-Message-State: AOAM530on5DvRta2OL1r22A622JN4HL42RbSzp1889MsiKf2pe2EdbYy
 veZqf/eKLCpMrrdNR0kFptU9zaJOurE=
X-Google-Smtp-Source: ABdhPJwlGR9LbkwslcTVo23oQzDGM/4MShAybN51snLAMyuOhBW32wf0LbVvAKT8z91bQYBzxg51jn3JWKY=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2181:b0:44c:f4bc:2f74
 with SMTP id
 h1-20020a056a00218100b0044cf4bc2f74mr47624205pfi.68.1635985578784; Wed, 03
 Nov 2021 17:26:18 -0700 (PDT)
Date: Thu,  4 Nov 2021 00:25:13 +0000
In-Reply-To: <20211104002531.1176691-1-seanjc@google.com>
Message-Id: <20211104002531.1176691-13-seanjc@google.com>
Mime-Version: 1.0
References: <20211104002531.1176691-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH v5.5 12/30] KVM: x86: Use "new" memslot instead of userspace
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

Get the number of pages directly from the new memslot instead of
computing the same from the userspace memory region when allocating
memslot metadata.  This will allow a future patch to drop @mem.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index aa2abca47af0..c68e7de9f116 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11646,9 +11646,9 @@ int memslot_rmap_alloc(struct kvm_memory_slot *slot, unsigned long npages)
 }
 
 static int kvm_alloc_memslot_metadata(struct kvm *kvm,
-				      struct kvm_memory_slot *slot,
-				      unsigned long npages)
+				      struct kvm_memory_slot *slot)
 {
+	unsigned long npages = slot->npages;
 	int i, r;
 
 	/*
@@ -11733,8 +11733,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 				   enum kvm_mr_change change)
 {
 	if (change == KVM_MR_CREATE || change == KVM_MR_MOVE)
-		return kvm_alloc_memslot_metadata(kvm, new,
-						  mem->memory_size >> PAGE_SHIFT);
+		return kvm_alloc_memslot_metadata(kvm, new);
 
 	if (change == KVM_MR_FLAGS_ONLY)
 		memcpy(&new->arch, &old->arch, sizeof(old->arch));
-- 
2.33.1.1089.g2158813163f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
