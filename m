Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794324381;
	b=YswknKy+c6cmZ917XNO+ZQJgrk//bD6q2Yv8aFAFBkSe6g3QRBzkwNk8GvRrkCCmKWA8
	 xRIXKF9yJKm2LTiq6s99YmB2n/+pTmWy7yrEfEer1wxKrtV+4vPASinoiIHvPc2PxWCud
	 gFf17uQS8/fXB19v3k2yuwiSdJnSeG9FsrhgStCEkr9rPA6csbqoaPGie0XyD703ZU3cm
	 71hIlHvCWcoafAZA5rzBuQDOBlQdNXHos7QNp7LNXHFADN2g6gpHoQ9PUFJYoUvJgZH+U
	 CJEGCH+led/ITpHcPYvXulSFcTNZC82Ao10D8PFCo/3nAwwjdc4p88zgGxe/eHgacBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794324381;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=lMmqS7htx60skcDHbDZ9zCMv9pZXltSqU5UHaOSfJBY=;
	b=FW0wdR9PwgCxgwGjxs9aVo3f37DBrEvmRG/eMdM8BnXfha5tUI6ij19bYhph7sOP0qvp
	 VWm7L9QOCbhLGgz5L9cY7Ardtu3qr2+ej0fymWWHB+4z8bw8PQKIuGwwVOP2suNgvPa+T
	 dHpmXkgEC3/PVYu68se235gQBEjBwieCvsVYYQ70SuFfodCn6od2S8xC64O00i+bpYvjJ
	 obuacKQCYv7Q+6YRePVERHazCDguw2hHgbZ05vXKQtbSYzV4RroYPyHlUdOkLKKWYTbXF
	 Wimm+BULHu0kGWVADT150qZWxVSWABenO+G8V/hNavhkooQHgooNY5DWNdwY8f+2wJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=AElGW1IF;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8BB5606A31C
	for <kvmarm@lists.linux.dev>; Tue, 10 Nov 2026 15:26:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A8BB5606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=AElGW1IF
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9C8C51477;
	Tue, 10 Nov 2026 07:26:15 -0800 (PST)
Received: from [10.0.154.42] (e121487-lin.cambridge.arm.com [10.0.154.42])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D38123F85F;
	Tue, 10 Nov 2026 07:26:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794324378; bh=9omS4cAyHDEiJO/BU9pzgf/vidotnQ3dAM4+2D6/BDY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=AElGW1IF+umgeoplFKYai3XezO8C2CiBk3b3dPfieSsBOgTGP1TrtV06sT7GwK2ra
	 0fJBPMFtWzMbTpbrxXZmOxB3lXsxitN+HlRCLzc+Wrhud/ltmFL9d7CPt0RynOfUh2
	 rwyHkEK3z102FnfnZa5bJGnJZlDKl13yaAjrcWsg=
Message-ID: <d3575aea-2b86-4f97-b0f9-138c685112b3@arm.com>
Date: Tue, 10 Nov 2026 15:26:14 +0000
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
Subject: Re: [PATCH kvmtool v4 16/23] arm64: Generate GICv5 SPI specifiers for
 platform devices
To: Sascha Bischoff <sascha.bischoff@arm.com>, will@kernel.org,
 julien.thierry.kdev@gmail.com
Cc: maz@kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 timothy.hayes@arm.com, Peter Maydell <peter.maydell@linaro.org>
References: <20261102213413.4136118-1-sascha.bischoff@arm.com>
 <20261102213413.4136118-17-sascha.bischoff@arm.com>
Content-Language: en-GB
From: Vladimir Murzin <vladimir.murzin@arm.com>
In-Reply-To: <20261102213413.4136118-17-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/2/26 21:34, Sascha Bischoff wrote:
> Use the GICv5 interrupt type and absolute SPI number for platform
> devices. Preserve the legacy GICv2/v3 DT encoding for other VMs.
> 
> Tested-by: Vladimir Murzin <vladimir.murzin@arm.com>
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
> ---
>  arm64/fdt.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/arm64/fdt.c b/arm64/fdt.c
> index 5413956d..e92ae044 100644
> --- a/arm64/fdt.c
> +++ b/arm64/fdt.c
> @@ -63,11 +63,13 @@ static void generate_cpu_nodes(void *fdt, struct kvm *kvm)
>  
>  static void generate_irq_prop(void *fdt, u8 irq, enum irq_type irq_type)
>  {
> -	u32 irq_prop[] = {
> -		cpu_to_fdt32(GIC_FDT_IRQ_TYPE_SPI),
> -		cpu_to_fdt32(irq - GIC_SPI_IRQ_BASE),
> -		cpu_to_fdt32(irq_type)
> -	};
> +	u32 irq_prop[3];
> +	u32 type = gic__get_spi_fdt_type();
> +	u32 intid = irq - gic__get_spi_base();
> +
> +	irq_prop[0] = cpu_to_fdt32(type);
> +	irq_prop[1] = cpu_to_fdt32(intid);
> +	irq_prop[2] = cpu_to_fdt32(irq_type);
>  
>  	_FDT(fdt_property(fdt, "interrupts", irq_prop, sizeof(irq_prop)));
>  }
> -- 2.34.1
> 

FWIW

Reviewed-by: Vladimir Murzin <vladimir.murzin@arm.com>

