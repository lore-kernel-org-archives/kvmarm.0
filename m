From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 0/2] arm/arm64: KVM: Fix arthictected timer issues
Date: Fri, 4 Sep 2015 17:53:14 +0200
Message-ID: <20150904155314.GA20138@cbox>
References: <1441376679-8341-1-git-send-email-christoffer.dall@linaro.org>
 <55E9BA38.7030305@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <55E9BA38.7030305@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Sep 04, 2015 at 04:35:20PM +0100, Marc Zyngier wrote:
> Hi Christoffer,
> 
> On 04/09/15 15:24, Christoffer Dall wrote:
> > These two patches fix two separate issues with the architected timer and
> > the corresponding interrupt injection to VMs on KVM/ARM.
> > 
> > The first patch fixes an issue introduced with the active timer state
> > switching series recently merged for v4.3, which could cause a guest to
> > loop without progress if another VCPU is run on the same physical CPU
> > and preempts the original VCPU while the guest is running the ISR for
> > the timer interrupt.
> > 
> > The second patch resets the architected timer's control register to zero
> > on system reset, ensuring that interrupts are not injected when a system
> > resets.  This fixes a long-standing issue with UEFI, where soft reset
> > initiated from within UEFI prevented the system from booting again.
> 
> Thanks for respinning these patches. I've queued them in our -next
> queue. I'll send this to Paolo some time next week, once they get some
> hammering.
> 
Awesome, fyi I left these patches running in a loop with reboots and
running hackbench on 2 simultaneous VMs with 4 vcpus each on X-gene for
100 iterations, and left the guest and host run cyclictest for ~20
minutes without issues.

-Christoffer
