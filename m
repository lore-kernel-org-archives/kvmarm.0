Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794495018;
	b=kVfqbl3jf9Z79Z7TF+aM1XbY/8owuMfA/xfYOTbGYiKT99cmu9rXWGAC98pTDrFR1F4h
	 yZi/doxDkzJS7P2p15KqinZCAl91N6IbtTAgX7nclw66cveCfOI/CuyCx3dvJbouufbWK
	 kwj2hBAYQdIJrepNG2SUi+aPXf5NM5s8ZmVytxVgZp19Gi00VCVvolzjOKG8KsQ0cAhmy
	 yQdTx66D8NmzTCThfisGhGumHpm4JgGIPIW34uM39LgEoywapVF7T6pKcwVdswnZeK1jX
	 6hXZHPE3d7eAP0iyBNOzxgai2rfPPrjNSNWKXnJ928sm3JmUTvGjP6ziajiMeCLLEfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794495018;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=9A2jow7JRlptqCTEzg0jkw5u5ky6w2/LLBX62c+exTc=;
	b=CZSi5c6D7SVSG4hoKDPCI5BjI2gpsuE0H5nw7tUzF/gbh1L97izTDXfL1WvU2OEDkKnf
	 xj63oW97sm65jPT438tlmzOTVGu1RFyeqHvUCrFqCrT6UhnDt2ZrSceXBp95IUVTdpkU4
	 vZSejwtu/rV/VwVtspG48wGVHpyqsP9J9KkL+Qdk9dfVk3tnXDPWddX6LAklhooRd3tep
	 68C4JGVeHr7G93hibrIlGfn7mEgzZNSABOINfWdmkHlrui+bJvxKpnNUACkdxjQwVtRkQ
	 ej5rfZl3N3YXMwV1P71LliTC2oN6grGfHiyasoPsWBJXqbffEFy8fOR1Do+3LNN9j6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b="VDj/KxF3";
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09DE6606A31C
	for <kvmarm@lists.linux.dev>; Thu, 12 Nov 2026 14:50:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 09DE6606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=VDj/KxF3
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 447C31516;
	Thu, 12 Nov 2026 06:50:14 -0800 (PST)
Received: from [10.0.154.42] (e121487-lin.cambridge.arm.com [10.0.154.42])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0F2FA3F673;
	Thu, 12 Nov 2026 06:50:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794495017; bh=UkEVO6b2IdtK1EQstNMRtPhMcvSj6PEpb26mZ/3yqrI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=VDj/KxF3lZEycISfL20ixB75nykJEFJuP5ip9dZ7pplt82yTWJSAfsSoVBdPM2MSD
	 6lPMVOWBvKSt8GEJ4wAZ/W0TQt6VohwjbQr/DXHeQLCl1c54aj4ujidynhh/t2v+n/
	 7XC4+xloFr2XHubi1yvfG5i5EjlRPe9SjXBHr6JY=
Message-ID: <295c2f27-c45b-4bbd-b26d-b81a5dd5ef0d@arm.com>
Date: Thu, 12 Nov 2026 14:50:14 +0000
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
Subject: Re: [PATCH kvmtool v4 20/23] arm64: Add GICv5 ITS device support
To: Sascha Bischoff <sascha.bischoff@arm.com>, will@kernel.org,
 julien.thierry.kdev@gmail.com
Cc: maz@kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 timothy.hayes@arm.com, Peter Maydell <peter.maydell@linaro.org>
References: <20261102213413.4136118-1-sascha.bischoff@arm.com>
 <20261102213413.4136118-21-sascha.bischoff@arm.com>
Content-Language: en-GB
From: Vladimir Murzin <vladimir.murzin@arm.com>
In-Reply-To: <20261102213413.4136118-21-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/2/26 21:34, Sascha Bischoff wrote:
> Allow the GICv5 ITS irqchip to create a separate KVM ITS device and
> place its CONFIG and TRANSLATE frames immediately below the IRS.
> Reuse the ITS creation helper for GICv3 and GICv5, selecting the
> device and address types for each model.
> 
> At this stage, --irqchip=gicv5-its is not yet exposed, and automatic
> irqchip selection starts with GICv5.
> 
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
> ---
>  arm64/gic.c                  | 25 +++++++++++++++++++------
>  arm64/include/kvm/gic.h      |  1 +
>  arm64/include/kvm/kvm-arch.h |  8 ++++++++
>  3 files changed, 28 insertions(+), 6 deletions(-)
> 
> diff --git a/arm64/gic.c b/arm64/gic.c
> index 6abd7d44..fca99aef 100644
> --- a/arm64/gic.c
> +++ b/arm64/gic.c
> @@ -51,6 +51,7 @@ int gic__encode_ppi_irq(enum irqchip_type type, int irq)
>  {
>  	switch (type) {
>  	case IRQCHIP_GICV5:
> +	case IRQCHIP_GICV5_ITS:
>  		return irq | (GICV5_IRQ_TYPE_PPI << GICV5_IRQ_TYPE_SHIFT);
>  	default:
>  		return irq;
> @@ -136,15 +137,15 @@ static int irq__routing_init(struct kvm *kvm)
>  	return 0;
>  }
>  
> -static int gic__create_its_frame(struct kvm *kvm, u64 its_frame_addr)
> +static int gic__create_its_frame(struct kvm *kvm, u64 its_frame_addr, const bool v5)
>  {
>  	struct kvm_create_device its_device = {
> -		.type = KVM_DEV_TYPE_ARM_VGIC_ITS,
> +		.type = v5 ? KVM_DEV_TYPE_ARM_VGIC_V5_ITS : KVM_DEV_TYPE_ARM_VGIC_ITS,
>  		.flags	= 0,
>  	};
>  	struct kvm_device_attr its_attr = {
>  		.group	= KVM_DEV_ARM_VGIC_GRP_ADDR,
> -		.attr	= KVM_VGIC_ITS_ADDR_TYPE,
> +		.attr	= v5 ? KVM_VGIC_V5_ADDR_TYPE_ITS : KVM_VGIC_ITS_ADDR_TYPE,
>  		.addr	= (u64)(unsigned long)&its_frame_addr,
>  	};
>  	struct kvm_device_attr its_init_attr = {
> @@ -155,8 +156,9 @@ static int gic__create_its_frame(struct kvm *kvm, u64 its_frame_addr)
>  
>  	err = ioctl(kvm->vm_fd, KVM_CREATE_DEVICE, &its_device);
>  	if (err) {
> -		pr_err("GICv3 ITS requested, but kernel does not support it.");
> -		pr_err("Try --irqchip=gicv3 instead");
> +		pr_err("GICv%c ITS requested, but kernel does not support it.",
> +			v5 ? '5' : '3');
> +		pr_err("Try --irqchip=gicv%c instead", v5 ? '5' : '3');
>  		return err;
>  	}
>  
> @@ -185,7 +187,9 @@ static int gic__create_msi_frame(struct kvm *kvm, enum irqchip_type type)
>  	case IRQCHIP_GICV2M:
>  		return gic__create_gicv2m_frame(kvm, gic_msi_base);
>  	case IRQCHIP_GICV3_ITS:
> -		return gic__create_its_frame(kvm, gic_msi_base);
> +		return gic__create_its_frame(kvm, gic_msi_base, false);
> +	case IRQCHIP_GICV5_ITS:
> +		return gic__create_its_frame(kvm, gic_msi_base, true);
>  	default:	/* No MSI frame needed */
>  		return 0;
>  	}
> @@ -235,6 +239,7 @@ static int gic__set_irs(enum irqchip_type type)
>  
>  	switch (type) {
>  	case IRQCHIP_GICV5:
> +	case IRQCHIP_GICV5_ITS:
>  		return ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &irs_attr);
>  	default:	/* No IRS needed */
>  		return 0;
> @@ -270,6 +275,7 @@ static int gic__set_spi(enum irqchip_type type)
>  
>  	switch (type) {
>  	case IRQCHIP_GICV5:
> +	case IRQCHIP_GICV5_ITS:
>  		spi_base = GICV5_SPI_IRQ_BASE;
>  		fdt_type = GICV5_FDT_IRQ_TYPE_SPI;
>  		break;
> @@ -294,6 +300,7 @@ static int gic__set_ppi(enum irqchip_type type)
>  {
>  	switch (type) {
>  	case IRQCHIP_GICV5:
> +	case IRQCHIP_GICV5_ITS:
>  		gic_ppi_base = GICV5_PPI_IRQ_BASE;
>  		gic_ppi_fdt_type = GICV5_FDT_IRQ_TYPE_PPI;
>  		break;
> @@ -322,6 +329,7 @@ static int gic__create_device(struct kvm *kvm, enum irqchip_type type)
>  	case IRQCHIP_GICV3_ITS:
>  		gic_device.type = KVM_DEV_TYPE_ARM_VGIC_V3;
>  		break;
> +	case IRQCHIP_GICV5_ITS:
>  	case IRQCHIP_GICV5:
>  		gic_device.type = KVM_DEV_TYPE_ARM_VGIC_V5;
>  		break;
> @@ -431,6 +439,11 @@ int gic__create(struct kvm *kvm, enum irqchip_type type)
>  		gic_redists_base = ARM_GIC_DIST_BASE - gic_redists_size;
>  		gic_msi_base = gic_redists_base - gic_msi_size;
>  		break;
> +	case IRQCHIP_GICV5_ITS:
> +		gic_msi_base = ARM_GICV5_ITS_BASE;
> +		gic_msi_size = ARM_GICV5_ITS_SIZE;
> +		gicv5_irs_base = ARM_GICV5_IRS_BASE;
> +		break;

Nitpick: can it fall through into IRQCHIP_GICV5 similarly to IRQCHIP_GICV3_ITS?

>  	case IRQCHIP_GICV5:
>  		gicv5_irs_base = ARM_GICV5_IRS_BASE;
>  		break;
> diff --git a/arm64/include/kvm/gic.h b/arm64/include/kvm/gic.h
> index 9f1a3a25..0a5c70a1 100644
> --- a/arm64/include/kvm/gic.h
> +++ b/arm64/include/kvm/gic.h
> @@ -38,6 +38,7 @@ enum irqchip_type {
>  	IRQCHIP_GICV3,
>  	IRQCHIP_GICV3_ITS,
>  	IRQCHIP_GICV5,
> +	IRQCHIP_GICV5_ITS,
>  };
>  
>  struct kvm;
> diff --git a/arm64/include/kvm/kvm-arch.h b/arm64/include/kvm/kvm-arch.h
> index 94140364..3b0ffead 100644
> --- a/arm64/include/kvm/kvm-arch.h
> +++ b/arm64/include/kvm/kvm-arch.h
> @@ -65,6 +65,14 @@
>  #define ARM_GICV5_IRS_SETLPI_BASE	(ARM_GICV5_IRS_CONFIG_BASE + ARM_GICV5_IRS_CONFIG_SIZE)
>  #define ARM_GICV5_IRS_SETLPI_SIZE	0x10000
>  
> +/* GICv5 ITS CONFIG and TRANSLATE frames precede the IRS frames. */
> +#define ARM_GICV5_ITS_BASE		(ARM_GICV5_IRS_BASE - ARM_GICV5_ITS_SIZE)
> +#define ARM_GICV5_ITS_SIZE		(ARM_GICV5_ITS_CONFIG_SIZE + ARM_GICV5_ITS_TRANSL_SIZE)
> +#define ARM_GICV5_ITS_CONFIG_BASE	ARM_GICV5_ITS_BASE
> +#define ARM_GICV5_ITS_CONFIG_SIZE	0x10000
> +#define ARM_GICV5_ITS_TRANSL_BASE	(ARM_GICV5_ITS_CONFIG_BASE + ARM_GICV5_ITS_CONFIG_SIZE)
> +#define ARM_GICV5_ITS_TRANSL_SIZE	0x10000
> +
>  #define KVM_PCI_CFG_AREA	ARM_AXI_AREA
>  #define ARM_PCI_CFG_SIZE	(1ULL << 28)
>  #define KVM_PCI_MMIO_AREA	(KVM_PCI_CFG_AREA + ARM_PCI_CFG_SIZE)
> -- 2.34.1
> 

Looks pretty neat! Thanks!

Vladimir
