Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793866317;
	b=uqzdhAUMCqEuwDUpVvvoJdLA0TrNX7Wr7QI57soTRva6Og9X8KJgy1lSnIAeVi4CkDH2
	 RLiC0AT22pZYagcuUO7EoCY1TAuAFplwVtNPs9f9w7El49z8H6Q0VsBXyujtX5nqj5Dzf
	 6X5BeoclPCk3wtHxR/ZRZf+6uJl/JVbg6LSo2Z67Eq5QWxhYxeK+HZn0eurhHhQ+RfDcn
	 UFe3XklqbQLcwtm5d74jlD+arGiGGxPRpfcgFPAJtjzGiFEyDi5NfeqarbX3JAm9qnuCi
	 6TsEAELggYv4vs4BoXTdFyNyJpQLfQjOCyXG56E6765WHc8jcw1mMiiTtLisBUPc3iQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793866317;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=styLRX5Tlyc6QLwhRxfUq/pKF2silx9bLaMIeBuLar0=;
	b=BPeqw8mqd3DqSX/mUtTWYhOjec0AgVGZexGzGFlaInwv7JkxNA88EYv11j2PkjUPir/x
	 3NByzln6zbucuFy2kogljwkW1/KH3Bdl7UKS/mIMS8jXAdWfVjkD95hWrMm754uNxm+Qv
	 waLDeoo/fp30jKpJ45DiJoGFcKw5Nq6/WCHZrx7scEiG9v3wN3rzMpf6GkOY3euIQz0bo
	 /HC/cznUIBPk/cP1uj6F4Lq2NuwOBcv7gDZviNabFosz1hcyPk/PNq0u0PfJUUnpcW4Fc
	 Dgf9/qC+9ON0QUMXxCQiXleQpFBcfOWtcgbpguvKU8rfRcPLWTddn9mdeWhOVTM5vpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jquJxf1n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55081606A326
	for <kvmarm@lists.linux.dev>; Thu,  5 Nov 2026 08:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jquJxf1n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13D261F000C1;
	Thu,  5 Nov 2026 08:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793866317;
	bh=styLRX5Tlyc6QLwhRxfUq/pKF2silx9bLaMIeBuLar0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jquJxf1nWsdCVbu6kqO0jWa0Vh0LWbTRxYqgU7ITAgKTOfZeEfNmtgtYYEkaZZ4uD
	 2WvIjzcu4wtRaL8TZJLacPVg400ki4AR2oVOBgfV2d8qGejnGtSuOMldq/kDRGf7Rv
	 0DvA8HIUuaJWjwYQIoci/GRvbhMBKjhGYA55UAxsgar23ekFi6OLXebqN4Uu11D+rm
	 wrhr15DcT//iAS1zAvL2tf3tklTqw3mmIOmO6awco8nP6LqR/fO4hIjUXAC6qqtfZJ
	 UGQMq681QMeg0cw8aa2GH7CEYuwKXIySc7JXHsPLnpHjv+pw2y8Do9VyUm9pu2EbMt
	 cQok3VhMgwXSg==
Date: Thu, 5 Nov 2026 00:11:55 -0800
From: Oliver Upton <oupton@kernel.org>
To: Leonardo Bras <leo.bras@arm.com>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>
Subject: Re: [PATCH v2 18/28] KVM: arm64: nv: Emulate CMOs via writable-clean
 translations as NOPs
Message-ID: <auw6S0iWLDqYYhdK@kernel.org>
References: <20261023205610.1044532-1-oupton@kernel.org>
 <20261023205610.1044532-19-oupton@kernel.org>
 <autJUntFMhCoqZeH@LeoBrasDK>
 <autp0cVkXwvSXPGC@kernel.org>
 <autrOLZWT-s4Ailc@LeoBrasDK>
 <autzno1eEpw4X-0I@kernel.org>
 <aut5F2V0glbJv6ys@LeoBrasDK>
 <aut5UKnP5BREpTNU@LeoBrasDK>
 <aut6S_jvr_ZLbDoi@LeoBrasDK>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aut6S_jvr_ZLbDoi@LeoBrasDK>

On Wed, Nov 04, 2026 at 06:32:43PM +0000, Leonardo Bras wrote:
> > > > The operations would be, approximately:
> > > > 
> > > >  - Take a stage-2 permission fault on the cache maintenance instruction.
> > > >    Walk the guest's stage-2 and find a translation in writable-clean
> > > >    state.
> > > > 
> > > >  - Pause the VM, re-enter the guest and single-step the instruction. If
> > > >    we take the debug exception then the guest must've changed the
> > > >    instruction. Go back to base state.
> > > 
> > > Pausing the VM would be required so other vcpu treads do not access the 
> > > page we are trying to run CMO on, right? 

Messing with the data side is fine, the concern is with the page the
instruction sits in.

> > > > 
> > > >  - If we take another stage-2 permission fault for a cache maintenance
> > > >    instruction, temporarily promote the translation to RW in the shadow
> > > >    stage-2 and re-enter with single-step enabled.
> 
> But what if instead of RW we made it WC, and enabled Hardware HAFDBS just 
> in this cpu?
> 
> Other CPUs with HAFDBS=off would fault on write, and we could block them 
> there. 
> 
> (We would have to serialize those accesses, though, as multiple vcpus could 
> use the same strategy at the same time)

That would do what we want, just the idea of maintaining some state
machine across multiple guest exits feels pretty gnarly. Trap + emulate
is the way to go if we can't NOP the CMO.

Thanks,
Oliver
