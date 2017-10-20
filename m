From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v4 12/20] genirq: Document vcpu_info usage for percpu_devid
 interrupts
Date: Fri, 20 Oct 2017 13:56:16 +0200 (CEST)
Message-ID: <alpine.DEB.2.20.1710201354590.2908@nanos>
References: <20171020114939.12554-1-christoffer.dall@linaro.org> <20171020114939.12554-13-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171020114939.12554-13-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, 20 Oct 2017, Christoffer Dall wrote:

Please Cc lkml when changing genirq core code.

> It is currently unclear how to set the VCPU affinity for a percpu_devid
> interrupt , since the Linux irq_data structure describes the state for
> multiple interrupts, one for each physical CPU on the system.  Since
> each such interrupt can be associated with different VCPUs or none at
> all, associating a single VCPU state with such an interrupt does not
> capture the necessary semantics.
> 
> The implementers of irq_set_affinity are the Intel and AMD IOMMUs, and
> the ARM GIC irqchip.  The Intel and AMD callers do not appear to use
> percpu_devid interrupts, and the ARM GIC implementation only checks the
> pointer against NULL vs. non-NULL.
> 
> Therefore, simply update the function documentation to explain the
> expected use in the context of percpu_devid interrupts, allowing future
> changes or additions to irqchip implementers to do the right thing.
> 
> This allows us to set the VCPU affinity for the virtual timer interrupt
> in KVM/ARM, which is a percpu_devid (PPI) interrupt.

I have a hard time to understand how adding the comment allows you to set
VCPU affinity ....

Thanks,

	tglx
