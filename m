From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH 0/5] KVM/ARM: Fixes for 4.12-rc1
Date: Tue, 2 May 2017 19:15:55 +0200
Message-ID: <20170502171555.GA12916@cbox>
References: <20170502133041.10980-1-marc.zyngier@arm.com>
 <75f031d5-d16e-6311-af44-f2c5af5bded4@redhat.com>
 <c9f36b35-6a46-8ed8-0bb0-9c099f28d834@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <c9f36b35-6a46-8ed8-0bb0-9c099f28d834@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Christoffer Dall <christoffer.dall@linaro.org>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, May 02, 2017 at 04:00:49PM +0100, Marc Zyngier wrote:
> On 02/05/17 15:44, Paolo Bonzini wrote:
> > 
> > 
> > On 02/05/2017 15:30, Marc Zyngier wrote:
> >> Here's a handful of random fixes I've queued locally that didn't have
> >> a chance to make it in 4.11.
> >>
> >> The first two patches avoid stack-protector messing with the HYP code,
> >> as this ends up being a complete disaster.
> >>
> >> The following two patches fix a bug introduced in the new vgic, where
> >> we may queue HW interrupts with the Pending+Active state, which is
> >> illegal.
> >>
> >> The final patch fixes a misinterpretation of the spec, where we
> >> compute the number of APxRn register based on the number of priorities
> >> instead of using the number of preemption levels.
> >>
> >> I've tagged the first 4 patches for stable, given that we're doing
> >> something potentially harmful. The last patch is more of a theoretical
> >> issue at this stage, so probably need for a backport.
> > 
> > Would you like me to apply them, or are you looking for reviews and
> > going to send them in a pull request?
> > 
> > I can wait a couple days before sending my own pull request to Linus.
> 
> Christoffer is in charge of the tree at the moment, so I'll leave it up
> to him to decide. But my guess is that he will send a PR some time
> later, with the rest of the fixes that have been posted lately.
> 

Yes, I have some other fixes that I'll send together with these as soon
as -rc1 hits.  And I plan on reviewing these.

Thanks,
-Christoffer
