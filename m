Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793881419;
	b=NgcOpAuzQYnL41moyLfPfY3YQtZXiwRsYZDGSb1Fisc0CVvTF7h32GZWK1ZcKiS/bGmF
	 IngHIOcHOIKWHyoZo4sUdu2osK6waGb71k1CbPpkGL4DO2xDxgb0QK7Ur4mYSlZXvYCe5
	 lkNkgt8FL+yd/9ZzoUrqYUhpFy+axbCC8uuddcjhhR9zIgSsfkWCjMYUCJVxCM80tUMxH
	 P61hViS7AQSaMgB1uOoMnOpgBD0vhFxPczMbn4w9XrD2gvkj6pXVAr+vIb9sj3ybjanT0
	 wwL7Xkf2W2GzoOED8R7ch1imFT/8rosS2nmWZHBZ0czmsgqSwkUzykijm0JKhzKo8xA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793881419;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding;
	bh=VUNLx7P+LBuvrxPqQWlq/cHuy1OOS2ZNQ7dG6wtEDRs=;
	b=OyQh+FHwUiTySXFxT4DdUCeWRIjN0iNHP5esSxUEQ8oW4c+GWG1c9AjX+LOEUTxRdopd
	 HZv5PUxzq9Rl4+ygWUlR3B2SB4GSbLiOilV3jCyjW2g9iQXXNmQSOvrjH0DS3M5TnzT2q
	 pUiBx16zQ+lDij7PIE450CVSLJNZXhJw8TBUA+J2Xo+RsVanmApGfT3XvpyJGQ/NSPIu3
	 fcUzPaVzLnWUY8QLst/imTRQLvTAkwyvBFGSaRNW8ANsqHK9/krVhnyOMFAbVP82NQktW
	 6H3212Ii03Im7JsHrYys+JU+a9KL+rjqmGuZB1+2f0n2eAzFhhfhxGHrPvaDKeXOx1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=p8ydWS3k;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9AC1606A326
	for <kvmarm@lists.linux.dev>; Thu,  5 Nov 2026 12:23:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E9AC1606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=p8ydWS3k
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B0E9E19F6;
	Thu,  5 Nov 2026 04:23:34 -0800 (PST)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 54E273F673;
	Thu,  5 Nov 2026 04:23:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793881417; bh=DC+oqLSQrs563GRyOzibUQoJKqvpZqKMXW9zfrmOCi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p8ydWS3kk31mJpnZNbtXnxz3z2SRFVHdXV1hTHhCkHLSqNQ1li1zEfGA9HqtjDjyw
	 JEvq2UFVz7mujQqYP/3+9nHtihlEiALq643ba5IzH5JL/OHqSXaEFhnmKIJj89SKrS
	 ZNrLiiWQcy+LSiIhadpK8ecsyw1tVEwH+ZjitCkE=
From: Leonardo Bras <leo.bras@arm.com>
To: Oliver Upton <oupton@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>
Subject: Re: [PATCH v2 18/28] KVM: arm64: nv: Emulate CMOs via writable-clean translations as NOPs
Date: Thu,  5 Nov 2026 12:23:30 +0000
Message-ID: <aux1QsNTgE0fRLKZ@LeoBrasDK>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <auw6S0iWLDqYYhdK@kernel.org>
References: <20261023205610.1044532-1-oupton@kernel.org> <20261023205610.1044532-19-oupton@kernel.org> <autJUntFMhCoqZeH@LeoBrasDK> <autp0cVkXwvSXPGC@kernel.org> <autrOLZWT-s4Ailc@LeoBrasDK> <autzno1eEpw4X-0I@kernel.org> <aut5F2V0glbJv6ys@LeoBrasDK> <aut5UKnP5BREpTNU@LeoBrasDK> <aut6S_jvr_ZLbDoi@LeoBrasDK> <auw6S0iWLDqYYhdK@kernel.org>
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
Content-Transfer-Encoding: 8bit

On Thu, Nov 05, 2026 at 12:11:55AM -0800, Oliver Upton wrote:
> On Wed, Nov 04, 2026 at 06:32:43PM +0000, Leonardo Bras wrote:
> > > > > The operations would be, approximately:
> > > > > 
> > > > >  - Take a stage-2 permission fault on the cache maintenance instruction.
> > > > >    Walk the guest's stage-2 and find a translation in writable-clean
> > > > >    state.
> > > > > 
> > > > >  - Pause the VM, re-enter the guest and single-step the instruction. If
> > > > >    we take the debug exception then the guest must've changed the
> > > > >    instruction. Go back to base state.
> > > > 
> > > > Pausing the VM would be required so other vcpu treads do not access the 
> > > > page we are trying to run CMO on, right? 
> 
> Messing with the data side is fine, the concern is with the page the
> instruction sits in.
> 

Looks messy, indeed.

> > > > > 
> > > > >  - If we take another stage-2 permission fault for a cache maintenance
> > > > >    instruction, temporarily promote the translation to RW in the shadow
> > > > >    stage-2 and re-enter with single-step enabled.
> > 
> > But what if instead of RW we made it WC, and enabled Hardware HAFDBS just 
> > in this cpu?
> > 
> > Other CPUs with HAFDBS=off would fault on write, and we could block them 
> > there. 
> > 
> > (We would have to serialize those accesses, though, as multiple vcpus could 
> > use the same strategy at the same time)
> 
> That would do what we want, just the idea of maintaining some state
> machine across multiple guest exits feels pretty gnarly. Trap + emulate
> is the way to go if we can't NOP the CMO.

I agree.

Would it require to be across multiple guests, though?
I was thinking that as long as it's not the same page it would be ok, so it 
looked like the state machine would be particular to a guest (maybe a L1 
guest).

What am I missing?

Thanks!
Leo

