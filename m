Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E6C15C158
	for <kvmarm@lists.linux.dev>; Tue, 30 Sep 2025 00:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759192872; cv=none; b=J4grQNslJz/zUcXa+PlLiXdIvPnfYYYRFOtMG5IAQRXohOAK2x9VvG58Tr/+OTtw9ghvMjMZLdl/DHorUFMMg0LTyojy9MHIPh6HEoQ73OJjN51lZWq0My0/E8rmsGMeofC9FlpNOpOWhcCBiFTSwcVn+KSZr460KHy6CZpTpoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759192872; c=relaxed/simple;
	bh=xNGfxvXwebFTFuKGAKsECpF1yxmK6Bzc5LgyjKt0Qjg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UZ3vD4W/u1zK5hZas1sa1xgc3pSknbuJbplEfjuK1qoq7WTwbUQ8N+MhV+xYsadMt5KSUSYksGUufFb8Kp2BpUeBrvJlKaMUrN8d8Ke8Yl8jEa7H+MXNRuwgHbGaIOM3Oc64S6o5h9ak7/aUwSjBqCxii2pfR8AqLy6153zdDgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vQstJueR; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vQstJueR"
Date: Mon, 29 Sep 2025 17:41:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759192867;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=al7NVeWVCt6wvSuuBxYz51Qa667pYwu4Fk/SDCBU8o0=;
	b=vQstJueROGg1w9KYIsYzevZvj3jdAImXxYvZHg6r0xf7aDZpDUjKTklTa23GulRsOgMbzp
	4GJHGn7COhl1od6DtkQORkHPigpwCeXXC1lVpRpGNjgvHP+/0Aqm5ix8LMKrsGsxR+GiNH
	6XeSzLIpbzFIxKg4si7NhCs8RxIgtkg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 05/13] KVM: arm64: Add timer UAPI workaround to sysreg
 infrastructure
Message-ID: <aNsnHUTaHgrql07j@linux.dev>
References: <20250929160458.3351788-1-maz@kernel.org>
 <20250929160458.3351788-6-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250929160458.3351788-6-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Mon, Sep 29, 2025 at 05:04:49PM +0100, Marc Zyngier wrote:
> Amongst the numerous bugs that plague the KVM/arm64 UAPI, one of
> the most annoying thing is that the userspace view of the virtual
> timer has its CVAL and CNT encodings swapped.
> 
> In order to reduce the amount of code that has to know about this,
> start by adding handling for this bug in the sys_reg code.
> 
> Nothing is making use of it yet, as the code responsible for userspace
> interaction is catching the accesses early.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 33 ++++++++++++++++++++++++++++++---
>  arch/arm64/kvm/sys_regs.h |  6 ++++++
>  2 files changed, 36 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 9f2f4e0b042e8..8e6f50f54b4bf 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -5231,15 +5231,28 @@ static int demux_c15_set(struct kvm_vcpu *vcpu, u64 id, void __user *uaddr)
>  	}
>  }
>  
> +static u64 kvm_one_reg_to_id(const struct kvm_one_reg *reg)
> +{
> +	switch(reg->id) {
> +	case KVM_REG_ARM_TIMER_CVAL:
> +		return TO_ARM64_SYS_REG(CNTV_CVAL_EL0);
> +	case KVM_REG_ARM_TIMER_CNT:
> +		return TO_ARM64_SYS_REG(CNTVCT_EL0);
> +	default:
> +		return reg->id;
> +	}
> +}
> +

Seems like a good spot to name n' blame the commit that introduced this
bug as a comment.

Thanks,
Oliver
