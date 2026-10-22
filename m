Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792693562;
	b=v6eeRuFDOZSxRDKLzk+lP0kXmUv0MtYUEejt1Vok1hqpy0WYfU7HI6QvbICYHu15wXGD
	 ast9iWBIgfcmYjzIGXx5tPc42ytZCTZOw4XLe5nxM+e1b3r0k6dXN482jTs9YwAfMm3qo
	 uurqFL01xotQj/VcBV4jt/9biFrmUmcWNHG1oZQbjru/KthpbXCg60dwOvMS4M8HkzBFr
	 yyr4od+HSxntADfRHjI8r9J8XrLaiiHshvD5u5PZPuiDzhDavH0BGz1r0a8CST1sb9Od5
	 JXPy4UJ82zNxHGmWJ0yuwiJkutUrU6Cp4cwcpIUXXZts3mCY+CIsVXJ29C3xv+9AcVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792693562;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=+B/hxXLjKTU0fFTu1MgvPIeW5aIJvBWl+yNlqVSjGIY=;
	b=FVCSzUGTdczTjRYxa/W4r3ZW8GBuFCHHVi6ENKjzSLiCDRVXtZm45ov+IeLAAWIEYaJ3
	 rcjFoLDVEbry7zKgxoxtcmuOXqlcRxqNnDmaBA+N8ajTL9LfyHjOhWssL3e1sMQ2LgJHZ
	 MXHCYVU3Bj29vypAlANs+AdZYvPW0ywKvjvkbLrOaqqgOlJ1YowWlzTGXmVzTke4JYF0N
	 VlizW0JsbBXPq7/2hmpRHzGhYqoAcS5VcX6BX9FMnTlFwPhoCtqNx/11OklUun8Sqp8/L
	 u40AHcR0fhwm+Ja2R4vNwtu4R6CH1YA17CpNTLoKEYaJ6o/un4ebJ/7XcL2aD4/3uYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=bsmx2uOb;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8ECD8606A31A
	for <kvmarm@lists.linux.dev>; Thu, 22 Oct 2026 18:26:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8ECD8606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=bsmx2uOb
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A104F1692;
	Thu, 22 Oct 2026 11:25:57 -0700 (PDT)
Received: from [10.57.76.220] (unknown [10.57.76.220])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3C9A13F7B4;
	Thu, 22 Oct 2026 11:25:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792693560; bh=yFYX38nzSrgKXVKSXBJ9FV0XVnTWVsVzdNsl9hg5GaQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bsmx2uObfjcd2fllnReWtxSR5Dx8cQlfRycCXtpTOdVXevVeALQlRFnkZkubjTOmA
	 ndCWpsgFTsGVGLOLH982iXqV2lHwIUOSxv40J2e/4CRV7kR+dm/Fs0r+4n1SvNyoJm
	 UM72AWckdm62wyGY4TgHTbrlS5/QWznqXbtnC2jk=
Message-ID: <6964001c-3032-4c69-b1a6-382749dfc73b@arm.com>
Date: Thu, 22 Oct 2026 19:25:57 +0100
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
Subject: Re: [PATCH kvmtool v3 06/21] irq: Allow the initial interrupt line
 number to be set
To: Sascha Bischoff <sascha.bischoff@arm.com>, will@kernel.org,
 julien.thierry.kdev@gmail.com
Cc: maz@kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 timothy.hayes@arm.com, Peter Maydell <peter.maydell@linaro.org>
References: <20261016153939.913764-1-sascha.bischoff@arm.com>
 <20261016153939.913764-7-sascha.bischoff@arm.com>
Content-Language: en-GB
From: Vladimir Murzin <vladimir.murzin@arm.com>
In-Reply-To: <20261016153939.913764-7-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/16/26 16:39, Sascha Bischoff wrote:
> GICv5 SPIs start at zero, while earlier GICs use an offset of 32.
> Allow the offset to be changed before any line is allocated and set
> it to zero when creating a GICv5 VM.
> 
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
> ---
>  arm64/gic.c       |  6 ++++++
>  include/kvm/irq.h |  1 +
>  irq.c             | 15 ++++++++++++++-
>  3 files changed, 21 insertions(+), 1 deletion(-)
> 
> diff --git a/arm64/gic.c b/arm64/gic.c
> index c1bd0771..23c68862 100644
> --- a/arm64/gic.c
> +++ b/arm64/gic.c
> @@ -236,6 +236,12 @@ static int gic__create_device(struct kvm *kvm, enum irqchip_type type)
>  	if (err)
>  		goto out_err;
>  
> +	/* GICv5 SPIs start at zero. Set this before allocating IRQs. */
> +	if (type == IRQCHIP_GICV5) {
> +		err = irq__init_irq_offset(0);
> +		if (err)
> +			goto out_err;
> +	}
>  	vgic_is_v5 = type == IRQCHIP_GICV5;
>  	return 0;
>  
> diff --git a/include/kvm/irq.h b/include/kvm/irq.h
> index 2a3f8c9d..17113979 100644
> --- a/include/kvm/irq.h
> +++ b/include/kvm/irq.h
> @@ -23,6 +23,7 @@ extern struct msi_routing_ops *msi_routing_ops;
>  extern struct kvm_irq_routing *irq_routing;
>  extern int next_gsi;
>  
> +int irq__init_irq_offset(u8 offset);
>  int irq__alloc_line(void);
>  int irq__get_nr_allocated_lines(void);
>  
> diff --git a/irq.c b/irq.c
> index cdcf9923..7c4bfec4 100644
> --- a/irq.c
> +++ b/irq.c
> @@ -8,6 +8,7 @@
>  #include "kvm/irq.h"
>  #include "kvm/kvm-arch.h"
>  
> +static u8 irq_offset = KVM_IRQ_OFFSET;
>  static u8 next_line = KVM_IRQ_OFFSET;
>  static int allocated_gsis = 0;
>  
> @@ -18,6 +19,18 @@ struct msi_routing_ops *msi_routing_ops = &irq__default_routing_ops;
>  
>  struct kvm_irq_routing *irq_routing = NULL;
>  
> +/* Override the default offset before the first IRQ allocation. */
> +int irq__init_irq_offset(u8 offset)
> +{
> +	if (irq__get_nr_allocated_lines())
> +		return -EBUSY;
> +
> +	irq_offset = offset;
> +	next_line = offset;
> +
> +	return 0;
> +}
> +
>  int irq__alloc_line(void)
>  {
>  	return next_line++;
> @@ -25,7 +38,7 @@ int irq__alloc_line(void)
>  
>  int irq__get_nr_allocated_lines(void)
>  {
> -	return next_line - KVM_IRQ_OFFSET;
> +	return next_line - irq_offset;
>  }
>  
>  int irq__allocate_routing_entry(void)
> -- 2.34.1
> 

Perhaps should be split into:
- changes in generic infrastructure
- plumbing of GICv5

Cheers
Vladimir
