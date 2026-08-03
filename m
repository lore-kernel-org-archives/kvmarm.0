Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B97233C183;
	Mon,  3 Aug 2026 15:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785772468; cv=none; b=MnZw5/Dda+8oqPgd4IDC/b3w9nU1hnFDXiQdVciuVFMfwLV63+LLpLq+QCvQIlMeopTi+WN6yGzzN55D+7x7m5d999f2gEAVqLEN96uvydpo/7alUsBfG6cEcQIaiurxgFxpnPelQYrHuM7fDv9/7HQOLpD20niECIXWiU+nBbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785772468; c=relaxed/simple;
	bh=idhI6R+az60G49N2dgCqGSOPNkmYPnU+IPaX15d/DJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=BM8taf9TnpcBeeCoiD8CZTSp3lrKjOUMb91XHTRcnkw3vzGiG7wcfPKmzrNtBa8Mlk4vjgMWWRGVNKfjGyTorJgHsviazb8XUVdiKGj6OtggmIn6uK2pZdA8V+xcYwr48VHoF2eYgPtmglKXzLpZGRN0s7/YszhZzkYhlob0vvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=TBemmKAK; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="TBemmKAK"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E74151595;
	Mon,  3 Aug 2026 08:54:21 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CAA613F66F;
	Mon,  3 Aug 2026 08:54:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785772466; bh=idhI6R+az60G49N2dgCqGSOPNkmYPnU+IPaX15d/DJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TBemmKAKfzgMI/1rbxHXHowPf6S6mXXDHJHQKilIw6Q8LC9oZngCg8kQn4rQu7/dK
	 xfZjSBUT1bQZcaV/55tlEveE9EQRIA21GPcAaOo40vb+MADBurmEqP4VBpFM3DGjQg
	 yBxbt24xs1gwJGRkqM9z/sBlt3Ao1vYjySUeQi40=
From: Leonardo Bras <leo.bras@arm.com>
To: sashiko-reviews@lists.linux.dev
Cc: Leonardo Bras <leo.bras@arm.com>,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Subject: Re: [PATCH v3 07/11] KVM: arm64: Dirty-bitmap: avoid splitting previously split blocks
Date: Mon,  3 Aug 2026 16:54:22 +0100
Message-ID: <anC5rniXDZNFGfvy@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260729110854.ACFC31F000E9@smtp.kernel.org>
References: <20260729104548.3439958-1-leo.bras@arm.com> <20260729104548.3439958-8-leo.bras@arm.com> <20260729110854.ACFC31F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Jul 29, 2026 at 11:08:54AM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] Dropping `mmu_lock` during eager page splitting creates a race window that can permanently lose hardware-managed dirty bits (FEAT_HAFDBS), leading to silent guest data corruption during live migration.
> --
> 
> --- Patch [7]: [PATCH v3 07/11] KVM: arm64: Dirty-bitmap: avoid splitting previously split blocks ---
> commit fb963a566e307a780c669718446f8bf7c2c6ef94
> Author: Leonardo Bras <leo.bras@arm.com>
> 
> KVM: arm64: Dirty-bitmap: avoid splitting previously split blocks
> 
> If previous dirty-clean already split a block, then avoid calling the
> split helper on that block again.
> 
> > diff --git a/arch/arm64/kvm/dirty_bit.c b/arch/arm64/kvm/dirty_bit.c
> > index 5a6266205295e..d7e624f9b6308 100644
> > --- a/arch/arm64/kvm/dirty_bit.c
> > +++ b/arch/arm64/kvm/dirty_bit.c
> > @@ -295,10 +296,15 @@ int __kvm_arch_dirty_log_clear(struct kvm *kvm,
> >  
> >  		offset = base_gfn + i * BITS_PER_LONG;
> >  
> > -		if (kvm_dirty_log_manual_protect_and_init_set(kvm))
> > -			kvm_mmu_split_huge_pages(kvm,
> > -						 gfn_to_gpa(offset + __ffs(mask)),
> > -						 gfn_to_gpa(offset + __fls(mask) + 1));
> > +		if (kvm_dirty_log_manual_protect_and_init_set(kvm)) {
> > +			gpa_t split_start = gfn_to_gpa(offset + __ffs(mask));
> > +			gpa_t split_end =  gfn_to_gpa(offset + __fls(mask) + 1);
> > +
> > +			if (split_end > last_split) {
> > +				kvm_mmu_split_huge_pages(kvm, split_start, split_end);
> 
> [Severity: High]
> Can this sequence lose dirty state due to a race with hardware dirty bit
> management?
> 
> In __kvm_arch_dirty_log_clear(), the software dirty_bitmap for the target pages
> is fetched and cleared before reaching this point.
> 
> When kvm_mmu_split_huge_pages() is called, it can temporarily drop
> kvm->mmu_lock to allocate memory.
> 
> During this unlocked window, a vCPU could locklessly write to the page. With
> FEAT_HAFDBS enabled, the hardware automatically sets the PTE dirty bit without
> trapping to KVM.
> 
> After the lock is reacquired, the loop proceeds to dirty_bit_clear(), which
> unconditionally clears the hardware PTE dirty bit (via FEAT_HACDBS).
> 
> Because the software bitmap was already cleared and the hardware state is wiped
> without feeding the dirty state back, could a write during the unlocked window
> be permanently lost if userspace reads the page data before the clear operation?
> The next KVM_GET_DIRTY_LOG would not see it.

The bit, if was clear before the current KVM_GET_DIRTY_LOG(), will be set 
in the dirty-bitmap. HACDBS will not clean it, but sw fallback could.
In any case, it will be requested to be clean (again) in the next 
iteration.

This is the same as software dirty-bit cleaning. 

Leo
