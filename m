Return-Path: <SRS0=oZIB=PX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25F5BC433FE
	for <kvmarm@archiver.kernel.org>; Thu,  4 Nov 2021 00:26:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C68CA611CA
	for <kvmarm@archiver.kernel.org>; Thu,  4 Nov 2021 00:26:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C68CA611CA
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 77E6A4B131;
	Wed,  3 Nov 2021 20:26:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tqA5Jup84c0a; Wed,  3 Nov 2021 20:26:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 975844B159;
	Wed,  3 Nov 2021 20:26:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6ADA84B0C2
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 20:26:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YNKORXnMZPRT for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Nov 2021 20:26:15 -0400 (EDT)
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com
 [209.85.215.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E5CE94B16E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 20:26:14 -0400 (EDT)
Received: by mail-pg1-f201.google.com with SMTP id
 w13-20020a63934d000000b002a2935891daso2363369pgm.15
 for <kvmarm@lists.cs.columbia.edu>; Wed, 03 Nov 2021 17:26:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=8x8y6LCkLptxfKHX5+pDaTNp73wBECOiN1YdxqMK+rA=;
 b=Kwf8l4ALLidbOCnsA8IZb7EGVbQY2I/GyIc70v/xPgAN2uNZmJzzLzZJfwAX2uOOCO
 bOK9U8USa/+T5EGJ5WM+xo1wGM21VgQud3S9i76kNITLTzwA0wNdnUr/fJDAgqhSvhap
 Yw0ASqeY//wjIN0mhEQ3qwyRthBADSpw3C4ZFZ4+KorPOGjjv9GHHalj2Z0JVLcN7rKX
 1aJXnhddEMDTeyAz0wqrWJZzkxWK24hOVug2NjMIF6/CfNf9YTCoQnGyCXWnO5Qwes4j
 g5HbrauvOLkXEcvWsWbG0nodw7IIljy/H4UiUpBEQUah5lbLSlwy7/6wMiTLEuWxciTS
 tAtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=8x8y6LCkLptxfKHX5+pDaTNp73wBECOiN1YdxqMK+rA=;
 b=Ng3oSMNHITe8efR3aYdmBtMhhLFoPmSBV4GJoHjLx2VVh31+BSIQsLnqJRXncwTs9y
 +T35oT1MQ7hvJSqpO/o4uN4IlNIprKb3oSJzqytOa4qBlluTC4AO/0GDI3P3e7/xpc/c
 yYHdnzuaHe11BMtUJ2JgTq0NoIV6RHWCatn8rV95rPP2GHy/dLw2fgtRBj5VuwToYFcZ
 HYH2tw1dyvLz8I23jPSQ+z1l1Q0VIG3M2SrVPQ3eTSpoJMSRkdn4DoxKaIndaOvgq616
 lUo8Spkc5CznYz0riMZMnbmXT5QW09GPcJS2XHTUSX+FgB4/zJTEHl/1J0oAt3vNymvw
 7tgw==
X-Gm-Message-State: AOAM533nGes/156QOdz3AITLdlMsy57x28po9R+JzYmfhHRh1ARIESUp
 KFpdam+MMOJI7W62gFVWgkE6w8MVlBA=
X-Google-Smtp-Source: ABdhPJxsJ29Wj32AtuAm6joDY8iQebT4Rnu7/phTa+MfeSdX22KfADwkK1eYIPGppvLFyQSyOgzQ6GfE4Fg=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:5285:: with SMTP id
 w5mr261308pjh.1.1635985573544; Wed, 03 Nov 2021 17:26:13 -0700 (PDT)
Date: Thu,  4 Nov 2021 00:25:10 +0000
In-Reply-To: <20211104002531.1176691-1-seanjc@google.com>
Message-Id: <20211104002531.1176691-10-seanjc@google.com>
Mime-Version: 1.0
References: <20211104002531.1176691-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH v5.5 09/30] KVM: MIPS: Drop pr_debug from memslot commit to
 avoid using "mem"
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

Remove an old (circa 2012) kvm_debug from kvm_arch_commit_memory_region()
to print basic information when committing a memslot change.  The primary
motivation for removing the kvm_debug is to avoid using @mem, the user
memory region, so that said param can be removed.

Alternatively, the debug message could be converted to use @new, but that
would require synthesizing select state to play nice with the DELETED
case, which will pass NULL for @new in the future.  And there's no
argument to be had for dumping generic information in an arch callback,
i.e. if there's a good reason for the debug message, then it belongs in
common KVM code where all architectures can benefit.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/mips/kvm/mips.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index 8c94cd4093af..b7aa8fa4a5fb 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -249,10 +249,6 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 {
 	int needs_flush;
 
-	kvm_debug("%s: kvm: %p slot: %d, GPA: %llx, size: %llx, QVA: %llx\n",
-		  __func__, kvm, mem->slot, mem->guest_phys_addr,
-		  mem->memory_size, mem->userspace_addr);
-
 	/*
 	 * If dirty page logging is enabled, write protect all pages in the slot
 	 * ready for dirty logging.
-- 
2.33.1.1089.g2158813163f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
