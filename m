Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFC57156F4A
	for <kvmarm@lists.linux.dev>; Mon, 17 Mar 2025 22:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742251130; cv=none; b=Lm1EHE6gRGmr09r1E/FW5y+T+hJ1VuwTTVFloqnL9DzXsR5dwA2umpa2E+4uJkl8/fWDDoIX4kf9pJ14eTzufTE3J0S4lQLWphZNNow7citLpExNULJvFw9Ig3mGHPGaM3iij1QDPRKLr0A/njKsjL60UQpcK/yFjBrL9sgB3r0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742251130; c=relaxed/simple;
	bh=JPnUf+neTVO1foYCHOPFK/dfIznHCLNcxHqUYvJz9BM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fw+LmxD/zItAlNBiFoO3S7a/BpUX+/wq19ESbAw5OjZccvJsh3WT0GWQp/S44cDoobMVDbms8xnf5ohTUoIdskeqZnBe2g90aBXlhCqzrSq65lzM8zFlP5qCYzrf5CAHc8vyd8V4n66tpcxMc1UPep7Ie63kI4uPF8l9tUplkfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=w73MujJE; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="w73MujJE"
Date: Mon, 17 Mar 2025 15:38:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742251125;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DuSletg3itwsifS0Pf73fBweBoBSkCY5MMD6bIiKHUM=;
	b=w73MujJEgi79uE2nYyf1yxCCBii2ix3gfNcfmwc3/fVH3HyAHE0cByR5j5iusSMQ2G7GiS
	8B7LyLZ3dAKSIiG5/txRwqw05gu8hIOZYvcaAUKRy+J1kMOgV0nJZIdpyqR+xnaw6ceaix
	8nAdgVfFYFp+GXA4tueRzn5yki05AvQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>, joey.gouly@arm.com,
	kvmarm@lists.linux.dev, maz@kernel.org, suzuki.poulose@arm.com,
	yuzenghui@huawei.com
Subject: Re: [PATCH 0/4] arm64: mitigate CVE-2024-7881 in the absence of
 firmware mitigation
Message-ID: <Z9ikak5AOtDJNVgE@linux.dev>
References: <20250128155428.210645-1-mark.rutland@arm.com>
 <174197730164.734861.6726211221092480832.b4-ty@arm.com>
 <20250317212611.GA12724@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250317212611.GA12724@willie-the-truck>
X-Migadu-Flow: FLOW_OUT

On Mon, Mar 17, 2025 at 09:26:12PM +0000, Will Deacon wrote:
> On Fri, Mar 14, 2025 at 06:37:25PM +0000, Catalin Marinas wrote:
> > On Tue, 28 Jan 2025 15:54:24 +0000, Mark Rutland wrote:
> > > On some CPUs from Arm Ltd, it is possible for unprivileged code to cause
> > > a hardware prefetcher to form an address using the contents of a memory
> > > location which is accessible by privileged accesses in the active
> > > translation regime, potentially leaking the contents of this memory
> > > location via a side channel. This has been assigned CVE-2024-7881:
> > > 
> > >   https://developer.arm.com/Arm%20Security%20Center/Arm%20CPU%20Vulnerability%20CVE-2024-7881
> > > 
> > > [...]
> > 
> > Applied to arm64 (for-next/leaky-prefetcher), thanks!
> > 
> > There hasn't been much review (thanks Oliver for looking at the KVM
> > bits) and there's some implied work that can go on top of this series.
> > But the patches looked fine to me, so I queued them. Mark or others,
> > please shout if you'd like them dropped, they are on a branch.
> 
> I'm really not comfortable with this series and would prefer to see it
> dropped while we continue the discussion, especially as it's causing
> minor conflicts with the KVM/arm64 tree in -next.

Catalin, unless you say otherwise, I'm going to assume this will be
dropped in the interim.

> The series is pitched a bit like an erratum workaround, but the overall
> problem that a memory-dependent prefetcher can bypass permission checks
> is fairly general and, even if nobody else gets this wrong, I doubt that
> it's the last time Arm will mess it up. So, while the EL3 mitigation may
> be Arm-specific, I don't think the rest of it really is. That's
> especially true given the sorry state of spectre mitigations on
> third-party derivatives of Arm designs, such as the Qualcomm Kryo parts,
> and the fact that we provide userspace with a mechanism today for
> querying the state of those mitigations via sysfs.
> 
> The immediate question, then, is whether this broken behaviour is
> prohibited by CSV3. The text in the latest Arm ARM just refers to
> "Data loaded under speculation", so it's not entirely clear whether that
> applies to a prefetcher.

Hmm, good point. I think prefetchers fall under the ARM ARM glossary
definition of speculation, which includes:

 - Operations generated by the hardware that are not directly generated
   by any instructions appearing in the Execution stream.

> If we decide to go with a new entry for this, then we also need to
> change the default behaviour along the lines of Doug's Spectre-BHB
> changes queued on for-next/spectre-bhb-assume-vulnerable so that we
> assume vulnerable if we don't know better. To do otherwise will result
> in false assurances to userspace on derivative and third-party
> implementations.

Is the idea here that we'd assume any part with FEAT_CSV3 is vulnerable
to CVE-2024-7881 unless told otherwise by firmware / known good list of
implementations?

ARCH_WORKAROUND_4 assumes software has already detected an affected
implementation and doesn't distinguish between "not affected" and "not
mitigated". So I'd be concerned that we're gonna turn on KPTI for a load
of unrelated parts for something that hasn't (yet) been defined as a new
ecosystem bug.

> To be clear: I'm not at all against mitigating this problem and
> advertising the status of that mitigation. I *am* against quietly
> handling it like a CPU erratum whilst simultaneously telling userspace
> that meltdown is not a problem regardless of the mitigation state.

I like your idea of treating this as a broken CSV3 implementation
instead of an entirely new CPU bug, if only to avoid the 'assume the
worst' problem.

Either way KVM will need to implement the SMCCC call to the letter, even
if we wind up nuking CSV3.

Thanks,
Oliver
