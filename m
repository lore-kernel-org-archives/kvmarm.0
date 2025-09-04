Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAB0F23BCFD
	for <kvmarm@lists.linux.dev>; Thu,  4 Sep 2025 10:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756981514; cv=none; b=ZCi3tO6jwmQ5R5DIHqIPpRQMIRWgxfpbKz0RdXb5NHQ3rwBTWvYRPBmGuUuQ5GwVweCMk9TGxCNRLhE+7NVO3OB+TKLr+EVQE5/P5g3xUNqgdvUMx3kE0BHinStSRE4uPsP4rbR7fr4TYOu2nIUmSSBgTLVZlZmIRfLCt+rcepc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756981514; c=relaxed/simple;
	bh=7B6tRAQ/x6uPj4Np1+EaCweR3Eh37F1jHsIKSD7AWJo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KHn8HnNoHYvwelo1m+dCOnM7BmwdAiWENMbAFT6i2PlZULwyJQoBLVlgMA9TnYxeVFUJONZPfx9lBOl7+TVlrTBNgCNCN3jPIKhqx+k2S0JS/T7vN87pa5k56kmbi1OI3tXqd7Nxwfl/YlbfHeZ+mcirrkIBYjevyCkml7H7Los=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 921321756;
	Thu,  4 Sep 2025 03:25:02 -0700 (PDT)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E362B3F63F;
	Thu,  4 Sep 2025 03:25:09 -0700 (PDT)
Message-ID: <308ef1ea-f81c-4081-b664-a55e77de81d6@arm.com>
Date: Thu, 4 Sep 2025 11:25:08 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] KVM: arm64: vgic-v3: Indicate vgic_put_irq() may take
 LPI xarray lock
To: Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>
References: <20250904062348.223976-1-oliver.upton@linux.dev>
 <20250904062348.223976-6-oliver.upton@linux.dev>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <20250904062348.223976-6-oliver.upton@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Oliver,

On 9/4/25 07:23, Oliver Upton wrote:
> The release path on LPIs is quite rare, meaning it can be difficult to
> find lock ordering bugs on the LPI xarray's spinlock. Tell lockdep that
> vgic_put_irq() might acquire the xa_lock to make unsafe patterns more
> obvious.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arch/arm64/kvm/vgic/vgic.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
> index a21b482844ce..e61b95167ed1 100644
> --- a/arch/arm64/kvm/vgic/vgic.c
> +++ b/arch/arm64/kvm/vgic/vgic.c
> @@ -142,6 +142,9 @@ void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq)
>  {
>  	struct vgic_dist *dist = &kvm->arch.vgic;
>  
> +	if (irq->intid > VGIC_MIN_LPI)
> +		might_lock(&dist->lpi_xa.xa_lock);
> +

nit: Use >= rather than > to include all LPI.

>  	if (!__vgic_put_irq(kvm, irq))
>  		return;
>  

Thanks,

Ben

