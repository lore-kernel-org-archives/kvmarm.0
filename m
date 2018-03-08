From: Christoffer Dall <cdall@kernel.org>
Subject: Re: [RFC PATCH] KVM: arm/arm64: vgic: change condition for level
 interrupt resampling
Date: Thu, 8 Mar 2018 08:10:21 -0800
Message-ID: <20180308161021.GB1917@lvm>
References: <1520492490-7943-1-git-send-email-shunyong.yang@hxt-semitech.com>
 <9ad47673-068e-f732-d2ca-9c76a8fbdfbc@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <9ad47673-068e-f732-d2ca-9c76a8fbdfbc@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Shunyong Yang <shunyong.yang@hxt-semitech.com>, ard.biesheuvel@linaro.org, will.deacon@arm.com, eric.auger@redhat.com, david.daney@cavium.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, Joey Zheng <yu.zheng@hxt-semitech.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Mar 08, 2018 at 09:49:43AM +0000, Marc Zyngier wrote:
> [updated Christoffer's email address]
> 
> Hi Shunyong,
> 
> On 08/03/18 07:01, Shunyong Yang wrote:
> > When resampling irqfds is enabled, level interrupt should be
> > de-asserted when resampling happens. On page 4-47 of GIC v3
> > specification IHI0069D, it said,
> > "When the PE acknowledges an SGI, a PPI, or an SPI at the CPU
> > interface, the IRI changes the status of the interrupt to active
> > and pending if:
> > • It is an edge-triggered interrupt, and another edge has been
> > detected since the interrupt was acknowledged.
> > • It is a level-sensitive interrupt, and the level has not been
> > deasserted since the interrupt was acknowledged."
> > 
> > GIC v2 specification IHI0048B.b has similar description on page
> > 3-42 for state machine transition.
> > 
> > When some VFIO device, like mtty(8250 VFIO mdev emulation driver
> > in samples/vfio-mdev) triggers a level interrupt, the status
> > transition in LR is pending-->active-->active and pending.
> > Then it will wait resampling to de-assert the interrupt.
> > 
> > Current design of lr_signals_eoi_mi() will return false if state
> > in LR is not invalid(Inactive). It causes resampling will not happen
> > in mtty case.
> 
> Let me rephrase this, and tell me if I understood it correctly:
> 
> - A level interrupt is injected, activated by the guest (LR state=active)
> - guest exits, re-enters, (LR state=pending+active)
> - guest EOIs the interrupt (LR state=pending)
> - maintenance interrupt
> - we don't signal the resampling because we're not in an invalid state
> 
> Is that correct?
> 
> That's an interesting case, because it seems to invalidate some of the 
> optimization that went in over a year ago.
> 
> 096f31c4360f KVM: arm/arm64: vgic: Get rid of MISR and EISR fields
> b6095b084d87 KVM: arm/arm64: vgic: Get rid of unnecessary save_maint_int_state
> af0614991ab6 KVM: arm/arm64: vgic: Get rid of unnecessary process_maintenance operation
> 
> We could compare the value of the LR before the guest entry with
> the value at exit time, but we still could miss it if we have a
> transition such as P+A -> P -> A and assume a long enough propagation
> delay for the maintenance interrupt (which is very likely).
> 
> In essence, we have lost the benefit of EISR, which was to give us a
> way to deal with asynchronous signalling.
> 

I don't understand why EISR gives us anything beyond looking at the LR
and evaluating if the state is 00.  My reading of the spec is that the
EISR is merely a shortcut to knowing the state of the LRs but contains
not record or information beyond what you can read from the LRs.

What am I missing?

Thanks,
-Christoffer
