Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16DA22737EB
	for <kvmarm@lists.linux.dev>; Mon, 23 Mar 2026 14:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277902; cv=none; b=iJlSxZcaoE9v2u0t3/ilqtDRwCldEcAYNBPn63eqyWxLvGqCmqpGU/1ozmnIH3HlXTxQ5Nbx4649a8AbBBN+V2NxwG7p38jxgosklo6V1aslJezYPQYPh/CR4Cf8jr0u+0fz5ihph+f0q2D/k/DqKjxn1a6T5kB/NHazycWvoII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277902; c=relaxed/simple;
	bh=f8dCaoHE8v13TX7zhudBhLxwnKyjtp2XPdiKUD8OWGE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ByRi3EUrnwgTh5KWYyv9N+Nkca04R2h7+fuxnr2SA97SPnDG5e0+cx13XHeJcU+pCyNhbXysw5JLz6EwQ9FoZm9Bnd5o8gNJkWTzE6t7WOL4jPrn8Na7Dxp7sGRbsFVOVZpst2flzaEIx2JZXyBfCyBe+Y6ItrGXncyZ+TSmaAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IHzOAlF5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IHzOAlF5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70A55C2BC9E;
	Mon, 23 Mar 2026 14:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774277901;
	bh=f8dCaoHE8v13TX7zhudBhLxwnKyjtp2XPdiKUD8OWGE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IHzOAlF5Ymj0Vgg4Oh1oKLaVDPOpYje9/8/qWu57Nft5V+j/b0M8g+Cu2UNVc6R2g
	 9z51ACWPv4nBFHk3tat/R5aiNl9d6UIGIGIW/DRNqcAJfViMhrS4WoeXWXkeCrJFS3
	 OVU5yeag7Iq9MfbIWCHBciePzpm3nX0Ep7Zbu7flioBdRslEKuD+Zg2iSXUjp65M66
	 +u4EeDR8uDD3tEYcKpc+pwswo37xLvEvjYMC+uBe1EPQAXy9u54A2GzLtkBsPJCGOA
	 HKZqV3VnVcs32rR4WDHocLGDgK4gLNw+YGhBTZjtuF33JfgvEWfVmp8ja2HrD1dXBJ
	 Y4Nkya3ai0L8Q==
Date: Mon, 23 Mar 2026 14:58:16 +0000
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Quentin Perret <qperret@google.com>, Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH v3 25/36] KVM: arm64: Reclaim faulting page from pKVM in
 spurious fault handler
Message-ID: <acFVCKZVw77OSiS0@willie-the-truck>
References: <20260305144351.17071-1-will@kernel.org>
 <20260305144351.17071-26-will@kernel.org>
 <864ima5v6c.wl-maz@kernel.org>
 <87fr5tcyim.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fr5tcyim.wl-maz@kernel.org>

On Sat, Mar 21, 2026 at 09:39:13AM +0000, Marc Zyngier wrote:
> On Fri, 20 Mar 2026 16:20:59 +0000,
> Marc Zyngier <maz@kernel.org> wrote:
> > 
> > On Thu, 05 Mar 2026 14:43:38 +0000,
> > Will Deacon <will@kernel.org> wrote:
> > > 
> > > Host kernel accesses to pages that are inaccessible at stage-2 result in
> > > the injection of a translation fault, which is fatal unless an exception
> > > table fixup is registered for the faulting PC (e.g. for user access
> > > routines). This is undesirable, since a get_user_pages() call could be
> > > used to obtain a reference to a donated page and then a subsequent
> > > access via a kernel mapping would lead to a panic().
> > > 
> > > Rework the spurious fault handler so that stage-2 faults injected back
> > > into the host result in the target page being forcefully reclaimed when
> > > no exception table fixup handler is registered.
> > 
> > Is there any reason why you prefer the 'inject fault' followed by
> > 'gimme that page' dance over a more direct 'unconditionally reclaim
> > the page on the back of the fault'?
> > 
> > I can't figure out what would go wrong in the latter approach, as you
> > always have an opportunity to inject a (fatal) fault if you can't
> > safely reclaim the page.
> 
> To be clear, the reason I'm asking this is that with RME (whether
> that's with the dreaded CCA or something else), injecting a fault into
> the host would involve EL3, and I don't trust EL3 to do that. There is
> also the small detail that the fault syndrome is not strictly
> architectural, meaning that EL3 would have to learn a pKVM-specific
> behaviour.
>
> But EL3 should be able to report a GPC fault to RL-EL2, which then
> could act the exact same way as pKVM, unmapping, clearing and
> releasing the page.

I wonder if we should try to get this changed/extended, given that it's
all software? Perhaps RL-EL2 could populate parts of the fault syndrome
that get injected back into the host?

Ideally, we'd run something at RL-EL2 that is tightly-coupled with KVM
and so we wouldn't need to teach EL3 anything as long as it lets the
two talk to each other...

> Thoughts?

I think we need to retain the exception injection behaviour, for two
reasons:

1. The kernel can over-read strings via load_unaligned_zeropad(). If
   this happens to walk into a protected page, we have to inject a fault
   so that the exception handler can fix things up. Otherwise, we'd
   silently poison protected pages due to software-speculative accesses.

2. If the fault comes directly from userspace (e.g. because of an
   out-of-bounds access or a virtio problem), the fault handler in the
   kernel will inject a signal back to userspace which can be caught and
   handled synchronously. I suppose we could require the VMM to make the
   guest memory PROT_NONE if it wanted to preserve this behaviour
   (assuming it doesn't break GUP). Still, it feels desirable to report
   the problem synchronously when we can.

Will
