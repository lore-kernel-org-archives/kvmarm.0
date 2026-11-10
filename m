Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794322833;
	b=rSim1Qrl7moZSDJda8Xqb2X3BolgQhqTTRKgTBCFTZsPXSL1sQHl3XKpq4PsA5hEK1Ru
	 +FNy2I6MVy3AfB2oJUua1R4rpUMeVxSmESfFLh2KZql5oiXa93BSP0OjWLesxVh/xB9H8
	 BwuURAC6xVvYQ0ON2mCi+LbMXDBysiGPJ+5f18SlPntozXE0u+5Sa8MOWZDmz22Rk+BdN
	 m3f7W2f0JwEhsNZDXVwqalBWYA5kyOWPPyg96MZaFatfgeblP0aOe7oG4e9YSb7AA8dxu
	 qsT43dYtpAgZgSR+/z7irfNAQypabrnWOQh0LMvdgB+MbB0bpbbQVn0jVvtfBtK0bQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794322833;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=v+fh2ZDF3Xnnr8cfuBggx4xiPsRGvZPWMsya77LZGb4=;
	b=ZZ9F9UDRY7I5c7rFKJr0MtMGtdQjY7x5Z+70XJwnkkbc0W2Ha9wBHCehT5rhxEanmrls
	 ckPgM98UYqWG3b/Z9p1C0zDo7Ph24CAjz5qbPEov+FZIgAi8zY/EJr+Ce0T469fvI91Wk
	 xM3L37l1zXnUN7Iib1SEiVwxVlh2u1oSZ6MF6pjQqVj+XAs+D2P10yJj+uZ59uUZsRnuC
	 WokDcQsEY+/jkNoKXV68VVq5YISUeIRmc1IzBAfkQWQk7EpevjsGNh6iWZ7skevISvRyp
	 5jegCPFZj9ukRVEhmJZM2hWatVWymdL8/K/PVUSrOb3o046jLbYjCls72xesuj1x2tQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=k8tR2hcq;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F43060A261F
	for <kvmarm@lists.linux.dev>; Tue, 10 Nov 2026 15:00:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4F43060A261F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=k8tR2hcq
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5D47F1477;
	Tue, 10 Nov 2026 07:00:28 -0800 (PST)
Received: from [10.0.154.42] (e121487-lin.cambridge.arm.com [10.0.154.42])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9B2FE3F632;
	Tue, 10 Nov 2026 07:00:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794322831; bh=/0Gga801rsXtW7QvKKBIKg27fb7mmL2PqR/ZwIiJXxg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=k8tR2hcqF2XwmvqgpJRORbdqak4vBQhFmgcoTSdR/C33cavwQVYdGO8qkSmFokohh
	 AIGJN68fQ+V45AxtsCpRz2DfZQES44e7kv6Bso1gm8dTbBO3BEf7dy/ftx3K4dTIGz
	 a7m5oYkyUrWPMPgasALHUtXPT2ACo/26JpGVL4LI=
Message-ID: <e641655a-bdaf-4cd8-b61a-b5ba041d732c@arm.com>
Date: Tue, 10 Nov 2026 15:00:27 +0000
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
Subject: Re: [PATCH kvmtool v4 03/23] arm64: Split GIC device setup
To: Sascha Bischoff <sascha.bischoff@arm.com>, will@kernel.org,
 julien.thierry.kdev@gmail.com
Cc: maz@kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 timothy.hayes@arm.com, Peter Maydell <peter.maydell@linaro.org>
References: <20261102213413.4136118-1-sascha.bischoff@arm.com>
 <20261102213413.4136118-4-sascha.bischoff@arm.com>
Content-Language: en-GB
From: Vladimir Murzin <vladimir.murzin@arm.com>
In-Reply-To: <20261102213413.4136118-4-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/2/26 21:33, Sascha Bischoff wrote:
> Separate the CPU interface, redistributor and distributor address setup
> from GIC device creation. Keep the per-GIC address handling in small
> helpers.
> 
> Use the irqchip enum order to omit the GICv2 PPI CPU mask for GICv3
> and later generations.
> 
> Suggested-by: Vladimir Murzin <vladimir.murzin@arm.com>
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
> ---
>  arm64/gic.c | 94 +++++++++++++++++++++++++++++++++++------------------
>  1 file changed, 62 insertions(+), 32 deletions(-)
> 
> diff --git a/arm64/gic.c b/arm64/gic.c
> index f8371f50..57f3fa02 100644
> --- a/arm64/gic.c
> +++ b/arm64/gic.c
> @@ -142,52 +142,90 @@ out_close:
>  	return err;
>  }
>  
> -static int gic__create_msi_frame(struct kvm *kvm, enum irqchip_type type,
> -				 u64 msi_frame_addr)
> +static int gic__create_msi_frame(struct kvm *kvm, enum irqchip_type type)
>  {
>  	switch (type) {
>  	case IRQCHIP_GICV2M:
> -		return gic__create_gicv2m_frame(kvm, msi_frame_addr);
> +		return gic__create_gicv2m_frame(kvm, gic_msi_base);
>  	case IRQCHIP_GICV3_ITS:
> -		return gic__create_its_frame(kvm, msi_frame_addr);
> +		return gic__create_its_frame(kvm, gic_msi_base);
>  	default:	/* No MSI frame needed */
>  		return 0;

Nitpick: change is not mentioned in commit log


>  	}
>  }
>  
> -static int gic__create_device(struct kvm *kvm, enum irqchip_type type)
> +static int gic__set_cpu_if(enum irqchip_type type)
>  {
> -	int err;
>  	u64 cpu_if_addr = ARM_GIC_CPUI_BASE;
> -	u64 dist_addr = ARM_GIC_DIST_BASE;
> -	struct kvm_create_device gic_device = {
> -		.flags	= 0,
> -	};
>  	struct kvm_device_attr cpu_if_attr = {
>  		.group	= KVM_DEV_ARM_VGIC_GRP_ADDR,
>  		.attr	= KVM_VGIC_V2_ADDR_TYPE_CPU,
>  		.addr	= (u64)(unsigned long)&cpu_if_addr,
>  	};
> -	struct kvm_device_attr dist_attr = {
> -		.group	= KVM_DEV_ARM_VGIC_GRP_ADDR,
> -		.addr	= (u64)(unsigned long)&dist_addr,
> -	};
> +
> +	switch (type) {
> +	case IRQCHIP_GICV2M:
> +	case IRQCHIP_GICV2:
> +		return ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &cpu_if_attr);
> +	default:	/* No CPU interface needed */
> +		return 0;
> +	}
> +}
> +
> +static int gic__set_redist(enum irqchip_type type)
> +{
>  	struct kvm_device_attr redist_attr = {
>  		.group	= KVM_DEV_ARM_VGIC_GRP_ADDR,
>  		.attr	= KVM_VGIC_V3_ADDR_TYPE_REDIST,
>  		.addr	= (u64)(unsigned long)&gic_redists_base,
>  	};
>  
> +	switch (type) {
> +	case IRQCHIP_GICV3:
> +	case IRQCHIP_GICV3_ITS:
> +		return ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &redist_attr);
> +	default:	/* No redistributor needed */
> +		return 0;
> +	}
> +}
> +
> +static int gic__set_dist(enum irqchip_type type)
> +{
> +	u64 dist_addr = ARM_GIC_DIST_BASE;
> +	struct kvm_device_attr dist_attr = {
> +		.group	= KVM_DEV_ARM_VGIC_GRP_ADDR,
> +		.addr	= (u64)(unsigned long)&dist_addr,
> +	};
> +
> +	switch (type) {
> +	case IRQCHIP_GICV2M:
> +	case IRQCHIP_GICV2:
> +		dist_attr.attr = KVM_VGIC_V2_ADDR_TYPE_DIST;
> +		return ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &dist_attr);
> +	case IRQCHIP_GICV3:
> +	case IRQCHIP_GICV3_ITS:
> +		dist_attr.attr = KVM_VGIC_V3_ADDR_TYPE_DIST;
> +		return ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &dist_attr);
> +	default:	/* No distributor needed */
> +		return 0;
> +	}
> +}
> +
> +static int gic__create_device(struct kvm *kvm, enum irqchip_type type)
> +{
> +	int err;
> +	struct kvm_create_device gic_device = {
> +		.flags	= 0,
> +	};
> +
>  	switch (type) {
>  	case IRQCHIP_GICV2M:
>  	case IRQCHIP_GICV2:
>  		gic_device.type = KVM_DEV_TYPE_ARM_VGIC_V2;
> -		dist_attr.attr  = KVM_VGIC_V2_ADDR_TYPE_DIST;
>  		break;
>  	case IRQCHIP_GICV3:
>  	case IRQCHIP_GICV3_ITS:
>  		gic_device.type = KVM_DEV_TYPE_ARM_VGIC_V3;
> -		dist_attr.attr  = KVM_VGIC_V3_ADDR_TYPE_DIST;
>  		break;
>  	case IRQCHIP_AUTO:
>  		return -ENODEV;
> @@ -199,26 +237,19 @@ static int gic__create_device(struct kvm *kvm, enum irqchip_type type)
>  
>  	gic_fd = gic_device.fd;
>  
> -	switch (type) {
> -	case IRQCHIP_GICV2M:
> -	case IRQCHIP_GICV2:
> -		err = ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &cpu_if_attr);
> -		break;
> -	case IRQCHIP_GICV3_ITS:
> -	case IRQCHIP_GICV3:
> -		err = ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &redist_attr);
> -		break;
> -	case IRQCHIP_AUTO:
> -		return -ENODEV;
> -	}
> +	err = gic__set_cpu_if(type);
> +	if (err)
> +		goto out_err;
> +
> +	err = gic__set_redist(type);
>  	if (err)
>  		goto out_err;
>  
> -	err = ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &dist_attr);
> +	err = gic__set_dist(type);
>  	if (err)
>  		goto out_err;
>  
> -	err = gic__create_msi_frame(kvm, type, gic_msi_base);
> +	err = gic__create_msi_frame(kvm, type);
>  	if (err)
>  		goto out_err;
>  
> @@ -439,8 +470,7 @@ void gic__generate_fdt_nodes(void *fdt, struct kvm *kvm)
>  u32 gic__get_fdt_irq_cpumask(struct kvm *kvm)
>  {
>  	/* Only for GICv2 */
> -	if (kvm->cfg.arch.irqchip == IRQCHIP_GICV3 ||
> -	    kvm->cfg.arch.irqchip == IRQCHIP_GICV3_ITS)
> +	if (kvm->cfg.arch.irqchip >= IRQCHIP_GICV3)
>  		return 0;
>  
>  	if (kvm->nrcpus > 8)
> -- 2.34.1
> 

FWIW:

Reviewed-by: Vladimir Murzin <vladimir.murzin@arm.com>
Tested-by: Vladimir Murzin <vladimir.murzin@arm.com>

