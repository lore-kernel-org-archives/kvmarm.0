Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01EC725EF8E;
	Wed, 21 May 2025 10:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747823145; cv=none; b=eCm/HHluTY6QyWUwZnzW8Rw9AazaR/4n4GCB6bI7vh8BX2BsG1qhzjpQf+ylQhSnPNjsC4EWCPaP6HZNGVQF2/WDu7/5B3ogS4aObZXUu8cPAMB5R3U+OhWr4ZTHI2EEUe9xNxB+qFvA3/YhGQprCjhPKvKfGn2fQHJm0B2Mwww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747823145; c=relaxed/simple;
	bh=2rnn78Rg+0MJvcpNO0QmApgpbowTQNaRIFKgkHlV634=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U2tUQ3bRPGfzVS6HaksC7C1nnlA9iUl6BgI3BghFES+SkBOUGZAfBO7Iy5VkJQulIyMpxxSZUoI8cQlRSISv3TOKjMFAmsJZNQ+yAjzsV0xpHxuL7ncu8r+R2H4TCXx2FJkvWT1XcPzZ7LHG8oEq28BbZ2105T5uSQ0uTq9ZWEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HmBQZUyh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HmBQZUyh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64C87C4CEE4;
	Wed, 21 May 2025 10:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747823143;
	bh=2rnn78Rg+0MJvcpNO0QmApgpbowTQNaRIFKgkHlV634=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HmBQZUyhvpsh3EvDn3MzLqKaHntr0CCNTEDv7alMsao7no5ZyKQi2ZZNaO92GzaqE
	 mSiMYAn6JjPfyMcvVuf0KAlwYfV7oeCklVCdqZzLh2XLH5w77I/dPvKIqrbCF4W0QH
	 dWn0Y+OxNRuq+BJ3xzO7VyvUaBXonXl5ZJ8gigkaUlJ4PBdzLRlTPbvjHRLwM8jOTy
	 aX2TT04tGejpPcx48bblp314iCgjs8Df7RjonT2su4TcB5cxJ1t8dj6bQDAkvZuOlB
	 gx+8zihzIni8NPXS/dFAOkgOYOwVpaB8Hx3sFBuqTNMRQQOtJglesXM9aQhNaIi/er
	 6Y6NTigmcHtjw==
Date: Wed, 21 May 2025 11:25:37 +0100
From: Will Deacon <will@kernel.org>
To: "Rob Herring (Arm)" <robh@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	James Clark <james.clark@linaro.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Leo Yan <leo.yan@arm.com>, linux-arm-kernel@lists.infradead.org,
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, kvmarm@lists.linux.dev,
	Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v22 2/5] arm64: el2_setup.h: Make __init_el2_fgt labels
 consistent, again
Message-ID: <20250521102536.GB20245@willie-the-truck>
References: <20250520-arm-brbe-v19-v22-0-c1ddde38e7f8@kernel.org>
 <20250520-arm-brbe-v19-v22-2-c1ddde38e7f8@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250520-arm-brbe-v19-v22-2-c1ddde38e7f8@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, May 20, 2025 at 05:27:37PM -0500, Rob Herring (Arm) wrote:
> From: Anshuman Khandual <anshuman.khandual@arm.com>
> 
> Commit 5b39db6037e7 ("arm64: el2_setup.h: Rename some labels to be more
> diff-friendly") reworked the labels in __init_el2_fgt to say what's
> skipped rather than what the target location is. The exception was
> "set_fgt_" which is where registers are written. In reviewing the BRBE
> additions, Will suggested "set_debug_fgt_" where HDFGxTR_EL2 are
> written. Doing that would partially revert commit 5b39db6037e7 undoing
> the goal of minimizing additions here, but it would follow the
> convention for labels where registers are written.
> 
> So let's do both. Branches that skip something go to a "skip" label and
> places that set registers have a "set" label. This results in some
> double labels, but it makes things entirely consistent.
> 
> While we're here, the SME skip label was incorrectly named, so fix it.
> 
> Reported-by: Will Deacon <will@kernel.org>
> Cc: Dave Martin <Dave.Martin@arm.com>
> Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
> ---
> This one can be applied even if the rest of the series is not.

Cheers, Rob. I'll grab this one.

Will
