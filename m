From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v3 09/41] KVM: arm64: Defer restoring host VFP state to
 vcpu_put
Date: Mon, 22 Jan 2018 17:33:28 +0000
Message-ID: <20180122173326.GO22781@e103592.cambridge.arm.com>
References: <20180112120747.27999-1-christoffer.dall@linaro.org>
 <20180112120747.27999-10-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180112120747.27999-10-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Jan 12, 2018 at 01:07:15PM +0100, Christoffer Dall wrote:
> Avoid saving the guest VFP registers and restoring the host VFP
> registers on every exit from the VM.  Only when we're about to run
> userspace or other threads in the kernel do we really have to switch the
> state back to the host state.
> 
> We still initially configure the VFP registers to trap when entering the
> VM, but the difference is that we now leave the guest state in the
> hardware registers as long as we're running this VCPU, even if we
> occasionally trap to the host, and we only restore the host state when
> we return to user space or when scheduling another thread.
> 
> Reviewed-by: Andrew Jones <drjones@redhat.com>
> Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>

[...]

> diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
> index 883a6383cd36..848a46eb33bf 100644
> --- a/arch/arm64/kvm/hyp/sysreg-sr.c
> +++ b/arch/arm64/kvm/hyp/sysreg-sr.c

[...]

> @@ -213,6 +215,19 @@ void kvm_vcpu_load_sysregs(struct kvm_vcpu *vcpu)
>   */
>  void kvm_vcpu_put_sysregs(struct kvm_vcpu *vcpu)
>  {
> +	struct kvm_cpu_context *host_ctxt = vcpu->arch.host_cpu_context;
> +	struct kvm_cpu_context *guest_ctxt = &vcpu->arch.ctxt;
> +
> +	/* Restore host FP/SIMD state */
> +	if (vcpu->arch.guest_vfp_loaded) {
> +		if (vcpu_el1_is_32bit(vcpu)) {
> +			kvm_call_hyp(__fpsimd32_save_state,
> +				     kern_hyp_va(guest_ctxt));
> +		}
> +		__fpsimd_save_state(&guest_ctxt->gp_regs.fp_regs);
> +		__fpsimd_restore_state(&host_ctxt->gp_regs.fp_regs);
> +		vcpu->arch.guest_vfp_loaded = 0;

Provided we've already marked the host FPSIMD state as dirty on the way
in, we probably don't need to restore it here.

In v4.15, the kvm_fpsimd_flush_cpu_state() call in
kvm_arch_vcpu_ioctl_run() is supposed to do this marking: currently
it's only done for SVE, since KVM was previously restoring the host
FPSIMD subset of the state anyway, but it could be made unconditional.

For a returning run ioctl, this would have the effect of deferring the
host FPSIMD reload until we return to userspace, which is probably
no more costly since the kernel must check whether to do this in
ret_to_user anyway; OTOH if the vcpu thread was preempted by some
other thread we save the cost of restoring the host state entirely here
... I think.

Ultimately I'd like to go one better and actually treat a vcpu as a
first-class fpsimd context, so that taking an interrupt to the host
and then reentering the guest doesn't cause any reload at all.  But
that feels like too big a step for this series, and there are likely
side-issues I've not thought about yet.

Cheers
---Dave
