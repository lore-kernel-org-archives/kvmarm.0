From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 12/20] genirq: Document vcpu_info usage for
 percpu_devid interrupts
Date: Mon, 9 Oct 2017 18:48:33 +0100
Message-ID: <1a21ed0e-39eb-a5a3-5cda-3a51d9f9c8da@arm.com>
References: <20170923004207.22356-1-cdall@linaro.org>
 <20170923004207.22356-13-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170923004207.22356-13-cdall@linaro.org>
Content-Language: en-GB
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Thomas Gleixner <tglx@linutronix.de>
List-Id: kvmarm@lists.cs.columbia.edu

On 23/09/17 01:41, Christoffer Dall wrote:
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
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Christoffer Dall <cdall@linaro.org>
> ---
>  kernel/irq/manage.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> index 573dc52..2b2c94f 100644
> --- a/kernel/irq/manage.c
> +++ b/kernel/irq/manage.c
> @@ -381,7 +381,8 @@ int irq_select_affinity_usr(unsigned int irq)
>  /**
>   *	irq_set_vcpu_affinity - Set vcpu affinity for the interrupt
>   *	@irq: interrupt number to set affinity
> - *	@vcpu_info: vCPU specific data
> + *	@vcpu_info: vCPU specific data or pointer to a percpu array of vCPU
> + *	            specific data for percpu_devid interrupts
>   *
>   *	This function uses the vCPU specific data to set the vCPU
>   *	affinity for an irq. The vCPU specific data is passed from
> 

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
