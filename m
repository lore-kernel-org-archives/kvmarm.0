Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CC77C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 24 Nov 2021 13:12:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D96B4B1B4;
	Wed, 24 Nov 2021 08:12:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YMEgDEWRf-cI; Wed, 24 Nov 2021 08:12:32 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EC15C4B1AD;
	Wed, 24 Nov 2021 08:12:32 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 275BF4B1AB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Nov 2021 08:12:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id njNouadP0SBO for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Nov 2021 08:12:29 -0500 (EST)
Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com
 [209.85.167.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 583B04B1AA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Nov 2021 08:12:29 -0500 (EST)
Received: by mail-oi1-f172.google.com with SMTP id m6so5266874oim.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Nov 2021 05:12:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=JqN346vu81xV6yQg3GItWA6XVAjI0w4RnyXhzwybFVw=;
 b=GdE6vOdYO2UZK3IVHXRiN/8XrRot+7I7LZF7o5UQEEuqcBzZxFYFd56+wN9qno6V0o
 Xs5Tqh/QVh0kLhIA/JP3b12vua0n1kXM9QUVRyXOBfDkxWta5h+ze+lO2NIoeDIPUPVO
 7IgZfmrm+3RKHTcC0+oR+yMGXAVIf2qmOYc6aKan+x7ZzNvrP4eiLV49whZSIxw4N3t2
 Ap2Xrr0e4uMgGo5h0vj3xO+SBCN9hHTeOh/6E4Oeh9SlFHVLmgmoLrplzop1C/s3y1tt
 GqnOfRv5HV1/ECSxPVyrbBCNtF06nuTSFOciTJIELVxSSwiNFAfZ0RizPPA+n7KLtq44
 bHgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=JqN346vu81xV6yQg3GItWA6XVAjI0w4RnyXhzwybFVw=;
 b=vqDTHlHIjn8+pcsmwM1a/n/FF2fhQExwb0n6zzJHrlgjssx6/pM335X44pTjfFXL7c
 i5VWrt9ST8G0tKZov3VDgLpuUHupD8owo0lwQQwoQBoyw9TUQ/EUGYTm6Q0DYoo9QRVk
 tgfSLBUnBMlGmZFiNY4dIa/v8I/JXgVzLgcp0T39s+VeUucukhb1XrZc2qoez6T/V57z
 OZLP2T3qTS+IXwjo8CLe6KLSdIgBL91D+7HL2Unm9l0aN7wBfjObxZoY1tCX4dhpv0L0
 zviDCeNR8G6Mib7Ae1sTF+m96/ry45KtQ+/r59BedIleD+2BbkI6i6hHNXAKYHY4bVlt
 4BIw==
X-Gm-Message-State: AOAM533Qq6FlUPIa1l0kGnvQAqxwUFu1BlVEioahGAspoD76/rPJMNoB
 hBo3fy4uj06/vE3NcxaNSOCv9DwqfdUdG2H23yW32A==
X-Google-Smtp-Source: ABdhPJx6aGoSfut46o7LozaSaGDBEYjnElPUGNTmNdIG3WvaJORhEJnZ4e5LPQV4sDNoPQnTg2+QL6dL0q6ON8peIzc=
X-Received: by 2002:aca:a88f:: with SMTP id r137mr5760840oie.85.1637759547911; 
 Wed, 24 Nov 2021 05:12:27 -0800 (PST)
MIME-Version: 1.0
References: <20211123142247.62532-1-maz@kernel.org>
 <20211123142247.62532-3-maz@kernel.org>
In-Reply-To: <20211123142247.62532-3-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 24 Nov 2021 13:11:52 +0000
Message-ID: <CA+EHjTx47iiyKNuS5utSScSNbnE74Mktiv1AA9wwvTBF+U4LTw@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: arm64: Move pkvm's special 32bit handling into a
 generic infrastructure
To: Marc Zyngier <maz@kernel.org>
Cc: kernel-team@android.com, kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
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

Hi Marc,

On Tue, Nov 23, 2021 at 2:23 PM Marc Zyngier <maz@kernel.org> wrote:
>
> Protected KVM is trying to turn AArch32 exceptions into an illegal
> exception entry. Unfortunately, it does that it a way that is a bit

Small nit: s/it/in

> abrupt, and too early for PSTATE to be available.

> Instead, move it to the fixup code, which is a more reasonable place
> for it. This will also be useful for the NV code.

This approach seems to be easier to generalize for other cases than
the previous one.

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 8 ++++++++
>  arch/arm64/kvm/hyp/nvhe/switch.c        | 8 +-------
>  arch/arm64/kvm/hyp/vhe/switch.c         | 4 ++++
>  3 files changed, 13 insertions(+), 7 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index d79fd101615f..96c5f3fb7838 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -403,6 +403,8 @@ typedef bool (*exit_handler_fn)(struct kvm_vcpu *, u64 *);
>
>  static const exit_handler_fn *kvm_get_exit_handler_array(struct kvm_vcpu *vcpu);
>
> +static void early_exit_filter(struct kvm_vcpu *vcpu, u64 *exit_code);
> +
>  /*
>   * Allow the hypervisor to handle the exit with an exit handler if it has one.
>   *
> @@ -435,6 +437,12 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
>          */
>         vcpu->arch.ctxt.regs.pstate = read_sysreg_el2(SYS_SPSR);
>
> +       /*
> +        * Check whether we want to repaint the state one way or
> +        * another.
> +        */
> +       early_exit_filter(vcpu, exit_code);
> +
>         if (ARM_EXCEPTION_CODE(*exit_code) != ARM_EXCEPTION_IRQ)
>                 vcpu->arch.fault.esr_el2 = read_sysreg_el2(SYS_ESR);
>
> diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
> index c0e3fed26d93..d13115a12434 100644
> --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> @@ -233,7 +233,7 @@ static const exit_handler_fn *kvm_get_exit_handler_array(struct kvm_vcpu *vcpu)
>   * Returns false if the guest ran in AArch32 when it shouldn't have, and
>   * thus should exit to the host, or true if a the guest run loop can continue.
>   */
> -static bool handle_aarch32_guest(struct kvm_vcpu *vcpu, u64 *exit_code)
> +static void early_exit_filter(struct kvm_vcpu *vcpu, u64 *exit_code)
>  {
>         struct kvm *kvm = kern_hyp_va(vcpu->kvm);
>
> @@ -248,10 +248,7 @@ static bool handle_aarch32_guest(struct kvm_vcpu *vcpu, u64 *exit_code)
>                 vcpu->arch.target = -1;
>                 *exit_code &= BIT(ARM_EXIT_WITH_SERROR_BIT);
>                 *exit_code |= ARM_EXCEPTION_IL;
> -               return false;
>         }
> -
> -       return true;
>  }
>
>  /* Switch to the guest for legacy non-VHE systems */
> @@ -316,9 +313,6 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
>                 /* Jump in the fire! */
>                 exit_code = __guest_enter(vcpu);
>
> -               if (unlikely(!handle_aarch32_guest(vcpu, &exit_code)))
> -                       break;
> -
>                 /* And we're baaack! */
>         } while (fixup_guest_exit(vcpu, &exit_code));
>
> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
> index 5a2cb5d9bc4b..fbb26b93c347 100644
> --- a/arch/arm64/kvm/hyp/vhe/switch.c
> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> @@ -112,6 +112,10 @@ static const exit_handler_fn *kvm_get_exit_handler_array(struct kvm_vcpu *vcpu)
>         return hyp_exit_handlers;
>  }
>
> +static void early_exit_filter(struct kvm_vcpu *vcpu, u64 *exit_code)
> +{
> +}
> +
>  /* Switch to the guest for VHE systems running in EL2 */
>  static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
>  {
> --
> 2.30.2
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
