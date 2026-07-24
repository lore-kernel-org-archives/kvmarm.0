Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3141F3E5EF8;
	Fri, 24 Jul 2026 11:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784892162; cv=none; b=KJqMj29OFjDuqKIm2XeqiRHOpi0e/mKFzNBo3fzaTOOwN8mhSwT3f4o78ClpucajlrG9lytuLJaDrBktVD/Gst7FKptlenGWRNWuMFvzhiI1tcCzpGfr0PGU/kNK2DtqzNADeROroxGA3MEVo1xJY5vl8Y8+tqKkOOltzrSJVl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784892162; c=relaxed/simple;
	bh=T5NoPh997PFaeaJEGEZH1DeNsteLq5sRvrWPios7rY0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=axJnh9oTUwxsiik7Aai25HREp11xImL/bA32b37Q3eeLsCc9XFCPtxkYuuMwSXtyh2XRN6QSTp905fcCE9GY6p0SKcy1E4SUmlN9Chucx24vYktlalwzPfGu3Zc7bMpp0MJcht3dEjmAe08ZYhxzAJf+SOGsQw59dqxHxBR0gSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GjAuckK2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GjAuckK2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FD981F000E9;
	Fri, 24 Jul 2026 11:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784892160;
	bh=3vfsYiMAs8CeC67x5zhV4ZNlIfG+tia7+KTAYhHWj0Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GjAuckK2942XcRdPnY/AqkM8WUKbETZfHVJwl79aH4DPj4zh4dDOki7k9hveUnFcB
	 hHgjLn5P/ua/9NiA4jC4bvmTayiZtHJT0bE/q/S/sszjgUpcJNTkYrsoWqYy1C/Skm
	 qqLfxu6TSzHWFeIRpAUi2I5boxNSMUQB/JOnEdBIWtWQdHA0mxyann1JhnjRbE4Cmr
	 KiDe2JPxww2OtmlZJBSR9rLijCurvOnVR7C+H13D4Sd2bCifW0++6HOd1FC25tBcAM
	 KHiMplaNSECdXuk0AR2j9sPYKjqtQkcC2QNBQgY/uUKuZHlFBYQunnfn4FsLKe4UE/
	 ZhAG0vdZayWSg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 10/48] KVM: arm64: gic-v5: Introduce guest IST alloc
 and management
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260724104819.1296803-11-sascha.bischoff@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
 <20260724104819.1296803-11-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 24 Jul 2026 11:22:39 +0000
Message-Id: <20260724112240.4FD981F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 7 potential issue(=
s) to consider:
- [Critical] Missing hardware invalidation commands allow DMA Use-After-Fre=
e.
- [Critical] Integer truncation in `l1sz` calculation leads to zero-sized I=
ST allocation and host memory corruption.
- [High] VPE descriptor pointer is published to hardware before its initial=
ization is visible.
- [High] Null pointer dereference of `vcpu0` in `vgic_v5_vmte_assign_ist`.
- [High] Missing `GICV5_VMTEL2E_IST_VALID` bit leaves IST configurations in=
valid.
- [High] Unsafe DMA buffer allocations using `kzalloc()` cause cacheline sh=
aring and lost hardware updates.
- [Medium] Missing `WRITE_ONCE` when zeroing the hardware-shared VMTE entry.
--

--- Patch [10]: [PATCH v4 10/48] KVM: arm64: gic-v5: Introduce guest IST al=
loc and management ---
commit 014722137813a4073b0da36f6aceff4c3e396990
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: arm64: gic-v5: Introduce guest IST alloc and management

GICv5 guests use Interrupt State Tables (ISTs) to track and manage the
interrupt state for SPIs and LPIs. These ISTs are provided to the host's
IRS via the VMTE.

> diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.c b/arch/arm64/kvm/vgic/v=
gic-v5-tables.c
> index 22cd03e0f1963..aa737972f525c 100644
> --- a/arch/arm64/kvm/vgic/vgic-v5-tables.c
> +++ b/arch/arm64/kvm/vgic/vgic-v5-tables.c

[ ... ]

> @@ -628,3 +671,500 @@ int vgic_v5_vmte_free_vpe(struct kvm_vcpu *vcpu)
> =20
>  	return 0;
>  }
> +
> +/*
> + * Assign an already allocated IST to the VM by populating the fields in=
 the
> + * corresponding VMTE. We re-use this code for both an SPI IST and LPI I=
ST, even
> + * if the paths to reach it might be vastly different.
> + */
> +static int vgic_v5_vmte_assign_ist(struct kvm *kvm, phys_addr_t ist_base,
> +				   bool two_level, unsigned int id_bits,
> +				   unsigned int l2sz, unsigned int istsz,
> +				   bool spi_ist)
> +{
> +	struct kvm_vcpu *vcpu0 =3D kvm_get_vcpu(kvm, 0);

[Severity: High]
Could kvm_get_vcpu(kvm, 0) return NULL here if userspace performs VGIC
initialization operations before any vCPUs have been created?

> +	u32 vm_id =3D vgic_v5_vm_id(kvm);
> +	enum gicv5_vcpu_cmd cmd;
> +	struct vmtl2_entry *vmte;
> +	unsigned int section;
> +	u64 tmp;
> +	int ret;

[ ... ]

> +	tmp =3D FIELD_PREP(GICV5_VMTEL2E_IST_L2SZ, l2sz);
> +	tmp |=3D FIELD_PREP(GICV5_VMTEL2E_IST_ADDR,
> +			ist_base >> GICV5_VMTEL2E_IST_ADDR_SHIFT);
> +	tmp |=3D FIELD_PREP(GICV5_VMTEL2E_IST_ISTSZ, istsz);
> +	tmp |=3D FIELD_PREP(GICV5_VMTEL2E_IST_ID_BITS, id_bits);
> +	if (two_level)
> +		tmp |=3D GICV5_VMTEL2E_IST_STRUCTURE;
> +
> +	WRITE_ONCE(vmte->val[section], cpu_to_le64(tmp));

[Severity: High]
Is the GICV5_VMTEL2E_IST_VALID bit missing when constructing this IST entry?

It appears the valid bit is never set in tmp before it is written to the VM=
TE,
which might leave the configuration architecturally invalid and break inter=
rupt
routing.

> +	vgic_v5_clean_inval(vmte, sizeof(*vmte));
> +
> +	/* Finally, mark the entry as valid */
> +	cmd =3D spi_ist ? SPI_VIST_MAKE_VALID : LPI_VIST_MAKE_VALID;
> +	ret =3D irq_set_vcpu_affinity(vgic_v5_vpe_db(vcpu0), &cmd);

[Severity: High]
If kvm_get_vcpu(kvm, 0) returned NULL above, does passing it directly to
vgic_v5_vpe_db() here cause a NULL pointer dereference?

> +
> +	return ret;
> +}
> +
> +/*
> + * Allocate a Linear IST - always used for SPIs and potentially LPIs.
> + *
> + * The calculation for n has been taken from section 11.2.2 of the GICv5=
 EAC0
> + * spec.
> + *
> + * NOTE: istsz is the FIELD used by GICv5, not the actual size (or log2(=
) of the
> + * size).
> + */
> +static int vgic_v5_alloc_linear_ist(struct kvm *kvm, bool spi_ist,
> +				    unsigned int id_bits, unsigned int istsz)
> +{
> +	const size_t n =3D id_bits + 1 + istsz;
> +	u32 vm_id =3D vgic_v5_vm_id(kvm);
> +	struct vgic_v5_vm_info *vmi;
> +	__le64 *ist;
> +	u32 l1sz;
> +
> +	vmi =3D xa_load(&vm_info, vm_id);
> +	if (!vmi)
> +		return -EINVAL;
> +
> +	/*
> +	 * Allocate the IST. We only have one level, so we just use the L2 ISTE.
> +	 */
> +	l1sz =3D BIT(n + 1);

[Severity: Critical]
Could the 32-bit truncation of l1sz evaluate to zero for large values of n
(such as when a guest requests a large LPI ID space)?

If n + 1 >=3D 32, the 64-bit BIT() macro result will be truncated to exactl=
y 0
when assigned to the u32 l1sz. This would result in a zero-sized allocation
that returns ZERO_SIZE_PTR, potentially leading to host memory corruption.

> +	ist =3D kzalloc(l1sz, GFP_KERNEL_ACCOUNT);

[Severity: High]
Is this memory structure modified by the non-coherent GIC hardware?

If so, does allocating it with kzalloc() risk cacheline sharing with adjace=
nt
slab objects, potentially causing lost hardware updates during CPU cache
eviction?

[ ... ]

> +/*
> + * Free a Linear IST. Can only happen once the VM is dead.
> + */
> +static int vgic_v5_linear_ist_free(struct kvm *kvm, bool spi)
> +{

[ ... ]

> +	/* The VM should be dead here, so we can just zero the VMT section */
> +	vmte->val[section] =3D cpu_to_le64(0);

[Severity: Critical]
Does freeing the backing memory and zeroing the VMTE without first issuing
hardware invalidation commands allow the hardware to continue DMAing into
freed slab objects?

[Severity: Medium]
Additionally, since this is a hardware-shared data structure, does clearing
the VMTE entry with a plain assignment risk store tearing? Should this use
WRITE_ONCE() to ensure an atomic 64-bit write?

> +	vgic_v5_clean_inval(vmte, sizeof(*vmte));
> +
> +	return 0;
> +}
> +
> +/*
> + * Free a Two-Level IST. Can only happen once the VM is dead.
> + */
> +static int vgic_v5_two_level_ist_free(struct kvm *kvm, bool spi)
> +{

[ ... ]

> +	/* The VM must be dead, so we can just zero the VMT section */
> +	vmte->val[section] =3D cpu_to_le64(0);

[Severity: Critical]
Does freeing the backing memory and zeroing the VMTE without first issuing
hardware invalidation commands allow the hardware to continue DMAing into
freed slab objects?

[Severity: Medium]
Similarly, does clearing the VMTE entry with a plain assignment risk store
tearing here?

> +	vgic_v5_clean_inval(vmte, sizeof(*vmte));
> +
> +	return 0;
> +}

Looking at vgic_v5_vmte_alloc_vpe() from the broader context of this file:

vgic_v5_vmte_alloc_vpe() {
    ...
    vped =3D kzalloc(vmt_info->vped_size, GFP_KERNEL);
    ...
    tmp =3D FIELD_PREP(GICV5_VPED_ADDR, virt_to_phys(vped) >> GICV5_VPED_AD=
DR_SHIFT);
    WRITE_ONCE(vpet_base[vpe_id], cpu_to_le64(tmp));

    vgic_v5_clean_inval(vped, vmt_info->vped_size);
    ...
}

[Severity: High]
Is it possible for the hardware to observe the VPE descriptor pointer before
the zeroed memory of the descriptor is flushed to the Point of Coherency?

If a CPU cache eviction writes the pointer to main memory before the cache
clean, non-coherent hardware might consume uninitialized memory.

[Severity: High]
Additionally, since vped is allocated with kzalloc(), does this risk cachel=
ine
sharing with adjacent objects, potentially leading to lost hardware updates?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260724104819.1296=
803-1-sascha.bischoff@arm.com?part=3D10
