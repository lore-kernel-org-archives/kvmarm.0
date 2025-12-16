Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2A7634B196
	for <kvmarm@lists.linux.dev>; Tue, 16 Dec 2025 11:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885233; cv=none; b=fNAXdafoXAU8Y/yysQ/O30smlAwjR57rQjeeypEGTHnsiOU987snNbqCeLRTW9XFiFmQu5Hq3Et33SJ9pS5DCbKmnXJoYCKIwXwmr+UVr8dtydAkKzX9NPc2CY94usFeHvzJkxWefmOag8CTMR+004jYYa/zVLEJUZKLVlsriUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885233; c=relaxed/simple;
	bh=HOv8peaZqKO72YKuuevzyqOzgp5gBc7OVhO62RP22SI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C5oOaExhudokEfWPyFO28r9x/9iEvsWMmPqexkklD3+pYf7rN2Ffp8Evw/xNqjgOJ1LAnOXnkSISElwrWLishwKzXaJkwQ4qPv35VX4Nyjq6VyXRfu/WWptLQDBQjz6CixwW9aPVOJY4q+0ee7xPXCOIS0IMwDZ3feZvi0BYN9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D3B6CFEC;
	Tue, 16 Dec 2025 03:40:16 -0800 (PST)
Received: from [10.57.79.61] (unknown [10.57.79.61])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5C3463F73B;
	Tue, 16 Dec 2025 03:40:22 -0800 (PST)
Message-ID: <36416368-4447-4b16-8496-3e3d603d88d4@arm.com>
Date: Tue, 16 Dec 2025 11:40:20 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v6 16/35] KVM: arm64: Advertise SPE version in
 ID_AA64DFR0_EL1.PMSver
Content-Language: en-GB
To: Alexandru Elisei <alexandru.elisei@arm.com>, maz@kernel.org,
 oliver.upton@linux.dev, joey.gouly@arm.com, yuzenghui@huawei.com,
 will@kernel.org, catalin.marinas@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Cc: james.clark@linaro.org, mark.rutland@arm.com, james.morse@arm.com
References: <20251114160717.163230-1-alexandru.elisei@arm.com>
 <20251114160717.163230-17-alexandru.elisei@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20251114160717.163230-17-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 14/11/2025 16:06, Alexandru Elisei wrote:
> The VCPU registers are reset during the KVM_ARM_VCPU_INIT ioctl, before
> userspace can set the desired SPU. Assume that the VCPU is initialized from


> a thread that runs on one of the physical CPUs that correspond to the SPU
> that userspace will choose for the VM. Set PMSVer to that CPUs hardware
> value.

This doesn't match the code. See below.

> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>   arch/arm64/include/asm/kvm_spe.h |  6 ++++++
>   arch/arm64/kvm/spe.c             | 10 ++++++++++
>   arch/arm64/kvm/sys_regs.c        | 10 +++++++++-
>   3 files changed, 25 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_spe.h b/arch/arm64/include/asm/kvm_spe.h
> index 6ce70cf2abaf..5e6d7e609a48 100644
> --- a/arch/arm64/include/asm/kvm_spe.h
> +++ b/arch/arm64/include/asm/kvm_spe.h
> @@ -33,6 +33,8 @@ static __always_inline bool kvm_supports_spe(void)
>   void kvm_spe_init_vm(struct kvm *kvm);
>   int kvm_spe_vcpu_first_run_init(struct kvm_vcpu *vcpu);
>   
> +u8 kvm_spe_get_pmsver_limit(void);
> +
>   int kvm_spe_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
>   int kvm_spe_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
>   int kvm_spe_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
> @@ -53,6 +55,10 @@ static inline int kvm_spe_vcpu_first_run_init(struct kvm_vcpu *vcpu)
>   {
>   	return 0;
>   }
> +static inline u8 kvm_spe_get_pmsver_limit(void)
> +{
> +	return 0;
> +}
>   static inline int kvm_spe_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>   {
>   	return -ENXIO;
> diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
> index 6bd074e40f6c..0c4896c6a873 100644
> --- a/arch/arm64/kvm/spe.c
> +++ b/arch/arm64/kvm/spe.c
> @@ -68,6 +68,16 @@ int kvm_spe_vcpu_first_run_init(struct kvm_vcpu *vcpu)
>   	return 0;
>   }
>   
> +u8 kvm_spe_get_pmsver_limit(void)
> +{
> +	unsigned int pmsver;
> +
> +	pmsver = SYS_FIELD_GET(ID_AA64DFR0_EL1, PMSVer,
> +			       read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1));

The read_sanitised_ftr_reg() gives you the system wide sanitised
version, not the one on the current CPU. You may need
read_sysreg_s() instead here.


> +
> +	return min(pmsver, ID_AA64DFR0_EL1_PMSVer_V1P5);
> +}
> +
>   static u64 max_buffer_size_to_pmbidr_el1(u64 size)
>   {
>   	u64 msb_idx, num_bits;
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index e67eb39ddc11..ac859c39c2be 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -29,6 +29,7 @@
>   #include <asm/kvm_hyp.h>
>   #include <asm/kvm_mmu.h>
>   #include <asm/kvm_nested.h>
> +#include <asm/kvm_spe.h>
>   #include <asm/perf_event.h>
>   #include <asm/sysreg.h>
>   
> @@ -1652,6 +1653,9 @@ static s64 kvm_arm64_ftr_safe_value(u32 id, const struct arm64_ftr_bits *ftrp,
>   		case ID_AA64DFR0_EL1_DebugVer_SHIFT:
>   			kvm_ftr.type = FTR_LOWER_SAFE;
>   			break;
> +		case ID_AA64DFR0_EL1_PMSVer_SHIFT:
> +			kvm_ftr.type = FTR_LOWER_SAFE;

PMSVer is already FTR_LOWER_SAFE, and we don't need to override it here 
? (unlike the DebugVer or PMU Ver)

> +			break;
>   		}
>   		break;
>   	case SYS_ID_DFR0_EL1:
> @@ -2021,8 +2025,11 @@ static u64 sanitise_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu, u64 val)
>   		val |= SYS_FIELD_PREP(ID_AA64DFR0_EL1, PMUVer,
>   				      kvm_arm_pmu_get_pmuver_limit());
>   
> -	/* Hide SPE from guests */
>   	val &= ~ID_AA64DFR0_EL1_PMSVer_MASK;
> +	if (vcpu_has_spe(vcpu)) {
> +		val |= SYS_FIELD_PREP(ID_AA64DFR0_EL1, PMSVer,
> +				      kvm_spe_get_pmsver_limit());
> +	}

So, we ignore value that the user sets and go with what the SPE instance
that has been chosen ? Should we make it non-writable then ?

Suzuki

>   
>   	/* Hide BRBE from guests */
>   	val &= ~ID_AA64DFR0_EL1_BRBE_MASK;
> @@ -3209,6 +3216,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>   	 */
>   	ID_FILTERED(ID_AA64DFR0_EL1, id_aa64dfr0_el1,
>   		    ID_AA64DFR0_EL1_DoubleLock_MASK |
> +		    ID_AA64DFR0_EL1_PMSVer_MASK |
>   		    ID_AA64DFR0_EL1_WRPs_MASK |
>   		    ID_AA64DFR0_EL1_PMUVer_MASK |
>   		    ID_AA64DFR0_EL1_DebugVer_MASK),

