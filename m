Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C862EB856;
	Fri,  3 Jul 2026 16:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783096310; cv=none; b=N/7/v+iwLR2rQgV8HMYpzoL9iQk+17fCo/a3LVV9RvvI0wYdxwcXflNXlleNvL3nzCDXTBeK5+LU0LjW4To8/vrksnCrAMDWZ5OQ7B5yYhSMoKpJP/etF6D2MvuZrqsns3qHdxEMxvn/puVxa6NsAlMJtGgio4WT6JW3IhgO5ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783096310; c=relaxed/simple;
	bh=I88X+jHM0rBxzdlsXl8pdTRw+KM3Q+tZq18EmHU0MOQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=P/Gin8oHS67094WwsMrUpbE2NwOdSusCCSyoPyPd10pL+d6vWZqIzcEKZ+wCaAtRKEC6mcZg2D7521F6qVxJ8uBZJ3CgsJz2vBSFbxRCVqMp8epV93myoT55nQwewf+qH8PEUsr5v82KiTHS7rgtZs8Rf9odrHcI4ZnSrvqdZz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g5jm9ort; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g5jm9ort"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80DCD1F00A3A;
	Fri,  3 Jul 2026 16:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783096308;
	bh=DaNxw/y8tS/1Ya6n6lnzKtNbugGYnEKqNa0l3SQ1/fQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=g5jm9ortgF7JwKtnaaTCFOIROy3CnV3NxRA1aA6e1Bg4lqbt8YgA/8jFu2Ny4+8gY
	 Zsillxm7Q+ID54I0uhIBdL58CiacXDKELB3NvQp2B/DKoKvrbKPDCtOOHAP5GvqxWZ
	 CqvCpYGSCk4Vex0ZJhMV5R7A+SN4O1SH3L8gzwkPyDWbpqWma47qQUDmU7vAjf85zI
	 PzuknZfsoPldw6S5+cTdptX/1fyi7CQ/KH3UWk4c0LN2vMIzOjA4XjgEeQMifdaIdy
	 MHjw8wHScSP/hhJ0NI+wbKS1FkQfNtergSb3IJaqf7WkDsarppdsx2Zte4oAJkvVKf
	 1ZNnAl3MrhcaQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 09/40] KVM: arm64: gic-v5: Create and manage VM and
 VPE tables
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
In-Reply-To: <20260703154811.3355680-10-sascha.bischoff@arm.com>
References: <20260703154811.3355680-1-sascha.bischoff@arm.com>
 <20260703154811.3355680-10-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 16:31:48 +0000
Message-Id: <20260703163148.80DCD1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:
- [High] Hardware-modified VMT and VPET tables are allocated as Cacheable m=
emory and managed with CPU cache maintenance, leading to false sharing and =
loss of hardware writes on systems with a non-coherent IRS.
- [High] Incorrect calculation of `vpe_id_bits` tells the hardware the VPET=
 is twice its actual size, allowing a guest to trigger out-of-bounds IRS me=
mory accesses.
- [High] Failure to check if `vped_size` is zero before allocation leads to=
 `ZERO_SIZE_PTR` usage, resulting in bogus physical addresses and a kernel =
panic during cache maintenance.
- [High] The L1 Virtual Machine Table and linear VMT allocations lack the 4=
KB page alignment required by the GICv5 hardware for `IRS_VMT_BASER`.
- [Medium] Error paths in `vgic_v5_vmte_release` return early after freeing=
 VPE tracking pointers, leaving dangling pointers in the globally reachable=
 `vmi` structure.
--

commit f0a39157639262cdd2140f7a3d5512f31e4004d2
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>
KVM: arm64: gic-v5: Create and manage VM and VPE tables

This patch adds support for allocating the Virtual Machine Table (VMT) and
Virtual PE Table (VPET) to track VM state for GICv5. It introduces lifecycle
management and tracking for unused VMTEs via an IDA.

> diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.c b/arch/arm64/kvm/vgic/v=
gic-v5-tables.c
> index db8cb6a384994..xxxxxxxxxxxxx 100644
> --- a/arch/arm64/kvm/vgic/vgic-v5-tables.c
> +++ b/arch/arm64/kvm/vgic/vgic-v5-tables.c
[ ... ]
> static int vgic_v5_alloc_vmt_linear(unsigned int num_entries)
> {
> 	vmt_info->linear.vmt_base =3D kzalloc_objs(*vmt_info->linear.vmt_base,
> 						 num_entries);

[Severity: High]
Does this allocation guarantee the 4KB alignment required by the GICv5
hardware for IRS_VMT_BASER?

When the base address is written to VMT_BASER in vgic_v5_irs_assign_vmt(),
the lower 12 bits are stripped:

vmt_baser =3D FIELD_PREP(...) | (vmt_base & GICV5_IRS_VMT_BASER_ADDR);

Since kzalloc_objs() only guarantees SLUB alignment (e.g., 8 or 16 bytes
for small allocations), won't the truncation of the lower bits cause the
hardware to read from the wrong address at the start of the 4KB page?

[ ... ]
> static int vgic_v5_alloc_vmt_two_level(unsigned int num_entries)
> {
[ ... ]
> 	vmt_info->l2.vmt_base =3D kzalloc_objs(*vmt_info->l2.vmt_base,
> 					     vmt_info->l2.num_l1_ents);

[Severity: High]
Should these hardware-modified tables be allocated from Non-Cacheable memory
instead of standard Cacheable memory (via kzalloc_objs)?

For systems with a non-coherent IRS, vgic_v5_clean_inval() uses
dcache_clean_inval_poc() which executes DC CIVAC. Because VMT and VPET
entries are tightly packed, multiple entries can share a single 64-byte
cache line.

If the hardware writes to these tables (like setting VALID bits) and the
CPU later invalidates or cleans an adjacent entry, could the CIVAC operation
write back the CPU's stale cache state and silently overwrite concurrent
hardware updates?

[ ... ]
> int vgic_v5_vmte_init(struct kvm *kvm)
> {
[ ... ]
> 	/*
> 	 * Allocate and assign the VPE Table. Round up the number of CPUs to a
> 	 * whole power of two as we cannot describe non-powers-of-two in the
> 	 * VMTE field as it conveys the number of ID bits used and not the
> 	 * number of vPEs.
> 	 *
> 	 * The IRS encodes the number of IAFFID bits as N - 1, so a VM with a
> 	 * single vCPU must still allocate two VPET entries and expose 1 bit.
> 	 */
> 	nr_cpus =3D max(2UL, roundup_pow_of_two(nr_cpus));
> 	vmi->vpe_id_bits =3D fls(nr_cpus) - 1;

[Severity: High]
Is there an off-by-one calculation error here for vmi->vpe_id_bits?

The hardware expects the number of ID bits to be encoded as N - 1 for a
table of 2^N entries. Since nr_cpus is already rounded up to a power of 2,
fls(nr_cpus) - 1 evaluates to ilog2(nr_cpus), which is N rather than N - 1.

By writing N into the VPE_ID_BITS field, does this instruct the hardware
that the VPET has 2^(N+1) entries instead of 2^N? A guest could potentially
trigger out-of-bounds IRS memory accesses by targeting an interrupt at a
VPE ID in the non-existent upper half.

[ ... ]
> int vgic_v5_vmte_release(struct kvm *kvm)
> {
[ ... ]
> 	for (int i =3D 0; i < BIT(vmi->vpe_id_bits); i++)
> 		kfree(vmi->vped_ptrs[i]);
> 	kfree(vmi->vped_ptrs);
> 	kfree(vmi->vpet_base);
> 	kfree(vmi->vmd_base);
>=20
> 	/* Unlikely, but possible. Avoid leaking the memory. */
> 	vgic_v5_drain_pending_irqs(kvm, vmi, false);
>=20
> 	/* If we have an LPI IST, free it */
> 	if (vmi->h_lpi_ist) {
> 		ret =3D vgic_v5_lpi_ist_free(kvm);
> 		if (ret)
> 			return ret;
> 	}

[Severity: Medium]
Does returning early here leave dangling pointers in the globally reachable
vmi structure?

The pointers for vped_ptrs, vpet_base, and vmd_base are unconditionally
freed just above this check. If vgic_v5_lpi_ist_free() (or
vgic_v5_spi_ist_free() below it) fails, the function returns immediately
without erasing the vmi object from the vm_info XArray or setting the
freed pointers to NULL.

If the teardown is retried, will this result in a double-free of these
pointers when vgic_v5_vmte_release() runs again?

[ ... ]
> int vgic_v5_vmte_alloc_vpe(struct kvm_vcpu *vcpu)
> {
[ ... ]
> 	/* Alloc VPE Descriptor. Only used by IRS. */
> 	vped =3D kzalloc(vmt_info->vped_size, GFP_KERNEL);
> 	if (!vped)
> 		return -ENOMEM;

[Severity: High]
Could vmt_info->vped_size be zero here, leading to a ZERO_SIZE_PTR
allocation?

Unlike the VM descriptor allocation which explicitly checks if
vmt_info->vmd_size !=3D 0, this allocation proceeds unconditionally. If the
IRS does not require a VPE descriptor and specifies a size of 0, kzalloc()
will return the non-null ZERO_SIZE_PTR (0x10).

If that happens, won't virt_to_phys() generate a bogus physical address for
the hardware, and won't the subsequent vgic_v5_clean_inval(vped, ...)
cause a kernel panic when dcache_clean_inval_poc() executes a cache
maintenance instruction on the unmapped 0x10 address?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703154811.3355=
680-1-sascha.bischoff@arm.com?part=3D9
