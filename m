Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793018986;
	b=MG0uA0skitQUGXU7MjwnYYbCX2prSdhx2nke3J2WmAzNDRhlTLd+Tbg4/0ucBVlmXHRo
	 uw7RSFwQ1/Gc4srWJGG/lXys14HPwK8Y40rygYhizngB6Szb2ErhG4s+Ob5cOz0/RR/V4
	 OmMYu0tR1yVEWUcLsH0gbGj0Hfko+VonEo2tiYyDFfDwQIevgQjBs58guLBzE2x7UKx+H
	 DP9zY3fHF1KojrBGHAiqTfvRLDKwrI/t/8ZqZzBs0bze54sRq6F2e5YOk0mGW7ZMQFEmP
	 HLp24jHiKqTy62rlCl1Fu4TDtnMDTDsqDIjt5yfORyqeM7UCnEele9LsVCsPPVky0+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793018986;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=LIrtVbYjeTWt+LPvI92NrDXUDYJK8HJf3q8Bf9eTqhE=;
	b=HrlqIAHAQQBGcr/a0unrweEywwhOzc+HGSMZ7LQ0vRDgtvDrFW7/XN48Esf2AaeowJaj
	 dkHQ5ExJdKT0dXpVjjBhIEnPPIn8aMJNmzaA7yELqJXbZtPdWyArASEN55Sv9XcQLC/ff
	 YTyxd1IDUwJYtfRCwCZtFfMMVh3r5w2mZt/G7iPeZxgL7nlUtG76Bw7eILA3fVmFRtgJV
	 yGBsyeCsh6eKTFyD7G9CqtAuSdQD3YGq5A2iDPYVWF2LzTS2IrsW+biIOTmBPbQ8nq7Vy
	 CyrfxIUb1RWP2DcafEhYIO1bhhE12Yjbbf4CQaSS8qnq3M0CW4T3N2xwt5Pb9rnYxRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=rasdJEGG;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74187606A324
	for <kvmarm@lists.linux.dev>; Mon, 26 Oct 2026 12:49:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 74187606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=rasdJEGG
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9CC872938;
	Mon, 26 Oct 2026 05:49:40 -0700 (PDT)
Received: from [10.0.152.204] (e121487-lin.cambridge.arm.com [10.0.152.204])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2A0F33FB9E;
	Mon, 26 Oct 2026 05:49:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793018983; bh=e2pYa8Twri+w4XzkvlgSAsv6p9aZhbW6K5ilPD/wl+g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=rasdJEGGSx43dhoi704JRgz8gUGtC+Lak3gwOQiWaTu4WSXtuYILWY6TScjpMMSKH
	 wp71hl9xvVcYlHuCRHNybIPwqBEav03QnWngSz/zJB68Lry32WzZCSsieI9WRLvY4U
	 u6l4hoyHUMnQy20v1Td5ZZS3LORAL8/MSXzQZTYQ=
Message-ID: <eceb5d34-b505-468d-8f46-117d34f864f7@arm.com>
Date: Mon, 26 Oct 2026 12:49:39 +0000
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
Subject: Re: [PATCH kvmtool v3 12/21] arm64: Describe the GICv5 CPU interface
 in the DT
To: Sascha Bischoff <sascha.bischoff@arm.com>, will@kernel.org,
 julien.thierry.kdev@gmail.com
Cc: maz@kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 timothy.hayes@arm.com, Peter Maydell <peter.maydell@linaro.org>
References: <20261016153939.913764-1-sascha.bischoff@arm.com>
 <20261016153939.913764-13-sascha.bischoff@arm.com>
Content-Language: en-GB
From: Vladimir Murzin <vladimir.murzin@arm.com>
In-Reply-To: <20261016153939.913764-13-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/16/26 16:39, Sascha Bischoff wrote:
> Emit an interrupt-controller node for the GICv5 CPU interface. This
> provides the interrupt parent and allows guests to use PPIs.
> 
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
> ---
>  arm64/gic.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/arm64/gic.c b/arm64/gic.c
> index 5be71ba1..f4d446da 100644
> --- a/arm64/gic.c
> +++ b/arm64/gic.c
> @@ -408,6 +408,8 @@ static int gic__init_gic(struct kvm *kvm)
>  }
>  late_init(gic__init_gic)
>  
> +static void gic__generate_gicv5_fdt_nodes(void *fdt, struct kvm *kvm);
> +
>  void gic__generate_fdt_nodes(void *fdt, struct kvm *kvm)
>  {
>  	const char *compatible, *msi_compatible = NULL;
> @@ -438,6 +440,8 @@ void gic__generate_fdt_nodes(void *fdt, struct kvm *kvm)
>  		reg_prop[2] = cpu_to_fdt64(gic_redists_base);
>  		reg_prop[3] = cpu_to_fdt64(gic_redists_size);
>  		break;
> +	case IRQCHIP_GICV5:
> +		return gic__generate_gicv5_fdt_nodes(fdt, kvm);
>  	default:
>  		return;
>  	}
> @@ -471,6 +475,22 @@ void gic__generate_fdt_nodes(void *fdt, struct kvm *kvm)
>  	_FDT(fdt_end_node(fdt));
>  }
>  
> +static void gic__generate_gicv5_fdt_nodes(void *fdt, struct kvm *kvm)
> +{
> +	_FDT(fdt_begin_node(fdt, "gicv5-cpuif"));
> +	_FDT(fdt_property_string(fdt, "compatible", "arm,gic-v5"));
> +	_FDT(fdt_property_cell(fdt, "#interrupt-cells", GIC_FDT_IRQ_NUM_CELLS));
> +	_FDT(fdt_property(fdt, "interrupt-controller", NULL, 0));
> +	_FDT(fdt_property_cell(fdt, "#address-cells", 2));
> +	_FDT(fdt_property_cell(fdt, "#size-cells", 2));
> +	_FDT(fdt_property(fdt, "ranges", NULL, 0));
> +
> +	/* Use a hard-coded phandle for the GIC to help wire things up */
> +	_FDT(fdt_property_cell(fdt, "phandle", PHANDLE_GIC));
> +
> +	_FDT(fdt_end_node(fdt));
> +}
> +
>  u32 gic__get_fdt_irq_cpumask(struct kvm *kvm)
>  {
>  	/* Only for GICv2 */
> -- 2.34.1
> 


FWIW,

Reviewed-by: Vladimir Murzin <vladimir.murzin@arm.com>
