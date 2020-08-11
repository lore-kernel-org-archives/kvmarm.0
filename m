Return-Path: <SRS0=6J9q=BV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.3 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FE85C433DF
	for <kvmarm@archiver.kernel.org>; Tue, 11 Aug 2020 15:12:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 22C9520782
	for <kvmarm@archiver.kernel.org>; Tue, 11 Aug 2020 15:12:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="Czg+Limk"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 22C9520782
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 94ABA4B5DE;
	Tue, 11 Aug 2020 11:12:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mFeVwSSKlgch; Tue, 11 Aug 2020 11:12:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F18C4B5DF;
	Tue, 11 Aug 2020 11:12:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DF5854B5DC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Aug 2020 11:12:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uKDVAR4V8H72 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Aug 2020 11:12:37 -0400 (EDT)
Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com
 [209.85.221.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A503E4B5DA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Aug 2020 11:12:37 -0400 (EDT)
Received: by mail-wr1-f67.google.com with SMTP id f7so11847281wrw.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Aug 2020 08:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=elgOqu1FrFl4n0UqqA4DrNAE8y7BeNWYPp0LCfpZI8c=;
 b=Czg+Limkjz1XjI56V0MoZEXqaapPpfV/nqkl31mEbim39Xgdb2NYiuzs3ho7EMKi31
 Eou2UVN7vhlxZHR9lb4HGeNaARJE5cZMf2nUtycKQCKH8PF83E8xa8FAipOOigDCGU8N
 x7qK3iDXQO7UH316Wj9HHm5kTF96rPe4Zt9S5rbVwK0epGNvvdqMavPX2up7mqY8V+dN
 +a4i+O4vXIJoTC0N/+2PrffSZ7Ag80vV4Uu8P3QOLd76YbKV1jI55cTjzL+F86IqFB6a
 WBA/1/sm975pathGt6RVIl9i/cx1ovTtLCk3/xzw4gwKz0Ks3Ku2P0TK7Fev68nI78qA
 lxFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=elgOqu1FrFl4n0UqqA4DrNAE8y7BeNWYPp0LCfpZI8c=;
 b=f/Lr7AQE80dEt33Gx2qYsZafTqKOBjsBBZcZvf2CX9Kx5zrwicAjji8cTeB1o1M/pi
 8Z9gyNYocc8uq6DDn3YOftyrOYbqcsl0s0UqFRtUrbj7/SXqrAoxS4Pw3p+9YJ8r34T0
 tGFTHNgdvlEXsspRuWMrc+ww7AKHQ6dXex7JE17zSd4Lk9NQePBbnpi/r0l14CsRjLSb
 /NTsi8lUabAVPkF3GJaWj01WKa0/ZjZCJp8vEj0KIDqKT2s7evX/5L+iTmz9z5SR8m7B
 1JQ5mkG4DCibL/zBCOSGNdEazj0e4vzy4xzudviqlt+jlP+ylouFCQJuzMqss242WcjD
 6eOw==
X-Gm-Message-State: AOAM530lqjUz/ZiHaoFwg6C/0fhV5fksUb+7AddabZucYO5jT8LgVPd6
 IerIJ3vFU+0ZzNOmAo3RA0Ggqw==
X-Google-Smtp-Source: ABdhPJxiBqwvWPYcs5l2EIl8Kqi6g5iM7AMVU8bvakhm1z/gmYR8Fb66PQRT8bDxacKX2CmkPb8LYg==
X-Received: by 2002:adf:dcc5:: with SMTP id x5mr29169005wrm.367.1597158756296; 
 Tue, 11 Aug 2020 08:12:36 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:109:4a0f:cfff:fe4a:6363])
 by smtp.gmail.com with ESMTPSA id f124sm5697818wmf.7.2020.08.11.08.12.34
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 11 Aug 2020 08:12:35 -0700 (PDT)
Date: Tue, 11 Aug 2020 16:12:30 +0100
From: Andrew Scull <ascull@google.com>
To: James Morse <james.morse@arm.com>
Subject: Re: [PATCH 2/2] KVM: arm64: nVHE: Don't consume host SErrors with RAS
Message-ID: <20200811151230.GC2917393@google.com>
References: <20200730151823.1414808-1-ascull@google.com>
 <20200730151823.1414808-2-ascull@google.com>
 <20200730223144.GA2022880@google.com>
 <8d469be9de5ce825ffeacdb530731591@kernel.org>
 <20200731102056.GA2547274@google.com>
 <ffbfe036-4370-4a89-7818-1f6b8d4ebed8@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <ffbfe036-4370-4a89-7818-1f6b8d4ebed8@arm.com>
Cc: kernel-team@android.com, catalin.marinas@arm.com,
 Marc Zyngier <maz@kernel.org>, will@kernel.org, kvmarm@lists.cs.columbia.edu
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

On Wed, Aug 05, 2020 at 03:37:27PM +0100, James Morse wrote:
> Hi Andrew,
> 
> On 31/07/2020 11:20, Andrew Scull wrote:
> > On Fri, Jul 31, 2020 at 09:00:03AM +0100, Marc Zyngier wrote:
> >> On 2020-07-30 23:31, Andrew Scull wrote:
> >>> On Thu, Jul 30, 2020 at 04:18:23PM +0100, Andrew Scull wrote:
> >>>> The ESB at the start of the vectors causes any SErrors to be
> >>>> consumed to
> >>>> DISR_EL1. If the exception came from the host and the ESB caught an
> >>>> SError, it would not be noticed until a guest exits and DISR_EL1 is
> >>>> checked. Further, the SError would be attributed to the guest and not
> >>>> the host.
> >>>>
> >>>> To avoid these problems, use a different exception vector for the host
> >>>> that does not use an ESB but instead leaves any host SError pending. A
> >>>> guest will not be entered if an SError is pending so it will always be
> >>>> the host that will receive and handle it.
> >>>
> >>> Thinking further, I'm not sure this actually solves all of the problem.
> >>> It does prevent hyp from causing a host SError to be consumed but, IIUC,
> >>> there could be an SError already deferred by the host and logged in
> >>> DISR_EL1 that hyp would not preserve if a guest is run.
> >>>
> >>> I think the host's DISR_EL1 would need to be saved and restored in the
> >>> vcpu context switch which, from a cursory read of the ARM, is possible
> >>> without having to virtualize SErrors for the host.
> >>
> >> The question is what do you if you have something pending in DISR_EL1
> >> at the point where you enter EL2? Context switching it is not going to
> >> help. One problem is that you'd need to do an ESB, corrupting DISR_EL1,
> >> before any memory access (I'm assuming you can get traps where all
> >> registers are live). I can't see how we square this circle.
> 
> > I'll expand on what I understand (or think I do) about RAS at the
> > moment. It should hopefully highlight anything wrong with my reasoning
> > for your questions.
> > 
> > DISR_EL1.A being set means a pending physical SError has been
> > consumed/cleared. The host has already deferred an SError so saving and
> > restoring (i.e. preserving) DISR_EL1 for the host would mean the
> > deferred SError is as it was on return to the host.
> 
> [..]
> 
> > If there is a pending physical SError, we'd have to keep it pending so
> > the host can consume it.
> 
> I agree!
> 
> 
> > __guest_enter has the dsb-isb for RAS so
> > SErrors will become pending, but it doesn't consume them.
> 
> 
> > I can't
> > remember now whether this was reliable or not; I assumed it was as it is
> > gated on the RAS config.
> 
> It should be reliable for 'asynchronous external abort', but not 'SError Interrupt', both
> of which are signalled via the SError vector.

Uh oh, more terms with differences that I don't understand yet.

I assume that there aren't SError Interrupts that we would be concerned
about being deliered to the guest that should have been delivered to the
host after checing for asynchronous external aborts? At least, that seem
to be the current behaviour if I'm reading things right.

> The DSB completes previous memory accesses, so that the components they land in can return
> an abort if they need to. The ISB ensures the abort is seen as pending in ISR_EL1 before
> the CPU reads it.
> 
> The ESB-instruction is potentially cheaper, (as cheap as a nop if all errors are going to
> be reported as uncontained anyway), but it has the nasty side effect of consuming the
> error, which we don't want here.
>
>
> > The above didn't need an ESB for the host but incorrect assumptions
> > might change that.
> > 
> >> Furthermore, assuming you find a way to do it, what do you do with it?
> >>
> >> (a) Either there was something pending already and it is still pending,
> 
> > If a physical SError is pending, you leave it pending and go back to the
> > host so it can consume it.
> 
> Great idea!
> If the CPU has IESB, you can just check ISR_EL1 on entry from the host.
> If not, you'll need some extra barriers.

I'm not sure it would be easy to check ISR_EL1 and bail to the host in
the general case as it would require a meaningful return code for each
context, something like EAGAIN that doesn't exist in the hyp interfaces.

I was instead thinking that EL2 would continue as usual except it won't
consume any SErrors with the ESB. Care is needed when a vCPU is being
run and the DSB-ISB + ISR_EL1 check in __guest_enter is be there to
prevent a guest being entered if the host needs to handle an SError.

> >> (b) Or there was nothing pending and you now have an error that you
> >>     don't know how to report (the host EL1 never issued an ESB)
> > 
> > If there isn't a physical SError pending, either there is no SError at
> > all (easy) or the SError has already been consumed to DISR_EL1 by a host
> > ESB and we'd preserve DISR_EL1 for the host to handle however it chooses.
> 
> (I think this is a host bug)
> 
> 
> >> We could just error out on hypercalls if DISR_EL1 is non-zero, but
> >> I don't see how we do that for traps, as it would just confuse the host
> >> EL1.
> > 
> > Traps would need to be left pending. Detected but not consumed with the
> > dsb-isb in __guest_enter.
> 
> You're trapping stuff from the host?

Not yet, but it might happen e.g. to context switch FPSIMD under
protected KVM.

> If you might trap something between the ESB-instruction and the host reading DISR_EL1 then
> you can't use the ESB-instruction in your trap handling path, as it would over-write it.
> This sucks as presumably you want to make it common with the really-a-guest trap handling
> path.
> 
> The best thing to do would be to go the whole-hog and route SError to EL2 with
> HCR_EL2.AMO. SError taken out of the host can be re-injected with HCR_EL2.VSE and
> VSESR_EL2, which will be consumed to VDISR_EL2 if the 'host' executes an ESB-instruction.
> 
> DISR_EL1 then belongs to EL2, meaning its free to use the ESB-instruction as it likes.

Does a save and restore of DISR_EL1 (see other thread on this series)
address the concerns here or would you still think it better to start
virtualizing for the host?

> Thanks,
> 
> James
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
