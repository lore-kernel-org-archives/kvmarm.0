Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0EBA4322F8;
	Fri, 24 Jul 2026 11:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784891957; cv=none; b=sYO8O6hiWyceAihF/E9sFqIkEJcAVk/c9qKwS4Z0kZtb+RZ4zzWOxuGNR6uvUv2ATaBAeZnjXPnhl3VIjRfRI+WuRdww+ffxHjizMuv5JjYfSC7hTrNZYv43Y+zRiYQUFjdB98aNJL9Puh4w8JUmW+c5EjRpZXglnLVEblCO0uU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784891957; c=relaxed/simple;
	bh=N99OnIrq8sVuX0fcpuUaNOwhGHxhW2GSpVjcCYrrrCs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=UuToB6wE60Nc3oinZ7UY7AB12XfwvcnTHiQymLNDmhJjgYzAMYs9FQP5zJPUhmp50buUl9xKRa1Ea+wJbOjuefh2yor3noX2ZLN+Cnrn/iim0QUhzPmTvdt1KG6OVgOE2ml5VdcFJ06X7qRfSnQAdMdUD0ntwSBIPGXzzC914ZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OTsyN6x+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OTsyN6x+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A83B1F000E9;
	Fri, 24 Jul 2026 11:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784891953;
	bh=xQ10j+q58KoB469Xj42ES0TsO3ZQnIa8X9YvO5aI9qc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OTsyN6x+t9K3Zkh4BeEOeFFyfvM75xHUt82BN6heTLhhV6nWt6vw6Rjax4fwLG/+O
	 87F6dsYvaXHLLW0gG+d4iIHmi5+f7qO9KjBikb960DzNPN1jqB+AT7iXTDRB+bP+ZB
	 G+BzE6Hp5f06CvhiqvUXgKYl9Qmbk8mY9V6iHVzXTtmq2c9sZgBG7a5QAdImkE2yhp
	 RrtK0sM287Zcslpo7kdsqlU4DJZcezFKEXqjbINivcILp0UaQsleaPB0uZ0nOJSZTd
	 rj9LrA+RaQf3j/DHqE4Br4S1HIiVLOy9gImVow1uZeYeUS7Plp6dvc7nzBRXHFcd2Z
	 Nwn6k/YQ3zyWA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 09/48] KVM: arm64: gic-v5: Create and manage VM and
 VPE tables
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org
In-Reply-To: <20260724104819.1296803-10-sascha.bischoff@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
 <20260724104819.1296803-10-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 24 Jul 2026 11:19:13 +0000
Message-Id: <20260724111913.8A83B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 6 potential issue(=
s) to consider:
- [High] `vgic_v5_alloc_l2_vmt()` unconditionally dereferences `kvm_get_vcp=
u(kvm, 0)`, causing a host kernel panic if no vCPUs are online.
- [High] Allocating hardware-modified tables (VMTE and VPETE) densely in no=
rmal cacheable memory causes silent data corruption on non-coherent IRS sys=
tems due to cacheline false sharing.
- [High] Missing cache invalidation before zeroing the VPE table entry caus=
es false-sharing corruption of neighboring hardware state.
- [High] The error handling path in `vgic_v5_vmte_init()` incorrectly calls=
 `xa_erase()` when `xa_insert()` fails with `-EBUSY`, destroying pre-existi=
ng valid state.
- [High] Early returns on error in `vgic_v5_vmte_release()` bypass critical=
 cleanup steps, permanently leaking memory and leaving hardware state activ=
e.
- [Medium] Lockless read of `l2ptrs` array without `READ_ONCE()` can lead t=
o observing a stale or partially updated pointer.
--

--- Patch [9]: [PATCH v4 09/48] KVM: arm64: gic-v5: Create and manage VM an=
d VPE tables ---
commit 6d18ab27d2875b7a3e267a39ae7efb4397ebac92
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>
Subject: KVM: arm64: gic-v5: Create and manage VM and VPE tables

GICv5 uses a set of in-memory tables to track and manage VM
state. These must be allocated by the hypervisor, and provided to the
IRS to use.

> diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.c b/arch/arm64/kvm/vgic/v=
gic-v5-tables.c
> new file mode 100644
> index 0000000000000..22cd03e0f1963
> --- /dev/null
> +++ b/arch/arm64/kvm/vgic/vgic-v5-tables.c
> @@ -0,0 +1,630 @@

[ ... ]

> +static int vgic_v5_alloc_vmt_linear(unsigned int num_entries)
> +{
> +	vmt_info->linear.vmt_base =3D kzalloc_objs(*vmt_info->linear.vmt_base,
> +						 num_entries);

[Severity: High]
Does allocating the hardware-modified VMTE table densely in normal cacheable
memory cause silent data corruption on non-coherent IRS systems?

Since kzalloc_objs() allocates the 32-byte VMTE entries contiguously,
multiple entries will share a 64-byte CPU cache line. If a CPU modifies one
entry, the subsequent DC CIVAC cache maintenance could write the entire cac=
he
line back to memory, overwriting any concurrent hardware updates to
neighboring entries.

[ ... ]

> +static int vgic_v5_alloc_l2_vmt(struct kvm *kvm)
> +{
> +	struct kvm_vcpu *vcpu0 =3D kvm_get_vcpu(kvm, 0);

[ ... ]

> +	/*
> +	 * VMAP in the L2 VMT via the IRS. We use any of the VM's CPUs as a
> +	 * conduit for interacting with the host's IRS. In the current case,
> +	 * this lets us resolve the VM ID to pass to the hardware.
> +	 */
> +	ret =3D irq_set_vcpu_affinity(vgic_v5_vpe_db(vcpu0), &cmd);

[Severity: High]
Can vcpu0 be NULL here, leading to a host kernel panic?

If vgic_v5_vmte_init() is called before any vCPUs are online (which it appe=
ars
to handle by rounding nr_cpus up to 2), kvm_get_vcpu(kvm, 0) will return NU=
LL.
vgic_v5_vpe_db(vcpu0) unconditionally dereferences the vCPU pointer, which
would cause an immediate crash.

[ ... ]

> +static struct vmtl2_entry *vgic_v5_get_l2_vmte(u32 vm_id)
> +{

[ ... ]

> +	if (!vmt_info->l2.l2ptrs[l1_index])
> +		return ERR_PTR(-EINVAL);
> +
> +	l2_table =3D vmt_info->l2.l2ptrs[l1_index];

[Severity: Medium]
Could this lockless read of l2ptrs observe a stale or partially updated
pointer without READ_ONCE()?

Since the array element is accessed locklessly and read twice (once for the
NULL check and once for the assignment), the compiler might emit two separa=
te
loads. A concurrent update in vgic_v5_alloc_l2_vmt() could cause these loads
to return inconsistent states.

[ ... ]

> +int vgic_v5_vmte_init(struct kvm *kvm)
> +{

[ ... ]

> +	ret =3D xa_insert(&vm_info, vm_id, vmi, GFP_KERNEL);
> +	if (ret)
> +		goto out_fail;

[ ... ]

> +	vpet =3D kzalloc_objs(*vpet, nr_cpus);

[Severity: High]
Does allocating the 8-byte VPETE table entries densely cause the same false
sharing and data corruption issues as with the VMTE table?

Since the entries are tightly packed into cache lines, a flush for one entry
could destroy concurrent hardware modifications to neighboring entries on
non-coherent IRS systems.

[ ... ]

> +out_fail:
> +	/* kfree(NULL) is safe so we can just kfree() at leisure */
> +	kfree(vmd);
> +	kfree(vpet);
> +	kfree(vped_ptrs);
> +	if (vmi)
> +		xa_erase(&vm_info, vm_id);

[Severity: High]
Is it safe to unconditionally erase the XArray entry if xa_insert() fails?

If xa_insert() fails with -EBUSY because an entry already exists for this
vm_id (e.g., due to concurrent initialization), the code jumps to out_fail.
Since vmi was successfully allocated and is non-NULL, this cleanup block ca=
lls
xa_erase(), blindly deleting the pre-existing valid entry and corrupting KV=
M's
tracking of an active VM.

[ ... ]

> +int vgic_v5_vmte_release(struct kvm *kvm)
> +{

[Severity: High]
Are there early return paths in this function (such as when freeing LPI or
SPI IST structures) that bypass critical cleanup steps?

If freeing the IST structures fails and returns an error early, it bypasses
the rest of the teardown logic. It fails to free the vped_ptrs, vpet_base,
and vmd_base allocations, and skips calling vgic_v5_reset_vmte(). This leav=
es
the hardware state active and permanently leaks memory.

[ ... ]

> +int vgic_v5_vmte_free_vpe(struct kvm_vcpu *vcpu)
> +{

[ ... ]

> +	vpet_base =3D vmi->vpet_base;
> +	WRITE_ONCE(vpet_base[vpe_id], 0ULL);
> +
> +	vgic_v5_clean_inval(vpet_base + vpe_id, sizeof(vpe_entry));

[Severity: High]
Does this sequence need a cache invalidation before the write to avoid false
sharing corruption?

If the CPU holds a stale, clean copy of this cache line, the WRITE_ONCE()
dirties it without fetching the latest hardware state from RAM. The subsequ=
ent
cache flush writes this stale line back to memory, destroying concurrent
hardware modifications to other VPE entries sharing the same cache line.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260724104819.1296=
803-1-sascha.bischoff@arm.com?part=3D9
