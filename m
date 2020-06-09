Return-Path: <SRS0=Dlxa=7X=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05748C433DF
	for <kvmarm@archiver.kernel.org>; Wed, 10 Jun 2020 11:20:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6FB94204EA
	for <kvmarm@archiver.kernel.org>; Wed, 10 Jun 2020 11:20:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="YQTUSvv3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6FB94204EA
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C05204B2AF;
	Wed, 10 Jun 2020 07:20:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id saTo+FFwWRyU; Wed, 10 Jun 2020 07:20:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A645F4B2C5;
	Wed, 10 Jun 2020 07:20:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6DC824B167
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Jun 2020 17:07:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iLrJVz2wLe7s for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Jun 2020 17:07:13 -0400 (EDT)
Received: from mail-ua1-f67.google.com (mail-ua1-f67.google.com
 [209.85.222.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 42C714B11B
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Jun 2020 17:07:13 -0400 (EDT)
Received: by mail-ua1-f67.google.com with SMTP id r9so115558ual.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 09 Jun 2020 14:07:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=f15ThlgRIs3s50AvF0kFQ8PMHdAjHFT357oOtlUx/ug=;
 b=YQTUSvv3PxEEhj5ujE/dPySButOyH55bK4Xn7FFJQPplWJdwV27lg1hiiGZPMl+Csy
 utkQv6pOjG6DMuuUAn6OW8rUDsTwDk+L09wjyrOsEHgSM9DO1jG+4DXrAkvtnH7+VocI
 GJeE84ALY1lEBJxLNfWmnbxI8H4dKWQGgYe6NIzbLwEX92BP0BVccbN5ywjf+ad2hItV
 hOK3koJ698Vs9caFgU0Oz67/J789jH+4rxh31hXP0eWCQ0G50xlrah8Vhcbhoz+wsVGG
 RvWp/Z6BsjYqNpoy5p5CsKAw38VlYjZy47xgAAr8XRHehyo5E50oaLRajAfxViZwx+CC
 YVIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=f15ThlgRIs3s50AvF0kFQ8PMHdAjHFT357oOtlUx/ug=;
 b=S1N7ezajPUoGTTl0tOG53WhhrPrFRk2mqNBuAQ/2lMta2xS55xSCA9vO9/uaXz7lDs
 lKpHfJM5rHuiC7Oa2pUPIgzbhflO3D1MbXO2s4zq9MOuzIol/jQExtKxz1E0uk9z4Glf
 fCjVgb5myApwvkY3Uu1p/7uj/1YsU0/TfM0zG266EtMxugtaiph/09kpOxZXdJPrP5EC
 WM9UYEm9NQcJekT8VrWhA/1ZLEoxHFT9JC6GqgZoS90KuLtqrDp1DTXGGg2+s+hRraCP
 xMcRFCkc0edm2bbUwvyftuCccEghcFJCpWmsAt8pcezGZIonSk+BxUclUX8tETV+6ynT
 Qbmw==
X-Gm-Message-State: AOAM532WXg5D6elGKCic9PiLLy2gMeHVxc90udU4H6+G3/sZXE3BS7W1
 38Oyqi2r+AATOkeYYOCPmiCThZQgu0tKgmfsu5pCHA==
X-Google-Smtp-Source: ABdhPJwQ+viuUyt4Xvfz0B/F5q8uWrpKqo6vNNs2uM0NepreAFEA0QuoyJVSJ76WQkzVbDy0sso7BcdwlZvUGeg7c1M=
X-Received: by 2002:ab0:6012:: with SMTP id j18mr260224ual.69.1591736832385;
 Tue, 09 Jun 2020 14:07:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200605213853.14959-1-sean.j.christopherson@intel.com>
 <20200605213853.14959-2-sean.j.christopherson@intel.com>
In-Reply-To: <20200605213853.14959-2-sean.j.christopherson@intel.com>
From: Ben Gardon <bgardon@google.com>
Date: Tue, 9 Jun 2020 14:07:01 -0700
Message-ID: <CANgfPd87=eS6h=GX6CxZRwAj=MTET-AtVAjVQn4i1zkwZ4ApXw@mail.gmail.com>
Subject: Re: [PATCH 01/21] KVM: x86/mmu: Track the associated kmem_cache in
 the MMU caches
To: Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailman-Approved-At: Wed, 10 Jun 2020 07:20:46 -0400
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
> Track the kmem_cache used for non-page KVM MMU memory caches instead of
> passing in the associated kmem_cache when filling the cache.  This will
> allow consolidating code and other cleanups.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/mmu/mmu.c          | 24 +++++++++++-------------
>  2 files changed, 12 insertions(+), 13 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 1da5858501ca..16347b050754 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -251,6 +251,7 @@ struct kvm_kernel_irq_routing_entry;
>   */
>  struct kvm_mmu_memory_cache {
>         int nobjs;
> +       struct kmem_cache *kmem_cache;
>         void *objects[KVM_NR_MEM_OBJS];
>  };
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index fdd05c233308..0830c195c9ed 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1060,15 +1060,14 @@ static void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu)
>         local_irq_enable();
>  }
>
> -static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache,
> -                                 struct kmem_cache *base_cache, int min)
> +static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache, int min)
>  {
>         void *obj;
>
>         if (cache->nobjs >= min)
>                 return 0;
>         while (cache->nobjs < ARRAY_SIZE(cache->objects)) {
> -               obj = kmem_cache_zalloc(base_cache, GFP_KERNEL_ACCOUNT);
> +               obj = kmem_cache_zalloc(cache->kmem_cache, GFP_KERNEL_ACCOUNT);
>                 if (!obj)
>                         return cache->nobjs >= min ? 0 : -ENOMEM;
>                 cache->objects[cache->nobjs++] = obj;
> @@ -1081,11 +1080,10 @@ static int mmu_memory_cache_free_objects(struct kvm_mmu_memory_cache *cache)
>         return cache->nobjs;
>  }
>
> -static void mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc,
> -                                 struct kmem_cache *cache)
> +static void mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc)
>  {
>         while (mc->nobjs)
> -               kmem_cache_free(cache, mc->objects[--mc->nobjs]);
> +               kmem_cache_free(mc->kmem_cache, mc->objects[--mc->nobjs]);
>  }
>
>  static int mmu_topup_memory_cache_page(struct kvm_mmu_memory_cache *cache,
> @@ -1115,25 +1113,22 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu)
>         int r;
>
>         r = mmu_topup_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache,
> -                                  pte_list_desc_cache, 8 + PTE_PREFETCH_NUM);
> +                                  8 + PTE_PREFETCH_NUM);
>         if (r)
>                 goto out;
>         r = mmu_topup_memory_cache_page(&vcpu->arch.mmu_page_cache, 8);
>         if (r)
>                 goto out;
> -       r = mmu_topup_memory_cache(&vcpu->arch.mmu_page_header_cache,
> -                                  mmu_page_header_cache, 4);
> +       r = mmu_topup_memory_cache(&vcpu->arch.mmu_page_header_cache, 4);
>  out:
>         return r;
>  }
>
>  static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
>  {
> -       mmu_free_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache,
> -                               pte_list_desc_cache);
> +       mmu_free_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache);
>         mmu_free_memory_cache_page(&vcpu->arch.mmu_page_cache);
> -       mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache,
> -                               mmu_page_header_cache);
> +       mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache);
>  }
>
>  static void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
> @@ -5684,6 +5679,9 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
>         uint i;
>         int ret;
>
> +       vcpu->arch.mmu_pte_list_desc_cache.kmem_cache = pte_list_desc_cache;
> +       vcpu->arch.mmu_page_header_cache.kmem_cache = mmu_page_header_cache;
> +
>         vcpu->arch.mmu = &vcpu->arch.root_mmu;
>         vcpu->arch.walk_mmu = &vcpu->arch.root_mmu;
>
> --
> 2.26.0
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
