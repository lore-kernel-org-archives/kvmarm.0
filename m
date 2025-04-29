Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 218382135DD
	for <kvmarm@lists.linux.dev>; Tue, 29 Apr 2025 13:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745932112; cv=none; b=GoSdaFzsCIH9GDdjqI3Q3QF2g1y5l73udnM+1DlwnpYskjPQYmVUwS0/IlEaRW+8PPDQvyGoERMNH8CIAAXJYobsDzpKIR4uPm91oNShrSgu26vSaJevZI99dy00NDYj9kS5AxwNtH2aNE447qhzaC+uaHRG3CQRlSXmkFkGCUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745932112; c=relaxed/simple;
	bh=RyHJYSAknC2j+Gkhd1jaB8jQXcBXIs9wn7vfHEgFMzs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WIi21GwAO6KY2boYN5Z+tYMmIwMubMCu3DFkPDPsTnc7yLVAwEqc+9HaC4eIbd9mVkB82nGr7Eo1sOr9IjlugvsAyWdF1zWTpQmmS4Sip9rojZl8mCK/agjUiwCGBJx1hzCg2tXAHUTyAz9yHmgxKGEzIUF82hoi4nCRiLEnbvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D392A1515;
	Tue, 29 Apr 2025 06:08:23 -0700 (PDT)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DEA503F673;
	Tue, 29 Apr 2025 06:08:28 -0700 (PDT)
Message-ID: <363383a2-c05e-458c-82b7-acc6e5d73939@arm.com>
Date: Tue, 29 Apr 2025 14:08:27 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 24/42] KVM: arm64: Unconditionally configure fine-grain
 traps
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>,
 Fuad Tabba <tabba@google.com>, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>
References: <20250426122836.3341523-1-maz@kernel.org>
 <20250426122836.3341523-25-maz@kernel.org>
Content-Language: en-US
From: Ben Horgan <ben.horgan@arm.com>
In-Reply-To: <20250426122836.3341523-25-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Marc,

On 4/26/25 13:28, Marc Zyngier wrote:
> From: Mark Rutland <mark.rutland@arm.com>
> 
> ... otherwise we can inherit the host configuration if this differs from
> the KVM configuration.
> 
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> [maz: simplified a couple of things]
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>   arch/arm64/kvm/hyp/include/hyp/switch.h | 39 ++++++++++---------------
>   1 file changed, 15 insertions(+), 24 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index 027d05f308f75..925a3288bd5be 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -107,7 +107,8 @@ static inline void __activate_traps_fpsimd32(struct kvm_vcpu *vcpu)
>   
> [...]
>   
>   static inline void __deactivate_traps_hfgxtr(struct kvm_vcpu *vcpu)
>   {
>   	struct kvm_cpu_context *hctxt = host_data_ptr(host_ctxt);
> -	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
>   
>   	if (!cpus_have_final_cap(ARM64_HAS_FGT))
>   		return;
>   
> -	__deactivate_fgt(hctxt, vcpu, kvm, HFGRTR_EL2);
> -	if (cpus_have_final_cap(ARM64_WORKAROUND_AMPERE_AC03_CPU_38))
Don't we need to continue considering the ampere errata here? Or, at 
least worth a mention in the commit message.
> -		write_sysreg_s(ctxt_sys_reg(hctxt, HFGWTR_EL2), SYS_HFGWTR_EL2);
> -	else
> -		__deactivate_fgt(hctxt, vcpu, kvm, HFGWTR_EL2);
> -	__deactivate_fgt(hctxt, vcpu, kvm, HFGITR_EL2);
> -	__deactivate_fgt(hctxt, vcpu, kvm, HDFGRTR_EL2);
> -	__deactivate_fgt(hctxt, vcpu, kvm, HDFGWTR_EL2);
> +	__deactivate_fgt(hctxt, vcpu, HFGRTR_EL2);
> +	__deactivate_fgt(hctxt, vcpu, HFGWTR_EL2);
> +	__deactivate_fgt(hctxt, vcpu, HFGITR_EL2);
> +	__deactivate_fgt(hctxt, vcpu, HDFGRTR_EL2);
> +	__deactivate_fgt(hctxt, vcpu, HDFGWTR_EL2);
>   
>   	if (cpu_has_amu())
> -		__deactivate_fgt(hctxt, vcpu, kvm, HAFGRTR_EL2);
> +		__deactivate_fgt(hctxt, vcpu, HAFGRTR_EL2);
>   }
>   
>   static inline void  __activate_traps_mpam(struct kvm_vcpu *vcpu)


Thanks,

Ben

