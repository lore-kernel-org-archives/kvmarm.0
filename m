Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795556180;
	b=fhgfi4NVqLh0Marw0QHoUUv/mmnGUK/KZNgcsiVFXMRHecXUqscjYFfKH0VlBVnZSBS0
	 Tt92YWbYMXltCALm08not2uMnHJmGCmx+W15HB0Fd/9hDaz7W53U179wFxoPIhaI8mgJR
	 2sNBZja0SXJ9rDcxWyXpre13qHaKHuaWi/Vi6PlaA7lBAUsdf13RUu59mCnuuMGYZl6H3
	 7zB0V8R4fBqGkw5/sPgGcLdCJIsTD7qq44YYK4s69c4Vi6/CuDfQVnUo9sjbRYX2VcEFJ
	 F+wUM06r9cfhhr5ynzMCSTKya3vpMTL1zN06Qkt2AivketC6Nkoi7RN7WRSUq/TUYjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795556180;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=rYAc1hx2z2NWRsJDEhnbb4VFlg8aKyZS9533vnaOVTs=;
	b=ImGaWpBXJAFx4AE909oi5gPIjxZUAAlWZKubBqcroSsSgfeNgScy0Q1EtACg1rNeDDk2
	 1Gzv5IEMVhdK3JUJacSfPy4a1HNwri5zi73UXOdV5XG54lTQIHT7W3qkN9yMDUV4oUAVd
	 yYk1q+Coanv/3ZGtxJgRXmeUEOzBVdzeJH3OiXf03Bh2SbgLkmQ7o5tPs8O6hJCOEUGqa
	 dYaY2c4om95AshGr0xN3mLRQbQPoWxV2NWUqjQM7t4TJSKdWBQx1b7vRTzxOfmFFD9CBn
	 rG3I28Olji/J1LCfIHBK5F2FGloShsGXAuOWppeWYTuN8PqtQ5wFxo6ZsJdeSVIYZzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=clNux5Qk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 918F0606A687
	for <kvmarm@lists.linux.dev>; Tue, 24 Nov 2026 21:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=clNux5Qk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDEE81F000D3;
	Tue, 24 Nov 2026 21:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795556179;
	bh=rYAc1hx2z2NWRsJDEhnbb4VFlg8aKyZS9533vnaOVTs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=clNux5QkUnvID2DLLiPNxWpB9kJ3KmGMwd7FVacD+TVhW/t956bHIDQrai/XgLUac
	 ZQDY0T4pUIUZCbw5Cpn7Zw1t8y5Ogz/TN5/9deNigZBSNjvafBMw9BYluthWif7XoX
	 ofR77ZjipUAkSZWuleToASW/q1ReTVacEMRqCvRzwoZSr9Ov5AG2Busd1mj1nz2FzW
	 05jW03RdaIRo5jYeMBhOyGECO/KoWSOF63nBzx7kpNw3KgAhstQD6IqNapeKzS52Xd
	 sZ3ag7vj1/0pIBEIxtcUA5Drmbw46HPL/jxQ873czAJibimu4I2d+1d10lf5C2/JGF
	 fO/J6l7rcwFcw==
Message-ID: <sashiko-outbox-232052@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 5/6] KVM: arm64: nv: Park grown MMUs on ALLE1 and
 reactivate them on demand
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nathan Chen" <nathanc@nvidia.com>, kvmarm@lists.linux.dev
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261124211218.2751086-6-nathanc@nvidia.com>
References: <20261124211218.2751086-1-nathanc@nvidia.com>
 <20261124211218.2751086-6-nathanc@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 24 Nov 2026 21:36:19 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 4 potential
issues to consider:
- [High] KVM: arm64: nv: kvm_vcpu_init_nested() counts grown and parked
  MMUs as base
- [Medium] KVM: arm64: nv: nested_mmus_no_grow blocks reactivating
  parked MMUs
- [Medium] KVM: arm64: nv: kvm_nested_add_s2_mmus() clobbers reactivated
  clock hand
- [Medium] KVM: arm64: nv: stale guest_s2_mappings left behind by
  kvm_nested_s2_park()
--

commit 9c4a135b779b29bdcbc1e942f3c2d4d37849957b
Author: Nathan Chen <nathanc@nvidia.com>

KVM: arm64: nv: Park grown MMUs on ALLE1 and reactivate them on demand

This commit parks unreferenced and empty grown shadow stage-2 MMUs on a
guest TLBI ALLE1 to return them to the host budget, and reactivates
parked MMUs before allocating new ones when growing the pool.

> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index d530a37716be6..9251f3fd48405 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -96,6 +96,55 @@ struct nested_s2_mmu_block {
>  	struct kvm_s2_mmu	mmus[];
>  };
> =20
> +static int s2_mmu_nonempty_walker(const struct kvm_pgtable_visit_ctx *ct=
x,
> +				  enum kvm_pgtable_walk_flags visit)
> +{
> +	return ctx->old ? -EEXIST : 0;
> +}
> +
> +/* Only looks at the stage-2 root unless it finds an entry in use */
> +static bool kvm_s2_mmu_empty(struct kvm_s2_mmu *mmu)
> +{
> +	struct kvm_pgtable_walker walker =3D {
> +		.cb	=3D s2_mmu_nonempty_walker,
> +		.flags	=3D KVM_PGTABLE_WALK_LEAF | KVM_PGTABLE_WALK_TABLE_PRE,
> +	};
> +
> +	return !kvm_pgtable_walk(mmu->pgt, 0, kvm_phys_size(mmu), &walker);
> +}
> +
> +/*
> + * Park @mmu if it is grown, unreferenced and empty, returning it to the
> + * budget. It is invalidated, so no lookup can hand it out, and skipped
> + * by the victim search. It keeps its slot, its struct and its stage-2
> + * root until the VM is destroyed, so walkers of the table that drop
> + * mmu_lock never see it go away. Parking always leaves S2_MMU_PER_VCPU
> + * unparked MMUs per vcpu, so the victim search always has a candidate.
> + */
> +static bool kvm_nested_s2_park(struct kvm *kvm, struct kvm_s2_mmu *mmu)
> +{
> +	unsigned int keep =3D atomic_read(&kvm->online_vcpus) * S2_MMU_PER_VCPU;
> +
> +	lockdep_assert_held_write(&kvm->mmu_lock);
> +
> +	if (kvm->arch.nested_mmus_size - kvm->arch.nested_mmus_parked <=3D keep)
> +		return false;
> +
> +	if (!mmu->grown || mmu->parked || atomic_read(&mmu->refcnt) ||
> +	    !mmu->pgt || !kvm_s2_mmu_empty(mmu))
> +		return false;
> +
> +	if (kvm_s2_mmu_valid(mmu))
> +		kvm_init_nested_s2_mmu(mmu);
> +	mmu->parked =3D true;
> +	mmu->pending_unmap =3D false;

[Severity: Medium]
Can kvm_nested_s2_park() leave stale entries in mmu->guest_s2_mappings
when parking an MMU?

kvm_s2_mmu_empty() only checks mmu->pgt, which can be empty while
mmu->guest_s2_mappings still holds nodes (for example, if a guest stage-2
TLBI unmapped a subrange of a block mapping: stage2_unmap_walker() breaks
the entire block PTE in mmu->pgt, while kvm_remove_guest_s2_mappings()
keeps nodes larger than the unmap range).

Because kvm_nested_s2_park() marks the MMU invalid via
kvm_init_nested_s2_mmu() and clears mmu->pending_unmap, a later
reactivation and reuse in get_s2_mmu_nested() will not request
KVM_REQ_NESTED_S2_UNMAP, leaving the old tracking nodes attached to the
new nested context until a full unmap or VM teardown.  Calling
kvm_remove_guest_s2_mappings(mmu, 0, kvm_phys_size(mmu)) before parking
would clear any remaining tracking entries.

[ ... ]

> @@ -216,14 +266,15 @@ static int kvm_nested_add_s2_mmus(struct kvm *kvm, =
int nr, bool grow)
>  static void kvm_nested_s2_grow(struct kvm *kvm)
>  {
> -	int nr, add;
> +	int nr, add =3D 0, reactivated =3D 0, first =3D -1;
> =20
>  	guard(mutex)(&kvm->arch.config_lock);
> =20
> @@ -238,15 +289,57 @@ static void kvm_nested_s2_grow(struct kvm *kvm)
>  		return;
>  	}
> =20
> -	add =3D min_t(int, nr, S2_MMU_MAX_PER_VM - kvm->arch.nested_mmus_size);
> +	scoped_guard(write_lock, &kvm->mmu_lock) {
> +		for (int i =3D 0; i < kvm->arch.nested_mmus_size; i++) {
> +			struct kvm_s2_mmu *mmu =3D kvm->arch.nested_mmus[i];
> +
> +			if (reactivated =3D=3D nr)
> +				break;
> +			if (!mmu->parked)
> +				continue;
> +
> +			mmu->parked =3D false;
> +			reactivated++;
> +			if (first < 0)
> +				first =3D i;
> +		}
> +
> +		if (reactivated) {
> +			kvm->arch.nested_mmus_grown +=3D reactivated;
> +			kvm->arch.nested_mmus_parked -=3D reactivated;
> +			kvm->arch.nested_mmus_next =3D first;
> +		}
> +
> +		add =3D min_t(int, nr - reactivated,
> +			    S2_MMU_MAX_PER_VM - kvm->arch.nested_mmus_size);
> +	}
> +
>  	if (add && kvm_nested_add_s2_mmus(kvm, add, true)) {

[Severity: Medium]
When kvm_nested_s2_grow() both reactivates parked MMUs (0 < reactivated <
nr) and allocates new ones (add > 0), does kvm_nested_add_s2_mmus()
clobber kvm->arch.nested_mmus_next =3D first?

kvm_nested_add_s2_mmus() unconditionally sets kvm->arch.nested_mmus_next
to the old nested_mmus_size.  After get_s2_mmu_nested() hands out the new
MMUs at the tail, the clock hand wraps to index 0 and recycles live MMUs
in [0, first) whose accessed bits were just cleared by the pass that
triggered the grow, before reaching the empty reactivated MMUs at
[first, size).

[ ... ]

> @@ -984,7 +1078,7 @@ static struct kvm_s2_mmu *get_s2_mmu_nested(struct k=
vm_vcpu *vcpu)
>  		struct kvm_s2_mmu *mmu;
> =20
>  		mmu =3D kvm->arch.nested_mmus[i % kvm->arch.nested_mmus_size];
> -		if (atomic_read(&mmu->refcnt))
> +		if (atomic_read(&mmu->refcnt) || mmu->parked)
>  			continue;

[Severity: High]
Can skipping parked MMUs here trigger BUG_ON(victim < 0) in
get_s2_mmu_nested() when vCPUs are initialized after the pool has grown?

arch/arm64/kvm/nested.c:kvm_vcpu_init_nested() {
    ...
	num_mmus =3D atomic_read(&kvm->online_vcpus) * S2_MMU_PER_VCPU;

	if (num_mmus > kvm->arch.nested_mmus_size) {
		int ret =3D kvm_nested_add_s2_mmus(kvm, S2_MMU_PER_VCPU, false);
    ...
}

kvm_vcpu_init_nested() compares num_mmus against nested_mmus_size, which
includes grown and parked MMUs rather than just the base non-grown pool
(nested_mmus_size - nested_mmus_grown - nested_mmus_parked).

If vCPU 0 is created, initialized (nested_mmus_size =3D=3D 2), and runs in
nested mode to grow the pool (for example by 4 MMUs to nested_mmus_size
=3D=3D 6), and then executes TLBI ALLE1, kvm_nested_s2_park() parks all 4
grown MMUs (keep =3D=3D 2, leaving 2 unparked MMUs).  If userspace then
creates and initializes vCPU 1 and vCPU 2 (allowed before VGIC init or
when !irqchip_in_kernel(kvm)), num_mmus > kvm->arch.nested_mmus_size is
false, so no base MMUs are added and the 4 grown MMUs remain parked.  The
VM now has 3 online vCPUs and only 2 unparked MMUs; when 2 vCPUs hold
references to those 2 MMUs and the 3rd calls get_s2_mmu_nested(), every
entry is either referenced or parked and the host hits BUG_ON(victim < 0).

Even when all vCPUs are created upfront, if vCPU 0 grows the pool before
the remaining vCPUs call KVM_ARM_VCPU_INIT, kvm_vcpu_init_nested() skips
allocating their base MMUs, and kvm_nested_s2_park() permanently retains
grown MMUs against the host budget to satisfy keep.

> @@ -1010,7 +1104,8 @@ static struct kvm_s2_mmu *get_s2_mmu_nested(struct =
kvm_vcpu *vcpu)
> =20
>  	/* Every free MMU is in concurrent use: the pool is too small */
>  	if (in_use && !READ_ONCE(kvm->arch.nested_mmus_no_grow) &&
> -	    kvm->arch.nested_mmus_size < S2_MMU_MAX_PER_VM &&
> +	    (kvm->arch.nested_mmus_size < S2_MMU_MAX_PER_VM ||
> +	     kvm->arch.nested_mmus_parked) &&
>  	    nested_s2_mmus_budget_left()) {
>  		WRITE_ONCE(kvm->arch.nested_mmus_grow, true);
>  		kvm_make_request(KVM_REQ_NESTED_S2_GROW, vcpu);

[Severity: Medium]
Does nested_mmus_no_grow prevent reactivating already-allocated parked
MMUs?

If a grow allocation in kvm_nested_add_s2_mmus() fails after the VM has
already accumulated grown MMUs, kvm_nested_s2_grow() sets
nested_mmus_no_grow =3D true.  Once a later guest TLBI parks those earlier
grown MMUs, checking !READ_ONCE(kvm->arch.nested_mmus_no_grow) here and
at the start of kvm_nested_s2_grow() blocks reactivating them even though
reactivation needs no memory allocation, leaving their memory and stage-2
PGDs allocated but unusable until VM teardown.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261124211218.2751=
086-1-nathanc@nvidia.com?part=3D5
