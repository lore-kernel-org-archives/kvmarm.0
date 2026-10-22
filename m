Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792690649;
	b=iP5wIyPVO9AeJdXmZxPG/E6IkMT5WfMnF563xcD5GZj1j0hhpN6NvP6PlkWsczSjTITy
	 NIIg3FQV1Flc3Y4w0S+3g7T0JOv5tEqyE8GpYJffAphEfx1+fIxFhCD2WSREc5B1oNIVL
	 gsYU3NBhmxKs4BBGtrCudJJfkWYZtSiRPARIgkOW8YucfK7FWaHeUed95ceLSOufB/8N0
	 /Ebr+7U9BQjvFV27masetL41cQThIfxbZVPSxGsDh7N1yndmlvX3nfgKUVeq5cjs0EjT9
	 EPOe1gabqGWr4maN73JDP7FqdhWO2Gt1MNyR92HPOdRP09fW84X+FQj2cjn9+3WLKkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792690649;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=K9W5RCdzIyUx2UGPGNpmosuNQ05dcpdn632UhvrEm/U=;
	b=IbsSHO2amh7nw9jBaHDLGKPd5v47gQGAI/lDIrJMkO2B8GVT97jP9ub0+6VkYIF5ajZK
	 gx3c/ST0tz+xBflZ69UvajwzenYsle+Y7UYvg1QHEbM8FH4uumHz1OXraV7ImgrW29vHK
	 zDtEz9gvBjCiPXruBcCxpQpbg2871tNKOeO3rcc059vHPkAkvO32UzDGIcH+vkPoHLLRE
	 twez17KRpmPl2YD/V0qJEybO/o9mZBSHNBcdqwov73CYj8a6AzDa8Ghnhj3VDFeDlRwSP
	 2/rWJrWqO4cuFx3SN7yWtkQWzCJ6SrvXf7eiOGVIVAdyeWOonV2n11RzdMBvaV1OMbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=NjFUqFWk;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45E25606A328
	for <kvmarm@lists.linux.dev>; Thu, 22 Oct 2026 17:37:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 45E25606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=NjFUqFWk
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 80DC91691;
	Thu, 22 Oct 2026 10:37:24 -0700 (PDT)
Received: from [10.57.76.220] (unknown [10.57.76.220])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0AB7B3F673;
	Thu, 22 Oct 2026 10:37:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792690647; bh=wEmXCKLi8hNQIEvYmhYaLegYxs9QSULRFwJW/xWDQTs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=NjFUqFWkZX85dGb/IWTgRXjZ67lw+gzzoNjeaEOF8FmgZ+8Z4wLj4+GPeTrvmwWPO
	 eOY3P2lpdM9O/xoFCfZJ9W2Z4Li9dW811Z1b4EFC4ZL+/Qup3NWOlT1P7Yt+4/ZMZ6
	 epa2BgewZnpOwa5SnQ0ES4xgM9TeCbfYuTwNhtcQ=
Message-ID: <c3df7c89-1376-4fc9-88c0-083029c836bb@arm.com>
Date: Thu, 22 Oct 2026 18:37:24 +0100
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
Subject: Re: [PATCH kvmtool v3 03/21] arm64: Sync KVM UAPI headers for GICv5
 IRS
To: Sascha Bischoff <sascha.bischoff@arm.com>, will@kernel.org,
 julien.thierry.kdev@gmail.com
Cc: maz@kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 timothy.hayes@arm.com, Peter Maydell <peter.maydell@linaro.org>
References: <20261016153939.913764-1-sascha.bischoff@arm.com>
 <20261016153939.913764-4-sascha.bischoff@arm.com>
Content-Language: en-GB
From: Vladimir Murzin <vladimir.murzin@arm.com>
In-Reply-To: <20261016153939.913764-4-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/16/26 16:39, Sascha Bischoff wrote:
> Copy the GICv5 IRS address type and size, the IRS register attribute
> group, and the IST attribute and descriptor from the Linux headers.
> 
> Keep the ITS UAPI out of this sync so the base GICv5 support uses
> only the IRS definitions already present in Linux.
> 
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
> ---
>  arm64/include/asm/kvm.h | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/arm64/include/asm/kvm.h b/arm64/include/asm/kvm.h
> index 1c13bfa2..9998252e 100644
> --- a/arm64/include/asm/kvm.h
> +++ b/arm64/include/asm/kvm.h
> @@ -97,6 +97,11 @@ struct kvm_regs {
>  #define KVM_VGIC_V3_REDIST_SIZE		(2 * SZ_64K)
>  #define KVM_VGIC_V3_ITS_SIZE		(2 * SZ_64K)
>  
> +/* Supported VGICv5 address types  */
> +#define KVM_VGIC_V5_ADDR_TYPE_IRS	6
> +
> +#define KVM_VGIC_V5_IRS_SIZE		(2 * SZ_64K)
> +
>  #define KVM_ARM_VCPU_POWER_OFF		0 /* CPU is started in OFF state */
>  #define KVM_ARM_VCPU_EL1_32BIT		1 /* CPU running a 32bit VM */
>  #define KVM_ARM_VCPU_PSCI_0_2		2 /* CPU uses PSCI v0.2 */
> @@ -417,6 +422,16 @@ enum {
>  #define KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO  7
>  #define KVM_DEV_ARM_VGIC_GRP_ITS_REGS 8
>  #define KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ  9
> +#define KVM_DEV_ARM_VGIC_GRP_IRS_REGS	10
> +#define KVM_DEV_ARM_VGIC_GRP_IST	11
> +
> +struct kvm_vgic_v5_ist {
> +	__u64	spi_ist_addr;
> +	__u64	spi_ist_size;
> +	__u64	lpi_ist_addr;
> +	__u64	lpi_ist_size;
> +};
> +
>  #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT	10
>  #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_MASK \
>  			(0x3fffffULL << KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT)
> -- 2.34.1
> 

That matches to what we expect in 7.4-rc1, so FWIW

Reviewed-by: Vladimir Murzin <vladimir.murzin@arm.com>
