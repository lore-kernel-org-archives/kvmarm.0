Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8AF61AF0BA
	for <kvmarm@lists.linux.dev>; Thu, 30 Jan 2025 21:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738273292; cv=none; b=hCI2JEAF1a7Ywrc+PKz0C3IkkOUOt5tQFwybLF6CJOjZN2FZ0CCEGFU0ZhJyUl6JuXQsc6YWjo245NdJxO++HPf+0pBpiv81t9P52LpMyDJgUGqx68YjikPRSjHOMEEq+UkEZmxo6uJlXNcbC4eKGeNOMA0CLQQcfD4newMPheI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738273292; c=relaxed/simple;
	bh=FPTNXf/h9CuzGMdcgXwJERrwzTDmKl9zLynfQdw9tZ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=toAlJYJthCDgQOjcsMO+9POPSoqLDxPLVTquYNzHNzrjMf+IPC9F6jaoIcbBRbVqEOmdk11FO5gKnJ8CN4SomQZ9/lsaBUAEPzGl17449Msft//4GnwGrFwVpMbOCLqt0h68uveGAEJ/IGWpZ5yZ+LBSiMY+XmcBsxSnvLMObXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LA2qhgbZ; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LA2qhgbZ"
Date: Thu, 30 Jan 2025 13:41:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1738273282;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ojmpRg/HOY6aK9s6IqWiNPKBEyVR6Jj69/+3d+ZdCh4=;
	b=LA2qhgbZmA6VzVvZVSo1cYrCXUmkBVvxEKcPO74NlnJvQxCgsXQGYyGA7SdoUveUNOkTQ5
	AOtsUnlqpOdDHYn7KpcAkDxoDu15xW+NZV3vb+7JHsrsC1F65p0FoDir5helebx0FjhwFm
	mS+2QQfSAySHTzLyIM0x7ZPQTeJQ5dg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Wei-Lin Chang <r09922117@csie.ntu.edu.tw>,
	Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>,
	Dmytro Terletskyi <Dmytro_Terletskyi@epam.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 3/3] KVM: arm64: timer: Consolidate NV configuration of
 virtual timers
Message-ID: <Z5vx8NVN8lF6QuJz@linux.dev>
References: <20250128161721.3279927-1-maz@kernel.org>
 <20250128161721.3279927-4-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250128161721.3279927-4-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

> +void kvm_timer_vcpu_nv_init(struct kvm_vcpu *vcpu)
> +{
> +	/*
> +	 * A vcpu running at EL2 is in charge of the offset applied to
> +	 * the virtual timer, so use the physical VM offset, and point
> +	 * the vcpu offset to CNTVOFF_EL2.
> +	 *
> +	 * The virtual offset behaviour is "interesting", as it always
> +	 * applies when HCR_EL2.E2H==0, but only when accessed from EL1 when
> +	 * HCR_EL2.E2H==1. Apply it to the HV timer when E2H==0.
> +	 */

I'm definitely being pedantic, but all the talk of an HV timer when
E2H==0 isn't sitting well with me. Since a programmable E2H has gone
out the window there isn't such thing as an HV timer when E2H==0, as
FEAT_VHE isn't implemented for the VM.

And along those lines, accesses to CNTHV_*_EL2 registers should undef
when FEAT_VHE isn't implemented for the VM but I don't think we have any
enforcement of that.

-- 
Thanks,
Oliver
