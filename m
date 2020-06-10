Return-Path: <SRS0=Dlxa=7X=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93A6AC433DF
	for <kvmarm@archiver.kernel.org>; Wed, 10 Jun 2020 19:40:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4B7C7206F7
	for <kvmarm@archiver.kernel.org>; Wed, 10 Jun 2020 19:40:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="Zt0ORjDT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4B7C7206F7
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 075D24B21B;
	Wed, 10 Jun 2020 15:40:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uL2+yRlrAX1q; Wed, 10 Jun 2020 15:40:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D4B54B1A9;
	Wed, 10 Jun 2020 15:40:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E52AA4B168
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Jun 2020 14:56:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4IM9Jz98xBF1 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Jun 2020 14:56:26 -0400 (EDT)
Received: from mail-vk1-f195.google.com (mail-vk1-f195.google.com
 [209.85.221.195])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BD3BB4B0E6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Jun 2020 14:56:26 -0400 (EDT)
Received: by mail-vk1-f195.google.com with SMTP id m23so861724vko.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Jun 2020 11:56:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=7eIpW1TrmjAjBk7KQrsYXoot8/oGn/0TG+dydExJy2w=;
 b=Zt0ORjDTOU4A4Z/iXipnwo1pC3JnqzSsmd5ypTkLOgKENLJmgdAk/ogZdaBrXeKm4G
 kDu+D/hjyT0rpS0gzIsFvo44p5bZGjGsJFvu2tjNW6qm7SZqMENiXuvOqnYibPGwN+1C
 QKQVWcJhGYrCDUOb1ifJ4mL1wa3UBhO4+AcKgl714BEONvkSxYjHpjLEOPxoHRErzeYA
 cDMc97eLeC7E19+RflCNmm/O27QJT802Ym6aPwq4UFRBDd5iSHVrpDJQs1/sfU10UWto
 PO8itFSobsR5+z94ReeJIINHtdccWBoSIRGorciVbvXEgDEpCuRfWrVssLkYdce1lUgI
 xinw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=7eIpW1TrmjAjBk7KQrsYXoot8/oGn/0TG+dydExJy2w=;
 b=E3BBv4tgVmgYmgfQqpNAp5rIWHkndmPDvgvmu0bmiDn4/LdptpTSnca+7QtOC3RlsO
 AyGTDfV+YsxJ4q5NfnFU+jfijBJjHokv0vp42k/3r3FGyZDcKZTmxtf88K/UWTTRhXwA
 glNoj8Nvdc9ksEc+R7nUGYDLInRjLkP6u+JjWXp+x6F418PA7tCt13MzvKLXg7cyAEpH
 UOPiRbu5FagB9QrkmNtgfRTiEuCK1QIA7IEEtJOxDm6eFiVOArNPWY1nJqozMETmFwt6
 bil58BFzQ9GjHVKcvzm2ZYtfLinC3IWAX2nqytbP0ip1BlhqXXWRgRyOUz7RLKqbF/AM
 7+Aw==
X-Gm-Message-State: AOAM531cATp51C7dyq6kq5lZplQ6rfHI1FSRsCnfFI5G1+RfEzNimAJr
 gjBEl3MAsv7YxXdLBYLXQaM5EPK0n5NQTndxSEOF2A==
X-Google-Smtp-Source: ABdhPJzTz3+TLBOLxyJarRjMGjCxCEXEcgNWvchhSDXNpIW/g1/IZl7i88fZ2VTc/j4GkNMODoBhJOAYiSGYjIJjENg=
X-Received: by 2002:a1f:b647:: with SMTP id g68mr2478062vkf.76.1591815385955; 
 Wed, 10 Jun 2020 11:56:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200605213853.14959-1-sean.j.christopherson@intel.com>
 <20200605213853.14959-14-sean.j.christopherson@intel.com>
In-Reply-To: <20200605213853.14959-14-sean.j.christopherson@intel.com>
From: Ben Gardon <bgardon@google.com>
Date: Wed, 10 Jun 2020 11:56:14 -0700
Message-ID: <CANgfPd_YFfE_97W0y2d5dZo1CVgYAc=K3ADDz3azda42P+Ek=A@mail.gmail.com>
Subject: Re: [PATCH 13/21] KVM: x86/mmu: Prepend "kvm_" to memory cache
 helpers that will be global
To: Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailman-Approved-At: Wed, 10 Jun 2020 15:40:12 -0400
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
> Rename the memory helpers that will soon be moved to common code and be
> made globaly available via linux/kvm_host.h.  "mmu" alone is not a
> sufficient namespace for globally available KVM symbols.
>
> Opportunistically add "nr_" in mmu_memory_cache_free_objects() to make
> it clear the function returns the number of free objects, as opposed to
> freeing existing objects.
>
> Suggested-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 42 +++++++++++++++++++++---------------------
>  1 file changed, 21 insertions(+), 21 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 8d66cf558f1b..b85d3e8e8403 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1071,7 +1071,7 @@ static inline void *mmu_memory_cache_alloc_obj(struct kvm_mmu_memory_cache *mc,
>                 return (void *)__get_free_page(gfp_flags);
>  }
>
> -static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
> +static int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
>  {
>         void *obj;
>
> @@ -1086,12 +1086,12 @@ static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
>         return 0;
>  }
>
> -static int mmu_memory_cache_free_objects(struct kvm_mmu_memory_cache *mc)
> +static int kvm_mmu_memory_cache_nr_free_objects(struct kvm_mmu_memory_cache *mc)
>  {
>         return mc->nobjs;
>  }
>
> -static void mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc)
> +static void kvm_mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc)
>  {
>         while (mc->nobjs) {
>                 if (mc->kmem_cache)
> @@ -1106,33 +1106,33 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
>         int r;
>
>         /* 1 rmap, 1 parent PTE per level, and the prefetched rmaps. */
> -       r = mmu_topup_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache,
> -                                  1 + PT64_ROOT_MAX_LEVEL + PTE_PREFETCH_NUM);
> +       r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache,
> +                                      1 + PT64_ROOT_MAX_LEVEL + PTE_PREFETCH_NUM);
>         if (r)
>                 return r;
> -       r = mmu_topup_memory_cache(&vcpu->arch.mmu_shadow_page_cache,
> -                                  PT64_ROOT_MAX_LEVEL);
> +       r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_shadow_page_cache,
> +                                      PT64_ROOT_MAX_LEVEL);
>         if (r)
>                 return r;
>         if (maybe_indirect) {
> -               r = mmu_topup_memory_cache(&vcpu->arch.mmu_gfn_array_cache,
> -                                          PT64_ROOT_MAX_LEVEL);
> +               r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_gfn_array_cache,
> +                                              PT64_ROOT_MAX_LEVEL);
>                 if (r)
>                         return r;
>         }
> -       return mmu_topup_memory_cache(&vcpu->arch.mmu_page_header_cache,
> -                                     PT64_ROOT_MAX_LEVEL);
> +       return kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_page_header_cache,
> +                                         PT64_ROOT_MAX_LEVEL);
>  }
>
>  static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
>  {
> -       mmu_free_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache);
> -       mmu_free_memory_cache(&vcpu->arch.mmu_shadow_page_cache);
> -       mmu_free_memory_cache(&vcpu->arch.mmu_gfn_array_cache);
> -       mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache);
> +       kvm_mmu_free_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache);
> +       kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadow_page_cache);
> +       kvm_mmu_free_memory_cache(&vcpu->arch.mmu_gfn_array_cache);
> +       kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache);
>  }
>
> -static void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
> +static void *kvm_mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
>  {
>         void *p;
>
> @@ -1146,7 +1146,7 @@ static void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
>
>  static struct pte_list_desc *mmu_alloc_pte_list_desc(struct kvm_vcpu *vcpu)
>  {
> -       return mmu_memory_cache_alloc(&vcpu->arch.mmu_pte_list_desc_cache);
> +       return kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_pte_list_desc_cache);
>  }
>
>  static void mmu_free_pte_list_desc(struct pte_list_desc *pte_list_desc)
> @@ -1417,7 +1417,7 @@ static bool rmap_can_add(struct kvm_vcpu *vcpu)
>         struct kvm_mmu_memory_cache *mc;
>
>         mc = &vcpu->arch.mmu_pte_list_desc_cache;
> -       return mmu_memory_cache_free_objects(mc);
> +       return kvm_mmu_memory_cache_nr_free_objects(mc);
>  }
>
>  static int rmap_add(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
> @@ -2104,10 +2104,10 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, int direct
>  {
>         struct kvm_mmu_page *sp;
>
> -       sp = mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
> -       sp->spt = mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
> +       sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
> +       sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
>         if (!direct)
> -               sp->gfns = mmu_memory_cache_alloc(&vcpu->arch.mmu_gfn_array_cache);
> +               sp->gfns = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_gfn_array_cache);
>         set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
>
>         /*
> --
> 2.26.0
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
