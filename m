Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B862926461F;
	Wed, 16 Sep 2026 00:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789519039; cv=none; b=GtatC9zg3xcWwLOrjCqX/1I+LM4uuE3ssKy2XZ02zK7v09VYrRTywsTaf+J6tpwCV/1PwZO+779avJ5FeJFWQPPWC3af+sno/tXJtbohV7wfMT2TX0PMmtIZbyBS2I/vThWHQTxL6PXZTNTTrRTce/LiWRtI7uAdbl8buGXFLBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789519039; c=relaxed/simple;
	bh=ue53jCiy2LEZYlyTYduuCH59J6dHDmi8VzF1KRLqTC4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MTpnBHZe0Yhr9gCBLS0TnncoM2aWePY5TFySvA12UKvwJGiT6oJ7C4Tu6PFQCDhHRi6fyf4tibtbxiz4OTk8Sf/YmdUmXQxUeDLYmcFtSUKPFrS9dwu07AXrcbdFzpgKLsInb7QCAtDJXr7YCEZjJt2juoNkX6rsXBcQ0WHSIuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iOo+6B/Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iOo+6B/Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 139BE1F000FF;
	Wed, 16 Sep 2026 00:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789519037;
	bh=KhXpFZ9VswPhvLkxuik9i+Nt4jMBXcRn/oG41k/T1uI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iOo+6B/Yvvx05OkVOSWtJrtXZBBctiElUpb+YdCas1bze8OsVyQZ6cXF3ODvv6xyU
	 19Dmokvl6NZMSZO/0u9No8KATqKry+dWiIrGu8ClSBu7Jv8v9YZJydNnRzK1epCf+2
	 uyDZBY9TEr3sbezw7f8OIaiF437g7W3s0bhLbrlCTNNng5pdkKdsPvF1IoXS5+ESSF
	 R3zAWlDbzgZgdUtWwe7XtrSvgYjplCmgJRJiQbqMsCBYAgq+g1I6pinLUg5N8OLO2X
	 9yE8I4xTnhcvnkpYUOhUHemT1p7MjLWorbUBBkc7YcafptTkdhqkUt4DduVfe+LL4K
	 xY0MFIWY2cwkQ==
Date: Tue, 15 Sep 2026 17:37:15 -0700
From: Oliver Upton <oupton@kernel.org>
To: Leonardo Bras <leo.bras@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Tian Zheng <zhengtian10@huawei.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/5] KVM: arm64: pgtables: Change write bit from
 S2AP_W to DBM
Message-ID: <aqnku2TcFzIKhjQl@kernel.org>
References: <20260901171558.2674031-1-leo.bras@arm.com>
 <20260901171558.2674031-2-leo.bras@arm.com>
 <86bja17cg7.wl-maz@kernel.org>
 <aql8jY4o8SzjJuFU@LeoBrasDK>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aql8jY4o8SzjJuFU@LeoBrasDK>

On Tue, Sep 15, 2026 at 06:12:45PM +0100, Leonardo Bras wrote:
> > Yes, the HW should ignore it. But we have also
> > seen quite a few broken designs in this area...
> > 
> 
> I lack experience on what bad thing could happen. So I will expand on what 
> I belive to understand up to here:
> 
> - The PTE is in memory, so the DBM bit can be set regardless of being RES0
> - For SW pagetable walking, I don't think 'bit 51 == 0' is checked
> - For HW pagetable walking, maybe some faulty implementation may rely on 
>   bit51 being RES0, and fault otherwise.
> 
> If that's the case, then we would have to actually support both encodings, 
> and only enable the new one if HAFDBS is available in the system. 
> 
> I just wonder how high are the chances to have such a broken design, 
> or other broken designs did not come to my mind, and if we have to start 
> with that multiple-encoding option.

FWIW, the host stage-1 already uses the DBM bit unconditionally,
treating it as a software bit on implementations without HAFDBS.
Although given the quality of any garden variety Arm MMU I understand
where Marc is coming from.

I don't think the HAFDBS enablement is complicated enough to be done in
a separate series without any meaningful users, nor would I really be
interested in taking it without, say, HDBSS.

Can you please work with Tian to get a combined series out for this?

> > > diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> > > index 17123f0b6dab..eb8dfffc32c7 100644
> > > --- a/arch/arm64/kvm/nested.c
> > > +++ b/arch/arm64/kvm/nested.c
> > > @@ -379,21 +379,23 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, phys_addr_t ipa,
> > >  	}
> > >  
> > >  	addr_bottom += contiguous_bit_shift(desc, wi, level);
> > >  
> > >  	/* Calculate and return the result */
> > >  	paddr = (desc & GENMASK_ULL(47, addr_bottom)) |
> > >  		(ipa & GENMASK_ULL(addr_bottom - 1, 0));
> > >  	out->output = paddr;
> > >  	out->block_size = 1UL << ((3 - level) * stride + wi->pgshift);
> > >  	out->readable = desc & KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R;
> > > -	out->writable = desc & KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
> > > +	/* Takes care of both RO/RW and RO/WC/WD encodings */
> > > +	out->writable = desc & (KVM_PTE_LEAF_ATTR_HI_S2_DBM |
> > > +				KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W);
> > 
> > Absolutely NOT. For a start, NV doesn't support FEAT_HAFDBS. But even
> > if it did, you are now actively corrupting memory by turning a RO
> > mapping with a spurious DBM bit set into a writable mapping.
> > VTCR_EL2.HD exists for a reason.
> > 
> > Do you see why your blanket approach of equating DBM with writable is
> > plain wrong?
> 
> Sorry, not really... please help me understand it.
> 
> When you say a spurious DBM bit, what does it mean?

You've implemented the exact sort of bug that was alluded to above. In
this case it's a software page table walker consuming DBM regardless of
the value of VTCR_EL2.HD.

If the guest hypervisor sets VTCR_EL2.HD=0, the expectation is that the
shadow stage-2 MMU treats the corresponding bit in the PTE as RES0.

Thanks,
Oliver
