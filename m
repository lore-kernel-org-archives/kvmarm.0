Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD2BD46D558
	for <kvmarm@lists.linux.dev>; Mon,  5 Oct 2026 12:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791202263; cv=none; b=t6PzQxlyiy3Zj1kUP7TFzeh7NDM2WLmX5IFg+Uibti1YAdkFKyujMySKQbqIvXHkN01wAdt4gI8reR2v9hvvDtSh9h32qIaUKGqKrNrl4Mor+xrVydtgchFl/AOjeLCd04kKrYE2SP3y3f756vfy+rrrDl6f3YInqSLJRPIKIuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791202263; c=relaxed/simple;
	bh=f0uib9eMHl81tzc+EqAfrcIxoFi4MWrxxKPr85f9QCE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lzi0wukxg2dfNUuVwy5Aims924h7gm0zpRwcbL2hswr80rV9gU9XvRsj8FOEUz4A2NK9r/uVfaL74TBRxlk+U9hR7FczINXqn+D9ZXWES0DgiOg8dIe9ERHw/2+4pb3Svlm4s2tF38Fo6fuIBTq6bZv3MRfDbeiyCaiHDfAQb8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KlY3ULAw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KlY3ULAw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 059FB1F000FF;
	Mon,  5 Oct 2026 12:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791202262;
	bh=f0uib9eMHl81tzc+EqAfrcIxoFi4MWrxxKPr85f9QCE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KlY3ULAwEo0SmWdc+EGl/5eTNPos2ssNKzNs4Vx9kPXwGMCvuYHiXqhTf935U3Siz
	 mMFPezPH1itjem0CcEus1PEX8iwup2+pTX0tcEqzh4Z1zPKSqFmwBcRjLcBL19EhuC
	 VjPk87y9hrjRt4uP/fOxm6SdkGXvIqYN09U/B/meU2XCAcXKmn+HDRdWUFaZTbCIeR
	 HXNisfDkfpQTDNz9pfMCV3ibrgv2oS2832pIh6xBcBjod6NB3UapzexWJiTrU4zzLK
	 P5VreISqLLUjb+HOm43OrCG2o9JpTqeZJdbO9ySjDB4sWzJn/F1oP3bU9F8m2zCLhf
	 HSBlWW7NLgDSg==
Date: Mon, 5 Oct 2026 05:10:55 -0700
From: Oliver Upton <oupton@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Matthias Goergens <matthias.goergens@gmail.com>,
	Steffen Eiden <seiden@linux.ibm.com>, fuad.tabba@linux.dev,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [RFC PATCH] Documentation/process: Add a maintainer entry
 profile for KVM/arm64
Message-ID: <asOTzzNU7foTo9KA@kernel.org>
References: <20260924033536.3624334-1-matthias.goergens@gmail.com>
 <877bkb3zjq.wl-maz@kernel.org>
 <20260924083036.1744194-1-matthias.goergens@gmail.com>
 <875wzu4vuv.wl-maz@kernel.org>
 <20260925085621.562448-1-matthias.goergens@gmail.com>
 <87tsnb2dtq.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tsnb2dtq.wl-maz@kernel.org>

On Sun, Sep 27, 2026 at 11:22:57AM +0100, Marc Zyngier wrote:
> This otherwise looks pretty good to me. Let's see what Oliver says,
> but I'm otherwise inclined to take something like this in 7.4.

I haven't had time to review this in detail but I'm not generally
opposed to better documentation. Post as a patch and I'll make an
effort to review.

Thanks,
Oliver
