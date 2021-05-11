Return-Path: <SRS0=u/VZ=KG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44194C433B4
	for <kvmarm@archiver.kernel.org>; Tue, 11 May 2021 11:13:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 83F6A61628
	for <kvmarm@archiver.kernel.org>; Tue, 11 May 2021 11:13:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 83F6A61628
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DAF584B4F9;
	Tue, 11 May 2021 07:13:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bqJ9t19DoL4a; Tue, 11 May 2021 07:13:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F0844B463;
	Tue, 11 May 2021 07:13:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 483F34B371
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 May 2021 07:13:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cI5ZMst4L2Sz for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 May 2021 07:13:30 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E538D4B35F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 May 2021 07:13:29 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4A638169E;
 Tue, 11 May 2021 04:13:14 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.29.91])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E11043F719;
 Tue, 11 May 2021 04:13:06 -0700 (PDT)
Date: Tue, 11 May 2021 12:13:03 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v3 3/9] KVM: arm64: vgic: Be tolerant to the lack of
 maintenance interrupt
Message-ID: <20210511111303.GE6152@C02TD0UTHF1T.local>
References: <20210510134824.1910399-1-maz@kernel.org>
 <20210510134824.1910399-4-maz@kernel.org>
 <20210510161907.GD92897@C02TD0UTHF1T.local>
 <87sg2uo54e.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87sg2uo54e.wl-maz@kernel.org>
Cc: kvm@vger.kernel.org, kernel-team@android.com,
 Hector Martin <marcan@marcan.st>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Mon, May 10, 2021 at 06:44:49PM +0100, Marc Zyngier wrote:
> On Mon, 10 May 2021 17:19:07 +0100,
> Mark Rutland <mark.rutland@arm.com> wrote:
> > 
> > On Mon, May 10, 2021 at 02:48:18PM +0100, Marc Zyngier wrote:
> > > As it turns out, not all the interrupt controllers are able to
> > > expose a vGIC maintenance interrupt as a distrete signal.
> > > And to be fair, it doesn't really matter as all we require is
> > > for *something* to kick us out of guest mode out way or another.
> > > 
> > > On systems that do not expose a maintenance interrupt as such,
> > > there are two outcomes:
> > > 
> > > - either the virtual CPUIF does generate an interrupt, and
> > >   by the time we are back to the host the interrupt will have long
> > >   been disabled (as we set ICH_HCR_EL2.EN to 0 on exit). In this case,
> > >   interrupt latency is as good as it gets.
> > > 
> > > - or some other event (physical timer) will take us out of the guest
> > >   anyway, and the only drawback is a bad interrupt latency.
> > 
> > IIRC we won't have a a guaranteed schedular tick for NO_HZ_FULL, so in
> > that case we'll either need to set a period software maintenance
> > interrupt, or reject this combination at runtime (either when trying to
> > isolate the dynticks CPUs, or when trying to create a VM).
> 
> That's a good point.
> 
> On sensible systems, the maintenance interrupt is a standard GIC PPI
> that requires enabling, and that is all that KVM requires (the
> maintenance interrupt is only used as an exit mechanism and will be
> disabled before reaching the handler).
> 
> On the M1, owing to the lack of a per-CPU interrupt controller, there
> is nothing to enable. The virtual CPU interface will fire at will and
> take us out of the guest in a timely manner.

Ah, so the M1 does have a maintenance interrupt, but you can't silence
it at the irqchip level.

> So maybe instead of relaxing the requirement for a maintenance
> interrupt, we should only bypass the checks if the root interrupt
> controller advertises that it is safe to do so, making it a
> M1-specific hack.

That certainly sounds safer than permitting running without any
maintenance interrupt at all.

Thanks,
Mark.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
