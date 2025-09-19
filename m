Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82DEC2D77E2
	for <kvmarm@lists.linux.dev>; Fri, 19 Sep 2025 08:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758269281; cv=none; b=TyVA+s1AMIna5pwq97PwAac1YLK/Js6AzvDqXHvYraJCESs/kiAyAmsi7u4qzaqdkBbeyT5nidW1TnOn0jtLPiQ4J6/5O3X/N0l8tTFTp+KjLyw5zZuwczReQNK7vUygVFgNHx1KFOYAcvBCIJpHlE27ASZr2MDsOxw/UTzMrrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758269281; c=relaxed/simple;
	bh=LDlPDEh2o/r0cuKAQhRmtKoUUYorC6bpasP4zLD5uU8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aNKZd2EQy0M4v4Vpa0lWNCdKF5LqB2HBJ1smDhfFfRa1i70xYSSbd2BL/nHzC2ph0gpVu1prjsZ3qLY+R54nzc0LLUi5VbjFbaNT9+dw1FCmSftR3/Siit+52H5NeLj5Q6wX2JqTB/y4Q9DHJqHSIaRlUeo2MRalD+aP68ecoo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9D713169E;
	Fri, 19 Sep 2025 01:07:51 -0700 (PDT)
Received: from [10.57.7.92] (unknown [10.57.7.92])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DD94D3F673;
	Fri, 19 Sep 2025 01:07:58 -0700 (PDT)
Message-ID: <ba2891a1-9a2c-40f7-8e8d-7dae02c10efc@arm.com>
Date: Fri, 19 Sep 2025 09:07:57 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: arm64: nv: Allow userspace to de-feature stage-2
 TGRANs
Content-Language: en-GB
To: Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
 Zenghui Yu <yuzenghui@huawei.com>, Itaru Kitayama <itaru.kitayama@linux.dev>
References: <20250918165505.415017-1-oliver.upton@linux.dev>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20250918165505.415017-1-oliver.upton@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 18/09/2025 17:55, Oliver Upton wrote:
> KVM advertises the stage-2 TGRAN fields as writable to userspace but
> prevents any modification for NV-enabled VMs. Update the special-cased
> sanitization to permit de-featuring a particular TGRAN without allowing
> the legacy value which refers to the stage-1 field for support.
> 
> Cc: Itaru Kitayama <itaru.kitayama@linux.dev>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>   arch/arm64/kvm/sys_regs.c | 23 ++++++++++++++++++-----
>   1 file changed, 18 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index b29f72478a50..83ecfdb46704 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -2148,16 +2148,29 @@ static int set_id_aa64pfr1_el1(struct kvm_vcpu *vcpu,
>   	return set_id_reg(vcpu, rd, user_val);
>   }
>   
> +/*
> + * Allow userspace to de-feature a stage-2 translation granule but prevent it
> + * from claiming the impossible.
> + */

super minor nit: May be we could call it "nv_tgran2_val_allowed()", to 
explicitly indicate this is for "NV" case.
Feel free to ignore.

> +#define tgran2_val_allowed(tg, safe, user)			\
> +({								\
> +	u8 __s = SYS_FIELD_GET(ID_AA64MMFR0_EL1, tg, safe);	\
> +	u8 __u = SYS_FIELD_GET(ID_AA64MMFR0_EL1, tg, user);	\
> +								\
> +	__s == __u || __u == ID_AA64MMFR0_EL1_##tg##_NI;	\
> +})
> +

Looks correct to me, we allow user to specify TGRANx_2_NI (== 0b01)
advertising lack of Stage2 support.

>   static int set_id_aa64mmfr0_el1(struct kvm_vcpu *vcpu,
>   				const struct sys_reg_desc *rd, u64 user_val)
>   {
>   	u64 sanitized_val = kvm_read_sanitised_id_reg(vcpu, rd);
> -	u64 tgran2_mask = ID_AA64MMFR0_EL1_TGRAN4_2_MASK |
> -			  ID_AA64MMFR0_EL1_TGRAN16_2_MASK |
> -			  ID_AA64MMFR0_EL1_TGRAN64_2_MASK;
>   
> -	if (vcpu_has_nv(vcpu) &&
> -	    ((sanitized_val & tgran2_mask) != (user_val & tgran2_mask)))
> +	if (!vcpu_has_nv(vcpu))
> +		return set_id_reg(vcpu, rd, user_val);
> +
> +	if (!tgran2_val_allowed(TGRAN4_2, sanitized_val, user_val) ||
> +	    !tgran2_val_allowed(TGRAN16_2, sanitized_val, user_val) ||
> +	    !tgran2_val_allowed(TGRAN64_2, sanitized_val, user_val))
>   		return -EINVAL;
>   
>   	return set_id_reg(vcpu, rd, user_val);

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
