From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 1/2] ARM: hyp-stub: improve ABI
Date: Mon, 9 Jan 2017 14:26:36 +0100
Message-ID: <20170109132636.GH4348@cbox>
References: <20161213113044.GC19985@leverpostej>
 <E1cH74w-0003ke-Qp@rmk-PC.armlinux.org.uk>
 <72f93940-cf87-fd91-90f2-760b7ff050fb@arm.com>
 <20161215113539.GK14217@n2100.armlinux.org.uk>
 <06fca797-da5d-f7f2-eecb-9b1b33b7e83f@arm.com>
 <20161215151548.GL14217@n2100.armlinux.org.uk>
 <c21d6514-44a2-ba88-0fe5-d14d5897cc48@arm.com>
 <20161215185717.GM14217@n2100.armlinux.org.uk>
 <20170103095149.GA14242@cbox>
 <20170109122639.GX14217@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CE123403FB
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 08:24:59 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id riMWH+21XVhO for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Jan 2017 08:24:57 -0500 (EST)
Received: from mail-lf0-f51.google.com (mail-lf0-f51.google.com
 [209.85.215.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9285F401A1
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 08:24:57 -0500 (EST)
Received: by mail-lf0-f51.google.com with SMTP id m78so73103054lfg.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 Jan 2017 05:26:39 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20170109122639.GX14217@n2100.armlinux.org.uk>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: Marc Zyngier <marc.zyngier@arm.com>, dave.martin@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jan 09, 2017 at 12:26:39PM +0000, Russell King - ARM Linux wrote:
> On Tue, Jan 03, 2017 at 10:51:49AM +0100, Christoffer Dall wrote:
> > Hi Russell,
> > 
> > On Thu, Dec 15, 2016 at 06:57:18PM +0000, Russell King - ARM Linux wrote:
> > > What's also coming clear is that there's very few people who understand
> > > all the interactions here, and the whole thing seems to be an undocumented
> > > mess.  
> > 
> > I think the hyp stub has just served a very limited purpose so far, and
> > therefore is a somewhat immature implementation.  Now we've discovered a
> > need to clean it up, and we're all for that.  Again, I don't think the
> > problem is any larger than that, we just need to fix it, and it seems to
> > me everyone is willing to work on that.
> 
> What I want to see is some documentation of the hyp-stub, so that there
> can be some element of confidence that changes there are properly
> coordinated.  As I said in a follow up email:
> 
> | Either we need more people to have an understanding (so if one of them
> | gets run over by a bus, we're not left floundering around) or we need
> | it to be documented - even if it's just a simple comment "the ABI in
> | this file is shared with XYZ, if you change the ABI here, also update
> | XYZ too."
> 
> > Marc even offered to work on your suggestion to support the general
> > hyp ABI commands in KVM.
> 
> ... which is pointless, because it's a duplication of the effort I've
> already put in.  My patches already do the:
> 
> #define HVC_GET_VECTORS 0
> #define HVC_SET_VECTORS 1
> #define HVC_SOFT_RESTART 2
> 
> thing which ARM64 does, passing the arguments in via the appropriate
> registers.  However, such a change is a major revision of hyp-stub's
> ABI, which completely changes the way it works.

Sorry, I'm afraid I might have been unclear.  What I meant with "general
hyp ABI commands in KVM" was, that if there's a need for KVM to support
the operations (using a unified and documented ABI) that the hyp stub
supports, then we could add that in KVM as well.  I thought your patches
added the functionality for the hyp stub, and Marc would add whichever
remaining pieces in the KVM side.


[...]

> 
> Longer term, I'd like to see the existing hypervisor documentation in
> Documentation/virtual/kvm/hypercalls.txt updated with the ARM details.
> According to that document, KVM effectively only exists on PPC and x86
> at the present time...
> 

I'm afraid I don't think this is right place to document this behavior.

There's a difference between an internal ABI between code running in two
CPU modes but both part of the same kernel, and a hypervisor running
a guest OS on top.

I believe that Documentation/virtual/kvm/hypercalls.txt documents the
latter case (i.e. guest hypercalls supported by the KVM host
hypervisor), not the former case, and these things should not be
combined.

I would suggest adding something like
Documentation/virtual/kvm/arm/hyp-abi.txt instead.

-Christoffer
