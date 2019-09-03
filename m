Return-Path: <SRS0=67XK=W6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69E5FC3A5A2
	for <kvmarm@archiver.kernel.org>; Tue,  3 Sep 2019 11:34:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DB00E22CF7
	for <kvmarm@archiver.kernel.org>; Tue,  3 Sep 2019 11:34:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wDvVk5e0"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DB00E22CF7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 324104A4F5;
	Tue,  3 Sep 2019 07:34:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 54KuD9QDUzkc; Tue,  3 Sep 2019 07:34:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F2E1B4A554;
	Tue,  3 Sep 2019 07:34:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C9CD14A4FE
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Sep 2019 07:34:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BIE8AoiQdkph for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 Sep 2019 07:33:59 -0400 (EDT)
Received: from mail-ot1-f66.google.com (mail-ot1-f66.google.com
 [209.85.210.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B572C4A4F5
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Sep 2019 07:33:59 -0400 (EDT)
Received: by mail-ot1-f66.google.com with SMTP id n7so8959310otk.6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 03 Sep 2019 04:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=XtxHXKLfW5QJwBGA+RR9lcAadfuUNqWWH2+7dJcY6l8=;
 b=wDvVk5e0nozBCiHVpIJ1ag0McMj21a4LnQhk0VwHhzsl21zYG3/FYXtHN/gUQR/qwI
 DQ4nXwRjv+5mKj4QwJcpR0ZAN3IhvqFizCBzmL1ZNU0hnKclsxK56/VuG73N2ZAtpxSA
 0Qj1vwhiPppNFvUDzZ7vZbEa7IYHFa0HjqZktvpweEF6+6yOecujjcAGJ30EBIat4pIQ
 y64j6SBsRT3rCskUD0jU9xXYh6EcT1sftyeldRF4iEeAibREHceCb3sJKew1Hc0qEPWh
 I+FPgFDTiENXz/Xu+DWTL5cinxcSaGb7hgdzGTRAJwjPSGaskJrTfLTWUWrBW4DO8yZs
 xS/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=XtxHXKLfW5QJwBGA+RR9lcAadfuUNqWWH2+7dJcY6l8=;
 b=Ogl8t9v32FcPxbU2cEHWJi79QT8KhY+vRF7OQhQkP5BpLpEsTzp3pZvSbbRu04fauw
 sPkLCKcd+YSLXxHgC/MpMjRoRZ1mklkIoTPOi5JfHGhKyIpj2VLo8goCGDA+9mW7HtC6
 m8UIpQ9lC05qk/S2ZQZO13NAwiyvEcw+8JDQcZjfQg0OmCFUmdtFA6pZ6SzlBtNQ4xkS
 fOoccPwwbScKRr5g8NLFC5l7uJNuEBkh+a1UBAu0rQpq40PrWg1NoAam4Qbgm9vQLZhS
 WHn770+53bcgixf/SX+uH0ViE38Ji2HQq315B3RZfiYd3ibA6VLHodfbWi6QPiBwCt4M
 WYhA==
X-Gm-Message-State: APjAAAUO5U79msm6Bu2a0Pf0e3Z+E+a/ayNYF07/DgthFKjlZe7FvXbx
 G6c45PCClu6uw4kJWXVKo3dm3f5JHutKos1X1eJcgg==
X-Google-Smtp-Source: APXvYqyoKS7/0TF1tdmLXrX9ofvDMLr2r/p8mHmpyBd5yntAm033XmhU1CGaf4hTCyzl8TYx1jaWNrydF4XT7x42HGQ=
X-Received: by 2002:a9d:5e10:: with SMTP id d16mr28380255oti.91.1567510439153; 
 Tue, 03 Sep 2019 04:33:59 -0700 (PDT)
MIME-Version: 1.0
References: <20190818140710.23920-1-maz@kernel.org>
In-Reply-To: <20190818140710.23920-1-maz@kernel.org>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Tue, 3 Sep 2019 12:33:48 +0100
Message-ID: <CAFEAcA-25Cm9ZgSkgXDomEs7jt4sn4z3GeXLt4hvU4P1D0vJCA@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm/arm64: vgic: Allow more than 256 vcpus for
 KVM_IRQ_LINE
To: Marc Zyngier <maz@kernel.org>
Cc: kvm-devel <kvm@vger.kernel.org>, qemu-arm <qemu-arm@nongnu.org>,
 kvmarm@lists.cs.columbia.edu,
 arm-mail-list <linux-arm-kernel@lists.infradead.org>
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

On Sun, 18 Aug 2019 at 15:07, Marc Zyngier <maz@kernel.org> wrote:
>
> While parts of the VGIC support a large number of vcpus (we
> bravely allow up to 512), other parts are more limited.
>
> One of these limits is visible in the KVM_IRQ_LINE ioctl, which
> only allows 256 vcpus to be signalled when using the CPU or PPI
> types. Unfortunately, we've cornered ourselves badly by allocating
> all the bits in the irq field.
>
> Since the irq_type subfield (8 bit wide) is currently only taking
> the values 0, 1 and 2 (and we have been careful not to allow anything
> else), let's reduce this field to only 4 bits, and allocate the
> remaining 4 bits to a vcpu2_index, which acts as a multiplier:
>
>   vcpu_id = 256 * vcpu2_index + vcpu_index
>
> With that, and a new capability (KVM_CAP_ARM_IRQ_LINE_LAYOUT_2)
> allowing this to be discovered, it becomes possible to inject
> PPIs to up to 4096 vcpus. But please just don't.
>
> Reported-by: Zenghui Yu <yuzenghui@huawei.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

> diff --git a/Documentation/virt/kvm/api.txt b/Documentation/virt/kvm/api.txt
> index 2d067767b617..85518bfb2a99 100644
> --- a/Documentation/virt/kvm/api.txt
> +++ b/Documentation/virt/kvm/api.txt
> @@ -753,8 +753,8 @@ in-kernel irqchip (GIC), and for in-kernel irqchip can tell the GIC to
>  use PPIs designated for specific cpus.  The irq field is interpreted
>  like this:
>
> -  bits:  | 31 ... 24 | 23  ... 16 | 15    ...    0 |
> -  field: | irq_type  | vcpu_index |     irq_id     |
> +  bits:  |  31 ... 28  | 27 ... 24 | 23  ... 16 | 15 ... 0 |
> +  field: | vcpu2_index | irq_type  | vcpu_index |  irq_id  |
>
>  The irq_type field has the following values:
>  - irq_type[0]: out-of-kernel GIC: irq_id 0 is IRQ, irq_id 1 is FIQ
> @@ -766,6 +766,10 @@ The irq_type field has the following values:
>
>  In both cases, level is used to assert/deassert the line.
>
> +When KVM_CAP_ARM_IRQ_LINE_LAYOUT_2 is supported, the target vcpu is
> +identified as (256 * vcpu2_index + vcpu_index). Otherwise, vcpu2_index
> +must be zero.
> +
>  struct kvm_irq_level {
>         union {
>                 __u32 irq;     /* GSI */

> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index 35a069815baf..c1385911de69 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -182,6 +182,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>         int r;
>         switch (ext) {
>         case KVM_CAP_IRQCHIP:
> +       case KVM_CAP_ARM_IRQ_LINE_LAYOUT_2:
>                 r = vgic_present;
>                 break;

Shouldn't we be advertising the capability always, not just if
the VGIC is present? The KVM_IRQ_LINE ioctl can be used for
directly signalling IRQs to vCPUs even if we're using an
out-of-kernel irqchip model.

The general principle of the API change/extension looks OK to me.

thanks
-- PMM
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
