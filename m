Return-Path: <SRS0=u6p1=NB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3E67C4338F
	for <kvmarm@archiver.kernel.org>; Tue, 10 Aug 2021 04:44:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4A46A60EBD
	for <kvmarm@archiver.kernel.org>; Tue, 10 Aug 2021 04:44:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4A46A60EBD
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B794849F92;
	Tue, 10 Aug 2021 00:44:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9nZisMccIqwI; Tue, 10 Aug 2021 00:43:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C19294A003;
	Tue, 10 Aug 2021 00:43:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B18C49FA6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Aug 2021 00:43:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZCEll9AmgKIT for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 Aug 2021 00:43:57 -0400 (EDT)
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com
 [209.85.210.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E25FB49F92
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Aug 2021 00:43:56 -0400 (EDT)
Received: by mail-ot1-f51.google.com with SMTP id
 v24-20020a0568300918b02904f3d10c9742so17337669ott.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 Aug 2021 21:43:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=6hIn+VGKvusb6b7sO/wOtxTZw8L+KXVHNSnzIuHc/pE=;
 b=fgUKRrd2ALAqp5eIVnbfIwegrCVM7UjXuYYeKg5JzYTFO4yhEuZxKBoFf7/CaFqO2g
 fmMPKFH/FgKPJ8Qqm2BtlpJYOGpNpvk1mZNllYN8c7Js8i2Tm6Lg+uvTnKrYNh/bxUme
 vVTnmf0YmJbbVqIzNWsVCfTOGcBLcuJ4DwMObX00w4mzouCFATn769zSycJneHKNqg9B
 xx13ceImQW+CWfxFxvvyKTp/rLwqXKSSr79URSVZkSL7f1CVpdHDOLTFbtkJaTq22Ukr
 u6oWkTp8+8VJ0BKoQm0GgwWWpvHcXvUtSZ8diIP5DvfP2tPgd4r5Y46eYZkF2r6L79+x
 I/QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=6hIn+VGKvusb6b7sO/wOtxTZw8L+KXVHNSnzIuHc/pE=;
 b=TU76M5dGgtPEjRFl/jZDEaakA/rtt1syHuJLngsTS8g2FUXg8FzBsTWATXhn+gTGLl
 TMMr9yYIynz3BFlXkLIJaywztxGFLVnRrwFgQNmH7nhN9r+DxUwOIsfIsjH3+tc0sUAA
 ED7CqvM0BQcIPoUXrw0q4NY8kmisw9eFtQYp1PNpYmw51rm3MUd7qp54aNXiqRAsY3gF
 1fgm1XifMz438/1RvPGxdq2DHLbsN3C5Ghm030c/9ygF60GYKfKJNByp+mq8ICTcgk4z
 GLvw9XIiAMnOv4B3xmuFDW6p6SkMreHRDN8eoUSehMPpzscu5ZLhCd5betkF0yfPJ/CE
 F4rQ==
X-Gm-Message-State: AOAM530YfrKUnyKNLbvthQoV86Tm0VwpsdxCmuY3JQzAj+vm1HB7FMYn
 gmh4sFMLOMQnL1TFnQcitHzEmHVbe1Bq0GmsCMO66A==
X-Google-Smtp-Source: ABdhPJzOF1Ld2lX/FTRPRpblwYqA+D2k2EFUDV3ETiQrYV+LzoFPd9b9VW+kK9Hds3CzrO0et0cLy6KDLuUHG0ywX4c=
X-Received: by 2002:a9d:7359:: with SMTP id l25mr993791otk.52.1628570636085;
 Mon, 09 Aug 2021 21:43:56 -0700 (PDT)
MIME-Version: 1.0
References: <20210809152448.1810400-1-qperret@google.com>
 <20210809152448.1810400-21-qperret@google.com>
In-Reply-To: <20210809152448.1810400-21-qperret@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 10 Aug 2021 06:43:20 +0200
Message-ID: <CA+EHjTwZX2m1LwUyrh9vxnhh5GYRJOcQnmKQHXg9B+uNTdYp1Q@mail.gmail.com>
Subject: Re: [PATCH v4 20/21] KVM: arm64: Restrict EL2 stage-1 changes in
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

On Mon, Aug 9, 2021 at 5:25 PM Quentin Perret <qperret@google.com> wrote:
>
> The host kernel is currently able to change EL2 stage-1 mappings without
> restrictions thanks to the __pkvm_create_mappings() hypercall. But in a
> world where the host is no longer part of the TCB, this clearly poses a
> problem.
>
> To fix this, introduce a new hypercall to allow the host to share a
> physical memory page with the hypervisor, and remove the
> __pkvm_create_mappings() variant. The new hypercall implements
> ownership and permission checks before allowing the sharing operation,
> and it annotates the shared page in the hypervisor stage-1 and host
> stage-2 page-tables.
>
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---

Reviewed-by: Fuad Tabba <tabba@google.com>

Thanks,
/fuad

>  arch/arm64/include/asm/kvm_asm.h              |  2 +-
>  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  1 +
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c            | 11 +--
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 88 +++++++++++++++++++
>  arch/arm64/kvm/mmu.c                          | 28 +++++-
>  5 files changed, 118 insertions(+), 12 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> index 432a9ea1f02e..aed2aa61766a 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -59,7 +59,7 @@
>  #define __KVM_HOST_SMCCC_FUNC___vgic_v3_save_aprs              13
>  #define __KVM_HOST_SMCCC_FUNC___vgic_v3_restore_aprs           14
>  #define __KVM_HOST_SMCCC_FUNC___pkvm_init                      15
> -#define __KVM_HOST_SMCCC_FUNC___pkvm_create_mappings           16
> +#define __KVM_HOST_SMCCC_FUNC___pkvm_host_share_hyp            16
>  #define __KVM_HOST_SMCCC_FUNC___pkvm_create_private_mapping    17
>  #define __KVM_HOST_SMCCC_FUNC___pkvm_cpu_set_vector            18
>  #define __KVM_HOST_SMCCC_FUNC___pkvm_prot_finalize             19
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> index 0118527b07b0..03e604f842e2 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> @@ -49,6 +49,7 @@ extern struct host_kvm host_kvm;
>  extern const u8 pkvm_hyp_id;
>
>  int __pkvm_prot_finalize(void);
> +int __pkvm_host_share_hyp(u64 pfn);
>
>  bool addr_is_memory(phys_addr_t phys);
>  int host_stage2_idmap_locked(phys_addr_t addr, u64 size, enum kvm_pgtable_prot prot);
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> index 7900d5b66ba3..2da6aa8da868 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -140,14 +140,11 @@ static void handle___pkvm_cpu_set_vector(struct kvm_cpu_context *host_ctxt)
>         cpu_reg(host_ctxt, 1) = pkvm_cpu_set_vector(slot);
>  }
>
> -static void handle___pkvm_create_mappings(struct kvm_cpu_context *host_ctxt)
> +static void handle___pkvm_host_share_hyp(struct kvm_cpu_context *host_ctxt)
>  {
> -       DECLARE_REG(unsigned long, start, host_ctxt, 1);
> -       DECLARE_REG(unsigned long, size, host_ctxt, 2);
> -       DECLARE_REG(unsigned long, phys, host_ctxt, 3);
> -       DECLARE_REG(enum kvm_pgtable_prot, prot, host_ctxt, 4);
> +       DECLARE_REG(u64, pfn, host_ctxt, 1);
>
> -       cpu_reg(host_ctxt, 1) = __pkvm_create_mappings(start, size, phys, prot);
> +       cpu_reg(host_ctxt, 1) = __pkvm_host_share_hyp(pfn);
>  }
>
>  static void handle___pkvm_create_private_mapping(struct kvm_cpu_context *host_ctxt)
> @@ -185,7 +182,7 @@ static const hcall_t host_hcall[] = {
>         HANDLE_FUNC(__vgic_v3_restore_aprs),
>         HANDLE_FUNC(__pkvm_init),
>         HANDLE_FUNC(__pkvm_cpu_set_vector),
> -       HANDLE_FUNC(__pkvm_create_mappings),
> +       HANDLE_FUNC(__pkvm_host_share_hyp),
>         HANDLE_FUNC(__pkvm_create_private_mapping),
>         HANDLE_FUNC(__pkvm_prot_finalize),
>  };
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index 2991dc6996b9..8165390d3ec9 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -339,6 +339,94 @@ static int host_stage2_idmap(u64 addr)
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
> +       int ret;
> +
> +       if (!addr_is_memory(addr))
> +               return -EINVAL;
> +
> +       hyp_spin_lock(&host_kvm.lock);
> +       hyp_spin_lock(&pkvm_pgd_lock);
> +
> +       ret = kvm_pgtable_get_leaf(&host_kvm.pgt, addr, &pte, NULL);
> +       if (ret)
> +               goto unlock;
> +       if (!pte)
> +               goto map_shared;
> +
> +       /*
> +        * Check attributes in the host stage-2 PTE. We need the page to be:
> +        *  - mapped RWX as we're sharing memory;
> +        *  - not borrowed, as that implies absence of ownership.
> +        * Otherwise, we can't let it got through
> +        */
> +       cur = kvm_pgtable_stage2_pte_prot(pte);
> +       prot = pkvm_mkstate(0, PKVM_PAGE_SHARED_BORROWED);
> +       if (!check_prot(cur, PKVM_HOST_MEM_PROT, prot)) {
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
> +       ret = kvm_pgtable_get_leaf(&pkvm_pgtable, (u64)virt, &pte, NULL);
> +       if (ret)
> +               goto unlock;
> +
> +       /*
> +        * If the page has been shared with the hypervisor, it must be
> +        * already mapped as SHARED_BORROWED in its stage-1.
> +        */
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
> +       prot = pkvm_mkstate(PKVM_HOST_MEM_PROT, PKVM_PAGE_SHARED_OWNED);
> +       ret = host_stage2_idmap_locked(addr, PAGE_SIZE, prot);
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
> 2.32.0.605.g8dce9f2422-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
