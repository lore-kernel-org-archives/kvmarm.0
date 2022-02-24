Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0018C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 24 Feb 2022 12:26:55 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 66AFF4C0C6;
	Thu, 24 Feb 2022 07:26:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VjzUcLQ8rId0; Thu, 24 Feb 2022 07:26:54 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0739A4C0DB;
	Thu, 24 Feb 2022 07:26:54 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 77CC84C0CB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 07:26:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QYuiiG9xNS4v for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Feb 2022 07:26:51 -0500 (EST)
Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com
 [209.85.167.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1A7254BEF4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 07:26:51 -0500 (EST)
Received: by mail-oi1-f175.google.com with SMTP id s5so2236902oic.10
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 04:26:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=oYTU/xUKnqUv9iv9u+6g24yzpR+pFvcXOd7BnbJwM7w=;
 b=JR1017e8qWfgaETBmi93Id8ZpoF/iFAwjXtyZL81dMEwoRABQDNCRDEwYJyOYNHJA7
 3JT4S8HMKzT5aFATiKFCdFdBs0gNgZ3cKYkVoATCsqDNJZkVdpGStrMZ4EIdLurcWQcT
 axPXDvwkZwCsExi02fUqzjQahgCz2tcXQlclkRQfGlUuX5CfbQ3pp0VoYRMl8dvwB5yo
 wzS/qZZNloI2WvCFDVltZEkpsitX/EWbewf6DJQXtD+tNxQFb/fb+BXJ3UzO9knbkCWf
 yOkKJZWXoXPDMAcT7Q7vNS3Wp/XjhTz/cgm42/7uad1Pk4RNPkWC6+5wNQTOVXNmWQdt
 rKTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=oYTU/xUKnqUv9iv9u+6g24yzpR+pFvcXOd7BnbJwM7w=;
 b=jLTP8yEchjsVxWWP+2yqY3sPr1cR+EJEf5PPwYApwQ2mi6PVM/XHnQjL0vIdHL2ytD
 /WPrfVyvKSL+K71wiiGHVIhzTK/S9zs0QyF5/lXNWFTnr7dUhA5JTfO1AFv2kc9DwrtB
 /HhVAfpNHm1Zj57/Nu9mfJINZxBaiDzVPMF4RFWs4K+BiXZXzxn3UuCM5TfqBR5J56H9
 XwMlZPkJ3Zu2mN9FGuCLwoVDnY2G0NNoVppC9cpxWP2cyrpY8mFC6Ml8h11X2L4cETk7
 1U0CaBRG5h6jPotlPme0GUYLHwYWp+L3rojvdR/T8iwQgVlffeO1gSP+ASGprW3BaJVD
 W2kw==
X-Gm-Message-State: AOAM530zmLNWuUAJ5gkiza5iwTV0AjDqdBAxVXJsaot6SncHL3YEula+
 PPiLxf3x6VHkDVa3bjVPrYQp3lwbgtEyipeLDY5zqw==
X-Google-Smtp-Source: ABdhPJzmSzfVqT9jRRqKWQ7Vbi8o4Aj8CdhVv14Hh6K4GF7CeVmxqmI6yIP2jfyFBJ29+WT16YhgLURlwHMt4sHdxhs=
X-Received: by 2002:a54:4e86:0:b0:2cf:c254:f77c with SMTP id
 c6-20020a544e86000000b002cfc254f77cmr1069155oiy.171.1645705610293; Thu, 24
 Feb 2022 04:26:50 -0800 (PST)
MIME-Version: 1.0
References: <20220224051439.640768-1-kaleshsingh@google.com>
 <20220224051439.640768-4-kaleshsingh@google.com>
In-Reply-To: <20220224051439.640768-4-kaleshsingh@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 24 Feb 2022 12:26:14 +0000
Message-ID: <CA+EHjTy6DJt8Pcfj4JnVhSG0sQ7O09zvOaMP--aRuAsM=8zKUw@mail.gmail.com>
Subject: Re: [PATCH v3 3/8] KVM: arm64: Add guard pages for KVM nVHE
 hypervisor stack
To: Kalesh Singh <kaleshsingh@google.com>
Cc: kernel-team@android.com, Andrew Walbran <qwandor@google.com>,
 will@kernel.org, Peter Collingbourne <pcc@google.com>, maz@kernel.org,
 linux-kernel@vger.kernel.org,
 "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 Mark Brown <broonie@kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 surenb@google.com, kvmarm@lists.cs.columbia.edu,
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



On Thu, Feb 24, 2022 at 5:18 AM Kalesh Singh <kaleshsingh@google.com> wrote:
>
> Maps the stack pages in the flexible private VA range and allocates
> guard pages below the stack as unbacked VA space. The stack is aligned
> to twice its size to aid overflow detection (implemented in a subsequent
> patch in the series).
>
> Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> ---
>
> Changes in v3:
>   - Handle null ptr in IS_ERR_OR_NULL checks, per Mark
>
>  arch/arm64/include/asm/kvm_asm.h |  1 +
>  arch/arm64/kvm/arm.c             | 32 +++++++++++++++++++++++++++++---
>  2 files changed, 30 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> index d5b0386ef765..2e277f2ed671 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -169,6 +169,7 @@ struct kvm_nvhe_init_params {
>         unsigned long tcr_el2;
>         unsigned long tpidr_el2;
>         unsigned long stack_hyp_va;
> +       unsigned long stack_pa;
>         phys_addr_t pgd_pa;
>         unsigned long hcr_el2;
>         unsigned long vttbr;
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index ecc5958e27fe..7a23630c4a7f 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1541,7 +1541,6 @@ static void cpu_prepare_hyp_mode(int cpu)
>         tcr |= (idmap_t0sz & GENMASK(TCR_TxSZ_WIDTH - 1, 0)) << TCR_T0SZ_OFFSET;
>         params->tcr_el2 = tcr;
>
> -       params->stack_hyp_va = kern_hyp_va(per_cpu(kvm_arm_hyp_stack_page, cpu) + PAGE_SIZE);
>         params->pgd_pa = kvm_mmu_get_httbr();
>         if (is_protected_kvm_enabled())
>                 params->hcr_el2 = HCR_HOST_NVHE_PROTECTED_FLAGS;
> @@ -1990,14 +1989,41 @@ static int init_hyp_mode(void)
>          * Map the Hyp stack pages
>          */
>         for_each_possible_cpu(cpu) {
> +               struct kvm_nvhe_init_params *params = per_cpu_ptr_nvhe_sym(kvm_init_params, cpu);
>                 char *stack_page = (char *)per_cpu(kvm_arm_hyp_stack_page, cpu);
> -               err = create_hyp_mappings(stack_page, stack_page + PAGE_SIZE,
> -                                         PAGE_HYP);
> +               unsigned long stack_hyp_va, guard_hyp_va;
>
> +               /*
> +                * Private mappings are allocated downwards from io_map_base
> +                * so allocate the stack first then the guard page.
> +                *
> +                * The stack is aligned to twice its size to facilitate overflow
> +                * detection.
> +                */
> +               err = __create_hyp_private_mapping(__pa(stack_page), PAGE_SIZE,
> +                                               PAGE_SIZE * 2, &stack_hyp_va, PAGE_HYP);
>                 if (err) {
>                         kvm_err("Cannot map hyp stack\n");
>                         goto out_err;
>                 }
> +
> +               /* Allocate unbacked private VA range for stack guard page */
> +               guard_hyp_va = hyp_alloc_private_va_range(PAGE_SIZE, PAGE_SIZE);
> +               if (IS_ERR_OR_NULL((void *)guard_hyp_va)) {
> +                       err = guard_hyp_va ? PTR_ERR((void *)guard_hyp_va) : -ENOMEM;

I am a bit confused by this check. hyp_alloc_private_va_range() always
returns ERR_PTR(-ENOMEM) if there's an error. Mark's comment (if I
understood it correctly) was about how you were handling it *in*
hyp_alloc_private_va_range(), rather than calls *to*
hyp_alloc_private_va_range().

> +                       kvm_err("Cannot allocate hyp stack guard page\n");
> +                       goto out_err;
> +               }
> +
> +               /*
> +                * Save the stack PA in nvhe_init_params. This will be needed to recreate
> +                * the stack mapping in protected nVHE mode. __hyp_pa() won't do the right
> +                * thing there, since the stack has been mapped in the flexible private
> +                * VA space.
> +                */

Nit: These comments go over 80 columns, unlike other comments that
you've added in this file.

Thanks,
/fuad

> +               params->stack_pa = __pa(stack_page) + PAGE_SIZE;
> +
> +               params->stack_hyp_va = stack_hyp_va + PAGE_SIZE;
>         }
>
>         for_each_possible_cpu(cpu) {
> --
> 2.35.1.473.g83b2b277ed-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
