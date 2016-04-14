From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC PATCH 06/45] KVM: arm/arm64: vgic-new: Implement virtual
 IRQ injection
Date: Thu, 14 Apr 2016 16:05:20 +0200
Message-ID: <20160414140520.GN30804@cbox>
References: <1458871508-17279-1-git-send-email-andre.przywara@arm.com>
 <1458871508-17279-7-git-send-email-andre.przywara@arm.com>
 <20160329211650.GF4126@cbox> <5703F5D7.5060803@arm.com>
 <20160406142358.GA26026@cbox> <570F769A.7040104@arm.com>
 <20160414121506.GI30804@cbox> <570F9F0D.9020501@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3816A49BB9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Apr 2016 10:03:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id e4BXsng7demC for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Apr 2016 10:03:16 -0400 (EDT)
Received: from mail-wm0-f43.google.com (mail-wm0-f43.google.com [74.125.82.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 34DB749BB8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Apr 2016 10:03:15 -0400 (EDT)
Received: by mail-wm0-f43.google.com with SMTP id v188so221860285wme.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Apr 2016 07:04:59 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <570F9F0D.9020501@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Apr 14, 2016 at 02:45:49PM +0100, Andre Przywara wrote:
> Hi,
> 
> ....
> 
> >>>>>> +	if (irq->vcpu || !(irq->pending && irq->enabled) || !vcpu) {
> >>>>>> +		/*
> >>>>>> +		 * If this IRQ is already on a VCPU's ap_list, then it
> >>>>>> +		 * cannot be moved or modified and there is no more work for
> >>>>>> +		 * us to do.
> >>>>>> +		 *
> >>>>>> +		 * Otherwise, if the irq is not pending and enabled, it does
> >>>>>> +		 * not need to be inserted into an ap_list and there is also
> >>>>>> +		 * no more work for us to do.
> >>>>>> +		 */
> >>>>>
> >>>>> is the !vcpu check here not redundant because if you ever get to
> >>>>> evaluating it, then irq->vcpu is null, and pending and enabled are set,
> >>>>> which means the oracle couldn't have returned null, could it?
> >>>>
> >>>> In this case vcpu is always irq->target_vcpu, if I did the math
> >>>> correctly. So can this be NULL?
> >>>> Even if this is correct reasoning, I wonder if we optimize something
> >>>> prematurely here and rely on the current implementation of
> >>>> vgic_target_oracle(). I think the check for "!vcpu" is here to avoid a
> >>>> NULL pointer deference below (in the first spin_lock after the retry:
> >>>> label), so I'd rather keep this explicit check in here.
> >>>
> >>> I'm really not a fan of building the correctness of one of the most
> >>> crucial parts of our code based on "let's add a few extra checks which
> >>> may not be necessary, just in case" kind of logic.
> >>>
> >>> So let's be clear on why we have an if-statement here exactly:
> >>>
> >>> As the comment says, if we can't move the IRQ, because it's already
> >>> assigned to somebody or if this IRQ is not pending or active, then it's
> >>> shouldn't be queued.
> >>>
> >>> So the simple and all-encompassing check here is simply:
> >>>
> >>> 	if (irq->vcpu || !vcpu) {
> >>> 		spin_unlock(&irq->irq_lock);
> >>> 		return false;
> >>> 	}
> >>>
> >>> The only requirement for this to be correct is that the MMIO handler for
> >>> ISACTIVER to both set the active bit and the irq->vcpu pointer (and put
> >>> it on the AP list), without calling this function...).  That was my
> >>> quesiton below.
> >>>
> >>> Because if that's not the case, you could end up here with irq->active
> >>> set, but irq->vcpu == NULL and !(pending && enabled) and you'd error
> >>> out, which means you would have to check explicitly for the active state
> >>> here as well, but I think that just becomes too messy.
> >>>
> >>> So, just change this to what I propose and we can deal with the active
> >>> state MMIO handler separately.
> >>
> >> I agree that setting the active state via MMIO is a mess in general and
> >> stuffing this case into this function here gets hairy.
> >> I am tempted to not support it in the first version, I guess it never
> >> really worked reliably before ...
> > 
> > I'm pretty sure it did, because we ran into migration breaking when this
> > wasn't supported for the save/restore userspace interface.
> 
> Well, I was more concerned about the reliability part in there and all
> the corner cases. Not sure if anyone actually tested this from within a
> guest.
> 

probably not.

> >>
> >> At the moment I am trying to code this explicitly into the SACTIVER
> >> handler and it's messy, too (because of the corner cases).
> >> Let's see how this will look like ...
> > 
> > ok.
> > 
> > If you want, you can focus on getting a new version out, and I can take
> > a stab at the SACTIVER together with the priority stuff.  OTOH, if you
> > already have something, then it may be worth following through with
> > that.
> 
> Yeah, so by now I have something which doesn't look too bad. Copied your
> style with many comments ;-)
> 
> I will now clean up the patches and try to send something out still
> today. I think by now there are significantly enough changes to justify
> a new revision, even if I haven't addressed every single bit of the
> comments yet.

I quite prefer you work through all the comments carefully before
sending out a new revision.

I think the key here is to improve stability and quality between each
revision as much as possible.

Also, as you know, I really don't want to go over issues I've already
commented on before.

Thanks,
-Christoffer
