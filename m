Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E42CE1D47AC;
	Thu, 17 Oct 2024 15:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729179141; cv=none; b=BvR9AI/2tHxeMO5/oVs91bTxv3wbQXAwNQZEAa0zHTtgi5y4WcgxEohGiJsFG2OtnRKfGjMYHsqWeezHw1SXz+xRsE8T+hsQIRg7QOoxjdV8kYdxaeobY/ugLKIOB7UXkckK+lPja9BS+lcxZJnrpa87paV0PJqL8JMjgWD1RE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729179141; c=relaxed/simple;
	bh=SXtzKMYQw4YGoZMy9cziDnMey+ubUZZhAaoTGjWv/zI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JuNnf41Ldq7gqn8Idsn/9yc29oqX/WyvpaBLm+HZzLMHALFbbHXaK3IFy/LApdU17KAqcKD+eBzANv3zrRC2oC4UYhz04V7uMeSW1wm35tcFU7kQnshIIhojI44R5tw5a4czOK99oPV5UyoiZis5DPMpQH+AacUXfRB3HHUhAbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E4AEFFEC;
	Thu, 17 Oct 2024 08:32:45 -0700 (PDT)
Received: from [10.57.22.188] (unknown [10.57.22.188])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id F30583F528;
	Thu, 17 Oct 2024 08:32:12 -0700 (PDT)
Message-ID: <de0ebef7-8be3-444f-99ee-5e9b6f9140f7@arm.com>
Date: Thu, 17 Oct 2024 16:32:12 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 23/43] KVM: arm64: Validate register access for a Realm
 VM
Content-Language: en-GB
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>
References: <20241004152804.72508-1-steven.price@arm.com>
 <20241004152804.72508-24-steven.price@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20241004152804.72508-24-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Steven

On 04/10/2024 16:27, Steven Price wrote:
> The RMM only allows setting the lower GPRS (x0-x7) and PC for a realm
> guest. Check this in kvm_arm_set_reg() so that the VMM can receive a
> suitable error return if other registers are accessed.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>   arch/arm64/kvm/guest.c | 26 ++++++++++++++++++++++++++
>   1 file changed, 26 insertions(+)
> 
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index 962f985977c2..c23b9480ceb0 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -783,12 +783,38 @@ int kvm_arm_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>   	return kvm_arm_sys_reg_get_reg(vcpu, reg);
>   }
>   
> +/*
> + * The RMI ABI only enables setting the lower GPRs (x0-x7) and PC.

This is true only for REC_CREATE ? But when we handle SMCCC calls in the
userspace, we may need to allow setting x0-x17 and we should accommodate
for that here ?

Otherwise looks good to me.

Suzuki


> + * All other registers are reset to architectural or otherwise defined reset
> + * values by the RMM, except for a few configuration fields that correspond to
> + * Realm parameters.
> + */
> +static bool validate_realm_set_reg(struct kvm_vcpu *vcpu,
> +				   const struct kvm_one_reg *reg)
> +{
> +	if ((reg->id & KVM_REG_ARM_COPROC_MASK) == KVM_REG_ARM_CORE) {
> +		u64 off = core_reg_offset_from_id(reg->id);
> +
> +		switch (off) {
> +		case KVM_REG_ARM_CORE_REG(regs.regs[0]) ...
> +		     KVM_REG_ARM_CORE_REG(regs.regs[7]):

> +		case KVM_REG_ARM_CORE_REG(regs.pc):
> +			return true;
> +		}
> +	}
> +
> +	return false;
> +}
> +
>   int kvm_arm_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>   {
>   	/* We currently use nothing arch-specific in upper 32 bits */
>   	if ((reg->id & ~KVM_REG_SIZE_MASK) >> 32 != KVM_REG_ARM64 >> 32)
>   		return -EINVAL;
>   
> +	if (kvm_is_realm(vcpu->kvm) && !validate_realm_set_reg(vcpu, reg))
> +		return -EINVAL;
> +
>   	switch (reg->id & KVM_REG_ARM_COPROC_MASK) {
>   	case KVM_REG_ARM_CORE:	return set_core_reg(vcpu, reg);
>   	case KVM_REG_ARM_FW:

