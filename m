Return-Path: <SRS0=fzUG=OL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A044DC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 21 Sep 2021 18:22:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1114761242
	for <kvmarm@archiver.kernel.org>; Tue, 21 Sep 2021 18:22:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1114761242
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 665654B09C;
	Tue, 21 Sep 2021 14:22:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 79qxtmzgBncK; Tue, 21 Sep 2021 14:22:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B60414A19A;
	Tue, 21 Sep 2021 14:22:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B69654066E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 14:22:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PTXpePneu655 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Sep 2021 14:22:09 -0400 (EDT)
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com
 [209.85.166.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7081440191
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 14:22:09 -0400 (EDT)
Received: by mail-io1-f49.google.com with SMTP id d18so16098579iof.13
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 11:22:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=9+MHxSXYWf62H1mi1zwglh1AL9XfTUwDuHjSd9t/urI=;
 b=jyujWDhde9Ijat2B16V/yQFlxPDr13NnlzjpfFtbN/4jk4xVU5OLGyChRGgfFmiXEf
 17pwo3aMGu4v0FWTN96FMwOVx0HdSEeCJ+7wkdtk4JUYaDxEQbuf2WnEBLE3qTc6NCEJ
 128fHPjCV0jY/+/G0916Bz0MK+UcCJ2RMVLryO23dF42QcZRJtWwLrGq10JGSk37NEhl
 DYWU+Ew1iSYu8FV2BX4Q7uYsRpPZDyyOnSZzQoqqU4a/74glpc3LlyZ6HtAGwd74hn7I
 uqByjmnxA/EzblonHNyVc/aN2CZOQ8r+6PY1ZZBNbaNdOYE36rcMq+0gD009RAKIUV0k
 r51w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=9+MHxSXYWf62H1mi1zwglh1AL9XfTUwDuHjSd9t/urI=;
 b=TmdGv6mffZBQ1K+yKJH9uj/NrGQYANcHFUS7WeH+XbTtaQtmklxGIEBuI9JG8XL1ib
 B6dKcd9Bt3gap8PJhuh0/tCXNwO0D+RQu+mhZgL5eoGtXgxyzThjbJ1FCftKoxZLmTh+
 gRB9AjOTKeJfOfI2awag+5IfmxAS382CneGYZynklPX4aOSrNaOa2CP4DuvcdyLVGcRd
 bzbiZffRu73edMdbbC3FB7TUHUcOqD36TvG40+4r4XnJAq3Irm06yhuJU4AneSsoqjQY
 JFRi/O4vpOF58Xo6hlushclUj6BAvVUHA47/FzhqjuTgRVIprB7eig36oguxXPg9Gz/z
 BhTQ==
X-Gm-Message-State: AOAM531uw4Pvpldmfifr2aqj2s9X9HpC7rvtJfolcje7wPTaS3YvPC9s
 Fg3huMwYwWzOaX1avLgQi0Bb5A==
X-Google-Smtp-Source: ABdhPJxbTKfRsy2+nMboYmvHPECb+3i1VPhDhlxB7htZ/MIZ22coBg216qMnOQCeKMbph/gje7gM7Q==
X-Received: by 2002:a05:6638:2393:: with SMTP id
 q19mr1249131jat.109.1632248528551; 
 Tue, 21 Sep 2021 11:22:08 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194])
 by smtp.gmail.com with ESMTPSA id w4sm3355197iox.25.2021.09.21.11.22.07
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 21 Sep 2021 11:22:07 -0700 (PDT)
Date: Tue, 21 Sep 2021 18:22:04 +0000
From: Oliver Upton <oupton@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 0/6] KVM: arm64: Implement PSCI SYSTEM_SUSPEND support
Message-ID: <YUoizIJ+xQTreLtP@google.com>
References: <20210819223640.3564975-1-oupton@google.com>
 <87ilzecbkj.wl-maz@kernel.org>
 <CAOQ_QsgOtufyB6_qGAs4fQf6kd81FSMSj44uiVRgoFQWOf3nRA@mail.gmail.com>
 <87a6kocmcx.wl-maz@kernel.org>
 <CAOQ_QshZe8ay03XqCo4DkM6zUaOuEoS5bRbrOy+FsuXaJ=YyKA@mail.gmail.com>
 <87k0jauurx.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87k0jauurx.wl-maz@kernel.org>
Cc: kvm@vger.kernel.org, Peter Shier <pshier@google.com>,
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

Hey Marc,

On Tue, Sep 21, 2021 at 10:45:22AM +0100, Marc Zyngier wrote:
> > > > > - How do you define which interrupts are actual wake-up events?
> > > > >   Nothing in the GIC architecture defines what a wake-up is (let alone
> > > > >   a wake-up event).
> > > >
> > > > Good point.
> > > >
> > > > One possible implementation of suspend could just be a `WFI` in a
> > > > higher EL. In this case, KVM could emulate WFI wake up events
> > > > according to D1.16.2 in DDI 0487G.a. But I agree, it isn't entirely
> > > > clear what constitutes a wakeup from powered down state.
> > >
> > > It isn't, and it is actually IMPDEF (there isn't much in the ARM ARM
> > > in terms of what constitutes a low power state). And even if you
> > > wanted to emulate a WFI in userspace, the problem of interrupts that
> > > have their source in the kernel remains. How to you tell userspace
> > > that such an event has occurred if the vcpu thread isn't in the
> > > kernel?
> > 
> > Well, are there any objections to saying for the KVM implementation we
> > observe the WFI wake-up events per the cited section of the ARM ARM?
> 
> These are fine. However, what of the GIC, for example? Can any GIC
> interrupt wake-up the guest? I'm happy to say "yes" to this, but I
> suspect others will have a different idea, and the thought of
> introducing an IMPDEF wake-up interrupt controller doesn't fill me
> with joy.
>

I'm planning to propose exactly this in the next series; any GIC
interrupt will wake the guest. I'd argue that if someone wants to do
anything else, their window of opportunity is the exit to userspace.

[...]

> > Just to check understanding for v2:
> > 
> > We agree that an exit to userspace is fine so it has the opportunity
> > to do something crazy when the guest attempts a suspend. If a VMM does
> > nothing and immediately re-enters the kernel, we emulate the suspend
> > there by waiting for some event to fire, which for our purposes we
> > will say is an interrupt originating from userspace or the kernel
> > (WFI). In all, the SUSPEND exit type does not indicate that emulation
> > terminates with the VMM. It only indicates we are about to block in
> > the kernel.
> > 
> > If there is some IMPDEF event specific to the VMM, it should signal
> > the vCPU thread to kick it out of the kernel, make it runnable, and
> > re-enter. No need to do anything special from the kernel perspective
> > for this. This is only for the case where we decide to block in the
> > kernel.
> 
> This looks sensible. One question though: I think there is an implicit
> requirement that the guest should be "migratable" in that state. How
> does the above handles it? If the "suspend state" is solely held in
> the kernel, we need to be able to snapshot it, and I don't like the
> sound of that...
> 
> We could instead keep the "suspend state" in the VMM:
> 
> On PSCI_SUSPEND, the guest exits to userspace. If the VMM wants to
> honour the supend request, it reenters the guest with RUN+SUSPEND,
> which results in a WFI. On each wake-up, the guest exits to userspace,
> and it is the VMM responsibility to either perform the wake-up (RUN)
> or stay in suspend (RUN+SUSPEND).
> 
> This ensures that the guest never transitions out of suspend without
> the VMM knowing, and the VMM can always force a resume by kicking the
> thread back to userspace.
> 
> Thoughts?

Agreed. I was mulling on exactly how to clue in the VMM about the
suspend state. What if we just encode it in KVM_{GET,SET}_MP_STATE? We'd
avoid the need for new UAPI that way. We could introduce a new state,
KVM_MP_STATE_SUSPENDED, which would clue KVM to do the suspend as we've
discussed. We would exit to userspace with KVM_MP_STATE_RUNNABLE,
meaning the VMM would need to set the MP state explicitly for the
in-kernel suspend to work.

[...]

> > > > On the contrary, it is up to KVM's implementation to
> > > > guarantee caches are clean when servicing the guest request.
> > >
> > > This last point is pretty unclear to me. If the guest doesn't clean to
> > > the PoC (or even to one of the PoPs) when it calls into suspend,
> > > that's a clear indication that it doesn't care about its data. Why
> > > should KVM be more conservative here? It shouldn't be in the business
> > > of working around guest bugs.
> > 
> > PSCI is vague on this, sadly. DEN0022D.b, 5.4.8 "Implementation
> > responsibilities: Cache and coherency management states" that for
> > CPU_SUSPEND, the PSCI implementation must perform a cache clean
> > operation before entering the powerdown state. I don't see any reason
> > why SYSTEM_SUSPEND should be excluded from this requirement.
> 
> I'm not sure that's the case. CPU_SUSPEND may not use the resume
> entry-point if the suspend results is a shallower state than expected
> (i.e. the call just returns instead of behaving like a CPU boot).
> 
> However, a successful SYSTEM_SUSPEND always results in the deepest
> possible state. The guest should know that. There is also the fact
> that performing a full clean to the PoC is going to be pretty
> expensive, and I'd like to avoid that.
> 
> I'll try and reach out to some of the ARM folks for clarification on
> the matter.

That'd be very helpful!

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
