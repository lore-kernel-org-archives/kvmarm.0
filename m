Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1D572F25F1
	for <kvmarm@lists.linux.dev>; Mon, 10 Nov 2025 10:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762771227; cv=none; b=Cev+eajv5T/06C6a0MNKgfgTkIQARafr6GSnsmrAbLUQRVFW9pF7o7NiO0u19PktFzmLAwsRrptLN9043NMFDFHb7yDZu/vQ2KuaWaQoDuRvSiqRZHVBt8zXq8a2GtifNTMwJlshrAR1m3Y3Y+6KT+coz193n7SLwzbfGfTWps0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762771227; c=relaxed/simple;
	bh=8i2zPMoje5Db5aepFhq7c7rk3UWvoR7p+9rsDJZmqGM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B3Laj6DfAajrzfGsK+H1dqi/8edSL5hizmIZCcDqLL63kOszfwBVasTXL+oDVVtn1LsiRjgjyEe/hFhWjPPDi92fhN2ujF/Ib98nP54XeZaGygVB5hxVw+cj+7/ecAGklegTXFvVTLu+fVqd3TZeWJaknZxjV+Vdy1c5L1F/1lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 78DC8497;
	Mon, 10 Nov 2025 02:40:16 -0800 (PST)
Received: from [10.1.197.1] (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 03D223F66E;
	Mon, 10 Nov 2025 02:40:22 -0800 (PST)
Message-ID: <a914297b-753b-4fa0-8ffc-3a64b006316c@arm.com>
Date: Mon, 10 Nov 2025 10:40:21 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 04/45] KVM: arm64: Turn vgic-v3 errata traps into a
 patched-in constant
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>, Oliver Upton <oupton@kernel.org>,
 Zenghui Yu <yuzenghui@huawei.com>,
 Christoffer Dall <christoffer.dall@arm.com>,
 Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>,
 Yao Yuan <yaoyuan@linux.alibaba.com>
References: <20251109171619.1507205-1-maz@kernel.org>
 <20251109171619.1507205-5-maz@kernel.org>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20251109171619.1507205-5-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Marc,

On 09/11/2025 17:15, Marc Zyngier wrote:
> The trap bits are currently only set to manage CPU errata. However,
> we are about to make use of them for purposes beyond beating broken
> CPUs into submission.
> 
> For this purpose, turn these errata-driven bits into a patched-in
> constant that is merged with the KVM-driven value at the point of
> programming the ICH_HCR_EL2 register, rather than being directly
> stored with with the shadow value..
> 
> This allows the KVM code to distinguish between a trap being handled
> for the purpose of an erratum workaround, or for KVM's own need.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---

...

> diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
> index ac5f9c5d2b980..0ecadfa00397d 100644
> --- a/arch/arm64/kvm/vgic/vgic.h
> +++ b/arch/arm64/kvm/vgic/vgic.h
> @@ -164,6 +164,22 @@ static inline int vgic_write_guest_lock(struct kvm *kvm, gpa_t gpa,
>   	return ret;
>   }
>   
> +void kvm_compute_ich_hcr_trap_bits(struct alt_instr *alt,
> +				   __le32 *origptr, __le32 *updptr, int nr_inst);
> +
> +static inline u64 vgic_ich_hcr_trap_bits(void)
> +{
> +	u64 hcr;

minor nit: Do we need a guard to make sure this isn't called before the 
capabilities are finalized (given we may use it outside VM context, e.g. 
VGIC probe). perhaps :

WARN_ON(!system_capabilities_finalized());


> +
> +	/* All the traps are in the bottom 16bits */
> +	asm volatile(ALTERNATIVE_CB("movz %0, #0\n",
> +				    ARM64_ALWAYS_SYSTEM,
> +				    kvm_compute_ich_hcr_trap_bits)
> +		     : "=r" (hcr));


Suzuki
