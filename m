Return-Path: <SRS0=cLfN=AF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EF48C433DF
	for <kvmarm@archiver.kernel.org>; Wed, 24 Jun 2020 20:01:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A043D206C0
	for <kvmarm@archiver.kernel.org>; Wed, 24 Jun 2020 20:01:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="NIvLFzPd"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A043D206C0
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B219A4B380;
	Wed, 24 Jun 2020 16:01:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id D-pS77+FDpOx; Wed, 24 Jun 2020 16:01:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E25274B381;
	Wed, 24 Jun 2020 16:01:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BAD104B2F1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Jun 2020 14:03:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wGWgQV6uvDRZ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Jun 2020 14:03:44 -0400 (EDT)
Received: from mail-vs1-f65.google.com (mail-vs1-f65.google.com
 [209.85.217.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BE08A4B2D2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Jun 2020 14:03:44 -0400 (EDT)
Received: by mail-vs1-f65.google.com with SMTP id r5so1904840vso.11
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Jun 2020 11:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=1afIoMWdCnvusBXYOP0bLDijIEbS3RXa7POt+hB0Fw4=;
 b=NIvLFzPdL7brFmgZZkBrbdWRKXdLJFpTc5UrQsQv36JzAjt5rgikCgbvE3QMUKnGnE
 XmscnvcyB6kOBbwAB9EM3UKYCChDSNkbHupnPDtPxvQl4G9Pkjeos5Bm8DytaGshVhkI
 Wo0SjMea+tb5BRtArI4g7vOejKn3Bk1LWCfvYE35MNxDHJcERtqloa5n2CZ1SrIIx8bm
 YK/AkO1/4Hy6i2WGMLXiglHFykEwg6EQOGtIIgxX031RuNUNxq2xMB2ksEDoenn8Y8bU
 iD9NiUMhdvwEe//mgBzdOdNd/Ms7sdzY4jUCZ6n8jQuF1Ki0JZ+lDgl+XLDRN7uvlvHF
 RwjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=1afIoMWdCnvusBXYOP0bLDijIEbS3RXa7POt+hB0Fw4=;
 b=HU22h6lvmzGCdiJGmCuRvEafX0rz0UkLIQk6Z5qKL/GBLAH0ipLUL1NXRM76tmAfMU
 IutGaVNmKtUYlgU8EJKkPJS4jNm66xYZDACY2VO7Uxv+IpXz1RlorGkjS3aMC6WyVif0
 7AihdS0KDuh9IHuNCJ7+B42vBiDXG1134Cu0q66PiFFjktkMvwzDDaVqRzrNprS7rHyU
 vvvteRMlbfgmTF0LFq9pJCfPzx7dl2F4BB9IvK73EA9PmHEQpqOd3d0q4W7L9Qwwfx4g
 ApuMQZdLjM853JkALrKTs7fT92M02/ahcDRR/XziuGDpWEArAXf5mPKxabE82PjyOI0Y
 SaFg==
X-Gm-Message-State: AOAM531c7h4hC1j/7TOah1ar78B2TkVZGbjKgY1YYF/NULUgxiP31zDE
 f4MENxhcozmMEf2oxApdHZamX48pECi55vQQ6NBRZg==
X-Google-Smtp-Source: ABdhPJyROW49kmTunW4kDbGXG/w9lVbn8C5Y1zvlBdo1nQXevJIjGNe/9OCUS4ZCNkHdvkWYXzv5+RUYU0APu1AbpCE=
X-Received: by 2002:a67:f785:: with SMTP id j5mr2788080vso.17.1593021823822;
 Wed, 24 Jun 2020 11:03:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200622200822.4426-1-sean.j.christopherson@intel.com>
 <20200622200822.4426-6-sean.j.christopherson@intel.com>
In-Reply-To: <20200622200822.4426-6-sean.j.christopherson@intel.com>
From: Ben Gardon <bgardon@google.com>
Date: Wed, 24 Jun 2020 11:03:32 -0700
Message-ID: <CANgfPd8gYX1Fm1vEcfnEBXn_MjRxLHdgQAS=TAHQiOMNMrhFGA@mail.gmail.com>
Subject: Re: [PATCH v2 05/21] KVM: x86/mmu: Try to avoid crashing KVM if a MMU
 memory cache is empty
To: Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailman-Approved-At: Wed, 24 Jun 2020 16:01:47 -0400
Cc: linux-arch@vger.kernel.org, Junaid Shahid <junaids@google.com>,
 Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Peter Shier <pshier@google.com>,
 linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, Peter Feiner <pfeiner@google.com>,
 kvmarm@lists.cs.columbia.edu, Jim Mattson <jmattson@google.com>
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

On Mon, Jun 22, 2020 at 1:09 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> Attempt to allocate a new object instead of crashing KVM (and likely the
> kernel) if a memory cache is unexpectedly empty.  Use GFP_ATOMIC for the
> allocation as the caches are used while holding mmu_lock.  The immediate
> BUG_ON() makes the code unnecessarily explosive and led to confusing
> minimums being used in the past, e.g. allocating 4 objects where 1 would
> suffice.
>
Reviewed-by: Ben Gardon <bgardon@google.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 21 +++++++++++++++------
>  1 file changed, 15 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index ba70de24a5b0..5e773564ab20 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1060,6 +1060,15 @@ static void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu)
>         local_irq_enable();
>  }
>
> +static inline void *mmu_memory_cache_alloc_obj(struct kvm_mmu_memory_cache *mc,
> +                                              gfp_t gfp_flags)
> +{
> +       if (mc->kmem_cache)
> +               return kmem_cache_zalloc(mc->kmem_cache, gfp_flags);
> +       else
> +               return (void *)__get_free_page(gfp_flags);
> +}
> +
>  static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
>  {
>         void *obj;
> @@ -1067,10 +1076,7 @@ static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
>         if (mc->nobjs >= min)
>                 return 0;
>         while (mc->nobjs < ARRAY_SIZE(mc->objects)) {
> -               if (mc->kmem_cache)
> -                       obj = kmem_cache_zalloc(mc->kmem_cache, GFP_KERNEL_ACCOUNT);
> -               else
> -                       obj = (void *)__get_free_page(GFP_KERNEL_ACCOUNT);
> +               obj = mmu_memory_cache_alloc_obj(mc, GFP_KERNEL_ACCOUNT);
>                 if (!obj)
>                         return mc->nobjs >= min ? 0 : -ENOMEM;
>                 mc->objects[mc->nobjs++] = obj;
> @@ -1118,8 +1124,11 @@ static void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
>  {
>         void *p;
>
> -       BUG_ON(!mc->nobjs);
> -       p = mc->objects[--mc->nobjs];
> +       if (WARN_ON(!mc->nobjs))
> +               p = mmu_memory_cache_alloc_obj(mc, GFP_ATOMIC | __GFP_ACCOUNT);
> +       else
> +               p = mc->objects[--mc->nobjs];
> +       BUG_ON(!p);
>         return p;
>  }
>
> --
> 2.26.0
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
