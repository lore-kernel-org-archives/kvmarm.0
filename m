Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBCABC433EF
	for <kvmarm@archiver.kernel.org>; Thu, 24 Mar 2022 06:00:47 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3BBA24A105;
	Thu, 24 Mar 2022 02:00:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id h7QPNEYdA3LV; Thu, 24 Mar 2022 02:00:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B9E1C4A11C;
	Thu, 24 Mar 2022 02:00:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D0DE4A0FE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Mar 2022 02:00:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TMwbz4989AYu for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Mar 2022 02:00:43 -0400 (EDT)
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com
 [209.85.215.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D29994A104
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Mar 2022 02:00:42 -0400 (EDT)
Received: by mail-pg1-f169.google.com with SMTP id t14so3026092pgr.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Mar 2022 23:00:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=t3czBkYyoHFg7UJyKxX9VIgCHCyrFQ4XAs2LDl9neps=;
 b=TA83IRs9/p7oKXnSveX6TI3Vj5Ybd/zTmzI6jGDtPoD7QGlG5vqQbcO7hjIRdnfcYW
 LKq4gDkPgb7k9kpY71Z5RtRqdQ/BBV8nsKmb/DUs9TWkD7o16960BgpH2V7gwcGwOofb
 lWoRShYl4LaVlyF3UqT/CEstw/OgwrJqv6+CJTG68Ay7ADjXL2cTqNcBntsgqB+OOHNo
 1HFfdE8EzszeOzP7cKV+p3lYy27mRKHseyqEiOFdYXfXE3b2+D5IZfbEy/u4uIWmjbKj
 vEcdGLUodL+4B76S7kWAr5KFpXKKTFff7GVqq4oCWePPI3+ZBqZwZkgK+dZjO0cnNux2
 L2kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=t3czBkYyoHFg7UJyKxX9VIgCHCyrFQ4XAs2LDl9neps=;
 b=TwH7BjwmyWTY5gJucv83zEWTCXKLY4TrSoWfTCvfp/C46KDjpE9X+AVA4G12/AZpbD
 TdH7MvhDj+bol6d/568HCD6Oi/K0GEGxWK7XvkwcHeHe5KV1fwn+SQXRUxvpohAo/P2I
 +KE6lXyH7ThrDJDTufYiwv7nSp1IMDmp3s4T8q8KQkP3bh5NeEbG7K7Q2ZVV5WdhICmC
 ssY8733yp+ik1NYtxj04Ug5Xhkqg7VtfBcCQvGHC2w+W9MNi2kBGqB5dUeg2CEJF++qg
 UGmFrWpFoIPZTRVtDytatIoYxyx/3NLzQDLHnO9Kt6B1f07QAWerTMrSE/zLR6mByfyk
 mwUA==
X-Gm-Message-State: AOAM531GojbeQAiQ1Cp19rxMFzerQJD82CzikQJS+OShHmF/C/hj7yT5
 ORPwrszu+bHdHhtzaKfgkd6+U6wjtK45SteIHMtz2Xc3QNV/7Nms
X-Google-Smtp-Source: ABdhPJzFKhg99WAnPGSmAok3ONRhr2z+aCSI9fpBJ9ZLnS92ko1dp5e3Osel3T/L88y8KOgEXAnGC7E2tyRVBlJjz2w=
X-Received: by 2002:a65:56cb:0:b0:378:82ed:d74 with SMTP id
 w11-20020a6556cb000000b0037882ed0d74mr2784915pgs.491.1648101641606; Wed, 23
 Mar 2022 23:00:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220311044811.1980336-1-reijiw@google.com>
 <20220311044811.1980336-2-reijiw@google.com>
 <Yjl96UQ7lUovKBWD@google.com>
 <CAAeT=FzELqXZiWjZ9aRNqYRbX0zx6LdhETiZUS+CMvax2vLRQw@mail.gmail.com>
 <YjrG0xiubC108tIN@google.com>
In-Reply-To: <YjrG0xiubC108tIN@google.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Wed, 23 Mar 2022 23:00:25 -0700
Message-ID: <CAAeT=FxEwuwg310vhWQeBJ9UouHNaJNcPqvbLYh7nXp7aFFq=Q@mail.gmail.com>
Subject: Re: [PATCH v6 01/25] KVM: arm64: Introduce a validation function for
 an ID register
To: Oliver Upton <oupton@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Will Deacon <will@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 Linux ARM <linux-arm-kernel@lists.infradead.org>
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

> > > I have some concerns regarding the API between cpufeature and KVM that's
> > > being proposed here. It would appear that we are adding some of KVM's
> > > implementation details into the cpufeature code. In particular, I see
> > > that KVM's limitations on AA64DFR0 are being copied here.
> >
> > I assume "KVM's limitation details" you meant is about
> > ftr_id_aa64dfr0_kvm.
> > Entries in arm64_ftr_bits_kvm_override shouldn't be added based
> > on KVM's implementation.  When cpufeature.c doesn't handle lower level
> > of (or fewer) features as the "safe" value for fields, the field should
> > be added to arm64_ftr_bits_kvm_override.  As PMUVER and DEBUGVER are not
> > treated as LOWER_SAFE, they were added in arm64_ftr_bits_kvm_override.
>
> I believe the fact that KVM is more permissive on PMUVER and DEBUGVER
> than cpufeature is in fact a detail of KVM, no? read_id_reg() already

What cpufeature knows is that consumers of the validation function
needs the validation of each field based on ID register schemes that
are described in Arm ARM (basically lower safe).
As lower values of PMUVER/DEBUGVER indicates lower level of features
or fewer level of features, those entries are to provide validation
based on that.  So, entries in arm64_ftr_bits_kvm_override will be added
to adjust cpufeture's behavior based on ID register schemes, and KVM may
or may not use them.

I need to remove the word "kvm" from variable/function/structure names
and put more clear comments:)

> implicitly trusts the cpufeature code filtering and applies additional
> limitations on top of what we get back. Similarly, there are fields
> where KVM is more restrictive than cpufeature (ID_AA64DFR0_PMSVER).
>
> Each of those constraints could theoretically be expressed as an
> arm64_ftr_bits structure within KVM.

It's not impossible but it's a bit tricky (With __arm64_ftr_reg_valid(),
it might look straight forward, but I don't think that treats FTR_EXACT
correctly. Please see update_cpu_ftr_reg).

> > Having said that, although ftr_id_aa64dfr0 has PMUVER as signed field,
> > I didn't fix that in ftr_id_aa64dfr0_kvm, and the code abused that....
> > I should make PMUVER unsigned field, and fix cpufeature.c to validate
> > the field based on its special ID scheme for cleaner abstraction.
>
> Good point. AA64DFR0 is an annoying register :)
>
> > (And KVM should skip the cpufeature.c's PMUVER validation using
> >  id_reg_desc's ignore_mask and have KVM validate it locally based on
> >  the KVM's special requirement)
> >
> >
> > > Additionally, I think it would be preferable to expose this in a manner
> > > that does not require CONFIG_KVM guards in other parts of the kernel.
> > >
> > > WDYT about having KVM keep its set of feature overrides and otherwise
> > > rely on the kernel's feature tables? I messed around with the idea a
> > > bit until I could get something workable (attached). I only compile
> > > tested this :)
> >
> > Thanks for the proposal!
> > But, providing the overrides to arm64_ftr_reg_valid() means that its
> > consumer knows implementation details of cpufeture.c (values of entries
> > in arm64_ftr_regs[]), which is a similar abstraction problem I want to
> > avoid (the default validation by cpufeature.c should be purely based on
> > ID schemes even with this option).
>
> It is certainly a matter of where you choose to draw those lines. We already
> do bank on the implementation details of cpufeature.c quite heavily, its
> just stuffed away behind read_sanitised_ftr_reg(). Now we have KVM bits and
> pieces in cpufeature.c and might wind up forcing others to clean up our dirty
> laundry in the future.

As I mentioned above, they aren't KVM specific.

> It also seems to me that if I wanted to raise the permitted DEBUGVER for KVM,
> would I have to make a change outside of KVM.

Could you elaborate this a little more?

More specific concern I have about providing the override (with the
existing arm64_ftr_bits) would be when field values of arm64_ftr_bits
(i.e. LOWER_SAFE to EXACT) in cpufeature are changed due to kernel's
implementation reasons, which might affect KVM (may need to pass
extra override to arm64_ftr_reg_valid).
But, by having cpufeature provide the validation based on the ID
register schemes, cpufeature should be changed to provide the same
validation in that case (i.e. if DFR0.PERFMON is changed from LOWER_SAFE
to EXACT like AA64DFR0.PMUVER, DFR0.PERFMON should be added in
arm64_ftr_bits_kvm_override with LOWER_SAFE).

So, if I go with the option to provide override to cpufeature, IMHO it
would be preferable for cpufeature to provide the validation based
on ID schemes instead of with the current need-based policy (, which
might get changed) for clear separation.

> > Another option that I considered earlier was having a full set of
> > arm64_ftr_bits in KVM for its validation. At the time, I thought
> > statically) having a full set of arm64_ftr_bits in KVM is not good in
> > terms of maintenance.  But, considering that again, since most of
> > fields are unsigned and lower safe fields, and KVM doesn't necessarily
> > have to statically have a full set of arm64_ftr_bits
>
> I think the argument could be made for KVM having its own static +
> verbose cpufeature tables. We've already been bitten by scenarios where

What does "verbose cpufeature tables" mean ?

> cpufeature exposes a feature that we simply do not virtualize in KVM.
> That really can become a game of whack-a-mole. commit 96f4f6809bee
> ("KVM: arm64: Don't advertise FEAT_SPE to guests") is a good example,
> and I can really see no end to these sorts of issues without an
> overhaul. We'd need to also find a way to leverage the existing
> infrasturcture for working out a system-wide safe value, but this time
> with KVM's table of registers.
> KVM would then need to take a change to expose any new feature that has
> no involvement of EL2. Personally, I'd take that over the possibility of
> another unhandled feature slipping through and blowing up a guest kernel
> when running on newer hardware.

Userspace with configurable ID registers would eliminate such problems
on known systems, but I agree that KVM itself should prevent it.
It will be inconvenient for some people, but it would be safer in general.

> > (dynamically generate during KVM's initialization)
>
> This was another one of my concerns with the current state of this
> patch. I found the register table construction at runtime hard to
> follow. I think it could be avoided with a helper that has a prescribed
> set of rules (caller-provided field definition takes precedence over the
> general one).

Sure, I will improve that if I continue to keep the current way.
With the option of having a separate KVM's arm64_ftr_bits,
the code will be very different, but I will keep that in mind.

Thanks,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
