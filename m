Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F7043176EE
	for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 17:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790183777; cv=none; b=kB4bQdaKvmAQIurIvb8J8ntkAYYbofy/v2Q7M518GG+VOA4bIal/5aN6LHMkzC1gW3PQFaKhg6x/1m2tKGwB9qu3j5/zc0jFY2jXWWRts0R5TX27LliS2PkbBo1V/aiaqI5I0K/aP67qiDkQVsmlzy3d5Xqxrn8f394CoiRxaFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790183777; c=relaxed/simple;
	bh=2AXkjNjNIZXWAfIxs3HH40UltS39mh6uaskEHZRCcWw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zb4HRZZYQx/5O9zJBe3hP+zrtzKWReXKt4MbRPQr7E+tk3ldtYB+uTGhvWFZc8lGs4UOXsNwkkhLxSa85ZPJHvht5ybL7TcSo+TKdGCwFQKjAR2bd7288zD6fZz/o2EtXdD6EjFGUrRPBXmATJSkZR4j8G2iKRxX5hMDpGN4270=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=en5h0MVi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="en5h0MVi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 046B81F000FF;
	Wed, 23 Sep 2026 17:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790183768;
	bh=M1k3JQ2GwQTzzCIDmgIl0zaw/pOscBb3chSbJddi+fE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=en5h0MVik+l5uXU+7yz9yRjY1S6U0L6mzabDBLJ8Hze1gCQRMx/UprcIBzYYrg4Si
	 X6LqxXnGvJa4KK/sXlHOVZ5vK0nYtRBnaL9MfNHXf3xfVz7HY39Rs2qmNstgwlE5Ad
	 1Tpg3b38QMz4sRuE5D3O7eX7at652KlqC6J1y1QB0IWLyFEDcZ9oXEAxKjMtSHNl45
	 1Gsk3EjK/tpON2orqXjURMUse1Bc1LMaLt4Z+aN0VPJLWAazYqRHaimhY72A81Lu73
	 jGhNrj6Ss5NWOMd3q7ACqOIMCphGZuMjxM3JZF4lFlhTj1c0yu0t8wMI9T1nJRFmSc
	 NuxHDlZrDob6w==
Date: Wed, 23 Sep 2026 10:16:06 -0700
From: Oliver Upton <oupton@kernel.org>
To: Leonardo Bras <leo.bras@arm.com>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>
Subject: Re: [PATCH 08/22] KVM: arm64: nv: Treat DBM as writable at stage-2
Message-ID: <arQJVgtalOI1A8ip@kernel.org>
References: <20260623184201.1518871-1-oupton@kernel.org>
 <20260623184201.1518871-9-oupton@kernel.org>
 <arPka0PldKvd0jzc@LeoBrasDK>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arPka0PldKvd0jzc@LeoBrasDK>

On Wed, Sep 23, 2026 at 03:38:36PM +0100, Leonardo Bras wrote:
> On Tue, Jun 23, 2026 at 11:41:47AM -0700, Oliver Upton wrote:
> > When using direct permissions, the DBM bit has the effect of granting
> > the write permission. And, depending on the access, it could grant write
> > permission without a dirty state update.
> > 
> > Signed-off-by: Oliver Upton <oupton@kernel.org>
> > ---
> >  arch/arm64/include/asm/kvm_pgtable.h |  1 +
> >  arch/arm64/kvm/nested.c              | 11 +++++++++++
> >  2 files changed, 12 insertions(+)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> > index 22aeb2ed18d1..6ae36973686c 100644
> > --- a/arch/arm64/include/asm/kvm_pgtable.h
> > +++ b/arch/arm64/include/asm/kvm_pgtable.h
> > @@ -94,6 +94,7 @@ typedef u64 kvm_pte_t;
> >  #define KVM_PTE_LEAF_ATTR_HI_S1_PXN	BIT(53)
> >  
> >  #define KVM_PTE_LEAF_ATTR_HI_S2_XN	GENMASK(54, 53)
> > +#define KVM_PTE_LEAF_ATTR_HI_S2_DBM	BIT(51)
> >  
> >  #define KVM_PTE_LEAF_ATTR_HI_S1_GP	BIT(50)
> >  
> > diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> > index e5a407fc0880..4f13f37e560b 100644
> > --- a/arch/arm64/kvm/nested.c
> > +++ b/arch/arm64/kvm/nested.c
> > @@ -305,6 +305,17 @@ static void compute_s2_permissions(struct kvm_vcpu *vcpu, struct s2_walk_info *w
> >  		break;
> >  	}
> >  
> > +	/*
> > +	 * Descriptors with the DBM bit set while hardware dirty state are
> > +	 * considered writable, even though certain accesses (like AT instructions)
> > +	 * don't actually update the dirty state.
> > +	 *
> > +	 * Assume that walk_nestd_s2_pgd() made the necessary descriptor updates
> > +	 * for the access and just treat DBM as writable here.
> > +	 */
> > +	if (wi->hd && ws->desc & KVM_PTE_LEAF_ATTR_HI_S2_DBM)
> > +		s2ap |= BIT(1);
> > +
> >  	trans->readable = s2ap & BIT(0);
> >  	trans->writable = s2ap & BIT(1);
> >  
> > -- 
> > 2.47.3
> > 
> 
> 
> Okay, now I see why were you doing that on the previous patch.
> 
> Here you test DBM and set writable to 1, and change nothing else, as s2ap 
> is a local variable that is only used to set writable if DBM is set.
> 
> This feels weird, though. That way it looks like DBM is changing s2ap, 
> which is not.
> 
> I suggest doing something like:
> 
> +     if (wi->hd && ws->desc & KVM_PTE_LEAF_ATTR_HI_S2_DBM)
> +             trans->writable = true;
> +
>        trans->readable =  s2ap & BIT(0);
> -      trans->writable = s2ap & BIT(1);
> +      trans->writable |= s2ap & BIT(1);
> 
> Although, this is odd, as S2AP[1] is supposed to be the dirty-bit.
> Maybe it's fine, as in our case, dirty implies writable.
> 
> IHMO, the best approach to this would be to make the movement to 
> DBM = writable, then have something like:
> 
> +	trans->readable =  s2ap & BIT(0);
> +	trans->dirty    =  s2ap & BIT(1);
> +	trans->writable =  ws->desc & KVM_PTE_LEAF_ATTR_HI_S2_DBM;
> 
> +	/* Dirty implies on writable, was used alone on older systems */
> +	trans->writable |= trans->dirty;
> 
> (And we assume DBM always means writable, and not only when VTCR_EL2.HD=1.

The Arm ARM is clear as mud in this area but this doesn't pass the smell
test. Look at R_HBFHL and R_FQNDX, which suggests that S2AP is the
authoritative field for write permissions through a descriptor.

> What do you think?

So the current shape of the code is a byproduct of looking at the Arm
pseudocode. Granted, AArch64.S1DirectBasePermissions() is the one
changing the effective value of AP based on the dirty state of the
descriptor.

Thanks,
Oliver
