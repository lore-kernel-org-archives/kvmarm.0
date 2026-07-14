Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7463E34C130
	for <kvmarm@lists.linux.dev>; Tue, 14 Jul 2026 05:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784007690; cv=none; b=BsqIy5VUBhU5ZyBdIuy34TtdUpB7CP76ZRHRfBoCmHJrkSvC1hu34VP/7nzfCAWVSLy0aXR0wbCg6qul2aQ0E6bckxLLStHQ9pNldRiVa8pQaSMmir6UNJCh5/1gsB89qKHc6N3QPrBu5dQ3+rEXEuhEKhm5jtUdWtMJMyondpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784007690; c=relaxed/simple;
	bh=OxxCw0TrrbqDbRQCeH+h9QyaAVJCaa7E/Y+YYgZK8uE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GoDuCgF3ljVtFj7YHb5ArYvXh4EAjJA8mbasB54+WoAXtTVxbFwxZo7o1i3u4s4y8neCQXBOe6CXGcNG5CJsGDEVS/2TqrpV17//DLE3l4BrRxInCP8JN53JI50mxO6rH9Hep0SrRGokTp9f+Uj0G6ZOOm6XaNT+4OfJRA7rQJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=EeuS9kub; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="EeuS9kub"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7EADA1570;
	Mon, 13 Jul 2026 22:41:23 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 39D3B3F7D8;
	Mon, 13 Jul 2026 22:41:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784007687; bh=OxxCw0TrrbqDbRQCeH+h9QyaAVJCaa7E/Y+YYgZK8uE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EeuS9kubCQ+xtAVWkvq4ZrsPojmfiQI3x+ScLfDa7wf4UX0hhHG+Vz40M4vcTHUMT
	 MNxrppE+wOJ7mrvPfKpWT8jlMsPg2jZrdi0rC503LiuR4NGyPUJJFxu2ggruILeFCl
	 QxwjL5pXChyzcbfjd5enH90oXy0tFRQeYmI8ihjI=
Date: Tue, 14 Jul 2026 06:41:11 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Leonardo Bras <leo.bras@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>, 
	Raghavendra Rao Ananta <rananta@google.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/3] KVM: arm64: Introduce
 KVM_PGTABLE_WALK_SKIP_LEVEL* walk flags
Message-ID: <4d5imbtps2p35zujbupzmvag6m46yc4jz4qnoje6pdwlx4zuno@wom5iiwkszzs>
References: <20260708134101.2514759-1-leo.bras@arm.com>
 <20260708134101.2514759-3-leo.bras@arm.com>
 <jiy6rtx24nqnnduze3uuvc2ifqrjlskhefyctlwyh2jshdjrw2@a2wpodq6ife6>
 <alS6hwzsBUEfvBEk@LeoBrasDK>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alS6hwzsBUEfvBEk@LeoBrasDK>

On Mon, Jul 13, 2026 at 11:14:32AM +0100, Leonardo Bras wrote:
> On Sat, Jul 11, 2026 at 06:53:28AM +0100, Wei-Lin Chang wrote:
> > Hi Leonardo,
> 
> Hi Wei-Lin, thanks for reviewing!
> 
> > 
> > On Wed, Jul 08, 2026 at 02:40:58PM +0100, Leonardo Bras wrote:
> > > Add the new walking flags that tell kvm_pgtable_walk() to skip lower levels
> > > when walking the pagetables.
> > > 
> > > Signed-off-by: Leonardo Bras <leo.bras@arm.com>
> > > ---
> > >  arch/arm64/include/asm/kvm_pgtable.h | 13 +++++++++++++
> > >  arch/arm64/kvm/hyp/pgtable.c         | 19 ++++++++++++++++---
> > >  2 files changed, 29 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> > > index 41a8687938eb..20c7c12e0e76 100644
> > > --- a/arch/arm64/include/asm/kvm_pgtable.h
> > > +++ b/arch/arm64/include/asm/kvm_pgtable.h
> > > @@ -311,31 +311,44 @@ typedef bool (*kvm_pgtable_force_pte_cb_t)(u64 addr, u64 end,
> > >   * @KVM_PGTABLE_WALK_SHARED:		Indicates the page-tables may be shared
> > >   *					with other software walkers.
> > >   * @KVM_PGTABLE_WALK_IGNORE_EAGAIN:	Don't terminate the walk early if
> > >   *					the walker returns -EAGAIN.
> > >   * @KVM_PGTABLE_WALK_SKIP_BBM_TLBI:	Visit and update table entries
> > >   *					without Break-before-make's
> > >   *					TLB invalidation.
> > >   * @KVM_PGTABLE_WALK_SKIP_CMO:		Visit and update table entries
> > >   *					without Cache maintenance
> > >   *					operations required.
> > > + * @KVM_PGTABLE_WALK_SKIP_LEVEL0:	Skip visiting level-0+ entries
> > > + * @KVM_PGTABLE_WALK_SKIP_LEVEL1:	Skip visiting level-1+ entries
> > > + * @KVM_PGTABLE_WALK_SKIP_LEVEL2:	Skip visiting level-2+ entries
> > > + * @KVM_PGTABLE_WALK_SKIP_LEVEL3:	Skip visiting level-3 entries
> > 
> > Just a drive-by nit:
> > Maybe avoid the level-$LEVEL terminology? Since as you said there is
> > level -1 in the architecture, in that case you'd have to write
> > "level--1" which is awkward :)
> 
> It would have to be something like level-(-1), or we could call it level+1, 
> LOL.

Good one! :)

> 
> Seriously though, yes it's bad.
> I could call it level_1 entries, but level_-1 also seems weird :(
> level(1) & level(-1) could work, but looks like a function now
> 
> maybe just saying 'level 1' and 'level -1' can be better.

Yeah, I generally also just go with the space when it's text.
For code/variables, I guess a direct concatenation like what's done here
for the enum is good.

Thanks,
Wei-Lin Chang

> 
> What do you think?
> 
> Thanks!
> Leo
> 
>  
