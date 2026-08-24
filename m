Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 201D2417BCA
	for <kvmarm@lists.linux.dev>; Mon, 24 Aug 2026 12:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787574297; cv=none; b=FmcCTpoPE7ODbzvyYyeUvx3A36jxadMB6UHeXPCqremEnzMllgnzLxN/yO28Dqx+dZ9Gs2a0P6BOKcE7lEHkr8O6ISg2HbV4j5ezqUL5R3ge0KZjM48eQx4SoOuMcGjdjnMk1Jv6Hi3NQuFcT/bw42BVWyod3PKCYB/zOBIgQIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787574297; c=relaxed/simple;
	bh=y57nrII56IaKQCTkiVNkBmQs5pkbLltNP8lUNCbyO6U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S39zfIUtKGzefkAtS1znJAjKOUFOTmddZHhII3vmnWBfPo8bpjzgsazu0HF2mQ1FiJKnefbV0FUrvENWu/abPfS8qgW9wbkWPJgPTA2lTryJZ9bO9YTOXiigG5nO2T0gE4VovBGsmWOWG2KP/yvKqE8LSOwIbVw5C+TotwQD9E4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=jym1L6H9; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="jym1L6H9"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D1AF21570;
	Mon, 24 Aug 2026 05:24:48 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BCF303F85F;
	Mon, 24 Aug 2026 05:24:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787574292; bh=y57nrII56IaKQCTkiVNkBmQs5pkbLltNP8lUNCbyO6U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jym1L6H92LJ/ZEJ0f6m2PDeg5wOYnfGAe7lasGu2UlAEFzUhhpJ4ysD5Ged73UoCs
	 AYvCSuS7g1mUxW7/HmqK0QL62fCiICEFeVuQaaQKPDeKC/BMFOrAdDQPY7Ibc7CUpg
	 CNfIOWekQZ3G0R36KR+1NQ62WmegcqwE3HAhed30=
Date: Mon, 24 Aug 2026 13:24:47 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Mark Brown <broonie@kernel.org>, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v2] arm64: Defer the GMID_EL1 read to
 {init,update}_cpu_features()
Message-ID: <aow4D2g2nZNwN285@arm.com>
References: <20260824071004.504894-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260824071004.504894-1-fuad.tabba@linux.dev>

On Mon, Aug 24, 2026 at 08:10:04AM +0100, Fuad Tabba wrote:
> diff --git a/arch/arm64/kernel/cpuinfo.c b/arch/arm64/kernel/cpuinfo.c
> index d50e2a9b066b3..c8967f185e3dd 100644
> --- a/arch/arm64/kernel/cpuinfo.c
> +++ b/arch/arm64/kernel/cpuinfo.c
> @@ -502,12 +502,14 @@ static void __cpuinfo_store_cpu(struct cpuinfo_arm64 *info)
>  	info->reg_id_aa64smfr0 = read_cpuid(ID_AA64SMFR0_EL1);
>  	info->reg_id_aa64fpfr0 = read_cpuid(ID_AA64FPFR0_EL1);
>  
> -	if (id_aa64pfr1_mte(info->reg_id_aa64pfr1))
> -		info->reg_gmid = read_cpuid(GMID_EL1);
> -
>  	if (id_aa64pfr0_32bit_el0(info->reg_id_aa64pfr0))
>  		__cpuinfo_store_cpu_32bit(&info->aarch32);
>  
> +	/*
> +	 * info->reg_gmid deferred to {init,update}_cpu_features because
> +	 * reading it traps to EL2 when MTE is disabled.
> +	 */

The only nit I have is that cpu_data[0] now won't have the GMID_EL1 set.
It doesn't matter as we don't expose it via c_show() or sysfs, rather
for consistency. We have this inconsistency already with mpamidr.

I guess we just need to call init_cpu_features() on the per-CPU data
before the assignment to boot_cpu_data. Something like (untested):

diff --git a/arch/arm64/kernel/cpuinfo.c b/arch/arm64/kernel/cpuinfo.c
index d50e2a9b066b..d22f3514ab8b 100644
--- a/arch/arm64/kernel/cpuinfo.c
+++ b/arch/arm64/kernel/cpuinfo.c
@@ -538,7 +538,7 @@ void __init cpuinfo_store_boot_cpu(void)
 {
 	struct cpuinfo_arm64 *info = &per_cpu(cpu_data, 0);
 	__cpuinfo_store_cpu(info);
+	init_cpu_features(info);

 	boot_cpu_data = *info;
-	init_cpu_features(&boot_cpu_data);
 }

Either way:

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
