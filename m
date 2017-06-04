From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v5 04/11] KVM: arm/arm64: properly use vcpu requests
Date: Sun, 4 Jun 2017 16:51:33 +0200
Message-ID: <20170604145133.GD9464@cbox>
References: <20170604124401.24902-1-drjones@redhat.com>
 <20170604124401.24902-5-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170604124401.24902-5-drjones@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Sun, Jun 04, 2017 at 02:43:54PM +0200, Andrew Jones wrote:
> arm/arm64 already has one VCPU request used when setting pause,
> but it doesn't properly check requests in VCPU RUN. Check it
> and also make sure we set vcpu->mode at the appropriate time
> (before the check) and with the appropriate barriers. See
> Documentation/virtual/kvm/vcpu-requests.rst. Also make sure we
> don't leave any vcpu requests we don't intend to handle later
> set in the request bitmap. If we don't clear them, then
> kvm_request_pending() may return true when it shouldn't.
> 
> Using VCPU requests properly fixes a small race where pause
> could get set just as a VCPU was entering guest mode.

Whoops, i forgot to say that I reviewed this:

Reviewed-by: Christoffer Dall <cdall@linaro.org>

> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  arch/arm/kvm/handle_exit.c   |  1 +
>  arch/arm64/kvm/handle_exit.c |  1 +
>  virt/kvm/arm/arm.c           | 14 ++++++++++++--
>  virt/kvm/arm/psci.c          |  1 +
>  4 files changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/kvm/handle_exit.c b/arch/arm/kvm/handle_exit.c
> index 5fd7968cdae9..a2b4f7b82356 100644
> --- a/arch/arm/kvm/handle_exit.c
> +++ b/arch/arm/kvm/handle_exit.c
> @@ -72,6 +72,7 @@ static int kvm_handle_wfx(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  		trace_kvm_wfx(*vcpu_pc(vcpu), false);
>  		vcpu->stat.wfi_exit_stat++;
>  		kvm_vcpu_block(vcpu);
> +		kvm_clear_request(KVM_REQ_UNHALT, vcpu);
>  	}
>  
>  	kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index fa1b18e364fc..17d8a1677a0b 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -89,6 +89,7 @@ static int kvm_handle_wfx(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  		trace_kvm_wfx_arm64(*vcpu_pc(vcpu), false);
>  		vcpu->stat.wfi_exit_stat++;
>  		kvm_vcpu_block(vcpu);
> +		kvm_clear_request(KVM_REQ_UNHALT, vcpu);
>  	}
>  
>  	kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index 3c387fdc4a9e..138212605ad9 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -546,6 +546,7 @@ void kvm_arm_resume_guest(struct kvm *kvm)
>  
>  	kvm_for_each_vcpu(i, vcpu, kvm) {
>  		vcpu->arch.pause = false;
> +		kvm_clear_request(KVM_REQ_VCPU_EXIT, vcpu);
>  		swake_up(kvm_arch_vcpu_wq(vcpu));
>  	}
>  }
> @@ -638,8 +639,18 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  			run->exit_reason = KVM_EXIT_INTR;
>  		}
>  
> +		/*
> +		 * Ensure we set mode to IN_GUEST_MODE after we disable
> +		 * interrupts and before the final VCPU requests check.
> +		 * See the comment in kvm_vcpu_exiting_guest_mode() and
> +		 * Documentation/virtual/kvm/vcpu-requests.rst
> +		 */
> +		smp_store_mb(vcpu->mode, IN_GUEST_MODE);
> +
>  		if (ret <= 0 || need_new_vmid_gen(vcpu->kvm) ||
> -			vcpu->arch.power_off || vcpu->arch.pause) {
> +		    kvm_request_pending(vcpu) ||
> +		    vcpu->arch.power_off || vcpu->arch.pause) {
> +			vcpu->mode = OUTSIDE_GUEST_MODE;
>  			local_irq_enable();
>  			kvm_pmu_sync_hwstate(vcpu);
>  			kvm_timer_sync_hwstate(vcpu);
> @@ -655,7 +666,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  		 */
>  		trace_kvm_entry(*vcpu_pc(vcpu));
>  		guest_enter_irqoff();
> -		vcpu->mode = IN_GUEST_MODE;
>  
>  		ret = kvm_call_hyp(__kvm_vcpu_run, vcpu);
>  
> diff --git a/virt/kvm/arm/psci.c b/virt/kvm/arm/psci.c
> index a08d7a93aebb..f68be2cc6256 100644
> --- a/virt/kvm/arm/psci.c
> +++ b/virt/kvm/arm/psci.c
> @@ -57,6 +57,7 @@ static unsigned long kvm_psci_vcpu_suspend(struct kvm_vcpu *vcpu)
>  	 * for KVM will preserve the register state.
>  	 */
>  	kvm_vcpu_block(vcpu);
> +	kvm_clear_request(KVM_REQ_UNHALT, vcpu);
>  
>  	return PSCI_RET_SUCCESS;
>  }
> -- 
> 2.9.4
> 
