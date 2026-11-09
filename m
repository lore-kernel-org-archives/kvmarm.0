Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794232518;
	b=zfz9Na/3lUgQk9u2vQxQz5+cniNYOkFS/mjSryku+cVurx6+CFVwIMN3KczeXYTTGtSI
	 M6aVZ37yYrWXMGbp8YqYVwQihFXb398lvQA2MrkGaTfQ5b2f/VKOgDIBiIpzSiJ+gyn7Q
	 Wwo/TQPiCO0hFlDESxfsJdxb5ALY+i42hrEJqL6saRstWBdAJQiXZerAo+7BnV8R5G8BA
	 0JScIUk92WUJecCXsLsXvdfXQkOBF8jJPRQSdlC7PtI1GCzgpnEOmUJDwFD3qMt5D5Fwg
	 lYT0zqY8VEMB1D10qZKonv8AcqPs1ylA2fx3CyAuAzH+eWcD485AqIRxjn5bbFRV1xQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794232518;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding;
	bh=qyBKwFksJNX/3zANmADcweL35ZbCo7zw0f36je+aSa0=;
	b=QoIC1wCddInoACfeSjv6dsoRQvpWcX96Yk3xLJom9K35WBBzu+mSpdcIscY1aMp7b/ic
	 3Hb6vWjd+jaELJ60C1N9bmyRAxmWaTaud06FvfLAD0U5kMly3cFXPpzIrRcpw6b1J0TgC
	 v8C9qb45YzgngA3nOVg0K1U5FCZQPI5XUcBG53UZVJD6WpgGZwEB8utGBfZO0FD+ihIxS
	 KxkfyLomSCM7Wt+JbJ7dt5bjwWlJO7z6qIr9cPy8nuHpibhcDNWIyTmHbMiRMLfhWYxqE
	 iJ5meCalMHiaz1sm5m02DfmuwM/4VsDMVaIZvi2BFCaVQHtfmbr0PbDsaurHrz+Cqtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=b8Usqek3;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67242606A31C
	for <kvmarm@lists.linux.dev>; Mon,  9 Nov 2026 13:55:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 67242606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=b8Usqek3
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9CF7114BF;
	Mon,  9 Nov 2026 05:55:13 -0800 (PST)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6C3F13F632;
	Mon,  9 Nov 2026 05:55:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794232516; bh=KJJLhpniQZUmQ77hpm1zsDXOiW1CCXxKt62dmhbtma8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b8Usqek3kaVUOB1RB0xwIA04Lp+O+RMitLE1+TFQAq4X64T9fjtId114taMH3frRl
	 uKaZaRYI3VzAPYg9BkjXhmSjl9Z9fCVabsIalNzEHG3yDozSmuQbmFGDj9pvCUCHl0
	 RU9u7X30AsjjJzRT1Z8wrFgLwHe0DDdE1gdE9jI4=
From: Leonardo Bras <leo.bras@arm.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Leonardo Bras <leo.bras@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v4 2/3] KVM: arm64: Introduce KVM_PGTABLE_WALK_SKIP_LEVEL* walk flags
Date: Mon,  9 Nov 2026 13:55:05 +0000
Message-ID: <avHQubuK6r3k9anX@LeoBrasDK>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <60fe23f4-4fca-41b6-8489-a28ab7b281f9@arm.com>
References: <20261106161240.1345126-1-leo.bras@arm.com> <20261106161240.1345126-3-leo.bras@arm.com> <60fe23f4-4fca-41b6-8489-a28ab7b281f9@arm.com>
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

On Fri, Nov 06, 2026 at 05:02:31PM +0000, Suzuki K Poulose wrote:
> On 06/11/2026 16:12, Leonardo Bras wrote:
> > Add new walking flags KVM_PGTABLE_WALK_SKIP_LEVEL{0-3}.
> > When used, they make the kvm_pgtable_walk() skip the given level, as well
> > as levels higher than that.
> > 
> > Being able to skip levels substancially decreases the runtime of a
> 
> minor nit: substantially

fixed!

> 
> > pagetable walk when the callback function does nothing on that level.
> > 
> > Signed-off-by: Leonardo Bras <leo.bras@arm.com>
> > ---
> >   arch/arm64/include/asm/kvm_pgtable.h | 14 ++++++++++++++
> >   arch/arm64/kvm/hyp/pgtable.c         | 16 +++++++++++++---
> >   2 files changed, 27 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> > index 41a8687938eb..5f37ceef8d63 100644
> > --- a/arch/arm64/include/asm/kvm_pgtable.h
> > +++ b/arch/arm64/include/asm/kvm_pgtable.h
> > @@ -311,31 +311,45 @@ typedef bool (*kvm_pgtable_force_pte_cb_t)(u64 addr, u64 end,
> >    * @KVM_PGTABLE_WALK_SHARED:		Indicates the page-tables may be shared
> >    *					with other software walkers.
> >    * @KVM_PGTABLE_WALK_IGNORE_EAGAIN:	Don't terminate the walk early if
> >    *					the walker returns -EAGAIN.
> >    * @KVM_PGTABLE_WALK_SKIP_BBM_TLBI:	Visit and update table entries
> >    *					without Break-before-make's
> >    *					TLB invalidation.
> >    * @KVM_PGTABLE_WALK_SKIP_CMO:		Visit and update table entries
> >    *					without Cache maintenance
> >    *					operations required.
> > + * @KVM_PGTABLE_WALK_SKIP_LEVEL0:	Skip visiting level 0+ entries
> > + * @KVM_PGTABLE_WALK_SKIP_LEVEL1:	Skip visiting level 1+ entries
> > + * @KVM_PGTABLE_WALK_SKIP_LEVEL2:	Skip visiting level 2+ entries
> > + * @KVM_PGTABLE_WALK_SKIP_LEVEL3:	Skip visiting level 3 entries
> >    */
> >   enum kvm_pgtable_walk_flags {
> >   	KVM_PGTABLE_WALK_LEAF			= BIT(0),
> >   	KVM_PGTABLE_WALK_TABLE_PRE		= BIT(1),
> >   	KVM_PGTABLE_WALK_TABLE_POST		= BIT(2),
> >   	KVM_PGTABLE_WALK_SHARED			= BIT(3),
> >   	KVM_PGTABLE_WALK_IGNORE_EAGAIN		= BIT(4),
> >   	KVM_PGTABLE_WALK_SKIP_BBM_TLBI		= BIT(5),
> >   	KVM_PGTABLE_WALK_SKIP_CMO		= BIT(6),
> > +	/* SKIP_LEVEL* flags should not be split nor reordered */
> > +	KVM_PGTABLE_WALK_SKIP_LEVEL0		= BIT(7),
> > +	KVM_PGTABLE_WALK_SKIP_LEVEL1		= BIT(8),
> > +	KVM_PGTABLE_WALK_SKIP_LEVEL2		= BIT(9),
> > +	KVM_PGTABLE_WALK_SKIP_LEVEL3		= BIT(10),
> >   };
> > +#define KVM_PGTABLE_WALK_SKIP_LEVELS 	(KVM_PGTABLE_WALK_SKIP_LEVEL0 | \
> > +					 KVM_PGTABLE_WALK_SKIP_LEVEL1 | \
> > +					 KVM_PGTABLE_WALK_SKIP_LEVEL2 | \
> > +					 KVM_PGTABLE_WALK_SKIP_LEVEL3 )
> > +
> >   struct kvm_pgtable_visit_ctx {
> >   	kvm_pte_t				*ptep;
> >   	kvm_pte_t				old;
> >   	void					*arg;
> >   	struct kvm_pgtable_mm_ops		*mm_ops;
> >   	u64					start;
> >   	u64					addr;
> >   	u64					end;
> >   	s8					level;
> >   	enum kvm_pgtable_walk_flags		flags;
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > index 7a51f78b6446..80744478c810 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -137,20 +137,27 @@ static bool kvm_pgtable_walk_continue(const struct kvm_pgtable_walker *walker,
> >   	 * Ignore the return code altogether for walkers outside a fault handler
> >   	 * (e.g. write protecting a range of memory) and chug along with the
> >   	 * page table walk.
> >   	 */
> >   	if (r == -EAGAIN)
> >   		return walker->flags & KVM_PGTABLE_WALK_IGNORE_EAGAIN;
> >   	return !r;
> >   }
> > +static bool kvm_pgtable_skip_level(s8 level, enum kvm_pgtable_walk_flags flags)
> > +{
> > +	u32 skip = FIELD_GET(KVM_PGTABLE_WALK_SKIP_LEVELS, flags);
> > +
> > +	return unlikely(skip && level >= ffs(skip) - 1);
> > +}
> > +
> >   static int __kvm_pgtable_walk(struct kvm_pgtable_walk_data *data,
> >   			      struct kvm_pgtable_mm_ops *mm_ops, kvm_pteref_t pgtable, s8 level);
> >   static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
> >   				      struct kvm_pgtable_mm_ops *mm_ops,
> >   				      kvm_pteref_t pteref, s8 level)
> >   {
> >   	enum kvm_pgtable_walk_flags flags = data->walker->flags;
> >   	kvm_pte_t *ptep = kvm_dereference_pteref(data->walker, pteref);
> >   	struct kvm_pgtable_visit_ctx ctx = {
> > @@ -185,35 +192,35 @@ static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
> >   	 * into a newly installed or replaced table.
> >   	 */
> >   	if (reload) {
> >   		ctx.old = READ_ONCE(*ptep);
> >   		table = kvm_pte_table(ctx.old, level);
> >   	}
> >   	if (!kvm_pgtable_walk_continue(data->walker, ret))
> >   		return ret;
> > -	if (!table) {
> > +	if (!table || kvm_pgtable_skip_level(level + 1, ctx.flags)) {
> >   		data->addr = ALIGN_DOWN(data->addr, kvm_granule_size(level));
> >   		data->addr += kvm_granule_size(level);
> >   		goto out;
> >   	}
> >   	childp = (kvm_pteref_t)kvm_pte_follow(ctx.old, mm_ops);
> >   	ret = __kvm_pgtable_walk(data, mm_ops, childp, level + 1);
> >   	if (!kvm_pgtable_walk_continue(data->walker, ret))
> >   		return ret;
> > -	if (ctx.flags & KVM_PGTABLE_WALK_TABLE_POST)
> > +out:
> > +	if (table && ctx.flags & KVM_PGTABLE_WALK_TABLE_POST)
> >   		ret = kvm_pgtable_visitor_cb(data, &ctx, KVM_PGTABLE_WALK_TABLE_POST);
> > -out:
> >   	if (kvm_pgtable_walk_continue(data->walker, ret))
> >   		return 0;
> >   	return ret;
> >   }
> >   static int __kvm_pgtable_walk(struct kvm_pgtable_walk_data *data,
> >   			      struct kvm_pgtable_mm_ops *mm_ops, kvm_pteref_t pgtable, s8 level)
> >   {
> >   	u32 idx;
> > @@ -242,20 +249,23 @@ static int _kvm_pgtable_walk(struct kvm_pgtable *pgt, struct kvm_pgtable_walk_da
> >   	u32 idx;
> >   	int ret = 0;
> >   	u64 limit = BIT(pgt->ia_bits);
> >   	if (data->addr > limit || data->end > limit)
> >   		return -ERANGE;
> >   	if (!pgt->pgd)
> >   		return -EINVAL;
> > +	if (kvm_pgtable_skip_level(pgt->start_level, data->walker->flags))
> > +		return 0;
> > +
> 
> Should we rather return an error here ? A walk skipping the start level,
> is that any meaningful ?
> 

My rationale on not returning error is that it may be ok for some routine 
to call a walker on a pagetable range just to be sure, even if it actually 
does nothing.

I take that this happens based on the split walker being called on
kvm_arch_mmu_enable_log_dirty_pt_masked() multiple times in the same range, 
even though it's already split, for instance.

But I am fine on changing it to return an error here if it's important in 
some scenario.

Thanks!
Leo 
