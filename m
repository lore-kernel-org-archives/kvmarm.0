Return-Path: <SRS0=p2dm=M2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B30FC4320A
	for <kvmarm@archiver.kernel.org>; Tue,  3 Aug 2021 05:03:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0991261029
	for <kvmarm@archiver.kernel.org>; Tue,  3 Aug 2021 05:03:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0991261029
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 59F5A49FE6;
	Tue,  3 Aug 2021 01:03:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fxIXTDa2iBQK; Tue,  3 Aug 2021 01:03:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3FD5B40856;
	Tue,  3 Aug 2021 01:03:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7ACD940856
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Aug 2021 01:03:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KGPIgpZVqgyH for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 Aug 2021 01:03:19 -0400 (EDT)
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com
 [209.85.210.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3AA4C40642
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Aug 2021 01:03:19 -0400 (EDT)
Received: by mail-ot1-f47.google.com with SMTP id
 61-20020a9d0d430000b02903eabfc221a9so19700634oti.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 Aug 2021 22:03:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=98m49kM51gXXQwk6EzBddK2TZzu06e6NOrKKSkFgLXM=;
 b=JBfRN5uUGJv1mXH50K1CUMtDQM796k7tGX2Ggs3sEatCxVZhKBAtXSgvWVQYe793T+
 003e95gjoA3OzMjjHFsMb0rlP1AnnVwDbrdL87tbbPt4M3Tgv6pd1Oi3uu4AawLHtTt/
 LfxpBm0bd/2e42IQOKMsrniKeY7x4/1DBISSuyzW/bYl3ihzEtBnZWhjjr+fB7XKS2tL
 C0sjEML/9uy5Fou5GMaLDw+ItaHpAdsWgNmzppUMP2hoLnwzQT+exRn1U90Mr6Qt0d77
 II3+ILcfc6/Ht8xDPjvcu4IWmoDcutECmD9qPd8SjUofuZuMpfo8LMghTHZJxYCQ27xh
 ymkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=98m49kM51gXXQwk6EzBddK2TZzu06e6NOrKKSkFgLXM=;
 b=iJFGMMoiGSZ/2fgBEsxNaCmrvHcA+N8hOzLu0gfeWMVFEjAwADT98FrIlr+TAgS+LY
 CygLHo9MKToUsHvW/TQ9lOyIoQseVdoxXM4go6MzTVqmawilUxs1hp5VNceC82BDWodg
 MfkcN9jE8ohhMA3k7Mdp0R1JlL+R3j/GLnTSinqewFHGzTCt8roIUQc+3RWpgl5Gfbxw
 Pj6lJnlGqoLxBMzKdOOiC8XN5MnbGVB6lAGqyA+As6tbXEFFmwkxlCyqmBhmTCMQG8HT
 VUlIKSJ1WMqGP5xkFFGF2twkci95e61CLT7xMndUu1SLWAdzMqRL4nEnxSwQrIlIgMrO
 Whug==
X-Gm-Message-State: AOAM5310W7pIMxNjNr3yFCGTQl8Ay34LyBK70UzGhkb2WYcrRW6L9Ryx
 GquLAMEVcejyEFBFWYbNyJL7PZrXupXJ4r9QU25OsQ==
X-Google-Smtp-Source: ABdhPJxUZ3uaAUbN+2nQwNL5VyZUDFvbxFFeJtlu36GNKbf5VdioZ67EaWSYprJBEZoIRbrNocdm8Hwh3Z7MWKDhLCw=
X-Received: by 2002:a9d:202d:: with SMTP id n42mr474563ota.52.1627966998377;
 Mon, 02 Aug 2021 22:03:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210729132818.4091769-1-qperret@google.com>
 <20210729132818.4091769-18-qperret@google.com>
In-Reply-To: <20210729132818.4091769-18-qperret@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 3 Aug 2021 07:02:42 +0200
Message-ID: <CA+EHjTwfsA8Z+_dJzqjsBXJ_SSC55Bcxc6HQ_Q4OJDrqmk0Unw@mail.gmail.com>
Subject: Re: [PATCH v3 17/21] KVM: arm64: Mark host bss and rodata section as
 shared
To: Quentin Perret <qperret@google.com>
Cc: kernel-team@android.com, qwandor@google.com, maz@kernel.org,
 linux-kernel@vger.kernel.org, catalin.marinas@arm.com, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Hi Quentin,

On Thu, Jul 29, 2021 at 3:29 PM Quentin Perret <qperret@google.com> wrote:
>
> As the hypervisor maps the host's .bss and .rodata sections in its
> stage-1, make sure to tag them as shared in hyp and host page-tables.
>
> But since the hypervisor relies on the presence of these mappings, we
> cannot let the host in complete control of the memory regions -- it
> must not unshare or donate them to another entity for example. To
> prevent this, let's transfer the ownership of those ranges to the
> hypervisor itself, and share the pages back with the host.
>
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/setup.c | 82 +++++++++++++++++++++++++++++----
>  1 file changed, 74 insertions(+), 8 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
> index 0b574d106519..7f557b264f62 100644
> --- a/arch/arm64/kvm/hyp/nvhe/setup.c
> +++ b/arch/arm64/kvm/hyp/nvhe/setup.c
> @@ -58,6 +58,7 @@ static int recreate_hyp_mappings(phys_addr_t phys, unsigned long size,
>  {
>         void *start, *end, *virt = hyp_phys_to_virt(phys);
>         unsigned long pgt_size = hyp_s1_pgtable_pages() << PAGE_SHIFT;
> +       enum kvm_pgtable_prot prot;
>         int ret, i;
>
>         /* Recreate the hyp page-table using the early page allocator */
> @@ -83,10 +84,6 @@ static int recreate_hyp_mappings(phys_addr_t phys, unsigned long size,
>         if (ret)
>                 return ret;
>
> -       ret = pkvm_create_mappings(__start_rodata, __end_rodata, PAGE_HYP_RO);
> -       if (ret)
> -               return ret;
> -
>         ret = pkvm_create_mappings(__hyp_rodata_start, __hyp_rodata_end, PAGE_HYP_RO);
>         if (ret)
>                 return ret;
> @@ -95,10 +92,6 @@ static int recreate_hyp_mappings(phys_addr_t phys, unsigned long size,
>         if (ret)
>                 return ret;
>
> -       ret = pkvm_create_mappings(__hyp_bss_end, __bss_stop, PAGE_HYP_RO);
> -       if (ret)
> -               return ret;
> -
>         ret = pkvm_create_mappings(virt, virt + size, PAGE_HYP);
>         if (ret)
>                 return ret;
> @@ -117,6 +110,24 @@ static int recreate_hyp_mappings(phys_addr_t phys, unsigned long size,
>                         return ret;
>         }
>
> +       /*
> +        * Map the host's .bss and .rodata sections RO in the hypervisor, but
> +        * transfer the ownerhsip from the host to the hypervisor itself to
> +        * make sure it can't be donated or shared with another entity.

nit: ownerhsip -> ownership

> +        *
> +        * The ownership transtion requires matching changes in the host

nit: transtion -> transition

> +        * stage-2. This will done later (see finalize_host_mappings()) once the

nit: will done -> will be done

> +        * hyp_vmemmap is addressable.
> +        */
> +       prot = pkvm_mkstate(PAGE_HYP_RO, PKVM_PAGE_SHARED_OWNED);
> +       ret = pkvm_create_mappings(__start_rodata, __end_rodata, prot);
> +       if (ret)
> +               return ret;
> +
> +       ret = pkvm_create_mappings(__hyp_bss_end, __bss_stop, prot);

nit: for clarity, I wonder if it might be good to create an alias of
__hyp_bss_end as __bss_start or something. When it's been moved here,
it sticks out a bit more and makes the reader wonder about the
significance of __hyp_bss_end.

> +       if (ret)
> +               return ret;
> +
>         return 0;
>  }
>
> @@ -148,6 +159,57 @@ static void hpool_put_page(void *addr)
>         hyp_put_page(&hpool, addr);
>  }
>
> +static int finalize_host_mappings_walker(u64 addr, u64 end, u32 level,
> +                                        kvm_pte_t *ptep,
> +                                        enum kvm_pgtable_walk_flags flag,
> +                                        void * const arg)
> +{
> +       enum kvm_pgtable_prot prot;
> +       enum pkvm_page_state state;
> +       kvm_pte_t pte = *ptep;
> +       phys_addr_t phys;
> +
> +       if (!kvm_pte_valid(pte))
> +               return 0;
> +
> +       if (level != (KVM_PGTABLE_MAX_LEVELS - 1))
> +               return -EINVAL;

I know that it's not in scope here, but I'm wondering whether we
should be checking for KVM_PTE_TYPE_PAGE instead of the level. Maybe
it would be good to have a helper somewhere for all these checks both
for clarity and to ensure that nothing has gone wrong with the pte.

> +
> +       phys = kvm_pte_to_phys(pte);
> +       if (!addr_is_memory(phys))
> +               return 0;
> +
> +       /*
> +        * Adjust the host stage-2 mappings to match the ownership attributes
> +        * configured in the hypervisor stage-1.
> +        */
> +       state = pkvm_getstate(kvm_pgtable_hyp_pte_prot(pte));
> +       switch (state) {
> +       case PKVM_PAGE_OWNED:
> +               return host_stage2_set_owner_locked(phys, phys + PAGE_SIZE, pkvm_hyp_id);
> +       case PKVM_PAGE_SHARED_OWNED:
> +               prot = pkvm_mkstate(KVM_PGTABLE_PROT_RWX, PKVM_PAGE_SHARED_BORROWED);
> +               break;
> +       case PKVM_PAGE_SHARED_BORROWED:
> +               prot = pkvm_mkstate(KVM_PGTABLE_PROT_RWX, PKVM_PAGE_SHARED_OWNED);
> +               break;
> +       default:
> +               return -EINVAL;
> +       }
> +
> +       return host_stage2_idmap_locked(phys, phys + PAGE_SIZE, prot);
> +}
> +
> +static int finalize_host_mappings(void)
> +{
> +       struct kvm_pgtable_walker walker = {
> +               .cb     = finalize_host_mappings_walker,
> +               .flags  = KVM_PGTABLE_WALK_LEAF,
> +       };
> +
> +       return kvm_pgtable_walk(&pkvm_pgtable, 0, BIT(pkvm_pgtable.ia_bits), &walker);
> +}
> +
>  void __noreturn __pkvm_init_finalise(void)
>  {
>         struct kvm_host_data *host_data = this_cpu_ptr(&kvm_host_data);
> @@ -167,6 +229,10 @@ void __noreturn __pkvm_init_finalise(void)
>         if (ret)
>                 goto out;
>
> +       ret = finalize_host_mappings();
> +       if (ret)
> +               goto out;
> +
>         pkvm_pgtable_mm_ops = (struct kvm_pgtable_mm_ops) {
>                 .zalloc_page = hyp_zalloc_hyp_page,
>                 .phys_to_virt = hyp_phys_to_virt,
> --
> 2.32.0.432.gabb21c7263-goog
>

Thanks,
/fuad
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
