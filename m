From: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: [PATCH 1/2] ARM: hyp-stub: improve ABI
Date: Thu, 15 Dec 2016 18:57:18 +0000
Message-ID: <20161215185717.GM14217@n2100.armlinux.org.uk>
References: <20161213113044.GC19985@leverpostej>
 <E1cH74w-0003ke-Qp@rmk-PC.armlinux.org.uk>
 <72f93940-cf87-fd91-90f2-760b7ff050fb@arm.com>
 <20161215113539.GK14217@n2100.armlinux.org.uk>
 <06fca797-da5d-f7f2-eecb-9b1b33b7e83f@arm.com>
 <20161215151548.GL14217@n2100.armlinux.org.uk>
 <c21d6514-44a2-ba88-0fe5-d14d5897cc48@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AA3364041B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Dec 2016 13:56:18 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jXW5k8gyXlBG for <kvmarm@lists.cs.columbia.edu>;
 Thu, 15 Dec 2016 13:56:17 -0500 (EST)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 119FD4019C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Dec 2016 13:56:16 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <c21d6514-44a2-ba88-0fe5-d14d5897cc48@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, dave.martin@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Dec 15, 2016 at 03:37:15PM +0000, Marc Zyngier wrote:
> On 15/12/16 15:15, Russell King - ARM Linux wrote:
> > On Thu, Dec 15, 2016 at 11:46:41AM +0000, Marc Zyngier wrote:
> >> On 15/12/16 11:35, Russell King - ARM Linux wrote:
> >>> On Thu, Dec 15, 2016 at 11:18:48AM +0000, Marc Zyngier wrote:
> >>>> On 14/12/16 10:46, Russell King wrote:
> >>>>> @@ -231,10 +244,14 @@ ENDPROC(__hyp_stub_do_trap)
> >>>>>   * initialisation entry point.
> >>>>>   */
> >>>>>  ENTRY(__hyp_get_vectors)
> >>>>> -	mov	r0, #-1
> >>>>> +	mov	r0, #HVC_GET_VECTORS
> >>>>
> >>>> This breaks the KVM implementation of __hyp_get_vectors, easily fixed
> >>>> with the following patchlet:
> >>>
> >>> Right, so what Mark said is wrong:
> >>>
> >>> "The hyp-stub is part of the kernel image, and the API is private to
> >>>  that particular image, so we can change things -- there's no ABI to
> >>>  worry about."
> >>
> >> I think Mark is right. The API *is* private to the kernel, and KVM being
> >> the only in-kernel hypervisor on ARM, this is not an ABI.
> > 
> > Again, that's wrong.
> > 
> > We have two hypervisors in the kernel.  One is KVM, the other is the
> > stub.  Sure, the stub isn't a full implementation of a hypervisor, but
> > it is nevertheless, for the purposes of _this_ discussion, a hypervisor
> > of sorts.
> > 
> > The reason that both are included is because they both appear to share
> > a common interface (although that's totally not documented anywhere.)
> 
> And this interface exists for the sole purpose of enabling KVM. Call it
> a hypervisor if you wish, but its usefulness is doubtful on its own.
> 
> >>> So no, I'm going with my original patch (which TI has tested) which is
> >>> the minimal change, and if we _then_ want to rework the HYP mode
> >>> interfaces, that's the time to do the other changes when more people
> >>> (such as KVM folk) are paying attention and we can come to a cross-
> >>> hypervisor agreement on what the interface should be.
> >>
> >> Given that there is a single in-kernel hypervisor, I can't really see
> >> who we're going to agree anything with...
> > 
> > As far as I can see, the hyp-stub falls under ARM arch maintanence.
> > KVM falls under KVM people.  Two different groups, we need agreement
> > between them what a sane API for both "hypervisors" should be.
> 
> Well, I though we had the right level of discussion by reviewing your
> patches and coming up with improvements. If you're after something else,
> please let me know.

What I'm after is a meaningful discussion between ARM arch maintainers
and KVM maintainers - so far all I see are people on the ARM side of
things.

I've also yet to have any response on some of the KVM questions I raised
earlier in this thread - again, silence from KVM people.

What's also coming clear is that there's very few people who understand
all the interactions here, and the whole thing seems to be an undocumented
mess.  Something needs to change there - people need to stop shovelling
half baked crap into the kernel.  KVM have the privilege of being able to
push ARM stuff directly, I now see that was a very big mistake.

So, I want KVM further changes to come through my tree once this merge
window is over - and I want to see some documentation about how things
hang together, because hardly anyone understands it right now, and that's
_really_ bad.

Let's start with some documentation on the KVM hypervisor interfaces on
32-bit ARM.  Documentation/virtual/kvm/hypercalls.txt already contains
some for x86, s390 and PPC, so that would be a good place to document
the ARM side.  Arguably, that should have already been done.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
