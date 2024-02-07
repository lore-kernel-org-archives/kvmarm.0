Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB4D21429A
	for <kvmarm@lists.linux.dev>; Wed,  7 Feb 2024 10:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707302415; cv=none; b=TbOwYjYPvI3FrNn7OaQpZ5eKPgFHWXI97SlRbuYpGze7eP/AiatjQUWrcerthVAyweqQPg4B1pWtw7sqWeDnq0wEMqZ4VxFsdFQZInT1PAb3kRP8BLtG1C7LMpH6LxR6H01CrdcCpXltDqofsLfzExghD5RhSHKHeYokdbiOGYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707302415; c=relaxed/simple;
	bh=cAxhH+SONjD42Gw3gF+CFGXzaUkX8lnopUdQqjcQd0I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g27fCgLzXu7BNM1e0McG4IQlvMQ4MQWvU56fOAEPWoDyxVtcTtgzQQQNVBW/qDUswQw4Pt4dtk98xMKeABwyA5GezEytMv7ilJEbK7NtqV+pZWg5lMGiMLqNCMhSJdcBeGiUjRektLkIvOjKBiV7FP/Nu2eLryiVd15aEgC2hWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OVnT1IBv; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OVnT1IBv"
Date: Wed, 7 Feb 2024 10:40:08 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1707302410;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EOXmtPnFnBC290lPG3I2msiOcq62QDPQe0I4UIkLUi4=;
	b=OVnT1IBvZqREiqu4C7ANpqTXrYLU+JqRJoIk2KmilaUJC+391mgYdDXoi02OI/bkY+iCAR
	c2TPlSjx32vCnNkp1rkIcZ9MqSW4B9q6cCY5+8+0I7ug9cJ85RSbDJd75GiQdm8Kqo0Ru4
	eQhqdIsHYP/Vr7j6Ut6UntGp4/QGcjw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v3 04/26] KVM: arm64: nv: Add sanitising to EL2
 configuration registers
Message-ID: <ZcNeCACYeozbM_Dr@linux.dev>
References: <20240205103431.1104133-1-maz@kernel.org>
 <20240205103431.1104133-5-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240205103431.1104133-5-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Mon, Feb 05, 2024 at 10:34:09AM +0000, Marc Zyngier wrote:
> +	if (!(__vcpu_has_feature(&kvm->arch, KVM_ARM_VCPU_PTRAUTH_ADDRESS) &&
> +	      __vcpu_has_feature(&kvm->arch, KVM_ARM_VCPU_PTRAUTH_ADDRESS)))
> +		res0 |= (HCR_API | HCR_APK);

I think what you probably meant here is _ADDRESS and _GENERIC, right? Of
course, this has no actual effect on the code, since we don't allow one
without the other.

Maybe we can just change KVM's representation to a single flag to avoid
this pointless exercise.

> +	if (!kvm_has_feat(kvm, ID_AA64ISAR0_EL1, TME, IMP))
> +		res0 |= BIT(39);
> +	if (!kvm_has_feat(kvm, ID_AA64PFR0_EL1, RAS, IMP))
> +		res0 |= (HCR_TEA | HCR_TERR);
> +	if (!kvm_has_feat(kvm, ID_AA64MMFR1_EL1, LO, IMP))
> +		res0 |= HCR_TLOR;
> +	if (!kvm_has_feat(kvm, ID_AA64MMFR4_EL1, E2H0, IMP))
> +		res1 |= HCR_E2H;
> +	set_sysreg_masks(kvm, HCR_EL2, res0, res1);
> +
>  out:
>  	mutex_unlock(&kvm->arch.config_lock);
>  
> -- 
> 2.39.2

-- 
Thanks,
Oliver
