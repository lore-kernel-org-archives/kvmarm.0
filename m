Return-Path: <SRS0=vcVD=7Y=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1369AC433DF
	for <kvmarm@archiver.kernel.org>; Thu, 11 Jun 2020 07:22:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BE6D92075F
	for <kvmarm@archiver.kernel.org>; Thu, 11 Jun 2020 07:22:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="kTsXOfwb"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BE6D92075F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 33FC94B1A5;
	Thu, 11 Jun 2020 03:22:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RG7FEejgSPV3; Thu, 11 Jun 2020 03:22:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9AD9C4B1EB;
	Thu, 11 Jun 2020 03:22:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2DD064B1C6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Jun 2020 18:12:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 95i11o3FdKxO for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Jun 2020 18:12:16 -0400 (EDT)
Received: from mail-vs1-f68.google.com (mail-vs1-f68.google.com
 [209.85.217.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1CA374B1C5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Jun 2020 18:12:16 -0400 (EDT)
Received: by mail-vs1-f68.google.com with SMTP id o2so2278600vsr.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Jun 2020 15:12:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=8ql4vRpj/ZWF0M5dCwe9+ml5aQlV0lcOnQe3sK6ypzM=;
 b=kTsXOfwbXO1Uvm6+8Wf5L/fmhgemJhOoPbGZtDXyP56sRmOUE+HA356ytHrF/MlXkQ
 r+1fTsody5otxHns0nzVjZjMeQJj9WoPKXg0BPcii5S2Vq1Ayu70wHvn3U6G6RqrQBvC
 jSu1p0ysxMxnJa2TzDGY4sLYXQnzRJLHj0xaUVf1zUO19aG6ujSzer2qXhNyA2X+cvfN
 QNZYptdgi9zoEJS5toP3hYFMkkzdyd1H8EpsMi509eCk6JMhMyTb06cU3CaECg/JVl6m
 tAYCYRdOo7EvNdkjSrQY9nVTNc4YUOIJmFbRZZ2waZnieyy4pcGkAdQQzGPlFugLlj6g
 3d7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=8ql4vRpj/ZWF0M5dCwe9+ml5aQlV0lcOnQe3sK6ypzM=;
 b=YID0z6OhgWYFvlKJ8yeQmV+VhdKlzcsvJTG94MjWgHv0EuyiM2eNx8zSKBbfMdgSd4
 GLloPkifDL11c/cZPfg2XwBo9D+QOgc4DU3+OsNs8qYNJWae5W2Bqx8s9PlECE8TzbJ+
 qPvWw8OiY1NNjR7cjt8AUrRkPdTEqvkqvd8cX8Lv0gmEij7WSGU2J9jbRX0MyqRwkClD
 nwUZLnn1IAuuz0G6kOZ0tKux4TWaBigEJ28yURXIx6kJL64L7JszT45SxwBLEt+Y+HyF
 Aefk/I8HKAefrgQOTGMNHCQHGgxjVwbvVbzlHf2iV0D+Tse3BjwVn1QedCt9AJx2DNAh
 d/hw==
X-Gm-Message-State: AOAM532tBACJkxhv3012cm12Fse3aIrHdUHlGAhGIX8sXMXTxkt9koJf
 V5V3t3IZCqRfjqlZl3QW6S9y6O3wGHBKuaie2Ph76Q==
X-Google-Smtp-Source: ABdhPJzdmghMx590xCu3q0oAa1Tiyl8Cd4txMWbr/Hdcmg3h07QCfUudu4lcAnLl2oYkxmlR4q6o6Uh/L8LMxNpv/bE=
X-Received: by 2002:a67:f982:: with SMTP id b2mr4434307vsq.202.1591827135387; 
 Wed, 10 Jun 2020 15:12:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200605213853.14959-1-sean.j.christopherson@intel.com>
 <20200605213853.14959-6-sean.j.christopherson@intel.com>
In-Reply-To: <20200605213853.14959-6-sean.j.christopherson@intel.com>
From: Ben Gardon <bgardon@google.com>
Date: Wed, 10 Jun 2020 15:12:04 -0700
Message-ID: <CANgfPd8B5R9NRL5q_4v4xvvn_3Vo9N93Ms3EiUFANMzqAMedMw@mail.gmail.com>
Subject: Re: [PATCH 05/21] KVM: x86/mmu: Try to avoid crashing KVM if a MMU
 memory cache is empty
To: Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailman-Approved-At: Thu, 11 Jun 2020 03:22:32 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 kvmarm@lists.cs.columbia.edu, Janosch Frank <frankja@linux.ibm.com>,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Junaid Shahid <junaids@google.com>, kvm-ppc@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Cornelia Huck <cohuck@redhat.com>, Peter Shier <pshier@google.com>,
 linux-mips@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, Peter Feiner <pfeiner@google.com>
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

On Fri, Jun 5, 2020 at 2:39 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> Attempt to allocate a new object instead of crashing KVM (and likely the
> kernel) if a memory cache is unexpectedly empty.  Use GFP_ATOMIC for the
> allocation as the caches are used while holding mmu_lock.  The immediate
> BUG_ON() makes the code unnecessarily explosive and led to confusing
> minimums being used in the past, e.g. allocating 4 objects where 1 would
> suffice.
>
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
Is an atomic allocation really necessary here? In most cases, when
topping up the memory cache we are handing a guest page fault. This
bug could also be removed by returning null if unable to allocate from
the cache, and then re-trying the page fault in that case. I don't
know if this is necessary to handle other, non-x86 architectures more
easily, but I worry this could cause some unpleasantness if combined
with some other bug or the host was in a low memory situation and then
this consumed the atomic pool. Perhaps this is a moot point since we
log a warning and consider the atomic allocation something of an
error.
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
