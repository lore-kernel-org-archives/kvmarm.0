From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] KVM: arm/arm64: BUG FIX: Do not inject spurious interrupts
Date: Mon, 14 Sep 2015 13:29:32 +0200
Message-ID: <20150914112932.GH15712@cbox>
References: <1440676282-2152-1-git-send-email-p.fedin@samsung.com>
 <20150827124442.GD29439@cbox>
 <00ca01d0e171$7ff1c710$7fd55530$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0BB91412F2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Sep 2015 07:26:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gY2vX7LcZBZR for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Sep 2015 07:26:57 -0400 (EDT)
Received: from mail-lb0-f171.google.com (mail-lb0-f171.google.com
 [209.85.217.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E031141291
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Sep 2015 07:26:56 -0400 (EDT)
Received: by lbcjc2 with SMTP id jc2so65496925lbc.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Sep 2015 04:27:49 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <00ca01d0e171$7ff1c710$7fd55530$@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Pavel Fedin <p.fedin@samsung.com>
Cc: 'Marc Zyngier' <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Aug 28, 2015 at 12:11:17PM +0300, Pavel Fedin wrote:
>  Hello!
> 
> > It's a bit weird to just sned this as a new patch without replying to my
> > mail from yesterday with feedback
> 
>  Sorry. But changes are actually minimal, and i remember that i replied to you with the promise of
> testing your suggestion. So, done, works fine. :)
> 
> > I think you're missing a potential change to the irq_pending_on_cpu
> > field here, which you have to compute by calling vgic_update_state()
> > like we do elsewhere when we change status bits
> 
>  I have just checked this. vgic_update_state() never resets this bit. This bit is reset only in
> __kvm_vgic_flush_hwstate() and only if we have consumed completely everything. I have followed
> through the code and looks like it's perfectly safe to have this bit set while nothing is actually
> pendng. Following __kvm_vgic_flush_hwstate(), having this bit cleared is actually a shorthand for
> "no interrupt is pending at all". If it is set without any interrupt actually being pending (this
> ends up in pa_percpu and pa_shared being all zeroes), all three for_each_set_bit() loops will just
> not do anything, and we still get to "epilog:" label, just after a bit longer check. And, since we
> are here, the guest has already been disturbed.

ok, looks like it is functionally correct, but I'm not thrilled about us
setting the state in the VGIC to something is pending on the CPU, when
really there is not.  In that case, we should explicitly mark the bit as
a hint and not rely on its correctness and your patch should explain
this in vgic_update_irq_pending().

The alternative is to just call compute_pending which does nothing more
than a few bitwise and/or operations plus a couple of handfuls of
load/stores on this IRQ injection path, so I don't see the problem doing
this.

Does the code look awful?  If so, why?

> 
> > different from the incorrect approach I suggested yesterday where we
> > always just clear the bit for that vcpu).
> 
>  Yes, it is extremely bad idea to clear it because this bit summarizes all interrupts for this vcpu,
> and clearing it means that we are going to lose everything.

yes, I see this.

>  An alternate would be: clear the bit, THEN call vgic_update_state() which would set it back if
> necessary. But does this extra bit of complexity worth anything, given one paragraph above?
> 
I'm not sure your suggested approach works, because you could still
loose state for other IRQs I think.

-Christoffer
