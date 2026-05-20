Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FC524502A
	for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 11:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779277824; cv=none; b=SrReRlzGVx6fxg3T3bIaMNlS7eQgPk45LUvTlFABbO21bH0of5R6prOvK7axGTXsGfC/y0noTN9AuLe2JyHAPttlAihFWISIobmidEP9GKyPnd5TvnRO9nSG65lKK1UQX+LL0ni+gzqRYL3ik7pbmBm1UDfz3J5XKfzZc1v08bI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779277824; c=relaxed/simple;
	bh=hPKT3WzdkwMamGhokWO/Li0K/EjbItHBpVmy/rZjq6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=oVMvqcSOArOir1TwLuN/M1KNahCSZNuC2AgvKWdiqBXMulhvjRk2PaoU8H9+ECIWi0D9OVMJmUAc6StU2a0tFfmwzs7IOfHJ4ckACx+SfBw/q7rMTF6y6isFqJOBhNOUYbuSoTx+2UP7ppb/d6YnH5t4pC0wjITPPKObcJXfghg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=u8V4vwUy; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="u8V4vwUy"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A70783597;
	Wed, 20 May 2026 04:50:12 -0700 (PDT)
Received: from devkitleo.cambridge.arm.com (devkitleo.cambridge.arm.com [10.1.196.90])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7B1433F632;
	Wed, 20 May 2026 04:50:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779277817; bh=hPKT3WzdkwMamGhokWO/Li0K/EjbItHBpVmy/rZjq6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u8V4vwUykvL5GS+hJov9hbaKLBze2jIIkaSFpdN/x3vZlkx7Ci/BQDyoP0lTp0vz6
	 zXb33XaRUTNgUIsOOrUcLcDc96098hMKEIDhKFF3wS+5B91qJOVcitEcMFbCLbax7W
	 dbutQ6rjU2xakgYSJ8KrErCxKpgEmR3Cmx7YF2y8=
From: Leonardo Bras <leo.bras@arm.com>
To: Oliver Upton <oupton@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] KVM: arm64: Introduce S2 walker SKIP return options
Date: Wed, 20 May 2026 12:49:56 +0100
Message-ID: <ag2f5C3i3LBGSPS5@devkitleo>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <agzUZS1l-uHQoodG@kernel.org>
References: <20260515195904.2466381-1-leo.bras@arm.com> <20260515195904.2466381-2-leo.bras@arm.com> <agq-RyKhBy4CIThm@kernel.org> <agrTQMw4QJX6HGrm@willie-the-truck> <agsYF-Dav2bpxWK4@devkitleo> <agxa-TydN1PoKsYn@willie-the-truck> <agxeEA14cP3yMV1m@devkitleo> <agxifbKzGcYQivBz@willie-the-truck> <agx1J1tQFn0cdtBf@devkitleo> <agzUZS1l-uHQoodG@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, May 19, 2026 at 02:21:41PM -0700, Oliver Upton wrote:
> On Tue, May 19, 2026 at 03:35:19PM +0100, Leonardo Bras wrote:
> > On Tue, May 19, 2026 at 02:15:41PM +0100, Will Deacon wrote:
> > > On Tue, May 19, 2026 at 01:56:48PM +0100, Leonardo Bras wrote:
> > > > On Tue, May 19, 2026 at 01:43:37PM +0100, Will Deacon wrote:
> > > > > > > I was wondering along similar lines, but maybe it would be useful just
> > > > > > > to pass a maximum level to the walker logic? That feels like the most
> > > > > > > general case without complicating the existing logic.
> 
> FWIW, I had considered this too but decided that it requires a bit more
> churn since we cannot rely on zero initialization in the existing
> callsites (level 0 is a valid level).
> 
> But that's extremely minor.
> 
> > > > > > This proposal seems simpler for me to understand, and indeed looks like a 
> > > > > > better solution than what I have proposed, taking care of  the 
> > > > > > 'already split' case with better performance, as it don't even walk a 
> > > > > > single level-3 entry. 
> > > > > > 
> > > > > > On the 'splitting' case, it also works flawlessly if the memory is given in 
> > > > > > level-2 blocks. There is only one case that I would like to address here:
> > > > > > 
> > > > > > - Memory given in level-1 blocks (say 1GB)
> > > > > > - Walker flag says 'walk down to level-2 only'
> > > > > > - Split Walker on level-1 will break page down to (up to) level-3 entries.
> > > > > > - Walker will continue to be called on level-2 entries, even though it's 
> > > > > >   not necessary.
> > > > > 
> > > > > If you're only visiting leaves, why would it be called on the level-2
> > > > > table entries?
> > > > > 
> > > > 
> > > > Because once the leaf is turned into a table by the splitting walker, it 
> > > > gets reloaded and walked. This is an excerpt of __kvm_pgtable_visit():
> > > 
> > > Sorry, I was musing about the semantics after adding something to limit
> > > the maximum level. I don't dispute what the current code would do.
> > > 
> > > > Example:
> > > > - Split this level-1 leave:
> > > >   - Walker creates the whole structure up to given level (currently 3)
> > > >   - Walker returns, gets reloaded, table detected, go down on that one
> > > >   - Level 2 entries walked (which is unnecessary)
> > > > 
> > > > Please let me know if I am misunderstanding something.
> > > 
> > > I just don't grok why this would happen if we limited the maximum level
> > > to '2' _and_ said we only wanted to visit the leaf entries. In that
> > > case, I wouldn't expect to descend into any of the L2 table entries
> > > (because that would imply going beyond level 2) and I wouldn't expect to
> > > be called for the table entries either (because we're only interested in
> > > leaves).
> > 
> > Agree, if we specify to skip level-3 entries, it would only walk up to 
> > level-2 entries, but take above example in detail:
> > - Split these level-1 leaves, up to level-3 leaves (regular)
> >   - INFO: kvm_pgtable_walk will call walker:
> >     - only up to level-2 entries (skip level-3)
> >     - only on leaf entries
> >   - Walk first level-1 leaf, calls walker
> >     - walker will split the level-1 leaf in level-3 leaves
> >     - walker return from that first level-1 leaf
> >   - level-1 leaf is reloaded as a table
> >     - level-2 entries of that table are also walked (unnecessary)
> >     - on each of the level-2 table entries, level-3 entries are skipped
> > 
> > To avoid the unecessary walk of the level-2 entries above, we would need to 
> > specify 'skip level-2' that could be an issue if we have a mix of level-1 
> > and level-2 leaves, as the level-2 leaves in that case would not be split.
> > 
> > That's why I suggest something like "skip recently created table" as a flag 
> > as well, so we can guarantee no newly created table gets walked 
> > unecessarily.
> > 
> > Please help me if I am missing something important.
> 
> I'm not sure the added complexity of handling this case perfectly results
> in a measurable performance improvement. Just avoiding the level 3
> tables would be an exponential reduction (~ 512-8192x) in the number of
> walk steps.
> 

Humm, I agree most of the improvement is due to skipping level-3 walks.

The added complexity would be, appart from a new flag, just a single line 
change:

---
        if (!table && (ctx.flags & KVM_PGTABLE_WALK_LEAF)) {
                ret = kvm_pgtable_visitor_cb(data, &ctx, KVM_PGTABLE_WALK_LEAF);
-               reload = true;
+               /* Do not reload if flagged to skip new table */
+               reload = !(ctx.flags & KVM_PGTABLE_WALK_SKIP_NEW_TABLE);
        }
--- 

Even then, do you think it would not be worth having it?

Thanks!
Leo
 
