Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C49B3016E0
	for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 17:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782495906; cv=none; b=h9fmvIu7zZme8o1j9XiysPIqTZo4R6tlE++wjtHhHqLWTyttzMxjffglWfQmB3c/GiDn1NpL7ZknJ79beweV+23TCIOpLEhnN+CKl8LBanOS9puaKUA8S2kod7I4srb6NMhL4x4dFLBvTRVXCGQebLz8gqPDwK4i/N24TQbXTmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782495906; c=relaxed/simple;
	bh=tLtLZFvsX8bheNE3zZF0Q9uUuzV3la0etvPhuKYIbMo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qcTN+2Ktvv7prNhFkCJUW8amNvFMML0J9OC4BtXLrYlSPMRdrN7FicZZYeSP+G2a7k35ZFEEY3Zf1NYkEvl/46Ha4PIzJxDbuDZxu11dsyOf8q1eOiSfyWgUu5d4z9qVCvpxB7a6HaQyYNUVMjBMkjU5jX0xUBdD+Caak1jdNPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P35bIcws; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P35bIcws"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B65841F000E9;
	Fri, 26 Jun 2026 17:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782495904;
	bh=ZxHk+XdHdINVvigYhdxLu0E1rfYR81tajITCKz/b60E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=P35bIcwsA503p+vhE1OE6p2uuEaGt8zW6mN4H3OPJVEtDuXit8AmeO5foZHWjGMa8
	 oz9uETDH14FjMiALVhuH082z2jylKk4rkR3AP+4M+T3aJNBFQAqB7AHmp8R/8OwWxT
	 2sa9yvr15m3/Mf/g1F0mMPkBm8gDZbcm7JYy28YoXr5nGhqecdla92UpB1HZbWpOft
	 X7iJnVYj81Bjc8xcURC3bG3aonloXEtksIoNf30CPd+UOOuG6OGoZ7J0W6PoL5KDA2
	 iVO+DiReG1IBa6SAHqeEpKLizP53ExE3azgRS/PRzoNj9rKXab4f0SX4ScomyBd0Mg
	 fHPtQR9hHRtnw==
Date: Fri, 26 Jun 2026 10:45:03 -0700
From: Oliver Upton <oupton@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>, kvmarm@lists.linux.dev,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>
Subject: Re: [PATCH 00/22] KVM: arm64: nv: Implement FEAT_HAFDBS, FEAT_HAFT
Message-ID: <aj66nzo3gTHYInp8@kernel.org>
References: <20260623184201.1518871-1-oupton@kernel.org>
 <aj6bZZLSk24Ze6_S@LeoBrasDK>
 <8633y9ql8q.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8633y9ql8q.wl-maz@kernel.org>

On Fri, Jun 26, 2026 at 06:12:21PM +0100, Marc Zyngier wrote:
> On Fri, 26 Jun 2026 16:31:50 +0100,
> Leonardo Bras <leo.bras@arm.com> wrote:
> > 
> > On Tue, Jun 23, 2026 at 11:41:39AM -0700, Oliver Upton wrote:
> > > KVM's support for hardware descriptor updates has been lacking, owing in
> > > large part to the fact that the most widely available NV2 hardware
> > > actually lacks HAFDBS :)
> > > 
> > > This series brings support for hardware dirty state and table Access
> > > flags to the nested MMU. While KVM uses neither of these features, the
> > > kernel definitely does in the stage-1 page tables. Since there is only
> > > one hypervisor to rule them all, implementing this stuff at stage-2 is
> > > mostly motivated by the desire to enable guest stage-1 :)
> > > 
> > > Implementing dirty state at stage-2 is a bit more challenging than
> > > anticipated, I'm in the middle of seeking a relaxation from Arm that
> > > would make this all architectural. See the last patch for the details.
> > 
> > Hi Oliver,
> > 
> > Haven't read your patchset yet, but in regards to stage-2 dirty-state
> > tracking, there have already been some efforts in the area, also
> > implementing HDBSS and HACDBS in a way of improving performance / reducing 
> > impact of live migration on a system.
> 
> I'm worried you are reading this series the wrong way. This is mostly
> orthogonal to the whole HDBSS/HACDBS/SLAUA (Super Long And
> Unpronounceable Acronym). Oh wait, you haven't read it yet. Great :-(.
> 
> This series is about *implementing* HAFDBS and HAFT in NV. We can't
> rely on the HW setting the AF and DB in the guest's own S2 PTs,
> because these page tables are never live. So we have to do it
> ourselves.
> 
> So this has nothing to do with S2 dirty tracking for the purpose of
> migration. The guest could implement its own migration based on that,
> but that has nothing to do with what this series is doing.

Sorry, I haven't looked at the HDBSS/HACDBS stuff yet. Just want to be
clear, neither of these features make sense for the host to use in the
context of NV.

KVM's dirty tracking is done on the L1 IPA space, however nested MMUs
translate the L2 IPA space. The descriptors emitted by HDBSS would be of
the L2 IPA space and would require reverse-translation for each entry...

Software dirty tracking is the way to go for nested MMUs. Maybe in the
distant future we can emulate HDBSS/HACDBS for the L1 hypervisor. Maybe.

Thanks,
Oliver
