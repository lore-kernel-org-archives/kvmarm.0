Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4F3E34EEE5
	for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 17:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790270551; cv=none; b=VABURy6A1BgVQcra0wWptrdY9E7smpwFQc0gXLkzKtm0uY9AiPLN8t+LFVBBpOebacUxeNnQ8R1zscpLPv3Cx5daKZDXBFL4+PZrmAxa6wpXr0V1zMrOOvj/jOP/xSwR8zJjs6keFG6cy/9HedT7Fvd5yZQJ5ZKvxAit1JZbT7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790270551; c=relaxed/simple;
	bh=860Ojr3v0ayDbG7KiIyixbDOOgrZDzkEsMJgGNgAg4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=BjhXuXDjnAMTJkSxrNxDNxYbsvbCtU+4GR1P6idxop7DGahX7y3Lzc0k613pViqdgdpwNgPD0WaCkH4aKMLPgjvyt2ZmbAmd+vAk+W8ayrRMsWiUSB9MrePmJE5N359UNTDBQKZ68D7JsNUCCG+zoy6j9vtC2KXgWufUEeW9G9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ZG6XqqL0; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ZG6XqqL0"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 596E31E4D;
	Thu, 24 Sep 2026 10:22:24 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B2E353F86F;
	Thu, 24 Sep 2026 10:22:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790270547; bh=860Ojr3v0ayDbG7KiIyixbDOOgrZDzkEsMJgGNgAg4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZG6XqqL0D4QPzo2kTqF5l2dtLuw+Sc6ia+hsJTEX0+UIDRrsOn2bXjacowzicKSG3
	 6Le123RWy9ORcKyW1oIJEELu7BoSZ5ezSGNOGLF+M9/e4bJjqSgVSwOogNVK/qdbe1
	 OCGyYBKsVCOTekVRLmvpiEZsrHN5oSSma4xGXELE=
From: Leonardo Bras <leo.bras@arm.com>
To: Oliver Upton <oupton@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>
Subject: Re: [PATCH 08/22] KVM: arm64: nv: Treat DBM as writable at stage-2
Date: Thu, 24 Sep 2026 18:22:21 +0100
Message-ID: <arVcTZ2frgLH1wRR@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <arQJVgtalOI1A8ip@kernel.org>
References: <20260623184201.1518871-1-oupton@kernel.org> <20260623184201.1518871-9-oupton@kernel.org> <arPka0PldKvd0jzc@LeoBrasDK> <arQJVgtalOI1A8ip@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Sep 23, 2026 at 10:16:06AM -0700, Oliver Upton wrote:
> On Wed, Sep 23, 2026 at 03:38:36PM +0100, Leonardo Bras wrote:
> > On Tue, Jun 23, 2026 at 11:41:47AM -0700, Oliver Upton wrote:
> > > When using direct permissions, the DBM bit has the effect of granting
> > > the write permission. And, depending on the access, it could grant write
> > > permission without a dirty state update.
> > > 
> > > Signed-off-by: Oliver Upton <oupton@kernel.org>
> > > ---
> > >  arch/arm64/include/asm/kvm_pgtable.h |  1 +
> > >  arch/arm64/kvm/nested.c              | 11 +++++++++++
> > >  2 files changed, 12 insertions(+)
> > > 
> > > diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> > > index 22aeb2ed18d1..6ae36973686c 100644
> > > --- a/arch/arm64/include/asm/kvm_pgtable.h
> > > +++ b/arch/arm64/include/asm/kvm_pgtable.h
> > > @@ -94,6 +94,7 @@ typedef u64 kvm_pte_t;
> > >  #define KVM_PTE_LEAF_ATTR_HI_S1_PXN	BIT(53)
> > >  
> > >  #define KVM_PTE_LEAF_ATTR_HI_S2_XN	GENMASK(54, 53)
> > > +#define KVM_PTE_LEAF_ATTR_HI_S2_DBM	BIT(51)
> > >  
> > >  #define KVM_PTE_LEAF_ATTR_HI_S1_GP	BIT(50)
> > >  
> > > diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> > > index e5a407fc0880..4f13f37e560b 100644
> > > --- a/arch/arm64/kvm/nested.c
> > > +++ b/arch/arm64/kvm/nested.c
> > > @@ -305,6 +305,17 @@ static void compute_s2_permissions(struct kvm_vcpu *vcpu, struct s2_walk_info *w
> > >  		break;
> > >  	}
> > >  
> > > +	/*
> > > +	 * Descriptors with the DBM bit set while hardware dirty state are
> > > +	 * considered writable, even though certain accesses (like AT instructions)
> > > +	 * don't actually update the dirty state.
> > > +	 *
> > > +	 * Assume that walk_nestd_s2_pgd() made the necessary descriptor updates
> > > +	 * for the access and just treat DBM as writable here.
> > > +	 */
> > > +	if (wi->hd && ws->desc & KVM_PTE_LEAF_ATTR_HI_S2_DBM)
> > > +		s2ap |= BIT(1);
> > > +
> > >  	trans->readable = s2ap & BIT(0);
> > >  	trans->writable = s2ap & BIT(1);
> > >  
> > > -- 
> > > 2.47.3
> > > 
> > 
> > 
> > Okay, now I see why were you doing that on the previous patch.
> > 
> > Here you test DBM and set writable to 1, and change nothing else, as s2ap 
> > is a local variable that is only used to set writable if DBM is set.
> > 
> > This feels weird, though. That way it looks like DBM is changing s2ap, 
> > which is not.
> > 
> > I suggest doing something like:
> > 
> > +     if (wi->hd && ws->desc & KVM_PTE_LEAF_ATTR_HI_S2_DBM)
> > +             trans->writable = true;
> > +
> >        trans->readable =  s2ap & BIT(0);
> > -      trans->writable = s2ap & BIT(1);
> > +      trans->writable |= s2ap & BIT(1);
> > 
> > Although, this is odd, as S2AP[1] is supposed to be the dirty-bit.
> > Maybe it's fine, as in our case, dirty implies writable.
> > 
> > IHMO, the best approach to this would be to make the movement to 
> > DBM = writable, then have something like:
> > 
> > +	trans->readable =  s2ap & BIT(0);
> > +	trans->dirty    =  s2ap & BIT(1);
> > +	trans->writable =  ws->desc & KVM_PTE_LEAF_ATTR_HI_S2_DBM;
> > 
> > +	/* Dirty implies on writable, was used alone on older systems */
> > +	trans->writable |= trans->dirty;
> > 
> > (And we assume DBM always means writable, and not only when VTCR_EL2.HD=1.
> 
> The Arm ARM is clear as mud in this area but this doesn't pass the smell
> test. Look at R_HBFHL and R_FQNDX, which suggests that S2AP is the
> authoritative field for write permissions through a descriptor.
>
> > What do you think?
> 
> So the current shape of the code is a byproduct of looking at the Arm
> pseudocode. Granted, AArch64.S1DirectBasePermissions() is the one
> changing the effective value of AP based on the dirty state of the
> descriptor.

Oh, right, the pseudocode.
Yeah, it looks very much like your code, even the use of DBM+HD to reset 
AP[2]. But that's S1, right?

Stage2 has a different form [*], yet carries the same idea:
writable = S2AP[1] || (DBM && HD && (!HDBSS || HDBSS_NOT_FULL()));

Most interestingly, in that order.
So DBM is not a writable bit, in fact. :(
It's just a bit that, with HD=1, can change the permission of a page 
to writable.

Right, that fits better with the whole HAFDBS feature as well.

Reading the code again, the only difference with the pseudocode is that you 
evaluate DBM & HD before even checking S2AP[1], but that is not relevant as 
the end result is the same.

FWIW:
Reviewed-by: Leonardo Bras <leo.bras@arm.com>

Thanks for your patience!
Leo


[*] https://support.arm.com/documentation/ddi0487/mc/-Part-J-Architectural-Pseudocode/-Chapter-J1-A-profile-Architecture-Pseudocode/-J1-2-Pseudocode-for-AArch64-operation/-J1-2-676-AArch64-S2DirectBasePermissions?lang=en


