Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4AC8C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 15 Dec 2021 14:32:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 30CD04A98B;
	Wed, 15 Dec 2021 09:32:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9bgSCkCZOlyc; Wed, 15 Dec 2021 09:32:12 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AEBED49E5F;
	Wed, 15 Dec 2021 09:32:12 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E89744B0B4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Dec 2021 09:32:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9xLymk3N1bKR for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Dec 2021 09:32:10 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 076E24B09C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Dec 2021 09:32:09 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 842511FB;
 Wed, 15 Dec 2021 06:32:09 -0800 (PST)
Received: from FVFF77S0Q05N (unknown [10.57.67.176])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 21DA23F774;
 Wed, 15 Dec 2021 06:32:07 -0800 (PST)
Date: Wed, 15 Dec 2021 14:32:04 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v4 1/6] KVM: arm64: Correctly treat writes to OSLSR_EL1
 as undefined
Message-ID: <Ybn8ZK29AI18WGPQ@FVFF77S0Q05N>
References: <20211214172812.2894560-1-oupton@google.com>
 <20211214172812.2894560-2-oupton@google.com>
 <YbnUDny3GSNpyabJ@FVFF77S0Q05N> <YbnpCFBPNgmkEXjf@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YbnpCFBPNgmkEXjf@google.com>
Cc: linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
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

On Wed, Dec 15, 2021 at 01:09:28PM +0000, Oliver Upton wrote:
> Hi Mark,
> 
> On Wed, Dec 15, 2021 at 11:39:58AM +0000, Mark Rutland wrote:
> > Hi Oliver,
> > 
> > On Tue, Dec 14, 2021 at 05:28:07PM +0000, Oliver Upton wrote:
> > > Any valid implementation of the architecture should generate an
> > > undefined exception for writes to a read-only register, such as
> > > OSLSR_EL1. Nonetheless, the KVM handler actually implements write-ignore
> > > behavior.
> > > 
> > > Align the trap handler for OSLSR_EL1 with hardware behavior. If such a
> > > write ever traps to EL2, inject an undef into the guest and print a
> > > warning.
> > 
> > I think this can still be read amibguously, since we don't explicitly state
> > that writes to OSLSR_EL1 should never trap (and the implications of being
> > UNDEFINED are subtle). How about:
> > 
> > | Writes to OSLSR_EL1 are UNDEFINED and should never trap from EL1 to EL2, but
> > | the KVM trap handler for OSLSR_EL1 handlees writes via ignore_write(). This

Whoops, with s/handlees/handles/

> > | is confusing to readers of the code, but shouldn't have any functional impact.
> > |
> > | For clarity, use write_to_read_only() rather than ignore_write(). If a trap
> > | is unexpectedly taken to EL2 in violation of the architecture, this will
> > | WARN_ONCE() and inject an undef into the guest.
> 
> Agreed, I like your suggested changelog better :-)

Cool!

Mark.

> 
> > With that:
> > 
> > Reviewed-by: Mark Rutland <mark.rutland@arm.com>
> 
> Thanks!
> 
> --
> Best,
> Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
