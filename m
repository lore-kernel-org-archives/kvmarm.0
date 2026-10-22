Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792693382;
	b=fHqiSShJjBrcMX8Teb6mZZn173Xl3f/ziRgydLemDT+S/KVgMTWoFLSs5/Tq5hqIHfE/
	 wEHzTBTmJNf4EZ0HxkeJyOFfvBIIyliteed9PfXO4o2fnMnG4WscsP4vsj7E4Jy1ulFs5
	 ZnOnlMK6lhSQMc7z6jhkRe4DSake6jWQiGTWOK3jB2Czqh7sbFaLgBxWH5hbLgSmG+h3G
	 lOq00P8GTuTQDcGyPtyJ488Jrm6LLRfVl8HMu+J4tAR8QhWUeyQW31qkyv7p6sENXoCzb
	 7AatHzJrEgtvnr58yIUmfrDLeW35ZJubk8MY521kcgxQ+RMYwM9RreKmA4VDlKF2IJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792693382;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=sbzKVeJYRAFzhPg7qk1/fAacsQOinxlRsutiF6Ah0fU=;
	b=V6VqAjJQtqKj9g/5iMAl3Tx8Qyjk4cOCujw1XrMHwWSkpP07kbQ9Iv/h7Fm48u0eBfVU
	 8lO+VGOms7Dc7FpG9NQKPRFAy/tMoYhuf12pPLxZUnrxzMzUAZaokOJ8/7zb6JUv8slY1
	 7aJyk447OcXT+fVTtBiMX9CUJ+JAH4EkJrPdnC6DyhOLV6MbsKoUTxVDxszP+LVo1IZqz
	 AcvwZUqToqqxR4AYKV7lV1IytxG1LgJEBgLjZFQntzW7eIdGoHmQC2Eb41DOG0Kcl/ceC
	 IlU8mv2UW5kssvtFbC4sbPNodmR11EG52PwQmpXZKmoWz8sGxj6jBOKaOz5QV4l2Q5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b="tJ/ZXWG1";
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 987E6606A31D
	for <kvmarm@lists.linux.dev>; Thu, 22 Oct 2026 18:23:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 987E6606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=tJ/ZXWG1
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 95CAD1692;
	Thu, 22 Oct 2026 11:22:57 -0700 (PDT)
Received: from [10.57.76.220] (unknown [10.57.76.220])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 022DC3F7B4;
	Thu, 22 Oct 2026 11:22:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792693380; bh=aO98M6VdjpkKcybKywSJO9dzROa80tlYikJ2ql8nWBY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=tJ/ZXWG1Ib3qisCNXgjrOVQVPET4iPWQaabwjllYvoxYRW07s/AjNbXDmUhwcIITR
	 eIR5Y3x3/eywwR9Su+QKbOMkCr7ysjRlJHS2MpmIjPU/yi6wNuMyP0bCYUqkcPW4Ki
	 Kmja1HlASUPYMevmz49zMSXuJINJ94M6H40Urh7c=
Message-ID: <4fcaa349-6c0c-4660-89cc-5cd34872fa7a@arm.com>
Date: Thu, 22 Oct 2026 19:22:56 +0100
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
Subject: Re: [PATCH kvmtool v3 05/21] arm64: Track whether the VM uses GICv5
To: Sascha Bischoff <sascha.bischoff@arm.com>, will@kernel.org,
 julien.thierry.kdev@gmail.com
Cc: maz@kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 timothy.hayes@arm.com, Peter Maydell <peter.maydell@linaro.org>
References: <20261016153939.913764-1-sascha.bischoff@arm.com>
 <20261016153939.913764-6-sascha.bischoff@arm.com>
Content-Language: en-GB
From: Vladimir Murzin <vladimir.murzin@arm.com>
In-Reply-To: <20261016153939.913764-6-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/16/26 16:39, Sascha Bischoff wrote:
> Expose the selected GIC generation to interrupt and DT setup code that
> does not receive the irqchip type directly. Set the state only after
> the GIC device has been configured successfully.
> 
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
> ---
>  arm64/gic.c             | 7 +++++++
>  arm64/include/kvm/gic.h | 1 +
>  2 files changed, 8 insertions(+)
> 
> diff --git a/arm64/gic.c b/arm64/gic.c
> index 5c8a33b5..c1bd0771 100644
> --- a/arm64/gic.c
> +++ b/arm64/gic.c
> @@ -21,6 +21,12 @@ static u64 gic_redists_size;
>  static u64 gic_msi_base;
>  static u64 gic_msi_size = 0;
>  static bool vgic_is_init = false;
> +static bool vgic_is_v5;
> +
> +bool gic__is_v5(void)
> +{
> +	return vgic_is_v5;
> +}
>  
>  struct kvm_irqfd_line {
>  	unsigned int		gsi;
> @@ -230,6 +236,7 @@ static int gic__create_device(struct kvm *kvm, enum irqchip_type type)
>  	if (err)
>  		goto out_err;
>  
> +	vgic_is_v5 = type == IRQCHIP_GICV5;
>  	return 0;
>  
>  out_err:
> diff --git a/arm64/include/kvm/gic.h b/arm64/include/kvm/gic.h
> index 630f0bbd..991aa912 100644
> --- a/arm64/include/kvm/gic.h
> +++ b/arm64/include/kvm/gic.h
> @@ -34,6 +34,7 @@ enum irqchip_type {
>  
>  struct kvm;
>  
> +bool gic__is_v5(void);
>  int gic__alloc_irqnum(void);
>  int gic__create(struct kvm *kvm, enum irqchip_type type);
>  int gic__create_gicv2m_frame(struct kvm *kvm, u64 msi_frame_addr);
> -- 2.34.1
> 

I noticed that gic__is_v5() is used later on in places which, in theory,
should not care about what exact gic type is in use. Those places are

1. adjustments for fdt generations

For that case, can we have some helpers, say

int gic__get_spi_base(void)
{
        return gic_spi_base;
}

int gic__get_ppi_base(void)
{
        return gic_ppi_base;
}

int gic__get_spi_fdt_type(void)
{
        return gic_spi_fdt_type;
}

int gic__get_ppi_fdt_type(void)
{
        return gic_ppi_fdt_type;
}

which we configure from 

static int gic__create_device(struct kvm *kvm, enum irqchip_type type)
{
...
        err = gic__set_spi(type);
        if (err)
                goto out_err;

        err = gic__set_ppi(type);
        if (err)
                goto out_err;
...
}

where

static int gic__set_spi(enum irqchip_type type)
{
        switch (type) {
        case IRQCHIP_GICV5:
                gic_spi_base = GICV5_SPI_IRQ_BASE;
                gic_spi_fdt_type = GICV5_FDT_IRQ_TYPE_SPI;
                break;
        default:
                gic_spi_base = GIC_SPI_IRQ_BASE;
                gic_spi_fdt_type = GIC_FDT_IRQ_TYPE_SPI;
                break;
        }

        return irq__init_irq_offset(gic_spi_base);
}

static int gic__set_ppi(enum irqchip_type type)
{
        switch (type) {
        case IRQCHIP_GICV5:
                gic_ppi_base = GICV5_PPI_IRQ_BASE;
                gic_ppi_fdt_type = GICV5_FDT_IRQ_TYPE_PPI;
                break;
        default:
                gic_ppi_base = GIC_PPI_IRQ_BASE;
                gic_ppi_fdt_type = GIC_FDT_IRQ_TYPE_PPI;
                break;
        }

        return 0;
}

so 

void pci__generate_fdt_nodes(void *fdt, struct kvm *kvm)
{
...
        int_type = gic__get_spi_fdt_type();
        int_id = irq - gic__get_spi_base();
...
}

and

void pmu__generate_fdt_nodes(void *fdt, struct kvm *kvm)
{
...
        irq_prop[0] = cpu_to_fdt32(gic__get_ppi_fdt_type());
        irq_prop[1] = cpu_to_fdt32(irq - gic__get_ppi_base());

...
}

and

void timer__generate_fdt_nodes(void *fdt, struct kvm *kvm)
{
...
        type = gic__get_ppi_fdt_type();
        offset = gic__get_ppi_base();
...
}

2. adjustment for IRQ line

With helpers introduced above 

static int gic__init_gic(struct kvm *kvm)
{
...
        nr_irqs += gic__get_spi_base();
...
}

and

void kvm__irq_line(struct kvm *kvm, int irq, int level)
{
...
        if (irq < gic__get_spi_base() || irq > GIC_MAX_IRQ)
...
}

}

3. PMU initialisation

Can we introduce another helper

int gic__encode_ppi_irq(enum irqchip_type type, int irq)
{
        switch (type) {
        case IRQCHIP_GICV5:
                return irq | (GICV5_IRQ_TYPE_PPI <<  GICV5_IRQ_TYPE_SHIFT);
        default:
                return irq;
        }
}

so

int pmu__init(struct kvm *kvm)
{
...
        irq = gic__encode_ppi_irq(kvm->cfg.arch.irqchip, irq);
...
}

4. phandle generation for CPU node(s)

We can either guard by kvm->cfg.arch.irqchip == IRQCHIP_GICV5 or, perhaps
generate it unconditionally?


Cheers
Vladimir
