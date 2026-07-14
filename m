Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B44C4363087
	for <kvmarm@lists.linux.dev>; Tue, 14 Jul 2026 10:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784023993; cv=none; b=AqRpdolIOYkReUERCB23+w24HKbcFxBZP1nut1x/uqBSdZuOjRk4hD7cjLX73cXSAZMuBNjAbcqZMKrdIbwzwasy9EaPKOTvRRVXJCKzWR0JeHuBcp9zKNOj94sR2g8FaOiMKQF9RXYs62P5pvYr78i143XpCg44t7y/aBA+3uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784023993; c=relaxed/simple;
	bh=g7mASN1w+UMRPcOtlUAKXnklRJCF0YJxJU34hxUurtg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=kqe8chLBJ+7DXYuo58F+YNYHcTsqK/2InNa5ilQKtWKEtv5Qsi6hCidD1q0d0Pgltrp2EhEbcARJUHvzOQYhXFDpY4BVSzrFQUhIm7N04meZS3w/aRu6UBCO+4deTw36Tjcm+5QYaa5CK1TbDj0Rq2Q0NqITHuIrBQ8EEK233/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=cvuo8rF7; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="cvuo8rF7"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 919601476;
	Tue, 14 Jul 2026 03:13:05 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 502F63FAF5;
	Tue, 14 Jul 2026 03:13:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784023989; bh=g7mASN1w+UMRPcOtlUAKXnklRJCF0YJxJU34hxUurtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cvuo8rF7fLtQJaXzvusD6AKM4OJ8QEAIeTRlXzwiCpcTpYqUhmJQJKFySi1ejFX+r
	 w332l+4skESsmVNU8aYYoPQ03Q28sQC6qwWzkcyFtz0NjscDx3ft1WoNmvBBWVeCQ9
	 mVWQGekFSg5ybgTuAQG6qdN+qvmEydrSXAmGy8Vg=
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
Date: Tue, 14 Jul 2026 11:13:01 +0100
Message-ID: <alYLrbArDIKx1hh_@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <4d5imbtps2p35zujbupzmvag6m46yc4jz4qnoje6pdwlx4zuno@wom5iiwkszzs>
References: <20260708134101.2514759-1-leo.bras@arm.com> <20260708134101.2514759-3-leo.bras@arm.com> <jiy6rtx24nqnnduze3uuvc2ifqrjlskhefyctlwyh2jshdjrw2@a2wpodq6ife6> <alS6hwzsBUEfvBEk@LeoBrasDK> <4d5imbtps2p35zujbupzmvag6m46yc4jz4qnoje6pdwlx4zuno@wom5iiwkszzs>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Jul 14, 2026 at 06:41:11AM +0100, Wei-Lin Chang wrote:
> On Mon, Jul 13, 2026 at 11:14:32AM +0100, Leonardo Bras wrote:
> > On Sat, Jul 11, 2026 at 06:53:28AM +0100, Wei-Lin Chang wrote:
> > > Hi Leonardo,
> > 
> > Hi Wei-Lin, thanks for reviewing!
> > 
> > > 
> > > On Wed, Jul 08, 2026 at 02:40:58PM +0100, Leonardo Bras wrote:
> > > > Add the new walking flags that tell kvm_pgtable_walk() to skip lower levels
> > > > when walking the pagetables.
> > > > 
> > > > Signed-off-by: Leonardo Bras <leo.bras@arm.com>
> > > > ---
> > > >  arch/arm64/include/asm/kvm_pgtable.h | 13 +++++++++++++
> > > >  arch/arm64/kvm/hyp/pgtable.c         | 19 ++++++++++++++++---
> > > >  2 files changed, 29 insertions(+), 3 deletions(-)
> > > > 
> > > > diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> > > > index 41a8687938eb..20c7c12e0e76 100644
> > > > --- a/arch/arm64/include/asm/kvm_pgtable.h
> > > > +++ b/arch/arm64/include/asm/kvm_pgtable.h
> > > > @@ -311,31 +311,44 @@ typedef bool (*kvm_pgtable_force_pte_cb_t)(u64 addr, u64 end,
> > > >   * @KVM_PGTABLE_WALK_SHARED:		Indicates the page-tables may be shared
> > > >   *					with other software walkers.
> > > >   * @KVM_PGTABLE_WALK_IGNORE_EAGAIN:	Don't terminate the walk early if
> > > >   *					the walker returns -EAGAIN.
> > > >   * @KVM_PGTABLE_WALK_SKIP_BBM_TLBI:	Visit and update table entries
> > > >   *					without Break-before-make's
> > > >   *					TLB invalidation.
> > > >   * @KVM_PGTABLE_WALK_SKIP_CMO:		Visit and update table entries
> > > >   *					without Cache maintenance
> > > >   *					operations required.
> > > > + * @KVM_PGTABLE_WALK_SKIP_LEVEL0:	Skip visiting level-0+ entries
> > > > + * @KVM_PGTABLE_WALK_SKIP_LEVEL1:	Skip visiting level-1+ entries
> > > > + * @KVM_PGTABLE_WALK_SKIP_LEVEL2:	Skip visiting level-2+ entries
> > > > + * @KVM_PGTABLE_WALK_SKIP_LEVEL3:	Skip visiting level-3 entries
> > > 
> > > Just a drive-by nit:
> > > Maybe avoid the level-$LEVEL terminology? Since as you said there is
> > > level -1 in the architecture, in that case you'd have to write
> > > "level--1" which is awkward :)
> > 
> > It would have to be something like level-(-1), or we could call it level+1, 
> > LOL.
> 
> Good one! :)
> 
> > 
> > Seriously though, yes it's bad.
> > I could call it level_1 entries, but level_-1 also seems weird :(
> > level(1) & level(-1) could work, but looks like a function now
> > 
> > maybe just saying 'level 1' and 'level -1' can be better.
> 
> Yeah, I generally also just go with the space when it's text.
> For code/variables, I guess a direct concatenation like what's done here
> for the enum is good.
> 

Sure, noted for next version

Thanks!
Leo
