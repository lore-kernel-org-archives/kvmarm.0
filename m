Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793143178;
	b=25JrBPHNzEfO0DUuJMt176sXYTYTaB7KVI50vUZpWCr/qKdaxOoCF6q5zFN+T6iuBE5a
	 jbpRkUnX5ke2HN6qI43+4TOqkP0X6cyK/ZO7OTH+Qo5YAaBS8fpTvi+5+uD/tOECWSOIR
	 qpeqSl/FQW6jbJty7tSH54CVrExBzGFFtXYrIgjtJlERVUZF2Q/q7x9ihY7mE7bv0/1j8
	 zVJoIdKR88ksu6N3dzK9nOOTWglimM6Zop4PjFD7z8F6/+i0lfx5AfpFc1De5NWt9nhrE
	 i/hF5EPq9aSfYHmqxQl+HLFmUsrR6xWj/lVFCYH2M2Q+HY+ipKcpCfH8av9xDQO0biw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793143178;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=gcC21IdQ6bspw7TEhlauUEjBQvyVhgVj7MtVw7/gPRo=;
	b=bTPZ6aMtDc0hI46AMVm4cDJd5UqfJrNs8snbua2LOC1rCqqY2/p6/JhSezJp1Yz/cl/d
	 B4uumYHBE8iFSjUABnp/r101kUPVb1fDCVKOEggCdgDp/HDAgUrYrTCMQtDbFvW1QXB6P
	 7cPbQVWDFYKyqhlbwgS2DMKcBzpCx5RBh7tXJ/MQiD/OALBTb3I3GsMrEn2FLNaW8nwpH
	 EW0AFvzGQoRFgDoW0MBW7+v8x/6hOOGa1dQUAOHpGwE2uOVvdjh1MczmtNryCaR7dXM1M
	 VdrE7h02ox7w+ZdlbqJEaMQzNsQhjMI40f7MY4IkgkL1sa3EUrZyl0hjoVGwfj4M68Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VgjbfQwc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6CF9606A31A;
	Tue, 27 Oct 2026 23:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VgjbfQwc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08BED1F01825;
	Tue, 27 Oct 2026 23:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793143177;
	bh=gcC21IdQ6bspw7TEhlauUEjBQvyVhgVj7MtVw7/gPRo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VgjbfQwcwbx4G42W26MolZaeZmmXJ+28ATNkVJuDLpN6KYpStv2PVQpQCZthLi0Sy
	 Vg0fSiXXlPFlQ2xu6X1+pCN+9q6fY7DXGldExk148QvFsIMOnibTPS5MsHvQvqsHGo
	 07mQQeDmtm7rZSrNK8pHGNFYOR5ywAuC4MhrwEaXpmUq8KKc33oP7JqKe0HzJxHc4Y
	 cvsHOp+fAuG8FjhIKLfqOa3ge07+dILxP+q5mEHAnecHIR/yExBg4iTxMbXktXJjd7
	 WnCBeJjmEbHqadHxsujCA5q1asob8LX6bl2nZWJtVF+b9irHKjGz47+rLya+R9tQ2D
	 P1OmVj1Q4oAaQ==
Date: Tue, 27 Oct 2026 16:19:35 -0700
From: Oliver Upton <oupton@kernel.org>
To: Leonardo Bras <leo.bras@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Tian Zheng <zhengtian10@huawei.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 0/3] Set DBM bit on writable pages
Message-ID: <auExh5laWQbUKmUY@kernel.org>
References: <20261026144413.441566-1-leo.bras@arm.com>
 <at-lSy7H-K60LhCB@kernel.org>
 <auCOj9dgk42AE1WX@LeoBrasDK>
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
In-Reply-To: <auCOj9dgk42AE1WX@LeoBrasDK>

On Tue, Oct 27, 2026 at 11:44:15AM +0000, Leonardo Bras wrote:
> > I'm pretty sure I shared this feedback before, but patches that enable
> > DBM do not make sense in isolation. We need a single series that
> > contains the DBM enablement as well as the corresponding HDBSS support.
> >
> 
> Right, 
> My reasoning is that we can discuss this new version, and make the needed 
> changes, so Tian could pick this for his own patch series for the next 
> version. I do not intend to get this merged by itself.
> 
> Next time I will make sure to state this in the cover letter so it's clear.

Can you just work this out off-list? Let's keep the on-list dialogue
consolidated to a single series to review.

> > The abstract permission flags need to have a WRITE an DIRTY state, which
> > we then map to hardware based on the capabilities of the system.
> > 
> > !FEAT_HAFDBS:
> > 
> > 	DIRTY	=> S2AP[1]
> > 	WRITE	=> S2AP[1]
> > 
> > FEAT_HAFDBS:
> > 
> > 	DIRTY	=> S2AP[1]
> > 	WRITE	=> DBM
> > 
> 
> I agree that it could work, and my first version was based on that.
> 
> But looks weird to me that we have to decide the writable bit based on 
> having a feature enabled.
> 
> Take in account that we can only have DBM being the writable bit while 
> HAFDBS is enabled (not only present), and that it is just enabled during 
> dirty-tracking. 
> 
> It means we would need to convert the whole pagetable between DIRTY=S2AP[1] 
> and DIRTY=DBM every time we enable or disable dirty-tracking.
> 
> My suggestion with this series is to have WRITE=DIRTY=S2AP[1] at all 
> times, and have DBM to act as a "can be promoted to writable on write" bit.
> This way we don't actually need to convert between encodings, and it still 
> works and complies with the architecture.

There's no such "can be promoted to writable on write" in the indirect
permission model. This is why I'm suggesting that we align the abstract
permission bits (i.e. KVM_PGTABLE_PROT_*) with the architecture's own
abstracted permissions (e.g. uX, pX, RO, RW).

That composes nicely with nested virt as it is unambiguous what
permissions we're trying to represent in a shadow stage-2. And in the
non-nested case you can just lay down writable-dirty translations for
most things and use writable-clean when necessary for HDBSS.

> > Beyond making the whole HAFDBS easy to reason about, I want this for
> > FEAT_S2PIE which reimagines bit 7 as a literal dirty bit that can be
> > managed by software or hardware.
> 
> Humm, and would not that work with the above suggested approach?
> I mean, bit 7 (Dirty, S2AP[1]) will both mean WRITE/DIRTY, but it will be 
> able to get promoted (nonW->W, or clean->dirty) based on the indirect 
> permissions.

There's a bit more though. We need to have an entry in S2PIR_EL2 that
encodes write permission and select that with PIIndex. So then we wind
up mapping the abstract WRITE permission bit to two fields into the
descriptor rather than 1.
