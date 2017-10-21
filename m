From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v4 12/20] genirq: Document vcpu_info usage for
 percpu_devid interrupts
Date: Sat, 21 Oct 2017 16:29:23 +0200
Message-ID: <20171021142923.GA12618@cbox>
References: <20171020114939.12554-1-christoffer.dall@linaro.org>
 <20171020114939.12554-13-christoffer.dall@linaro.org>
 <alpine.DEB.2.20.1710201354590.2908@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1710201354590.2908@nanos>
Sender: kvm-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Oct 20, 2017 at 01:56:16PM +0200, Thomas Gleixner wrote:
> On Fri, 20 Oct 2017, Christoffer Dall wrote:
> 
> Please Cc lkml when changing genirq core code.
> 

ok, will do so in the future.

> > It is currently unclear how to set the VCPU affinity for a percpu_devid
> > interrupt , since the Linux irq_data structure describes the state for
> > multiple interrupts, one for each physical CPU on the system.  Since
> > each such interrupt can be associated with different VCPUs or none at
> > all, associating a single VCPU state with such an interrupt does not
> > capture the necessary semantics.
> > 
> > The implementers of irq_set_affinity are the Intel and AMD IOMMUs, and
> > the ARM GIC irqchip.  The Intel and AMD callers do not appear to use
> > percpu_devid interrupts, and the ARM GIC implementation only checks the
> > pointer against NULL vs. non-NULL.
> > 
> > Therefore, simply update the function documentation to explain the
> > expected use in the context of percpu_devid interrupts, allowing future
> > changes or additions to irqchip implementers to do the right thing.
> > 
> > This allows us to set the VCPU affinity for the virtual timer interrupt
> > in KVM/ARM, which is a percpu_devid (PPI) interrupt.
> 
> I have a hard time to understand how adding the comment allows you to set
> VCPU affinity ....
> 

Obviously everything already works without adding the comment, however
it is not entirely clear how to use the vcpu_into for percpu_devid
interrupts, and this patch aims to make that clear, as it is the first
user of irq_set_vcpu_affinity for a percpu_devid interrupt which
actually uses the vcpu_info pointer.

Would you rather that we did not update the documentation or what do you
suggest?

Thanks,
-Christoffer
