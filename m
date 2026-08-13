Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD126345EA2;
	Thu, 13 Aug 2026 15:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786636583; cv=none; b=bsH0k34k1ShkBcYmo0xJLdG0eRLMKie39dtNcOR+8LqcmKDKiOUF5IZfq+1PX2BQ4Htz115iVWVt1KzB0q9D4f+RVzXeEsndmG1DLeV3Zo1jlLRD3i4CEhZ272mmlMvJTR7tMNCv1R73Msld7VHsY1tF1sP6N2N5aOG5tuYCXms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786636583; c=relaxed/simple;
	bh=5Y52WDn+x2YvZ+N4VN8lYflQWRFDJnc5MuXpaZUEGx0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B72v32Nlyapga0gzIkCdegsfiQamEVXH9yUcBhugb2FxgfDohitcjEISno9NAOX11C7GhH/TJf/Cfq0Azqx/C5farTqRiHx9NaARI1/YxHJPgmBDa6DFGbQT5ccPATnfKqcI/g/Anz4w/ymIBJJODkhl26e2jSeo77od+ALpYdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MUu9mCX/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MUu9mCX/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55E5E1F000E9;
	Thu, 13 Aug 2026 15:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786636580;
	bh=zFi/eYdDkOk4QFk4d5TCUoZ5IdueZQPw39MRIni2akY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MUu9mCX/Od1l/M7P2njj5Nk/Mt9Swu9kF/om7GqhK1ROjaH/xP4RaNWqJFYzVWAtt
	 lCu0BuvJZpXOClgRNvRZ3vVPhmeZIA+S+Wt3MlKxnCvmqbGhm+roFdjmtV9eccqgn9
	 z7oLi6FWgvPOTgd/hvUdQdKLu1QiCoO3o3L8amm3a3z6Weo3d9FzPuZVnw2nDNnvTS
	 rqRHF2XvTDAvJsfI780+4IyUbtpctDs+Szx5Dkz+0FVPiSe1GGVXGiB2DCWped5hxG
	 zWs8jrQ5WqnDlZcI7niHFikOsOSb4ibDuE4/FkmauCgNUsiXOhf4MEaCHUfd194nsS
	 LPB4N0hP3D8jQ==
Date: Thu, 13 Aug 2026 16:56:02 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>, 
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 2/2] KVM: arm64: nv: Fix null ptr deref in
 kvm_nested_s2_unmap() on S2 teardown
Message-ID: <an3lHhgmwS0RnCgI@lucifer>
References: <20260812-kvm-arm-nested-virt-fix-v1-0-4ad883f1b6a5@kernel.org>
 <20260812-kvm-arm-nested-virt-fix-v1-2-4ad883f1b6a5@kernel.org>
 <20260812140101.D77AC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260812140101.D77AC1F000E9@smtp.kernel.org>

On Wed, Aug 12, 2026 at 02:01:01PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
>
> Pre-existing issues:
> - [Critical] Use-After-Free on `kvm->arch.nested_mmus` array due to concurrent teardown.

Addressed by Marc's changes + discussed over there.

> - [Critical] Incomplete Fix: `kvm_nested_s2_wp()` is vulnerable to the same NULL pointer dereference and UAF.

OK interesting!

> - [High] Data Race: `kvm->arch.nested_mmus_size` updated locklessly causing uninitialized memory reads.

Addressed by Marc's changes + discussed over there.

> --
>
> --- Patch [2]: [PATCH 2/2] KVM: arm64: nv: Fix null ptr deref in kvm_nested_s2_unmap() on S2 teardown ---
> commit 04c9d62ec51b0000a28c8099341f6a2d31ce7848
> Author: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>
> KVM: arm64: nv: Fix null ptr deref in kvm_nested_s2_unmap() on S2 teardown
>
> This commit adds a NULL check for kvm->arch.mmu.pgt in kvm_nested_s2_unmap()
> to prevent a NULL pointer dereference. This happens when the MMU lock is
> dropped during stage 2 teardown, allowing concurrent progress that clears the
> page table.
>
> > diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> > index 17123f0b6daba..9fc0b1696dcb6 100644
> > --- a/arch/arm64/kvm/nested.c
> > +++ b/arch/arm64/kvm/nested.c
> > @@ -1295,7 +1295,11 @@ void kvm_nested_s2_unmap(struct kvm *kvm, bool may_block)
> >  			kvm_stage2_unmap_range(mmu, 0, kvm_phys_size(mmu), may_block);
>
> [Severity: Critical]
> This isn't a bug introduced by this patch, but does this loop contain a
> Use-After-Free vulnerability?
>
> While iterating over the nested_mmus array in kvm_nested_s2_unmap(),
> kvm_stage2_unmap_range() can drop kvm->mmu_lock inside stage2_apply_range().
>
> Concurrently, if kvm_mmu_notifier_release() calls kvm_arch_flush_shadow_all(),
> it frees the kvm->arch.nested_mmus array unconditionally and without taking
> kvm->mmu_lock:
>
> kvm_arch_flush_shadow_all() {
>     ...
>     kvfree(kvm->arch.nested_mmus);
>     ...
> }
>
> If the array is freed during the lock-drop window, the local mmu pointer
> becomes dangling, and accessing it when the lock is reacquired could result
> in a Use-After-Free.
>
> >  	}
> >
> > -	kvm_invalidate_vncr_ipa(kvm, 0, BIT(kvm->arch.mmu.pgt->ia_bits));
> > +	/* NULL pgt should only be possible if raced when mmu_lock dropped. */
> > +	if (kvm->arch.mmu.pgt)
> > +		kvm_invalidate_vncr_ipa(kvm, 0, BIT(kvm->arch.mmu.pgt->ia_bits));
> > +	else
> > +		WARN_ON(!may_block);
> >  }
>
> [Severity: Critical]
> This is a pre-existing issue, but does kvm_nested_s2_wp() suffer from the exact
> same NULL pointer dereference and Use-After-Free vulnerability?
>
> Like kvm_nested_s2_unmap(), kvm_nested_s2_wp() iterates over the nested_mmus
> array and drops mmu_lock via stage2_apply_range_resched(). When it resumes
> and exits the loop, it also unconditionally executes
> BIT(kvm->arch.mmu.pgt->ia_bits).
>
> Should the same fix be applied to kvm_nested_s2_wp() to prevent a guaranteed
> NULL pointer dereference when kvm_arch_flush_shadow_all() clears the page
> table in the window where the lock is dropped?

Yeah this seems valid actually, will note and can send as a follow-up?

>
> [Severity: High]
> This isn't a bug introduced by this patch, but is there a data race on
> kvm->arch.nested_mmus_size?
>
> In kvm_vcpu_init_nested(), nested_mmus_size is updated outside of
> kvm->mmu_lock and without memory barriers:
>
> kvm_vcpu_init_nested() {
>     ...
>     kvm->arch.nested_mmus_size = num_mmus;
>     ...
> }
>
> A concurrent reader like kvm_nested_s2_unmap() can see the updated size
> before the stores initializing the new array elements become visible. Because
> the new array is allocated with kvcalloc(), an uninitialized/zeroed
> mmu->tlb_vttbr causes kvm_s2_mmu_valid() to incorrectly evaluate to TRUE.
>
> Will this cause the reader to process the zeroed mmu structure, passing it
> to kvm_stage2_unmap_range(), which would dereference a NULL mmu->pgt or
> access a partially initialized pgt?
>
> --
> Sashiko AI review · https://sashiko.dev/#/patchset/20260812-kvm-arm-nested-virt-fix-v1-0-4ad883f1b6a5@kernel.org?part=2

--
Cheers, Lorenzo
