From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH] KVM: arm/arm64: timer: Don't set irq as forwarded if no
 usable GIC
Date: Thu, 7 Dec 2017 15:57:52 +0000
Message-ID: <be026808-1292-62de-3282-464fc836b12b@arm.com>
References: <20171207114615.23950-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 948A049D6F
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Dec 2017 10:54:36 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nVUXCI74dBCR for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Dec 2017 10:54:35 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 592E849D32
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Dec 2017 10:54:35 -0500 (EST)
In-Reply-To: <20171207114615.23950-1-marc.zyngier@arm.com>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 07/12/17 11:46, Marc Zyngier wrote:
> If we don't have a usable GIC, do not try to set the vcpu affinity
> as this is guaranteed to fail.

Yes, I can confirm that this fixes the problem. With this patch and a DT
advertising only a 4K GICC region size KVM still initializes, but denies
the in-kernel VGIC. kvmtool does not work anymore (expected), but QEMU
helps out with its userland GIC emulation.

> Reported-by: Andre Przywara <andre.przywara@arm.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Tested-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre


> ---
>  include/kvm/arm_arch_timer.h |  2 +-
>  virt/kvm/arm/arch_timer.c    | 13 ++++++++-----
>  virt/kvm/arm/arm.c           |  2 +-
>  3 files changed, 10 insertions(+), 7 deletions(-)
> 
> diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
> index 01ee473517e2..5fa4fef257a4 100644
> --- a/include/kvm/arm_arch_timer.h
> +++ b/include/kvm/arm_arch_timer.h
> @@ -62,7 +62,7 @@ struct arch_timer_cpu {
>  	bool			enabled;
>  };
>  
> -int kvm_timer_hyp_init(void);
> +int kvm_timer_hyp_init(bool);
>  int kvm_timer_enable(struct kvm_vcpu *vcpu);
>  int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu);
>  void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu);
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index 4151250ce8da..4804b5608013 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -726,7 +726,7 @@ static int kvm_timer_dying_cpu(unsigned int cpu)
>  	return 0;
>  }
>  
> -int kvm_timer_hyp_init(void)
> +int kvm_timer_hyp_init(bool has_gic)
>  {
>  	struct arch_timer_kvm_info *info;
>  	int err;
> @@ -762,10 +762,13 @@ int kvm_timer_hyp_init(void)
>  		return err;
>  	}
>  
> -	err = irq_set_vcpu_affinity(host_vtimer_irq, kvm_get_running_vcpus());
> -	if (err) {
> -		kvm_err("kvm_arch_timer: error setting vcpu affinity\n");
> -		goto out_free_irq;
> +	if (has_gic) {
> +		err = irq_set_vcpu_affinity(host_vtimer_irq,
> +					    kvm_get_running_vcpus());
> +		if (err) {
> +			kvm_err("kvm_arch_timer: error setting vcpu affinity\n");
> +			goto out_free_irq;
> +		}
>  	}
>  
>  	kvm_info("virtual timer IRQ%d\n", host_vtimer_irq);
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index a67c106d73f5..d9df6d0731e6 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -1323,7 +1323,7 @@ static int init_subsystems(void)
>  	/*
>  	 * Init HYP architected timer support
>  	 */
> -	err = kvm_timer_hyp_init();
> +	err = kvm_timer_hyp_init(vgic_present);
>  	if (err)
>  		goto out;
>  
> 
