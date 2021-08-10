Return-Path: <SRS0=u6p1=NB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A310C432BE
	for <kvmarm@archiver.kernel.org>; Tue, 10 Aug 2021 04:41:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C17AD60E78
	for <kvmarm@archiver.kernel.org>; Tue, 10 Aug 2021 04:41:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C17AD60E78
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 328D2405EE;
	Tue, 10 Aug 2021 00:41:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AW27EKoQzzKX; Tue, 10 Aug 2021 00:41:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 438A14075E;
	Tue, 10 Aug 2021 00:41:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B8CC94075E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Aug 2021 00:41:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3ppbU2QZpQPm for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 Aug 2021 00:41:32 -0400 (EDT)
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com
 [209.85.210.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 82EAC405EE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Aug 2021 00:41:32 -0400 (EDT)
Received: by mail-ot1-f53.google.com with SMTP id
 e13-20020a9d63cd0000b02904fa42f9d275so9797401otl.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 Aug 2021 21:41:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=3fI6+zpWNL9dvCk7s7yKEGMLw+f473R8fD+YQvZUssc=;
 b=S+9Be2ujBEjAO/Cvjx/UoNPdG/2jmG1oVR6I33Uq9jZ1NgAngrD/qybkdKuZbFIUru
 RmEH1sk6mPxKrWmER7c0s1VmWjpRpQn3gZDirUtMGP9Z0sNbj2JJID4ZFeYYPl5mkiRg
 C1nTSfkVtHFUjt5iL4chObDwqYID6tRYm2xdP2xEV254TTd/RC2Uh/XN8iGScwrt3R8G
 3e5gZVSoYOh2fgQ32mD7rEgV+ln4JAD+Vq1nRWnUCkl4UvFZOCgOB/SC07++0N2AKJ2y
 wwHtMe2M2zIibmu5h2lhnoiUWlqjjGpV5pv2iLIykt1zx2Mg2qAy7qWvJS7OuXpJD3Op
 S7aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=3fI6+zpWNL9dvCk7s7yKEGMLw+f473R8fD+YQvZUssc=;
 b=stCPp/vhUUJ/9ePKucYczp43/lbUNk25z7v9XQk1zQI9q1mmnLFc3FDI8kkP5id3Jy
 47KjxoR1VDeDSerIc2/gsonlmLy/2bCZBaAzy8bxRA2Fs9iwRIoXQzEORcrHO+4Af+xw
 +MMjST45ta92wWQcrIipAJpwG8e2c+1swt/in9dZoCn1GcD/K6mi5Cb8t7k8Z/5Y7OpK
 oCZPEm8Y9PPKygMY5PiA09xYuID6LyEgN37c0xehlzLJ2ysjU9LNjZZEgHhJ9reRwaKu
 vXrDFSMm0Zjv79f6rels0k7b5K2aDEVtQr4Mt+QZwQQJMAqQWU/WwvtjaTYKKxZ3SysD
 HOPQ==
X-Gm-Message-State: AOAM530t1215GHREPeNPf7rdz/wtHfLrZLYgnPbJ+kEfXC5jEI5z4xoj
 MS66+hkgVkCsWHr6LmpyvlM/sQgBnq1h0IF4+2FYYg==
X-Google-Smtp-Source: ABdhPJxKEk6fQCA2o1JXEptjeSlu9BoabMv4CVKRUJiXnXZ0Wgi0UVzPLAEc4ytF0a6GM96rp0y6yz6REwL92K31Ij8=
X-Received: by 2002:a9d:7359:: with SMTP id l25mr988748otk.52.1628570491801;
 Mon, 09 Aug 2021 21:41:31 -0700 (PDT)
MIME-Version: 1.0
References: <20210809152448.1810400-1-qperret@google.com>
 <20210809152448.1810400-18-qperret@google.com>
In-Reply-To: <20210809152448.1810400-18-qperret@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 10 Aug 2021 06:40:55 +0200
Message-ID: <CA+EHjTxM1QA30k4ZzajmQftZWtSR7QPVaSfVOMgpJH7GPHT+Fw@mail.gmail.com>
Subject: Re: [PATCH v4 17/21] KVM: arm64: Mark host bss and rodata section as
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

On Mon, Aug 9, 2021 at 5:25 PM Quentin Perret <qperret@google.com> wrote:
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

Reviewed-by: Fuad Tabba <tabba@google.com>

Thanks,
/fuad


>  arch/arm64/kvm/hyp/nvhe/setup.c | 82 +++++++++++++++++++++++++++++----
>  1 file changed, 74 insertions(+), 8 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
> index 0b574d106519..57c27846320f 100644
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
> +        * transfer the ownership from the host to the hypervisor itself to
> +        * make sure it can't be donated or shared with another entity.
> +        *
> +        * The ownership transition requires matching changes in the host
> +        * stage-2. This will be done later (see finalize_host_mappings()) once
> +        * the hyp_vmemmap is addressable.
> +        */
> +       prot = pkvm_mkstate(PAGE_HYP_RO, PKVM_PAGE_SHARED_OWNED);
> +       ret = pkvm_create_mappings(__start_rodata, __end_rodata, prot);
> +       if (ret)
> +               return ret;
> +
> +       ret = pkvm_create_mappings(__hyp_bss_end, __bss_stop, prot);
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
> +               return host_stage2_set_owner_locked(phys, PAGE_SIZE, pkvm_hyp_id);
> +       case PKVM_PAGE_SHARED_OWNED:
> +               prot = pkvm_mkstate(PKVM_HOST_MEM_PROT, PKVM_PAGE_SHARED_BORROWED);
> +               break;
> +       case PKVM_PAGE_SHARED_BORROWED:
> +               prot = pkvm_mkstate(PKVM_HOST_MEM_PROT, PKVM_PAGE_SHARED_OWNED);
> +               break;
> +       default:
> +               return -EINVAL;
> +       }
> +
> +       return host_stage2_idmap_locked(phys, PAGE_SIZE, prot);
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
> 2.32.0.605.g8dce9f2422-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
