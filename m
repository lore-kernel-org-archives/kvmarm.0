From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 1/2] KVM: arm64: Filter out invalid core register IDs
 in KVM_GET_REG_LIST
Date: Tue, 18 Dec 2018 14:00:26 +0000
Message-ID: <822638a1-dbf0-ed4a-55a4-b908a4f13649@arm.com>
References: <1544645824-16461-1-git-send-email-Dave.Martin@arm.com>
 <1544645824-16461-2-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1544645824-16461-2-git-send-email-Dave.Martin@arm.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Dave Martin <Dave.Martin@arm.com>, kvmarm@lists.cs.columbia.edu, Peter Maydell <peter.maydell@linaro.org>
Cc: Christoffer Dall <christoffer.dall@arm.com>, linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 12/12/2018 20:17, Dave Martin wrote:
> Since commit d26c25a9d19b ("arm64: KVM: Tighten guest core register
> access from userspace"), KVM_{GET,SET}_ONE_REG rejects register IDs
> that do not correspond to a single underlying architectural register.
> 
> KVM_GET_REG_LIST was not changed to match however: instead, it
> simply yields a list of 32-bit register IDs that together cover the
> whole kvm_regs struct.  This means that if userspace tries to use
> the resulting list of IDs directly to drive calls to KVM_*_ONE_REG,
> some of those calls will now fail.
> 
> This was not the intention.  Instead, iterating KVM_*_ONE_REG over
> the list of IDs returned by KVM_GET_REG_LIST should be guaranteed
> to work.
> 
> This patch fixes the problem by splitting validate_core_reg_id()
> into a backend core_reg_size_from_offset() which does all of the
> work except for checking that the size field in the register ID
> matches, and kvm_arm_copy_reg_indices() and num_core_regs() are
> converted to use this to enumerate the valid offsets.
> 
> kvm_arm_copy_reg_indices() now also sets the register ID size field
> appropriately based on the value returned, so the register ID
> supplied to userspace is fully qualified for use with the register
> access ioctls.
> 
> Cc: stable@vger.kernel.org
> Fixes: d26c25a9d19b ("arm64: KVM: Tighten guest core register access from userspace")
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> ---
>  arch/arm64/kvm/guest.c | 61 ++++++++++++++++++++++++++++++++++++++++++++------
>  1 file changed, 54 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index dd436a5..cbe423b 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -57,9 +57,8 @@ static u64 core_reg_offset_from_id(u64 id)
>  	return id & ~(KVM_REG_ARCH_MASK | KVM_REG_SIZE_MASK | KVM_REG_ARM_CORE);
>  }
>  
> -static int validate_core_offset(const struct kvm_one_reg *reg)
> +static int core_reg_size_from_offset(u64 off)
>  {
> -	u64 off = core_reg_offset_from_id(reg->id);
>  	int size;
>  
>  	switch (off) {
> @@ -89,8 +88,21 @@ static int validate_core_offset(const struct kvm_one_reg *reg)
>  		return -EINVAL;
>  	}
>  
> -	if (KVM_REG_SIZE(reg->id) == size &&
> -	    IS_ALIGNED(off, size / sizeof(__u32)))
> +	if (IS_ALIGNED(off, size / sizeof(__u32)))
> +		return size;
> +
> +	return -EINVAL;
> +}
> +
> +static int validate_core_offset(const struct kvm_one_reg *reg)
> +{
> +	u64 off = core_reg_offset_from_id(reg->id);
> +	int size = core_reg_size_from_offset(off);
> +
> +	if (size < 0)
> +		return -EINVAL;
> +
> +	if (KVM_REG_SIZE(reg->id) == size)
>  		return 0;
>  
>  	return -EINVAL;
> @@ -195,7 +207,19 @@ int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
>  
>  static unsigned long num_core_regs(void)
>  {
> -	return sizeof(struct kvm_regs) / sizeof(__u32);
> +	unsigned int i;
> +	int n = 0;
> +
> +	for (i = 0; i < sizeof(struct kvm_regs) / sizeof(__u32); i++) {
> +		int size = core_reg_size_from_offset(i);
> +
> +		if (size < 0)
> +			continue;
> +
> +		n++;
> +	}
> +
> +	return n;
>  }
>  
>  /**
> @@ -270,11 +294,34 @@ unsigned long kvm_arm_num_regs(struct kvm_vcpu *vcpu)
>  int kvm_arm_copy_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
>  {
>  	unsigned int i;
> -	const u64 core_reg = KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE;
>  	int ret;
>  
>  	for (i = 0; i < sizeof(struct kvm_regs) / sizeof(__u32); i++) {
> -		if (put_user(core_reg | i, uindices))
> +		u64 reg = KVM_REG_ARM64 | KVM_REG_ARM_CORE | i;
> +		int size = core_reg_size_from_offset(i);
> +
> +		if (size < 0)
> +			continue;
> +
> +		switch (size) {
> +		case sizeof(__u32):
> +			reg |= KVM_REG_SIZE_U32;
> +			break;
> +
> +		case sizeof(__u64):
> +			reg |= KVM_REG_SIZE_U64;
> +			break;
> +
> +		case sizeof(__uint128_t):
> +			reg |= KVM_REG_SIZE_U128;
> +			break;
> +
> +		default:
> +			WARN_ON(1);
> +			continue;
> +		}
> +
> +		if (put_user(reg, uindices))
>  			return -EFAULT;
>  		uindices++;
>  	}
> 

I'm quite keen on queuing this for 4.21, but I'd like Peter's seal of
approval on it.

Peter?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
