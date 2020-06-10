Return-Path: <SRS0=vcVD=7Y=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A556EC433E0
	for <kvmarm@archiver.kernel.org>; Thu, 11 Jun 2020 07:22:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1CF6A2075F
	for <kvmarm@archiver.kernel.org>; Thu, 11 Jun 2020 07:22:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="c2GBWEym"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1CF6A2075F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 747214B1A2;
	Thu, 11 Jun 2020 03:22:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WpQxRGtbw-ox; Thu, 11 Jun 2020 03:22:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BA094B1CB;
	Thu, 11 Jun 2020 03:22:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 076B44B164
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Jun 2020 16:24:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kGdrsiPA63Uu for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Jun 2020 16:24:31 -0400 (EDT)
Received: from mail-ua1-f67.google.com (mail-ua1-f67.google.com
 [209.85.222.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BBDDE4B14E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Jun 2020 16:24:31 -0400 (EDT)
Received: by mail-ua1-f67.google.com with SMTP id v6so1324882uam.10
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Jun 2020 13:24:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=OYjqAVwtvPl7Y3hFy8cg2FHFUeVaZTx/znZrNTcOHyg=;
 b=c2GBWEymOyDmHxxDIPkNDniIbX3TqlOV7Ry9nkanRvVCrSn2NMJ1GnwEfVB5/R50jP
 77Rjx/4tfzv/21jbJwgXQWYHRcGohQXCaWO3gsp+nHajYQM5boFPucGIPLgfHX2MDKZ9
 +OTXs9o5nIuxF0NxV+MOUmd1vMtcj2kdrDNZSP44fW4w0h/heaF22VAQQKgm2rqnMc6V
 NJb+uAZ7l7pOtCuqjyYuB03gXscyCe3TL+JYrlC+kUJVKogfkmlGDaS6Z3tJZHdjtIyR
 8GoO1sGjzYWFt6lmc/+nI7dUOUzM6fyQMlG2J8rvlAJmgx36NdSbKub1xcaNcasqobbn
 Zo8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=OYjqAVwtvPl7Y3hFy8cg2FHFUeVaZTx/znZrNTcOHyg=;
 b=gYxBH4bR0+iP9epIjgLnAzQ8Cfljc7UrlEH7Ri3WQtlOtEcI/a+o5Mhi6s0/cCQIJf
 a3N15SPxquUVVjRnd7dxX1hNv6RyM6pKN9+82eJUbsP51099lYKHlLq2Ye46BF9PCpHZ
 svGJTLVM0IeyF8mOb/ThyaVtFrFJ4V1OHmukBWWvO9+tMwMTqgcX6vzjJ0VhFdX0rrMx
 PMk064cKv7YzIDJOP3chmzn6HD3sW9fE4tB5zVJrKegj1XbDEb33Bxjt9JHp8Y1eM+jj
 dJirppd4IcStexQKQespcl0WpT9IEB9DoR6xFxGdYdFzV9msQ6asJ24N8aYtviaRtJ+X
 gC+w==
X-Gm-Message-State: AOAM532f0g/Bw9l26JcqSGNC8AaN6bEfnP/uDk4j3T3VRQrw2QmTbNrE
 HSZP9lb+wA9LgeGlCr37tS3dPl3eL+HMTV4/3slb0w==
X-Google-Smtp-Source: ABdhPJzuDO175rlKEOjx+cUrssRUoDydSEqe6opXAVLnE5jRaJ0s7w5Cvs20/NG/qvzCO9X/JYv7sNtKVyijp2/LQvA=
X-Received: by 2002:ab0:5642:: with SMTP id z2mr4013044uaa.6.1591820670801;
 Wed, 10 Jun 2020 13:24:30 -0700 (PDT)
MIME-Version: 1.0
References: <20200605213853.14959-1-sean.j.christopherson@intel.com>
 <20200605213853.14959-16-sean.j.christopherson@intel.com>
In-Reply-To: <20200605213853.14959-16-sean.j.christopherson@intel.com>
From: Ben Gardon <bgardon@google.com>
Date: Wed, 10 Jun 2020 13:24:18 -0700
Message-ID: <CANgfPd_oGhO4dpkejhzh1PaAc-0U068kVdoHj4_fiQveW8yXLg@mail.gmail.com>
Subject: Re: [PATCH 15/21] KVM: Move x86's MMU memory cache helpers to common
 KVM code
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
> Move x86's memory cache helpers to common KVM code so that they can be
> reused by arm64 and MIPS in future patches.
>
> Suggested-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c   | 53 --------------------------------------
>  include/linux/kvm_host.h |  7 +++++
>  virt/kvm/kvm_main.c      | 55 ++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 62 insertions(+), 53 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index b85d3e8e8403..a627437f73fd 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1060,47 +1060,6 @@ static void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu)
>         local_irq_enable();
>  }
>
> -static inline void *mmu_memory_cache_alloc_obj(struct kvm_mmu_memory_cache *mc,
> -                                              gfp_t gfp_flags)
> -{
> -       gfp_flags |= mc->gfp_zero;
> -
> -       if (mc->kmem_cache)
> -               return kmem_cache_alloc(mc->kmem_cache, gfp_flags);
> -       else
> -               return (void *)__get_free_page(gfp_flags);
> -}
> -
> -static int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
> -{
> -       void *obj;
> -
> -       if (mc->nobjs >= min)
> -               return 0;
> -       while (mc->nobjs < ARRAY_SIZE(mc->objects)) {
> -               obj = mmu_memory_cache_alloc_obj(mc, GFP_KERNEL_ACCOUNT);
> -               if (!obj)
> -                       return mc->nobjs >= min ? 0 : -ENOMEM;
> -               mc->objects[mc->nobjs++] = obj;
> -       }
> -       return 0;
> -}
> -
> -static int kvm_mmu_memory_cache_nr_free_objects(struct kvm_mmu_memory_cache *mc)
> -{
> -       return mc->nobjs;
> -}
> -
> -static void kvm_mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc)
> -{
> -       while (mc->nobjs) {
> -               if (mc->kmem_cache)
> -                       kmem_cache_free(mc->kmem_cache, mc->objects[--mc->nobjs]);
> -               else
> -                       free_page((unsigned long)mc->objects[--mc->nobjs]);
> -       }
> -}
> -
>  static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
>  {
>         int r;
> @@ -1132,18 +1091,6 @@ static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
>         kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache);
>  }
>
> -static void *kvm_mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
> -{
> -       void *p;
> -
> -       if (WARN_ON(!mc->nobjs))
> -               p = mmu_memory_cache_alloc_obj(mc, GFP_ATOMIC | __GFP_ACCOUNT);
> -       else
> -               p = mc->objects[--mc->nobjs];
> -       BUG_ON(!p);
> -       return p;
> -}
> -
>  static struct pte_list_desc *mmu_alloc_pte_list_desc(struct kvm_vcpu *vcpu)
>  {
>         return kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_pte_list_desc_cache);
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index d38d6b9c24be..802b9e2306f0 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -815,6 +815,13 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *vcpu, bool usermode_vcpu_not_eligible);
>  void kvm_flush_remote_tlbs(struct kvm *kvm);
>  void kvm_reload_remote_mmus(struct kvm *kvm);
>
> +#ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
> +int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min);
> +int kvm_mmu_memory_cache_nr_free_objects(struct kvm_mmu_memory_cache *mc);
> +void kvm_mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc);
> +void *kvm_mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
> +#endif
> +
>  bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
>                                  struct kvm_vcpu *except,
>                                  unsigned long *vcpu_bitmap, cpumask_var_t tmp);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 4db151f6101e..fead5f1d5594 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -342,6 +342,61 @@ void kvm_reload_remote_mmus(struct kvm *kvm)
>         kvm_make_all_cpus_request(kvm, KVM_REQ_MMU_RELOAD);
>  }
>
> +#ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
> +static inline void *mmu_memory_cache_alloc_obj(struct kvm_mmu_memory_cache *mc,
> +                                              gfp_t gfp_flags)
> +{
> +       gfp_flags |= mc->gfp_zero;
> +
> +       if (mc->kmem_cache)
> +               return kmem_cache_alloc(mc->kmem_cache, gfp_flags);
> +       else
> +               return (void *)__get_free_page(gfp_flags);
> +}
> +
> +int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
> +{
> +       void *obj;
> +
> +       if (mc->nobjs >= min)
> +               return 0;
> +       while (mc->nobjs < ARRAY_SIZE(mc->objects)) {
> +               obj = mmu_memory_cache_alloc_obj(mc, GFP_KERNEL_ACCOUNT);
> +               if (!obj)
> +                       return mc->nobjs >= min ? 0 : -ENOMEM;
> +               mc->objects[mc->nobjs++] = obj;
> +       }
> +       return 0;
> +}
> +
> +int kvm_mmu_memory_cache_nr_free_objects(struct kvm_mmu_memory_cache *mc)
> +{
> +       return mc->nobjs;
> +}
> +
> +void kvm_mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc)
> +{
> +       while (mc->nobjs) {
> +               if (mc->kmem_cache)
> +                       kmem_cache_free(mc->kmem_cache, mc->objects[--mc->nobjs]);
> +               else
> +                       free_page((unsigned long)mc->objects[--mc->nobjs]);
> +       }
> +}
> +
> +void *kvm_mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
> +{
> +       void *p;
> +
> +       if (WARN_ON(!mc->nobjs))
> +               p = mmu_memory_cache_alloc_obj(mc, GFP_ATOMIC | __GFP_ACCOUNT);
> +       else
> +               p = mc->objects[--mc->nobjs];
> +       BUG_ON(!p);
> +       return p;
> +}
> +#endif
> +
>  static void kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
>  {
>         mutex_init(&vcpu->mutex);
> --
> 2.26.0
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
