Return-Path: <SRS0=A4hI=LM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84BD7C49EA2
	for <kvmarm@archiver.kernel.org>; Fri, 18 Jun 2021 09:30:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1FAB0613D6
	for <kvmarm@archiver.kernel.org>; Fri, 18 Jun 2021 09:30:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1FAB0613D6
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9415340821;
	Fri, 18 Jun 2021 05:30:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZfuKdqXCQOo5; Fri, 18 Jun 2021 05:30:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 511554A4A3;
	Fri, 18 Jun 2021 05:30:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A7A4040821
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jun 2021 05:30:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zPIjEKIXO-xz for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Jun 2021 05:30:17 -0400 (EDT)
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com
 [209.85.210.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6C0FF4A4A0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jun 2021 05:30:17 -0400 (EDT)
Received: by mail-ot1-f50.google.com with SMTP id
 h24-20020a9d64180000b029036edcf8f9a6so9097776otl.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jun 2021 02:30:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=77mzIJgsnd6fd7VLB24yLdWxFauCP3v4BC+3010BcoI=;
 b=splN4F0W2+ZYXW8DQ+07l5RKaruWT5ZPxUWsjzNl0oY2XTzTCR6O8vimbufSv6f3vL
 PdIdB2fFYw/cg01yOh2vFuNnt9hjIKDpyHEYO71Hc+iwk6TfEmRw0y9B3tIGcgXeHo+c
 N6E2cG8vYoY/4zV02vTQ1kqMVPzdus88HcTB+hxJIGCc1O6QG+R2p+toipCf9CjfkhKZ
 Ndy7h6uRN1EYXnhOI8K0E3syWmJGpVfs4IARtSp07Z4tMQ0TPasM2HPJs6pNWLtuZy3+
 y3euoAub9b+8Y/e3HycDRmitzm0NAHM7fpEtcqTCAsNuzrL158zM4nLnYpdDHv8SuSPc
 77DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=77mzIJgsnd6fd7VLB24yLdWxFauCP3v4BC+3010BcoI=;
 b=Me2LveyrXmdvzgTTCl8j18Tzte3sztLNRSBuYBtP7H/EeEuK9kbKsfnWKfSUQgY5nH
 1HgZS1eNuE5WgdJzKCnxmno0ZOObysU+FR69/LfCUXXkpxZaSWR1o6PVlvAgBeVmZ1Sx
 E+EtwCPYI1MIk1aq/5zDr6d/H8qr044bLdzYhbBuWCLP0bJiowL2fnJw/pk16iM6vOjI
 eMThqvLuYlcMxaPjpncgoKpEvFZAd7CDkTW38xeevLiS+YVaOqrBYUvtYzgBACphHXXD
 hiWPnCJL1yp470/UHuW3nvrxALFfMmllZp7Qk1igWY5zuKHBKJPuH8zcEbt04pPJB3L6
 jv+g==
X-Gm-Message-State: AOAM531vQUBByMMbB+xZPMyQQhaLKf/XyYphlQQgITkusEhsEDThGiL6
 BIzSFHkSS8kfRb3i3k9WznstSJ0gmYuGgb9yg6XVJg==
X-Google-Smtp-Source: ABdhPJyIgn+m9LaLC8tfpgMI6o5DwNs431a/XgStcK+ZHToBxiaKuPwfiAkwxBcEas0/uG7N+C3oGG+BgIoYjsXskfY=
X-Received: by 2002:a05:6830:1002:: with SMTP id
 a2mr8203403otp.144.1624008616648; 
 Fri, 18 Jun 2021 02:30:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210617105824.31752-1-wangyanan55@huawei.com>
 <20210617105824.31752-4-wangyanan55@huawei.com>
In-Reply-To: <20210617105824.31752-4-wangyanan55@huawei.com>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 18 Jun 2021 10:29:40 +0100
Message-ID: <CA+EHjTxS9Kae3dXLsC7XDi4neb21JGwOxZzsBN8OevczRPXn8Q@mail.gmail.com>
Subject: Re: [PATCH v7 3/4] KVM: arm64: Tweak parameters of guest cache
 maintenance functions
To: Yanan Wang <wangyanan55@huawei.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Hi Yanan,

On Thu, Jun 17, 2021 at 11:58 AM Yanan Wang <wangyanan55@huawei.com> wrote:
>
> Adjust the parameter "kvm_pfn_t pfn" of __clean_dcache_guest_page
> and __invalidate_icache_guest_page to "void *va", which paves the
> way for converting these two guest CMO functions into callbacks in
> structure kvm_pgtable_mm_ops. No functional change.
>
> Signed-off-by: Yanan Wang <wangyanan55@huawei.com>
> ---
>  arch/arm64/include/asm/kvm_mmu.h |  9 ++-------
>  arch/arm64/kvm/mmu.c             | 28 +++++++++++++++-------------
>  2 files changed, 17 insertions(+), 20 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index 25ed956f9af1..6844a7550392 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -187,10 +187,8 @@ static inline bool vcpu_has_cache_enabled(struct kvm_vcpu *vcpu)
>         return (vcpu_read_sys_reg(vcpu, SCTLR_EL1) & 0b101) == 0b101;
>  }
>
> -static inline void __clean_dcache_guest_page(kvm_pfn_t pfn, unsigned long size)
> +static inline void __clean_dcache_guest_page(void *va, size_t size)
>  {
> -       void *va = page_address(pfn_to_page(pfn));
> -
>         /*
>          * With FWB, we ensure that the guest always accesses memory using
>          * cacheable attributes, and we don't have to clean to PoC when
> @@ -203,16 +201,13 @@ static inline void __clean_dcache_guest_page(kvm_pfn_t pfn, unsigned long size)
>         kvm_flush_dcache_to_poc(va, size);
>  }
>
> -static inline void __invalidate_icache_guest_page(kvm_pfn_t pfn,
> -                                                 unsigned long size)
> +static inline void __invalidate_icache_guest_page(void *va, size_t size)
>  {
>         if (icache_is_aliasing()) {
>                 /* any kind of VIPT cache */
>                 __flush_icache_all();
>         } else if (is_kernel_in_hyp_mode() || !icache_is_vpipt()) {
>                 /* PIPT or VPIPT at EL2 (see comment in __kvm_tlb_flush_vmid_ipa) */
> -               void *va = page_address(pfn_to_page(pfn));
> -
>                 invalidate_icache_range((unsigned long)va,
>                                         (unsigned long)va + size);
>         }
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 5742ba765ff9..b980f8a47cbb 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -126,6 +126,16 @@ static void *kvm_host_va(phys_addr_t phys)
>         return __va(phys);
>  }
>
> +static void clean_dcache_guest_page(void *va, size_t size)
> +{
> +       __clean_dcache_guest_page(va, size);
> +}
> +
> +static void invalidate_icache_guest_page(void *va, size_t size)
> +{
> +       __invalidate_icache_guest_page(va, size);
> +}
> +
>  /*
>   * Unmapping vs dcache management:
>   *
> @@ -693,16 +703,6 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
>         kvm_mmu_write_protect_pt_masked(kvm, slot, gfn_offset, mask);
>  }
>
> -static void clean_dcache_guest_page(kvm_pfn_t pfn, unsigned long size)
> -{
> -       __clean_dcache_guest_page(pfn, size);
> -}
> -
> -static void invalidate_icache_guest_page(kvm_pfn_t pfn, unsigned long size)
> -{
> -       __invalidate_icache_guest_page(pfn, size);
> -}
> -
>  static void kvm_send_hwpoison_signal(unsigned long address, short lsb)
>  {
>         send_sig_mceerr(BUS_MCEERR_AR, (void __user *)address, lsb, current);
> @@ -1013,11 +1013,13 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>                 prot |= KVM_PGTABLE_PROT_W;
>
>         if (fault_status != FSC_PERM && !device)
> -               clean_dcache_guest_page(pfn, vma_pagesize);
> +               clean_dcache_guest_page(page_address(pfn_to_page(pfn)),
> +                                       vma_pagesize);
>
>         if (exec_fault) {
>                 prot |= KVM_PGTABLE_PROT_X;
> -               invalidate_icache_guest_page(pfn, vma_pagesize);
> +               invalidate_icache_guest_page(page_address(pfn_to_page(pfn)),
> +                                            vma_pagesize);
>         }
>
>         if (device)
> @@ -1219,7 +1221,7 @@ bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>          * We've moved a page around, probably through CoW, so let's treat it
>          * just like a translation fault and clean the cache to the PoC.
>          */
> -       clean_dcache_guest_page(pfn, PAGE_SIZE);
> +       clean_dcache_guest_page(page_address(pfn_to_page(pfn), PAGE_SIZE);
>
>         /*
>          * The MMU notifiers will have unmapped a huge PMD before calling
> --
> 2.23.0


Reviewed-by: Fuad Tabba <tabba@google.com>

Thanks,
/fuad

> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
