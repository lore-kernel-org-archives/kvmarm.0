Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57C7F2749C8;
	Mon, 19 May 2025 11:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747653204; cv=none; b=dFci2vqmjP7F9La62m/k4nW/ne1yD3yOkoSWYXD97uVE86fkjEHhyAS++AowgVFYeI33P2HEig3gjNgJUkCEXfqnWAuFvQAg5MS0ewLbNqunKeVLEjmeKPKtVeIYoxHKdjcxushHH6pRIiPZCGOG3ClLxd4kzhu4os7wBgXMG5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747653204; c=relaxed/simple;
	bh=YcufbpuTBeyN+hUjFALoDwbhHl+o5XaWxiPAMRJKtWo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dLcsO6752CwuLPo9G0rbcH1S+2CsWIdQqKNMVvh99w2yQNhkcuqdW8L601vgav1z5QA5+Myp2ut7gayLfP0q5RxW/fEe6gFfB4dNbtppbJvv8WQbEvcoejaVA+CF1dWaVOL/1/+iR9RxXpEqDN5Nb0P6qEAz9gTsjaP1REOMf1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bo2IQ8kn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bo2IQ8kn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49DF9C4CEE4;
	Mon, 19 May 2025 11:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747653204;
	bh=YcufbpuTBeyN+hUjFALoDwbhHl+o5XaWxiPAMRJKtWo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bo2IQ8kn9q53ZeZxv3v9t240uzKWkWH2oLFzQoVk7r1byOrUuYIUeKxzhg//cGkY/
	 wy4cyyD8eI1I2Grg0X2utXExDZo1glPtoz6OMFmuiLV2ElnVve1ZIXHTPx1Ejod5UA
	 1gd8fO4rxLGBsr1OiIxud+HZPbLakAEM9QqPDQS+DIZiBPU1ZF/HMd4JEz6qWVjDqL
	 pucPmz8bw2cCjkj010ZLLRKyoxwMM1ZH8OnYlQ1i+DMTQ58ZLlBLH4lJ0UfzI/PfPq
	 mWS80HRv3x7mGoBBGe5sR2I7Bd0JiIXjKgujzORr0+ncRkzldA1lVmRPP5hY2RKsTW
	 dRNEEIMfzvGSg==
Date: Mon, 19 May 2025 12:13:17 +0100
From: Will Deacon <will@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: D Scott Phillips <scott@os.amperecomputing.com>,
	James Clark <james.clark@linaro.org>,
	James Morse <james.morse@arm.com>, Joey Gouly <joey.gouly@arm.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Shiqi Liu <shiqiliu@hust.edu.cn>,
	Yicong Yang <yangyicong@hisilicon.com>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] arm64: errata: Work around AmpereOne's erratum
 AC04_CPU_23
Message-ID: <20250519111313.GA16690@willie-the-truck>
References: <20250513184514.2678288-1-scott@os.amperecomputing.com>
 <aCsOc7VeJTJFk-x6@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aCsOc7VeJTJFk-x6@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, May 19, 2025 at 11:56:51AM +0100, Catalin Marinas wrote:
> On Tue, May 13, 2025 at 11:45:14AM -0700, D Scott Phillips wrote:
> > On AmpereOne AC04, updates to HCR_EL2 can rarely corrupt simultaneous
> > translations for data addresses initiated by load/store instructions.
> > Only instruction initiated translations are vulnerable, not translations
> > from prefetches for example. A DSB before the store to HCR_EL2 is
> > sufficient to prevent older instructions from hitting the window for
> > corruption, and an ISB after is sufficient to prevent younger
> > instructions from hitting the window for corruption.
> > 
> > Signed-off-by: D Scott Phillips <scott@os.amperecomputing.com>
> > Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
> 
> For the core arm64 bits:
> 
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> 
> Marc, Will - any preference on how this should go in (kvm or arm64
> trees)?

I think it makes most sense to go via the kvm tree based on the diffstat.

Cheers,

Will
