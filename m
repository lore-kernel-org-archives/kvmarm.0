Return-Path: <SRS0=mpH5=NJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A00B0C4338F
	for <kvmarm@archiver.kernel.org>; Wed, 18 Aug 2021 21:34:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 14FCD610FF
	for <kvmarm@archiver.kernel.org>; Wed, 18 Aug 2021 21:34:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 14FCD610FF
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 81EBD4086D;
	Wed, 18 Aug 2021 17:34:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WMaNAdZeocpA; Wed, 18 Aug 2021 17:34:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C4C44B0AD;
	Wed, 18 Aug 2021 17:34:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4007C49E57
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Aug 2021 17:34:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yGEe-9951cKp for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Aug 2021 17:34:16 -0400 (EDT)
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com
 [209.85.208.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B076F4086D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Aug 2021 17:34:16 -0400 (EDT)
Received: by mail-lj1-f171.google.com with SMTP id d16so7671381ljq.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Aug 2021 14:34:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=fIJMBP+oNGnAAKwmFqWtXv81MB4wkUEraz55M0YB7rs=;
 b=foqb7b1M4tTMZr+19gT0KatyK3YWAxVGmDQTr25cXFLF0MNddFFoCuyzPU0hKkbF5a
 L529T14lULjeLlBYc/lRwonH7BG1vdlrvQ76+jec+Jmwslwl/bx33sJk1a80NEkgWDJS
 HM5nvMVR4Y0+7o7t6UkBRIJbb2oaEXr9QC0e9AJtm/n3qgnTfaeFWklKZ58KnlbhfU1S
 LdXrfUwhrrXFFMf9PAFN3C5/y92KRFtOqrgDf6Tx8HSnt7CRihSzYyrODXSIxppqerAv
 Yi/lSAFuOYtEDMuVLEtd4fGzXfFWKV4CywjxWbuMW62mfWceZEi4UwRF6WZoBAoGXnVr
 2qyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=fIJMBP+oNGnAAKwmFqWtXv81MB4wkUEraz55M0YB7rs=;
 b=ijKsZTfJzL67y3bF3dAK9lX2ba//xeRDnsxFrSmA38wd2JHmlkSuyjsasf9a5E4pGb
 YLYpkmAeQ48vayuQ9AZ6GlmZF5sEXJi466+ucXha6qNQVGU5YktQRPQ60dG6lYfqVlf/
 uSN0lP0SsHjoJE3P8YX46cYUd5+4ooDDJHF2+7SkP03vqGctgyzvzDdzofrrJQ1/Cxh9
 Z2qVNo8I+sgWvcRAoJmELaWyM3YPd2t8erTcvcCcCprR8677GigAdHGocEdxC/J+BlNZ
 b+OGl+qFUZeMJbjkkBr7ZQ8B8iSumrusrS33BCHG9TpDXg5ufRTjNUdtJuiPcMYAr/Zv
 wyUw==
X-Gm-Message-State: AOAM530WlxHELvdlelPuqmg/sMG6Vc/OXY6++1AqhySAO1FqIgvnhOgo
 DwQ64Ej/MgInlcqe00uPySpFfZNqeHRB/waAxgTWpQ==
X-Google-Smtp-Source: ABdhPJzdkFHv/DoVrFmnB5SXoPKGwHxKK4vShunyvprddeq1JJO2GNWpXj1AvWJsXXOV9c+ZzuVZMpwPaSIXCFPJT5Q=
X-Received: by 2002:a2e:a782:: with SMTP id c2mr9537367ljf.388.1629322454756; 
 Wed, 18 Aug 2021 14:34:14 -0700 (PDT)
MIME-Version: 1.0
References: <20210818213205.598471-1-ricarkol@google.com>
In-Reply-To: <20210818213205.598471-1-ricarkol@google.com>
From: Oliver Upton <oupton@google.com>
Date: Wed, 18 Aug 2021 14:34:03 -0700
Message-ID: <CAOQ_QshVenuri8WdZdEis4szCv03U0KRNt4CqDNtvUBsqBqUoA@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: vgic: drop WARN from vgic_get_irq
To: Ricardo Koller <ricarkol@google.com>
Cc: kvm@vger.kernel.org, maz@kernel.org, rananta@google.com, pshier@google.com,
 catalin.marinas@arm.com, kvmarm@lists.cs.columbia.edu
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

Hi Ricardo,

On Wed, Aug 18, 2021 at 2:32 PM Ricardo Koller <ricarkol@google.com> wrote:
>
> vgic_get_irq(intid) is used all over the vgic code in order to get a
> reference to a struct irq. It warns whenever intid is not a valid number
> (like when it's a reserved IRQ number). The issue is that this warning
> can be triggered from userspace (e.g., KVM_IRQ_LINE for intid 1020).
>
> Drop the WARN call from vgic_get_irq.
>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  arch/arm64/kvm/vgic/vgic.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
> index 111bff47e471..81cec508d413 100644
> --- a/arch/arm64/kvm/vgic/vgic.c
> +++ b/arch/arm64/kvm/vgic/vgic.c
> @@ -106,7 +106,6 @@ struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
>         if (intid >= VGIC_MIN_LPI)
>                 return vgic_get_lpi(kvm, intid);
>
> -       WARN(1, "Looking up struct vgic_irq for reserved INTID");

Could we maybe downgrade the message to WARN_ONCE() (to get a stack)
or pr_warn_ratelimited()? I agree it is problematic that userspace can
cause this WARN to fire, but it'd be helpful for debugging too.

--
Thanks,
Oliver

>         return NULL;
>  }
>
> --
> 2.33.0.rc2.250.ged5fa647cd-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
