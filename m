Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1047F26E17F
	for <kvmarm@lists.linux.dev>; Fri, 28 Nov 2025 18:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764355694; cv=none; b=nrFoSsveSbnuP4ixu0owkmwW0DCxqYQsSYg/2njLxKv4AD+GSROw4R/wRsrrttgevCZeAsPri4IG5LM8LuDKN0CtFuelF1cDhuZLmTbTFTW7a7qgjEskoGHKJy/SjeekpzpdSeL1H4QEfydEX/v7OjwGgLUXtUnkKUNJwMMrYuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764355694; c=relaxed/simple;
	bh=FSDNcDjcSHNEpBt47zKm4TaQeFx3bDhR+BL9MuiqZ+s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qGqSTlSVCugTL6C7bIzJOk8i2molbtLbNVEV8gVtION3fCaP9ymoo2fKcdbVOVD7K40ra8vaMV6Utnllso7baJJKkVJ3u+C5KcZitvrBSo91Mu/7A13rLNvTxn8tJGNwJ5L1/3nVuzEesLrIXHyVk13ZgxdLjiTq8LsysooHqyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=COincvZm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="COincvZm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A6BEC4CEF1;
	Fri, 28 Nov 2025 18:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764355692;
	bh=FSDNcDjcSHNEpBt47zKm4TaQeFx3bDhR+BL9MuiqZ+s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=COincvZmdF6AYs666DRcJHlpv2QVyg8rvNVSTKD724SSpnQ6rH2bApNmStmgePXqv
	 ukqfRFpKUdTqqPQmwY6lg8vBNwAgx6g3KJjL8F7zrIn18/kQ4Vk3WKM1THsGmzt1tU
	 qdIA5TL601IayzwlIzvBa6RKpZ0kcISaJrRVPEGNZVPDrlhsknOwtEvlfdwrC6UjBa
	 +1R6vC/g2fUp0NC9FBf6mMzUFnRvjzMUkMM/9E2aN2ql8rxh0/VWb//fK8hdtJP6nP
	 tRb1nRlcCQE+NJ2o5apZEcyOa3rAzAYyzK/WeLIx/O/6nvsxYJ55eIHUYl24hClKWr
	 F0pazRWMAPswQ==
Date: Fri, 28 Nov 2025 10:48:10 -0800
From: Oliver Upton <oupton@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, oliver.upton@linux.dev,
	joey.gouly@arm.com, yuzenghui@huawei.com, suzuki.poulose@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH 3/4] KVM: arm64: nv: Don't mask VTCR_EL2.HA if
 FEAT_HAFDBS is present
Message-ID: <aSnuauBCe1Ru2q0T@kernel.org>
References: <20251128100946.74210-1-alexandru.elisei@arm.com>
 <20251128100946.74210-4-alexandru.elisei@arm.com>
 <86v7iup3bv.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86v7iup3bv.wl-maz@kernel.org>

On Fri, Nov 28, 2025 at 03:46:44PM +0000, Marc Zyngier wrote:
> On Fri, 28 Nov 2025 10:09:45 +0000,
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> > 
> > Commit 39db933ba67f ("KVM: arm64: nv: Implement HW access flag management
> > in stage-2 SW PTW") added support for hardware updates to the access flag
> > to stage 2 if the feature is available to the virtual machine, but forgot
> > to remove the VTCR_EL2.HA bit from the res0 mask for the register. Remove
> > it from the mask to allow the VM to use the feature.
> > 
> > Fixes: 39db933ba67f ("KVM: arm64: nv: Implement HW access flag management in stage-2 SW PTW")
> > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > ---
> >  arch/arm64/kvm/nested.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> > index 911fc99ed99d..7a34163f6c68 100644
> > --- a/arch/arm64/kvm/nested.c
> > +++ b/arch/arm64/kvm/nested.c
> > @@ -1719,7 +1719,9 @@ int kvm_init_nv_sysregs(struct kvm_vcpu *vcpu)
> >  	set_sysreg_masks(kvm, VTTBR_EL2, res0, res1);
> >  
> >  	/* VTCR_EL2 */
> > -	res0 = GENMASK(63, 32) | GENMASK(30, 20);
> > +	res0 = GENMASK(63, 32) | GENMASK(30, 22) | BIT(20);
> > +	if (!kvm_has_feat(kvm, ID_AA64MMFR1_EL1, HAFDBS, AF))
> > +		res0 |= VTCR_EL2_HA;
> >  	res1 = BIT(31);
> >  	set_sysreg_masks(kvm, VTCR_EL2, res0, res1);
> >  
> 
> The fix is correct, but I really do not want to add more of these
> tedious checks, one after the other. We should fix this once and for
> all by converting VTCR_EL2 to the feature dependency infrastructure
> and be done with it.
> 
> I've pushed a small series at [1] that does that (very lightly
> tested).

This looks alright to me, do you want to post it?

Thanks,
Oliver
