Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794324301;
	b=DsHLvA5sU/WXYirkqf/dtZLCXNWrD4oqqp8OIqXSzcIUZK4BKGy6I2vZsNuaC0O0q7Mo
	 /ST8wrevAkUUzB5EBSRPmuT31kSfOANvzvHGKuXDcr/hj+lAH/IcVqdyp8YXsj1xVBHn0
	 Ti/yEFUYMElR4h7QuDENWRAiusrGqo+XeXbJPavT5l2ZNjLwiCiCkmBoX/kyeksDSnDhr
	 GWQBWZcbaPucAfT0N7blfse+nqOabq7GSisTbIdiiQXEUMs7vVc1Dl6xsgj7Lry8+P3oA
	 VuOB6T0Txn6i+mvgDrblhJjCYRL/7FwCgPdfjTg8kakmiPPGRBb0ajPA9bXpUU8n0+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794324301;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=VqU+KhhFreJ5IL2pGJlq8MsSOxgFZnI7RxYPryerqc4=;
	b=EZF2FPZAv2CyJ9D7DTbsnp2+TMlhYFDTSafY1Capt+1oU/yYTUUH0LP5qJDTYIYShY7N
	 bttJiCfqL/7ARogQLSf0BH3Gq7u4e4tW4S3/gG8XHGrHi/NmoPckzRfuaXY1sLNJz7f63
	 gPTu6W+A5FOnmKQVGSkmiHD6H9W27zzUQCoDqCin4s01SLgzy3x5JVgtyETZXEfMURK55
	 KXpSgLXZPOam1bMEGSwAnC/kHCjTHUoMylNXnyTvr8AtJc2Dlxcf03MqldtqLMKalLfI0
	 1i9kKKeGVo/RTAGvxav9dCKrjm+oLLeReLmvXhZpWINtVpuLDYqSqANP6fiCnErhnzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=IFf+ZoEC;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BBBC606A325
	for <kvmarm@lists.linux.dev>; Tue, 10 Nov 2026 15:25:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6BBBC606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=IFf+ZoEC
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BFBFA1477;
	Tue, 10 Nov 2026 07:24:56 -0800 (PST)
Received: from [10.0.154.42] (e121487-lin.cambridge.arm.com [10.0.154.42])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 165433F85F;
	Tue, 10 Nov 2026 07:24:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794324299; bh=yh5KijqevR2nrRKL5+1t6nzLUiW/tT40yM81ClYr06c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=IFf+ZoEC0pqfFP2iOls2KIOCd85kRR6MxLuBMGap3G/lOx96ouEu/zxhkw9iP3vhm
	 nDZjzTfUMdHcKckMFbGzXhnmCUch6VCobplZVZzF2iOorpowWD76JWTGP3JCJR0jJd
	 cBPN8nhbrQcUf5VEJVeGLV/f6qvHQGo3tuB6B2xI=
Message-ID: <19db29e9-ef49-44c0-a42b-e9da5c7a54b4@arm.com>
Date: Tue, 10 Nov 2026 15:24:55 +0000
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
Subject: Re: [PATCH kvmtool v4 13/23] arm64: Assign CPU DT phandles
To: Sascha Bischoff <sascha.bischoff@arm.com>, will@kernel.org,
 julien.thierry.kdev@gmail.com
Cc: maz@kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 timothy.hayes@arm.com, Peter Maydell <peter.maydell@linaro.org>
References: <20261102213413.4136118-1-sascha.bischoff@arm.com>
 <20261102213413.4136118-14-sascha.bischoff@arm.com>
Content-Language: en-GB
From: Vladimir Murzin <vladimir.murzin@arm.com>
In-Reply-To: <20261102213413.4136118-14-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/2/26 21:34, Sascha Bischoff wrote:
> Assign stable phandles to all arm64 CPU nodes. The GICv5 IRS DT node
> uses them to map IAFFIDs to CPUs; they remain unreferenced for earlier
> GIC models.
> 

Who knows maybe one day we would need them for anything other than GIC :)

> Tested-by: Vladimir Murzin <vladimir.murzin@arm.com>
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
> ---
>  arm64/fdt.c                  | 1 +
>  arm64/include/kvm/fdt-arch.h | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/arm64/fdt.c b/arm64/fdt.c
> index 3cbd36e2..5413956d 100644
> --- a/arm64/fdt.c
> +++ b/arm64/fdt.c
> @@ -54,6 +54,7 @@ static void generate_cpu_nodes(void *fdt, struct kvm *kvm)
>  			_FDT(fdt_property_string(fdt, "enable-method", "psci"));
>  
>  		_FDT(fdt_property_cell(fdt, "reg", mpidr));
> +		_FDT(fdt_property_cell(fdt, "phandle", PHANDLE_CPU_BASE + cpu));
>  		_FDT(fdt_end_node(fdt));
>  	}
>  
> diff --git a/arm64/include/kvm/fdt-arch.h b/arm64/include/kvm/fdt-arch.h
> index 8a0a460e..2b667c53 100644
> --- a/arm64/include/kvm/fdt-arch.h
> +++ b/arm64/include/kvm/fdt-arch.h
> @@ -11,4 +11,5 @@ enum phandles {
>  
>  void generate_dma_region_prop(void *fdt);
>  
> +#define PHANDLE_CPU_BASE PHANDLES_MAX
>  #endif /* ARM__FDT_H */
> -- 2.34.1
> 

FWIW,

Reviewed-by: Vladimir Murzin <vladimir.murzin@arm.com>

