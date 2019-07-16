Return-Path: <SRS0=eCDF=VN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE105C76195
	for <kvmarm@archiver.kernel.org>; Tue, 16 Jul 2019 08:47:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9303C2173B
	for <kvmarm@archiver.kernel.org>; Tue, 16 Jul 2019 08:47:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9303C2173B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 368784A534;
	Tue, 16 Jul 2019 04:47:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2SDOsXw8f4fy; Tue, 16 Jul 2019 04:47:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F2DE64A539;
	Tue, 16 Jul 2019 04:47:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A5BB4A534
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Jul 2019 04:47:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lVNC+TzQcUC9 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Jul 2019 04:47:38 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BBD974A4E6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Jul 2019 04:47:38 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 13D242B;
 Tue, 16 Jul 2019 01:47:38 -0700 (PDT)
Received: from e103592.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E94343F59C;
 Tue, 16 Jul 2019 01:47:36 -0700 (PDT)
Date: Tue, 16 Jul 2019 09:47:34 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [RFC] Add virtual SDEI support in qemu
Message-ID: <20190716084734.GL2790@e103592.cambridge.arm.com>
References: <1b0aa6b2-80b1-a72e-6849-7323c3b9c6bc@huawei.com>
 <20190715134059.GJ2790@e103592.cambridge.arm.com>
 <20190715134848.GI56232@lakrids.cambridge.arm.com>
 <4daefb19-6c15-f82c-31e9-1ae035d45bd5@arm.com>
 <20190715144446.GK56232@lakrids.cambridge.arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190715144446.GK56232@lakrids.cambridge.arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Cc: Marc Zyngier <marc.zyngier@arm.com>, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, Guoheyi <guoheyi@huawei.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Mon, Jul 15, 2019 at 03:44:46PM +0100, Mark Rutland wrote:
> On Mon, Jul 15, 2019 at 03:26:39PM +0100, James Morse wrote:
> > On 15/07/2019 14:48, Mark Rutland wrote:
> > > On Mon, Jul 15, 2019 at 02:41:00PM +0100, Dave Martin wrote:
> > >> One option (suggested to me by James Morse) would be to allow userspace
> > >> to disable in the in-kernel PSCI implementation and provide its own
> > >> PSCI to the guest via SMC -- in which case userspace that wants to
> > >> implement SDEI would have to implement PSCI as well.
> > > 
> > > I think this would be the best approach, since it puts userspace in
> > > charge of everything.
> > > 
> > > However, this interacts poorly with FW-based mitigations that we
> > > implement in hyp. I suspect we'd probably need a mechanism to delegate
> > > that responsibility back to the kernel, and figure out if that has any
> > > interaction with thigns that got punted to userspace...
> > 
> > This has come up before:
> > https://lore.kernel.org/r/59C139D0.3040507@arm.com
> > 
> > I agree Qemu should opt-in to this, it needs to be a feature that is enabled.
> > 
> > I had an early version of something like this for testing SDEI before
> > there was firmware available. The review feedback from Christoffer was
> > that it should include HVC and SMC, their immediates, and shouldn't be
> > tied to SMC-CC ranges.
> > 
> > I think this should be a catch-all as Heyi describes to deliver
> > 'unhandled SMC/HVC' to user-space as hypercall exits. We should
> > include the immediate in the struct.
> > 
> > We can allow Qemu to disable the in-kernel PSCI implementation, which
> > would let it be done in user-space via this catch-all mechanism. (PSCI
> > in user-space has come up on another thread recently). The in-kernel
> > PSCI needs to be default-on for backwards compatibility.
> > 
> > As Mark points out, the piece that's left is the 'arch workaround'
> > stuff. We always need to handle these in the kernel. I don't think
> > these should be routed-back, they should be un-obtainable by
> > user-space.
> 
> Sure; I meant that those should be handled in the kernel rather than
> going to host userspace and back.
> 
> I was suggesting was that userspace would opt into taking ownership of
> all HVC calls, then explicitly opt-in to the kernel handling specific
> (sets of) calls.

The most logical thing to do would be to have userspace handle all
calls, but add an ioctl to forward a call to KVM.  This puts userspace
in charge of the SMCCC interface, with KVM handling only those things
that userspace can't do for itself, on request.

If the performance overhead is unacceptable for certain calls, we could
have a way to delegate specific function IDs to KVM.  I suspect that
will be the exception rather than the rule.

> There are probably issues with that, but I suspect defining "all
> undandled calls" will be problematic otherwise.

Agreed: the set of calls not handled by KVM will mutate over time.

Cheers
---Dave
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
