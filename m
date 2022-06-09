Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01BACC43334
	for <kvmarm@archiver.kernel.org>; Thu,  9 Jun 2022 06:16:10 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7BBF14A531;
	Thu,  9 Jun 2022 02:16:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TzLHg7BCINci; Thu,  9 Jun 2022 02:16:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 49A414B15C;
	Thu,  9 Jun 2022 02:16:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9566D4B0EC
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jun 2022 02:16:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RXX5RpYKB81J for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Jun 2022 02:16:07 -0400 (EDT)
Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com
 [209.85.160.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1D46649F35
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jun 2022 02:16:07 -0400 (EDT)
Received: by mail-oa1-f54.google.com with SMTP id
 586e51a60fabf-e656032735so29949486fac.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 08 Jun 2022 23:16:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=/Z/1XTBKe1QWw98t46G1hNo7RgHv61Hc5Y6PJukHBko=;
 b=fkv+CAJR3Ffi7S0b0VTixB/Pb7JeMn6ZtnJSPTbyo34o893ptmubNaOhtImaGIow5/
 hBT02/qz5ELlaAuyx5hof3GQb79MONUthEXjruk2Pm6cxRXuAg6FKLqt8azO/XZXOpMW
 cjqv2dhW8KgLtX7WI9cm4S/v/v1KTdSkZwDKwgY7Ym4nrvHmXXHY4uVyiGpvtwqDMf8Q
 wzM0WHOAZ4WLuDIC5i4+pgMaWgCct3Cf98a7luDufg0HAIZINbx/+knXTBSmWLYmEw1B
 KWbFicxkMimB2vSE+uag41fob+QqwYqTc1nUV+dgY67jry3oIIQC9G7dBC9GZY/8QbKn
 pyew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=/Z/1XTBKe1QWw98t46G1hNo7RgHv61Hc5Y6PJukHBko=;
 b=cAlgiJraSNNj+0apZPAwxHmCgdvAh2BxHKi85XjS8Yy7e0NOholI4Z0vV8/vJlhN31
 8Zvt5lp1T6ysmFiQeJ1qO8MgddLRAXwHq16CZrrpaftHZfEx5eMIJ85enGHCnrcb/fvG
 RHhKPN0NlhWhw8ZmeGuQA6/eSXG1rStFPFNCX3TsfD9Wz8tPX6jCVSAwR5NCutbz8RAE
 TZZoEnYIEuhlvb6CTA6jbU8xcASuPJ9yib/8Lpzqb7iVPuQb5SmcmrM6xWSCCQ5GTDKp
 skzOXiF5p4KZl/M2iJ4OlJuT8WsaqMMw1u+lktjOBvEmuKFllf6F7MNvT4wN7BjiZmL7
 rKzg==
X-Gm-Message-State: AOAM530i78GaXNEwO/Htxtb/5MOYcEwozjN7m97KSIvQDlv1yRcsG+dH
 PatWiArM6N+NJcO0LLxQ+Z2FGE77LF8h7GfgqhzBaQ==
X-Google-Smtp-Source: ABdhPJxuZNri2roMZCEB2LGASmwWsTjThZXGjNAEetdXoOcgFQbw6VAtsZpP1s2K4b8NuHuoFRKboLKUW48EoyIanrs=
X-Received: by 2002:a05:6870:5a8:b0:f4:2cf8:77eb with SMTP id
 m40-20020a05687005a800b000f42cf877ebmr844978oap.16.1654755366304; Wed, 08 Jun
 2022 23:16:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220528113829.1043361-1-maz@kernel.org>
 <20220528113829.1043361-8-maz@kernel.org>
In-Reply-To: <20220528113829.1043361-8-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Wed, 8 Jun 2022 23:15:50 -0700
Message-ID: <CAAeT=FxVHfUH0=bvNxxU=L0oQk9utjeQGuozRkdSQnTMHwgaKg@mail.gmail.com>
Subject: Re: [PATCH 07/18] KVM: arm64: Move vcpu configuration flags into
 their own set
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, kernel-team@android.com,
 Mark Brown <broonie@kernel.org>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, Linux ARM <linux-arm-kernel@lists.infradead.org>
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

On Sat, May 28, 2022 at 4:38 AM Marc Zyngier <maz@kernel.org> wrote:
>
> The KVM_ARM64_{GUEST_HAS_SVE,VCPU_SVE_FINALIZED,GUEST_HAS_PTRAUTH}
> flags are purely configuration flags. Once set, they are never cleared,
> but evaluated all over the code base.
>
> Move these three flags into the configuration set in one go, using
> the new accessors, and take this opportunity to drop the KVM_ARM64_
> prefix which doesn't provide any help.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h | 17 ++++++++++-------
>  arch/arm64/kvm/reset.c            |  6 +++---
>  2 files changed, 13 insertions(+), 10 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index c9dd0d4e22f2..2b8f1265eade 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -459,6 +459,13 @@ struct kvm_vcpu_arch {
>  #define __flag_unpack(_set, _f, _m)    _f
>  #define vcpu_flag_unpack(...)          __flag_unpack(__VA_ARGS__)
>
> +/* SVE exposed to guest */
> +#define GUEST_HAS_SVE          __vcpu_single_flag(cflags, BIT(0))
> +/* SVE config completed */
> +#define VCPU_SVE_FINALIZED     __vcpu_single_flag(cflags, BIT(1))
> +/* PTRAUTH exposed to guest */
> +#define GUEST_HAS_PTRAUTH      __vcpu_single_flag(cflags, BIT(2))
> +
>
>  /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
>  #define vcpu_sve_pffr(vcpu) (kern_hyp_va((vcpu)->arch.sve_state) +     \
> @@ -483,9 +490,6 @@ struct kvm_vcpu_arch {
>  /* vcpu_arch flags field values: */
>  #define KVM_ARM64_DEBUG_DIRTY          (1 << 0)
>  #define KVM_ARM64_HOST_SVE_ENABLED     (1 << 4) /* SVE enabled for EL0 */
> -#define KVM_ARM64_GUEST_HAS_SVE                (1 << 5) /* SVE exposed to guest */
> -#define KVM_ARM64_VCPU_SVE_FINALIZED   (1 << 6) /* SVE config completed */
> -#define KVM_ARM64_GUEST_HAS_PTRAUTH    (1 << 7) /* PTRAUTH exposed to guest */
>  #define KVM_ARM64_PENDING_EXCEPTION    (1 << 8) /* Exception pending */
>  /*
>   * Overlaps with KVM_ARM64_EXCEPT_MASK on purpose so that it can't be
> @@ -522,13 +526,13 @@ struct kvm_vcpu_arch {
>                                  KVM_GUESTDBG_SINGLESTEP)
>
>  #define vcpu_has_sve(vcpu) (system_supports_sve() &&                   \
> -                           ((vcpu)->arch.flags & KVM_ARM64_GUEST_HAS_SVE))
> +                           vcpu_get_flag((vcpu), GUEST_HAS_SVE))

Minor nit: The parentheses around the vcpu above would be unnecessary.
(as was omitted for vcpu_has_ptrauth/kvm_arm_vcpu_sve_finalized)

Reviewed-by: Reiji Watanabe <reijiw@google.com>

The new infrastructure for those flags looks nice.

Thanks!
Reiji



>
>  #ifdef CONFIG_ARM64_PTR_AUTH
>  #define vcpu_has_ptrauth(vcpu)                                         \
>         ((cpus_have_final_cap(ARM64_HAS_ADDRESS_AUTH) ||                \
>           cpus_have_final_cap(ARM64_HAS_GENERIC_AUTH)) &&               \
> -        (vcpu)->arch.flags & KVM_ARM64_GUEST_HAS_PTRAUTH)
> +         vcpu_get_flag(vcpu, GUEST_HAS_PTRAUTH))
>  #else
>  #define vcpu_has_ptrauth(vcpu)         false
>  #endif
> @@ -885,8 +889,7 @@ void kvm_init_protected_traps(struct kvm_vcpu *vcpu);
>  int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int feature);
>  bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
>
> -#define kvm_arm_vcpu_sve_finalized(vcpu) \
> -       ((vcpu)->arch.flags & KVM_ARM64_VCPU_SVE_FINALIZED)
> +#define kvm_arm_vcpu_sve_finalized(vcpu) vcpu_get_flag(vcpu, VCPU_SVE_FINALIZED)
>
>  #define kvm_has_mte(kvm)                                       \
>         (system_supports_mte() &&                               \
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index 6c70c6f61c70..0e08fbe68715 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -81,7 +81,7 @@ static int kvm_vcpu_enable_sve(struct kvm_vcpu *vcpu)
>          * KVM_REG_ARM64_SVE_VLS.  Allocation is deferred until
>          * kvm_arm_vcpu_finalize(), which freezes the configuration.
>          */
> -       vcpu->arch.flags |= KVM_ARM64_GUEST_HAS_SVE;
> +       vcpu_set_flag(vcpu, GUEST_HAS_SVE);
>
>         return 0;
>  }
> @@ -120,7 +120,7 @@ static int kvm_vcpu_finalize_sve(struct kvm_vcpu *vcpu)
>         }
>
>         vcpu->arch.sve_state = buf;
> -       vcpu->arch.flags |= KVM_ARM64_VCPU_SVE_FINALIZED;
> +       vcpu_set_flag(vcpu, VCPU_SVE_FINALIZED);
>         return 0;
>  }
>
> @@ -177,7 +177,7 @@ static int kvm_vcpu_enable_ptrauth(struct kvm_vcpu *vcpu)
>             !system_has_full_ptr_auth())
>                 return -EINVAL;
>
> -       vcpu->arch.flags |= KVM_ARM64_GUEST_HAS_PTRAUTH;
> +       vcpu_set_flag(vcpu, GUEST_HAS_PTRAUTH);
>         return 0;
>  }
>
> --
> 2.34.1
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
