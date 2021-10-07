Return-Path: <SRS0=Cc05=O3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC0F0C433EF
	for <kvmarm@archiver.kernel.org>; Thu,  7 Oct 2021 16:59:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5466C61261
	for <kvmarm@archiver.kernel.org>; Thu,  7 Oct 2021 16:59:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5466C61261
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AD66C4B2E3;
	Thu,  7 Oct 2021 12:59:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KgK2X6sDpTY3; Thu,  7 Oct 2021 12:59:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9111A4B312;
	Thu,  7 Oct 2021 12:59:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4EBC74B2D6
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Oct 2021 12:59:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0qG5bVbVSSgR for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Oct 2021 12:59:34 -0400 (EDT)
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com
 [209.85.160.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4A03E4B2B3
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Oct 2021 12:59:34 -0400 (EDT)
Received: by mail-qt1-f178.google.com with SMTP id b16so6802898qtt.7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 07 Oct 2021 09:59:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=yStGYIpZvygpVOizwmrRBKxJSbCuOoEwX5b/Zb25tt0=;
 b=mppNOVAEN+ki/T08o63WMJV4P8udEmtmkGOlQa6mcKWowODcCyB3XLnyzMlrqUi1Xt
 wI5mcrEfQgBS+oGPU0FZqxVZwv1pUgMA+7RUVAVU2d+8TzfnfzZQIZtxJh39WKdtcldj
 Knt//D+OuRT2vJoa9q9ajNmswldyLCfxFDP+dd+PID4/BFfOvM70p/DLM9Ue3wAs/k+b
 D8BcOwYQoTXdBHESPulEEW54QXng020cd88Q70TiLf4EESkmarwkLX4bds7s5k9kpbYd
 LOerYpEUJPxMKvXsHykqqKe/fw58OaS1iRAfvMpAHR4rwb/lfsX9NzgcnLw6uPeJCqkB
 crOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=yStGYIpZvygpVOizwmrRBKxJSbCuOoEwX5b/Zb25tt0=;
 b=RZy5i3p/oodjHMMUOqtR5Lld+CKNWufdzFAgaLpb9KR7Wh4kjRP7643lvp31UnR0Ig
 52saSNR8i9MQYcKNosMt55ZTI/jg+1ebhXqfkq0Q8+A4RsZm5jnNrK6049xvzxIHaDR3
 i0d/fJOWdtgXXNh6Bes55zvbRK/1tdh0xnsnIlwJyMEWClCBRp6VZI4oM+EUlSfPFmrS
 anaJccV+Jepem+7M1wj0Ugt7RnRKb+ZU4NXSANww75VUZg9cEXgBUDcx+BWB3JOgysn0
 fpqdHvGD+Jn3lXZjldeCdZ8eL8B/03536CIZDBaBng3PjEjtb5X3ffkSqCqArgPN8zg2
 R6WQ==
X-Gm-Message-State: AOAM533BBx8XZ+ttjHdIm+ySBZ1gGwYL4V247gR+UyeICUrwwuJdcddS
 FKjW4E8G3NnQcpBWfj1es7vSeROhN6SUhCwCjinABQ==
X-Google-Smtp-Source: ABdhPJxTAXIl5n2x/wQHnws8o08Z9GMfP8GXDvCZvrxTPvhcRyUVX7c5KZ+qz0KRjOEopqc7sNJRocOee/a0NptbvdQ=
X-Received: by 2002:a05:622a:4d4:: with SMTP id
 q20mr6376969qtx.57.1633625973690; 
 Thu, 07 Oct 2021 09:59:33 -0700 (PDT)
MIME-Version: 1.0
References: <20211001170553.3062988-1-maz@kernel.org>
In-Reply-To: <20211001170553.3062988-1-maz@kernel.org>
From: Andrew Scull <ascull@google.com>
Date: Thu, 7 Oct 2021 17:59:22 +0100
Message-ID: <CADcWuH0S2-WVN073VkZ1tTf76xemKsbZyjNyC1hBjY+n09dZWQ@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: arm64: Allow KVM to be disabled from the command
 line
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, kernel-team@android.com, Will Deacon <will@kernel.org>,
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

Reviewed-by: Andrew Scull <ascull@google.com>


On Fri, 1 Oct 2021 at 18:06, Marc Zyngier <maz@kernel.org> wrote:
>
> Although KVM can be compiled out of the kernel, it cannot be disabled
> at runtime. Allow this possibility by introducing a new mode that
> will prevent KVM from initialising.
>
> This is useful in the (limited) circumstances where you don't want
> KVM to be available (what is wrong with you?), or when you want
> to install another hypervisor instead (good luck with that).
>
> Reviewed-by: David Brazdil <dbrazdil@google.com>
> Acked-by: Will Deacon <will@kernel.org>
> Acked-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>
> Notes:
>     v2: Dropped the id_aa64mmfr1_vh=0 setting so that KVM can be disabled
>         and yet stay in VHE mode on platforms that require it.
>         I kept the AB/RB's, but please shout if you disagree!
>
>  Documentation/admin-guide/kernel-parameters.txt |  2 ++
>  arch/arm64/include/asm/kvm_host.h               |  1 +
>  arch/arm64/kvm/arm.c                            | 14 +++++++++++++-
>  3 files changed, 16 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 91ba391f9b32..f268731a3d4d 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -2365,6 +2365,8 @@
>         kvm-arm.mode=
>                         [KVM,ARM] Select one of KVM/arm64's modes of operation.
>
> +                       none: Forcefully disable KVM.
> +
>                         nvhe: Standard nVHE-based mode, without support for
>                               protected guests.
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index f8be56d5342b..019490c67976 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -58,6 +58,7 @@
>  enum kvm_mode {
>         KVM_MODE_DEFAULT,
>         KVM_MODE_PROTECTED,
> +       KVM_MODE_NONE,
>  };
>  enum kvm_mode kvm_get_mode(void);
>
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index fe102cd2e518..658171231af9 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -2064,6 +2064,11 @@ int kvm_arch_init(void *opaque)
>                 return -ENODEV;
>         }
>
> +       if (kvm_get_mode() == KVM_MODE_NONE) {
> +               kvm_info("KVM disabled from command line\n");
> +               return -ENODEV;
> +       }
> +
>         in_hyp_mode = is_kernel_in_hyp_mode();
>
>         if (cpus_have_final_cap(ARM64_WORKAROUND_DEVICE_LOAD_ACQUIRE) ||
> @@ -2137,8 +2142,15 @@ static int __init early_kvm_mode_cfg(char *arg)
>                 return 0;
>         }
>
> -       if (strcmp(arg, "nvhe") == 0 && !WARN_ON(is_kernel_in_hyp_mode()))
> +       if (strcmp(arg, "nvhe") == 0 && !WARN_ON(is_kernel_in_hyp_mode())) {
> +               kvm_mode = KVM_MODE_DEFAULT;
>                 return 0;
> +       }
> +
> +       if (strcmp(arg, "none") == 0) {
> +               kvm_mode = KVM_MODE_NONE;
> +               return 0;
> +       }
>
>         return -EINVAL;
>  }
> --
> 2.30.2
>
> --
> To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
