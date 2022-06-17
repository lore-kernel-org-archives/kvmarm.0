Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4313EC433EF
	for <kvmarm@archiver.kernel.org>; Fri, 17 Jun 2022 18:35:08 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 87E1A4B368;
	Fri, 17 Jun 2022 14:35:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CEPfCL7Jx5Un; Fri, 17 Jun 2022 14:35:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 737974B35E;
	Fri, 17 Jun 2022 14:35:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 735BF4B354
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jun 2022 14:35:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SiFiqinSIElT for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Jun 2022 14:35:04 -0400 (EDT)
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com
 [209.85.210.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 637244B249
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jun 2022 14:35:04 -0400 (EDT)
Received: by mail-pf1-f182.google.com with SMTP id x138so4826395pfc.12
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jun 2022 11:35:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=wn5PJvZjayRGTgY0EL7zo+ZpkVBIhnd1vf/XBJfv398=;
 b=XUjHAkComAsH676GvMGE8tfx7jPYVHXd49eunVKrZupRS34+He9Ne0Gtm/unj7Uqyl
 ykdip2LZH2YlJjdHgomgqFc1Zio2za04RCEQEox9FQRzHqZ9we1ib3s5M1DhJyFZa9MB
 nnl5RiYodqPM9NTNq+MB76c62ZV49AUKSUk5uIlwYA7OxXm0KgOM2nJwnHg5npdpCC8F
 H8M1+Ofb3zHl5174PCWBppRvNiI2V22LzZfKWhFLP7bQKF4az2k7MvbZx4421pwNr9Xr
 v6vIoBdyVQZiyzfWn+jGiAPVJ7cHZf608mZ+JbqR3zUZHJ5W6IPaR1ljg1lxpVqRMVHS
 JzRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=wn5PJvZjayRGTgY0EL7zo+ZpkVBIhnd1vf/XBJfv398=;
 b=2gYCzGjk1BHHR4FNHkNd+B9lhAjmhvjmEtvrlKCyW+m8O6KF4akPO2jpw5BG2FXv+i
 gjl3mwJgBofgY/1XZV5BTa6NYcN9yw5pPy42+fSq+tHGLr2+R94vTqUk1YYEaWHyEAv5
 BKU5r31et8F9J/AmEe6snCfwjpf9i9HwHQE9+sm48AH5K8RI91Bq9l2fcdUNEyn/kCab
 iiSAS/g5YBwZrzbICuhqxaL5WrhFyha+tiFb6Sl6NtyKSET69TtCPPhruR44PXzw93y+
 QXKMdI+ODiE1x2rQFnJd1rgdAt5F9Mf1II4AgWuTapMleeTT3QiBV/pKCB53VxXzumX0
 2VWA==
X-Gm-Message-State: AJIora+psYPA/NqEkcazzqBoTnUsCOc0B1fi0qZcD3Eo4UywWx2oKpGv
 mpP9fv5ScIpnKxtT6RvjDvuYWg==
X-Google-Smtp-Source: AGRyM1spMY0SV+af/bWX4jYu0RNeMMMehRL+RlWnsxhf3BAN02q9XVjNqdlG9AaqqAiCUkeYx2Fagw==
X-Received: by 2002:a05:6a00:218c:b0:51c:c64:3f6a with SMTP id
 h12-20020a056a00218c00b0051c0c643f6amr11135128pfi.50.1655490903050; 
 Fri, 17 Jun 2022 11:35:03 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com.
 [35.230.65.123]) by smtp.gmail.com with ESMTPSA id
 g8-20020a62f948000000b0051b8e7765edsm4014810pfm.67.2022.06.17.11.35.02
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 17 Jun 2022 11:35:02 -0700 (PDT)
Date: Fri, 17 Jun 2022 18:34:59 +0000
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v6 21/22] KVM: Allow for different capacities in
 kvm_mmu_memory_cache structs
Message-ID: <YqzJUxrW67vACltI@google.com>
References: <20220516232138.1783324-1-dmatlack@google.com>
 <20220516232138.1783324-22-dmatlack@google.com>
 <Yqy84GkGAdE1BzI6@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Yqy84GkGAdE1BzI6@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Albert Ou <aou@eecs.berkeley.edu>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <kvm@vger.kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 Lai Jiangshan <jiangshanlai@gmail.com>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <linux-mips@vger.kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 "open list:KERNEL VIRTUAL MACHINE FOR RISC-V \(KVM/riscv\)"
 <kvm-riscv@lists.infradead.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Ben Gardon <bgardon@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 maciej.szmigiero@oracle.com,
 "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>, Peter Feiner <pfeiner@google.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
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

On Fri, Jun 17, 2022, Sean Christopherson wrote:
> On Mon, May 16, 2022, David Matlack wrote:
> > -int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
> > +static int __kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int capacity, int min)
> 
> I still find it somewhat kludgy to have callers provide an capacity.  It's not
> terrible while there's only a single call site, but if a use case comes along
> for using an oversized cache with multiple call sites, it'll be gross.
> 
> Tweaking my idea of a "custom" wrapper, what about adding an "oversized" wrapper?
> That yields clear, firm rules on when to use each helper, guards against calling
> the "standard" flavor with an impossible @min, and addresses Mingwei's concern
> that a misguided user could specify a nonsensically small capacity.

Drat, arguing against my own idea.

The future usage in nested_mmu_try_split_huge_page() is going to be inefficient.
By having capacity==min, consuming just one entry, which is guaranteed when a
huge page split is successful, will mean the cache needs to be topped up.  In other
words, I'm pretty sure need_topup_split_caches_or_resched() will always return
true between different huge pages and so KVM will drop mmu_lock and reschedule
after every huge page.  Maybe that's not a big deal, but at the very least it's
odd, and its a nasty gotcha with forcing capacity==min.

So I'm ok with this patch, though it should yell if min > capacity.

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 932abb4fb67e..14e807501229 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -388,7 +388,7 @@ int __kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int capacity,
                return 0;

        if (unlikely(!mc->objects)) {
-               if (WARN_ON_ONCE(!capacity))
+               if (WARN_ON_ONCE(!capacity || min > capacity))
                        return -EIO;

                mc->objects = kvmalloc_array(sizeof(void *), capacity, gfp);
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
