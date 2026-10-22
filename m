Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792693838;
	b=wEFHFRvntOLN58nVnsIRyAEocqDTNSKOeVy7atkJpYaATjjRsmcIcRtas3ogjsYjT4gk
	 gxldlmDZJ0+14j4fbsdxJoG28eU2g0URkiue9C+wuPJmsDp7xWaYdo9fTGgWRDzzoOO5z
	 Cs/ARneHTkKwbpJ22ZnGXu8/aLH1PrjvyXKEDGz511oaNekSHoiLthYhQdSZY2o3IhHGV
	 XrbLBNLFDiRXF+tyQbiu/oy/4gFh20GYy7wGh3zPS2sho9GeicqywLtYrHx7Ojw546VzI
	 idOOdxFo61dSizb1XCnD82gKmHQu8fcAGJQRDjwH/0wfDPPLsIsIyX9TGblKGqkLZZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792693838;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=wCxKDZRVKHU0nhyl1MyEQpBOlgr0Xb2zicSTlTbA3M8=;
	b=LU+yZIEd/H+rvPlUo98OhFxcOvNpodGGF0k2IP/6P6246XprBdj3/TncqXqUzWiF6FqB
	 /D5FBDJ7KW6UDsAyMMqTNgL9cMKAxaberdS57amJ08fem27e5B8aOFMxV4e0HKmAyhoo4
	 QAdLf/6kGXuz2Ds/5sUI9YN4bfinS4mAFVWZR09DXyY/lc8mmGNbBvA2mgvEyLvjpkvLa
	 TTuYqaHnw0097cIeCM7GgI/h51HtwGNgtqEHz3u3vID9fCqJZb2aNild8Ono+jLhAtFuC
	 3mZ/TrqG6lh5tCqmLlobPstJ2HMYeIbKqIlwfQVrNzmCnl+OJAkfGpJa6GpNKjVAnGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=qpfpTJfm;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DC85606A320
	for <kvmarm@lists.linux.dev>; Thu, 22 Oct 2026 18:30:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8DC85606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=qpfpTJfm
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9C8781692;
	Thu, 22 Oct 2026 11:30:33 -0700 (PDT)
Received: from [10.57.76.220] (unknown [10.57.76.220])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 36E2A3F7B4;
	Thu, 22 Oct 2026 11:30:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792693836; bh=Ikc6yOUiVYpFyLlT69Xm9dwfB1TIc31tika94aoKgGQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qpfpTJfm+FFdy7KQPHpm1vrm1zNwH9M7/wC3kvxasTdCiTaz80aE7clleHG8sfTdc
	 IaGro8DSjpe5Llt5yXL6Ghzf43dodRy3OeCh0YmqMrH9szAf0yY8xGCjbF4GTFVi/F
	 KXfApXOwSHz06gfy2oXffZWY7MxW5ncpopOtL5hk=
Message-ID: <5ad54e6b-8005-4487-95d8-3dc512d6b32c@arm.com>
Date: Thu, 22 Oct 2026 19:30:33 +0100
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
Subject: Re: [PATCH kvmtool v3 16/21] arm64: Expose the GICv5 irqchip option
To: Sascha Bischoff <sascha.bischoff@arm.com>, will@kernel.org,
 julien.thierry.kdev@gmail.com
Cc: maz@kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 timothy.hayes@arm.com, Peter Maydell <peter.maydell@linaro.org>
References: <20261016153939.913764-1-sascha.bischoff@arm.com>
 <20261016153939.913764-17-sascha.bischoff@arm.com>
Content-Language: en-GB
From: Vladimir Murzin <vladimir.murzin@arm.com>
In-Reply-To: <20261016153939.913764-17-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/16/26 16:39, Sascha Bischoff wrote:
> Allow --irqchip=gicv5 and prefer GICv5 for automatic irqchip selection
> when the kernel supports it. The IRS and guest DT support are now in
> place.
> 
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
> ---
>  arm64/gic.c                         | 4 +++-
>  arm64/include/kvm/kvm-config-arch.h | 2 +-
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arm64/gic.c b/arm64/gic.c
> index fe6c2059..02e55cd5 100644
> --- a/arm64/gic.c
> +++ b/arm64/gic.c
> @@ -50,6 +50,8 @@ int irqchip_parser(const struct option *opt, const char *arg, int unset)
>  		*type = IRQCHIP_GICV3;
>  	} else if (!strcmp(arg, "gicv3-its")) {
>  		*type = IRQCHIP_GICV3_ITS;
> +	} else if (!strcmp(arg, "gicv5")) {
> +		*type = IRQCHIP_GICV5;
>  	} else {
>  		pr_err("irqchip: unknown type \"%s\"\n", arg);
>  		return -1;
> @@ -293,7 +295,7 @@ int gic__create(struct kvm *kvm, enum irqchip_type type)
>  
>  	switch (type) {
>  	case IRQCHIP_AUTO:
> -		for (try = IRQCHIP_GICV3_ITS; try >= IRQCHIP_GICV2; try--) {
> +		for (try = IRQCHIP_GICV5; try >= IRQCHIP_GICV2; try--) {
>  			err = gic__create(kvm, try);
>  			if (!err)
>  				break;
> diff --git a/arm64/include/kvm/kvm-config-arch.h b/arm64/include/kvm/kvm-config-arch.h
> index d8a8ef7f..46130663 100644
> --- a/arm64/include/kvm/kvm-config-arch.h
> +++ b/arm64/include/kvm/kvm-config-arch.h
> @@ -59,7 +59,7 @@ int sve_vl_parser(const struct option *opt, const char *arg, int unset);
>  			   "transport (Deprecated: Use --virtio-transport "	\
>  			   "option instead)", virtio_transport_parser, kvm),	\
>  	OPT_CALLBACK('\0', "irqchip", &(cfg)->irqchip,				\
> -		     "[gicv2|gicv2m|gicv3|gicv3-its]",				\
> +		     "[gicv2|gicv2m|gicv3|gicv3-its|gicv5]",			\
>  		     "Type of interrupt controller to emulate in the guest",	\
>  		     irqchip_parser, NULL),					\
>  	OPT_U64('\0', "firmware-address", &(cfg)->fw_addr,			\
> -- 2.34.1
> 

FWIW,

Reviewed-by: Vladimir Murzin <vladimir.murzin@arm.com>
