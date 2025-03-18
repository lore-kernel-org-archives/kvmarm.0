Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D09672080D3
	for <kvmarm@lists.linux.dev>; Tue, 18 Mar 2025 11:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742297054; cv=none; b=cd9mTX6bbm0kD++ZHpnCP/+X6N8ikolAIUZ9uzwHZczLRlX3cIE9LTfY+oPFsnffG7vXyUyK9p4DtlXnnbzYvfxRyBxS67P0FTm+FMZQ4FoWnPxqxSBHbjeotKiH+TxNExLFQVwzGay35aXgT64GXHC6Y7SApXTA5dIl8QDtRMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742297054; c=relaxed/simple;
	bh=158fTv/WLv8yXsUCaExeBywAUdzNo077tMVESEzlSbw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aNGHlskfcAlcyGI5nZXaBaQpFh0Tp9pIQlhuSyJ4CZ8KQLgSCUMt8rlUTZ2Ijp2DbFd1k5IVfPIV2WtaTalf866fqtF6oFXpD5s2f0ltHsoennWehDy84ToolIjboakCZltN2k0J9gFoJ7qSi1vNQNi7SrCA4F6GFM17jML/t4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5BF6C4CEDD;
	Tue, 18 Mar 2025 11:24:12 +0000 (UTC)
Date: Tue, 18 Mar 2025 11:24:10 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>, joey.gouly@arm.com,
	kvmarm@lists.linux.dev, maz@kernel.org, suzuki.poulose@arm.com,
	yuzenghui@huawei.com
Subject: Re: [PATCH 0/4] arm64: mitigate CVE-2024-7881 in the absence of
 firmware mitigation
Message-ID: <Z9lX2juZYCq_cnZs@arm.com>
References: <20250128155428.210645-1-mark.rutland@arm.com>
 <174197730164.734861.6726211221092480832.b4-ty@arm.com>
 <20250317212611.GA12724@willie-the-truck>
 <Z9ikak5AOtDJNVgE@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z9ikak5AOtDJNVgE@linux.dev>

On Mon, Mar 17, 2025 at 03:38:34PM -0700, Oliver Upton wrote:
> On Mon, Mar 17, 2025 at 09:26:12PM +0000, Will Deacon wrote:
> > On Fri, Mar 14, 2025 at 06:37:25PM +0000, Catalin Marinas wrote:
> > > On Tue, 28 Jan 2025 15:54:24 +0000, Mark Rutland wrote:
> > > > On some CPUs from Arm Ltd, it is possible for unprivileged code to cause
> > > > a hardware prefetcher to form an address using the contents of a memory
> > > > location which is accessible by privileged accesses in the active
> > > > translation regime, potentially leaking the contents of this memory
> > > > location via a side channel. This has been assigned CVE-2024-7881:
> > > > 
> > > >   https://developer.arm.com/Arm%20Security%20Center/Arm%20CPU%20Vulnerability%20CVE-2024-7881
> > > > 
> > > > [...]
> > > 
> > > Applied to arm64 (for-next/leaky-prefetcher), thanks!
> > > 
> > > There hasn't been much review (thanks Oliver for looking at the KVM
> > > bits) and there's some implied work that can go on top of this series.
> > > But the patches looked fine to me, so I queued them. Mark or others,
> > > please shout if you'd like them dropped, they are on a branch.
> > 
> > I'm really not comfortable with this series and would prefer to see it
> > dropped while we continue the discussion, especially as it's causing
> > minor conflicts with the KVM/arm64 tree in -next.
> 
> Catalin, unless you say otherwise, I'm going to assume this will be
> dropped in the interim.

Yes, I just dropped it.

-- 
Catalin
