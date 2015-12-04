From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 1/4] KVM: arm64: Correctly handle zero register during
 MMIO
Date: Fri, 04 Dec 2015 15:33:03 +0000
Message-ID: <5661B22F.6080909@arm.com>
References: <cover.1449230499.git.p.fedin@samsung.com> <1158b9cda9dc726342280bd36b0c06631f3d9e88.1449230499.git.p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1158b9cda9dc726342280bd36b0c06631f3d9e88.1449230499.git.p.fedin@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Pavel Fedin <p.fedin@samsung.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 04/12/15 12:03, Pavel Fedin wrote:
> On ARM64 register index of 31 corresponds to both zero register and SP.
> However, all memory access instructions, use ZR as transfer register. SP
> is used only as a base register in indirect memory addressing, or by
> register-register arithmetics, which cannot be trapped here.
> 
> Correct emulation is achieved by introducing new register accessor
> functions, which can do special handling for reg_num == 31. These new
> accessors intentionally do not rely on old vcpu_reg() on ARM64, because
> it is to be removed. Since the affected code is shared by both ARM
> flavours, implementations of these accessors are also added to ARM32 code.
> 
> This patch fixes setting MMIO register to a random value (actually SP)
> instead of zero by something like:
> 
>  *((volatile int *)reg) = 0;
> 
> compilers tend to generate "str wzr, [xx]" here
> 
> Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
> Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm/include/asm/kvm_emulate.h   | 12 ++++++++++++
>  arch/arm/kvm/mmio.c                  |  5 +++--
>  arch/arm64/include/asm/kvm_emulate.h | 13 +++++++++++++
>  3 files changed, 28 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/include/asm/kvm_emulate.h b/arch/arm/include/asm/kvm_emulate.h
> index a9c80a2..b7ff32e 100644
> --- a/arch/arm/include/asm/kvm_emulate.h
> +++ b/arch/arm/include/asm/kvm_emulate.h
> @@ -28,6 +28,18 @@
>  unsigned long *vcpu_reg(struct kvm_vcpu *vcpu, u8 reg_num);
>  unsigned long *vcpu_spsr(struct kvm_vcpu *vcpu);
>  
> +static inline unsigned long vcpu_get_reg(const struct kvm_vcpu *vcpu,
> +					 u8 reg_num)
> +{
> +	return *vcpu_reg(vcpu, reg_num);
> +}
> +
> +static inline void vcpu_set_reg(const struct kvm_vcpu *vcpu, u8 reg_num,
> +				unsigned long val)
> +{
> +	*vcpu_reg(vcpu, reg_num) = val;
> +}
> +

This makes a 32bit compile scream (making these vcpu pointer const is
not a good idea).

I'll fix it locally.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
