Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35E0714D2A3
	for <kvmarm@lists.linux.dev>; Tue, 20 Aug 2024 23:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724196830; cv=none; b=bsUzr2floJooffNWr7FZSX1KapmcoDVCDNF/DIyT7bcYyHPSqyYgv+xNivfwNeRpkIPywYxfYhZCxX3LAh6SYKW7BIc8lERe/7rRhppYkrcZrk9nZqoF4BTZWdxVmG9Nr8PdMBnCrn7G1GbOjFM9r8cxy2aPFymu9oVH/TV1d1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724196830; c=relaxed/simple;
	bh=BKHJHbHa19Ih2gq/65r1haup2z8NnQNS+f8PkCCH9Og=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iADB6IKz6y19vjywFH8uboQHznKO4Xb1hp1yQGK5468kIxgfogsEo8iLH6hBW4SOyx2iQq5eW4oXFfksh8bQuBbC1T+vcAerKS0d30e4TIdbkckkojEsVKW8jHDgtPSbfrtujDbM8D0gz4wMYb4J8OsNkfk9fpQKFo9kRpyZ+T8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=N0XgiVxF; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="N0XgiVxF"
Date: Tue, 20 Aug 2024 16:33:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724196826;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pwtQbLYsFWwvfXXtgan0g6RHZJGMppl5MqjZKi/sPao=;
	b=N0XgiVxFcOhGDMyiWiGS98Cz/VCq3n0Z+pgSMRTwv2GH/Q5e0cPDpWKiH/BqXVumxvQX3+
	b2/5+regFQBHfgrqfBPukxC15aciH5i8T7nLdfSssAGHQniZo9mFIrGU16Q+l47nQOX95S
	+SMn5Awjl/Ifua6k6MCz29aiO2QYpkA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexander Potapenko <glider@google.com>
Subject: Re: [PATCH 04/12] KVM: arm64: Force GICv3 traps activa when no
 irqchip is configured on VHE
Message-ID: <ZsUn1E6Gytu40iOW@linux.dev>
References: <20240820100349.3544850-1-maz@kernel.org>
 <20240820100349.3544850-5-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240820100349.3544850-5-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

s/activa/active/

On Tue, Aug 20, 2024 at 11:03:41AM +0100, Marc Zyngier wrote:
> On a VHE system, no GICv3 traps get configured when no irqchip is
> present. This is not quite matching the "no GICv3" semantics that
> we want to present.
> 
> Force such traps to be configured in this case.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/vgic/vgic.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
> index 974849ea7101..2caa64415ff3 100644
> --- a/arch/arm64/kvm/vgic/vgic.c
> +++ b/arch/arm64/kvm/vgic/vgic.c
> @@ -917,10 +917,13 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
>  
>  void kvm_vgic_load(struct kvm_vcpu *vcpu)
>  {
> -	if (unlikely(!vgic_initialized(vcpu->kvm)))
> +	if (unlikely(!irqchip_in_kernel(vcpu->kvm) || !vgic_initialized(vcpu->kvm))) {

Doesn't !vgic_initialized(vcpu->kvm) also cover the case of no irqchip
in kernel?

-- 
Thanks,
Oliver
