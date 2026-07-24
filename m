Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24D6443A7FD;
	Fri, 24 Jul 2026 11:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784892052; cv=none; b=fQz0KKVRBfBAODklAComBfIGXmp/0JBm/GcpuXWi2tdORt3bEO8QtS9I8HyVrCY8KXQbFAOU+rkaCIU5lG5C9v5vcYmp1cxd/rzsEkbfCsUse/8aMGXpXGdtE/10SlN3pgUj9YmJSSD31El9jP5gOdKWL9MVO3ZXA4mzsH9/XfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784892052; c=relaxed/simple;
	bh=WMnVvo5Gc3X6xtYHcxzsK80e6FGl5/HVAeX6JVSGA+U=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=uaIrAridbE66wIUh28AKxKJ+Ir2la9Fn1kpLS8cu7GIq7O0RrlZSa1kubboNwC0v105FMmL2XZ/YrW/TCgR4gHgAmgYYEOzGq+/AeDDMM+7BuHLzEQrpy8ZqBK7aXSdxWDQAq3fhGjEeBPQmDyFu/51Bgsuj8IqnRYFJuOB1xQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OwFP0irU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OwFP0irU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7144B1F000E9;
	Fri, 24 Jul 2026 11:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784892036;
	bh=Ovw5ioB9tMqBaMPM+lD4stOgJhlv8vszZzm45gSAWKI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OwFP0irU6QSLHfpQBhaAfLQ7Nj3Dbio8CLW3kmJ88cDgiEHevGQJ6jDxEvvsFZ5hT
	 5Zwq8peyv7EWPEgsUGjorj/CC6FeBFqxGRiNLFX0H7H+Y3FTr9U0bgnYWpeiVuoA1r
	 541/0o6ALg9u82K54jchedXWhI71AENtZuPhiXKu3SkDFlsRKYLsYDXpNeuUfHOFX1
	 gTQ/GkBWp7iyqOH1daCjtKWEq2mMWU3XnBVeF+42qtu9zD4Yw0ZNcPYv59Eih1dUXg
	 EAMKbeC7+7DdGGUq7nmsUoV2ZFr+3GO/ouxUzfDglzdAusPQh6+mKxcncA31a63JAk
	 Wpnr15Vsq3JtA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 11/48] KVM: arm64: gic-v5: Implement VMT/vIST IRS
 MMIO Ops
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvm@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260724104819.1296803-12-sascha.bischoff@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
 <20260724104819.1296803-12-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 24 Jul 2026 11:20:35 +0000
Message-Id: <20260724112036.7144B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 6 potential issue(=
s) to consider:
- [Critical] Timeout of IRS MMIO commands leads to hardware Use-After-Free =
for IST/VMTE memory.
- [Critical] Cache line false sharing on non-coherent GICv5 VMT causes sile=
nt memory corruption.
- [Critical] Unsafe use of kzalloc for hardware data structures requiring s=
trict alignment.
- [High] Missing wait for idle before writing to IRS VMT configuration regi=
sters.
- [High] GICv5 probe fails systematically across kexec because it rejects a=
n already valid VMT base register.
- [Medium] The newly allocated VMT is leaked if vgic_v5_irs_assign_vmt() re=
turns -EBUSY and vgic_v5_irs_clear_vmt() fails.
--

--- Patch [11]: [PATCH v4 11/48] KVM: arm64: gic-v5: Implement VMT/vIST IRS=
 MMIO Ops ---
commit ef6f1e2217f9b0055cd57ec9bca6826104eed2cf
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: arm64: gic-v5: Implement VMT/vIST IRS MMIO Ops

This commit adds support for making level 1 VMTs valid, allowing dynamic
level 2 array allocation. It also implements IRS MMIO operations for
making VMs and ISTs valid or invalid.

> --- a/arch/arm64/kvm/vgic/vgic-v5-tables.c
> +++ b/arch/arm64/kvm/vgic/vgic-v5-tables.c

[ ... ]

> @@ -730,8 +738,13 @@ static int vgic_v5_vmte_assign_ist(struct kvm *kvm, =
phys_addr_t ist_base,
>  	/* Finally, mark the entry as valid */
>  	cmd =3D spi_ist ? SPI_VIST_MAKE_VALID : LPI_VIST_MAKE_VALID;
>  	ret =3D irq_set_vcpu_affinity(vgic_v5_vpe_db(vcpu0), &cmd);
> +	if (ret) {
> +		WRITE_ONCE(vmte->val[section], 0ULL);
> +		vgic_v5_clean_inval(vmte, sizeof(*vmte));
> +		return ret;
> +	}
> =20
> -	return ret;
> +	return 0;
>  }

[Severity: Critical]
If the IRS MMIO command times out and returns an error here, KVM zeroes the
VMTE and the caller frees the IST memory. Is it possible that the hardware
IRS is still processing the delayed command?

If the hardware eventually completes the command, it might use the physical
address KVM just freed, potentially causing a Use-After-Free DMA by writing
to the freed memory.

[Severity: Critical]
Could there be a false-sharing issue leading to memory corruption on
non-coherent GICv5 VMT systems?

The vmtl2_entry structure is 32 bytes:

arch/arm64/kvm/vgic/vgic-v5-tables.h:
    struct vmtl2_entry {
        __le64 val[4];
    };

When modifying a VMTE, the cache line is flushed:

arch/arm64/kvm/vgic/vgic-v5-tables.c:vgic_v5_clean_inval() {
    ...
    if (kvm_vgic_global_state.vgic_v5_irs_caps.non_coherent)
        dcache_clean_inval_poc(base, base + size);
}

Since ARM64 cache lines are at least 64 bytes, multiple VMTEs share a single
cache line. If the CPU writes back this dirty cache line, won't it overwrite
any concurrent updates the IRS made directly to adjacent VMTEs in main memo=
ry?

[Severity: Critical]
Are the alignment requirements for hardware data structures guaranteed when
using kzalloc()?

In vgic_v5_vmte_init(), vmd is allocated with kzalloc() and its physical
address is bit-shifted:

arch/arm64/kvm/vgic/vgic-v5-tables.c:vgic_v5_vmte_init() {
    ...
    vmd =3D kzalloc(vmt_info->vmd_size, GFP_KERNEL);
    ...
    tmp =3D FIELD_PREP(GICV5_VMTEL2E_VMD_ADDR,
                     virt_to_phys(vmd) >> GICV5_VMTEL2E_VMD_ADDR_SHIFT);
    ...
}

Since kzalloc() only guarantees natural alignment, shifting the address rig=
ht
by GICV5_VMTEL2E_VMD_ADDR_SHIFT could truncate the lower bits if the
allocation isn't perfectly aligned to 1 << SHIFT. Could this lead to the
hardware accessing the wrong memory location?

> --- a/arch/arm64/kvm/vgic/vgic-v5.c
> +++ b/arch/arm64/kvm/vgic/vgic-v5.c

[ ... ]

> @@ -105,13 +131,55 @@ int vgic_v5_probe(const struct gic_kvm_info *info)

[ ... ]

> +	ret =3D vgic_v5_irs_assign_vmt(irs_caps.two_level_vmt_support,
> +				     ilog2(irs_caps.max_vms),
> +				     vgic_v5_get_vmt_base());
> +	if (ret) {
> +		kvm_err("Failed to assign the GICv5 VM tables to the IRS; no GICv5 sup=
port\n");
> +		if (!vgic_v5_irs_clear_vmt())
> +			vgic_v5_vmt_free();
> +		return -ENODEV;
> +	}

[Severity: Medium]
If vgic_v5_irs_assign_vmt() returns -EBUSY and vgic_v5_irs_clear_vmt() fail=
s,
this skips calling vgic_v5_vmt_free().

Since vgic_v5_irs_assign_vmt() returns -EBUSY when the hardware VMT_BASER is
already valid (holding a pointer to the old VMT), doesn't skipping the free
here leak the newly allocated VMT?

[ ... ]

> @@ -153,18 +222,136 @@ int vgic_v5_probe(const struct gic_kvm_info *info)

[ ... ]

> +static int vgic_v5_irs_assign_vmt(bool two_level, u8 vm_id_bits,
> +				  phys_addr_t vmt_base)
> +{
> +	u64 vmt_baser;
> +	u32 vmt_cfgr;
> +
> +	guard(raw_spinlock_irqsave)(&global_irs_lock);
> +
> +	vmt_baser =3D irs_readq_relaxed(GICV5_IRS_VMT_BASER);
> +	if (!!FIELD_GET(GICV5_IRS_VMT_BASER_VALID, vmt_baser))
> +		return -EBUSY;

[Severity: High]
During a kexec, KVM does not clear this register on shutdown, so the
GICV5_IRS_VMT_BASER_VALID bit may already be set by the previous kernel.

Will vgic_v5_probe() systematically fail and permanently disable GICv5 on
kexec because it aborts instead of clearing the old VMT?

> +	vmt_cfgr =3D FIELD_PREP(GICV5_IRS_VMT_CFGR_VM_ID_BITS, vm_id_bits);
> +	if (two_level)
> +		vmt_cfgr |=3D FIELD_PREP(GICV5_IRS_VMT_CFGR_STRUCTURE,
> +				       GICV5_IRS_VMT_CFGR_STRUCTURE_TWO_LEVEL);
> +
> +	irs_writel_relaxed(vmt_cfgr, GICV5_IRS_VMT_CFGR);

[Severity: High]
Should this function call vgic_v5_irs_wait_for_vm_op() to poll for the IRS
to be idle before writing directly to GICV5_IRS_VMT_CFGR?

Other IRS writer functions enforce an idle check before writing. If the IRS
is busy processing an operation, could this direct write corrupt the hardwa=
re
state?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260724104819.1296=
803-1-sascha.bischoff@arm.com?part=3D11
