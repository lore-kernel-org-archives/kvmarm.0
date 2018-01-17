From: Julien Thierry <julien.thierry@arm.com>
Subject: Re: [PATCH v3 30/41] KVM: arm64: Prepare to handle deferred
 save/restore of 32-bit registers
Date: Wed, 17 Jan 2018 18:22:29 +0000
Message-ID: <9a2edac8-29aa-ffac-a845-ef6090e2226c@arm.com>
References: <20180112120747.27999-1-christoffer.dall@linaro.org>
 <20180112120747.27999-31-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E89D849DE2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Jan 2018 13:17:29 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AirWYmhONomU for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Jan 2018 13:17:28 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B8F0F49DC0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Jan 2018 13:17:28 -0500 (EST)
In-Reply-To: <20180112120747.27999-31-christoffer.dall@linaro.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 12/01/18 12:07, Christoffer Dall wrote:
> 32-bit registers are not used by a 64-bit host kernel and can be
> deferred, but we need to rework the accesses to this register to access
> the latest value depending on whether or not guest system registers are
> loaded on the CPU or only reside in memory.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>

Reviewed-by: Julien Thierry <julien.thierry@arm.com>

> ---
>   arch/arm64/include/asm/kvm_emulate.h | 32 +++++-------------
>   arch/arm64/kvm/regmap.c              | 65 ++++++++++++++++++++++++++----------
>   arch/arm64/kvm/sys_regs.c            |  6 ++--
>   3 files changed, 60 insertions(+), 43 deletions(-)
> 

[...]

> diff --git a/arch/arm64/kvm/regmap.c b/arch/arm64/kvm/regmap.c
> index bbc6ae32e4af..3f65098aff8d 100644
> --- a/arch/arm64/kvm/regmap.c
> +++ b/arch/arm64/kvm/regmap.c
> @@ -141,28 +141,59 @@ unsigned long *vcpu_reg32(const struct kvm_vcpu *vcpu, u8 reg_num)
>   /*
>    * Return the SPSR for the current mode of the virtual CPU.
>    */
> -unsigned long *vcpu_spsr32(const struct kvm_vcpu *vcpu)
> +static int vcpu_spsr32_mode(const struct kvm_vcpu *vcpu)
>   {
>   	unsigned long mode = *vcpu_cpsr(vcpu) & COMPAT_PSR_MODE_MASK;
>   	switch (mode) {
> -	case COMPAT_PSR_MODE_SVC:
> -		mode = KVM_SPSR_SVC;
> -		break;
> -	case COMPAT_PSR_MODE_ABT:
> -		mode = KVM_SPSR_ABT;
> -		break;
> -	case COMPAT_PSR_MODE_UND:
> -		mode = KVM_SPSR_UND;
> -		break;
> -	case COMPAT_PSR_MODE_IRQ:
> -		mode = KVM_SPSR_IRQ;
> -		break;
> -	case COMPAT_PSR_MODE_FIQ:
> -		mode = KVM_SPSR_FIQ;
> -		break;
> +	case COMPAT_PSR_MODE_SVC: return KVM_SPSR_SVC;
> +	case COMPAT_PSR_MODE_ABT: return KVM_SPSR_ABT;
> +	case COMPAT_PSR_MODE_UND: return KVM_SPSR_UND;
> +	case COMPAT_PSR_MODE_IRQ: return KVM_SPSR_IRQ;
> +	case COMPAT_PSR_MODE_FIQ: return KVM_SPSR_FIQ;
> +	default: BUG();
> +	}
> +}
> +
> +unsigned long vcpu_read_spsr32(const struct kvm_vcpu *vcpu)
> +{
> +	int spsr_idx = vcpu_spsr32_mode(vcpu);
> +
> +	if (!vcpu->arch.sysregs_loaded_on_cpu)
> +		return vcpu_gp_regs(vcpu)->spsr[spsr_idx];
> +
> +	switch (spsr_idx) {
> +	case KVM_SPSR_SVC:
> +		return read_sysreg_el1(spsr);
> +	case KVM_SPSR_ABT:
> +		return read_sysreg(spsr_abt);
> +	case KVM_SPSR_UND:
> +		return read_sysreg(spsr_und);
> +	case KVM_SPSR_IRQ:
> +		return read_sysreg(spsr_irq);
> +	case KVM_SPSR_FIQ:
> +		return read_sysreg(spsr_fiq);
>   	default:
>   		BUG();

Nit:

Since the BUG() is in vcpu_spsr32_mode now, you can probably remove it 
here (or add it to vcpu_write_sprsr32 for consistency).

>   	}
> +}
>   
> -	return (unsigned long *)&vcpu_gp_regs(vcpu)->spsr[mode];
> +void vcpu_write_spsr32(struct kvm_vcpu *vcpu, unsigned long v)
> +{
> +	int spsr_idx = vcpu_spsr32_mode(vcpu);
> +
> +	if (!vcpu->arch.sysregs_loaded_on_cpu)
> +		vcpu_gp_regs(vcpu)->spsr[spsr_idx] = v;
> +
> +	switch (spsr_idx) {
> +	case KVM_SPSR_SVC:
> +		write_sysreg_el1(v, spsr);
> +	case KVM_SPSR_ABT:
> +		write_sysreg(v, spsr_abt);
> +	case KVM_SPSR_UND:
> +		write_sysreg(v, spsr_und);
> +	case KVM_SPSR_IRQ:
> +		write_sysreg(v, spsr_irq);
> +	case KVM_SPSR_FIQ:
> +		write_sysreg(v, spsr_fiq);
> +	}
>   }

Cheers,

-- 
Julien Thierry
