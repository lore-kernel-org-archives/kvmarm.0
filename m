From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] KVM: arm/arm64: avoid using kvm_run for in-kernel
 emulation
Date: Thu, 9 Apr 2015 15:30:42 +0200
Message-ID: <20150409133042.GM4715@cbox>
References: <1427507300-19200-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1427507300-19200-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Sat, Mar 28, 2015 at 01:48:20AM +0000, Andre Przywara wrote:
> Our in-kernel VGIC emulation still uses struct kvm_run briefly before
> writing back the emulation result into the guest register. Using a
> userspace mapped data structure within the kernel sounds dodgy, also
> we do some extra copying at the moment at the end of the VGIC
> emulation code.
> Replace the usage of struct kvm_run in favour of passing separate
> parameters into kvm_handle_mmio_return (and rename the function on
> the way) to optimise the VGIC emulation. The real userland MMIO code
> path does not change much.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
> Hi,
> 
> this is an optimization of the VGIC code totally removing struct
> kvm_run from the VGIC emulation. In my eyes it provides a nice
> cleanup and is a logical consequence of the kvm_io_bus patches (on
> which it goes on top). On the other hand it is optional and I didn't
> want to merge it with the already quite large last patch 11.
> Marc, I leave it up to you whether you take this as part of the
> kvm_io_bus series or not.
> 
> Cheers,
> Andre.
> 
>  arch/arm/include/asm/kvm_mmio.h   |    3 +-
>  arch/arm/kvm/arm.c                |    6 ++--
>  arch/arm/kvm/mmio.c               |   55 ++++++++++++++++++-------------------
>  arch/arm64/include/asm/kvm_mmio.h |    3 +-
>  virt/kvm/arm/vgic.c               |    8 ++----
>  5 files changed, 37 insertions(+), 38 deletions(-)
> 
> diff --git a/arch/arm/include/asm/kvm_mmio.h b/arch/arm/include/asm/kvm_mmio.h
> index d8e90c8..53461a6 100644
> --- a/arch/arm/include/asm/kvm_mmio.h
> +++ b/arch/arm/include/asm/kvm_mmio.h
> @@ -28,7 +28,8 @@ struct kvm_decode {
>  	bool sign_extend;
>  };
>  
> -int kvm_handle_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run);
> +int kvm_writeback_mmio_data(struct kvm_vcpu *vcpu, unsigned int len,
> +			    void *val, gpa_t phys_addr);
>  int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
>  		 phys_addr_t fault_ipa);
>  
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index e98370c..b837aef 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -506,8 +506,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  	if (ret)
>  		return ret;
>  
> -	if (run->exit_reason == KVM_EXIT_MMIO) {
> -		ret = kvm_handle_mmio_return(vcpu, vcpu->run);
> +	if (run->exit_reason == KVM_EXIT_MMIO && !run->mmio.is_write) {
> +		ret = kvm_writeback_mmio_data(vcpu, run->mmio.len,
> +					      run->mmio.data,
> +					      run->mmio.phys_addr);
>  		if (ret)
>  			return ret;
>  	}
> diff --git a/arch/arm/kvm/mmio.c b/arch/arm/kvm/mmio.c
> index 974b1c6..3c57f96 100644
> --- a/arch/arm/kvm/mmio.c
> +++ b/arch/arm/kvm/mmio.c
> @@ -86,38 +86,36 @@ static unsigned long mmio_read_buf(char *buf, unsigned int len)
>  }
>  
>  /**
> - * kvm_handle_mmio_return -- Handle MMIO loads after user space emulation
> - * @vcpu: The VCPU pointer
> - * @run:  The VCPU run struct containing the mmio data
> + * kvm_writeback_mmio_data -- Handle MMIO loads after user space emulation
> + * @vcpu:	The VCPU pointer
> + * @len:	The length in Bytes of the MMIO access
> + * @data_ptr:	Pointer to the data to be written back into the guest
> + * @phys_addr:	Physical address of the originating MMIO access
>   *
>   * This should only be called after returning from userspace for MMIO load
> - * emulation.
> + * emulation. phys_addr is only used for the tracepoint output.
>   */
> -int kvm_handle_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run)
> +int kvm_writeback_mmio_data(struct kvm_vcpu *vcpu, unsigned int len,
> +			    void *data_ptr, gpa_t phys_addr)
>  {
>  	unsigned long data;
> -	unsigned int len;
>  	int mask;
>  
> -	if (!run->mmio.is_write) {
> -		len = run->mmio.len;
> -		if (len > sizeof(unsigned long))
> -			return -EINVAL;
> +	if (len > sizeof(unsigned long))
> +		return -EINVAL;
>  
> -		data = mmio_read_buf(run->mmio.data, len);
> +	data = mmio_read_buf(data_ptr, len);
>  
> -		if (vcpu->arch.mmio_decode.sign_extend &&
> -		    len < sizeof(unsigned long)) {
> -			mask = 1U << ((len * 8) - 1);
> -			data = (data ^ mask) - mask;
> -		}
> -
> -		trace_kvm_mmio(KVM_TRACE_MMIO_READ, len, run->mmio.phys_addr,
> -			       data);
> -		data = vcpu_data_host_to_guest(vcpu, data, len);
> -		*vcpu_reg(vcpu, vcpu->arch.mmio_decode.rt) = data;
> +	if (vcpu->arch.mmio_decode.sign_extend &&
> +	    len < sizeof(unsigned long)) {
> +		mask = 1U << ((len * 8) - 1);
> +		data = (data ^ mask) - mask;
>  	}
>  
> +	trace_kvm_mmio(KVM_TRACE_MMIO_READ, len, phys_addr, data);
> +	data = vcpu_data_host_to_guest(vcpu, data, len);
> +	*vcpu_reg(vcpu, vcpu->arch.mmio_decode.rt) = data;
> +
>  	return 0;
>  }
>  
> @@ -201,18 +199,19 @@ int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
>  				      data_buf);
>  	}
>  
> -	/* Now prepare kvm_run for the potential return to userland. */
> -	run->mmio.is_write	= is_write;
> -	run->mmio.phys_addr	= fault_ipa;
> -	run->mmio.len		= len;
> -	memcpy(run->mmio.data, data_buf, len);
> -
>  	if (!ret) {
>  		/* We handled the access successfully in the kernel. */
> -		kvm_handle_mmio_return(vcpu, run);
> +		if (!is_write)
> +			kvm_writeback_mmio_data(vcpu, len, data_buf, fault_ipa);
>  		return 1;
>  	}
>  
> +	/* Now prepare the kvm_run structure for the return to userland. */
> +	run->mmio.phys_addr	= fault_ipa;
> +	run->mmio.len		= len;
> +	run->mmio.is_write	= is_write;
> +	memcpy(run->mmio.data, data_buf, len);
>  	run->exit_reason	= KVM_EXIT_MMIO;
> +
>  	return 0;
>  }
> diff --git a/arch/arm64/include/asm/kvm_mmio.h b/arch/arm64/include/asm/kvm_mmio.h
> index 889c908..3b83475 100644
> --- a/arch/arm64/include/asm/kvm_mmio.h
> +++ b/arch/arm64/include/asm/kvm_mmio.h
> @@ -31,7 +31,8 @@ struct kvm_decode {
>  	bool sign_extend;
>  };
>  
> -int kvm_handle_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run);
> +int kvm_writeback_mmio_data(struct kvm_vcpu *vcpu, unsigned int len,
> +			    void *val, gpa_t phys_addr);
>  int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
>  		 phys_addr_t fault_ipa);
>  
> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> index b70174e..4047fc0 100644
> --- a/virt/kvm/arm/vgic.c
> +++ b/virt/kvm/arm/vgic.c
> @@ -803,7 +803,6 @@ static int vgic_handle_mmio_access(struct kvm_vcpu *vcpu,
>  	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
>  	struct vgic_io_device *iodev = container_of(this,
>  						    struct vgic_io_device, dev);
> -	struct kvm_run *run = vcpu->run;
>  	const struct vgic_io_range *range;
>  	struct kvm_exit_mmio mmio;
>  	bool updated_state;
> @@ -832,12 +831,9 @@ static int vgic_handle_mmio_access(struct kvm_vcpu *vcpu,
>  		updated_state = false;
>  	}
>  	spin_unlock(&dist->lock);
> -	run->mmio.is_write	= is_write;
> -	run->mmio.len		= len;
> -	run->mmio.phys_addr	= addr;
> -	memcpy(run->mmio.data, val, len);
>  
> -	kvm_handle_mmio_return(vcpu, run);
> +	if (!is_write)
> +		kvm_writeback_mmio_data(vcpu, len, val, addr);

why do we do a kvm_writeback_mmio_data() call here in addition to
io_mem_abort() ?  Are we not doing this twice?  What am I missing?

>  
>  	if (updated_state)
>  		vgic_kick_vcpus(vcpu->kvm);
> -- 
> 1.7.9.5
> 
