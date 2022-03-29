Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B99C1C433FE
	for <kvmarm@archiver.kernel.org>; Tue, 29 Mar 2022 08:51:41 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F62F49F5F;
	Tue, 29 Mar 2022 04:51:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wFAPNjUlkxbG; Tue, 29 Mar 2022 04:51:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3AA7149F26;
	Tue, 29 Mar 2022 04:51:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4954849F01
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Mar 2022 04:51:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QTF4v6520LV5 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Mar 2022 04:51:37 -0400 (EDT)
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com
 [209.85.167.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3E1C949EF2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Mar 2022 04:51:37 -0400 (EDT)
Received: by mail-oi1-f171.google.com with SMTP id q129so18386107oif.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Mar 2022 01:51:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=U1GTiO9dDgDxH/Vxt+2jG30+YBZIQXOPWArpR//sGFg=;
 b=UU8GyDTn5GPBTdghAF0xBMdcUitGZMvsVCNx4xVZYQW2TYDNWESNGbX0OcTWGLC67L
 9oEEvdnUPa9/eIrYM7RcTVvpEslVFA0X2bBB1yAlwLCiiv1j0pXF3NmH4Mpd55ORr/Ip
 It1inxQWbxrk0zt/HQS3JLef5fevrCHNjAplRQ/xFUTy0r4ImCtSX4V7QlDIxpDNsUaC
 raUG8jpy0JEFKvM6Z1THdhKbF6x2DRV2YzRFB/8j1Hqcq9mNMs5mv+nbg71f5DQsdcfL
 p2Al5iZlr1Uc+a+BtRuCB85OsVP/qpt1gbZv6tQLA949hOQBoZLREAZwH2Tw2x7cWF8D
 t5JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=U1GTiO9dDgDxH/Vxt+2jG30+YBZIQXOPWArpR//sGFg=;
 b=qujwpzOScSrhVgTCJmO4xgmRyS4teMbFOE4RxQKPz/nLjoNSfYISNxRLXi3sfa5jfx
 1/Kc6jFjwETekWBpp6v+Vye2DFxV4HOQLTDkVCTWc5rbplLPMOnjO1NbYEMHCGkv7A95
 anT9u7Iij8O+/YznuaVX0Pg4bg00u0nR6EUhnybpqudBaInLnyur32Gn8cM86kE27Zsj
 CL1zsbh/A08K3CtB4IwYm7yw754ZdYY3nG5ZJ/aWlaaz89ui2R3qna0KRWHi1+xhNB6L
 jjFDbwbzewRauJFACxGaQzqaKU9ioetRQpjRR1Dk5yGXMR/EfyLWR6LxqM34CecaG7hs
 NcGw==
X-Gm-Message-State: AOAM533qHU9zvMxTy5gmk4lMLy8YwL/SF+scGQgLwF6AJuTq1qM00qOI
 Jg01bZiv6uBJwEXbBiKFffGhkxvdSvjo3G/2YW8xug==
X-Google-Smtp-Source: ABdhPJz5vWH82Ul42JP7uuNEch+48rDza1ecNr8WyHT3CMBc2xib8vnK56UC2yUcipNLDMPf+BhhDUs45wMEDC4Q03c=
X-Received: by 2002:aca:180b:0:b0:2f7:23ae:8cd1 with SMTP id
 h11-20020aca180b000000b002f723ae8cd1mr1591903oih.146.1648543896531; Tue, 29
 Mar 2022 01:51:36 -0700 (PDT)
MIME-Version: 1.0
References: <20220314200148.2695206-1-kaleshsingh@google.com>
 <20220314200148.2695206-5-kaleshsingh@google.com>
In-Reply-To: <20220314200148.2695206-5-kaleshsingh@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 29 Mar 2022 09:51:00 +0100
Message-ID: <CA+EHjTys1a788HiLnBYu5yySOQ4BKPFxccXhO8P4dLnUCgBUQA@mail.gmail.com>
Subject: Re: [PATCH v6 4/8] KVM: arm64: Add guard pages for pKVM (protected
 nVHE) hypervisor stack
To: Kalesh Singh <kaleshsingh@google.com>
Cc: kernel-team@android.com, will@kernel.org,
 Peter Collingbourne <pcc@google.com>, maz@kernel.org,
 linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 Mark Brown <broonie@kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, surenb@google.com,
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

Hi Kalesh,

On Mon, Mar 14, 2022 at 8:04 PM Kalesh Singh <kaleshsingh@google.com> wrote:
>
> Map the stack pages in the flexible private VA range and allocate
> guard pages below the stack as unbacked VA space. The stack is aligned
> so that any valid stack address has PAGE_SHIFT bit as 1 - this is used
> for overflow detection (implemented in a subsequent patch in the series)
>
> Signed-off-by: Kalesh Singh <kaleshsingh@google.com>

Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>

Thanks,
/fuad


> ---
>
> Changes in v6:
>   - Update call to pkvm_alloc_private_va_range() (return val and params)
>
> Changes in v5:
>   - Use a single allocation for stack and guard pages to ensure they
>     are contiguous, per Marc
>
> Changes in v4:
>   - Replace IS_ERR_OR_NULL check with IS_ERR check now that
>     pkvm_alloc_private_va_range() returns an error for null
>     pointer, per Fuad
>
> Changes in v3:
>   - Handle null ptr in IS_ERR_OR_NULL checks, per Mark
>
>
>  arch/arm64/kvm/hyp/nvhe/setup.c | 31 ++++++++++++++++++++++++++++---
>  1 file changed, 28 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
> index 27af337f9fea..e8d4ea2fcfa0 100644
> --- a/arch/arm64/kvm/hyp/nvhe/setup.c
> +++ b/arch/arm64/kvm/hyp/nvhe/setup.c
> @@ -99,17 +99,42 @@ static int recreate_hyp_mappings(phys_addr_t phys, unsigned long size,
>                 return ret;
>
>         for (i = 0; i < hyp_nr_cpus; i++) {
> +               struct kvm_nvhe_init_params *params = per_cpu_ptr(&kvm_init_params, i);
> +               unsigned long hyp_addr;
> +
>                 start = (void *)kern_hyp_va(per_cpu_base[i]);
>                 end = start + PAGE_ALIGN(hyp_percpu_size);
>                 ret = pkvm_create_mappings(start, end, PAGE_HYP);
>                 if (ret)
>                         return ret;
>
> -               end = (void *)per_cpu_ptr(&kvm_init_params, i)->stack_hyp_va;
> -               start = end - PAGE_SIZE;
> -               ret = pkvm_create_mappings(start, end, PAGE_HYP);
> +               /*
> +                * Allocate a contiguous HYP private VA range for the stack
> +                * and guard page. The allocation is also aligned based on
> +                * the order of its size.
> +                */
> +               ret = pkvm_alloc_private_va_range(PAGE_SIZE * 2, &hyp_addr);
> +               if (ret)
> +                       return ret;
> +
> +               /*
> +                * Since the stack grows downwards, map the stack to the page
> +                * at the higher address and leave the lower guard page
> +                * unbacked.
> +                *
> +                * Any valid stack address now has the PAGE_SHIFT bit as 1
> +                * and addresses corresponding to the guard page have the
> +                * PAGE_SHIFT bit as 0 - this is used for overflow detection.
> +                */
> +               hyp_spin_lock(&pkvm_pgd_lock);
> +               ret = kvm_pgtable_hyp_map(&pkvm_pgtable, hyp_addr + PAGE_SIZE,
> +                                       PAGE_SIZE, params->stack_pa, PAGE_HYP);
> +               hyp_spin_unlock(&pkvm_pgd_lock);
>                 if (ret)
>                         return ret;
> +
> +               /* Update stack_hyp_va to end of the stack's private VA range */
> +               params->stack_hyp_va = hyp_addr + (2 * PAGE_SIZE);
>         }
>
>         /*
> --
> 2.35.1.723.g4982287a31-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
