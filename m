Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF37E4596D
	for <kvmarm@lists.linux.dev>; Tue, 30 Apr 2024 08:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714464737; cv=none; b=ZT89XbteHca2CJ7/EiEu7nNTBtyn4ZbBkKuHjpoRMiMXyNgS0ZE5EXb5hOuFKquRWV75SLatN/i3UmTnxP9Dh5Wfa7d8Dm4fV49qvsWAKZW7h3R+XTR0z25ujQVDYhsdkHEsWn0UEGAknz1VsUnI83fHioYtV3QT0FUgfManJ7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714464737; c=relaxed/simple;
	bh=vYSAJ0IkkLmf1YLuB/surS4SJAd15B43AkV2QDTo99E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OslrfsdmziS4cg/eHAos111uwkS6dcQdQoBo/TYUOJlptZHJf/1SnYtKP+Uopvn5ruMuxxN5VaO7EcXXAcNmL+z8p/Q2gf4xkz3j5UrL8zjFxKYjkT8I9KwbEQFE2zoV0rccWJPvnEAr7YGJh0QaXKYLLvv/qOBETJzwkjCTPp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=K0VbKUCA; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="K0VbKUCA"
Date: Tue, 30 Apr 2024 08:12:07 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1714464733;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dIoDBN/p9nhm2cGi2ntGgfL1tSJD5+rr/4v3UY2P0tA=;
	b=K0VbKUCARMbLyV83pCn7O3k6QfZavIhqoK+t+Xx4Fd5Y+CY+XlD5i5yhEWZyReUqsykUfs
	ZTQ3CSfxy6oFQ23v8iO8SR68HWas27KxAHkfbL8V4oOTPq/kwpJQaBQAHrhcL5w2fF8yvw
	j/tbaM5qNKn3UtQuc2WmOT1oOrRa7js=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, will@kernel.org,
	qperret@google.com, seanjc@google.com, alexandru.elisei@arm.com,
	catalin.marinas@arm.com, philmd@linaro.org, james.morse@arm.com,
	suzuki.poulose@arm.com, mark.rutland@arm.com, broonie@kernel.org,
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Subject: Re: [PATCH v4 00/30] KVM: arm64: Preamble for pKVM
Message-ID: <ZjCn11tZ-XkD3doB@linux.dev>
References: <20240423150538.2103045-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240423150538.2103045-1-tabba@google.com>
X-Migadu-Flow: FLOW_OUT

Hi Fuad,

On Tue, Apr 23, 2024 at 04:05:08PM +0100, Fuad Tabba wrote:
> Changes from V3 [0]:
> - Rebased on latest kvmarm/next (dcbf421a8c08)
> - Dropped atomic and locking patches for now, while we rework them
> - Misc fixes (Oliver)
> 
> We are getting closer to upstreaming the remaining part of pKVM
> [1]. To make the process easier for us and for our dear
> reviewers, we are sending out this patch series as a preamble to
> the upcoming patches.
> 
> This series is based on Linux 6.9-rc3 -- kvmarm/next
> (dcbf421a8c08). Most of the patches in this series are
> self-standing, and can be applied directly. Patches 1 to 13 are
> fixes.

Thanks for enduring my feedback. I think a lot of this looks good to go.
I'm not convinced that some of the patches moving/refactoring things are
a net positive _on their own_, but am happy to take them when they're
paired with the feature that depends on them.

Marc, sorry to be annoying, but for patches 1-18, 20, 25-30:

Acked-by: Oliver Upton <oliver.upton@linux.dev>

-- 
Thanks,
Oliver
