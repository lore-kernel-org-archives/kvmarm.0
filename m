Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1C2C41CB48;
	Wed,  8 Jul 2026 15:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783525747; cv=none; b=rKBRExDao2CNkzr5MBLy/j6mckr+05fPZ6wPiWn/3XQKEDzGWpAt1yf5OeVQz0V9+urgwEuoaFcvE5AqVMPWeDpdfNXUV4g886bD/rBuKK7I6R5NP68wjyWn2i1jcymrxJem+RPHnG4srttsETQ9pvEpJ9qNmZWFTFiI73ZPuU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783525747; c=relaxed/simple;
	bh=EWdlNvsirIypqFLmHDSLbGQCNStlRMboPldcKtzupos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=F49No8oEigNVUR3VJEDt+/PxxOadGZO8fdA4IXDGOqQQVCsOMqyKK2k9obEV6ARvPQVA/jFr8J21jIHpDZpkirEk9VsAKdDrOCewcLSON0idPZcOuxVzp+FyxrLx9cqLLhCgPfCpHPHwHM5HbwJEJOy4fLLOHss1ZShC2CDeJTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=iuRUQvTY; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="iuRUQvTY"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E32341D14;
	Wed,  8 Jul 2026 08:48:59 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5FD923F905;
	Wed,  8 Jul 2026 08:49:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783525744; bh=EWdlNvsirIypqFLmHDSLbGQCNStlRMboPldcKtzupos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iuRUQvTYBALas6Ybc3/Xe4udcJ5iJkD1yNWVBuo7xGEAzHX0x2plUs6SEnwmvXWI9
	 S72UeHU36e/jo+2L3EPluEZ1FBLsj3uW1UdJKipE7aCXHJ+l31Pfbn8AdvaKOEZw9K
	 eYp688AzuWNmH0mO3PcQXsYCI3QiyrO8qm+Yw4aw=
From: Leonardo Bras <leo.bras@arm.com>
To: sashiko-reviews@lists.linux.dev
Cc: Leonardo Bras <leo.bras@arm.com>,
	kvmarm@lists.linux.dev,
	Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v3 2/3] KVM: arm64: Introduce KVM_PGTABLE_WALK_SKIP_LEVEL* walk flags
Date: Wed,  8 Jul 2026 16:49:01 +0100
Message-ID: <ak5xbWIh4U3hbbx8@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260708135012.3B21A1F000E9@smtp.kernel.org>
References: <20260708134101.2514759-1-leo.bras@arm.com> <20260708134101.2514759-3-leo.bras@arm.com> <20260708135012.3B21A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Jul 08, 2026 at 01:50:11PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] KVM_PGTABLE_WALK_SKIP_LEVEL* flags fail to skip the starting root level of the page table walk.
> --
> 
> --- Patch [2]: [PATCH v3 2/3] KVM: arm64: Introduce KVM_PGTABLE_WALK_SKIP_LEVEL* walk flags ---
> commit 5ddf63ba492be8c2a84af0b81cf00790fc72767a
> Author: Leonardo Bras <leo.bras@arm.com>
> 
> KVM: arm64: Introduce KVM_PGTABLE_WALK_SKIP_LEVEL* walk flags
> 
> This commit adds new walking flags that tell kvm_pgtable_walk() to skip
> lower levels when traversing page tables.
> 
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > index 4be1d51a6ac58..b9a2078efc519 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> 
> [ ... ]
> 
> > @@ -192,7 +205,7 @@ static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
> >  	if (!kvm_pgtable_walk_continue(data->walker, ret))
> >  		return ret;
> >  
> > -	if (!table) {
> > +	if (!table || kvm_pgtable_skip_level(level + 1, ctx.flags)) {
> 
> [Severity: Medium]
> Does this fail to skip the starting level of the page table walk if that
> initial level matches the skip criteria?
> 
> Looking at __kvm_pgtable_visit() in arch/arm64/kvm/hyp/pgtable.c, the visitor
> callbacks are executed unconditionally for the current level before we reach
> this skip check:
> 
> 	if (table && (ctx.flags & KVM_PGTABLE_WALK_TABLE_PRE)) {
> 		ret = kvm_pgtable_visitor_cb(data, &ctx, KVM_PGTABLE_WALK_TABLE_PRE);
> 		reload = true;
> 	}
> 
> 	if (!table && (ctx.flags & KVM_PGTABLE_WALK_LEAF)) {
> 		ret = kvm_pgtable_visitor_cb(data, &ctx, KVM_PGTABLE_WALK_LEAF);
> 		reload = true;
> 	}
> 
> Since the skip condition here only evaluates level + 1 to prevent descending
> further, if a caller begins a walk at a level that should be skipped (for
> example, starting at level 2 with KVM_PGTABLE_WALK_SKIP_LEVEL2), the callbacks
> for that root level will still execute. 
> 
> Should the current level also be checked against the skip flags before
> executing the pre-table or leaf visitor callbacks?

Yes, we do execute the callback at least in the root we are given, which 
can have bad results in some scenario. That being said, testing here is not 
the best place, as this function will be called a lot.

If we want to avoid that scenario, I suggest we do that test before 
starting the walk, which would be on  _kvm_pgtable_walk(), except that both
kvm_pgtable_stage2_create_unlinked(), and 
kvm_pgtable_stage2_free_unlinked()
will call _kvm_pgtable_walk() directly.

(although they don't use skip_level paramters, yet)

Will take a look on that.

Thanks!
Leo
