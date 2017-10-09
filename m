From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 13/20] KVM: arm/arm64: Set VCPU affinity for virt timer
 irq
Date: Mon, 9 Oct 2017 18:52:16 +0100
Message-ID: <916c971f-861e-092e-3b3a-325eb558e599@arm.com>
References: <20170923004207.22356-1-cdall@linaro.org>
 <20170923004207.22356-14-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170923004207.22356-14-cdall@linaro.org>
Content-Language: en-GB
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 23/09/17 01:42, Christoffer Dall wrote:
> As we are about to take physical interrupts for the virtual timer on the
> host but want to leave those active while running the VM (and let the VM
> deactivate them), we need to set the vtimer PPI affinity accordingly.
> 
> Signed-off-by: Christoffer Dall <cdall@linaro.org>
> ---
>  virt/kvm/arm/arch_timer.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index 4254f88..4275f8f 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -650,11 +650,20 @@ int kvm_timer_hyp_init(void)
>  		return err;
>  	}
>  
> +	err = irq_set_vcpu_affinity(host_vtimer_irq, kvm_get_running_vcpus());
> +	if (err) {
> +		kvm_err("kvm_arch_timer: error setting vcpu affinity\n");
> +		goto out_free_irq;
> +	}
> +
>  	kvm_info("virtual timer IRQ%d\n", host_vtimer_irq);
>  
>  	cpuhp_setup_state(CPUHP_AP_KVM_ARM_TIMER_STARTING,
>  			  "kvm/arm/timer:starting", kvm_timer_starting_cpu,
>  			  kvm_timer_dying_cpu);
> +	return 0;
> +out_free_irq:
> +	free_percpu_irq(host_vtimer_irq, kvm_get_running_vcpus());
>  	return err;
>  }
>  
> 

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
