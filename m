From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH] KVM: arm64: Safety check PSTATE when entering guest and
 handle IL
Date: Wed, 17 Oct 2018 20:02:43 +0100
Message-ID: <CAFEAcA-b8O4tjViHGfQpJt6C=i4A2tV7vcOFPiE+i4QMFKFZKw@mail.gmail.com>
References: <20181017182116.22603-1-christoffer.dall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 377BC4A20B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Oct 2018 15:03:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id N5ArpRiQc2vQ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Oct 2018 15:03:05 -0400 (EDT)
Received: from mail-oi1-f196.google.com (mail-oi1-f196.google.com
 [209.85.167.196])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 22D4C49E4C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Oct 2018 15:03:05 -0400 (EDT)
Received: by mail-oi1-f196.google.com with SMTP id 22-v6so22001470oiz.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Oct 2018 12:03:05 -0700 (PDT)
In-Reply-To: <20181017182116.22603-1-christoffer.dall@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@arm.com>
Cc: Peter Maydell <peter.maydell@arm.com>, kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, Dave P Martin <dave.martin@arm.com>, kvmarm@lists.cs.columbia.edu, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 17 October 2018 at 19:21, Christoffer Dall <christoffer.dall@arm.com> wrote:
> This commit adds a paranoid check when entering the guest to make sure
> we don't attempt running guest code in an equally or more privilged mode
> than the hypervisor.  We also catch other accidental programming of the
> SPSR_EL2 which results in an illegal exception return and report this
> safely back to the user.
>
> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> ---

> diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
> index 9ce223944983..d7ac15412c97 100644
> --- a/arch/arm64/kvm/hyp/sysreg-sr.c
> +++ b/arch/arm64/kvm/hyp/sysreg-sr.c
> @@ -152,8 +152,25 @@ static void __hyp_text __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
>  static void __hyp_text
>  __sysreg_restore_el2_return_state(struct kvm_cpu_context *ctxt)
>  {
> +       u64 pstate = ctxt->gp_regs.regs.pstate;
> +       u64 mode = pstate & PSR_AA32_MODE_MASK;
> +
> +       /*
> +        * Safety check to ensure we're setting the CPU up to enter the guest
> +        * in a less privileged mode.
> +        *
> +        * If we are attempting a return to EL2 or higher in AArch64 state,
> +        * program SPSR_EL2 with M=EL2h and the IL bit set which ensures that
> +        * we'll take an illegal exception return exception immediately after

This should read "illegal exception state exception", I think
(for the 64-bit case we don't do an illegal exception return,
we do a legal exception return that sets PSTATE.IL to 1.)

> +        * the ERET to the guest.  Attempts to return to AArch32 Hyp will
> +        * result in an illegal exception return because EL2's execution state
> +        * is determined by SCR_EL3.RW.
> +        */
> +       if (!(mode & PSR_MODE32_BIT) && mode >= PSR_MODE_EL2t)
> +               pstate = PSR_MODE_EL2h | PSR_IL_BIT;

thanks
-- PMM
