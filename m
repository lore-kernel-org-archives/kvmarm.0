Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0325C43334
	for <kvmarm@archiver.kernel.org>; Wed,  8 Jun 2022 15:17:36 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 75C2D4B10B;
	Wed,  8 Jun 2022 11:17:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id e73L-6eeRiwc; Wed,  8 Jun 2022 11:17:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B49E4B25C;
	Wed,  8 Jun 2022 11:17:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C1D424B10B
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jun 2022 11:17:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eHUJ5C2ewPT1 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Jun 2022 11:17:32 -0400 (EDT)
Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com
 [209.85.167.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9578849F5D
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jun 2022 11:17:32 -0400 (EDT)
Received: by mail-oi1-f180.google.com with SMTP id w16so18576252oie.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 08 Jun 2022 08:17:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=VlFFsM0vokhDlBPR30yxEKtEVSOVohVHRPtlqVM7p4c=;
 b=NXMtuu4RASXFiLHNwNTM2NV/7eIyypEdCAzOxvmY3JUnnnQJFRDGvSRq/OfW7W8HiL
 xy+WWDZjp9bUHiz/qLV4UEX8zVWjQMhliROaWK27VZ6z1Mxkyr4YvJOPOOt47iKx2Y8a
 mdxMkgIgPfE+B4lVYWo8ltVL0dV8qNGV+3MBhCok1TQabTCpD+mSeZeB/K/n5hctyrlI
 djasKhQNBlnNq1fY3grB/0wQrBYNkGZcYAZn8OE5obUdZAgN47EVlv/Mm85DDi5U82Nc
 ELhJRFzr5PykyL8LEt5IZ6PBKeuzQqsRkN/TNxn+PMb3qQ6CPdFyxf/sN3jg5qUVHJpk
 SDgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=VlFFsM0vokhDlBPR30yxEKtEVSOVohVHRPtlqVM7p4c=;
 b=pL4EG7QokBQILfAOJb3oGsGARiOqVGpIMbPC/Axw931k9GrwRwhkt6eSXg2PO0QCmc
 UFlRwfZiK0WOEERlNPo9Qucoo8GgBRi0Nu6UivOu7SjPs3wMu0ZoQb9D6PeJXBBzCPH1
 6CH1Gk3i+bKsQ2WQM6w6OYAVULXtcXK9gc40565n1pMAkx6H/19EGaUbOQDfPadAp8O1
 p2ZgX8G6ptLhSbdeB4ib+Q7LWHAATwcLzvXKuOMc4ztSpNSt2a/PP47mqSLFyzQAPOfJ
 I0emCNMRiS11xi4syQrWd5ya+ILBavSaB1eHm3/yf/QLUlATb4ffsnFOgBaiPz81Xdb8
 ltRQ==
X-Gm-Message-State: AOAM531fu7TGrbaOjC07LhJjUvYuHUPDYit3mYVhZE1ZA22uNDzdHOYb
 ZrTq2EnSpTJJlK8nzRFSeo/Lpoayhh4NmI7Pz/j+CQ==
X-Google-Smtp-Source: ABdhPJxnpsuzj2vDd3Hr296o3dKVf0rqE6EvPPFUkQ3V1TX/N0nEd0b4JHWjPSVChOaJdBvJ3B1fyhijGVQUOJ2IcoI=
X-Received: by 2002:a05:6808:19a7:b0:32b:3cef:631 with SMTP id
 bj39-20020a05680819a700b0032b3cef0631mr2749669oib.294.1654701451827; Wed, 08
 Jun 2022 08:17:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220528113829.1043361-1-maz@kernel.org>
 <20220528113829.1043361-16-maz@kernel.org>
In-Reply-To: <20220528113829.1043361-16-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 8 Jun 2022 16:16:55 +0100
Message-ID: <CA+EHjTyW62HaJdH_L1RMBzQpzkNbFBAYpXQ-y_Wg4u1a2eVJwA@mail.gmail.com>
Subject: Re: [PATCH 15/18] KVM: arm64: Warn when PENDING_EXCEPTION and
 INCREMENT_PC are set together
To: Marc Zyngier <maz@kernel.org>
Cc: kernel-team@android.com, kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Mark Brown <broonie@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

Hi Marc,

On Sat, May 28, 2022 at 12:49 PM Marc Zyngier <maz@kernel.org> wrote:
>
> We really don't want PENDING_EXCEPTION and INCREMENT_PC to ever be
> set at the same time, as they are mutually exclusive. Add checks
> that will generate a warning should this ever happen.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_emulate.h | 1 +
>  arch/arm64/kvm/hyp/nvhe/sys_regs.c   | 2 ++
>  arch/arm64/kvm/inject_fault.c        | 8 ++++++++
>  3 files changed, 11 insertions(+)
>
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index 46e631cd8d9e..861fa0b24a7f 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -473,6 +473,7 @@ static inline unsigned long vcpu_data_host_to_guest(struct kvm_vcpu *vcpu,
>
>  static __always_inline void kvm_incr_pc(struct kvm_vcpu *vcpu)
>  {
> +       WARN_ON(vcpu_get_flag(vcpu, PENDING_EXCEPTION));
>         vcpu_set_flag(vcpu, INCREMENT_PC);
>  }
>
> diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> index 2841a2d447a1..04973984b6db 100644
> --- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> +++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> @@ -38,6 +38,8 @@ static void inject_undef64(struct kvm_vcpu *vcpu)
>         *vcpu_pc(vcpu) = read_sysreg_el2(SYS_ELR);
>         *vcpu_cpsr(vcpu) = read_sysreg_el2(SYS_SPSR);
>
> +       WARN_ON(vcpu_get_flag(vcpu, INCREMENT_PC));
> +
>         vcpu_set_flag(vcpu, PENDING_EXCEPTION);
>         vcpu_set_flag(vcpu, EXCEPT_AA64_EL1_SYNC);
>
> diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
> index a9a7b513f3b0..2f4b9afc16ec 100644
> --- a/arch/arm64/kvm/inject_fault.c
> +++ b/arch/arm64/kvm/inject_fault.c
> @@ -20,6 +20,8 @@ static void inject_abt64(struct kvm_vcpu *vcpu, bool is_iabt, unsigned long addr
>         bool is_aarch32 = vcpu_mode_is_32bit(vcpu);
>         u32 esr = 0;
>
> +       WARN_ON(vcpu_get_flag(vcpu, INCREMENT_PC));
> +

Minor nit: While we're at it, should we just create a helper for
setting PENDING_EXCEPTION, same as we have for INCREMENT_PC? That
might make the code clearer and save us from the hassle of having this
WARN_ON before every instance of setting PENDING_EXCEPTION?

Cheers,
/fuad



>         vcpu_set_flag(vcpu, PENDING_EXCEPTION);
>         vcpu_set_flag(vcpu, EXCEPT_AA64_EL1_SYNC);
>
> @@ -51,6 +53,8 @@ static void inject_undef64(struct kvm_vcpu *vcpu)
>  {
>         u32 esr = (ESR_ELx_EC_UNKNOWN << ESR_ELx_EC_SHIFT);
>
> +       WARN_ON(vcpu_get_flag(vcpu, INCREMENT_PC));
> +
>         vcpu_set_flag(vcpu, PENDING_EXCEPTION);
>         vcpu_set_flag(vcpu, EXCEPT_AA64_EL1_SYNC);
>
> @@ -71,6 +75,8 @@ static void inject_undef64(struct kvm_vcpu *vcpu)
>
>  static void inject_undef32(struct kvm_vcpu *vcpu)
>  {
> +       WARN_ON(vcpu_get_flag(vcpu, INCREMENT_PC));
> +
>         vcpu_set_flag(vcpu, PENDING_EXCEPTION);
>         vcpu_set_flag(vcpu, EXCEPT_AA32_UND);
>  }
> @@ -94,6 +100,8 @@ static void inject_abt32(struct kvm_vcpu *vcpu, bool is_pabt, u32 addr)
>
>         far = vcpu_read_sys_reg(vcpu, FAR_EL1);
>
> +       WARN_ON(vcpu_get_flag(vcpu, INCREMENT_PC));
> +
>         if (is_pabt) {
>                 vcpu_set_flag(vcpu, PENDING_EXCEPTION);
>                 vcpu_set_flag(vcpu, EXCEPT_AA32_IABT);
> --
> 2.34.1
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
