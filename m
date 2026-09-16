Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA4A54772A7
	for <kvmarm@lists.linux.dev>; Wed, 16 Sep 2026 11:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789557743; cv=none; b=EndVg0YspqylzD7EmT6D0fNVKZwBE2QJK6JTr8uGQiyIQhTVvQx1ageZFGySnz4EdsgpIGyYc+yoAyoMVbbXut+pCbss2BihBk7xZCXOGEXFGiYav4I9jMV6pA82TnD/AmHSuWbEMSfOpI2RWJVCovPzFBuDPuWI5Y0l4PhC8j4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789557743; c=relaxed/simple;
	bh=SpZeWShggoHQnmxhsOFx/oKPgEiPdIUl3gcqEzwY8o4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=uh0Sb6vNZlDoeSUymX4ZAoYpv8ofczKFxe37cHv1Gvz1BmO+MMDAs5UzFSg9M1wrmOU8nwoNjURUT6cEhWbr4E8FDmQS70tlR9QEejCmSzgHtLNLqvC9UlzSNgVpKy40j7nT+L0YNeunokH8mTiZglNWS5dMck4iSWcqYA539jM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=d+g/E/Wb; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="d+g/E/Wb"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AEE49152B;
	Wed, 16 Sep 2026 04:22:08 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (unknown [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5A1483F86F;
	Wed, 16 Sep 2026 04:22:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789557732; bh=SpZeWShggoHQnmxhsOFx/oKPgEiPdIUl3gcqEzwY8o4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d+g/E/WbonaThoed9wBDUOQiGEQ6jYTYFOks5xSiHifAf58WA7Ip8QvxsgSqtP7nz
	 2TOmoEjkdFD2DLu9VQnj2mAD1f0rZwo1Ehc6T58nKtp3gGrVWQBcpIxxwsE1Zmid7Z
	 soTsBLx9ghIknGFW8TMEdZYHLIO060uy5WRShYWs=
From: Leonardo Bras <leo.bras@arm.com>
To: Oliver Upton <oupton@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Tian Zheng <zhengtian10@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/5] KVM: arm64: pgtables: Change write bit from S2AP_W to DBM
Date: Wed, 16 Sep 2026 12:22:05 +0100
Message-ID: <aqp73SxO78o7LJTs@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <aqnku2TcFzIKhjQl@kernel.org>
References: <20260901171558.2674031-1-leo.bras@arm.com> <20260901171558.2674031-2-leo.bras@arm.com> <86bja17cg7.wl-maz@kernel.org> <aql8jY4o8SzjJuFU@LeoBrasDK> <aqnku2TcFzIKhjQl@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Sep 15, 2026 at 05:37:15PM -0700, Oliver Upton wrote:
> On Tue, Sep 15, 2026 at 06:12:45PM +0100, Leonardo Bras wrote:
> > > Yes, the HW should ignore it. But we have also
> > > seen quite a few broken designs in this area...
> > > 
> > 
> > I lack experience on what bad thing could happen. So I will expand on what 
> > I belive to understand up to here:
> > 
> > - The PTE is in memory, so the DBM bit can be set regardless of being RES0
> > - For SW pagetable walking, I don't think 'bit 51 == 0' is checked
> > - For HW pagetable walking, maybe some faulty implementation may rely on 
> >   bit51 being RES0, and fault otherwise.
> > 
> > If that's the case, then we would have to actually support both encodings, 
> > and only enable the new one if HAFDBS is available in the system. 
> > 
> > I just wonder how high are the chances to have such a broken design, 
> > or other broken designs did not come to my mind, and if we have to start 
> > with that multiple-encoding option.
> 
> FWIW, the host stage-1 already uses the DBM bit unconditionally,
> treating it as a software bit on implementations without HAFDBS.
> Although given the quality of any garden variety Arm MMU I understand
> where Marc is coming from.
> 
> I don't think the HAFDBS enablement is complicated enough to be done in
> a separate series without any meaningful users, nor would I really be
> interested in taking it without, say, HDBSS.
> 
> Can you please work with Tian to get a combined series out for this?
> 

Hi Oliver, thanks for reviewing!

Sure, one of the reasons I sent like this is so Tian could use it as a base 
for his next version.


> > > > diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> > > > index 17123f0b6dab..eb8dfffc32c7 100644
> > > > --- a/arch/arm64/kvm/nested.c
> > > > +++ b/arch/arm64/kvm/nested.c
> > > > @@ -379,21 +379,23 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, phys_addr_t ipa,
> > > >  	}
> > > >  
> > > >  	addr_bottom += contiguous_bit_shift(desc, wi, level);
> > > >  
> > > >  	/* Calculate and return the result */
> > > >  	paddr = (desc & GENMASK_ULL(47, addr_bottom)) |
> > > >  		(ipa & GENMASK_ULL(addr_bottom - 1, 0));
> > > >  	out->output = paddr;
> > > >  	out->block_size = 1UL << ((3 - level) * stride + wi->pgshift);
> > > >  	out->readable = desc & KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R;
> > > > -	out->writable = desc & KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
> > > > +	/* Takes care of both RO/RW and RO/WC/WD encodings */
> > > > +	out->writable = desc & (KVM_PTE_LEAF_ATTR_HI_S2_DBM |
> > > > +				KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W);
> > > 
> > > Absolutely NOT. For a start, NV doesn't support FEAT_HAFDBS. But even
> > > if it did, you are now actively corrupting memory by turning a RO
> > > mapping with a spurious DBM bit set into a writable mapping.
> > > VTCR_EL2.HD exists for a reason.
> > > 
> > > Do you see why your blanket approach of equating DBM with writable is
> > > plain wrong?
> > 
> > Sorry, not really... please help me understand it.
> > 
> > When you say a spurious DBM bit, what does it mean?
> 
> You've implemented the exact sort of bug that was alluded to above. In
> this case it's a software page table walker consuming DBM regardless of
> the value of VTCR_EL2.HD.
> 

So you mean that DBM being treated as "writable" could _only_ happen if we 
have VTCR_EL2.HD=1? I was previously under the impression that it could be 
used regardless of HD value.

> If the guest hypervisor sets VTCR_EL2.HD=0, the expectation is that the
> shadow stage-2 MMU treats the corresponding bit in the PTE as RES0.
> 

Okay, I think I can see it now: since the guest hypervisor could use RO/RW, 
and has no decoupled concept of dirty and writable, it could think all 
writable pages are dirty when we run above function.

So.. would it make sense to have an out->dirty, which we would check based 
on S2AP while out->writable is compared against DBM, and we change the 
logic that uses out->writable to properly match it, maybe based on the 
guest having the feature enabled?

Thanks for your patience on explaining this!
Leo
