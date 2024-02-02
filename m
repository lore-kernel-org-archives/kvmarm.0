Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B38AC1308D1
	for <kvmarm@lists.linux.dev>; Fri,  2 Feb 2024 19:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706900615; cv=none; b=f1qgabMDNw69utW6zqkjKFKG0HRTni6EP1pp9E3NPbYPXQBgeftLjlO0/fZbYISw/5+c0qwivIWGq4HTroWNTIyzTIy+NRbyV4FEEiTmrD1qlJT7sD1dxDOlP+QzRd4pzm5OHHfeS9R+9wOdjno9bMrUGQqVmPX0QoiNkV6+WvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706900615; c=relaxed/simple;
	bh=uGh3e9ihgbcK3sjjiriMVVyB8XXOqokmfn/lSULInCs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YDAeZNW9TlQIoRPEztm7/vnvX6M5GjZVJVh5/q3GUbon2XiLyXCBUMsXN55FqDiPr8lYtDX8xEm3EEaI4rzj9jCAnbXn7UIV3DZ2Xvj1nlOA4kiWeNw5J5OsUM7qiU1xVJIQ5K2D0FzyYdLqoTxNcE4kTYWwTV8Xn1WPS1b/7wE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lsO1ux64; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lsO1ux64"
Date: Fri, 2 Feb 2024 19:03:25 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706900610;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=evBFkKEKKP0LsMc6bHbbUzAu/6aHsfdZ5OMDYq25fsg=;
	b=lsO1ux64yYk95nCObYCdu+AL+bunpDjSLs4b7DNXZpKu2ZJB288FnWR9JmxQ3nKHSwR1S7
	8+iAOa707aux0vMGHmETQf+FvPmw6UOhjsGIUstEV+KoYBp+jIDoLSAMf9ahIsVcx1R+vt
	/EiAiNfRyyuasRSLLEYJTpDqlNOKM/A=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>, James Morse <james.morse@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v4 00/10] arm64: Add support for FEAT_E2H0, or lack
 thereof
Message-ID: <Zb08fXz23JUiF4hD@linux.dev>
References: <20240122181344.258974-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240122181344.258974-1-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Mon, Jan 22, 2024 at 06:13:34PM +0000, Marc Zyngier wrote:
> Since ARMv8.1, the architecture has grown the VHE feature, which makes
> EL2 a superset of EL1. With ARMv9.5 (and retroactively allowed from
> ARMv8.1), the architecture allows implementations to have VHE as the
> *only* implemented behaviour, meaning that HCR_EL2.E2H can be
> implemented as RES1. As a follow-up, HCR_EL2.NV1 can also be
> implemented as RES0, making the VHE-ness of the architecture
> recursive.
> 
> This has a number of consequences, both at boot time and for KVM,
> though the changes at that level are pretty minor.
> 
> The real meat of this series is on the cpufeature front, as FEAT_E2H0
> is a *negative* feature, where 0b1111 (-1) represents E2H being RES1
> and 0b1110 (-2) additionally indicates that NV1 is RES0. Fun, isn't
> it?

This looks good to me. Catalin + Will, are you comfortable with the
cpufeature changes at this point?

No strong opinions on which tree these patches get applied to. Most of
the series is non-KVM code, so I'd understand if y'all wanted it to go
through arm64. OTOH, there are some other KVM features that might appear
in 6.9 that build on top of this, so at minimum I'd probably need a
shared branch.

LMK what you think.

-- 
Thanks,
Oliver
