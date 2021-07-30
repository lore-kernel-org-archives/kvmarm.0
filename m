Return-Path: <SRS0=HDjL=MW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF9ABC4338F
	for <kvmarm@archiver.kernel.org>; Fri, 30 Jul 2021 16:48:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3FE1260F3A
	for <kvmarm@archiver.kernel.org>; Fri, 30 Jul 2021 16:48:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3FE1260F3A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B1E2F4AEF8;
	Fri, 30 Jul 2021 12:48:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jqP44Mozrjw9; Fri, 30 Jul 2021 12:48:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C4BD4B0B3;
	Fri, 30 Jul 2021 12:48:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3454A4B08F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jul 2021 12:48:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4aiermnjlFXE for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Jul 2021 12:48:45 -0400 (EDT)
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com
 [209.85.167.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EA0D44AEF8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jul 2021 12:48:44 -0400 (EDT)
Received: by mail-lf1-f45.google.com with SMTP id u3so19074083lff.9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jul 2021 09:48:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=HSpyjj2q59p3JnLbqxdGu1wbl5OCmoAl/PXe1KwPZFU=;
 b=jW7212u6qaToexTXRrnITb/f5YiTnaF4LgQPUS3FTRc9TklaeoKZmrbMIuHzbX2+fm
 IFLaPAZzT+BuXdjSnhln0I4HuDW/Fzq/qO3F0fs9P2xohbtR8mp/YyQ+b331WUgB4vAA
 8Z2+Qc2fVZpm+ttWUY+3iDDZi4N5oV08xvocvEj5SfS2rkbbMEnPi3b82v6N3QgKprM2
 Il0Oc16Aqg6BHrPliQDlX56bf9x9b15JTfF4uCQYujXjIeOcRW2EL8nIKJ42JLj8199R
 NnBYCesY1WLyV4Ojr0G5z+yn6CNLWHPvEDH11+QTMsybChnoLQVA3uzDiVMqX1ZK1SFJ
 YpqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=HSpyjj2q59p3JnLbqxdGu1wbl5OCmoAl/PXe1KwPZFU=;
 b=LQ6ycnYG0+wHHvfzbQqf6PeF+l2X2hfHVadmf3skfpV95fEgDfbYhIAcphN4WNdDvT
 dy82KAkA5uaSblKTSTuWXPMjC95IbJNKyH0okFK8gBhx987DW8InyxNw2LzLitZJledJ
 k+hpZqyhAvjTSRFObAbAOAKdflxjsyRqQR2BA552zOQul9Hn/aUzfepFwQ40kBaPFJZu
 7/t+tlVjIHnJshEf62z1pMK1JL/3bFJxTTCS9/cr5DEZDshoUnVU3UqYnNa9gZt2KNP1
 kHDRrox8XthLmp+53DQpq4zTEt3AV4K/5b67ZrdUog++2ORVfMKw6HezXKOh/rOX1q58
 uTiQ==
X-Gm-Message-State: AOAM530btljI9aGo/hsqNQvr7celpMPEOicGb+mpCfgFiFRc/FOTa3EB
 0PTak8MUKu6PlzqNV5vRGQO90RJQkVF8eq/ynTlU6g==
X-Google-Smtp-Source: ABdhPJz4i34C7e+Mzo+QI82IG1ULBhvTaO+2wTi9MxMbMPfkAjMEWJ3veRwIHG5RuIcvKrQLGSTFnFXPHku+pVxS+zI=
X-Received: by 2002:a05:6512:3b94:: with SMTP id
 g20mr2577501lfv.0.1627663723073; 
 Fri, 30 Jul 2021 09:48:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210729173300.181775-1-oupton@google.com>
 <20210729173300.181775-12-oupton@google.com>
 <875yws2h5w.wl-maz@kernel.org>
 <CAOQ_QsgCrEWQqakicR3Peu_c8oCMeq8Cok+CK8vJVURUwAdG0A@mail.gmail.com>
 <87wnp722tm.wl-maz@kernel.org>
In-Reply-To: <87wnp722tm.wl-maz@kernel.org>
From: Oliver Upton <oupton@google.com>
Date: Fri, 30 Jul 2021 09:48:31 -0700
Message-ID: <CAOQ_QsiwuancUsFEVr3TBeP6yLZMfAqNRv3ww2H+hcUGfxs9LA@mail.gmail.com>
Subject: Re: [PATCH v5 11/13] KVM: arm64: Provide userspace access to the
 physical counter offset
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
 Peter Shier <pshier@google.com>, Raghavendra Rao Anata <rananta@google.com>,
 David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
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

On Fri, Jul 30, 2021 at 9:18 AM Marc Zyngier <maz@kernel.org> wrote:
> You want the ARM FVP model, or maybe even the Foundation model. It has
> support all the way to ARMv8.7 apparently. I personally use the FVP,
> get in touch offline and I'll help you with the setup.
>
> In general, I tend to trust the ARM models a lot more than QEMU for
> the quality of the emulation. You can tune it in some bizarre way
> (the cache modelling is terrifying), and it will definitely do all
> kind of crazy reordering and speculation.

Awesome, thanks. I'll give this a try.

>
> >
> > > I really dislike the fallback to !vhe here. I'd rather you
> > > special-case the emulated ptimer in the VHE case:
> > >
> > >         if (has_vhe()) {
> > >                 map->direct_vtimer = vcpu_vtimer(vcpu);
> > >                 if (!timer_get_offset(vcpu_ptimer(vcpu)))
> > >                         map->direct_ptimer = vcpu_ptimer(vcpu);
> > >                         map->emul_ptimer = NULL;
> > >                 } else {
> > >                         map->direct_ptimer = NULL;
> > >                         map->emul_ptimer = vcpu_ptimer(vcpu);
> > >                 }
> > >         } else {
> >
> > Ack.
> >
> > > and you can drop the timer_emulation_required() helper which doesn't
> > > serve any purpose.
> >
> > Especially if I add ECV to this series, I'd prefer to carry it than
> > open-code the check for CNTPOFF && !ECV in get_timer_map(). Do you
> > concur? I can tighten it to ptimer_emulation_required() and avoid
> > taking an arch_timer context if you prefer.
>
> Sure, whatever you prefer. I'm not set on one way or another, but in
> the above case, it was clearly easier to get rid of the helper.

Agreed, it made sense to prune before.

> There has been a trap, so that already was a context synchronisation
> event. but it would be pretty common for the counter to be speculated
> way early, when entering EL2. That's not the end of the world, but
> that's not an accurate emulation. You'd want it to be as close as
> possible to the reentry point into the guest.

Cool, I'll add the barrier to kick the can closer to guest entry.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
