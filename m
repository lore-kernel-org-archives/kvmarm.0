From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 1/2] ARM: hyp-stub: improve ABI
Date: Tue, 3 Jan 2017 10:51:49 +0100
Message-ID: <20170103095149.GA14242@cbox>
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
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E88F408B3
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Jan 2017 04:50:19 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wUDYPsalKkHD for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 Jan 2017 04:50:17 -0500 (EST)
Received: from mail-lf0-f50.google.com (mail-lf0-f50.google.com
 [209.85.215.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6309F406F1
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Jan 2017 04:50:16 -0500 (EST)
Received: by mail-lf0-f50.google.com with SMTP id c13so282487323lfg.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 03 Jan 2017 01:51:50 -0800 (PST)
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, dave.martin@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Russell,

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
> > 
> > >>> So no, I'm going with my original patch (which TI has tested) which is
> > >>> the minimal change, and if we _then_ want to rework the HYP mode
> > >>> interfaces, that's the time to do the other changes when more people
> > >>> (such as KVM folk) are paying attention and we can come to a cross-
> > >>> hypervisor agreement on what the interface should be.
> > >>
> > >> Given that there is a single in-kernel hypervisor, I can't really see
> > >> who we're going to agree anything with...
> > > 
> > > As far as I can see, the hyp-stub falls under ARM arch maintanence.
> > > KVM falls under KVM people.  Two different groups, we need agreement
> > > between them what a sane API for both "hypervisors" should be.
> > 
> > Well, I though we had the right level of discussion by reviewing your
> > patches and coming up with improvements. If you're after something else,
> > please let me know.
> 
> What I'm after is a meaningful discussion between ARM arch maintainers
> and KVM maintainers - so far all I see are people on the ARM side of
> things.

I think your patches look fine, and I agree with your suggestions on
improving the hyp ABI and documenting it.

Marc found a small problem for KVM with your patch and offered a simple
fix.  I don't really see a bigger problem here?

> 
> I've also yet to have any response on some of the KVM questions I raised
> earlier in this thread - again, silence from KVM people.

Sorry about my silence, I was really busy leading up to Christmas and
was offline for most of the Christmas and new years days.

I've gone back over the thread and haven't been able to spot anything
that wasn't already answered by Marc (who also maintains KVM so would be
one of the KVM people).  Could you let me know which questions remain
unanswered and I can try to help?

> 
> What's also coming clear is that there's very few people who understand
> all the interactions here, and the whole thing seems to be an undocumented
> mess.  

I think the hyp stub has just served a very limited purpose so far, and
therefore is a somewhat immature implementation.  Now we've discovered a
need to clean it up, and we're all for that.  Again, I don't think the
problem is any larger than that, we just need to fix it, and it seems to
me everyone is willing to work on that.  Marc even offered to work on
your suggestion to support the general hyp ABI commands in KVM.

[...]
> 
> So, I want KVM further changes to come through my tree once this merge
> window is over 

I think we should try to separate the discussion of fixing an immediate
problem with the hyp code, and that of how to maintain things.  I think
we're already on the right track to fix the former.

Before we start changing up maintainerships (which I personally think
work fine as it is) I would encourage you to just comment on patches
touching arch/arm that you are unhappy with.

We have been cc'ing all our changes to lakml and we've tried to cc you
specifically on anything touching arch/arm, and we will listen to any
suggestions you may have.

Thanks,
-Christoffer
