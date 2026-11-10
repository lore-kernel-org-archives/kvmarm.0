Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794324433;
	b=r8BG9vTgAzOaBSwQEDePaIT4RLq09xLKF0A2ccbPsfnWQvv0+hyRNl0Uc1BFhiQO5rKL
	 NiDy+wpLmO1vEO1yh4mVuleRrLzLO5e60XFNicO7ZD/4Wiov4+fUxTiXykxm8PImEavrj
	 AM00ipP2+gRIXPfajBjUlTJr84DZrNuqP5i05L5nfAR9nWQiAqaBDZU7Tm/EiJUr4drxk
	 XsJpUj8NuMnfU+ri2FleRoWj6vY8azyDdmOt9KRkUF0jJ+YYW/AYw3TQg+/+83cRUiH1W
	 F8ob/z84NgChJDJfpsHAHPA9GewjazDK+uIrPl7jHDcwb8gxIifYmeFfyokrFPd+I8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794324433;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=a9Sk5i9is5fU5eACQgSm4m1SBaa7vSAZy7vt+SRsWOE=;
	b=qthsE+xhLPt1HYkw0YcAt4baB/rfpxxUzIsGKaIkDUNoVpiM+bp5oZ54JPQS6FeNvGl/
	 8YioFsV3idw1Rx1JcX4pW3pIAFeJlAVFlzhxAnubbFvsjFfsXA6CVO1mrUhsJ0x8J3pgt
	 pmI/f+VxzMHJN0GzPjoaxs5eN7C1bzpdMTJvzT7m9oTG3c2fuBcpUlSJHxMgPqNHl35yc
	 jbqMDrkNezqqb6GcNzC0MCnDhhZZYgF4MZ/YMRSvAZLTEYLL5VqnWe0wrm0gDla2JtFNs
	 JxwODoeERx3UGjLgAmuckp8wLKykDE/L4uMXqebbLIvSuADaoJAurSfOQUXHtr+9BAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b="oB/noVM5";
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03054606A31C
	for <kvmarm@lists.linux.dev>; Tue, 10 Nov 2026 15:27:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 03054606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=oB/noVM5
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 69D911477;
	Tue, 10 Nov 2026 07:27:08 -0800 (PST)
Received: from [10.0.154.42] (e121487-lin.cambridge.arm.com [10.0.154.42])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 15D133F85F;
	Tue, 10 Nov 2026 07:27:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794324431; bh=mWjfNeVoVsYr2+cYrGzmKbitoGk+0nff38nwEq4Sg4E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=oB/noVM58mRItctFs5MA0OEnABMxfUGua8Z5drxB8z8oRYSoHJ4s00y/PbwXUnKQR
	 a92DXUcmCGRzBf9iRAAQf/WtoixltPGH+Dlhs4NczmcAPUJRbj/+d27bcFmk1OsG1M
	 eyv/IycCQY2srve1MQ0ExGuE3t/g8HvVW6BWpD1Q=
Message-ID: <ef45d345-5c80-4656-9058-d3f07c8c806a@arm.com>
Date: Tue, 10 Nov 2026 15:27:08 +0000
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
Subject: Re: [PATCH kvmtool v4 17/23] arm64: Generate GICv5 PCI INTx
 specifiers
To: Sascha Bischoff <sascha.bischoff@arm.com>, will@kernel.org,
 julien.thierry.kdev@gmail.com
Cc: maz@kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 timothy.hayes@arm.com, Peter Maydell <peter.maydell@linaro.org>
References: <20261102213413.4136118-1-sascha.bischoff@arm.com>
 <20261102213413.4136118-18-sascha.bischoff@arm.com>
Content-Language: en-GB
From: Vladimir Murzin <vladimir.murzin@arm.com>
In-Reply-To: <20261102213413.4136118-18-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/2/26 21:34, Sascha Bischoff wrote:
> PCI interrupt-map entries currently use the GICv2/v3 SPI type and an
> IRQ number with the SPI base subtracted. GICv5 uses a different SPI
> type (matching the hardware) and zero-based SPI numbers. Use the GICv5
> encoding for its INTx entries while retaining the existing encoding
> for other GICs.
> 
> Tested-by: Vladimir Murzin <vladimir.murzin@arm.com>
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
> ---
>  arm64/pci.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arm64/pci.c b/arm64/pci.c
> index db87db8b..91265f67 100644
> --- a/arm64/pci.c
> +++ b/arm64/pci.c
> @@ -84,6 +84,8 @@ void pci__generate_fdt_nodes(void *fdt, struct kvm *kvm)
>  		u8 pin = pci_hdr->irq_pin;
>  		u8 irq = pci_hdr->irq_line;
>  		u32 irq_flags = pci_hdr->irq_type;
> +		u32 int_type = gic__get_spi_fdt_type();
> +		u32 int_id = irq - gic__get_spi_base();
>  
>  		/*
>  		 * Avoid adding entries in "interrupt-map" for devices that
> @@ -108,8 +110,8 @@ void pci__generate_fdt_nodes(void *fdt, struct kvm *kvm)
>  			.gic_addr_hi	= 0,
>  			.gic_addr_lo	= 0,
>  			.gic_irq = {
> -				.type	= cpu_to_fdt32(GIC_FDT_IRQ_TYPE_SPI),
> -				.num	= cpu_to_fdt32(irq - GIC_SPI_IRQ_BASE),
> +				.type	= cpu_to_fdt32(int_type),
> +				.num	= cpu_to_fdt32(int_id),
>  				.flags	= cpu_to_fdt32(irq_flags),
>  			},
>  		};
> -- 2.34.1
> 

FWIW,

Reviewed-by: Vladimir Murzin <vladimir.murzin@arm.com>

