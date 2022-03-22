Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 736F2C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 22 Mar 2022 06:21:36 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C2BA949F18;
	Tue, 22 Mar 2022 02:21:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OrNuMCqDG3vW; Tue, 22 Mar 2022 02:21:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9CFAA49F04;
	Tue, 22 Mar 2022 02:21:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 36B9949EFF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 02:21:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ki4UicrZjMq0 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Mar 2022 02:21:32 -0400 (EDT)
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com
 [209.85.215.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1219040FB6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 02:21:32 -0400 (EDT)
Received: by mail-pg1-f173.google.com with SMTP id t14so11936258pgr.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Mar 2022 23:21:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=MlDVg50YOyjTrz+LPUvEMuC6Q+pwMUWQRH23N2WfOcc=;
 b=AHY2JoSjeQQi3359E/W6STlGQYdMXpKomemMmvkLNZQy5hHXR4Co1gqq+Gh3p5JD/O
 xEy6fzMw9mzkCLbGwnC/du4WMi7LW37LozJD/eGywB6UEoCtGpOtw6cSiIAAHUYsKWY8
 P2DJwgyKWVMoJ6Ywdh7+MNchNmXhc1ecmGvPdZmjmOYBngzGKPt7HlAJJy/ZIjPeVQpR
 kmPDOq8Z6auQKmfF7LJTxnNAnoowN/5jTzaUJXpYOyPrFsCVKaJ/fpg9m/uPz3O2p40R
 ijyc27Egq12zX8JSLGiXXxNd4Fz8LW2r3oikCsyFlEf0y2ZVv66+eU/wSz/PfJAhrZcf
 puvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=MlDVg50YOyjTrz+LPUvEMuC6Q+pwMUWQRH23N2WfOcc=;
 b=JHkzce88PsaSyiMfm0D2ndB8Ytzkcg9kKDBa77xP/mxcdD49Nc7CtgCI30zFEtTFCF
 O28gbYciXWGQbikjXRGXpC6N00ox9O31JV9c5VxMoUG9W0E8BiFLYv6ELobmoMTHlG2y
 sf5+/vkfZyBvsCdhZronLA4OfSLc+1H3RJa46HZS7lze9cbQNXkKXme2BpY33wuH3xM8
 BSl4BnBHCgE4QXJu8fYHhGsojUkY8JtrkXvxG5pX0iAxN9fIjXx9niE+OOfDVl9rOgfH
 XJZqJB3ELca6tWyYTOi09Zh7vmX+sG6jKOmWlwS6fqJTo9VCjFtyQ+L62KhiFJo9TlZm
 bmqA==
X-Gm-Message-State: AOAM531d0hH6desVgL6cXCDPbW8NX/l40vtWS8fvw++X3bSBdmLByyiE
 zdPAwtrWdtpH0b1P5iVbsObB0/mtqUXbjN283zOZGQ==
X-Google-Smtp-Source: ABdhPJyNn1n4A3z47W3l0VM7ClAP6U5wbTDDu4CEdq0uRf0Y68tMVZ7ErqtRab9q+EEQ5/UbjMjJg5vJQ4miclPcAVA=
X-Received: by 2002:a65:56cb:0:b0:378:82ed:d74 with SMTP id
 w11-20020a6556cb000000b0037882ed0d74mr20755604pgs.491.1647930091046; Mon, 21
 Mar 2022 23:21:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220311174001.605719-1-oupton@google.com>
 <20220311174001.605719-9-oupton@google.com>
In-Reply-To: <20220311174001.605719-9-oupton@google.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Mon, 21 Mar 2022 23:21:15 -0700
Message-ID: <CAAeT=FwmU1Ej8zc4wB15TRRH6dH9xK7621gO12ib2QjHW11=NA@mail.gmail.com>
Subject: Re: [PATCH v4 08/15] KVM: arm64: Return a value from
 check_vcpu_requests()
To: Oliver Upton <oupton@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Wanpeng Li <wanpengli@tencent.com>,
 kvm@vger.kernel.org, Joerg Roedel <joro@8bytes.org>,
 Peter Shier <pshier@google.com>, kvm-riscv@lists.infradead.org,
 Atish Patra <atishp@atishpatra.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, kvmarm@lists.cs.columbia.edu,
 Jim Mattson <jmattson@google.com>
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

Hi Oliver,

On Fri, Mar 11, 2022 at 9:41 AM Oliver Upton <oupton@google.com> wrote:
>
> A subsequent change to KVM will introduce a vCPU request that could
> result in an exit to userspace. Change check_vcpu_requests() to return a
> value and document the function. Unconditionally return 1 for now.
>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/arm64/kvm/arm.c | 16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 7c297ddc8177..8eed0556ccaa 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -648,7 +648,16 @@ void kvm_vcpu_wfi(struct kvm_vcpu *vcpu)
>         preempt_enable();
>  }
>
> -static void check_vcpu_requests(struct kvm_vcpu *vcpu)
> +/**
> + * check_vcpu_requests - check and handle pending vCPU requests
> + * @vcpu:      the VCPU pointer
> + *
> + * Return: 1 if we should enter the guest
> + *        0 if we should exit to userspace
> + *        <= 0 if we should exit to userspace, where the return value indicates
> + *        an error

Nit: Shouldn't "<= 0" be "< 0" ?

Thanks,
Reiji


> + */
> +static int check_vcpu_requests(struct kvm_vcpu *vcpu)
>  {
>         if (kvm_request_pending(vcpu)) {
>                 if (kvm_check_request(KVM_REQ_SLEEP, vcpu))
> @@ -678,6 +687,8 @@ static void check_vcpu_requests(struct kvm_vcpu *vcpu)
>                         kvm_pmu_handle_pmcr(vcpu,
>                                             __vcpu_sys_reg(vcpu, PMCR_EL0));
>         }
> +
> +       return 1;
>  }
>
>  static bool vcpu_mode_is_bad_32bit(struct kvm_vcpu *vcpu)
> @@ -793,7 +804,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>                 if (!ret)
>                         ret = 1;
>
> -               check_vcpu_requests(vcpu);
> +               if (ret > 0)
> +                       ret = check_vcpu_requests(vcpu);
>
>                 /*
>                  * Preparing the interrupts to be injected also
> --
> 2.35.1.723.g4982287a31-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
