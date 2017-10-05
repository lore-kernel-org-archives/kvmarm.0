From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 1/5] KVM: arm/arm64: tidy 'should sleep' conditions
Date: Thu, 5 Oct 2017 09:13:02 +0100
Message-ID: <71ec93c5-8feb-3862-7f17-2ccc16fe04d0@arm.com>
References: <20170929113041.24371-1-drjones@redhat.com>
 <20170929113041.24371-2-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D6C7341185
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Oct 2017 04:12:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OLWyFHKXFS-t for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 Oct 2017 04:12:39 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BC27340E91
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Oct 2017 04:12:39 -0400 (EDT)
In-Reply-To: <20170929113041.24371-2-drjones@redhat.com>
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
To: Andrew Jones <drjones@redhat.com>, kvmarm@lists.cs.columbia.edu
Cc: cdall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On 29/09/17 12:30, Andrew Jones wrote:
> Introduce vcpu_should_sleep() in order to tidy several places up
> that the compound 'power_off || pause' condition is used.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  virt/kvm/arm/arm.c | 18 +++++++++++-------
>  1 file changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index b9f68e4add71..e4bec508ee5b 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -403,17 +403,22 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
>  	return 0;
>  }
>  
> +static bool vcpu_should_sleep(struct kvm_vcpu *vcpu)
> +{
> +	return vcpu->arch.power_off || vcpu->arch.pause;
> +}
> +
>  /**
>   * kvm_arch_vcpu_runnable - determine if the vcpu can be scheduled
> - * @v:		The VCPU pointer
> + * @vcpu:	The VCPU pointer
>   *
>   * If the guest CPU is not waiting for interrupts or an interrupt line is
>   * asserted, the CPU is by definition runnable.
>   */
> -int kvm_arch_vcpu_runnable(struct kvm_vcpu *v)
> +int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
>  {
> -	return ((!!v->arch.irq_lines || kvm_vgic_vcpu_pending_irq(v))
> -		&& !v->arch.power_off && !v->arch.pause);
> +	return (!!vcpu->arch.irq_lines || kvm_vgic_vcpu_pending_irq(vcpu))
> +		&& !vcpu_should_sleep(vcpu);
>  }
>  
>  bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
> @@ -570,10 +575,9 @@ static void vcpu_req_sleep(struct kvm_vcpu *vcpu)
>  {
>  	struct swait_queue_head *wq = kvm_arch_vcpu_wq(vcpu);
>  
> -	swait_event_interruptible(*wq, ((!vcpu->arch.power_off) &&
> -				       (!vcpu->arch.pause)));
> +	swait_event_interruptible(*wq, !vcpu_should_sleep(vcpu));
>  
> -	if (vcpu->arch.power_off || vcpu->arch.pause) {
> +	if (vcpu_should_sleep(vcpu)) {
>  		/* Awaken to handle a signal, request we sleep again later. */
>  		kvm_make_request(KVM_REQ_SLEEP, vcpu);
>  	}
> 

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
