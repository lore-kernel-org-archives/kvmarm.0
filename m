Return-Path: <SRS0=p2dm=M2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A22AC432BE
	for <kvmarm@archiver.kernel.org>; Tue,  3 Aug 2021 08:22:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9F7AC60EFF
	for <kvmarm@archiver.kernel.org>; Tue,  3 Aug 2021 08:22:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9F7AC60EFF
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1AEC6405D8;
	Tue,  3 Aug 2021 04:22:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id c4z+Z9qicL72; Tue,  3 Aug 2021 04:22:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BFA0A40CF9;
	Tue,  3 Aug 2021 04:22:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E018A4086D
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Aug 2021 04:22:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OIJ1zAw1t8O3 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 Aug 2021 04:22:40 -0400 (EDT)
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com
 [209.85.210.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A12BE405D8
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Aug 2021 04:22:40 -0400 (EDT)
Received: by mail-ot1-f41.google.com with SMTP id
 a5-20020a05683012c5b029036edcf8f9a6so20044466otq.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 03 Aug 2021 01:22:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=eMZBKtkn8NL1UPw8PxMyLJWcvvBS9uh79yjuZ1WcLtI=;
 b=QYoOqeb+fr6N1i0arfZM9cypT8Jjtw132LCw/SQ4Enct5klTvreF2njZsPUm/jMEZr
 i2aP589klgVgNONCsA4pFzUiZl2FzmgzOLldqA8CODVTFjimW7VbE/KSh7EBGeOmUH3c
 UF3E8hUxGq5xA49XMwniH+8/nUmAngZzH4Pn+pR8PflalRRAPjgkmhR2UJMjN9n5QerF
 VXsZe4hLIW64VFX8cIact9CLVL1w31inogvToJn6PC1h2ZKyGujDSwY+7LaLqQSLYQGk
 WgIBlyrFiPG83Ymn1giOQJrF9vg7fb0f4AIqNW0e/59L2mU3xK05Y9RKq4gZpAPKx9S4
 y2/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=eMZBKtkn8NL1UPw8PxMyLJWcvvBS9uh79yjuZ1WcLtI=;
 b=beHQs5y//g117Oq9FC35zlYFbsPW/Tcp3NNmEKvkWDzc02sbCj8qB3F/T2wcKVynoJ
 vq6LbkyvjSj4j5B8TGZLdt9OQAccmC8HQx5FFpN0PQBztUQg5Rb3k3euJjpTN6hO3G7j
 5+Gzl76X6JhijO1PTQK87lvI17mmjnGb+QW0CZgxsPJBMnK6wggxzn2XZHq3j25+5zSF
 Vo30yDayFsaImMI+Po54n79CBCVhjcVyrZGUKqkbed+fSZPPHvyH0gKCq2rwhfvRwRsk
 BvbWe3EpIDueWD7Nn0bWq+mLnimxUfkS8e6VPKKfh5ajtNUalMGvRJpAlyLAsZv1Mvx6
 udeA==
X-Gm-Message-State: AOAM531+Ylxhh5NqtL4AuoNlgYmzCZH36gktEJToy+xKukRWgQV0twa/
 S8jgNCQNK6tCNu2HzsUD8NQdH1lSnfQVTPMFIIJN3Q==
X-Google-Smtp-Source: ABdhPJwGOIzLQG5A+8rKyH9zldBHImB8OMSqb9kC1m1hpRZWt70/G2zZVShWKamYFCNWGJCc6MWwUl9Lwa1z7QGOQCA=
X-Received: by 2002:a9d:202d:: with SMTP id n42mr909666ota.52.1627978959752;
 Tue, 03 Aug 2021 01:22:39 -0700 (PDT)
MIME-Version: 1.0
References: <20210729132818.4091769-1-qperret@google.com>
 <20210729132818.4091769-21-qperret@google.com>
In-Reply-To: <20210729132818.4091769-21-qperret@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 3 Aug 2021 10:22:03 +0200
Message-ID: <CA+EHjTw7W=5JqH+oZAqLPrf_6222eazDnSk24h4EuGE1VLwKYg@mail.gmail.com>
Subject: Re: [PATCH v3 20/21] KVM: arm64: Restrict EL2 stage-1 changes in
 protected mode
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

> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index 0ccea58df7e0..1b67f562b6fc 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -338,6 +338,95 @@ static int host_stage2_idmap(u64 addr)
>         return ret;
>  }
>
> +static inline bool check_prot(enum kvm_pgtable_prot prot,
> +                             enum kvm_pgtable_prot required,
> +                             enum kvm_pgtable_prot denied)
> +{
> +       return (prot & (required | denied)) == required;
> +}
> +
> +int __pkvm_host_share_hyp(u64 pfn)
> +{
> +       phys_addr_t addr = hyp_pfn_to_phys(pfn);
> +       enum kvm_pgtable_prot prot, cur;
> +       void *virt = __hyp_va(addr);
> +       enum pkvm_page_state state;
> +       kvm_pte_t pte;
> +       u32 level;
> +       int ret;
> +
> +       if (!range_is_memory(addr, addr + PAGE_SIZE))
> +               return -EINVAL;
> +
> +       hyp_spin_lock(&host_kvm.lock);
> +       hyp_spin_lock(&pkvm_pgd_lock);
> +
> +       ret = kvm_pgtable_get_leaf(&host_kvm.pgt, addr, &pte, &level);
> +       if (ret)
> +               goto unlock;
> +       if (!pte)
> +               goto map_shared;

Should this check whether kvm_pte_valid as well, is that guaranteed to
always be the case, or implicitly handled later?

> +
> +       /*
> +        * Check attributes in the host stage-2 PTE. We need the page to be:
> +        *  - mapped RWX as we're sharing memory;
> +        *  - not borrowed, as that implies absence of ownership.
> +        * Otherwise, we can't let it got through
> +        */
> +       cur = kvm_pgtable_stage2_pte_prot(pte);
> +       prot = pkvm_mkstate(0, PKVM_PAGE_SHARED_BORROWED);
> +       if (!check_prot(cur, KVM_PGTABLE_PROT_RWX, prot)) {
> +               ret = -EPERM;
> +               goto unlock;
> +       }
> +
> +       state = pkvm_getstate(cur);
> +       if (state == PKVM_PAGE_OWNED)
> +               goto map_shared;
> +
> +       /*
> +        * Tolerate double-sharing the same page, but this requires
> +        * cross-checking the hypervisor stage-1.
> +        */
> +       if (state != PKVM_PAGE_SHARED_OWNED) {
> +               ret = -EPERM;
> +               goto unlock;
> +       }
> +
> +       ret = kvm_pgtable_get_leaf(&pkvm_pgtable, (u64)virt, &pte, &level);
> +       if (ret)
> +               goto unlock;
> +
> +       /*
> +        * If the page has been shared with the hypervisor, it must be
> +        * SHARED_BORROWED already.
> +        */

This comment confused me at first, but then I realized it's referring
to the page from the hyp's point of view. Could you add something to
the comment to that effect?

It might also make it easier to follow if the variables could be
annotated to specify whether cur, state, and prot are the host's or
hyps (and not reuse the same one for both).

> +       cur = kvm_pgtable_hyp_pte_prot(pte);
> +       prot = pkvm_mkstate(PAGE_HYP, PKVM_PAGE_SHARED_BORROWED);
> +       if (!check_prot(cur, prot, ~prot))
> +               ret = EPERM;
> +       goto unlock;
> +
> +map_shared:
> +       /*
> +        * If the page is not yet shared, adjust mappings in both page-tables
> +        * while both locks are held.
> +        */
> +       prot = pkvm_mkstate(PAGE_HYP, PKVM_PAGE_SHARED_BORROWED);
> +       ret = pkvm_create_mappings_locked(virt, virt + PAGE_SIZE, prot);
> +       BUG_ON(ret);
> +
> +       prot = pkvm_mkstate(KVM_PGTABLE_PROT_RWX, PKVM_PAGE_SHARED_OWNED);
> +       ret = host_stage2_idmap_locked(addr, addr + PAGE_SIZE, prot);
> +       BUG_ON(ret);
> +
> +unlock:
> +       hyp_spin_unlock(&pkvm_pgd_lock);
> +       hyp_spin_unlock(&host_kvm.lock);
> +
> +       return ret;
> +}
> +
>  void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt)
>  {
>         struct kvm_vcpu_fault_info fault;
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 0625bf2353c2..cbab146cda6a 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -259,10 +259,8 @@ static int __create_hyp_mappings(unsigned long start, unsigned long size,
>  {
>         int err;
>
> -       if (!kvm_host_owns_hyp_mappings()) {
> -               return kvm_call_hyp_nvhe(__pkvm_create_mappings,
> -                                        start, size, phys, prot);
> -       }
> +       if (WARN_ON(!kvm_host_owns_hyp_mappings()))
> +               return -EINVAL;
>
>         mutex_lock(&kvm_hyp_pgd_mutex);
>         err = kvm_pgtable_hyp_map(hyp_pgtable, start, size, phys, prot);
> @@ -282,6 +280,21 @@ static phys_addr_t kvm_kaddr_to_phys(void *kaddr)
>         }
>  }
>
> +static int pkvm_share_hyp(phys_addr_t start, phys_addr_t end)
> +{
> +       phys_addr_t addr;
> +       int ret;
> +
> +       for (addr = ALIGN_DOWN(start, PAGE_SIZE); addr < end; addr += PAGE_SIZE) {
> +               ret = kvm_call_hyp_nvhe(__pkvm_host_share_hyp,
> +                                       __phys_to_pfn(addr));

I guess we don't expect this to happen often, but I wonder if it would
be better to have the looping in the hyp call rather than here, to
reduce the number of hyp calls when sharing.

Thanks,
/fuad

> +               if (ret)
> +                       return ret;
> +       }
> +
> +       return 0;
> +}
> +
>  /**
>   * create_hyp_mappings - duplicate a kernel virtual address range in Hyp mode
>   * @from:      The virtual kernel start address of the range
> @@ -302,6 +315,13 @@ int create_hyp_mappings(void *from, void *to, enum kvm_pgtable_prot prot)
>         if (is_kernel_in_hyp_mode())
>                 return 0;
>
> +       if (!kvm_host_owns_hyp_mappings()) {
> +               if (WARN_ON(prot != PAGE_HYP))
> +                       return -EPERM;
> +               return pkvm_share_hyp(kvm_kaddr_to_phys(from),
> +                                     kvm_kaddr_to_phys(to));
> +       }
> +
>         start = start & PAGE_MASK;
>         end = PAGE_ALIGN(end);
>
> --
> 2.32.0.432.gabb21c7263-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
