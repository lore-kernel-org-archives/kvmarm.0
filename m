Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795556083;
	b=U+8HWLXT6JU+eJb6XiDtyano+5cLoIHgCujQxc2UJ66M1zPFedCA9BpMkZLJvVcvHx3x
	 G9K1wT0PnXgVYKYZL0YwldMHWhpbHMYo98SLnZalhYm77vWhIvR+cK/Oxldr7d27eHWkW
	 MoASRKLPyCoYdOiVsEhD8qREJfxk8BC3trx24tdsvuKEUIMi18Hc4QAYHO8Ap91MnTkgP
	 aej5aOVw6VSLGogxtXrFq7XCp5OBFlnv91IkSbesJUSyJY3+1H7YtepbHKXoVtAQe1tJO
	 LN+tVRHoVQFczULLtpWA+hWbmkqJM2UaXRuZWh0V/FXqJv6rIJ+kU9hIV8/bZSY329w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795556083;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=LY4DvxoieU9m+gzGOvWUzLp2xO5b5yJzX0tje1QrOWI=;
	b=SV/ztR0jDghQOJJq3r50gjayqGc7xs32geC5onVnDgl/rexwnL5kgCOqOkKA5M2U0uPt
	 dlMwZbaH7Tn8FbICcRmnjcIFTGqCQINaMo3RrEqVjZslRwhCRfV9Uy6+lU9liBmRnu5dC
	 1DJHDpyengqViABQB7ksA00N41Z2NNf+wP+lPvyNpQxVSSGvGWFEyDHTw6ns3PsB56Yh7
	 2ub9bcRR4HqAyCQgWBO+o2BfPMTErAQjs254MD/2JQ197sTTdTTuVt1i1YdvBSOD4M7nQ
	 vxGnaiGQrJq2L0uPaquCk+kg7zqEJwDGyrCTrpetry/lhCgT2WA274l3uCI0zP9JqBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QdU6qiJl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7374606A31E
	for <kvmarm@lists.linux.dev>; Tue, 24 Nov 2026 21:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QdU6qiJl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C39871F000D8;
	Tue, 24 Nov 2026 21:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795556082;
	bh=LY4DvxoieU9m+gzGOvWUzLp2xO5b5yJzX0tje1QrOWI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QdU6qiJllPFGMsPAPklD1Va4ef0h+VUHkz55BMU4M5TaruGsDdSue/U2FMnnDTm61
	 lMiGvh0YsQ7Gw7LPCwinTZgllmjGRq4GdWYiUj/0GtLDjaBc5tJl5b7o+hrEP1cJWD
	 sRETZvsq80ul38v3yn9Wzt1PLTxdAqNvGndhEo5nX8Jy5lvaHTarIiZwXZK8PFBig7
	 kU5m6V13vMA8ih5BnJWdUnNzInk1WOxdQeI75WJocjeHPdyHBl6laYeMbGSP3mZ8lH
	 hD+gRCkt7C+bbYDTwpGOouUuGlq4QEo8WUVq4bPPaptyq3W8cOo75G6A24Nps9mHu8
	 IkW0Nog3RfBGA==
Message-ID: <sashiko-outbox-232050@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 4/6] KVM: arm64: nv: Grow the shadow S2 MMU pool on
 demand
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nathan Chen" <nathanc@nvidia.com>, kvmarm@lists.linux.dev
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261124211218.2751086-5-nathanc@nvidia.com>
References: <20261124211218.2751086-1-nathanc@nvidia.com>
 <20261124211218.2751086-5-nathanc@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 24 Nov 2026 21:34:41 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [Medium] KVM: arm64: nv: premature pool growth in get_s2_mmu_nested()
  clock sweep
- [Medium] KVM: arm64: nv: missing __GFP_NORETRY in init_nested_s2_mmu()
  on pool grow
- [Medium] KVM: arm64: nv: skipped baseline MMU allocation in
  kvm_vcpu_init_nested()
--

commit ed87347a8e1063feec4d2776535ef6edc4da64e2
Author: Nathan Chen <nathanc@nvidia.com>

KVM: arm64: nv: Grow the shadow S2 MMU pool on demand

This commit grows a nested-capable VM's shadow stage-2 MMU pool on demand
when all free MMUs in the pool have been accessed since the last victim
sweep, bounded by a per-VM limit and a host-wide VMID budget.

> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 44dc6780fe6fe..d530a37716be6 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
[ ... ]
> @@ -91,16 +139,25 @@ static int init_nested_s2_mmu(struct kvm *kvm, struc=
t kvm_s2_mmu *mmu)
>  	return kvm_init_stage2_mmu(kvm, mmu, kvm_get_pa_bits(kvm));
>  }
> =20
> -/* Add a block of @nr shadow S2 MMUs to the pool */
> -static int kvm_nested_add_s2_mmus(struct kvm *kvm, int nr)
> +/*
> + * Add a block of @nr shadow S2 MMUs to the pool, reallocating the
> + * pointer table if it is full. Only the table moves, never the MMUs, so
> + * cached hw_mmu pointers stay valid. Runtime walkers of the table hold
> + * mmu_lock, and kvm_arch_flush_shadow_all() only runs once no vcpu can
> + * enter the guest, so it can't race with a grow.
> + */
> +static int kvm_nested_add_s2_mmus(struct kvm *kvm, int nr, bool grow)
>  {
> +	gfp_t gfp =3D GFP_KERNEL_ACCOUNT | (grow ? __GFP_NORETRY : 0);
>  	size_t size =3D kvm->arch.nested_mmus_size;
> +	size_t cap =3D kvm->arch.nested_mmus_capacity;
> +	struct kvm_s2_mmu **table =3D NULL;
>  	struct nested_s2_mmu_block *blk;
>  	int i, ret =3D 0;
> =20
>  	lockdep_assert_held(&kvm->arch.config_lock);
> =20
> -	blk =3D kvzalloc_flex(*blk, mmus, nr, GFP_KERNEL_ACCOUNT);
> +	blk =3D kvzalloc_flex(*blk, mmus, nr, gfp);
>  	if (!blk)
>  		return -ENOMEM;
> =20
>  	for (i =3D 0; i < nr; i++) {
>  		ret =3D init_nested_s2_mmu(kvm, &blk->mmus[i]);
>  		if (ret)
>  			goto out_free;

[Severity: Medium]
Should init_nested_s2_mmu() -> kvm_init_stage2_mmu() also receive @gfp so
that its allocations carry __GFP_NORETRY when @grow is true?

kvzalloc_flex() and kvmalloc_objs() use __GFP_NORETRY on grow, but
kvm_init_stage2_mmu() still allocates each struct kvm_pgtable and stage-2
PGD (up to 16 contiguous pages per MMU in kvm_host_zalloc_pages_exact())
with hardcoded GFP_KERNEL_ACCOUNT.  When a VM near its memcg limit
triggers kvm_nested_s2_grow(), the small block allocation can succeed
while the PGD allocations enter full reclaim and trigger the memcg OOM
killer instead of failing fast and setting nested_mmus_no_grow.

[ ... ]

> @@ -155,7 +270,7 @@ int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
>  	num_mmus =3D atomic_read(&kvm->online_vcpus) * S2_MMU_PER_VCPU;
> =20
>  	if (num_mmus > kvm->arch.nested_mmus_size) {
> -		int ret =3D kvm_nested_add_s2_mmus(kvm, S2_MMU_PER_VCPU);
> +		int ret =3D kvm_nested_add_s2_mmus(kvm, S2_MMU_PER_VCPU, false);

[Severity: Medium]
Should kvm_vcpu_init_nested() compare num_mmus against the baseline MMU
count (nested_mmus_size - nested_mmus_grown) rather than
nested_mmus_size?

If an already-initialized vcpu runs and triggers kvm_nested_s2_grow()
before the remaining vcpus run KVM_ARM_VCPU_INIT, nested_mmus_size
already includes nested_mmus_grown.  Later kvm_vcpu_init_nested() calls
then see num_mmus <=3D nested_mmus_size and skip allocating those vcpus'
baseline S2_MMU_PER_VCPU MMUs, leaving the pool smaller by
S2_MMU_PER_VCPU per late-initialized vcpu and keeping their baseline MMUs
charged against the global nested_s2_mmus_grown budget.

[ ... ]

> @@ -842,6 +957,7 @@ static struct kvm_s2_mmu *get_s2_mmu_nested(struct kv=
m_vcpu *vcpu)
>  {
>  	struct kvm *kvm =3D vcpu->kvm;
>  	struct kvm_s2_mmu *s2_mmu;
> +	bool in_use =3D true;
>  	int i, victim =3D -1;
> =20
>  	lockdep_assert_held_write(&vcpu->kvm->mmu_lock);
> @@ -859,8 +975,8 @@ static struct kvm_s2_mmu *get_s2_mmu_nested(struct kv=
m_vcpu *vcpu)
>  	 * hasn't been used since the search last went past it (such as
>  	 * one left behind by a torn down guest), is recycled straight
>  	 * away. Other free MMUs lose their accessed bit and get a second
> -	 * chance. If every free MMU was used since the last pass, the
> -	 * first one found is recycled.
> +	 * chance. If every free MMU was used since the last pass, they
> +	 * are all in concurrent use and the pool is too small.
>  	 */
>  	for (i =3D kvm->arch.nested_mmus_next;
>  	     i < (kvm->arch.nested_mmus_size + kvm->arch.nested_mmus_next);
> @@ -873,6 +989,7 @@ static struct kvm_s2_mmu *get_s2_mmu_nested(struct kv=
m_vcpu *vcpu)
> =20
>  		if (!kvm_s2_mmu_valid(mmu) || !mmu->accessed) {
>  			victim =3D i;
> +			in_use =3D false;
>  			break;
>  		}
> =20
> @@ -891,6 +1008,14 @@ static struct kvm_s2_mmu *get_s2_mmu_nested(struct =
kvm_vcpu *vcpu)
>  	if (kvm_s2_mmu_valid(s2_mmu))
>  		s2_mmu->pending_unmap =3D true;
> =20
> +	/* Every free MMU is in concurrent use: the pool is too small */
> +	if (in_use && !READ_ONCE(kvm->arch.nested_mmus_no_grow) &&
> +	    kvm->arch.nested_mmus_size < S2_MMU_MAX_PER_VM &&
> +	    nested_s2_mmus_budget_left()) {
> +		WRITE_ONCE(kvm->arch.nested_mmus_grow, true);
> +		kvm_make_request(KVM_REQ_NESTED_S2_GROW, vcpu);
> +	}

[Severity: Medium]
Does setting s2_mmu->accessed =3D true on a lookup miss cause
get_s2_mmu_nested() to grow the pool even when old MMUs are never reused?

When the loop picks an invalid or unaccessed slot at nested_mmus_next, it
breaks on the first iteration, advances nested_mmus_next to victim + 1
without sweeping other slots, and sets s2_mmu->accessed =3D true at the out
label:

arch/arm64/kvm/nested.c:get_s2_mmu_nested() {
    ...
out:
	atomic_inc(&s2_mmu->refcnt);
	s2_mmu->accessed =3D true;
    ...
}

Each newly allocated MMU therefore sits right behind the clock hand with
accessed =3D=3D true before any lookup_s2_mmu() hit has occurred.  After the
initial 2 * online_vcpus misses fill the invalid slots, the very first
recycle sees accessed =3D=3D true on every slot and triggers
KVM_REQ_NESTED_S2_GROW even if the guest only ran one nested VM at a
time.  After a grow resets nested_mmus_next =3D size, consuming the new
invalid slots and stepping one by one through the unaccessed slots leaves
at least size + online_vcpus - 1 slots with accessed =3D=3D true from
allocation misses alone, so a single active reference or lookup hit on
the remaining slot triggers another grow cycle, inflating the pool toward
S2_MMU_MAX_PER_VM (4096) and slowing linear scans over nested_mmus under
mmu_lock.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261124211218.2751=
086-1-nathanc@nvidia.com?part=3D4
