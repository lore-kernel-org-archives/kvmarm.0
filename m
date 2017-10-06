From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v1 2/2] kvm: arm64: handle single-step of userspace mmio
 instructions
Date: Fri, 6 Oct 2017 13:37:53 +0100
Message-ID: <ca10e4b9-08cc-486c-a229-da5ebcdb76cf@arm.com>
References: <20171006113921.24880-1-alex.bennee@linaro.org>
 <20171006113921.24880-3-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171006113921.24880-3-alex.bennee@linaro.org>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>, julien.thierry@arm.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
Cc: Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, open list <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 06/10/17 12:39, Alex Bennée wrote:
> The system state of KVM when using userspace emulation is not complete
> until we return into KVM_RUN. To handle mmio related updates we wait
> until they have been committed and then schedule our KVM_EXIT_DEBUG.
> 
> I've introduced a new function kvm_arm_maybe_return_debug() to wrap up
> the differences between arm/arm64 which is currently null for arm.
> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> ---
>  arch/arm/include/asm/kvm_host.h   |  2 ++
>  arch/arm64/include/asm/kvm_host.h |  1 +
>  arch/arm64/kvm/debug.c            | 21 +++++++++++++++++++++
>  arch/arm64/kvm/handle_exit.c      |  9 +++------
>  virt/kvm/arm/arm.c                |  2 +-
>  virt/kvm/arm/mmio.c               |  3 ++-
>  6 files changed, 30 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> index 4a879f6ff13b..aec943f6d123 100644
> --- a/arch/arm/include/asm/kvm_host.h
> +++ b/arch/arm/include/asm/kvm_host.h
> @@ -285,6 +285,8 @@ static inline void kvm_arm_init_debug(void) {}
>  static inline void kvm_arm_setup_debug(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_arm_clear_debug(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu) {}
> +static inline int  kvm_arm_maybe_return_debug(struct kvm_vcpu *vcpu,
> +						struct kvm_run *run) {}
>  
>  int kvm_arm_vcpu_arch_set_attr(struct kvm_vcpu *vcpu,
>  			       struct kvm_device_attr *attr);
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index e923b58606e2..fa67d21662f6 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -369,6 +369,7 @@ void kvm_arm_init_debug(void);
>  void kvm_arm_setup_debug(struct kvm_vcpu *vcpu);
>  void kvm_arm_clear_debug(struct kvm_vcpu *vcpu);
>  void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu);
> +int  kvm_arm_maybe_return_debug(struct kvm_vcpu *vcpu, struct kvm_run *run);
>  int kvm_arm_vcpu_arch_set_attr(struct kvm_vcpu *vcpu,
>  			       struct kvm_device_attr *attr);
>  int kvm_arm_vcpu_arch_get_attr(struct kvm_vcpu *vcpu,
> diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
> index dbadfaf850a7..a10a18c55c87 100644
> --- a/arch/arm64/kvm/debug.c
> +++ b/arch/arm64/kvm/debug.c
> @@ -221,3 +221,24 @@ void kvm_arm_clear_debug(struct kvm_vcpu *vcpu)
>  		}
>  	}
>  }
> +
> +
> +/*
> + * When KVM has successfully emulated the instruction we might want to
> + * return we a KVM_EXIT_DEBUG. We can only do this once the emulation
> + * is complete though so for userspace emulations we have to wait
> + * until we have re-entered KVM.
> + *
> + * Return > 0 to return to guest, 0 (and set exit_reason) on proper
> + * exit to userspace.
> + */
> +
> +int kvm_arm_maybe_return_debug(struct kvm_vcpu *vcpu, struct kvm_run *run)
> +{
> +	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP) {
> +		run->exit_reason = KVM_EXIT_DEBUG;
> +		run->debug.arch.hsr = ESR_ELx_EC_SOFTSTP_LOW << ESR_ELx_EC_SHIFT;
> +		return 0;
> +	}
> +	return 1;
> +}
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index c918d291cb58..7b04f59217bf 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -202,13 +202,10 @@ static int handle_trap_exceptions(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  		handled = exit_handler(vcpu, run);
>  	}
>  
> -	if (handled && (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)) {
> -		handled = 0;
> -		run->exit_reason = KVM_EXIT_DEBUG;
> -		run->debug.arch.hsr = ESR_ELx_EC_SOFTSTP_LOW << ESR_ELx_EC_SHIFT;
> -	}
> +	if (handled)
> +		return kvm_arm_maybe_return_debug(vcpu, run);
>  
> -	return handled;
> +	return 0;
>  }
>  
>  /*
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index b9f68e4add71..3d28fe2daa26 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -623,7 +623,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  
>  	if (run->exit_reason == KVM_EXIT_MMIO) {
>  		ret = kvm_handle_mmio_return(vcpu, vcpu->run);
> -		if (ret)
> +		if (ret < 1)
>  			return ret;
>  	}
>  
> diff --git a/virt/kvm/arm/mmio.c b/virt/kvm/arm/mmio.c
> index b6e715fd3c90..e43e3bd6222f 100644
> --- a/virt/kvm/arm/mmio.c
> +++ b/virt/kvm/arm/mmio.c
> @@ -117,7 +117,8 @@ int kvm_handle_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  		vcpu_set_reg(vcpu, vcpu->arch.mmio_decode.rt, data);
>  	}
>  
> -	return 0;
> +	/* If debugging in effect we may need to return now */
> +	return kvm_arm_maybe_return_debug(vcpu, run);

Ah, that's how you do it. OK. Then the patch splitting is wrong, because
everything is broken after patch #1.

I'd prefer something like "kvm_handle_single_step" instead of this
"kvm_arm_maybe_return_debug", but I'm very bad at naming things anyway.

>  }
>  
>  static int decode_hsr(struct kvm_vcpu *vcpu, bool *is_write, int *len)
> 

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
