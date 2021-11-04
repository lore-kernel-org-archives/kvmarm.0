Return-Path: <SRS0=oZIB=PX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50C38C433EF
	for <kvmarm@archiver.kernel.org>; Thu,  4 Nov 2021 00:26:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F3DAA611C8
	for <kvmarm@archiver.kernel.org>; Thu,  4 Nov 2021 00:26:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org F3DAA611C8
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FD304A3A5;
	Wed,  3 Nov 2021 20:26:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yHezbJtpiMdQ; Wed,  3 Nov 2021 20:26:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 016544B178;
	Wed,  3 Nov 2021 20:26:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F7684B1B6
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 20:26:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oyD28AgZdTjm for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Nov 2021 20:26:32 -0400 (EDT)
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com
 [209.85.210.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E9BAB4B0C2
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 20:26:31 -0400 (EDT)
Received: by mail-pf1-f201.google.com with SMTP id
 a84-20020a621a57000000b00480fcb384a7so2318870pfa.20
 for <kvmarm@lists.cs.columbia.edu>; Wed, 03 Nov 2021 17:26:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=uYjj4f3K7aLt9wIaWKUjF6y1lKdICOYwfejCWHB3aF8=;
 b=Uhm3v8WNND1uUP79qkh3iF9ngMS/QpmsXEC/6vevUuzviyfyF3+tSzE2rdmLrNYnov
 ivEPHlTaSTgUBPTTi0LsyRVmw9xXp2mzAafjmpRwoFL1KovVk8wtgK3U+1IWl+jiRT2o
 7QOXBMeLcoMyFIuk8nfYq8Z4cK4ySxLX4VQvCwivT4uBC8D1531XJeoZcVX+WcQdgv/2
 15XpbR3gJyAolfjM0WcGNgJS3ceK1iyuvg9S+WhHGJq+B2HdNn7lGmW8IZ2NF2RpaP0n
 2NlCasOBpN6Ngo/ODMi6fT9lbV6fzIJZALi7PZVoZsnpUFpAWoSzDGNfxoR0u+D8gkJP
 KhsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=uYjj4f3K7aLt9wIaWKUjF6y1lKdICOYwfejCWHB3aF8=;
 b=XotWmPZ+6kG0PdOSdXxeLw/w4qI5xoiu3/wmgDFQz1CP596lC4D9TOdi1XGj1Ndz98
 Q0Bd1s2TT+MXoU/J/dro74XX1SYh/EiB+bkwzLoDz4X8pmv9VUfPy11p0IRM+kj4I6R0
 dZGPFGK/QZqFzAkBYV9nCaj5iHm1UKS9YJI9QNb+cze68VJ9DL324yMqk6eJtNCdLSlH
 SnqT1xOYa3hSbGYl5R2uhBbnKuJOOMPjcv9Ti3BGAYZ2qmX/m3kxKikQ0d2QbTFIB88s
 qV27P8wCygK4I5IoaI7IATbOy3EqveT5fS18EpKdrbAqG9ni6OCRy0SF5lmbaqaiQ2Uv
 XsfA==
X-Gm-Message-State: AOAM53385YvqC8DgbLPhJR21Cr3yW0KSg6+5LApx1HDQkeZca5I0T8pP
 ppZwABKVaHpdbrMleeKZKr+iQ1pEwVY=
X-Google-Smtp-Source: ABdhPJyzJUVQ4+X7UL4YhSp9RCZBPi0XLOQZSFtg0LZxrgaDfXLCgqmWWI3ojjh232hTQrMrLyr2UsSbIBM=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1511:b0:492:61fe:9fa6
 with SMTP id
 q17-20020a056a00151100b0049261fe9fa6mr9114017pfu.57.1635985590891; Wed, 03
 Nov 2021 17:26:30 -0700 (PDT)
Date: Thu,  4 Nov 2021 00:25:20 +0000
In-Reply-To: <20211104002531.1176691-1-seanjc@google.com>
Message-Id: <20211104002531.1176691-20-seanjc@google.com>
Mime-Version: 1.0
References: <20211104002531.1176691-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH v5.5 19/30] KVM: x86: Don't call kvm_mmu_change_mmu_pages() if
 the count hasn't changed
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

There is no point in calling kvm_mmu_change_mmu_pages() for memslot
operations that don't change the total page count, so do it just for
KVM_MR_CREATE and KVM_MR_DELETE.

Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 80183f7eadeb..4b0cb7390902 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11836,7 +11836,8 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 				const struct kvm_memory_slot *new,
 				enum kvm_mr_change change)
 {
-	if (!kvm->arch.n_requested_mmu_pages)
+	if (!kvm->arch.n_requested_mmu_pages &&
+	    (change == KVM_MR_CREATE || change == KVM_MR_DELETE))
 		kvm_mmu_change_mmu_pages(kvm,
 				kvm_mmu_calculate_default_mmu_pages(kvm));
 
-- 
2.33.1.1089.g2158813163f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
