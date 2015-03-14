From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 11/12] KVM: ARM: on IO mem abort - route the call to KVM
 MMIO bus
Date: Sat, 14 Mar 2015 15:43:21 +0100
Message-ID: <20150314144321.GG10935@cbox>
References: <1426263012-22935-1-git-send-email-andre.przywara@arm.com>
 <1426263012-22935-12-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 562D348D87
 for <kvmarm@lists.cs.columbia.edu>; Sat, 14 Mar 2015 10:36:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WAMVYe80wDPR for <kvmarm@lists.cs.columbia.edu>;
 Sat, 14 Mar 2015 10:36:32 -0400 (EDT)
Received: from mail-la0-f45.google.com (mail-la0-f45.google.com
 [209.85.215.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E74EA48D82
 for <kvmarm@lists.cs.columbia.edu>; Sat, 14 Mar 2015 10:36:31 -0400 (EDT)
Received: by lagg8 with SMTP id g8so9852525lag.1
 for <kvmarm@lists.cs.columbia.edu>; Sat, 14 Mar 2015 07:42:59 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1426263012-22935-12-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Mar 13, 2015 at 04:10:11PM +0000, Andre Przywara wrote:
> From: Nikolay Nikolaev <n.nikolaev@virtualopensystems.com>
> 
> On IO memory abort, try to handle the MMIO access through the KVM
> registered read/write callbacks. This is done by invoking the relevant
> kvm_io_bus_* API.
> 
> [Andre: Since we converted the VGIC already, we can get rid of the
> VGIC specific MMIO handler alltogether.]
> 
> Signed-off-by: Nikolay Nikolaev <n.nikolaev@virtualopensystems.com>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  arch/arm/kvm/mmio.c    |   32 +++++++++++++++++++++++++++++++-
>  include/kvm/arm_vgic.h |    2 --
>  2 files changed, 31 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/kvm/mmio.c b/arch/arm/kvm/mmio.c
> index 5d3bfc0..8dc2fde 100644
> --- a/arch/arm/kvm/mmio.c
> +++ b/arch/arm/kvm/mmio.c
> @@ -162,6 +162,36 @@ static int decode_hsr(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	return 0;
>  }
>  
> +/**
> + * handle_kernel_mmio - handle an in-kernel MMIO access
> + * @vcpu:	pointer to the vcpu performing the access
> + * @run:	pointer to the kvm_run structure
> + * @mmio:	pointer to the data describing the access
> + *
> + * returns true if the MMIO access has been performed in kernel space,
> + * and false if it needs to be emulated in user space.
> + */
> +static bool handle_kernel_mmio(struct kvm_vcpu *vcpu, struct kvm_run *run,
> +		struct kvm_exit_mmio *mmio)
> +{
> +	int ret;
> +
> +	if (mmio->is_write) {
> +		ret = kvm_io_bus_write(vcpu, KVM_MMIO_BUS, mmio->phys_addr,
> +				mmio->len, &mmio->data);
> +
> +	} else {
> +		ret = kvm_io_bus_read(vcpu, KVM_MMIO_BUS, mmio->phys_addr,
> +				mmio->len, &mmio->data);
> +	}
> +	if (!ret) {
> +		kvm_prepare_mmio(run, mmio);
> +		kvm_handle_mmio_return(vcpu, run);

here I think you can optimize the copying, see my comment on the earlier
patch.

let's be nice to readers here and

return true

> +	}
> +
> +	return !ret;

and replace this with

return false

> +}
> +
>  int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
>  		 phys_addr_t fault_ipa)
>  {
> @@ -200,7 +230,7 @@ int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
>  			       fault_ipa, 0);
>  	}
>  
> -	if (vgic_handle_mmio(vcpu, run, &mmio))
> +	if (handle_kernel_mmio(vcpu, run, &mmio))
>  		return 1;
>  
>  	kvm_prepare_mmio(run, &mmio);
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index 09fd324..91976c8 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -317,8 +317,6 @@ int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int irq_num,
>  			bool level);
>  void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg);
>  int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu);
> -bool vgic_handle_mmio(struct kvm_vcpu *vcpu, struct kvm_run *run,
> -		      struct kvm_exit_mmio *mmio);
>  
>  #define irqchip_in_kernel(k)	(!!((k)->arch.vgic.in_kernel))
>  #define vgic_initialized(k)	(!!((k)->arch.vgic.nr_cpus))
> -- 
> 1.7.9.5
> 

Thanks,
-Christoffer
