From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 3/3] arm64: kvm: add support for the extended 64bit
 ccsidr
Date: Wed, 1 Feb 2017 16:02:53 +0000
Message-ID: <85bd7758-e0a3-f274-ba7a-db080e66d97c@arm.com>
References: <1485793527-18028-1-git-send-email-sudeep.holla@arm.com>
 <1485793527-18028-3-git-send-email-sudeep.holla@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EC7A940966
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Feb 2017 11:02:36 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AzJUo1mJahBs for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Feb 2017 11:02:35 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 94452405DA
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Feb 2017 11:02:35 -0500 (EST)
In-Reply-To: <1485793527-18028-3-git-send-email-sudeep.holla@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Sudeep Holla <sudeep.holla@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 30/01/17 16:25, Sudeep Holla wrote:
> csselr and ccsidr are treated as 64-bit values already elsewhere in the
> kernel. It also aligns well with the architecture extensions that allow
> 64-bit format for ccsidr.
> 
> This patch upgrades the existing accesses to csselr and ccsidr from
> 32-bit to 64-bit in preparation to add support to those extensions.
> It also add dedicated KVM_REG_ARM_DEMUX_ID_EXT_CCSIDR demux register
> to handle 64-bit ccsidr in KVM.
> 
> Cc: Christoffer Dall <christoffer.dall@linaro.org>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
> ---
>  arch/arm64/include/uapi/asm/kvm.h |   1 +
>  arch/arm64/kvm/sys_regs.c         | 104 ++++++++++++++++++++++++++++----------
>  2 files changed, 77 insertions(+), 28 deletions(-)
> 
> v1->v2:
> 	- Added dependency on cpu_supports_ccsidr_64b_format(PATCH 1/3)
> 	- Added a new KVM_REG_ARM_DEMUX_ID_EXT_CCSIDR demux register id
> 	  to support new 64bit CCSIDR
> 
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index 3051f86a9b5f..8aa18e65e6a5 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -161,6 +161,7 @@ struct kvm_arch_memory_slot {
>  #define KVM_REG_ARM_DEMUX_ID_MASK	0x000000000000FF00
>  #define KVM_REG_ARM_DEMUX_ID_SHIFT	8
>  #define KVM_REG_ARM_DEMUX_ID_CCSIDR	(0x00 << KVM_REG_ARM_DEMUX_ID_SHIFT)
> +#define KVM_REG_ARM_DEMUX_ID_EXT_CCSIDR	(0x01 << KVM_REG_ARM_DEMUX_ID_SHIFT)
>  #define KVM_REG_ARM_DEMUX_VAL_MASK	0x00000000000000FF
>  #define KVM_REG_ARM_DEMUX_VAL_SHIFT	0
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 72656743b4cc..f9822ac6d9ab 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -58,15 +58,15 @@
>   */
> 
>  /* 3 bits per cache level, as per CLIDR, but non-existent caches always 0 */
> -static u32 cache_levels;
> +static u64 cache_levels;
> 
> -/* CSSELR values; used to index KVM_REG_ARM_DEMUX_ID_CCSIDR */
> +/* CSSELR values; used to index KVM_REG_ARM_DEMUX_ID_{EXT_,}CCSIDR */
>  #define CSSELR_MAX 	((MAX_CACHE_LEVEL - 1) << 1)
> 
>  /* Which cache CCSIDR represents depends on CSSELR value. */
> -static u32 get_ccsidr(u32 csselr)
> +static u64 get_ccsidr(u64 csselr)
>  {
> -	u32 ccsidr;
> +	u64 ccsidr;
> 
>  	/* Make sure noone else changes CSSELR during this! */
>  	local_irq_disable();
> @@ -1952,9 +1952,9 @@ static int set_invariant_sys_reg(u64 id, void __user *uaddr)
>  	return 0;
>  }
> 
> -static bool is_valid_cache(u32 val)
> +static bool is_valid_cache(u64 val)
>  {
> -	u32 level, ctype;
> +	u64 level, ctype;
> 
>  	if (val >= CSSELR_MAX)
>  		return false;
> @@ -1977,10 +1977,28 @@ static bool is_valid_cache(u32 val)
>  	}
>  }
> 
> +static int demux_ccsidr_validate_get(u64 id, int size, u64 *val)
> +{
> +	u64 cidx;
> +
> +	if (KVM_REG_SIZE(id) != size)
> +		return -ENOENT;
> +
> +	cidx = (id & KVM_REG_ARM_DEMUX_VAL_MASK)
> +			>> KVM_REG_ARM_DEMUX_VAL_SHIFT;
> +	if (!is_valid_cache(cidx))
> +		return -ENOENT;
> +
> +	*val = get_ccsidr(cidx);
> +	return 0;
> +}
> +
>  static int demux_c15_get(u64 id, void __user *uaddr)
>  {
> -	u32 val;
> -	u32 __user *uval = uaddr;
> +	int ret;
> +	u64 val;
> +	u32 __user *uval;
> +	u64 __user *uval64;
> 
>  	/* Fail if we have unknown bits set. */
>  	if (id & ~(KVM_REG_ARCH_MASK|KVM_REG_SIZE_MASK|KVM_REG_ARM_COPROC_MASK
> @@ -1989,14 +2007,17 @@ static int demux_c15_get(u64 id, void __user *uaddr)
> 
>  	switch (id & KVM_REG_ARM_DEMUX_ID_MASK) {
>  	case KVM_REG_ARM_DEMUX_ID_CCSIDR:
> -		if (KVM_REG_SIZE(id) != 4)
> -			return -ENOENT;
> -		val = (id & KVM_REG_ARM_DEMUX_VAL_MASK)
> -			>> KVM_REG_ARM_DEMUX_VAL_SHIFT;
> -		if (!is_valid_cache(val))
> -			return -ENOENT;
> -
> -		return put_user(get_ccsidr(val), uval);
> +		ret = demux_ccsidr_validate_get(id, sizeof(*uval), &val);
> +		if (ret)
> +			return ret;
> +		uval = uaddr;
> +		return put_user(val, uval);
> +	case KVM_REG_ARM_DEMUX_ID_EXT_CCSIDR:
> +		ret = demux_ccsidr_validate_get(id, sizeof(*uval64), &val);
> +		if (ret)
> +			return ret;
> +		uval64 = uaddr;
> +		return put_user(val, uval64);
>  	default:
>  		return -ENOENT;
>  	}
> @@ -2004,8 +2025,10 @@ static int demux_c15_get(u64 id, void __user *uaddr)
> 
>  static int demux_c15_set(u64 id, void __user *uaddr)
>  {
> -	u32 val, newval;
> -	u32 __user *uval = uaddr;
> +	int ret;
> +	u64 val, newval;
> +	u32 __user *uval;
> +	u64 __user *uval64;
> 
>  	/* Fail if we have unknown bits set. */
>  	if (id & ~(KVM_REG_ARCH_MASK|KVM_REG_SIZE_MASK|KVM_REG_ARM_COPROC_MASK
> @@ -2014,18 +2037,29 @@ static int demux_c15_set(u64 id, void __user *uaddr)
> 
>  	switch (id & KVM_REG_ARM_DEMUX_ID_MASK) {
>  	case KVM_REG_ARM_DEMUX_ID_CCSIDR:
> -		if (KVM_REG_SIZE(id) != 4)
> -			return -ENOENT;
> -		val = (id & KVM_REG_ARM_DEMUX_VAL_MASK)
> -			>> KVM_REG_ARM_DEMUX_VAL_SHIFT;
> -		if (!is_valid_cache(val))
> -			return -ENOENT;
> +		ret = demux_ccsidr_validate_get(id, sizeof(*uval), &val);
> +		if (ret)
> +			return ret;
> 
> +		uval = uaddr;
>  		if (get_user(newval, uval))
>  			return -EFAULT;
> 
>  		/* This is also invariant: you can't change it. */
> -		if (newval != get_ccsidr(val))
> +		if (newval != val)
> +			return -EINVAL;
> +		return 0;
> +	case KVM_REG_ARM_DEMUX_ID_EXT_CCSIDR:
> +		ret = demux_ccsidr_validate_get(id, sizeof(*uval), &val);
> +		if (ret)
> +			return ret;
> +
> +		uval64 = uaddr;
> +		if (get_user(newval, uval64))
> +			return -EFAULT;
> +
> +		/* This is also invariant: you can't change it. */
> +		if (newval != val)
>  			return -EINVAL;
>  		return 0;
>  	default:
> @@ -2086,12 +2120,10 @@ static unsigned int num_demux_regs(void)
>  	return count;
>  }
> 
> -static int write_demux_regids(u64 __user *uindices)
> +static int write_demux_ccsidr(u64 val, u64 __user *uindices)
>  {
> -	u64 val = KVM_REG_ARM64 | KVM_REG_SIZE_U32 | KVM_REG_ARM_DEMUX;
>  	unsigned int i;
> 
> -	val |= KVM_REG_ARM_DEMUX_ID_CCSIDR;
>  	for (i = 0; i < CSSELR_MAX; i++) {
>  		if (!is_valid_cache(i))
>  			continue;
> @@ -2099,9 +2131,25 @@ static int write_demux_regids(u64 __user *uindices)
>  			return -EFAULT;
>  		uindices++;
>  	}
> +
>  	return 0;
>  }
> 
> +static int write_demux_regids(u64 __user *uindices)
> +{
> +	int ret;
> +	u64 val = KVM_REG_ARM64 | KVM_REG_ARM_DEMUX;
> +
> +	if (cpu_supports_ccsidr_64b_format())
> +		/* 64 bit extended CCSIDR */
> +		ret = write_demux_ccsidr(val | KVM_REG_ARM_DEMUX_ID_EXT_CCSIDR |
> +					 KVM_REG_SIZE_U64, uindices);
> +	else
> +		ret = write_demux_ccsidr(val | KVM_REG_ARM_DEMUX_ID_CCSIDR |
> +					 KVM_REG_SIZE_U32, uindices);
> +	return ret;
> +}
> +
>  static u64 sys_reg_to_index(const struct sys_reg_desc *reg)
>  {
>  	return (KVM_REG_ARM64 | KVM_REG_SIZE_U64 |
> --
> 2.7.4
> 

I'm a bit worried about this patch. If we snapshot a VM on a 32bit
CCSIDR system, and restore it on a 64bit CSSIDR system (or the reverse),
what happens? My hunch is that we cannot restore the VM properly.

Now, I'm questioning the need for having those altogether, as we do a
lot of work to prevent the guest from actually using that geometry (and
on a big-little system, this hardly works).

Christoffer, what do you think?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
