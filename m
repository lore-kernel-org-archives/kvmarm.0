Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDB644F6470
	for <kvmarm@lists.linux.dev>; Wed, 16 Sep 2026 13:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789565151; cv=none; b=kA4OAxrBz3yLMvV87twca4bBM0fPD2O4o8WWT/R0y8Mdfl3aucrBg9HT4tnhWCfEWbzq7Y8FccFx7cSFStLKT9n/Wb1ZzKI2MwDEdBeM14BdvFmz2Um4oiDSayZL8BfhDHEB/IyzUJ9M45NuYKiBidOfvbV+lHL2K0iMkvWtjVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789565151; c=relaxed/simple;
	bh=cGVvjXNh01uco9P4TObFJJ6STEQrLkR65na6DpvO3wk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=gk9T7apBIJ3+s070hp18fvYamosFVP71bNjx6O8XYxDVdCSlKHfam/GQMV8NxXyy5+4j3BB10TBLF24xKk7a8jrIzKdLbxIB8Oc6/IG8kuZfqTlgF3c8IgI4cnmK1fnDpLZe/ssplHT9rUn9AzyLnHzoY2JTOi6FjMT5dTLH2Lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=UZIzzNnC; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="UZIzzNnC"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 40E7F152B;
	Wed, 16 Sep 2026 06:25:42 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (unknown [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E08DC3F86F;
	Wed, 16 Sep 2026 06:25:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789565145; bh=cGVvjXNh01uco9P4TObFJJ6STEQrLkR65na6DpvO3wk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UZIzzNnCJnq+5NTtRsFxr5h9tDPp71kwrxcKq3gOU+0tjJ2PvHKza6XEztBr8WPrh
	 lbZtOrCiQIc3Dl9gLEc13Ar7JnRR25NFS3ZGN19SnBT6vtRHMFVKhIhBN75TujQDzb
	 0lHzOMTPzNT6ZTh09jdh+tyM+Mhf5ZaK375LuWfU=
From: Leonardo Bras <leo.bras@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	Oliver Upton <oupton@kernel.org>,
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
Date: Wed, 16 Sep 2026 14:25:41 +0100
Message-ID: <aqqY1QiB0ZBAQkwc@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <86fqz95qwe.wl-maz@kernel.org>
References: <20260901171558.2674031-1-leo.bras@arm.com> <20260901171558.2674031-2-leo.bras@arm.com> <86bja17cg7.wl-maz@kernel.org> <aql8jY4o8SzjJuFU@LeoBrasDK> <aqnku2TcFzIKhjQl@kernel.org> <aqp73SxO78o7LJTs@LeoBrasDK> <86fqz95qwe.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Sep 16, 2026 at 01:20:33PM +0100, Marc Zyngier wrote:
> On Wed, 16 Sep 2026 12:22:05 +0100,
> Leonardo Bras <leo.bras@arm.com> wrote:
> > 
> > On Tue, Sep 15, 2026 at 05:37:15PM -0700, Oliver Upton wrote:
> > > On Tue, Sep 15, 2026 at 06:12:45PM +0100, Leonardo Bras wrote:
> > > > > Yes, the HW should ignore it. But we have also
> > > > > seen quite a few broken designs in this area...
> > > > > 
> > > > 
> > > > I lack experience on what bad thing could happen. So I will expand on what 
> > > > I belive to understand up to here:
> > > > 
> > > > - The PTE is in memory, so the DBM bit can be set regardless of being RES0
> > > > - For SW pagetable walking, I don't think 'bit 51 == 0' is checked
> > > > - For HW pagetable walking, maybe some faulty implementation may rely on 
> > > >   bit51 being RES0, and fault otherwise.
> > > > 
> > > > If that's the case, then we would have to actually support both encodings, 
> > > > and only enable the new one if HAFDBS is available in the system. 
> > > > 
> > > > I just wonder how high are the chances to have such a broken design, 
> > > > or other broken designs did not come to my mind, and if we have to start 
> > > > with that multiple-encoding option.
> > > 
> > > FWIW, the host stage-1 already uses the DBM bit unconditionally,
> > > treating it as a software bit on implementations without HAFDBS.
> > > Although given the quality of any garden variety Arm MMU I understand
> > > where Marc is coming from.
> > > 
> > > I don't think the HAFDBS enablement is complicated enough to be done in
> > > a separate series without any meaningful users, nor would I really be
> > > interested in taking it without, say, HDBSS.
> > > 
> > > Can you please work with Tian to get a combined series out for this?
> > > 
> > 
> > Hi Oliver, thanks for reviewing!
> > 
> > Sure, one of the reasons I sent like this is so Tian could use it as a base 
> > for his next version.
> > 
> > 
> > > > > > diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> > > > > > index 17123f0b6dab..eb8dfffc32c7 100644
> > > > > > --- a/arch/arm64/kvm/nested.c
> > > > > > +++ b/arch/arm64/kvm/nested.c
> > > > > > @@ -379,21 +379,23 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, phys_addr_t ipa,
> > > > > >  	}
> > > > > >  
> > > > > >  	addr_bottom += contiguous_bit_shift(desc, wi, level);
> > > > > >  
> > > > > >  	/* Calculate and return the result */
> > > > > >  	paddr = (desc & GENMASK_ULL(47, addr_bottom)) |
> > > > > >  		(ipa & GENMASK_ULL(addr_bottom - 1, 0));
> > > > > >  	out->output = paddr;
> > > > > >  	out->block_size = 1UL << ((3 - level) * stride + wi->pgshift);
> > > > > >  	out->readable = desc & KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R;
> > > > > > -	out->writable = desc & KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
> > > > > > +	/* Takes care of both RO/RW and RO/WC/WD encodings */
> > > > > > +	out->writable = desc & (KVM_PTE_LEAF_ATTR_HI_S2_DBM |
> > > > > > +				KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W);
> > > > > 
> > > > > Absolutely NOT. For a start, NV doesn't support FEAT_HAFDBS. But even
> > > > > if it did, you are now actively corrupting memory by turning a RO
> > > > > mapping with a spurious DBM bit set into a writable mapping.
> > > > > VTCR_EL2.HD exists for a reason.
> > > > > 
> > > > > Do you see why your blanket approach of equating DBM with writable is
> > > > > plain wrong?
> > > > 
> > > > Sorry, not really... please help me understand it.
> > > > 
> > > > When you say a spurious DBM bit, what does it mean?
> > > 
> > > You've implemented the exact sort of bug that was alluded to above. In
> > > this case it's a software page table walker consuming DBM regardless of
> > > the value of VTCR_EL2.HD.
> > > 
> > 
> > So you mean that DBM being treated as "writable" could _only_ happen if we 
> > have VTCR_EL2.HD=1? I was previously under the impression that it could be 
> > used regardless of HD value.
> 
> Then you have failed to understand the architecture. When
> VTCR_EL2.HD==0, DBM can be treated as RES0, RES0, or RES0.
> 
> R_XZFQH and R_BRFGY are pretty clear that DBM can only be evaluated
> when dirty hw update is enabled, and I_MHJZP tells you what it means
> for S2 to have this enabled.

Right, I_MHJZP says that if VTCR_EL2.HD is 1, then dirty state hardware 
management is enabled.

Then, R_XZFQH and R_BRFGY say that if (DBM+S2AP) bit combination is the 
given and the dirty state hardware management is enabled then a block 
descriptor is WC/WD.

R_XZFQH header, as an example:
For each translation stage using Direct permissions, if all of the 
following apply, then a Block descriptor or Page descriptor is described 
as writable-clean[...]

It says: 
"if all apply, the block is WC", 
it does not say 
"only if all apply, the block is WC".
so it forces one way, but not the other.

So I previously understood that we could also use the encoding for WC/WD in 
software, to avoid having 2 distinct encodings, when VTCR_EL2.HD=0. 

If that's not possible, as you mentioned, then yes, I failed to get that 
part. I also see that you mention it being RES0 when VTCR_EL2.HD==0, but I 
honestly could not find reference to that. :(

What I could find on Arm ARM M.cc was Table D8-53, which states for 
bit 51 that it's DBM if indirect permissions are disabled, or PIINDEX[1] 
if they are enabled. There is also no such information in D8.5.2 about this 
res0 behavior. 

So I am possibly missing the proper place to look for that information. 
Could you please share that with me so I can improve and maybe avoid being 
a inconvenience in the future?

Thanks!
Leo
