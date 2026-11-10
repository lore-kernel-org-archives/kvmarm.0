Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794324045;
	b=vCNl1JTfcpi8wvVZWcPp4fPypiV763Ya9llQYAjKOjusM95p16UXUiByZgnCdsEaIOE9
	 w1vjoiqD1HCh5wXjMB5/HuaVl23mJTsB37j9Q+xWGb4TH1yqZm8o3DR3O//VxVSEXkXng
	 LvkVwL2tuaEMv6UTedyNx+Blik0Ot0dIZxrQOWIHXRpRFdGVsikgPSi2SJVcjpQ22Trk/
	 SsCsU0OLtbosr0aoaiB9V/N5byArCZMb4EtaLmPBUeX3CivR6K5Z7UcGQmBE4LMXPX6Vd
	 eVlmORZroE3gmAw1abzAKlBbCAo+p2CE6gFwXU/CYLo+5NzVlzQsEX2SqfuaFi3Acog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794324045;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=0MCfYrr79zOGeEI7k5EdiE7k95PTC3eYlw0lQQMx8r0=;
	b=OOXgtqceasC6AkBMt/o0uaNxfp0zTScAi4fNWUunE+Bb4gASmc/WNmYBH9mpzKRweNuE
	 qBrD3aX4KpSH72SQYod5ZZ8g9h7dhWSd9/9kKuXiuI3DWlURBUWyWunYkUKzU6Te60AmT
	 GzU/BftuFdiuu0y+nRcuQKDXe5J0nCXndmaxExSgRG6T8GDmdbMm1AAsSFbdIAKVvv1tu
	 0/bBqC+B8g/z/T+b16s33W25qIaVwY/Wsl6xp7JUNIy+nrdQpsciEV4jlXJKTGalCvcpL
	 aaH+wxrSK/1LPSsOBAVuVDSOlYYF+naJbV3lm07oouls+JOWqIH+TJ1Lv8hQOu/Yo7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=krYJs0BE;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E3AA606A31C
	for <kvmarm@lists.linux.dev>; Tue, 10 Nov 2026 15:20:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4E3AA606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=krYJs0BE
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 938DD1477;
	Tue, 10 Nov 2026 07:20:40 -0800 (PST)
Received: from [10.0.154.42] (e121487-lin.cambridge.arm.com [10.0.154.42])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 570413F85F;
	Tue, 10 Nov 2026 07:20:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794324043; bh=TtlirroHaVveeOl6KQyUR6geZC3vybNvJqT5iNcWsHc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=krYJs0BEpF0E7XiS/CnHNanFfVCDfC33yCpknfnJT3Ri9k+OBevBx9nmBHwxFequc
	 bSfKwd+HXGNjRZwkGss7t6eCDpxEsSKgU8wS+awOAsQmO1p9M71NgHz8Uy6sWneytZ
	 CrcLUbcSvyIeJk4HbvfZn9p/q+V2vJds8rjzgTSE=
Message-ID: <e802557f-c29e-4ecc-8285-da089cf68276@arm.com>
Date: Tue, 10 Nov 2026 15:20:40 +0000
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
Subject: Re: [PATCH kvmtool v4 10/23] arm64: Define GICv5 interrupt types
To: Sascha Bischoff <sascha.bischoff@arm.com>, will@kernel.org,
 julien.thierry.kdev@gmail.com
Cc: maz@kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 timothy.hayes@arm.com, Peter Maydell <peter.maydell@linaro.org>
References: <20261102213413.4136118-1-sascha.bischoff@arm.com>
 <20261102213413.4136118-11-sascha.bischoff@arm.com>
Content-Language: en-GB
From: Vladimir Murzin <vladimir.murzin@arm.com>
In-Reply-To: <20261102213413.4136118-11-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/2/26 21:34, Sascha Bischoff wrote:
> Define the PPI and SPI type values used by GICv5 interrupt specifiers,
> and the type-field shift used to construct a full GICv5 INTID for
> KVM's PMU IRQ attribute. Give the FDT type values distinct names while
> retaining the same numeric values.
> 
> Suggested-by: Vladimir Murzin <vladimir.murzin@arm.com>
> Tested-by: Vladimir Murzin <vladimir.murzin@arm.com>
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
> ---
>  arm64/gic.c             | 42 +++++++++++++++++++++++++++++++++++++----
>  arm64/include/kvm/gic.h |  9 +++++++++
>  2 files changed, 47 insertions(+), 4 deletions(-)
> 
> diff --git a/arm64/gic.c b/arm64/gic.c
> index 613813f6..a025464d 100644
> --- a/arm64/gic.c
> +++ b/arm64/gic.c
> @@ -24,6 +24,8 @@ static u64 gic_msi_size = 0;
>  static bool vgic_is_init = false;
>  static int gic_spi_base = GIC_SPI_IRQ_BASE;
>  static int gic_ppi_base = GIC_PPI_IRQ_BASE;
> +static int gic_spi_fdt_type = GIC_FDT_IRQ_TYPE_SPI;
> +static int gic_ppi_fdt_type = GIC_FDT_IRQ_TYPE_PPI;
>  
>  int gic__get_spi_base(void)
>  {
> @@ -35,6 +37,26 @@ int gic__get_ppi_base(void)
>  	return gic_ppi_base;
>  }
>  
> +int gic__get_spi_fdt_type(void)
> +{
> +	return gic_spi_fdt_type;
> +}
> +
> +int gic__get_ppi_fdt_type(void)
> +{
> +	return gic_ppi_fdt_type;
> +}
> +
> +int gic__encode_ppi_irq(enum irqchip_type type, int irq)
> +{
> +	switch (type) {
> +	case IRQCHIP_GICV5:
> +		return irq | (GICV5_IRQ_TYPE_PPI << GICV5_IRQ_TYPE_SHIFT);
> +	default:
> +		return irq;
> +	}
> +}
> +
>  struct kvm_irqfd_line {
>  	unsigned int		gsi;
>  	int			trigger_fd;
> @@ -241,18 +263,28 @@ static int gic__set_dist(enum irqchip_type type)
>  
>  static int gic__set_spi(enum irqchip_type type)
>  {
> +	int spi_base, fdt_type;
> +	int err;
> +
>  	switch (type) {
>  	case IRQCHIP_GICV5:
> -		gic_spi_base = GICV5_SPI_IRQ_BASE;
> +		spi_base = GICV5_SPI_IRQ_BASE;
> +		fdt_type = GICV5_FDT_IRQ_TYPE_SPI;
>  		break;
>  	default:
> -		gic_spi_base = GIC_SPI_IRQ_BASE;
> +		spi_base = GIC_SPI_IRQ_BASE;
> +		fdt_type = GIC_FDT_IRQ_TYPE_SPI;
>  		break;
>  	}
>  
> -	if (gic_spi_base == GICV5_SPI_IRQ_BASE)
> -		return irq__init_irq_offset(gic_spi_base);
> +	if (spi_base == GICV5_SPI_IRQ_BASE) {
> +		err = irq__init_irq_offset(spi_base);
> +		if (err)
> +			return err;
> +	}
>  
> +	gic_spi_base = spi_base;
> +	gic_spi_fdt_type = fdt_type;
>  	return 0;
>  }
>  
> @@ -261,9 +293,11 @@ static int gic__set_ppi(enum irqchip_type type)
>  	switch (type) {
>  	case IRQCHIP_GICV5:
>  		gic_ppi_base = GICV5_PPI_IRQ_BASE;
> +		gic_ppi_fdt_type = GICV5_FDT_IRQ_TYPE_PPI;
>  		break;
>  	default:
>  		gic_ppi_base = GIC_PPI_IRQ_BASE;
> +		gic_ppi_fdt_type = GIC_FDT_IRQ_TYPE_PPI;
>  		break;
>  	}
>  
> diff --git a/arm64/include/kvm/gic.h b/arm64/include/kvm/gic.h
> index c4f78cde..9f1a3a25 100644
> --- a/arm64/include/kvm/gic.h
> +++ b/arm64/include/kvm/gic.h
> @@ -12,6 +12,12 @@
>  #define GIC_FDT_IRQ_TYPE_SPI		0
>  #define GIC_FDT_IRQ_TYPE_PPI		1
>  
> +#define GICV5_IRQ_TYPE_PPI		1
> +#define GICV5_IRQ_TYPE_SPI		3
> +#define GICV5_IRQ_TYPE_SHIFT		29
> +#define GICV5_FDT_IRQ_TYPE_PPI		GICV5_IRQ_TYPE_PPI
> +#define GICV5_FDT_IRQ_TYPE_SPI		GICV5_IRQ_TYPE_SPI
> +
>  #define GIC_FDT_IRQ_PPI_CPU_SHIFT	8
>  #define GIC_FDT_IRQ_PPI_CPU_MASK	(0xff << GIC_FDT_IRQ_PPI_CPU_SHIFT)
>  
> @@ -38,6 +44,9 @@ struct kvm;
>  
>  int gic__get_spi_base(void);
>  int gic__get_ppi_base(void);
> +int gic__get_spi_fdt_type(void);
> +int gic__get_ppi_fdt_type(void);
> +int gic__encode_ppi_irq(enum irqchip_type type, int irq);
>  int gic__alloc_irqnum(void);
>  int gic__create(struct kvm *kvm, enum irqchip_type type);
>  int gic__create_gicv2m_frame(struct kvm *kvm, u64 msi_frame_addr);
> -- 2.34.1
> 

FWIW

Reviewed-by: Vladimir Murzin <vladimir.murzin@arm.com>

