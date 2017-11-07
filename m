From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 15/37] KVM: arm64: Don't deactivate VM on VHE systems
Date: Tue, 7 Nov 2017 17:14:50 +0100
Message-ID: <20171107161450.akn7yspt4ebxynjy@kamzik.brq.redhat.com>
References: <20171012104141.26902-1-christoffer.dall@linaro.org>
 <20171012104141.26902-16-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171012104141.26902-16-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Oct 12, 2017 at 12:41:19PM +0200, Christoffer Dall wrote:
> There is no need to reset the VTTBR to zero when exiting the guest on
> VHE systems.  VHE systems don't use stage 2 translations for the EL2&0
> translation regime used by the host.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
>  arch/arm64/kvm/hyp/switch.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> index b72dc66..2cedf12 100644
> --- a/arch/arm64/kvm/hyp/switch.c
> +++ b/arch/arm64/kvm/hyp/switch.c
> @@ -136,13 +136,13 @@ static void __hyp_text __deactivate_traps(struct kvm_vcpu *vcpu)
>  	write_sysreg(0, pmuserenr_el0);
>  }
>  
> -static void __hyp_text __activate_vm(struct kvm_vcpu *vcpu)
> +static inline void __hyp_text __activate_vm(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm *kvm = kern_hyp_va(vcpu->kvm);

Hmm, should we change __activate_vm to take a kvm pointer instead of a
vcpu, and then call the function from the VHE kvm_vcpu_run normally, but
from the non-VHE kvm_vcpu_run with kern_hyp_va(vcpu->kvm)? I only ask,
because it appears to be the last kern_hyp_va() that VHE code would still
invoke, at least considering the code in arch/arm64/kvm/hyp/switch.c

>  	write_sysreg(kvm->arch.vttbr, vttbr_el2);
>  }
>  
> -static void __hyp_text __deactivate_vm(struct kvm_vcpu *vcpu)
> +static inline void __hyp_text __deactivate_vm(struct kvm_vcpu *vcpu)

Adding these 'inline' attributes is unrelated to this patch, and probably
unnecessary, as the compiler probably knew to do so anyway, but whatever.

>  {
>  	write_sysreg(0, vttbr_el2);
>  }
> @@ -360,7 +360,6 @@ int kvm_vcpu_run(struct kvm_vcpu *vcpu)
>  	__vgic_save_state(vcpu);
>  
>  	__deactivate_traps(vcpu);
> -	__deactivate_vm(vcpu);
>  
>  	__sysreg_restore_host_state(host_ctxt);
>  
> -- 
> 2.9.0
> 

Reviewed-by: Andrew Jones <drjones@redhat.com>
