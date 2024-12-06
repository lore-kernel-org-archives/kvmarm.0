Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A49D6BE46
	for <kvmarm@lists.linux.dev>; Fri,  6 Dec 2024 01:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733446953; cv=none; b=lOTfn191H9rSUZEtkuNyT3q3NpdkFmw5uMF2n8BLYN1qt8Z8IwTvQdmRNdQ0BCR63CNYvjHvlhkGYnVmC7FzP9rEQc9W3u29qP0syHYStuE355Ew4BLJYorpvtQ1aac2T93xQ1dPT5kjSXaexXCkj7tN7ZS5Fl8Gr8lhSaqHD9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733446953; c=relaxed/simple;
	bh=lgnFJkgE1myppuaRqPoNT78R33iUivWXcbS8nzbDK5Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ohXrSbeZro3B0E/oyRBaJ5F8lbhtrGtsfrfDZ/nDCSu62FZw8uaRc1wPRn+Re8XEMOwowueDBZPCW3KReSD183qzA1HvCPZE+Y3O6CtHbPfoG9ClOdRnaGv6gDU35pMqwRjcg9C9fys0+u7d8JBMDR7QPeRQjl+n0z/V8Dv+3kQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LnFLkWHK; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LnFLkWHK"
Date: Thu, 5 Dec 2024 17:02:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1733446948;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=smpLQ5EAUCvdQcQ3ttJAsHL74T4TA9p4kd4Dy6c0FwA=;
	b=LnFLkWHKDniXpH26xNfkwnzM+l7kT59CELP4eEEoZNSXSsO/8IUIR2wexIbM5dgPSX6JfP
	7MI7UWHw61lwWPAZEa+8I6cECCuKh686cgtuMUSU3uwg1nPFf/3dr5rBTl6hPvRixXFpip
	g7l1BZ4DUv1jXEE/Mp36zFH7n4VP15E=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, james.clark@linaro.org, will@kernel.org,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, broonie@kernel.org, qperret@google.com,
	kristina.martsenko@arm.com
Subject: Re: [PATCH v4 05/14] KVM: arm64: Initialize feature id registers for
 protected VMs
Message-ID: <Z1JNGmcZka1hl2ha@linux.dev>
References: <20241202154742.3611749-1-tabba@google.com>
 <20241202154742.3611749-6-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241202154742.3611749-6-tabba@google.com>
X-Migadu-Flow: FLOW_OUT

Hi Fuad,

On Mon, Dec 02, 2024 at 03:47:32PM +0000, Fuad Tabba wrote:
> +/*
> + * Initializes feature registers for protected vms.
> + */
> +void kvm_init_pvm_id_regs(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	struct kvm_arch *ka = &kvm->arch;
> +	u32 r;
> +

Can you add an assertion that this is called while holding the
vm_table_lock? Otherwise it isn't clear why its safe to initialize
per-VM state.

> +	if (test_bit(KVM_ARCH_FLAG_ID_REGS_INITIALIZED, &kvm->arch.flags))
> +		return;
> +
> +	/*
> +	 * Initialize only AArch64 id registers since AArch32 isn't supported
> +	 * for protected VMs.
> +	 */
> +	for (r = sys_reg(3, 0, 0, 4, 0); r <= sys_reg(3, 0, 0, 7, 7); r += sys_reg(0, 0, 0, 0, 1))
> +		ka->id_regs[IDREG_IDX(r)] = pvm_calc_id_reg(vcpu, r);
> +
> +	set_bit(KVM_ARCH_FLAG_ID_REGS_INITIALIZED, &kvm->arch.flags);
> +}
> +
>  /*
>   * Checks that the sysreg table is unique and in-order.
>   *
> -- 
> 2.47.0.338.g60cca15819-goog
> 

-- 
Thanks,
Oliver
