Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFBFB1BBBEA
	for <kvmarm@lists.linux.dev>; Mon, 10 Feb 2025 18:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739211157; cv=none; b=H+B04aLE7/wxPGLsbVCn0apO5XCqF/JaHgs5EPKYlbmgAFwzakx6PAIkFEm2b3CzXI9YI9X/ROSG9ZG77ptHWCIJaWP3uYiEvW3Kt6bpag5rdQWjJNj5Of+Zy46XX7VKwRnXG1xz82AhuSqoKBJpxDnhnVqP7fFwqHZt3+Rky6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739211157; c=relaxed/simple;
	bh=KGU94NB2q4RwCucjukyrOb4T3rjEuQVWP0ukifA0Kxw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LLp/NmLy8Wk/YV25bjXlQHl5AGN3UZksfmwbcXFi06ykR+NEa/CwvILOFIJO2xzKSx7v7Fn2hjNSOmpVJVm++8LwtGl++EP+RhWowMeO4avrSJ2156MQP92LyccUEKcQFwaIjU/TzEod/jKEHnvQ03gsJuwd4AI0kedHsdBiQrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TVf+uKDD; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TVf+uKDD"
Date: Mon, 10 Feb 2025 10:12:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1739211143;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oLebe+jzGLux7DSpw2Ptd+bTvs2CJro4ymjhGMecT2s=;
	b=TVf+uKDDvKnu/oeSc93C892wJYH60SLMrlWI3XwVY0HrADEZScMSzN8qkJz96sq1PHBhYk
	UfaZKCjoDAr0sYpQKz9CChwj3KLaQZQKZMTvW6A2WVjgpmt/aGVdRvxcyp0er5maX+DqrJ
	V+9T5NjYbngj+ESa2xauSK9bopNaUSk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sebastian Ott <sebott@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Cornelia Huck <cohuck@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] KVM: arm64: Allow userspace to change MIDR_EL1
Message-ID: <Z6pBd0XgEvrMoLcS@linux.dev>
References: <20250210154953.27002-1-sebott@redhat.com>
 <20250210154953.27002-2-sebott@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250210154953.27002-2-sebott@redhat.com>
X-Migadu-Flow: FLOW_OUT

Hi Sebastian,

On Mon, Feb 10, 2025 at 04:49:50PM +0100, Sebastian Ott wrote:
> Enable VMMs to write MIDR_EL1 by treating it as a VM ID register.
> Since MIDR_EL1 is not handled as a proper arm64_ftr_reg apply only
> a sanity check against the writable mask to ensure the reserved
> bits are 0.

How exactly does the VMM's MIDR_EL1 find its way to the guest? VPIDR_EL2
is still set to the hardware value.

> @@ -2021,7 +2037,11 @@ static int set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
>  		return ret;
>  	}
>  
> -	ret = arm64_check_features(vcpu, rd, val);
> +	if (skip_feature_check(id))
> +		ret = arm64_check_mask(rd, val);
> +	else
> +		ret = arm64_check_features(vcpu, rd, val);
> +

Can you add a new implementation of ->set_user() for MIDR/REVIDR/AIDR
instead?

> @@ -2542,6 +2571,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  
>  	{ SYS_DESC(SYS_DBGVCR32_EL2), undef_access, reset_val, DBGVCR32_EL2, 0 },
>  
> +	{ ID_DESC(MIDR_EL1), .set_user = set_id_reg, .visibility = id_visibility,
> +	  .reset = reset_midr_el1, .val = (u32)-1 },

nit: GENMASK() instead of truncation by casting.

-- 
Thanks,
Oliver
