Return-Path: <SRS0=HDjL=MW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 995B4C4320A
	for <kvmarm@archiver.kernel.org>; Fri, 30 Jul 2021 15:22:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1C56E61059
	for <kvmarm@archiver.kernel.org>; Fri, 30 Jul 2021 15:22:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1C56E61059
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B8EB4B0C9;
	Fri, 30 Jul 2021 11:22:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MX63yujUh0n8; Fri, 30 Jul 2021 11:22:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 73FAA4B0A3;
	Fri, 30 Jul 2021 11:22:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EAC644B0A3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jul 2021 11:22:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mZsZDRc6cr+m for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Jul 2021 11:22:14 -0400 (EDT)
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com
 [209.85.167.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 84B2D4B09A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jul 2021 11:22:14 -0400 (EDT)
Received: by mail-lf1-f43.google.com with SMTP id p38so3679920lfa.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jul 2021 08:22:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=/1o7+QKd97cIwS/kb/Ro1mV06vaGWcTs0D3fJHtTeso=;
 b=nVqXEBrlXTGcTUwaUH5Wm8FEDfko7xv0Xdqrq5ntdbi6gth09eo2rp2GDwyHrYvBtt
 qcCaJ8HQgf4tyQdQ6aro6IyWLEpR5ja2MABBOxIHdNHEOIYAAx4P6J0nwbLx1/VjwT3z
 MnxgpQjuj/UbcnSfMYqagxbISEsp7GkQYhqGVNHjVMqv0GR0qtz9XXiVfUvngr69Llko
 Zlutqz6DBFg76VF5mD1QAh2yDxoxr7I/kjDc3v6eRfwv/YBPGLIJ1G6ckwEqO9WL8UT4
 LTjGh2P4o7HCw6SZOwcuTIAbcdkvvScewj+4RG5cfRjkKrck+bbowZ88vu01qTxghj3R
 HVcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=/1o7+QKd97cIwS/kb/Ro1mV06vaGWcTs0D3fJHtTeso=;
 b=FQfbvs5X4BzAeYxE9+T8SjQ5JJsR2pjNjvOwiuKWjCzYe08YO6keSb4TejO1oK8/80
 AsOr8fAsi+g6vdGIAcSjcE2mTuk/8ZIc1eQcq9DdU2uPRm6PWt/O6Hur2PNOW3cPjDMv
 fGI2q1bsk9MEUMlSgW4oVlXwiFxpGD5E+1ChjOwoWMHemI2Zjdha1D6jd7ANITztUsRK
 3vgx4wkOLMn+BX5lCFv8JbqVmFSHQ4bB3CKPOI9npwqSsJcyqffXW2bqYoZxyRocSosw
 T1+6tskD4TqlVEI9d/9NIOlmKKIj5IbEQvRi8E/DgNf5MGxfLp5O5r0t5vQkpSKi/ctq
 eWuQ==
X-Gm-Message-State: AOAM533lD+MYCDA2+i3mgF4yeErrwuZQUVdNI2Xu9/UWJVdTs5LRgIa6
 DNHRdOf+3Y8pii5O9aZN9LFbwdL5mb3eky0Pg83ftw==
X-Google-Smtp-Source: ABdhPJy3MzOJEL7JUXn3pv247OvpOyrn4DFM65cNNeDejFTsyvt+MsdJW5ifOeeaLmsG2MxQDXZ+nQuM/comVP/br64=
X-Received: by 2002:a05:6512:3d26:: with SMTP id
 d38mr2131778lfv.411.1627658532665; 
 Fri, 30 Jul 2021 08:22:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210729173300.181775-1-oupton@google.com>
 <20210729173300.181775-12-oupton@google.com>
 <875yws2h5w.wl-maz@kernel.org>
In-Reply-To: <875yws2h5w.wl-maz@kernel.org>
From: Oliver Upton <oupton@google.com>
Date: Fri, 30 Jul 2021 08:22:01 -0700
Message-ID: <CAOQ_QsgCrEWQqakicR3Peu_c8oCMeq8Cok+CK8vJVURUwAdG0A@mail.gmail.com>
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

On Fri, Jul 30, 2021 at 4:08 AM Marc Zyngier <maz@kernel.org> wrote:
> > FEAT_ECV provides a guest physical counter-timer offset register
> > (CNTPOFF_EL2), but ECV-enabled hardware is nonexistent at the time of
> > writing so support for it was elided for the sake of the author :)
>
> You seem to have done most the work for that, and there are SW models
> out there that implement ECV. If anything, the ECV support should come
> first, and its emulation only as a poor man's workaround.
>
> It is also good to show silicon vendors that they suck at providing
> useful features, and pointing them to the code that would use these
> features *is* an incentive.

Lol, then so be it. I'll add ECV support to this series. What can I
test with, though? I don't recall QEMU supporting ECV last I checked..

> I really dislike the fallback to !vhe here. I'd rather you
> special-case the emulated ptimer in the VHE case:
>
>         if (has_vhe()) {
>                 map->direct_vtimer = vcpu_vtimer(vcpu);
>                 if (!timer_get_offset(vcpu_ptimer(vcpu)))
>                         map->direct_ptimer = vcpu_ptimer(vcpu);
>                         map->emul_ptimer = NULL;
>                 } else {
>                         map->direct_ptimer = NULL;
>                         map->emul_ptimer = vcpu_ptimer(vcpu);
>                 }
>         } else {

Ack.

> and you can drop the timer_emulation_required() helper which doesn't
> serve any purpose.

Especially if I add ECV to this series, I'd prefer to carry it than
open-code the check for CNTPOFF && !ECV in get_timer_map(). Do you
concur? I can tighten it to ptimer_emulation_required() and avoid
taking an arch_timer context if you prefer.

> > +static inline bool __hyp_handle_counter(struct kvm_vcpu *vcpu)
> > +{
> > +     u32 sysreg = esr_sys64_to_sysreg(kvm_vcpu_get_esr(vcpu));
> > +     int rt = kvm_vcpu_sys_get_rt(vcpu);
> > +     u64 rv;
> > +
> > +     if (sysreg != SYS_CNTPCT_EL0)
>
> That's feels really optimistic. You don't check for the exception
> class, and pray that the bits will align? ;-)

Doh! Missed the EC check.

> Please don't add more small includes like this. It makes things hard
> to read and hides bugs

Ack.

> the counter read can (and will) be speculated,
> so you definitely need an ISB before the access. Please also look at
> __arch_counter_get_cntpct() and arch_counter_enforce_ordering().

Wouldn't it be up to the guest to decide if it wants the counter to be
speculated or not? I debated this a bit myself in the implementation,
as we would trap both ordered and un-ordered reads. Well, no way to
detect it :)

> >
> > -/*
> > - * Should only be called on non-VHE systems.
> > - * VHE systems use EL2 timers and configure EL1 timers in kvm_timer_init_vhe().
> > - */
>
> This comment still applies. this function *is* nVHE specific.
>

Ack.

>
> You now pay the price of reprogramming CNTHCTL_EL2 on every entry for
> VHE, and that's not right. On VHE, it should be enough to perform the
> programming on vcpu_load() only.
>

True. I'll rework the programming in the next series.

> Overall, this patch needs a bit of splitting up (userspace interface,
> HV rework), re-optimise VHE, and it *definitely* wants the ECV support
> for the physical timer.
>

Sure thing, thanks for the review Marc!

--
Best,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
