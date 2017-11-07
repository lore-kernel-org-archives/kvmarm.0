From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 14/37] KVM: arm64: Remove kern_hyp_va() use in VHE switch
 function
Date: Tue, 7 Nov 2017 17:07:26 +0100
Message-ID: <20171107160726.4fuw67qfzemm24es@kamzik.brq.redhat.com>
References: <20171012104141.26902-1-christoffer.dall@linaro.org>
 <20171012104141.26902-15-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171012104141.26902-15-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Oct 12, 2017 at 12:41:18PM +0200, Christoffer Dall wrote:
> VHE kernels run completely in EL2 and therefore don't have a notion of
> kernel and hyp addresses, they are all just kernel addresses.  Therefore
> don't call kern_hyp_va() in the VHE switch function.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
>  arch/arm64/kvm/hyp/switch.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> index 8a0f38f..b72dc66 100644
> --- a/arch/arm64/kvm/hyp/switch.c
> +++ b/arch/arm64/kvm/hyp/switch.c
> @@ -326,9 +326,7 @@ int kvm_vcpu_run(struct kvm_vcpu *vcpu)
>  	struct kvm_cpu_context *guest_ctxt;
>  	u64 exit_code;
>  
> -	vcpu = kern_hyp_va(vcpu);
> -
> -	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
> +	host_ctxt = vcpu->arch.host_cpu_context;
>  	host_ctxt->__hyp_running_vcpu = vcpu;
>  	guest_ctxt = &vcpu->arch.ctxt;
>  
> -- 
> 2.9.0
>

Reviewed-by: Andrew Jones <drjones@redhat.com>
