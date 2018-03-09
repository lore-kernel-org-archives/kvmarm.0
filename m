From: Christoffer Dall <cdall@kernel.org>
Subject: Re: [RFC PATCH] KVM: arm/arm64: vgic: change condition for level
 interrupt resampling
Date: Fri, 9 Mar 2018 13:36:12 -0800
Message-ID: <20180309213612.GD1917@lvm>
References: <1520492490-7943-1-git-send-email-shunyong.yang@hxt-semitech.com>
 <9ad47673-068e-f732-d2ca-9c76a8fbdfbc@arm.com>
 <0a15633d-8944-cb9b-3e6b-b08ee5ec42b9@arm.com>
 <20180308161900.GC1917@lvm>
 <86r2oubho3.wl-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <86r2oubho3.wl-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Shunyong Yang <shunyong.yang@hxt-semitech.com>, ard.biesheuvel@linaro.org, will.deacon@arm.com, eric.auger@redhat.com, david.daney@cavium.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, Joey Zheng <yu.zheng@hxt-semitech.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Mar 08, 2018 at 05:28:44PM +0000, Marc Zyngier wrote:
> On Thu, 08 Mar 2018 16:19:00 +0000,
> Christoffer Dall wrote:
> > 
> > On Thu, Mar 08, 2018 at 11:54:27AM +0000, Marc Zyngier wrote:
> > > On 08/03/18 09:49, Marc Zyngier wrote:

[...]

> > > The state is now pending, we've really EOI'd the interrupt, and
> > > yet lr_signals_eoi_mi() returns false, since the state is not 0.
> > > The result is that we won't signal anything on the corresponding
> > > irqfd, which people complain about. Meh.
> > 
> > So the core of the problem is that when we've entered the guest with
> > PENDING+ACTIVE and when we exit (for some reason) we don't signal the
> > resamplefd, right?  The solution seems to me that we don't ever do
> > PENDING+ACTIVE if you need to resample after each deactivate.  What
> > would be the point of appending a pending state that you only know to be
> > valid after a resample anyway?
> 
> The question is then to identify that a given source needs to be
> signalled back to VFIO. Calling into the eventfd code on the hot path
> is pretty horrid (I'm not sure if we can really call into this with
> interrupts disabled, for example).
> 

This feels like a bad layering violation to me as well.

> > 
> > > 
> > > Example 2:
> > > P+A -> guest EOI -> P -> delayed MI -> guest IAR -> A -> MI fires
> > 
> > We could be more clever and do the following calculation on every exit:
> > 
> > If you enter with P, and exit with either A or 0, then signal.
> > 
> > If you enter with P+A, and you exit with either P, A, or 0, then signal.
> > 
> > Wouldn't that also solve it?  (Although I have a feeling you'd miss some
> > exits in this case).
> 
> I'd be more confident if we did forbid P+A for such interrupts
> altogether, as they really feel like another kind of HW interrupt.

How about a slightly bigger hammer:  Can we avoid doing P+A for level
interrupts completely?  I don't think that really makes much sense, and
I think we simply everything if we just come back out and resample the
line.  For an edge, something like a network card, there's a potential
performance win to appending a new pending state, but I doubt that this
is the case for level interrupts.

The timer would be unaffected, because it's a HW interrupt.

Thanks,
-Christoffer
