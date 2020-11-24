Return-Path: <SRS0=ECKt=E6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24B7DC2D0E4
	for <kvmarm@archiver.kernel.org>; Tue, 24 Nov 2020 14:08:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5D3662076E
	for <kvmarm@archiver.kernel.org>; Tue, 24 Nov 2020 14:08:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="nl4LKBGH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5D3662076E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 877D54BD61;
	Tue, 24 Nov 2020 09:08:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jNTYdX7wd-Yx; Tue, 24 Nov 2020 09:08:35 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 501784BD59;
	Tue, 24 Nov 2020 09:08:35 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 14C184BD57
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2020 09:08:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6TA8F452FH40 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Nov 2020 09:08:34 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C80DE4BD55
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2020 09:08:33 -0500 (EST)
Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com
 [209.85.210.45])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 725DC2087D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2020 14:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1606226912;
 bh=pz8XoUvKXEST/Wi7IbfbTvTqunUI9mU5pA8fwrAYEJE=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=nl4LKBGHXLiIRlrreDlrfDbzGecyFa9PSdzoewZ818ZaPyt1T8tRLuFnZlI036AiE
 qzdpNbXI8SYGzYLssAZQqPw2SDVZTsjhRo4IN96Ltay558Qa9+v1AAGiKERBftKoaD
 Viz3E9vUFZuHO+1nwGPiYh70JVhu32AjFh0M9HQ8=
Received: by mail-ot1-f45.google.com with SMTP id k3so19412170otp.12
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2020 06:08:32 -0800 (PST)
X-Gm-Message-State: AOAM530qjDqOoN4WH5LGo4Cc59dCQD+LQofhgjn9FSlAJR+CxC1UpcGN
 9PgVcowk4K+Nt82dEfJ4O3gRIGoS5dJy+aVsqZc=
X-Google-Smtp-Source: ABdhPJx865zEnatF6fHHRJl/lB1cjLB90bCUA5G7R1GZ8uXtk6uzqRH3CNLacb06RN9WC8WkMCrwXVoS1kIZrZ5SsFM=
X-Received: by 2002:a9d:62c1:: with SMTP id z1mr3387804otk.108.1606226911537; 
 Tue, 24 Nov 2020 06:08:31 -0800 (PST)
MIME-Version: 1.0
References: <20201119162543.78001-1-dbrazdil@google.com>
 <20201119162543.78001-6-dbrazdil@google.com>
In-Reply-To: <20201119162543.78001-6-dbrazdil@google.com>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Tue, 24 Nov 2020 15:08:20 +0100
X-Gmail-Original-Message-ID: <CAMj1kXG_2MZu=JFqOPioGi-K3AtQHYvJyxkCR-HWBuagz=MoXw@mail.gmail.com>
Message-ID: <CAMj1kXG_2MZu=JFqOPioGi-K3AtQHYvJyxkCR-HWBuagz=MoXw@mail.gmail.com>
Subject: Re: [RFC PATCH 5/6] kvm: arm64: Fix constant-pool users in hyp
To: David Brazdil <dbrazdil@google.com>
Cc: Android Kernel Team <kernel-team@android.com>,
 Marc Zyngier <maz@kernel.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Linux ARM <linux-arm-kernel@lists.infradead.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 kvmarm <kvmarm@lists.cs.columbia.edu>
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

On Thu, 19 Nov 2020 at 17:26, David Brazdil <dbrazdil@google.com> wrote:
>
> Hyp code used to use absolute addressing via a constant pool to obtain
> the kernel VA of 3 symbols - panic, __hyp_panic_string and
> __kvm_handle_stub_hvc. This used to work because the kernel would
> relocate the addresses in the constant pool to kernel VA at boot and hyp
> would simply load them from there.
>
> Now that relocations are fixed up to point to hyp VAs, this does not
> work any longer. Rework the helpers to convert hyp VA to kernel VA / PA
> as needed.
>

Ok, so the reason for the problem is that the literal exists inside
the HYP text, and all literals are fixed up using the HYP mapping,
even if they don't point to something that is mapped at HYP. Would it
make sense to simply disregard literals that point outside of the HYP
VA mapping?

> Signed-off-by: David Brazdil <dbrazdil@google.com>
> ---
>  arch/arm64/include/asm/kvm_mmu.h | 29 +++++++++++++++++++----------
>  arch/arm64/kvm/hyp/nvhe/host.S   | 29 +++++++++++++++--------------
>  2 files changed, 34 insertions(+), 24 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index 8cb8974ec9cc..0676ff2105bb 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -72,9 +72,14 @@ alternative_cb kvm_update_va_mask
>  alternative_cb_end
>  .endm
>
> +.macro hyp_pa reg, tmp
> +       ldr_l   \tmp, hyp_physvirt_offset
> +       add     \reg, \reg, \tmp
> +.endm
> +
>  /*
> - * Convert a kernel image address to a PA
> - * reg: kernel address to be converted in place
> + * Convert a hypervisor VA to a kernel image address
> + * reg: hypervisor address to be converted in place
>   * tmp: temporary register
>   *
>   * The actual code generation takes place in kvm_get_kimage_voffset, and
> @@ -82,18 +87,22 @@ alternative_cb_end
>   * perform the register allocation (kvm_get_kimage_voffset uses the
>   * specific registers encoded in the instructions).
>   */
> -.macro kimg_pa reg, tmp
> +.macro hyp_kimg reg, tmp
> +       /* Convert hyp VA -> PA. */
> +       hyp_pa  \reg, \tmp
> +
> +       /* Load kimage_voffset. */
>  alternative_cb kvm_get_kimage_voffset
> -       movz    \tmp, #0
> -       movk    \tmp, #0, lsl #16
> -       movk    \tmp, #0, lsl #32
> -       movk    \tmp, #0, lsl #48
> +       movz    \tmp, #0
> +       movk    \tmp, #0, lsl #16
> +       movk    \tmp, #0, lsl #32
> +       movk    \tmp, #0, lsl #48
>  alternative_cb_end
>
> -       /* reg = __pa(reg) */
> -       sub     \reg, \reg, \tmp
> +       /* Convert PA -> kimg VA. */
> +       add     \reg, \reg, \tmp
>  .endm
> -
> +
>  #else
>
>  #include <linux/pgtable.h>
> diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
> index 596dd5ae8e77..bcb80d525d8c 100644
> --- a/arch/arm64/kvm/hyp/nvhe/host.S
> +++ b/arch/arm64/kvm/hyp/nvhe/host.S
> @@ -74,27 +74,28 @@ SYM_FUNC_END(__host_enter)
>   * void __noreturn __hyp_do_panic(bool restore_host, u64 spsr, u64 elr, u64 par);
>   */
>  SYM_FUNC_START(__hyp_do_panic)
> -       /* Load the format arguments into x1-7 */
> -       mov     x6, x3
> -       get_vcpu_ptr x7, x3
> -
> -       mrs     x3, esr_el2
> -       mrs     x4, far_el2
> -       mrs     x5, hpfar_el2
> -
>         /* Prepare and exit to the host's panic funciton. */
>         mov     lr, #(PSR_F_BIT | PSR_I_BIT | PSR_A_BIT | PSR_D_BIT |\
>                       PSR_MODE_EL1h)
>         msr     spsr_el2, lr
>         ldr     lr, =panic
> +       hyp_kimg lr, x6
>         msr     elr_el2, lr
>
> -       /*
> -        * Set the panic format string and enter the host, conditionally
> -        * restoring the host context.
> -        */
> +       /* Set the panic format string. Use the, now free, LR as scratch. */
> +       ldr     lr, =__hyp_panic_string
> +       hyp_kimg lr, x6
> +
> +       /* Load the format arguments into x1-7. */
> +       mov     x6, x3
> +       get_vcpu_ptr x7, x3
> +       mrs     x3, esr_el2
> +       mrs     x4, far_el2
> +       mrs     x5, hpfar_el2
> +
> +       /* Enter the host, conditionally restoring the host context. */
>         cmp     x0, xzr
> -       ldr     x0, =__hyp_panic_string
> +       mov     x0, lr
>         b.eq    __host_enter_without_restoring
>         b       __host_enter_for_panic
>  SYM_FUNC_END(__hyp_do_panic)
> @@ -124,7 +125,7 @@ SYM_FUNC_END(__hyp_do_panic)
>          * Preserve x0-x4, which may contain stub parameters.
>          */
>         ldr     x5, =__kvm_handle_stub_hvc
> -       kimg_pa x5, x6
> +       hyp_pa  x5, x6
>         br      x5
>  .L__vect_end\@:
>  .if ((.L__vect_end\@ - .L__vect_start\@) > 0x80)
> --
> 2.29.2.299.gdc1121823c-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
