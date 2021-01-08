Return-Path: <SRS0=HOrx=GL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C830C433DB
	for <kvmarm@archiver.kernel.org>; Fri,  8 Jan 2021 18:20:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 74BBA23A62
	for <kvmarm@archiver.kernel.org>; Fri,  8 Jan 2021 18:20:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 74BBA23A62
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F1B9B4B49C;
	Fri,  8 Jan 2021 13:20:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jo2XWwuqi58b; Fri,  8 Jan 2021 13:20:02 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DA3B94B48C;
	Fri,  8 Jan 2021 13:20:02 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E7414B48C
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jan 2021 13:20:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hag+pqrO30my for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Jan 2021 13:20:00 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1EE3E4B487
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jan 2021 13:20:00 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2A2D23A7B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jan 2021 18:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1610129999;
 bh=IqCSXoeQNBHtMWX+PEiVnSak8jKJI2R8HW8JGgO/A+U=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=qtV/SCFwDZUcKDh4o3T4FNHZu46HeplQMrkr2ZGjIrNsI/jlgC/Pw86KJ94nnA1Gy
 sj4hxosL9baeqN13CEYSuM8houoiq51t+gd4yrbFuOUvbRin35r+knapRUucByfgoT
 CvClQ/SVYGdN0d5kNusuQOaH/nA4EG7XTg/Gp9HRrmOsMqpJ95tjKmD/ylxxYsivKJ
 TO+pSSGVYH61SI8BB4ylSxnJ9ZFzoYrb3MYL1UW5h+SPKOrQgZnWKgE6rBrE9piqaR
 v+D7e6+Kn+8bVJRLR+iBt9h6IbrWfNRMEB4lZ9TXhq8t4gXQqh1IAneGjeahKLkffI
 OrNfDHmSg9M7A==
Received: by mail-ot1-f54.google.com with SMTP id n42so10502470ota.12
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Jan 2021 10:19:58 -0800 (PST)
X-Gm-Message-State: AOAM532Q4tPxLtUmbFZ8YIt9G6UEYoiRqfjdh+TKpgMSJ9/nQAmu9MAQ
 cf50vnQHaf24d8H/sx4GP2Go00FWaJM21vmb318=
X-Google-Smtp-Source: ABdhPJw8D23JbpFFmc+NJLaw5bBCPNhd1JG2Z7LPBQxMB3GK1ScwK+Dq5bnL1fPfQqnQ0B907oCW4a0AgvG7jaqvh4k=
X-Received: by 2002:a05:6830:10d2:: with SMTP id
 z18mr3487997oto.90.1610129998051; 
 Fri, 08 Jan 2021 10:19:58 -0800 (PST)
MIME-Version: 1.0
References: <20210108171216.2310188-1-maz@kernel.org>
 <20210108171216.2310188-3-maz@kernel.org>
 <CAMj1kXGAQKHZ+MHggDJK9qv0bPNVr7Zb6hdzd78YfRaMUQg8yQ@mail.gmail.com>
 <72a1bea27a29d35413c193f81b7ba170@kernel.org>
In-Reply-To: <72a1bea27a29d35413c193f81b7ba170@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Fri, 8 Jan 2021 19:19:47 +0100
X-Gmail-Original-Message-ID: <CAMj1kXFoB_qNH-7pvhYzwSaXC0tV3d427qfKAUmj3rqiU=t_JQ@mail.gmail.com>
Message-ID: <CAMj1kXFoB_qNH-7pvhYzwSaXC0tV3d427qfKAUmj3rqiU=t_JQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: arm64: Workaround firmware wrongly advertising
 GICv2-on-v3 compatibility
To: Marc Zyngier <maz@kernel.org>
Cc: Linux ARM <linux-arm-kernel@lists.infradead.org>,
 Android Kernel Team <kernel-team@android.com>,
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

On Fri, 8 Jan 2021 at 19:13, Marc Zyngier <maz@kernel.org> wrote:
>
> On 2021-01-08 17:59, Ard Biesheuvel wrote:
> > On Fri, 8 Jan 2021 at 18:12, Marc Zyngier <maz@kernel.org> wrote:
> >>
> >> It looks like we have broken firmware out there that wrongly
> >> advertises
> >> a GICv2 compatibility interface, despite the CPUs not being able to
> >> deal
> >> with it.
> >>
> >> To work around this, check that the CPU initialising KVM is actually
> >> able
> >> to switch to MMIO instead of system registers, and use that as a
> >> precondition to enable GICv2 compatibility in KVM.
> >>
> >> Note that the detection happens on a single CPU. If the firmware is
> >> lying *and* that the CPUs are asymetric, all hope is lost anyway.
> >>
> >> Reported-by: Shameerali Kolothum Thodi
> >> <shameerali.kolothum.thodi@huawei.com>
> >> Signed-off-by: Marc Zyngier <maz@kernel.org>
> >> ---
> >>  arch/arm64/kvm/hyp/vgic-v3-sr.c | 34
> >> +++++++++++++++++++++++++++++++--
> >>  arch/arm64/kvm/vgic/vgic-v3.c   |  8 ++++++--
> >>  2 files changed, 38 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c
> >> b/arch/arm64/kvm/hyp/vgic-v3-sr.c
> >> index 005daa0c9dd7..d504499ab917 100644
> >> --- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
> >> +++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
> >> @@ -408,11 +408,41 @@ void __vgic_v3_init_lrs(void)
> >>  /*
> >>   * Return the GIC CPU configuration:
> >>   * - [31:0]  ICH_VTR_EL2
> >> - * - [63:32] RES0
> >> + * - [62:32] RES0
> >> + * - [63]    MMIO (GICv2) capable
> >>   */
> >>  u64 __vgic_v3_get_gic_config(void)
> >>  {
> >> -       return read_gicreg(ICH_VTR_EL2);
> >> +       u64 sre = read_gicreg(ICC_SRE_EL1);
> >> +       unsigned long flags = 0;
> >> +       bool v2_capable;
> >> +
> >> +       /*
> >> +        * To check whether we have a MMIO-based (GICv2 compatible)
> >> +        * CPU interface, we need to disable the system register
> >> +        * view. To do that safely, we have to prevent any interrupt
> >> +        * from firing (which would be deadly).
> >> +        *
> >> +        * Note that this only makes sense on VHE, as interrupts are
> >> +        * already masked for nVHE as part of the exception entry to
> >> +        * EL2.
> >> +        */
> >> +       if (has_vhe())
> >> +               flags = local_daif_save();
> >> +
> >> +       write_gicreg(0, ICC_SRE_EL1);
> >> +       isb();
> >> +
> >> +       v2_capable = !(read_gicreg(ICC_SRE_EL1) & ICC_SRE_EL1_SRE);
> >> +
> >> +       write_gicreg(sre, ICC_SRE_EL1);
> >> +       isb();
> >> +
> >> +       if (has_vhe())
> >> +               local_daif_restore(flags);
> >> +
> >> +       return (read_gicreg(ICH_VTR_EL2) |
> >> +               v2_capable ? (1ULL << 63) : 0);
> >>  }
> >>
> >
> > Is it necessary to perform this check unconditionally? We only care
> > about this if the firmware claims v2 compat support.
>
> Indeed. But this is done exactly once per boot, and I see it as
> a way to extract the CPU configuration more than anything else.
>
> Extracting it *only* when we have some v2 compat info would mean
> sharing that information with EL2 (in the nVHE case), and it felt
> more hassle than it is worth.
>
> Do you foresee any issue with this, other than the whole thing
> being disgusting (which I wilfully admit)?
>

No I don't think it's a problem per se. Just a bit disappointing that
every system will be burdened with this for as long as the last v2
compat capable system is still being supported.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
