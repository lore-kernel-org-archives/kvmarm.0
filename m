Return-Path: <SRS0=np2t=GI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B83CC433E0
	for <kvmarm@archiver.kernel.org>; Tue,  5 Jan 2021 20:35:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B604322D73
	for <kvmarm@archiver.kernel.org>; Tue,  5 Jan 2021 20:35:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B604322D73
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 184ED4B23A;
	Tue,  5 Jan 2021 15:35:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id b3rPB-X2dsM0; Tue,  5 Jan 2021 15:35:51 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B7DA04B234;
	Tue,  5 Jan 2021 15:35:51 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 045DB4B225
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Jan 2021 15:35:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0Ti6FJGXRz0Z for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Jan 2021 15:35:49 -0500 (EST)
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com
 [209.85.167.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8F8F14B1ED
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Jan 2021 15:35:49 -0500 (EST)
Received: by mail-lf1-f54.google.com with SMTP id b26so1490741lff.9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 05 Jan 2021 12:35:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=4VscyJYhiGIcTTrQBOeiyNR46ULLgAygeEpUjanGCfo=;
 b=EcoR9tcQuqCugODFjv55EWqPY5iHhhMg/M7xKz8G9sXAOSq/MNvWaUdBoFUpil/HMO
 v5wLQhGVMWBj5Ksg5wI5tg+JlxrJVaD8DwsOcPp+a8kmDoDfYv0GFCBdIlauEOR05SEc
 ixIg0SWZhjI2MPCja8NoalnTeJpCRqlXHyivhmy/AB69NYE/SeiyfBhmZI26Tq35U64E
 qjlNBulAIdWcOJVN/3NcmDn8YMnVQPI4Jax5l67tQd4E+70J11gxQ13wPrYc1FyVw38i
 kBuDcjjYGTAPr15mhL+J7XsqdD0ce8LNO+UaEDNSGinhGNLqib71dQf6/FIw3jaGmaIV
 /PRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=4VscyJYhiGIcTTrQBOeiyNR46ULLgAygeEpUjanGCfo=;
 b=CYof/dMjfpIlNaRHzEPrt+xfoJgB35w/BCQYI8SW2RCyzWQGDkIlMSu/9uKcXZb9Lt
 yXcdIkFAIz8a6TD+Wf+DetmDojUyr/gQSH3rSijEfr0U5oBzN7YVJuUhZtDMUSZiJ8Gi
 6+CpVIeCPgin0K8jEOXlUAUU1mzJO5UkVyxiqj2OJnzSlv4EB5P4jU0pTGruhIR/8fF6
 0QNMmZl+WVr+xAvbrRpr1Aom2IRHpeRWWsSGsN9liFUNOCfs9Bmy1siFAFF0KlGMWXqg
 jipaVsmVutEbQ1IMsZ9zUYGM/FAudx8wJQvZ/6SQqZ4KYdnnBN6QbQ2TTYrStUHK/WJH
 cIYw==
X-Gm-Message-State: AOAM530rAUJWpiS7MRRbT2neNH6lKb9qNYRPqqCrIOHuT3PNxlP3Batu
 LI2M/Eiy8gt7KJZpQA/PJg5ycfiEErKjEdZaDu2X8w==
X-Google-Smtp-Source: ABdhPJzGF53jyYGA4ZUDiq/DyD8gsuVAzj4pKkpUmGFm0+lS55LundcofDfx94era8LH6n//MCzQhmYbQWFtY7IL51k=
X-Received: by 2002:a2e:b1d4:: with SMTP id e20mr580773lja.304.1609878947905; 
 Tue, 05 Jan 2021 12:35:47 -0800 (PST)
MIME-Version: 1.0
References: <20210104135011.2063104-1-maz@kernel.org>
 <20210104135011.2063104-5-maz@kernel.org>
In-Reply-To: <20210104135011.2063104-5-maz@kernel.org>
From: Jing Zhang <jingzhangos@google.com>
Date: Tue, 5 Jan 2021 14:35:35 -0600
Message-ID: <CAAdAUtiYe9Y6o2QLD_y94y-nVJM8ZquV-_ZETNSzc_u+rKM0-w@mail.gmail.com>
Subject: Re: [PATCH v2 04/17] arm64: Provide an 'upgrade to VHE' stub hypercall
To: Marc Zyngier <maz@kernel.org>
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
 Ard Biesheuvel <ardb@kernel.org>, Will Deacon <will@kernel.org>,
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

On Mon, Jan 4, 2021 at 7:50 AM Marc Zyngier <maz@kernel.org> wrote:
>
> As we are about to change the way a VHE system boots, let's
> provide the core helper, in the form of a stub hypercall that
> enables VHE and replicates the full EL1 context at EL2, thanks
> to EL1 and VHE-EL2 being extremely similar.
>
> On exception return, the kernel carries on at EL2. Fancy!
>
> Nothing calls this new hypercall yet, so no functional change.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/virt.h |  7 +++-
>  arch/arm64/kernel/hyp-stub.S  | 70 ++++++++++++++++++++++++++++++++++-
>  2 files changed, 74 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
> index ee6a48df89d9..7379f35ae2c6 100644
> --- a/arch/arm64/include/asm/virt.h
> +++ b/arch/arm64/include/asm/virt.h
> @@ -35,8 +35,13 @@
>   */
>  #define HVC_RESET_VECTORS 2
>
> +/*
> + * HVC_VHE_RESTART - Upgrade the CPU from EL1 to EL2, if possible
> + */
> +#define HVC_VHE_RESTART        3
> +
>  /* Max number of HYP stub hypercalls */
> -#define HVC_STUB_HCALL_NR 3
> +#define HVC_STUB_HCALL_NR 4
>
>  /* Error returned when an invalid stub number is passed into x0 */
>  #define HVC_STUB_ERR   0xbadca11
> diff --git a/arch/arm64/kernel/hyp-stub.S b/arch/arm64/kernel/hyp-stub.S
> index 160f5881a0b7..6ffdc1f7778b 100644
> --- a/arch/arm64/kernel/hyp-stub.S
> +++ b/arch/arm64/kernel/hyp-stub.S
> @@ -8,9 +8,9 @@
>
>  #include <linux/init.h>
>  #include <linux/linkage.h>
> -#include <linux/irqchip/arm-gic-v3.h>
>
>  #include <asm/assembler.h>
> +#include <asm/el2_setup.h>
>  #include <asm/kvm_arm.h>
>  #include <asm/kvm_asm.h>
>  #include <asm/ptrace.h>
> @@ -47,10 +47,16 @@ SYM_CODE_END(__hyp_stub_vectors)
>
>  SYM_CODE_START_LOCAL(el1_sync)
>         cmp     x0, #HVC_SET_VECTORS
> -       b.ne    2f
> +       b.ne    1f
>         msr     vbar_el2, x1
>         b       9f
>
> +1:     cmp     x0, #HVC_VHE_RESTART
> +       b.ne    2f
> +       mov     x0, #HVC_SOFT_RESTART
> +       adr     x1, mutate_to_vhe
> +       // fall through...
Does "br x1" work here instead of falling through into
HVC_SOFT_RESTART? Just curious about the reason for falling-through.
> +
>  2:     cmp     x0, #HVC_SOFT_RESTART
>         b.ne    3f
>         mov     x0, x2
> @@ -70,6 +76,66 @@ SYM_CODE_START_LOCAL(el1_sync)
>         eret
>  SYM_CODE_END(el1_sync)
>
> +// nVHE? No way! Give me the real thing!
> +SYM_CODE_START_LOCAL(mutate_to_vhe)
> +       // Sanity check: MMU *must* be off
> +       mrs     x0, sctlr_el2
> +       tbnz    x0, #0, 1f
> +
> +       // Needs to be VHE capable, obviously
> +       mrs     x0, id_aa64mmfr1_el1
> +       ubfx    x0, x0, #ID_AA64MMFR1_VHE_SHIFT, #4
> +       cbz     x0, 1f
> +
> +       // Engage the VHE magic!
> +       mov_q   x0, HCR_HOST_VHE_FLAGS
> +       msr     hcr_el2, x0
> +       isb
> +
> +       // Doesn't do much on VHE, but still, worth a shot
> +       init_el2_state vhe
> +
> +       // Use the EL1 allocated stack, per-cpu offset
> +       mrs     x0, sp_el1
> +       mov     sp, x0
> +       mrs     x0, tpidr_el1
> +       msr     tpidr_el2, x0
> +
> +       // FP configuration, vectors
> +       mrs_s   x0, SYS_CPACR_EL12
> +       msr     cpacr_el1, x0
> +       mrs_s   x0, SYS_VBAR_EL12
> +       msr     vbar_el1, x0
> +
> +       // Transfert the MM state from EL1 to EL2
> +       mrs_s   x0, SYS_TCR_EL12
> +       msr     tcr_el1, x0
> +       mrs_s   x0, SYS_TTBR0_EL12
> +       msr     ttbr0_el1, x0
> +       mrs_s   x0, SYS_TTBR1_EL12
> +       msr     ttbr1_el1, x0
> +       mrs_s   x0, SYS_MAIR_EL12
> +       msr     mair_el1, x0
> +       isb
> +
> +       // Invalidate TLBs before enabling the MMU
> +       tlbi    vmalle1
> +       dsb     nsh
> +
> +       // Enable the EL2 S1 MMU, as set up from EL1
> +       mrs_s   x0, SYS_SCTLR_EL12
> +       set_sctlr_el1   x0
> +
> +       // Hack the exception return to stay at EL2
> +       mrs     x0, spsr_el1
> +       and     x0, x0, #~PSR_MODE_MASK
> +       mov     x1, #PSR_MODE_EL2h
> +       orr     x0, x0, x1
> +       msr     spsr_el1, x0
> +
> +1:     eret
> +SYM_CODE_END(mutate_to_vhe)
> +
>  .macro invalid_vector  label
>  SYM_CODE_START_LOCAL(\label)
>         b \label
> --
> 2.29.2
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
