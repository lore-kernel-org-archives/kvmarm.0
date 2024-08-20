Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC54118E04F
	for <kvmarm@lists.linux.dev>; Tue, 20 Aug 2024 23:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724197829; cv=none; b=YvyIe0oWYegz2n+rJklBwfAhYJhKKRoT07V6JRxcjQFm7ae07L3vVrvhYsGpzqzrVLLLRtIQIwYrZFXEfUd8cWe1iWc7sf+w+oMbFPqkdlPxampQD/qLYkHG24Urobz147T60qqvufkD3OD6oIUVZaSnZDX/YnG+RfFN5qwxjT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724197829; c=relaxed/simple;
	bh=QkJKg3vPoOZqzqAAAi1fd5e6C7uGNd72rhiRltQXh3A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PMoXTRR+kRTe+/jJwGNwW0Y28IHE5Ahs7p7WPDvChBdqNrYEAqMhNQ9hPVtDoKX4wyM/Vj65THTPEiqElkL7uiS7lenIpAFQWK7eWHgvFYb1wv+7YXFnOGIPQ5exEpfkzt60RPAGsPulfWrq2hA7jVefXOrg/T/cfeDmH6IGYMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RsOmNM4Q; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RsOmNM4Q"
Date: Tue, 20 Aug 2024 16:50:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724197825;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Pt1udamrKjOweVawsfRN94PDF7eG1lnIpSBUiqYMMYk=;
	b=RsOmNM4Qj6hjDM7c5W9i7cea60eq/fLYMfQxyiyDZHLSe/t+VVgVT2VsEbMLUKRn8VU1ra
	+FCaQr7NZf1+6KV1EDBhjm9plMoKa9RZwA+hQ5O2V0z6UQY5ZdymDxRK1dyJEbQCeSkHNE
	zGjo+28E4NGlRKwAhdmfgDFkpKPToUw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexander Potapenko <glider@google.com>
Subject: Re: [PATCH 06/12] KVM: arm64: Zero ID_AA64PFR0_EL1.GIC when no GICv3
 is presented to the guest
Message-ID: <ZsUrukQpWqal9Zfm@linux.dev>
References: <20240820100349.3544850-1-maz@kernel.org>
 <20240820100349.3544850-7-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240820100349.3544850-7-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Tue, Aug 20, 2024 at 11:03:43AM +0100, Marc Zyngier wrote:
> In order to be consistent, we shouldn't advertise a GICv3 when none
> is actually usable by the guest.
> 
> Wipe the feature when these conditions apply, and allow the field
> to be written from userspace.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index bc2d54da3827..7d00d7e359e1 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -2365,7 +2365,6 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  		   ID_AA64PFR0_EL1_MPAM |
>  		   ID_AA64PFR0_EL1_SVE |
>  		   ID_AA64PFR0_EL1_RAS |
> -		   ID_AA64PFR0_EL1_GIC |
>  		   ID_AA64PFR0_EL1_AdvSIMD |
>  		   ID_AA64PFR0_EL1_FP), },
>  	ID_SANITISED(ID_AA64PFR1_EL1),
> @@ -4634,6 +4633,11 @@ int kvm_finalize_sys_regs(struct kvm_vcpu *vcpu)
>  
>  	guard(mutex)(&kvm->arch.config_lock);
>  
> +	if (!kvm_has_gicv3(kvm)) {
> +		kvm->arch.id_regs[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] &= ~ID_AA64PFR0_EL1_GIC_MASK;
> +		kvm->arch.id_regs[IDREG_IDX(SYS_ID_PFR1_EL1)] &= ~ID_PFR1_EL1_GIC_MASK;
> +	}
> +

Hmm, should we use the ID register field as the source of truth for
kvm_has_gicv3() at this point?

I think what you have in patch #1 makes good sense for a stable
backport. Using the ID register from this point forward would make the
behavior consistent for a stupid userspace instantiated GICv3 for the VM
but clobbered it from the ID register.

AFAICT all other usage of kvm_has_gicv3() happens after
kvm_finalize_sys_regs(), so it should take this last-minute fixup into
account.

-- 
Thanks,
Oliver
