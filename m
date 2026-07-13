Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACEAE3E5A39
	for <kvmarm@lists.linux.dev>; Mon, 13 Jul 2026 10:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783937679; cv=none; b=JkgDtknAhTf4pM0iDJKlAfAj4QES5C5LaI2/TmtZqezWJF7BDrUXWQS1qO/weqymr31FtMCl4inphcJOSIlRaP+CVF643/1boyyG9rIPlwFNsSJqkgoN+No6UEtSWvfbjQdqwnouOu8HVdV8bCFMNYPEaa5DzK+qtw709Xwp3Wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783937679; c=relaxed/simple;
	bh=hOTtIDDwEJ38L9MsPeZ5bG3KTsWQQaBXqxWIWrr/gWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=n905F1PUXvvbOtfGUAbmC22Enzlqcrtu/2ZdhVCTEr4GrGGKumjt9CYlG6XiHvmxD0WkpkKef62J8Vxkf8RBNeJXNNQ1whR5MmLwmNVYriJkCX0Qt+JEpeiuNfgxTyqUBmr2LortgTUnsy+FueGimC+1NE8oJy1jXS07LqWUA6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=rdk5qzyz; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="rdk5qzyz"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 106E21576;
	Mon, 13 Jul 2026 03:14:32 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 300E63F93E;
	Mon, 13 Jul 2026 03:14:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783937676; bh=hOTtIDDwEJ38L9MsPeZ5bG3KTsWQQaBXqxWIWrr/gWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rdk5qzyzFynDS7AUmdGerzb726zmchFq1rtgdUHYqLhzfjGlSFg8qbUIc2XqnlHPQ
	 2GlOoBtSaaGXUB/P7FhIqhRZET45/O3YFgXUtEABKJ3Rg84lS4G6bZMHCkmB4W/Msy
	 ED4jMdeT8O8zkVNK+AET6iqQqpbRFIwbj/Q4buXo=
From: Leonardo Bras <leo.bras@arm.com>
To: Wei-Lin Chang <weilin.chang@arm.com>
Cc: Leonardo Bras <leo.bras@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/3] KVM: arm64: Introduce KVM_PGTABLE_WALK_SKIP_LEVEL* walk flags
Date: Mon, 13 Jul 2026 11:14:32 +0100
Message-ID: <alS6hwzsBUEfvBEk@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <jiy6rtx24nqnnduze3uuvc2ifqrjlskhefyctlwyh2jshdjrw2@a2wpodq6ife6>
References: <20260708134101.2514759-1-leo.bras@arm.com> <20260708134101.2514759-3-leo.bras@arm.com> <jiy6rtx24nqnnduze3uuvc2ifqrjlskhefyctlwyh2jshdjrw2@a2wpodq6ife6>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Sat, Jul 11, 2026 at 06:53:28AM +0100, Wei-Lin Chang wrote:
> Hi Leonardo,

Hi Wei-Lin, thanks for reviewing!

> 
> On Wed, Jul 08, 2026 at 02:40:58PM +0100, Leonardo Bras wrote:
> > Add the new walking flags that tell kvm_pgtable_walk() to skip lower levels
> > when walking the pagetables.
> > 
> > Signed-off-by: Leonardo Bras <leo.bras@arm.com>
> > ---
> >  arch/arm64/include/asm/kvm_pgtable.h | 13 +++++++++++++
> >  arch/arm64/kvm/hyp/pgtable.c         | 19 ++++++++++++++++---
> >  2 files changed, 29 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> > index 41a8687938eb..20c7c12e0e76 100644
> > --- a/arch/arm64/include/asm/kvm_pgtable.h
> > +++ b/arch/arm64/include/asm/kvm_pgtable.h
> > @@ -311,31 +311,44 @@ typedef bool (*kvm_pgtable_force_pte_cb_t)(u64 addr, u64 end,
> >   * @KVM_PGTABLE_WALK_SHARED:		Indicates the page-tables may be shared
> >   *					with other software walkers.
> >   * @KVM_PGTABLE_WALK_IGNORE_EAGAIN:	Don't terminate the walk early if
> >   *					the walker returns -EAGAIN.
> >   * @KVM_PGTABLE_WALK_SKIP_BBM_TLBI:	Visit and update table entries
> >   *					without Break-before-make's
> >   *					TLB invalidation.
> >   * @KVM_PGTABLE_WALK_SKIP_CMO:		Visit and update table entries
> >   *					without Cache maintenance
> >   *					operations required.
> > + * @KVM_PGTABLE_WALK_SKIP_LEVEL0:	Skip visiting level-0+ entries
> > + * @KVM_PGTABLE_WALK_SKIP_LEVEL1:	Skip visiting level-1+ entries
> > + * @KVM_PGTABLE_WALK_SKIP_LEVEL2:	Skip visiting level-2+ entries
> > + * @KVM_PGTABLE_WALK_SKIP_LEVEL3:	Skip visiting level-3 entries
> 
> Just a drive-by nit:
> Maybe avoid the level-$LEVEL terminology? Since as you said there is
> level -1 in the architecture, in that case you'd have to write
> "level--1" which is awkward :)

It would have to be something like level-(-1), or we could call it level+1, 
LOL.

Seriously though, yes it's bad.
I could call it level_1 entries, but level_-1 also seems weird :(
level(1) & level(-1) could work, but looks like a function now

maybe just saying 'level 1' and 'level -1' can be better.

What do you think?

Thanks!
Leo

 
