From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH 1/9] KVM: Add kvm_arch_vcpu_{un}blocking callbacks
Date: Fri, 4 Sep 2015 15:50:08 +0200
Message-ID: <55E9A190.10602@linaro.org>
References: <1440942866-23802-1-git-send-email-christoffer.dall@linaro.org>
 <1440942866-23802-2-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1440942866-23802-2-git-send-email-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,
On 08/30/2015 03:54 PM, Christoffer Dall wrote:
> Some times it is useful for architecture implementations of KVM to know
> when the VCPU thread is about to block or when it comes back from
> blocking (arm/arm64 needs to know this to properly implement timers, for
> example).
what about vcpu_sleep()? Is that callback specific to kvm_vcpu_block
function entry/exit points or is it more generic? The question also
applies to future halt/resume functions

Thanks

Eric
> 
> Therefore provide a generic architecture callback function in line with
> what we do elsewhere for KVM generic-arch interactions.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
>  arch/arm/include/asm/kvm_host.h     | 3 +++
>  arch/arm64/include/asm/kvm_host.h   | 3 +++
>  arch/mips/include/asm/kvm_host.h    | 2 ++
>  arch/powerpc/include/asm/kvm_host.h | 2 ++
>  arch/s390/include/asm/kvm_host.h    | 2 ++
>  arch/x86/include/asm/kvm_host.h     | 3 +++
>  include/linux/kvm_host.h            | 2 ++
>  virt/kvm/kvm_main.c                 | 3 +++
>  8 files changed, 20 insertions(+)
> 
> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> index dcba0fa..86fcf6e 100644
> --- a/arch/arm/include/asm/kvm_host.h
> +++ b/arch/arm/include/asm/kvm_host.h
> @@ -236,4 +236,7 @@ static inline void kvm_arm_setup_debug(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_arm_clear_debug(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu) {}
>  
> +static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
> +static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
> +
>  #endif /* __ARM_KVM_HOST_H__ */
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 415938d..dd143f5 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -257,4 +257,7 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu);
>  void kvm_arm_clear_debug(struct kvm_vcpu *vcpu);
>  void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu);
>  
> +static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
> +static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
> +
>  #endif /* __ARM64_KVM_HOST_H__ */
> diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
> index e8c8d9d..58f0f4d 100644
> --- a/arch/mips/include/asm/kvm_host.h
> +++ b/arch/mips/include/asm/kvm_host.h
> @@ -845,5 +845,7 @@ static inline void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
>  		struct kvm_memory_slot *slot) {}
>  static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
> +static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
> +static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
>  
>  #endif /* __MIPS_KVM_HOST_H__ */
> diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
> index d91f65b..179f9a7 100644
> --- a/arch/powerpc/include/asm/kvm_host.h
> +++ b/arch/powerpc/include/asm/kvm_host.h
> @@ -702,5 +702,7 @@ static inline void kvm_arch_memslots_updated(struct kvm *kvm, struct kvm_memslot
>  static inline void kvm_arch_flush_shadow_all(struct kvm *kvm) {}
>  static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
>  static inline void kvm_arch_exit(void) {}
> +static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
> +static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
>  
>  #endif /* __POWERPC_KVM_HOST_H__ */
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index 3024acb..04a97df 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -640,5 +640,7 @@ static inline void kvm_arch_memslots_updated(struct kvm *kvm, struct kvm_memslot
>  static inline void kvm_arch_flush_shadow_all(struct kvm *kvm) {}
>  static inline void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
>  		struct kvm_memory_slot *slot) {}
> +static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
> +static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
>  
>  #endif
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 2a7f5d7..26c4086 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1202,4 +1202,7 @@ int __x86_set_memory_region(struct kvm *kvm,
>  int x86_set_memory_region(struct kvm *kvm,
>  			  const struct kvm_userspace_memory_region *mem);
>  
> +static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
> +static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
> +
>  #endif /* _ASM_X86_KVM_HOST_H */
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 9564fd7..87d7be6 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -619,6 +619,8 @@ int kvm_vcpu_write_guest(struct kvm_vcpu *vcpu, gpa_t gpa, const void *data,
>  void kvm_vcpu_mark_page_dirty(struct kvm_vcpu *vcpu, gfn_t gfn);
>  
>  void kvm_vcpu_block(struct kvm_vcpu *vcpu);
> +void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu);
> +void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu);
>  void kvm_vcpu_kick(struct kvm_vcpu *vcpu);
>  int kvm_vcpu_yield_to(struct kvm_vcpu *target);
>  void kvm_vcpu_on_spin(struct kvm_vcpu *vcpu);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 8b8a444..04b59dd 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1946,6 +1946,8 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
>  		} while (single_task_running() && ktime_before(cur, stop));
>  	}
>  
> +	kvm_arch_vcpu_blocking(vcpu);
> +
>  	for (;;) {
>  		prepare_to_wait(&vcpu->wq, &wait, TASK_INTERRUPTIBLE);
>  
> @@ -1959,6 +1961,7 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
>  	finish_wait(&vcpu->wq, &wait);
>  	cur = ktime_get();
>  
> +	kvm_arch_vcpu_unblocking(vcpu);
>  out:
>  	trace_kvm_vcpu_wakeup(ktime_to_ns(cur) - ktime_to_ns(start), waited);
>  }
> 

