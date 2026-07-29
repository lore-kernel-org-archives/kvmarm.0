Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65DEA4570F9;
	Wed, 29 Jul 2026 11:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785324086; cv=none; b=aCmNdRhyvQpmvRTLKH+BJYopKkrQiaoLBy76yX5sU+GIe0sLIRMUcg7Y1o7C3O8sgAKJj1VPpNlivGeYWTaGaC4wEDA8hLdcM/gl0D8vlC9oxaV8cIIR11KuWFBlpwstpCJFtyA+pkCKLU+ijX/HVJh5U415fl5UPDC20jcohqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785324086; c=relaxed/simple;
	bh=QuHyBg2s/cehQjopfMw129GzUIxoe/UFnCMnn1GNcXk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=qwQ2iNtzhE/n48fO6nf631gAolJjfEToh5YtiY+mNEcL10APIFShdE6uyIlCY0h2R3uv2jURCADZ+hZXJXIXbXN/Bmbbs/nyhu42qLtKzWKl4RJ67zfr3q9VJUkKfQ5rITWMHh4sxcll0M/vcbyIMAFfFgHzJ42zl402qCQEotg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c7a3y3J7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c7a3y3J7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F29F11F000E9;
	Wed, 29 Jul 2026 11:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785324085;
	bh=J7nXFxZdyacDpxnEOUxAoppGxuL4M65Y2OOvAS6ie74=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=c7a3y3J76oE0Hdv8mca6mAko3D6r3DQ2ZqrJphm3wFn8fkhdnpU9EVhAXoFkl5/56
	 ZCH22fgCv9RKxMvKs5c0rRsCJ8VJ+XVdAkVQsR6YokQhM9rJpZTKR9tYCz5Nbm/P2Y
	 kmn1kn0Nv+Lmr80QDI6qFZp5s7DPzqOqprJReTkk2WrSwGKi45WPEDM8xf+33aQJwk
	 gHvKN7JI7yW18UrSznNLN4uU4I2Xg5Bfs3QjdVtX0FQyy/47YziYbz7MR5QacrzDin
	 TLN+wjbM7pN2h/JaFNnr14HV6V/1F+IONB356r+uSxt+kTafpgnAL6/HgjaKxTKfXn
	 sqK/8CaUfw5Yg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 10/11] KVM: arm64: Add hardware-accelerated
 dirty-ring cleaning routine
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leonardo Bras" <leo.bras@arm.com>
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260729104548.3439958-11-leo.bras@arm.com>
References: <20260729104548.3439958-1-leo.bras@arm.com>
 <20260729104548.3439958-11-leo.bras@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 29 Jul 2026 11:21:24 +0000
Message-Id: <20260729112124.F29F11F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [Critical] Hardware-accelerated dirty ring clear directly accesses EL2 sy=
stem registers from the host kernel, causing fatal unhandled exceptions on =
nVHE and pKVM systems.
- [High] The `hw_entries` buffer is allocated using kmalloc, which does not=
 guarantee the page alignment strictly required by the `SYS_HACDBSBR_EL2` h=
ardware register.

Pre-existing issues:
- [High] Writes to control-plane system registers are batched without an in=
tervening `isb()`, violating ARM64 architectural synchronization requiremen=
ts.
--

--- Patch [10]: [PATCH v3 10/11] KVM: arm64: Add hardware-accelerated dirty=
-ring cleaning routine ---
commit f9fc2a3f2ff348143923dea638ecd996e369580d
Author: Leonardo Bras <leo.bras@arm.com>

KVM: arm64: Add hardware-accelerated dirty-ring cleaning routine
   =20
Implement arm64 version of kvm_arch_dirty_ring_clear() making use of
FEAT_HACDBS.
   =20
It works by transversing the dirty-ring and converting its entries into
HDBSS entries based on the slot offset.
   =20
The resulting HDBSS array is then fed to the HACDBS mechanism that walks
the pagetable marking writable-dirty pages as writable-clean.

> diff --git a/arch/arm64/include/asm/kvm_dirty_bit.h b/arch/arm64/include/=
asm/kvm_dirty_bit.h
> index d368a23a84b30..f785a7aad9e88 100644
> --- a/arch/arm64/include/asm/kvm_dirty_bit.h
> +++ b/arch/arm64/include/asm/kvm_dirty_bit.h
> @@ -15,6 +15,9 @@ int __kvm_arch_dirty_log_clear(struct kvm *kvm,
>  			       unsigned long *bitmap,
>  			       bool *flush);
> =20
> +int __kvm_arch_dirty_ring_clear(struct kvm *kvm, struct kvm_dirty_ring *=
ring,
> +				int *nr_entries_reset);
> +
>  static inline bool kvm_arch_dirty_clear_enabled(struct kvm *kvm)
>  {
>  	return system_supports_hacdbs() &&  kvm->arch.mmu.pgt &&
>  	       (kvm->arch.mmu.pgt->flags & KVM_PGTABLE_S2_DBM);
>  }

[Severity: Critical]
Does this gating function also need to verify the VHE execution mode?

By checking only system_supports_hacdbs(), it appears this permits the
accelerated path to be invoked on nVHE and pKVM host systems.

Since dirty_bit_clear() performs direct accesses to EL2 system registers
from the host kernel:

arch/arm64/kvm/dirty_bit.c:dirty_bit_clear() {
    ...
    __load_stage2(&kvm->arch.mmu);
    sysreg_clear_set_hcr(0, HCR_EL2_VM);
    ...
}

Wouldn't this trigger an unhandled hypervisor trap or undefined instruction
exception when triggered by userspace on nVHE systems?

[ ... ]
> diff --git a/arch/arm64/kvm/dirty_bit.c b/arch/arm64/kvm/dirty_bit.c
> index d7e624f9b6308..ca9cfefe0893b 100644
> --- a/arch/arm64/kvm/dirty_bit.c
> +++ b/arch/arm64/kvm/dirty_bit.c
[ ... ]
> @@ -359,3 +359,80 @@ int __kvm_arch_dirty_log_clear(struct kvm *kvm,
> =20
>  	return ret;
>  }
> +
> +int __kvm_arch_dirty_ring_clear(struct kvm *kvm, struct kvm_dirty_ring *=
ring,
> +				int *nr_entries_reset)
> +{
> +	u64 *hw_entries __free(kfree) =3D NULL;
> +	u64 ttwl;
> +	s64 cur_slot =3D S64_MAX;
> +	int i, ret;
> +	struct kvm_memory_slot *memslot;
> +
> +	if (signal_pending(current))
> +		return -EINTR;
> +
> +	ttwl =3D HDBSS_ENTRY_TTWL(KVM_PGTABLE_LAST_LEVEL);
> +
> +	hw_entries =3D kmalloc(max(ring->size * sizeof(u64), PAGE_SIZE), GFP_KE=
RNEL);

[Severity: High]
Could this allocation cause the hardware accelerator to read from the wrong
memory address?

When debugging features like SLUB debugging are enabled, kmalloc allocations
are not strictly page-aligned because of prepended metadata.

The SYS_HACDBSBR_EL2 hardware register requires a page-aligned physical
base address. When hacdbs_start() masks out the offset using
HACDBSBR_EL2_BADDR_MASK, an unaligned base address gets truncated.

Will this result in the hardware reading from the start of the physical
page instead of the actual hw_entries array? It might be necessary to use
alloc_pages_exact() or __get_free_pages() here to guarantee alignment.

> +	if (!hw_entries)
> +		return -ENOMEM;
> +
[ ... ]
> +	if (i =3D=3D 0)
> +		return 0;
> +
> +	write_lock(&kvm->mmu_lock);
> +	ret =3D dirty_bit_clear(kvm, hw_entries, i);

[Severity: High]
This is a pre-existing issue, but is it possible that the hardware routines
called here violate architectural synchronization requirements?

Looking at the underlying functions, writes to control-plane system
registers seem to be batched without an intervening isb() as the very next
instruction.

For example, in hacdbs_start():

arch/arm64/kvm/dirty_bit.c:hacdbs_start()
    ...
    sysreg_clear_set_s(SYS_HACDBSCONS_EL2,
                       HACDBSCONS_EL2_ERR_REASON | HACDBSCONS_EL2_INDEX, 0);
                      =20
    br =3D (virt_to_phys(hw_entries) & HACDBSBR_EL2_BADDR_MASK) | ...
    ...

And in hacdbs_sched_in():

arch/arm64/kvm/dirty_bit.c:hacdbs_sched_in()
    ...
    write_sysreg_s(save->save.vtcr_el2, SYS_VTCR_EL2);
    write_sysreg_s(save->save.vttbr_el2, SYS_VTTBR_EL2);
    isb();

Could this allow the CPU to execute the intervening instructions in an
architecturally undefined pipeline state?

> +	write_unlock(&kvm->mmu_lock);
> +
> +	/* Set as invalid all successfully cleaned entries */
[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260729104548.3439=
958-1-leo.bras@arm.com?part=3D10
