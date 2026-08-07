Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F9B4766A5;
	Fri,  7 Aug 2026 13:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786108089; cv=none; b=hUfafCPCI9n/5X131ac4jppUOcE1cZslop8REL+CzHGhtpgS9rs6RFicgq/wLBZCUK9U116URJnIVI8VADWt9iR4FDt6Ygv2Q+4og8m4rm8qN85SsjQKI1TDQ32oClae7de5isFG/wgUL5btoGF/XN3qJ0Hpx2KHlisDnVGaoMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786108089; c=relaxed/simple;
	bh=8Jc5DeX31k+DtFp0tnkz8x080ly4zvn1OzvmoLkrUV8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=jd1RLEdRN9IaoE8wwJs/dwwWaw1RxpXZ6exWESYSyVsFWfH+dh3FYcJfwvu/wQlC03gWQjNtjBEHZIYkvz5yEN19kN7YrUO4oQq1IWhwS92QwzsYl8I3HGm/Yd/23/128zwp87of4AaXQKE2o0K3qgk7AOkz7xsPHt6w75f79kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V9M/9Bw0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V9M/9Bw0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E3A41F00A3D;
	Fri,  7 Aug 2026 13:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786108073;
	bh=yf6npyemkd7IcvWnqdAfDHI/t9DnhIgiZz4NZSxE7A8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=V9M/9Bw0SXfLHEPwAd+zbfXWKyx0WukuQG7UTg9EQsE2uzCwU3xO19sCUxi/3oLVY
	 D74HeP3WEDctkOxR0KcWAT6+vtCxFriPEtTYl0PRZ/JQ0b6scV6qGZo3w1JLOSXzX3
	 DzUr8GQCrO9yeAPrWf6kJAThtRu7NwMnk5GBPD5GRfRwnznSxmAzBXECi3lmzjQhGW
	 cHgSeDTM2k36uc17hKqIeaOKYzPdFFQZCmjz4C/Oel2OiRz8ztYnul8IzFXxOYNWT8
	 P3e7ZHMvDY0KAh41BOvl6YGOS6qiUmkrxYCldp4EEbsH5qWP3DnAKiXq/6Ci05BnFU
	 MJCcUSLSK1D8A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 10/49] KVM: arm64: gic-v5: Introduce guest IST alloc
 and management
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org
In-Reply-To: <20260807111159.429128-11-sascha.bischoff@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
 <20260807111159.429128-11-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 07 Aug 2026 13:07:52 +0000
Message-Id: <20260807130753.3E3A41F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 6 potential issue(=
s) to consider:

New issues:
- [Critical] Hardware Use-After-Free (UAF) due to missing IRS invalidation =
command during LPI IST teardown.
- [Critical] Integer truncation in `vgic_v5_alloc_linear_ist` causes ZERO_S=
IZE_PTR allocation and silent memory corruption.
- [High] Unconditional NULL pointer dereference of `vcpu0` during IST assig=
nment.
- [High] Silent physical address truncation in L2 IST allocation due to unv=
alidated masking.
- [Medium] Permanent memory leak of VM resources due to early aborts in `vg=
ic_v5_vmte_release`.

Pre-existing issues:
- [High] Missing DSB barrier after cache maintenance allows the hardware IR=
S to read stale VMTE data.
--

--- Patch [10]: [PATCH v5 10/49] KVM: arm64: gic-v5: Introduce guest IST al=
loc and management ---
commit 4b81b458fb30bd2b57a30edcbe23a8f8de22edbb
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>
Date:   Fri Aug 7 11:17:41 2026 +0000

    KVM: arm64: gic-v5: Introduce guest IST alloc and management

GICv5 guests use Interrupt State Tables (ISTs) to track and manage the
interrupt state for SPIs and LPIs. This commit introduces the machinery
needed to allocate a linear SPI IST and a shadow LPI IST, and pass them
to the host's IRS via the VMTE.

> diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.c b/arch/arm64/kvm/vgic/v=
gic-v5-tables.c
> index 7252d48431a5a..f088006f39674 100644
> --- a/arch/arm64/kvm/vgic/vgic-v5-tables.c
> +++ b/arch/arm64/kvm/vgic/vgic-v5-tables.c
[ ... ]
> @@ -581,6 +608,22 @@ int vgic_v5_vmte_release(struct kvm *kvm)
>  	if (!vmi)
>  		goto no_vmi;
> =20
> +	/* If we have an LPI IST, free it */
> +	if (vmi->h_lpi_ist) {
> +		ret =3D vgic_v5_lpi_ist_free(kvm);
> +		if (ret)
> +			return ret;

[Severity: Medium]
What happens to the remaining allocated resources if this returns early?

If vgic_v5_lpi_ist_free() returns an error, the function aborts immediately.
This bypasses the release of vped_base, vpet_base, and vmd_base, and skips
removing the entry from vm_info, permanently leaking these VM resources.

> +	}
> +	vmi->h_lpi_ist =3D NULL;
> +
> +	/* If we have an SPI IST, free it */
> +	if (vmi->h_spi_ist) {
> +		ret =3D vgic_v5_spi_ist_free(kvm);
> +		if (ret)
> +			return ret;

[Severity: Medium]
Similarly, could an error here leak the same resources?

> +	}
> +	vmi->h_spi_ist =3D NULL;
[ ... ]
> @@ -679,3 +722,511 @@ int vgic_v5_vmte_free_vpe(struct kvm_vcpu *vcpu)
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
[ ... ]
> +	scoped_guard(raw_spinlock_irqsave, &vgic_v5_irs_lock) {
> +		/* Bail if already allocated */
> +		vgic_v5_clean_inval(vmte, sizeof(*vmte));
> +		if (le64_to_cpu(READ_ONCE(vmte->val[section])) &
> +		    GICV5_VMTEL2E_IST_VALID)
> +			return -EINVAL;
> +
> +		WRITE_ONCE(vmte->val[section], cpu_to_le64(tmp));
> +		vgic_v5_clean_inval(vmte, sizeof(*vmte));
> +	}
> +
> +	/* Finally, mark the entry as valid */
> +	cmd =3D spi_ist ? SPI_VIST_MAKE_VALID : LPI_VIST_MAKE_VALID;
> +	ret =3D irq_set_vcpu_affinity(vgic_v5_vpe_db(vcpu0), &cmd);

[Severity: High]
What happens if vcpu0 is NULL?=20

Userspace can invoke KVM VGIC initialization ioctls before any VCPUs are
created (where kvm->online_vcpus is 0). In this state, kvm_get_vcpu() retur=
ns
NULL. When vgic_v5_vpe_db() attempts to dereference vcpu0 to get the doorbe=
ll
address, it would cause a host kernel panic.

[Severity: High]
This is a pre-existing issue, but does vgic_v5_clean_inval() require a barr=
ier
to guarantee completion?

The vgic_v5_clean_inval() function calls dcache_clean_inval_poc() to flush
caches for a non-coherent IRS. However, it lacks a trailing dsb(sy) or dsb(=
ish)
barrier. Because of this, the memory-mapped write to the doorbell in
irq_set_vcpu_affinity() might execute before the cache flush completes,
allowing the IRS hardware to read stale VMTE data.

> +
> +	return ret;
> +}
[ ... ]
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
> +	const size_t n =3D max(5, id_bits + 1 + istsz);
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
Can l1sz overflow and truncate to zero?

If a guest requests a large LPI ID space (e.g., id_bits =3D 30), n can reac=
h 32.
BIT(33) evaluates to 8,589,934,592, which truncates to exactly 0 when assig=
ned
to the 32-bit u32 l1sz variable.

> +	ist =3D kzalloc(l1sz, GFP_KERNEL_ACCOUNT);

When kzalloc() is called with a size of 0, it returns ZERO_SIZE_PTR (0x10).
KVM will then translate this via virt_to_phys() and program the bogus physi=
cal
address into the hardware's VMTE. The IRS will perform DMA to this address,
leading to host memory corruption.

> +	if (!ist)
> +		return -ENOMEM;
[ ... ]
> +/*
> + * Allocate ALL of the second level ISTs for a two-level IST - LPI, only.
> + *
> + * The calculation for n has been taken from section 11.2.2 of the GICv5=
 EAC0
> + * spec. The l2_size calculation is from section 11.2.3 of the same docu=
ment.
> + *
> + * NOTE: istsz and l2sz are the FIELDS used by GICv5, not the actual siz=
es (or
> + * log2() of the sizes).
> + */
> +static int vgic_v5_alloc_l2_ists(struct kvm *kvm, unsigned int id_bits,
> +				 unsigned int istsz, unsigned int l2sz)
> +{
[ ... ]
> +		/*
> +		 * We are not doing on-demand allocation of the L2 ISTs, and are
> +		 * instead provisioning the whole IST up front. This means that
> +		 * we are able to mark the L2 ISTs as valid in the L1 ISTEs as
> +		 * the overall IST is not yet valid.
> +		 */
> +		val =3D (virt_to_phys(l2ist) & GICV5_ISTL1E_L2_ADDR_MASK) |
> +		      GICV5_ISTL1E_VALID;

[Severity: High]
Is it possible for virt_to_phys(l2ist) to have bits above the
GICV5_ISTL1E_L2_ADDR_MASK?

Unlike vgic_v5_vmte_assign_ist() which checks if the address fits the hardw=
are
mask, this function unconditionally applies a bitwise AND. On systems with
LVA/LPA (up to 52-bit PAs), if the allocated page resides above the bits
covered by the mask, the upper bits are silently truncated. The IRS would t=
hen
write incoming LPI states to an aliased, incorrect physical memory address.

> +		l1ist[index] =3D cpu_to_le64(val);
> +
> +		vmi->h_lpi_l2_ists[index] =3D l2ist;
> +
> +		vgic_v5_clean_inval(l2ist, l2_size);
> +	}
[ ... ]
> +/*
> + * Free a Linear IST. Can only happen once the VM is dead.
> + */
> +static int vgic_v5_linear_ist_free(struct kvm *kvm, bool spi)
> +{
> +	u32 vm_id =3D vgic_v5_vm_id(kvm);
> +	struct vmtl2_entry *vmte;
> +	struct vgic_v5_vm_info *vmi;
> +	int section;
[ ... ]
> +	if (spi) {
> +		section =3D GICV5_VMTEL2_SPI_SECTION;
> +		vgic_v5_free_allocated_spi_ist(kvm);
> +	} else {
> +		section =3D GICV5_VMTEL2_LPI_SECTION;
> +		vgic_v5_free_allocated_lpi_ist(vmi, 0, 0, 0);
> +	}
> +
> +	/* The VM should be dead here, so we can just zero the VMT section */
> +	scoped_guard(raw_spinlock_irqsave, &vgic_v5_irs_lock) {
> +		WRITE_ONCE(vmte->val[section], cpu_to_le64(0));
> +		vgic_v5_clean_inval(vmte, sizeof(*vmte));
> +	}

[Severity: Critical]
Does the hardware IRS need to be notified that the LPI IST is now invalid?

The memory is explicitly freed and the software VMTE is zeroed, but no
LPI_VIST_MAKE_INVALID command is sent to the IRS hardware. Because the hard=
ware
IRS is never notified, it will retain the physical address in its cache and
will continue to DMA incoming LPI state updates to the newly freed host mem=
ory
pages, leading to a Use-After-Free and host memory corruption.

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
> +	vgic_v5_free_allocated_lpi_ist(vmi, id_bits, istsz, l2sz);
> +
> +	/* The VM must be dead, so we can just zero the VMT section */
> +	scoped_guard(raw_spinlock_irqsave, &vgic_v5_irs_lock) {
> +		WRITE_ONCE(vmte->val[section], cpu_to_le64(0));
> +		vgic_v5_clean_inval(vmte, sizeof(*vmte));
> +	}

[Severity: Critical]
Similarly, does the two-level IST teardown also require an
LPI_VIST_MAKE_INVALID hardware command?

The LPI IST memory is freed and the VMTE is zeroed without sending the
invalidation command to the IRS, opening the same race window for hardware
Use-After-Free.

> +
> +	return 0;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260807111159.4291=
28-1-sascha.bischoff@arm.com?part=3D10
