From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 11/11] KVM: arm/arm64: rework MMIO abort handling to
 use KVM MMIO bus
Date: Fri, 27 Mar 2015 17:00:46 +0100
Message-ID: <20150327160046.GB5121@cbox>
References: <1427380778-942-1-git-send-email-andre.przywara@arm.com>
 <1427380778-942-12-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1427380778-942-12-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: marc.zyngier@arm.com, pbonzini@redhat.com, Marcelo Tosatti <mtosatti@redhat.com>, kvmarm@lists.cs.columbia.edu, n.nikolaev@virtualopensystems.com, eric.auger@linaro.org, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Mar 26, 2015 at 02:39:38PM +0000, Andre Przywara wrote:
> Currently we have struct kvm_exit_mmio for encapsulating MMIO abort
> data to be passed on from syndrome decoding all the way down to the
> VGIC register handlers. Now as we switch the MMIO handling to be
> routed through the KVM MMIO bus, it does not make sense anymore to
> use that structure already from the beginning. So we put the data into
> kvm_run very early and use that encapsulation till the MMIO bus call.
> Then we fill kvm_exit_mmio in the VGIC only, making it a VGIC private
> structure. On that way we replace the data buffer in that structure
> with a pointer pointing to a single location in kvm_run, so we get
> rid of some copying on the way.
> With all of the virtual GIC emulation code now being registered with
> the kvm_io_bus, we can remove all of the old MMIO handling code and
> its dispatching functionality.
> 
> I didn't bother to rename kvm_exit_mmio (to vgic_mmio or something),
> because that touches a lot of code lines without any good reason.
> 
> This is based on an original patch by Nikolay.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> Cc: Nikolay Nikolaev <n.nikolaev@virtualopensystems.com>
> ---
>  arch/arm/include/asm/kvm_mmio.h   |   22 ---------
>  arch/arm/kvm/mmio.c               |   60 ++++++++++++++++++-------
>  arch/arm64/include/asm/kvm_mmio.h |   22 ---------
>  include/kvm/arm_vgic.h            |    6 ---
>  virt/kvm/arm/vgic-v2-emul.c       |   21 +--------
>  virt/kvm/arm/vgic-v3-emul.c       |   35 ---------------
>  virt/kvm/arm/vgic.c               |   89 ++-----------------------------------
>  virt/kvm/arm/vgic.h               |   13 +++---
>  8 files changed, 57 insertions(+), 211 deletions(-)
> 
> diff --git a/arch/arm/include/asm/kvm_mmio.h b/arch/arm/include/asm/kvm_mmio.h
> index 3f83db2..d8e90c8 100644
> --- a/arch/arm/include/asm/kvm_mmio.h
> +++ b/arch/arm/include/asm/kvm_mmio.h
> @@ -28,28 +28,6 @@ struct kvm_decode {
>  	bool sign_extend;
>  };
>  
> -/*
> - * The in-kernel MMIO emulation code wants to use a copy of run->mmio,
> - * which is an anonymous type. Use our own type instead.
> - */
> -struct kvm_exit_mmio {
> -	phys_addr_t	phys_addr;
> -	u8		data[8];
> -	u32		len;
> -	bool		is_write;
> -	void		*private;
> -};
> -
> -static inline void kvm_prepare_mmio(struct kvm_run *run,
> -				    struct kvm_exit_mmio *mmio)
> -{
> -	run->mmio.phys_addr	= mmio->phys_addr;
> -	run->mmio.len		= mmio->len;
> -	run->mmio.is_write	= mmio->is_write;
> -	memcpy(run->mmio.data, mmio->data, mmio->len);
> -	run->exit_reason	= KVM_EXIT_MMIO;
> -}
> -
>  int kvm_handle_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run);
>  int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
>  		 phys_addr_t fault_ipa);
> diff --git a/arch/arm/kvm/mmio.c b/arch/arm/kvm/mmio.c
> index 5d3bfc0..bb2ab44 100644
> --- a/arch/arm/kvm/mmio.c
> +++ b/arch/arm/kvm/mmio.c
> @@ -122,7 +122,7 @@ int kvm_handle_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  }
>  
>  static int decode_hsr(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> -		      struct kvm_exit_mmio *mmio)
> +		      struct kvm_run *run)
>  {
>  	unsigned long rt;
>  	int len;
> @@ -148,9 +148,9 @@ static int decode_hsr(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	sign_extend = kvm_vcpu_dabt_issext(vcpu);
>  	rt = kvm_vcpu_dabt_get_rd(vcpu);
>  
> -	mmio->is_write = is_write;
> -	mmio->phys_addr = fault_ipa;
> -	mmio->len = len;
> +	run->mmio.is_write = is_write;
> +	run->mmio.phys_addr = fault_ipa;
> +	run->mmio.len = len;
>  	vcpu->arch.mmio_decode.sign_extend = sign_extend;
>  	vcpu->arch.mmio_decode.rt = rt;
>  
> @@ -162,23 +162,49 @@ static int decode_hsr(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	return 0;
>  }
>  
> +/**
> + * handle_kernel_mmio - handle an in-kernel MMIO access
> + * @vcpu:	pointer to the vcpu performing the access
> + * @run:	pointer to the kvm_run structure
> + *
> + * returns true if the MMIO access has been performed in kernel space,
> + * and false if it needs to be emulated in user space.
> + */
> +static bool handle_kernel_mmio(struct kvm_vcpu *vcpu, struct kvm_run *run)
> +{
> +	int ret;
> +
> +	if (run->mmio.is_write) {
> +		ret = kvm_io_bus_write(vcpu, KVM_MMIO_BUS, run->mmio.phys_addr,
> +				       run->mmio.len, run->mmio.data);
> +
> +	} else {
> +		ret = kvm_io_bus_read(vcpu, KVM_MMIO_BUS, run->mmio.phys_addr,
> +				      run->mmio.len, run->mmio.data);
> +	}
> +	if (!ret) {
> +		kvm_handle_mmio_return(vcpu, run);
> +		return true;
> +	}
> +
> +	return false;
> +}
> +
>  int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
>  		 phys_addr_t fault_ipa)
>  {
> -	struct kvm_exit_mmio mmio;
>  	unsigned long data;
>  	unsigned long rt;
>  	int ret;
>  
>  	/*
> -	 * Prepare MMIO operation. First stash it in a private
> -	 * structure that we can use for in-kernel emulation. If the
> -	 * kernel can't handle it, copy it into run->mmio and let user
> -	 * space do its magic.
> +	 * Prepare MMIO operation. First put the MMIO data into run->mmio.
> +	 * Then try if some in-kernel emulation feels responsible, otherwise
> +	 * let user space do its magic.
>  	 */
>  
>  	if (kvm_vcpu_dabt_isvalid(vcpu)) {
> -		ret = decode_hsr(vcpu, fault_ipa, &mmio);
> +		ret = decode_hsr(vcpu, fault_ipa, run);

hmm, this does feel rather obtrusive, because as Marc pointed out the
run structure can be modified from userspace.  So a patch that comes
along later and assumes that run->mmio.len is something sane from the
HSR will break catastrophically.  So I think it'd be better to use a
privat kernel struct for this.


Otherwise, this looks good to me!

Thanks,
-Christoffer
