Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794324086;
	b=Pe9Ea663rx7VrxdiNVhZZ7ASEowx1SrCmlnsjb1bqRyWl2th75GVo2Y6Lgs7eRUSVQxa
	 uru1iHV72pAY7FxrIMBfgmWJuNbdSJstic27Uqbv5jScACyGvcReX3U1xRhkfDZH+bC/h
	 VrCsxB/bL2wKngG040Ri9/4LWAL7Nh9AQw9e4HIJDmvi/wTn3AIuiqdYxTjkzQTsq5uwX
	 XWXZ/LfNGtyHxVDudAyK6+4henPffUTCyPxPWM4+bsSSFFVFKvtNwciSuIUTVP5hKM+Oj
	 C3ajdV2LRXvTCFj0C/U4vsY5CSV6fDUn4MVZMUoCgS1rnaxRzX3Sb69pXpbgnDi0HQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794324086;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=hw3mMkaHBb1Hs8aleFZk9IL4HtpNBpRV9dThh0ypXOc=;
	b=V5i3uGu5xu8SIn7iSKgUWfrd1OlKNkJu0blO/rgUhlirQLSiDFiDiTkIdISpVEoa/Hf9
	 5kPDqEUk2FyZZx18SfYRwxQREzj/bhNW4eu3QL3eor+fdBMK5G3EPbyFpBSBQZkI5FDex
	 vVq7VjIUKw6guWIvVNBLMhCmjR5SriqnhB1rfEZpm2NU3yr1LYPEJ5cAUTjFndn81nDng
	 gr7hcFhiYq30sFlGqJybsTxEFzBsHydWUqBcVtusXOBCZrHodb0m/sG6/AE+7olQda8Mc
	 zjPByPsGU4XpPv50h29o7S+pZW3qGOcflwp4rKvQ136Gt/xWC9RYFz7VH7ZVPAqJJaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=k2D2lm3z;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9369660A2609
	for <kvmarm@lists.linux.dev>; Tue, 10 Nov 2026 15:21:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9369660A2609
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=k2D2lm3z
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E9CB71477;
	Tue, 10 Nov 2026 07:21:21 -0800 (PST)
Received: from [10.0.154.42] (e121487-lin.cambridge.arm.com [10.0.154.42])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4FC733F85F;
	Tue, 10 Nov 2026 07:21:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794324085; bh=MKF0CHfCTJHhH1/HLOHNAs53sjHHKaSISnQX+4nBTcU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=k2D2lm3zTQnhWvxUvriVqmesaG7WBuTuBSopnKCDeZA2H7C97+VlnVM/3HT+GviEq
	 ZZeP15M0euXhdOLuLwXuoQp3cLUmCrlrfn4PIhFwD1JdGKyf0i9ISUR/piNXr63Vwd
	 o2JzEk1n5jOxAXJ8AD+qopqpYFCUNVDkwyxS7a80=
Message-ID: <0381792f-4d09-4cc3-bf84-b9a933eefbc9@arm.com>
Date: Tue, 10 Nov 2026 15:21:21 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH kvmtool v4 11/23] arm64: Describe the PMU interrupt for
 GICv5
To: Sascha Bischoff <sascha.bischoff@arm.com>, will@kernel.org,
 julien.thierry.kdev@gmail.com
Cc: maz@kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 timothy.hayes@arm.com, Peter Maydell <peter.maydell@linaro.org>
References: <20261102213413.4136118-1-sascha.bischoff@arm.com>
 <20261102213413.4136118-12-sascha.bischoff@arm.com>
Content-Language: en-GB
From: Vladimir Murzin <vladimir.murzin@arm.com>
In-Reply-To: <20261102213413.4136118-12-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/2/26 21:34, Sascha Bischoff wrote:
> Use the GICv5 PPI specifier in the DT. KVM also expects the PMU IRQ
> attribute to contain the GICv5 interrupt type in the upper bits, so
> encode it before setting KVM_ARM_VCPU_PMU_V3_IRQ.
> 
> Tested-by: Vladimir Murzin <vladimir.murzin@arm.com>
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
> ---
>  arm64/pmu.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/arm64/pmu.c b/arm64/pmu.c
> index ef7faca1..b3026d50 100644
> --- a/arm64/pmu.c
> +++ b/arm64/pmu.c
> @@ -214,16 +214,17 @@ static int find_pmu(struct kvm *kvm)
>  void pmu__generate_fdt_nodes(void *fdt, struct kvm *kvm)
>  {
>  	const char compatible[] = "arm,armv8-pmuv3";
> +	int irq = KVM_ARM_PMUv3_PPI;
> +	u32 irq_prop[3];
>  	u32 cpu_mask = gic__get_fdt_irq_cpumask(kvm);
> -	u32 irq_prop[] = {
> -		cpu_to_fdt32(GIC_FDT_IRQ_TYPE_PPI),
> -		cpu_to_fdt32(KVM_ARM_PMUv3_PPI - 16),
> -		cpu_to_fdt32(cpu_mask | IRQ_TYPE_LEVEL_HIGH),
> -	};
>  
>  	if (!kvm->cfg.arch.has_pmuv3)
>  		return;
>  
> +	irq_prop[0] = cpu_to_fdt32(gic__get_ppi_fdt_type());
> +	irq_prop[1] = cpu_to_fdt32(irq - gic__get_ppi_base());
> +	irq_prop[2] = cpu_to_fdt32(cpu_mask | IRQ_TYPE_LEVEL_HIGH);
> +
>  	_FDT(fdt_begin_node(fdt, "pmu"));
>  	_FDT(fdt_property(fdt, "compatible", compatible, sizeof(compatible)));
>  	_FDT(fdt_property(fdt, "interrupts", irq_prop, sizeof(irq_prop)));
> @@ -248,6 +249,8 @@ int pmu__init(struct kvm *kvm)
>  		}
>  	}
>  
> +	irq = gic__encode_ppi_irq(kvm->cfg.arch.irqchip, irq);
> +
>  	for (i = 0; i < kvm->nrcpus; i++) {
>  		vcpu = kvm->cpus[i];
>  		set_pmu_attr(vcpu, &irq, KVM_ARM_VCPU_PMU_V3_IRQ);
> -- 2.34.1
> 

FWIW

Reviewed-by: Vladimir Murzin <vladimir.murzin@arm.com>

