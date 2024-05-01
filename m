Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE9D9748D
	for <kvmarm@lists.linux.dev>; Wed,  1 May 2024 17:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714586248; cv=none; b=u47MAisYyZ8FLJIXV16VO+YeLfWcQL8JhXDQM8lNDXg5ZhYgcbJvhfgf7NWQ/9qtJIkAyk0np/ZHAXwVDi69b7D9Upo62y66EItGz1SwxnwNCxWJTdN8y+BnjwyUSi0qsz/i2AAkorg7szrFNKuwnWqPwqvqpBvNoFjlGl1fUO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714586248; c=relaxed/simple;
	bh=BY0t8l6BBAHssrM8PvF4e0vSBOgbuWTQTCoMSbINvtg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RBtlf+/zdmhJROohQjTCSNGYrmKE2wUMkknPtYu6M0R9Lae20QpscNyGEyoDHE1hECVB95BBPAl0k4q0WJ1D0fcEGsq/7wIsxipI6bTQD+I9/2pKt7qutXWqyvkZ9wn/2Ey71s+uxswq/wQGbJmnp0wuUbxIgjgUUeaF+kS7678=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=g2wJOg3x; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="g2wJOg3x"
Date: Wed, 1 May 2024 17:57:20 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1714586244;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Tt/PxbcUEf64em4t5RxtHA8scveQfLCnFNCRhqS43k4=;
	b=g2wJOg3xD+QENajCvslA7fX7MOIbIQkbx222rTDT80vlbwYnEHFKTTX4vWQEViXh+WRt1m
	sm2eUu+eeD7JGslpjvNFgc2iqWTdvnhu0EmGdZQGNK9/sZnWYifvX9U9EFHWhjDJV+oJT6
	dvAWNhyvSMRL9Nr7Io7liA6YiWUd+vg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc: Marc Zyngier <maz@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH RFC] KVM: arm64: allow ID_MMFR4_EL1 to be writable
Message-ID: <ZjKCgIyWqNKC6TUu@linux.dev>
References: <E1s2DPv-00AhaA-Ra@rmk-PC.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1s2DPv-00AhaA-Ra@rmk-PC.armlinux.org.uk>
X-Migadu-Flow: FLOW_OUT

Hi Russell,

On Wed, May 01, 2024 at 06:06:51PM +0100, Russell King (Oracle) wrote:
> Between 5.4 and 5.15, the guests view of HPDS, CnP, XNX and AC2
> changed their value on the same Neoverse N1 r3p1 hardware which makes
> migrating between these kernels on the host problematical.

It'd be helpful to expand a bit more on how these fields changed, better
yet if we can blame it back to a commit. I'm guessing the only direction
of migration you care about is old -> new then?

> We already permit changing HPDS in AA64MMFR1_EL1 and CnP in
> AA64MMFR2_EL1. We also allow LSM as we allow that in AA64MMFR2_EL1,
> so this patch includes support for that even though it isn't required.
> 
> Discussing with Marc Zygnier, AC2 should also be fine to be writable,

typo: Zyngier

> even though we don't inject an UNDEF if the guest accesses those
> registers.
> 
> The only questionable one is XNX, execute-never control distinction,
> which is also in AA64MMFR1_EL1 but we don't allow to be changed there.

It is quite odd for us to expose this field to non-nested VMs in the
first place, though I suppose we will apply an additional set of
restrictions for nested VMs when they come along.

-- 
Thanks,
Oliver
