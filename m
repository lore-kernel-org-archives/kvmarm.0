From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 2/2] arm/arm64: KVM: Improve kvm_exit tracepoint
Date: Thu, 3 Sep 2015 19:14:08 +0200
Message-ID: <20150903171408.GG5171@cbox>
References: <1440942922-23955-1-git-send-email-christoffer.dall@linaro.org>
 <1440942922-23955-3-git-send-email-christoffer.dall@linaro.org>
 <55E8757E.5020803@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <55E8757E.5020803@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Sep 03, 2015 at 05:29:50PM +0100, Andre Przywara wrote:
> Hi Christoffer,
> 
> On 30/08/15 14:55, Christoffer Dall wrote:
> > The ARM architecture only saves the exit class to the HSR (ESR_EL2 for
> > arm64) on synchronous exceptions, not on asynchronous exceptions like an
> > IRQ.  However, we only report the exception class on kvm_exit, which is
> > confusing because an IRQ looks like it exited at some PC with the same
> > reason as the previous exit.  Add a lookup table for the exception index
> > and prepend the kvm_exit tracepoint text with the exception type to
> > clarify this situation.
> > 
> > Also resolve the exception class (EC) to a human-friendly text version
> > so the trace output becomes immediately usable for debugging this code.
> 
> That patch just proved very useful for me, especially since the encoding
> of .EC is different between ARM & ARM64, so thanks for that!
> 
> But still there is HSR.EC reported for asynchronous exceptions, which is
> confusing, so I wonder if it would be worth to have two tracepoints to
> just report the PC for async exits and .EC and PC for traps?
> I guess it would be neater to have this differentiation in the
> TRACE_EVENT macro invocation, but I reckon it is not powerful enough?

I'd really like to have a single kvm_exit macro, because userspace
scripts etc. count this event.

I thought about doing something more meaningful, but couldn't think of a
better way, and in any case, this needs to be fixed first and we can
always add something on top.

Patches are welcome :)

> 
> Also this patch is independent from both the first one and the reworked
> arch timer series. I see your intention of pushing your arch timer
> series through ;-), but I suggest to make this patch separate and add
> 1/2 to the arch timer series.
> 
I anticipate this will not go in before the next merge window opens, and
surely the timer patch series in which ever form it ends up being in,
should go in before that, given that it fixes real issues, so hence the
way I sent out these patches.  No hidden agendas - for once ;)

-Christoffer
