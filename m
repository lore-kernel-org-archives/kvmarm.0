Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 853E93E7BA0;
	Tue, 19 May 2026 21:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779225704; cv=none; b=Jb1PZ630A1XyHAv6cuulR6wdH1a5X1ivPzFYa54/095JYn84KMjllM5lmB5bjWNjBJWZI/gsMmWGgqNQ+tBsII3GgWdykIUXfKp/jxMy6i/SsKtM2/pQcZ2nb+GrC9bK4iwN+mpAOhBYCv1ZtC/+xGlEWvEZ0TNVaxBMUgQtbic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779225704; c=relaxed/simple;
	bh=djCpecXEj3zHCmYe7VgFQ9Oql5NDiSL/b7rvo9CsIhY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bfJvvokKzyrUYSH+3iYjtoWIMjmelh5b7/FaxdhfdWWq5kh6JtmiBOv/1/LF5m9LoWty+N/TROi0/v1zDMo730FQc7GN0447OtgGnAeubcGZYEk/dupCNqkY5AGC6evB3Q7ybFMIbW+gAOT8zB4a66ud9U67YfUIUnURw/vESAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mSi5Oi8w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mSi5Oi8w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC15F1F000E9;
	Tue, 19 May 2026 21:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779225703;
	bh=ri+sVbVtaQpLD9jTrxV8FY3zeDim8GxNujn5Xy/XOv8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mSi5Oi8wWxJxTPYwM0kIZ5Swu9IrlsWBaYQoTzOy1yE2VKsWFWcnvzEfZldVLh0kL
	 Pho+U7EOqfr9pBhWNX20W9s6V91TFGkCWrk8weyXzHQjmcfCEOrtxEX44VVqn7AMA4
	 +nEqj8gWNOF052trRl7XMXLj1JC9ByhHkdLOfX0oHijWeoGmHeHl38hq2SE5uHn4Zz
	 28Uzvk+ur6n6vs5d3Ds3v8ar/TEix9MALf0X8Hb9ToyXqJI2VyWqWNGl+T0yZs7zeY
	 xWEXIZn4wKGNsMAXwClhdHgMwjEuv5HTGAURBzdpZPVZ1ny5uHgNb4BISTKlOK18uc
	 97pwhdgCkGNUA==
Date: Tue, 19 May 2026 14:21:41 -0700
From: Oliver Upton <oupton@kernel.org>
To: Leonardo Bras <leo.bras@arm.com>
Cc: Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
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
Message-ID: <agzUZS1l-uHQoodG@kernel.org>
References: <20260515195904.2466381-1-leo.bras@arm.com>
 <20260515195904.2466381-2-leo.bras@arm.com>
 <agq-RyKhBy4CIThm@kernel.org>
 <agrTQMw4QJX6HGrm@willie-the-truck>
 <agsYF-Dav2bpxWK4@devkitleo>
 <agxa-TydN1PoKsYn@willie-the-truck>
 <agxeEA14cP3yMV1m@devkitleo>
 <agxifbKzGcYQivBz@willie-the-truck>
 <agx1J1tQFn0cdtBf@devkitleo>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agx1J1tQFn0cdtBf@devkitleo>

On Tue, May 19, 2026 at 03:35:19PM +0100, Leonardo Bras wrote:
> On Tue, May 19, 2026 at 02:15:41PM +0100, Will Deacon wrote:
> > On Tue, May 19, 2026 at 01:56:48PM +0100, Leonardo Bras wrote:
> > > On Tue, May 19, 2026 at 01:43:37PM +0100, Will Deacon wrote:
> > > > > > I was wondering along similar lines, but maybe it would be useful just
> > > > > > to pass a maximum level to the walker logic? That feels like the most
> > > > > > general case without complicating the existing logic.

FWIW, I had considered this too but decided that it requires a bit more
churn since we cannot rely on zero initialization in the existing
callsites (level 0 is a valid level).

But that's extremely minor.

> > > > > This proposal seems simpler for me to understand, and indeed looks like a 
> > > > > better solution than what I have proposed, taking care of  the 
> > > > > 'already split' case with better performance, as it don't even walk a 
> > > > > single level-3 entry. 
> > > > > 
> > > > > On the 'splitting' case, it also works flawlessly if the memory is given in 
> > > > > level-2 blocks. There is only one case that I would like to address here:
> > > > > 
> > > > > - Memory given in level-1 blocks (say 1GB)
> > > > > - Walker flag says 'walk down to level-2 only'
> > > > > - Split Walker on level-1 will break page down to (up to) level-3 entries.
> > > > > - Walker will continue to be called on level-2 entries, even though it's 
> > > > >   not necessary.
> > > > 
> > > > If you're only visiting leaves, why would it be called on the level-2
> > > > table entries?
> > > > 
> > > 
> > > Because once the leaf is turned into a table by the splitting walker, it 
> > > gets reloaded and walked. This is an excerpt of __kvm_pgtable_visit():
> > 
> > Sorry, I was musing about the semantics after adding something to limit
> > the maximum level. I don't dispute what the current code would do.
> > 
> > > Example:
> > > - Split this level-1 leave:
> > >   - Walker creates the whole structure up to given level (currently 3)
> > >   - Walker returns, gets reloaded, table detected, go down on that one
> > >   - Level 2 entries walked (which is unnecessary)
> > > 
> > > Please let me know if I am misunderstanding something.
> > 
> > I just don't grok why this would happen if we limited the maximum level
> > to '2' _and_ said we only wanted to visit the leaf entries. In that
> > case, I wouldn't expect to descend into any of the L2 table entries
> > (because that would imply going beyond level 2) and I wouldn't expect to
> > be called for the table entries either (because we're only interested in
> > leaves).
> 
> Agree, if we specify to skip level-3 entries, it would only walk up to 
> level-2 entries, but take above example in detail:
> - Split these level-1 leaves, up to level-3 leaves (regular)
>   - INFO: kvm_pgtable_walk will call walker:
>     - only up to level-2 entries (skip level-3)
>     - only on leaf entries
>   - Walk first level-1 leaf, calls walker
>     - walker will split the level-1 leaf in level-3 leaves
>     - walker return from that first level-1 leaf
>   - level-1 leaf is reloaded as a table
>     - level-2 entries of that table are also walked (unnecessary)
>     - on each of the level-2 table entries, level-3 entries are skipped
> 
> To avoid the unecessary walk of the level-2 entries above, we would need to 
> specify 'skip level-2' that could be an issue if we have a mix of level-1 
> and level-2 leaves, as the level-2 leaves in that case would not be split.
> 
> That's why I suggest something like "skip recently created table" as a flag 
> as well, so we can guarantee no newly created table gets walked 
> unecessarily.
> 
> Please help me if I am missing something important.

I'm not sure the added complexity of handling this case perfectly results
in a measurable performance improvement. Just avoiding the level 3
tables would be an exponential reduction (~ 512-8192x) in the number of
walk steps.

Thanks,
Oliver
