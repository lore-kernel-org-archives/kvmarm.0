From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 22/37] KVM: arm64: Change 32-bit handling of VM system
 registers
Date: Mon, 13 Nov 2017 17:25:51 +0100
Message-ID: <20171113162551.i6xnmohnzs6lpf3w@hawk.localdomain>
References: <20171012104141.26902-1-christoffer.dall@linaro.org>
 <20171012104141.26902-23-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171012104141.26902-23-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Oct 12, 2017 at 12:41:26PM +0200, Christoffer Dall wrote:
> We currently handle 32-bit accesses to trapped VM system registers using
> the 32-bit index into the coproc array on the vcpu structure, which is a
> union of the coprog array and the sysreg array.

coproc

> 
> Since all the 32-bit coproc indicies are created to correspond to the
> architectural mapping between 64-bit system registers and 32-bit
> coprocessor registers, and because the AArch64 system registers are the
> double in size of the AArch32 coprocessor registers, we can always find
> the system register entry that we must update by dividing the 32-bit
> coproc index by 2.
> 
> This is going to make our lives much easier when we have to start
> accessing system registers that uses deferred save/restore and might

use

> have to be read directly from the physical CPU.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
>  arch/arm64/include/asm/kvm_host.h |  8 --------
>  arch/arm64/kvm/sys_regs.c         | 20 +++++++++++++++-----
>  2 files changed, 15 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 5e09eb9..9f5761f 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -289,14 +289,6 @@ struct kvm_vcpu_arch {
>  #define vcpu_cp14(v,r)		((v)->arch.ctxt.copro[(r)])
>  #define vcpu_cp15(v,r)		((v)->arch.ctxt.copro[(r)])
>  
> -#ifdef CONFIG_CPU_BIG_ENDIAN
> -#define vcpu_cp15_64_high(v,r)	vcpu_cp15((v),(r))
> -#define vcpu_cp15_64_low(v,r)	vcpu_cp15((v),(r) + 1)
> -#else
> -#define vcpu_cp15_64_high(v,r)	vcpu_cp15((v),(r) + 1)
> -#define vcpu_cp15_64_low(v,r)	vcpu_cp15((v),(r))
> -#endif
> -
>  struct kvm_vm_stat {
>  	ulong remote_tlb_flush;
>  };
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index bb0e41b..dbe35fd 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -120,16 +120,26 @@ static bool access_vm_reg(struct kvm_vcpu *vcpu,
>  			  const struct sys_reg_desc *r)
>  {
>  	bool was_enabled = vcpu_has_cache_enabled(vcpu);
> +	u64 val;
> +	int reg = r->reg;
>  
>  	BUG_ON(!p->is_write);
>  
> -	if (!p->is_aarch32) {
> -		vcpu_sys_reg(vcpu, r->reg) = p->regval;
> +	/* See the 32bit mapping in kvm_host.h */
> +	if (p->is_aarch32)
> +		reg = r->reg / 2;
> +
> +	if (!p->is_aarch32 || !p->is_32bit) {
> +		val = p->regval;
>  	} else {
> -		if (!p->is_32bit)
> -			vcpu_cp15_64_high(vcpu, r->reg) = upper_32_bits(p->regval);
> -		vcpu_cp15_64_low(vcpu, r->reg) = lower_32_bits(p->regval);
> +		val = vcpu_sys_reg(vcpu, reg);
> +		if (r->reg % 2)
> +			val = (p->regval << 32) | (u64)lower_32_bits(val);
> +		else
> +			val = ((u64)upper_32_bits(val) << 32) |
> +				(u64)lower_32_bits(p->regval);
>  	}
> +	vcpu_sys_reg(vcpu, reg) = val;
>  
>  	kvm_toggle_cache(vcpu, was_enabled);
>  	return true;
> -- 
> 2.9.0
>

Reviewed-by: Andrew Jones <drjones@redhat.com>
