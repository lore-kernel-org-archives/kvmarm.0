Return-Path: <SRS0=CSPl=AN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B347C433DF
	for <kvmarm@archiver.kernel.org>; Thu,  2 Jul 2020 14:05:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F3FFC20899
	for <kvmarm@archiver.kernel.org>; Thu,  2 Jul 2020 14:05:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="a+aiKaeu"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F3FFC20899
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9CC654B5FE;
	Thu,  2 Jul 2020 10:05:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3rBAFqXAndP9; Thu,  2 Jul 2020 10:04:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 434C74B5D7;
	Thu,  2 Jul 2020 10:04:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F12EA4B5D2
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2020 10:04:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0Hu0m-wh6xPz for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Jul 2020 10:04:56 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C89234B4D2
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2020 10:04:56 -0400 (EDT)
Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com
 [209.85.167.176])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id B454120CC7
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2020 14:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1593698695;
 bh=kA50VBMMrGdrE3xQ5v88BLtSVM3GvpTTysDMHRSjmko=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=a+aiKaeuTklSMSmtg/vA3HtvjPu26UYvgY252wgBZA006pvwDB0gJQEuZgJODWpQp
 CMU5OPvfV3mXBDU9Bjh0vZByGx5Ek+eqAAMwOK4AOrnuIGOGeU+zCpHNxZu45uExM2
 4rmZjTQZWgSvjaIjKF00J96/8oBwBoQDFf+9L/x0=
Received: by mail-oi1-f176.google.com with SMTP id t4so5930551oij.9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 02 Jul 2020 07:04:55 -0700 (PDT)
X-Gm-Message-State: AOAM531FiVd3wZEVAWhWqzg3ay9dbbFLrZELjqkSQMDuxqdXQ4XdBxQy
 227UwMR++zNtFtB9nYQU/EUkYmTBvtPOag2P1A==
X-Google-Smtp-Source: ABdhPJzrROq+VU/GH93IJWKW6WzvKUKB+YcooXfMjvvTdLnExXgvVy4cZjq/+hv19pvd+ndH7K9GFY4fG46Ww9CIFFc=
X-Received: by 2002:aca:30d2:: with SMTP id w201mr3133804oiw.147.1593698695101; 
 Thu, 02 Jul 2020 07:04:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200701215308.3715856-1-robh@kernel.org>
 <20200701215308.3715856-2-robh@kernel.org>
 <20200702114527.GB16499@willie-the-truck>
In-Reply-To: <20200702114527.GB16499@willie-the-truck>
From: Rob Herring <robh@kernel.org>
Date: Thu, 2 Jul 2020 08:04:43 -0600
X-Gmail-Original-Message-ID: <CAL_JsqLnZHXjnYf3s6FJnVKf4kN1fhRgJov=Sb3H6J=Yro+cQg@mail.gmail.com>
Message-ID: <CAL_JsqLnZHXjnYf3s6FJnVKf4kN1fhRgJov=Sb3H6J=Yro+cQg@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] KVM: arm64: Print warning when cpu erratum can
 cause guests to deadlock
To: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE"
 <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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

On Thu, Jul 2, 2020 at 5:45 AM Will Deacon <will@kernel.org> wrote:
>
> On Wed, Jul 01, 2020 at 03:53:06PM -0600, Rob Herring wrote:
> > If guests don't have certain CPU erratum work-arounds implemented, then
> > there is a possibility a guest can deadlock the system. IOW, only trusted
> > guests should be used on systems with the erratum.
> >
> > This is the case for Cortex-A57 erratum 832075.
> >
> > Cc: Marc Zyngier <maz@kernel.org>
> > Cc: James Morse <james.morse@arm.com>
> > Cc: Julien Thierry <julien.thierry.kdev@gmail.com>
> > Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > Cc: Will Deacon <will@kernel.org>
> > Cc: kvmarm@lists.cs.columbia.edu
> > Signed-off-by: Rob Herring <robh@kernel.org>
> > ---
> >  arch/arm64/kvm/arm.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 90cb90561446..e2f50fa4d825 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -1653,6 +1653,10 @@ int kvm_arch_init(void *opaque)
> >               return -ENODEV;
> >       }
> >
> > +     if (cpus_have_const_cap(ARM64_WORKAROUND_DEVICE_LOAD_ACQUIRE))
> > +             kvm_info("Guests without required CPU erratum work-arounds can deadlock system!\n" \
>
> work-arounds => workarounds
>
> (mainly for consistency, I have no clue if this is a real word or not!).
>
> I'd also probably do erratum => errata given that you're about to add a
> second one.

Humm, the plural is on workarounds. If I use a more standard singular
vs. plural form like "CPU feature workarounds" vs "CPU features
workarounds", the former seems more correct to me. (working around
features may be a bit nonsensical, but big.LITTLE ;) )

Rob
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
