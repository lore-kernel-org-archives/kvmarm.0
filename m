Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 742BA405C30
	for <kvmarm@lists.linux.dev>; Wed, 17 Jun 2026 13:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781703077; cv=none; b=AXrRAMYk+GzheYgneIRnT3OFJhFJUy8W05BlffFlDJbmHa3SCQDbT2Ir3gsfQr0bdoxbuySTpucG1WtMTCvdkSBi4opyNh3OADDyK+4W2fnr7ErX9TjXPFofvmC2i51OotEDD/VelgxGrXp8kzy00JUOCdk+4pGSgOpzRLg2rt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781703077; c=relaxed/simple;
	bh=4RSlRR4DXqslGaZVePecG7K3a4FqJN78zhQmH65ub2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=GQB2IUk/zwGWGAXETAgGM8nuzrEK6jGaPkn0QtEOpX+8krV51hL+LVRb4Qlz5FU5J+JXJ9jxmJ4xULmYM7+m5Pthdn49C6w4zDsoVj6cbYiNupU40R0z76DdE1h91D4uY/zbrAief1HAESCMdwbfjxlzFG0kHskz/pV67G6boLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=sGTh0csT; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="sGTh0csT"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 01DD74794;
	Wed, 17 Jun 2026 06:31:10 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (devkitleo.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DB84E3F915;
	Wed, 17 Jun 2026 06:31:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1781703074; bh=4RSlRR4DXqslGaZVePecG7K3a4FqJN78zhQmH65ub2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sGTh0csTMy0CkaiPUeHWvso+LfAj3NpbVtQ2lLyO9hP0VI/Wi2tI7I4kRz1Ihm7xK
	 aV6AZZ/awpKaNB/WA6+gKeNjScGaT8Va9g/svgQkPcMQDsfzF+sk/CYHL8trZuWL+O
	 KmaXeAAkYvluKuOqI5dBqatwHg5GJUYLBWNTCFcU=
From: Leonardo Bras <leo.bras@arm.com>
To: kvmarm@lists.linux.dev
Cc: Leonardo Bras <leo.bras@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v1 1/2] KVM: arm64: Introduce KVM_PGTABLE_WALK_SKIP_LEVEL* walk flags
Date: Wed, 17 Jun 2026 14:30:57 +0100
Message-ID: <aiqCPDKcb1oA5EgM@devkitleo>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260610203043.25A771F00893@smtp.kernel.org>
References: <20260610202112.2695205-3-leo.bras@arm.com> <20260610203043.25A771F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Jun 10, 2026 at 08:30:42PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
> - [Medium] Combining skip flags causes the walker to ignore the more restrictive skip levels due to fls() usage.
> - [Medium] Skipping a page table level bypasses the KVM_PGTABLE_WALK_TABLE_POST callback, breaking PRE/POST callback symmetry.
> - [Low] The skip logic cannot prevent the root level from being visited, making SKIP_LEVEL0 ineffective when start_level == 0.
> --
> 
> commit 4e6415e54e22d985a0c97622b8e8b28b4c84b54b
> Author: Leonardo Bras <leo.bras@arm.com>
> 
> KVM: arm64: Introduce KVM_PGTABLE_WALK_SKIP_LEVEL* walk flags
> 
> Add the new walking flags that tell kvm_pgtable_walk() to skip lower levels
> when walking the pagetables.
> 
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > index 91a7dfad66866..48d88a290a538 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> 
> [ ... ]
> 
> > @@ -144,6 +144,19 @@ static bool kvm_pgtable_walk_continue(const struct kvm_pgtable_walker *walker,
> >  	return !r;
> >  }
> >  
> > +static __always_inline bool kvm_pgtable_skip_level(s8 level, enum kvm_pgtable_walk_flags flags)
> > +{
> > +	flags &= KVM_PGTABLE_WALK_SKIP_LEVELS;
> > +
> > +	if (likely(!flags))
> > +		return false;
> > +
> > +	if (level >= (fls(flags) - ffs(KVM_PGTABLE_WALK_SKIP_LEVELS)))
> 
> [Severity: Medium]
> Will this evaluate to the highest level if multiple skip flags are ORed
> together?
> 
> If a caller combines flags like KVM_PGTABLE_WALK_SKIP_LEVEL1 and
> KVM_PGTABLE_WALK_SKIP_LEVEL2, fls() will select the highest set bit. This
> means the threshold evaluates to level 2, effectively ignoring the more
> restrictive SKIP_LEVEL1 flag and incorrectly descending into levels the
> caller requested to skip.
> 
> Should kvm_pgtable_skip_level() use ffs() instead of fls() to select the
> lowest requested level as the definitive stopping point?
> 

Correct. We should have s/fls/ffs/ in that line, so:
+   if (level >= (ffs(flags) - ffs(KVM_PGTABLE_WALK_SKIP_LEVELS)))

That will select the lowest level, instead of the highest.

Since the tests were done only with a single skiplevel selected, ffs and 
fls return the same bit, so performance results should not be affected. 

> > +		return true;
> > +
> > +	return false;
> > +}
> 
> [ ... ]
> 
> > @@ -192,7 +205,7 @@ static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
> >  	if (!kvm_pgtable_walk_continue(data->walker, ret))
> >  		goto out;
> >  
> > -	if (!table) {
> > +	if (!table || kvm_pgtable_skip_level(level + 1, ctx.flags)) {
> 
> [Severity: Medium]
> Does skipping the level here bypass the KVM_PGTABLE_WALK_TABLE_POST callback?
> 
> If the current entry is a table, the KVM_PGTABLE_WALK_TABLE_PRE callback is
> executed earlier in __kvm_pgtable_visit(). If kvm_pgtable_skip_level() then
> evaluates to true, the code executes an early exit via goto out.
> 
> This completely bypasses the KVM_PGTABLE_WALK_TABLE_POST callback at the
> end of the function, leaving the TABLE_PRE call unbalanced. If a walker
> relies on symmetric PRE and POST callbacks to clean up resources or track
> traversal depth, could this asymmetric execution flow lead to resource leaks
> or state inconsistency?

Correct. PRE and POST are called only on table entries, and in the case 
skip levels is enabled it will completelly skip that post, which is 
undesired.

To fix that, I propose the following:
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -209,24 +209,24 @@ static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
        childp = (kvm_pteref_t)kvm_pte_follow(ctx.old, mm_ops);
        ret = __kvm_pgtable_walk(data, mm_ops, childp, level + 1);
        if (!kvm_pgtable_walk_continue(data->walker, ret))
                goto out;

-       if (ctx.flags & KVM_PGTABLE_WALK_TABLE_POST)
+out:
+       if (table && ctx.flags & KVM_PGTABLE_WALK_TABLE_POST)
                ret = kvm_pgtable_visitor_cb(data, &ctx, KVM_PGTABLE_WALK_TABLE_POST);

-out:
---

I suppose the extra test will be optimized well by the compiler, and we 
should see not much difference in performance.

Only other alternative I can see would be to add an extra label, and a copy 
of the increasing data->addr.

> 
> [Severity: Low]
> Does checking level + 1 prevent the root level from being skipped?
> 
> The walker unconditionally calls __kvm_pgtable_visit() for entries at the
> root page table (start_level). Because the skip evaluation checks level + 1,
> it only governs whether the walker descends into the children of the current
> level.
> 
> If start_level == 0 and the walker requests SKIP_LEVEL0, won't the walker
> still visit level 0 and invoke its callbacks, making SKIP_LEVEL0 functionally
> identical to SKIP_LEVEL1 in this case?

Correct. But I don't see the usefulness of this being different.
SKIP_LEVEL0 is supposed to be useful if the root level is -1.
What would be a use case of having a flag to skip the root level? Why would 
the pagetable walk be called, then?


> 
> >  		data->addr = ALIGN_DOWN(data->addr, kvm_granule_size(level));
> >  		data->addr += kvm_granule_size(level);
> >  		goto out;
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260610202112.2695205-2-leo.bras@arm.com?part=1

Thanks!
Leo

