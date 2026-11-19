Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795085011;
	b=JO8+/ANRyxRYGfXRWmaFAFu5NhRco58eg3YQK8OnnON0Aml4/tamQblgvfaWC8p3kZez
	 UVM7XIitv1KtjIsesQskB/VaApWIhADVBJNBnAHkebht3MrMisnePH81gKGnLvbdYf9f6
	 /rZzk9GVmK0Jun+MY24kpcRgbxzvk3wPrhPLXG7sMkZHVT86DRLPyDAqZ0WAC6BxVUSu8
	 AmtqctgRMQtzp1JC9aG2iTsJciH2UlERU7EsdawSQ/LKnXTPp9NuTU6JuIMRNUwqkYEZ2
	 qGQzZrJbAJRJwGZigkDBKPKIhhK7NVcjDHOV//zHTY5hjCZrvftsoHffYr1S4V9+v5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795085011;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=vJKXxfdGCv+61w/aHQxKpufdz3oBLb6/8bJF+wXFtek=;
	b=oymesShKPGC/1Rzo+MliDZFTHZzKj7c+HHNZBE7zrt4UK1Zt1FFSADm4nYP8NNEdhbTV
	 Cy6ihsjYVEaieQL0RCAYR+8xk0Ly58GR3IamdHcLMA461AimjEz1kubfvp1Q/bqcxXLjL
	 QL2zyzVgZIvAnyoQimhgEDZLL96+V+8vHrNyRglsWqhepWoXJTejkKkQGlhUT1mEkMPUV
	 aoA/EJaaf6M0RYbQx6ef9WujcrueXCkv0tXVoMr+E5XOY4rqNOKv54p47a8YLoLNEg8Le
	 XrfrNzsT2ZKrh/f0uyZMnIrUevg0oNbGuoZ1JTHRYV6YggIgwPhsV+QabMLLSFLoAyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Ene0Ho72;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94900606A32A
	for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 10:43:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 94900606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Ene0Ho72
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EB5421575;
	Thu, 19 Nov 2026 02:43:26 -0800 (PST)
Received: from [10.0.154.42] (e121487-lin.cambridge.arm.com [10.0.154.42])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 207503F632;
	Thu, 19 Nov 2026 02:43:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795085009; bh=M21UZJyP9+AnwX4YTlB02md3WrtwshYZO/zb5ElQivE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Ene0Ho72kp0RATv46ILCov4k9hcuarmkOfaPurGM4w/6l/Y6aJHslTK4RpLiJp/lE
	 T/hxEiGr8xTmaeKk5W/tJUJkE3jI99INFdON3wp+hRjqSjMf5TthY53QNzYz5LnOzu
	 mb+vo+2tuZ3vYmIeuNCmYM6NDY/Bh0wGTgO9a/4I=
Message-ID: <6b61fcb7-e9ee-4f25-9484-5bf7e000f148@arm.com>
Date: Thu, 19 Nov 2026 10:43:25 +0000
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
Subject: Re: [PATCH kvmtool v5 15/23] arm64: Describe the GICv5 IRS in the DT
To: Sascha Bischoff <sascha.bischoff@arm.com>, will@kernel.org,
 julien.thierry.kdev@gmail.com
Cc: maz@kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 timothy.hayes@arm.com, Peter Maydell <peter.maydell@linaro.org>
References: <20261118175755.1946977-1-sascha.bischoff@arm.com>
 <20261118175755.1946977-16-sascha.bischoff@arm.com>
Content-Language: en-GB
From: Vladimir Murzin <vladimir.murzin@arm.com>
In-Reply-To: <20261118175755.1946977-16-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/18/26 17:57, Sascha Bischoff wrote:
> Describe the IRS CONFIG and SETLPI frames and associate each CPU
> phandle with its IAFFID. This lets the guest discover and configure
> the IRS for shared interrupts.
> 
> Tested-by: Vladimir Murzin <vladimir.murzin@arm.com>
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
> ---
>  arm64/gic.c | 35 +++++++++++++++++++++++++++++++++++
>  1 file changed, 35 insertions(+)
> 
> diff --git a/arm64/gic.c b/arm64/gic.c
> index 9a8f9916..e5a26252 100644
> --- a/arm64/gic.c
> +++ b/arm64/gic.c
> @@ -588,6 +588,16 @@ void gic__generate_fdt_nodes(void *fdt, struct kvm *kvm)
>  
>  static void gic__generate_gicv5_fdt_nodes(void *fdt, struct kvm *kvm)
>  {
> +	char node_at_addr[64];
> +	u32 cpus[kvm->nrcpus];
> +	u16 iaffids[kvm->nrcpus];
> +	u64 irs_reg_prop[] = {
> +		cpu_to_fdt64(ARM_GICV5_IRS_CONFIG_BASE),
> +		cpu_to_fdt64(ARM_GICV5_IRS_CONFIG_SIZE),
> +		cpu_to_fdt64(ARM_GICV5_IRS_SETLPI_BASE),
> +		cpu_to_fdt64(ARM_GICV5_IRS_SETLPI_SIZE)
> +	};
> +
>  	_FDT(fdt_begin_node(fdt, "gicv5-cpuif"));
>  	_FDT(fdt_property_string(fdt, "compatible", "arm,gic-v5"));
>  	_FDT(fdt_property_cell(fdt, "#interrupt-cells", GIC_FDT_IRQ_NUM_CELLS));
> @@ -599,6 +609,31 @@ static void gic__generate_gicv5_fdt_nodes(void *fdt, struct kvm *kvm)
>  	/* Use a hard-coded phandle for the GIC to help wire things up */
>  	_FDT(fdt_property_cell(fdt, "phandle", PHANDLE_GIC));
>  
> +	/*
> +	 * GICv5 IRS node
> +	 */
> +	snprintf(node_at_addr, sizeof(node_at_addr), "irs@%llx",
> +		 (unsigned long long)ARM_GICV5_IRS_CONFIG_BASE);
> +	_FDT(fdt_begin_node(fdt, node_at_addr));
> +	_FDT(fdt_property_string(fdt, "compatible", "arm,gic-v5-irs"));
> +	_FDT(fdt_property_cell(fdt, "#address-cells", 2));
> +	_FDT(fdt_property_cell(fdt, "#size-cells", 2));
> +	_FDT(fdt_property(fdt, "ranges", NULL, 0));
> +
> +	_FDT(fdt_property(fdt, "reg", irs_reg_prop, sizeof(irs_reg_prop)));
> +	_FDT(fdt_property(fdt, "reg-names", "ns-config\0ns-setlpi",
> +			  sizeof("ns-config\0ns-setlpi")));
> +
> +	for (int cpu = 0; cpu < kvm->nrcpus; cpu++) {
> +		cpus[cpu] = cpu_to_fdt32(PHANDLE_CPU_BASE + cpu);
> +		iaffids[cpu] = cpu_to_fdt16(cpu);
> +	}
> +
> +	_FDT(fdt_property(fdt, "cpus", cpus, sizeof(u32) * kvm->nrcpus));
> +	_FDT(fdt_property(fdt, "arm,iaffids", iaffids, sizeof(u16) * kvm->nrcpus));
> +
> +	_FDT(fdt_end_node(fdt));
> +
>  	_FDT(fdt_end_node(fdt));
>  }
>  
> -- 2.34.1
> 

With SETLPI dropped form DT (and commit message) as agreed [1], feel free to add

Reviewed-by: Vladimir Murzin <vladimir.murzin@arm.com>

[1] https://lore.kernel.org/kvmarm/d0e948c8-0d25-4207-bc04-01bc2bb6b7ec@arm.com/T/#m0dd67277b59609783e294e30cc681ee1a97a966a
