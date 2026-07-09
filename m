Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBCEC233933
	for <kvmarm@lists.linux.dev>; Thu,  9 Jul 2026 14:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783607160; cv=none; b=d6VhShPD355x3CSYgwDT/eu6oIt09sgxzub28lmOufCQG8amWP3GeR0M+C6zBWkRuoeAIeP5e17eReorKHWaNxAPT4vDwZqo4XBXxds9qmiNsA1tEu1xNZmgrUTqpEMaBY6NngxHsncQn9xK6HF0Hf32imViyJ3N346u4S3ZSgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783607160; c=relaxed/simple;
	bh=t/1cky5+DUWV8jkfkoFfgRk8CUIz4wRifGyX1Xturgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=G5Z6hXnHh4bQWsQRBIqtoNTQnMXuMvbJKKfSL0wIQ37nV7Su6ldj1pAbm/yMGRqjQYHoFOybOJztMCtbfgK0Vlno0ewHWHHLi1Xj74qEcXWel8MMaaRu275CT0ToD5/Q7FubETLrDRTESi/dqdBRL/2inMibwHiT//eZTJ6gaQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=qv1sm20O; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="qv1sm20O"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 21BD93592;
	Thu,  9 Jul 2026 07:25:54 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1921A3F66F;
	Thu,  9 Jul 2026 07:25:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783607158; bh=t/1cky5+DUWV8jkfkoFfgRk8CUIz4wRifGyX1Xturgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qv1sm20O4agpiSaHGYhF4Zsn9DHymqjG1zUy5AHJp6N4evImUKxglQTrdvsU3/f5v
	 N8Zc5MfnyeEt2eDsbOzLhY1QwR+AGSWIwwnKqhJx0PjUFnEvHk9p99m+CRRbIewDzL
	 3UBBdsNGqXFstDAwSb+kzm/VcCdfNOU+F//H3GG0=
From: Leonardo Bras <leo.bras@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
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
Date: Thu,  9 Jul 2026 15:25:50 +0100
Message-ID: <ak-vblq_CMADABBi@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <871pdd764g.wl-maz@kernel.org>
References: <20260708134101.2514759-1-leo.bras@arm.com> <20260708134101.2514759-3-leo.bras@arm.com> <871pdd764g.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Jul 08, 2026 at 06:17:51PM +0100, Marc Zyngier wrote:
> On Wed, 08 Jul 2026 14:40:58 +0100,
> Leonardo Bras <leo.bras@arm.com> wrote:
> > 
> > Add the new walking flags that tell kvm_pgtable_walk() to skip lower levels
> > when walking the pagetables.
> 
> I don't understand what 'lower' means here. There is also no
> description of what this patch is trying to do, or why it is trying to
> do it. All I see is a wall of code with no rationale, no explanation.

Indeed, the description is very poor. Sorry about that.

For next version, what about something like that:

Add new walking flags KVM_PGTABLE_WALK_SKIP_LEVEL{0-3}.
When used, they make the kvm_pgtable_walk() skip the given level, as well 
as levels higher than that. 


> 
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
> Skip under which conditions? Always?

Yes, if passed they will skip visiting those levels.

The only current issue with this patchset is that the root of the subtree 
passed is always visited. But I should be able to fix that for next 
version.

> 
> >   */
> >  enum kvm_pgtable_walk_flags {
> >  	KVM_PGTABLE_WALK_LEAF			= BIT(0),
> >  	KVM_PGTABLE_WALK_TABLE_PRE		= BIT(1),
> >  	KVM_PGTABLE_WALK_TABLE_POST		= BIT(2),
> >  	KVM_PGTABLE_WALK_SHARED			= BIT(3),
> >  	KVM_PGTABLE_WALK_IGNORE_EAGAIN		= BIT(4),
> >  	KVM_PGTABLE_WALK_SKIP_BBM_TLBI		= BIT(5),
> >  	KVM_PGTABLE_WALK_SKIP_CMO		= BIT(6),
> > +	KVM_PGTABLE_WALK_SKIP_LEVEL0		= BIT(7),
> > +	KVM_PGTABLE_WALK_SKIP_LEVEL1		= BIT(8),
> > +	KVM_PGTABLE_WALK_SKIP_LEVEL2		= BIT(9),
> > +	KVM_PGTABLE_WALK_SKIP_LEVEL3		= BIT(10),
> 
> There is a strong assumption that these bits must be contiguous. 

Correct. They can be shifted in the flags variable, but not reordered nor 
split.

> And
> yet that's not captured anywhere. Want to bet what is going to happen
> next?

I assumed that once the flags get defined, they are not usually changed or 
reordered, I only prepared for a day where we need skipping level -1 
as well, as it can be added below. 

But I think I get your point. Should have added a commend saying that the 
SKIP_LEVEL* flags should not be reordered nor split. 

Is that it? or you suggest doing something else?

> 
> >  };
> >  
> > +#define KVM_PGTABLE_WALK_SKIP_LEVELS 	(KVM_PGTABLE_WALK_SKIP_LEVEL0 | \
> > +					 KVM_PGTABLE_WALK_SKIP_LEVEL1 | \
> > +					 KVM_PGTABLE_WALK_SKIP_LEVEL2 | \
> > +					 KVM_PGTABLE_WALK_SKIP_LEVEL3 )
> > +
> >  struct kvm_pgtable_visit_ctx {
> >  	kvm_pte_t				*ptep;
> >  	kvm_pte_t				old;
> >  	void					*arg;
> >  	struct kvm_pgtable_mm_ops		*mm_ops;
> >  	u64					start;
> >  	u64					addr;
> >  	u64					end;
> >  	s8					level;
> >  	enum kvm_pgtable_walk_flags		flags;
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > index 4be1d51a6ac5..b9a2078efc51 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -137,20 +137,33 @@ static bool kvm_pgtable_walk_continue(const struct kvm_pgtable_walker *walker,
> >  	 * Ignore the return code altogether for walkers outside a fault handler
> >  	 * (e.g. write protecting a range of memory) and chug along with the
> >  	 * page table walk.
> >  	 */
> >  	if (r == -EAGAIN)
> >  		return walker->flags & KVM_PGTABLE_WALK_IGNORE_EAGAIN;
> >  
> >  	return !r;
> >  }
> >  
> > +static __always_inline bool kvm_pgtable_skip_level(s8 level, enum kvm_pgtable_walk_flags flags)
> 
> Why __always_inline? I'm sure the compiler can decide for itself.
> 

Right, will change that in next version.

> > +{
> > +	flags &= KVM_PGTABLE_WALK_SKIP_LEVELS;
> > +
> > +	if (likely(!flags))
> > +		return false;
> > +
> > +	if (level >= (ffs(flags) - ffs(KVM_PGTABLE_WALK_SKIP_LEVELS)))
> > +		return true;
> 
> This looks awfully complex for something this trivial:
> 
> 	u32 skip = FIELD_GET(KVM_PGTABLE_WALK_SKIP_LEVELS, flags);
> 
> 	return skip && level >= ffs(skip);
> 

My rationale was that in the regular case we would not have those flags 
set, so I tried to minimize any code that would be happening for that case.
So I used only a 'bitwise and' to check the flags, then returned if not 
used.

If one of those flags were set, then find the lowest level set, and check 
against the current level for skipping.

But looking into the ARM instructions, my rationale would be pointless, as 
there are instructions that AND+SHIFT at once, and your version with 
FIELD_GET() should be better.


> But also, you seem to assume that there cannot be more than one such
> flag set. I have no idea of the outcome in this situation, and the
> whole thing is completely undocumented anyway...
> 

ffs(flags) is meant to find the first set bit in the flags, which is, after 
the masking, the lowest level to skip. If you are skipping a level, it's 
supposed to skip all levels higher than that, as per the flag 
documentation:

+ * @KVM_PGTABLE_WALK_SKIP_LEVEL0:	Skip visiting level-0+ entries
+ * @KVM_PGTABLE_WALK_SKIP_LEVEL1:	Skip visiting level-1+ entries
+ * @KVM_PGTABLE_WALK_SKIP_LEVEL2:	Skip visiting level-2+ entries
+ * @KVM_PGTABLE_WALK_SKIP_LEVEL3:	Skip visiting level-3 entries
  */ 

The + above means any level above that as well.

> > +
> > +	return false;
> > +}
> > +
> >  static int __kvm_pgtable_walk(struct kvm_pgtable_walk_data *data,
> >  			      struct kvm_pgtable_mm_ops *mm_ops, kvm_pteref_t pgtable, s8 level);
> >  
> >  static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
> >  				      struct kvm_pgtable_mm_ops *mm_ops,
> >  				      kvm_pteref_t pteref, s8 level)
> >  {
> >  	enum kvm_pgtable_walk_flags flags = data->walker->flags;
> >  	kvm_pte_t *ptep = kvm_dereference_pteref(data->walker, pteref);
> >  	struct kvm_pgtable_visit_ctx ctx = {
> > @@ -185,35 +198,35 @@ static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
> >  	 * into a newly installed or replaced table.
> >  	 */
> >  	if (reload) {
> >  		ctx.old = READ_ONCE(*ptep);
> >  		table = kvm_pte_table(ctx.old, level);
> >  	}
> >  
> >  	if (!kvm_pgtable_walk_continue(data->walker, ret))
> >  		return ret;
> >  
> > -	if (!table) {
> > +	if (!table || kvm_pgtable_skip_level(level + 1, ctx.flags)) {
> >  		data->addr = ALIGN_DOWN(data->addr, kvm_granule_size(level));
> >  		data->addr += kvm_granule_size(level);
> >  		goto out;
> >  	}
> >  
> >  	childp = (kvm_pteref_t)kvm_pte_follow(ctx.old, mm_ops);
> >  	ret = __kvm_pgtable_walk(data, mm_ops, childp, level + 1);
> >  	if (!kvm_pgtable_walk_continue(data->walker, ret))
> >  		return ret;
> >  
> > -	if (ctx.flags & KVM_PGTABLE_WALK_TABLE_POST)
> > +out:
> > +	if (table && ctx.flags & KVM_PGTABLE_WALK_TABLE_POST)
> 
> I don't understand this change. Care to explain?

Sure!
Before this change, there was no need to test if the entry was 
a table before visiting it on WALK_TABLE_POST, as that if clause would 
only be reached by table entries.
 
(Since the 'out:' label was below it, and above there was an if (!table) 
that would always goto it, it was always skipped by !table entries)

With the moving of 'out:' label to above this clause, we need to check if 
the entry is actually a table before visiting with a WALK_TABLE_POST flag.
 
Now, the reason why I moved that label up is that the if(!table) clause 
received the '|| skip_level' check, and now we can have this scenario:
- table entry visited in WALK_TABLE_PRE,
- table got its children skipped due to skip_level, 
- need to visit it due to the WALK_TABLE_POST.

And that was the least intrusive way of doing it :)

Please let me know if I can make something else more clear!

Thanks!
Leo

 
