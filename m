From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 1/2] ARM: hyp-stub: improve ABI
Date: Sat, 17 Dec 2016 12:07:11 +0000
Message-ID: <20161217120707.GA72718@MBP.local>
References: <20161213113044.GC19985@leverpostej>
 <E1cH74w-0003ke-Qp@rmk-PC.armlinux.org.uk>
 <72f93940-cf87-fd91-90f2-760b7ff050fb@arm.com>
 <20161215113539.GK14217@n2100.armlinux.org.uk>
 <06fca797-da5d-f7f2-eecb-9b1b33b7e83f@arm.com>
 <20161215151548.GL14217@n2100.armlinux.org.uk>
 <c21d6514-44a2-ba88-0fe5-d14d5897cc48@arm.com>
 <20161215185717.GM14217@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 16A95401B9
 for <kvmarm@lists.cs.columbia.edu>; Sat, 17 Dec 2016 07:06:05 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RgKad1ohnguW for <kvmarm@lists.cs.columbia.edu>;
 Sat, 17 Dec 2016 07:06:03 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A9F9740199
 for <kvmarm@lists.cs.columbia.edu>; Sat, 17 Dec 2016 07:06:03 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20161215185717.GM14217@n2100.armlinux.org.uk>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, dave.martin@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Russell,

Just a quick reply expressing my opinion on the ABI and KVM maintenance
topics. Sorry I won't be able to follow up until the new year as I go on
holiday soon.

On Thu, Dec 15, 2016 at 06:57:18PM +0000, Russell King - ARM Linux wrote:
> On Thu, Dec 15, 2016 at 03:37:15PM +0000, Marc Zyngier wrote:
> > On 15/12/16 15:15, Russell King - ARM Linux wrote:
> > > On Thu, Dec 15, 2016 at 11:46:41AM +0000, Marc Zyngier wrote:
> > >> On 15/12/16 11:35, Russell King - ARM Linux wrote:
> > >>> On Thu, Dec 15, 2016 at 11:18:48AM +0000, Marc Zyngier wrote:
> > >>>> On 14/12/16 10:46, Russell King wrote:
> > >>>>> @@ -231,10 +244,14 @@ ENDPROC(__hyp_stub_do_trap)
> > >>>>>   * initialisation entry point.
> > >>>>>   */
> > >>>>>  ENTRY(__hyp_get_vectors)
> > >>>>> -	mov	r0, #-1
> > >>>>> +	mov	r0, #HVC_GET_VECTORS
> > >>>>
> > >>>> This breaks the KVM implementation of __hyp_get_vectors, easily fixed
> > >>>> with the following patchlet:
> > >>>
> > >>> Right, so what Mark said is wrong:
> > >>>
> > >>> "The hyp-stub is part of the kernel image, and the API is private to
> > >>>  that particular image, so we can change things -- there's no ABI to
> > >>>  worry about."
> > >>
> > >> I think Mark is right. The API *is* private to the kernel, and KVM being
> > >> the only in-kernel hypervisor on ARM, this is not an ABI.
> > > 
> > > Again, that's wrong.
> > > 
> > > We have two hypervisors in the kernel.  One is KVM, the other is the
> > > stub.  Sure, the stub isn't a full implementation of a hypervisor, but
> > > it is nevertheless, for the purposes of _this_ discussion, a hypervisor
> > > of sorts.
> > > 
> > > The reason that both are included is because they both appear to share
> > > a common interface (although that's totally not documented anywhere.)
> > 
> > And this interface exists for the sole purpose of enabling KVM. Call it
> > a hypervisor if you wish, but its usefulness is doubtful on its own.

IMO, the interface between EL1 and EL2 _is_ ABI. However, it should not
be confused with a *stable* ABI like the one we expose to user. Since
all users of the EL2 ABI live inside the kernel (either on the EL1 or
EL2 side), we are free to change it as long as everything is updated
simultaneously. I don't see this any different from other in-kernel ABI
like that exposed to loadable modules (for the latter, we have the
advantage of a partly self-documenting ABI as part of the C language).

I would welcome some documentation for the EL2 ABI as well, especially
since head.S and the KVM counterpart is maintained by different people.

> What's also coming clear is that there's very few people who understand
> all the interactions here, and the whole thing seems to be an undocumented
> mess.  Something needs to change there - people need to stop shovelling
> half baked crap into the kernel.  KVM have the privilege of being able to
> push ARM stuff directly, I now see that was a very big mistake.
> 
> So, I want KVM further changes to come through my tree once this merge
> window is over -

I'm afraid I strongly disagree. There are a few reasons neither you nor
me gatekeep the KVM port: (a) the ARM KVM maintainers know a lot more
about KVM than either of us, (b) the KVM code under arch/arm is reused
by arm64 and (c) you or I would certainly become a bottleneck. There is
a lot more to KVM support on ARM than the hyp stub and realistically you
won't have the time to review all the stuff that comes your way.

Just because there is an interface between two or more pieces of code,
it is not a strong enough argument for them to have the same gatekeeper
(I wouldn't say maintainer since IMO this implies a lot more). That
said, you can always advise other maintainers on how to do things right,
ask for proper documentation (as you did), review how things are defined
and implemented, especially when they touch code _you_ maintain.

> Let's start with some documentation on the KVM hypervisor interfaces on
> 32-bit ARM.  Documentation/virtual/kvm/hypercalls.txt already contains
> some for x86, s390 and PPC, so that would be a good place to document
> the ARM side.  Arguably, that should have already been done.

I'm all for documenting the interface.

(even though Will and I co-maintain arch/arm64, I deliberately kept his
name out of the above as I haven't had the chance to ask for his
opinion on this matter, which may as well differ)

I have to go and pack now. Merry Christmas!

-- 
Catalin
