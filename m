Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C1432D8DAF
	for <kvmarm@lists.linux.dev>; Fri,  7 Nov 2025 11:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762516096; cv=none; b=A8WRyQsyn0J2G9aNKW85Mk5DpqwXhZ5IgZ3DjZTFVzi01XSZIZ9S+rEoYSW23qUq+qhQ+/F9DACBShVXo0M15Mormu7i7tWJXxeFU9DgObj8aP6X5lx2bqsH0QxLaKLKyEwbMy9QNL0fzpfpIg/uhb9G5+ap+SCdNaQWPwM9bXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762516096; c=relaxed/simple;
	bh=TTyqYq0CvrFkQs0y0EmUgWxxtZwu4rOyfdCLqOtqRO4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YdpuLgNrDcSIYas6WbWKqDHOKS6M3bprzD7+MgAo0czyXkSD48StzkUQu/PGohLfe/WnqnCDFfboYhD1GloByL6iJpv0stolScs6fXaZCANt2I+AQJu/+wiXAX8v3DFjqveLVj2nayeq0LbZPPo4xYmPJlzDX4SIbosYKQ+jbtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8BDB41515;
	Fri,  7 Nov 2025 03:48:04 -0800 (PST)
Received: from [10.1.197.1] (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 87DD23F63F;
	Fri,  7 Nov 2025 03:48:10 -0800 (PST)
Message-ID: <1f0d24ae-c20c-4067-aa0c-b5bbeba367db@arm.com>
Date: Fri, 7 Nov 2025 11:48:09 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 1/7] KVM: arm64: Add exit to userspace on {LD,ST}64B*
 outside of memslots
To: Zhou Wang <wangzhou1@hisilicon.com>, catalin.marinas@arm.com,
 will@kernel.org, maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
 yuzenghui@huawei.com, arnd@arndb.de
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 yangyccccc@gmail.com, prime.zeng@hisilicon.com, xuwei5@huawei.com
References: <20251107072127.448953-1-wangzhou1@hisilicon.com>
 <20251107072127.448953-2-wangzhou1@hisilicon.com>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20251107072127.448953-2-wangzhou1@hisilicon.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 07/11/2025 07:21, Zhou Wang wrote:
> From: Marc Zyngier <maz@kernel.org>
> 
> The main use of {LD,ST}64B* is to talk to a device, which is hopefully
> directly assigned to the guest and requires no additional handling.
> 
> However, this does not preclude a VMM from exposing a virtual device
> to the guest, and to allow 64 byte accesses as part of the programming
> interface. A direct consequence of this is that we need to be able
> to forward such access to userspace.
> 
> Given that such a contraption is very unlikely to ever exist, we choose
> to offer a limited service: userspace gets (as part of a new exit reason)
> the ESR, the IPA, and that's it. It is fully expected to handle the full
> semantics of the instructions, deal with ACCDATA, the return values and
> increment PC. Much fun.
> 
> A canonical implementation can also simply inject an abort and be done
> with it. Frankly, don't try to do anything else unless you have time
> to waste.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
> Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>

We also need to document this new EXIT reason here :

Documentation/virt/kvm/api.rst


> ---
>   arch/arm64/kvm/mmio.c    | 27 ++++++++++++++++++++++++++-
>   include/uapi/linux/kvm.h |  3 ++-
>   2 files changed, 28 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmio.c b/arch/arm64/kvm/mmio.c
> index 54f9358c9e0e..2a6261abb647 100644
> --- a/arch/arm64/kvm/mmio.c
> +++ b/arch/arm64/kvm/mmio.c
> @@ -159,6 +159,9 @@ int io_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
>   	bool is_write;
>   	int len;
>   	u8 data_buf[8];
> +	u64 esr;
> +
> +	esr = kvm_vcpu_get_esr(vcpu);
>   
>   	/*
>   	 * No valid syndrome? Ask userspace for help if it has
> @@ -168,7 +171,7 @@ int io_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
>   	 * though, so directly deliver an exception to the guest.
>   	 */
>   	if (!kvm_vcpu_dabt_isvalid(vcpu)) {
> -		trace_kvm_mmio_nisv(*vcpu_pc(vcpu), kvm_vcpu_get_esr(vcpu),
> +		trace_kvm_mmio_nisv(*vcpu_pc(vcpu), esr,
>   				    kvm_vcpu_get_hfar(vcpu), fault_ipa);
>   
>   		if (vcpu_is_protected(vcpu))
> @@ -185,6 +188,28 @@ int io_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
>   		return -ENOSYS;
>   	}
>   
> +	/*
> +	 * When (DFSC == 0b00xxxx || DFSC == 0b10101x) && DFSC != 0b0000xx
> +	 * ESR_EL2[12:11] describe the Load/Store Type. This allows us to
> +	 * punt the LD64B/ST64B/ST64BV/ST64BV0 instructions to luserspace,

minor nit: typo: s/luserspace/userspace/                       ^^^

> +	 * which will have to provide a full emulation of these 4
> +	 * instructions.  No, we don't expect this do be fast.
> +	 *
> +	 * We rely on traps being set if the corresponding features are not
> +	 * enabled, so if we get here, userspace has promised us to handle
> +	 * it already.
> +	 */
> +	switch (kvm_vcpu_trap_get_fault(vcpu)) {
> +	case 0b000100 ... 0b001111:
> +	case 0b101010 ... 0b101011:

Matches Arm ARM.

> +		if (FIELD_GET(GENMASK(12, 11), esr)) {
> +			run->exit_reason = KVM_EXIT_ARM_LDST64B;
> +			run->arm_nisv.esr_iss = esr & ~(u64)ESR_ELx_FSC;

Any particular reason why we diverge from the NISV case, where the FSC 
is provided, but not here ? May be this needs to be documented too.

Suzuki


> +			run->arm_nisv.fault_ipa = fault_ipa;
> +			return 0;
> +		}
> +	}
> +
>   	/*
>   	 * Prepare MMIO operation. First decode the syndrome data we get
>   	 * from the CPU. Then try if some in-kernel emulation feels
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 52f6000ab020..d219946b96be 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -179,6 +179,7 @@ struct kvm_xen_exit {
>   #define KVM_EXIT_LOONGARCH_IOCSR  38
>   #define KVM_EXIT_MEMORY_FAULT     39
>   #define KVM_EXIT_TDX              40
> +#define KVM_EXIT_ARM_LDST64B      41
>   
>   /* For KVM_EXIT_INTERNAL_ERROR */
>   /* Emulate instruction failed. */
> @@ -401,7 +402,7 @@ struct kvm_run {
>   		} eoi;
>   		/* KVM_EXIT_HYPERV */
>   		struct kvm_hyperv_exit hyperv;
> -		/* KVM_EXIT_ARM_NISV */
> +		/* KVM_EXIT_ARM_NISV / KVM_EXIT_ARM_LDST64B */
>   		struct {
>   			__u64 esr_iss;
>   			__u64 fault_ipa;



