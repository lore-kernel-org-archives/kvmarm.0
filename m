Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD6272D0C83
	for <kvmarm@lists.linux.dev>; Fri, 24 Oct 2025 19:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761335656; cv=none; b=f9QCFzTx4NdxHfAsOvn/YngFuGswa4SOHsrPYNlejCBDMYAXww3k6/q91Eq8h+iFA0DHlCT6Q4GoISAi5X7TVliOW76CVPgm1462Kq+j8Q1AnjoQPIipKycQk7B7iaeMaRISbHHqap1R99vUJRilnOkLSr51Bj9yUpGlc9JIXi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761335656; c=relaxed/simple;
	bh=LpKWWkFR3CITTmpCL8ZuWDQBEP4742Iavukkvxrjjp0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GBz1S2ddTigV8r72J3UzVUR8DUB/3MrKc4ar3Pl72JZIH/ECBOV3cSGk/ZPjqrGYWM6YjhVP+NORLIxsb5aZD/1P8Euy7DK+9Uj1nRjv35kcPprgDmWxNWIViRsYzEKRKG66sKFZ3ws2hkLdWMB9aXCHddeOQwECWes/WPp4YQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jEMnp6kC; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jEMnp6kC"
Date: Fri, 24 Oct 2025 12:54:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761335652;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TluhHDVhZ7Q4e/zc1etRAVmQqRxZpavPzTy3fxZcCts=;
	b=jEMnp6kC4kWVUrNW6+DJHdUsB3AZjvBLHmaFN9WvAzSLLto9i/tI/2jJMkyC1i+FKjTWIX
	55KKAd4HhSpp0QwdjD9n8Sr2xd2hwOxUAWWziHFbcVt4oODcuee/d9RxiUkylL0WtXDfBk
	wWjCRUXOs4qs3PCdwRpmAXWo9MigZr0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Zhou Wang <wangzhou1@hisilicon.com>
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	yangyccccc@gmail.com, prime.zeng@hisilicon.com, xuwei5@huawei.com
Subject: Re: [PATCH v6 3/7] KVM: arm64: Handle DABT caused by LS64*
 instructions on unsupported memory
Message-ID: <aPvZWY57ppqqWm50@linux.dev>
References: <20251024090819.4097819-1-wangzhou1@hisilicon.com>
 <20251024090819.4097819-4-wangzhou1@hisilicon.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251024090819.4097819-4-wangzhou1@hisilicon.com>
X-Migadu-Flow: FLOW_OUT

Hi Zhou,

On Fri, Oct 24, 2025 at 05:08:15PM +0800, Zhou Wang wrote:
> +/**
> + * kvm_inject_dabt_excl_atomic - inject a data abort for unsupported exclusive
> + *				 or atomic access
> + * @vcpu: The VCPU to receive the data abort
> + * @addr: The address to report in the DFAR
> + *
> + * It is assumed that this code is called from the VCPU thread and that the
> + * VCPU therefore is not currently executing guest code.
> + */
> +void kvm_inject_dabt_excl_atomic(struct kvm_vcpu *vcpu, u64 addr)
> +{
> +	u64 esr;
> +
> +	/* Reuse the general DABT injection routine and modify the DFSC */
> +	kvm_inject_sea(vcpu, false, addr);

This potentially injects a nested SEA which I'm not sure you want. There
still is an interaction with nested, from DDI0487L.a B2.2.6:

  For the EL1&0 translation regime, if the atomic instruction is not
  supported because of the memory type that is defined in the first
  stage of translation, or the second stage of translation is not
  enabled, then this exception is a first stage abort and is taken to
  EL1. Otherwise, the exception is a second stage abort and is taken to EL2.

We don't need to worry about the S1 memory type since hardware will
handle that for us. But we do need to consider whether the guest
hypervisor enabled stage-2 translation or not and route accordingly.

int kvm_inject_nested_excl_atomic(struct kvm_vcpu *vcpu, u64 addr)
{
	u64 esr = FIELD_PREP(ESR_ELx_EC_MASK, ESR_ELx_EC_DABT_LOW) |
		  FIELD_PREP(ESR_ELx_FSC, ESR_ELx_FSC_EXCL_ATOMIC) |
		  ESR_ELx_IL;

	vcpu_write_sys_reg(vcpu, addr, FAR_EL2);
	return kvm_inject_nested_sync(vcpu, esr);
}

int kvm_inject_excl_atomic(struct kvm_vcpu *vcpu, u64 addr)
{
	if (is_nested_ctxt(vcpu) && (vcpu_read_sys_reg(vcpu, HCR_EL2) & HCR_VM))
		return kvm_inject_nested_excl_atomic(vcpu, addr);

	__kvm_inject_sea(vcpu, false, addr);
	esr = vcpu_read_sys_reg(vcpu, exception_esr_elx(vcpu));
	esr &= ~ESR_ELx_FSC;
	esr |= ESR_ELx_FSC_EXCL_ATOMIC;
	vcpu_write_sys_reg(vcpu, esr, exception_esr_elx(vcpu));
	return 1;
}

Thanks,
Oliver
