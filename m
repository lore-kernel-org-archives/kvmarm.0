Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794323022;
	b=Fge9o24/+AOGKjPjfUVewxK54XvbJHQhAUKKJCyCbvvOsmbV07zw0v0ju8qv8KCMWsfZ
	 ZRCZ3CEH3Xl76eil+vKX38ArW24QTzqti1squGzKt3Gthj+ETKGiPSUWxunOCoxWyv9SA
	 RsEl1cP3y479FimrCelpsoTED+z/axUewHljL79Q0vU96S7l6X87o1plLZ5IvJy+x6g1z
	 nwf9oJVUV4RkAka/JCN5ccSI+lSZAoBqFgbVS4OtY89U0tIMBtOYp65pH1aCEzWeIvTaB
	 XbRD2Fzm2NkHoOmxhZoqer6oODqZShG2k+OUF7SK4Wnv8CDgHHzBsfI9PAjxXq2K01g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794323022;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=AMHbmw6AVtBrgvvIHxlDgD7+QXqZ2+qmHiJeu2jXxSY=;
	b=Ly7bu9kg8uzRhcepRm95TczzS/jpkMsHAEO/KagoDeTtlk/9FHbisLFcLvrvZ1uG3CGD
	 TTpU0zF+O3lPWXoMCSpiGkPXAdh09+Bqb6g8D91GY7gqnXFVFexXEngIxO2Xzj0lBkPqs
	 m1rznTqr8LizkCSd+DIBLUY/4anpWUEFn3+JQavTqK3F91tQ7fFyJGkARBAkKkokG6ST/
	 ofQ00/mcuIp2dZIxsRTJw7cgY6SHse4KK4q2OzVPkRuuS582awUZt0b0lJBttjs0dLI96
	 zRIFta5AmprbgJxaBMdDvZSMPq/NfZ4KOUMVnats8+qAONKahR3MM1UqyVk8DIFh3bg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=BDXHlq7q;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C83760A6F6E
	for <kvmarm@lists.linux.dev>; Tue, 10 Nov 2026 15:03:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4C83760A6F6E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=BDXHlq7q
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AE1241477;
	Tue, 10 Nov 2026 07:03:37 -0800 (PST)
Received: from [10.0.154.42] (e121487-lin.cambridge.arm.com [10.0.154.42])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E02513F85F;
	Tue, 10 Nov 2026 07:03:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794323020; bh=+CQQvJipOP4J7j27DlWXVN4Zz15AKszvwAXw7sWPqqg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BDXHlq7qHdvVgaQ+ZYR6KGBROFyuL2TyBQrmoKdgJlTeP0i7eK/iLWAM2u1/aPBag
	 LbKPKIvrlwQa5RRvqTVytxn+T1nLmidWPm3TyDP+jXHyV9vNGDmCqSkLrlzWpc4b6x
	 s707A2RQDdfvks31yuTOBwqUr+Gd6ZU6Bikjmhw0=
Message-ID: <29794754-0152-4820-b457-33aea6a8cda2@arm.com>
Date: Tue, 10 Nov 2026 15:03:36 +0000
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
Subject: Re: [PATCH kvmtool v4 06/23] arm64: Configure GIC interrupt bases
To: Sascha Bischoff <sascha.bischoff@arm.com>, will@kernel.org,
 julien.thierry.kdev@gmail.com
Cc: maz@kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 timothy.hayes@arm.com, Peter Maydell <peter.maydell@linaro.org>
References: <20261102213413.4136118-1-sascha.bischoff@arm.com>
 <20261102213413.4136118-7-sascha.bischoff@arm.com>
Content-Language: en-GB
From: Vladimir Murzin <vladimir.murzin@arm.com>
In-Reply-To: <20261102213413.4136118-7-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/2/26 21:33, Sascha Bischoff wrote:
> Record the SPI and PPI bases for the selected irqchip and expose getters
> to code that does not receive the irqchip type. Configure the bases
> after the GIC device and MSI frame have been created.
> 
> Tested-by: Vladimir Murzin <vladimir.murzin@arm.com>
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
> ---
>  arm64/gic.c             | 48 +++++++++++++++++++++++++++++++++++++++++
>  arm64/include/kvm/gic.h |  4 ++++
>  2 files changed, 52 insertions(+)
> 
> diff --git a/arm64/gic.c b/arm64/gic.c
> index 51a32159..df5689a7 100644
> --- a/arm64/gic.c
> +++ b/arm64/gic.c
> @@ -21,6 +21,18 @@ static u64 gic_redists_size;
>  static u64 gic_msi_base;
>  static u64 gic_msi_size = 0;
>  static bool vgic_is_init = false;
> +static int gic_spi_base = GIC_SPI_IRQ_BASE;
> +static int gic_ppi_base = GIC_PPI_IRQ_BASE;
> +
> +int gic__get_spi_base(void)
> +{
> +	return gic_spi_base;
> +}
> +
> +int gic__get_ppi_base(void)
> +{
> +	return gic_ppi_base;
> +}
>  
>  struct kvm_irqfd_line {
>  	unsigned int		gsi;
> @@ -211,6 +223,34 @@ static int gic__set_dist(enum irqchip_type type)
>  	}
>  }
>  
> +static int gic__set_spi(enum irqchip_type type)
> +{
> +	switch (type) {
> +	case IRQCHIP_GICV5:
> +		gic_spi_base = GICV5_SPI_IRQ_BASE;
> +		break;
> +	default:
> +		gic_spi_base = GIC_SPI_IRQ_BASE;
> +		break;
> +	}
> +
> +	return 0;
> +}
> +
> +static int gic__set_ppi(enum irqchip_type type)
> +{
> +	switch (type) {
> +	case IRQCHIP_GICV5:
> +		gic_ppi_base = GICV5_PPI_IRQ_BASE;
> +		break;
> +	default:
> +		gic_ppi_base = GIC_PPI_IRQ_BASE;
> +		break;
> +	}
> +
> +	return 0;
> +}
> +
>  static int gic__create_device(struct kvm *kvm, enum irqchip_type type)
>  {
>  	int err;
> @@ -256,6 +296,14 @@ static int gic__create_device(struct kvm *kvm, enum irqchip_type type)
>  	if (err)
>  		goto out_err;
>  
> +	err = gic__set_spi(type);
> +	if (err)
> +		goto out_err;
> +
> +	err = gic__set_ppi(type);
> +	if (err)
> +		goto out_err;
> +
>  	return 0;
>  
>  out_err:
> diff --git a/arm64/include/kvm/gic.h b/arm64/include/kvm/gic.h
> index 630f0bbd..c4f78cde 100644
> --- a/arm64/include/kvm/gic.h
> +++ b/arm64/include/kvm/gic.h
> @@ -4,6 +4,8 @@
>  #define GIC_SGI_IRQ_BASE		0
>  #define GIC_PPI_IRQ_BASE		16
>  #define GIC_SPI_IRQ_BASE		32
> +#define GICV5_PPI_IRQ_BASE		0
> +#define GICV5_SPI_IRQ_BASE		0
>  
>  #define GIC_FDT_IRQ_NUM_CELLS		3
>  
> @@ -34,6 +36,8 @@ enum irqchip_type {
>  
>  struct kvm;
>  
> +int gic__get_spi_base(void);
> +int gic__get_ppi_base(void);
>  int gic__alloc_irqnum(void);
>  int gic__create(struct kvm *kvm, enum irqchip_type type);
>  int gic__create_gicv2m_frame(struct kvm *kvm, u64 msi_frame_addr);
> -- 2.34.1
> 

FWIW

Reviewed-by: Vladimir Murzin <vladimir.murzin@arm.com>

