From: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: [PATCH 1/2] ARM: hyp-stub: improve ABI
Date: Mon, 9 Jan 2017 12:26:39 +0000
Message-ID: <20170109122639.GX14217@n2100.armlinux.org.uk>
References: <20161213113044.GC19985@leverpostej>
 <E1cH74w-0003ke-Qp@rmk-PC.armlinux.org.uk>
 <72f93940-cf87-fd91-90f2-760b7ff050fb@arm.com>
 <20161215113539.GK14217@n2100.armlinux.org.uk>
 <06fca797-da5d-f7f2-eecb-9b1b33b7e83f@arm.com>
 <20161215151548.GL14217@n2100.armlinux.org.uk>
 <c21d6514-44a2-ba88-0fe5-d14d5897cc48@arm.com>
 <20161215185717.GM14217@n2100.armlinux.org.uk>
 <20170103095149.GA14242@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 35AB74019C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 07:25:08 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UE3kF+BUBZDB for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Jan 2017 07:25:06 -0500 (EST)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B4AAB400F3
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 07:25:06 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20170103095149.GA14242@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, dave.martin@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jan 03, 2017 at 10:51:49AM +0100, Christoffer Dall wrote:
> Hi Russell,
> 
> On Thu, Dec 15, 2016 at 06:57:18PM +0000, Russell King - ARM Linux wrote:
> > What's also coming clear is that there's very few people who understand
> > all the interactions here, and the whole thing seems to be an undocumented
> > mess.  
> 
> I think the hyp stub has just served a very limited purpose so far, and
> therefore is a somewhat immature implementation.  Now we've discovered a
> need to clean it up, and we're all for that.  Again, I don't think the
> problem is any larger than that, we just need to fix it, and it seems to
> me everyone is willing to work on that.

What I want to see is some documentation of the hyp-stub, so that there
can be some element of confidence that changes there are properly
coordinated.  As I said in a follow up email:

| Either we need more people to have an understanding (so if one of them
| gets run over by a bus, we're not left floundering around) or we need
| it to be documented - even if it's just a simple comment "the ABI in
| this file is shared with XYZ, if you change the ABI here, also update
| XYZ too."

> Marc even offered to work on your suggestion to support the general
> hyp ABI commands in KVM.

... which is pointless, because it's a duplication of the effort I've
already put in.  My patches already do the:

#define HVC_GET_VECTORS 0
#define HVC_SET_VECTORS 1
#define HVC_SOFT_RESTART 2

thing which ARM64 does, passing the arguments in via the appropriate
registers.  However, such a change is a major revision of hyp-stub's
ABI, which completely changes the way it works.

The issue here is that there seems to be only one person, Marc, who
understands that the KVM hypervisor also needs to be updated - everyone
else I've talked to was of the opinion that hyp-stub's ABI is limited
to hyp-stub.S.  That's worse than "I don't know" because it leads to
exactly the situation that my patches created: the two ABIs going out
of step.

What I'm asking for is a patch to add some sort of documentation ASAP
which ensures that this important non-obvious information isn't limited
to just one person.  As I mentioned in the quote above, it can be as
simple as merely pointing each file at its counterparts which have to
be updated at the same time.

Longer term, I'd like to see the existing hypervisor documentation in
Documentation/virtual/kvm/hypercalls.txt updated with the ARM details.
According to that document, KVM effectively only exists on PPC and x86
at the present time...

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
