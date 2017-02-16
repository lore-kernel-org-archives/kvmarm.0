From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PATCH] KVM: race-free exit from KVM_RUN without POSIX signals
Date: Thu, 16 Feb 2017 17:19:53 +0100
Message-ID: <20170216161952.GB8156@potion>
References: <1487169821-14806-1-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1487169821-14806-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, james.hogan@imgtec.com, paulus@samba.org, borntraeger@de.ibm.com, cornelia.huck@de.ibm.com, kvmarm@lists.cs.columbia.edu, kvm-ppc@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

2017-02-15 15:43+0100, Paolo Bonzini:
> The purpose of the KVM_SET_SIGNAL_MASK API is to let userspace "kick"
> a VCPU out of KVM_RUN through a POSIX signal.  A signal is attached
> to a dummy signal handler; by blocking the signal outside KVM_RUN and
> unblocking it inside, this possible race is closed:
> 
>           VCPU thread                     service thread
>    --------------------------------------------------------------
>         check flag
>                                           set flag
>                                           raise signal
>         (signal handler does nothing)
>         KVM_RUN
> 
> However, one issue with KVM_SET_SIGNAL_MASK is that it has to take
> tsk->sighand->siglock on every KVM_RUN.  This lock is often on a
> remote NUMA node, because it is on the node of a thread's creator.
> Taking this lock can be very expensive if there are many userspace
> exits (as is the case for SMP Windows VMs without Hyper-V reference
> time counter).
> 
> As an alternative, we can put the flag directly in kvm_run so that
> KVM can see it:
> 
>           VCPU thread                     service thread
>    --------------------------------------------------------------
>                                           raise signal
>         signal handler
>           set run->immediate_exit
>         KVM_RUN
>           check run->immediate_exit
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

The old immediate exit with signal did more work, but none of it should
affect user-space, so it looks like another minor optimization,

Reviewed-by: Radim Krčmář <rkrcmar@redhat.com>

> 	change from RFC:
> 	- implement in each architecture to ensure MMIO is completed
> 	  [Radim]
> 	- do not clear the flag [David Hildenbrand, offlist]
> 
>  Documentation/virtual/kvm/api.txt | 13 ++++++++++++-
>  arch/arm/kvm/arm.c                |  4 ++++
>  arch/mips/kvm/mips.c              |  7 ++++++-
>  arch/powerpc/kvm/powerpc.c        |  6 +++++-
>  arch/s390/kvm/kvm-s390.c          |  4 ++++
>  arch/x86/kvm/x86.c                |  6 +++++-
>  include/uapi/linux/kvm.h          |  4 +++-
>  7 files changed, 39 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> index e4f2cdcf78eb..925b1b6be073 100644
> --- a/Documentation/virtual/kvm/api.txt
> +++ b/Documentation/virtual/kvm/api.txt
> @@ -3389,7 +3389,18 @@ struct kvm_run {
>  Request that KVM_RUN return when it becomes possible to inject external
>  interrupts into the guest.  Useful in conjunction with KVM_INTERRUPT.
>  
> -	__u8 padding1[7];
> +	__u8 immediate_exit;
> +
> +This field is polled once when KVM_RUN starts; if non-zero, KVM_RUN
> +exits immediately, returning -EINTR.  In the common scenario where a
> +signal is used to "kick" a VCPU out of KVM_RUN, this field can be used
> +to avoid usage of KVM_SET_SIGNAL_MASK, which has worse scalability.
> +Rather than blocking the signal outside KVM_RUN, userspace can set up
> +a signal handler that sets run->immediate_exit to a non-zero value.
> +
> +This field is ignored if KVM_CAP_IMMEDIATE_EXIT is not available.
> +
> +	__u8 padding1[6];
>  
>  	/* out */
>  	__u32 exit_reason;
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index 21c493a9e5c9..c9a2103faeb9 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -206,6 +206,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_ARM_PSCI_0_2:
>  	case KVM_CAP_READONLY_MEM:
>  	case KVM_CAP_MP_STATE:
> +	case KVM_CAP_IMMEDIATE_EXIT:
>  		r = 1;
>  		break;
>  	case KVM_CAP_COALESCED_MMIO:
> @@ -604,6 +605,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  			return ret;
>  	}
>  
> +	if (run->immediate_exit)
> +		return -EINTR;
> +
>  	if (vcpu->sigset_active)
>  		sigprocmask(SIG_SETMASK, &vcpu->sigset, &sigsaved);
>  
> diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
> index 31ee5ee0010b..ed81e5ac1426 100644
> --- a/arch/mips/kvm/mips.c
> +++ b/arch/mips/kvm/mips.c
> @@ -397,7 +397,7 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
>  
>  int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  {
> -	int r = 0;
> +	int r = -EINTR;
>  	sigset_t sigsaved;
>  
>  	if (vcpu->sigset_active)
> @@ -409,6 +409,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  		vcpu->mmio_needed = 0;
>  	}
>  
> +	if (run->immediate_exit)
> +		goto out;
> +
>  	lose_fpu(1);
>  
>  	local_irq_disable();
> @@ -429,6 +432,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  	guest_exit_irqoff();
>  	local_irq_enable();
>  
> +out:
>  	if (vcpu->sigset_active)
>  		sigprocmask(SIG_SETMASK, &sigsaved, NULL);
>  
> @@ -1021,6 +1025,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_ENABLE_CAP:
>  	case KVM_CAP_READONLY_MEM:
>  	case KVM_CAP_SYNC_MMU:
> +	case KVM_CAP_IMMEDIATE_EXIT:
>  		r = 1;
>  		break;
>  	case KVM_CAP_COALESCED_MMIO:
> diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
> index 2b3e4e620078..1fe1391ba2c2 100644
> --- a/arch/powerpc/kvm/powerpc.c
> +++ b/arch/powerpc/kvm/powerpc.c
> @@ -511,6 +511,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_ONE_REG:
>  	case KVM_CAP_IOEVENTFD:
>  	case KVM_CAP_DEVICE_CTRL:
> +	case KVM_CAP_IMMEDIATE_EXIT:
>  		r = 1;
>  		break;
>  	case KVM_CAP_PPC_PAIRED_SINGLES:
> @@ -1117,7 +1118,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  #endif
>  	}
>  
> -	r = kvmppc_vcpu_run(run, vcpu);
> +	if (run->immediate_exit)
> +		r = -EINTR;
> +	else
> +		r = kvmppc_vcpu_run(run, vcpu);
>  
>  	if (vcpu->sigset_active)
>  		sigprocmask(SIG_SETMASK, &sigsaved, NULL);
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 502de74ea984..99e35fe0dea8 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -370,6 +370,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_S390_IRQCHIP:
>  	case KVM_CAP_VM_ATTRIBUTES:
>  	case KVM_CAP_MP_STATE:
> +	case KVM_CAP_IMMEDIATE_EXIT:
>  	case KVM_CAP_S390_INJECT_IRQ:
>  	case KVM_CAP_S390_USER_SIGP:
>  	case KVM_CAP_S390_USER_STSI:
> @@ -2798,6 +2799,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
>  	int rc;
>  	sigset_t sigsaved;
>  
> +	if (kvm_run->immediate_exit)
> +		return -EINTR;
> +
>  	if (guestdbg_exit_pending(vcpu)) {
>  		kvm_s390_prepare_debug_exit(vcpu);
>  		return 0;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 63a89a51dcc9..2a0974383ffe 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2672,6 +2672,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_DISABLE_QUIRKS:
>  	case KVM_CAP_SET_BOOT_CPU_ID:
>   	case KVM_CAP_SPLIT_IRQCHIP:
> +	case KVM_CAP_IMMEDIATE_EXIT:
>  #ifdef CONFIG_KVM_DEVICE_ASSIGNMENT
>  	case KVM_CAP_ASSIGN_DEV_IRQ:
>  	case KVM_CAP_PCI_2_3:
> @@ -7202,7 +7203,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
>  	} else
>  		WARN_ON(vcpu->arch.pio.count || vcpu->mmio_needed);
>  
> -	r = vcpu_run(vcpu);
> +	if (kvm_run->immediate_exit)
> +		r = -EINTR;
> +	else
> +		r = vcpu_run(vcpu);
>  
>  out:
>  	post_kvm_run_save(vcpu);
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 7964b970b9ad..f51d5082a377 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -218,7 +218,8 @@ struct kvm_hyperv_exit {
>  struct kvm_run {
>  	/* in */
>  	__u8 request_interrupt_window;
> -	__u8 padding1[7];
> +	__u8 immediate_exit;
> +	__u8 padding1[6];
>  
>  	/* out */
>  	__u32 exit_reason;
> @@ -881,6 +882,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_SPAPR_RESIZE_HPT 133
>  #define KVM_CAP_PPC_MMU_RADIX 134
>  #define KVM_CAP_PPC_MMU_HASH_V3 135
> +#define KVM_CAP_IMMEDIATE_EXIT 136
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  
> -- 
> 1.8.3.1
> 
