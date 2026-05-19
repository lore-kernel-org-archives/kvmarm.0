Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0EEF4DBD6F;
	Tue, 19 May 2026 13:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779196550; cv=none; b=Yr91JaHUc9816RUcGSEYYyL341XyBhx8bFFiZ670paZDcPVnBTo8xPKfjGFsCtfcr+4pBg6Mj2TTH1g0xpT0eH8bZGbvcrk6D/y/w6qaQffOYorPTLBDrtEBhwl2StMXTh0Gmc+bSrAAgbGdEpB2Bt0+ygouEHF6GkH9tkcBxOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779196550; c=relaxed/simple;
	bh=Gwwo2EWak0iwDGHZWNHmG6wAwA0ZrKZ9UzaMAHAmmmo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZC6xf/Y2rmRqHsNFnYaAz1GBjBa1W6iiFfGmb2b+/ZB5ZDwMmUYgrNb6bGuhbIEvTFqfBa4IhbFrabIHcManDOSt5u95//CadI8kBDZNk6qpqAqWcxv6WQYF1Nl7ZhZRMbgyF8AzhXEFdBD8AAoesBZn1LmwmnHHmhP9lqm7vII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DQi3bUFw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DQi3bUFw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F47BC2BCF5;
	Tue, 19 May 2026 13:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779196547;
	bh=Gwwo2EWak0iwDGHZWNHmG6wAwA0ZrKZ9UzaMAHAmmmo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DQi3bUFw6VBkHixJTgH3HPk7tFkN7gxRgNt76wjDyQALvsAW6HL6XAM0Sgrcby025
	 2S/xKE/4hMRTUCFfJ+74yRnOadzDpJElrjEMxYJTLSa3ZDJ3JGOpzH6T0hJlNluxAf
	 mTxlCVJXItjlQC1n3J7g68yIgCgDW3hT0fKU6FeNnZIkk/uPgU6UF6ZMJXt0vaBZ9Y
	 3KHIbeudIYaRQEOxuKqYOZaP/4+bwVA089mUMGP3xCwsTfG2rOVDi/sJrNdUTFHilH
	 loeG4KeS1l13W8Tc/uQPjPmuD04wlfins0OjNeu9ZZEqSEh+/UxJHtL+ANA1eGifdv
	 I8sinrVEnZZVQ==
Date: Tue, 19 May 2026 14:15:41 +0100
From: Will Deacon <will@kernel.org>
To: Leonardo Bras <leo.bras@arm.com>
Cc: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] KVM: arm64: Introduce S2 walker SKIP return
 options
Message-ID: <agxifbKzGcYQivBz@willie-the-truck>
References: <20260515195904.2466381-1-leo.bras@arm.com>
 <20260515195904.2466381-2-leo.bras@arm.com>
 <agq-RyKhBy4CIThm@kernel.org>
 <agrTQMw4QJX6HGrm@willie-the-truck>
 <agsYF-Dav2bpxWK4@devkitleo>
 <agxa-TydN1PoKsYn@willie-the-truck>
 <agxeEA14cP3yMV1m@devkitleo>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agxeEA14cP3yMV1m@devkitleo>

On Tue, May 19, 2026 at 01:56:48PM +0100, Leonardo Bras wrote:
> On Tue, May 19, 2026 at 01:43:37PM +0100, Will Deacon wrote:
> > > > I was wondering along similar lines, but maybe it would be useful just
> > > > to pass a maximum level to the walker logic? That feels like the most
> > > > general case without complicating the existing logic.
> > > 
> > > This proposal seems simpler for me to understand, and indeed looks like a 
> > > better solution than what I have proposed, taking care of  the 
> > > 'already split' case with better performance, as it don't even walk a 
> > > single level-3 entry. 
> > > 
> > > On the 'splitting' case, it also works flawlessly if the memory is given in 
> > > level-2 blocks. There is only one case that I would like to address here:
> > > 
> > > - Memory given in level-1 blocks (say 1GB)
> > > - Walker flag says 'walk down to level-2 only'
> > > - Split Walker on level-1 will break page down to (up to) level-3 entries.
> > > - Walker will continue to be called on level-2 entries, even though it's 
> > >   not necessary.
> > 
> > If you're only visiting leaves, why would it be called on the level-2
> > table entries?
> > 
> 
> Because once the leaf is turned into a table by the splitting walker, it 
> gets reloaded and walked. This is an excerpt of __kvm_pgtable_visit():

Sorry, I was musing about the semantics after adding something to limit
the maximum level. I don't dispute what the current code would do.

> Example:
> - Split this level-1 leave:
>   - Walker creates the whole structure up to given level (currently 3)
>   - Walker returns, gets reloaded, table detected, go down on that one
>   - Level 2 entries walked (which is unnecessary)
> 
> Please let me know if I am misunderstanding something.

I just don't grok why this would happen if we limited the maximum level
to '2' _and_ said we only wanted to visit the leaf entries. In that
case, I wouldn't expect to descend into any of the L2 table entries
(because that would imply going beyond level 2) and I wouldn't expect to
be called for the table entries either (because we're only interested in
leaves).

Will
