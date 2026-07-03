Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46B933090E2;
	Fri,  3 Jul 2026 16:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783096491; cv=none; b=fsuT7lZrRxX2lGKSI9ro/Q3dJ6ZJmuNzFLtz5fGCextXVwXShJGi59XfewUURigQsMXZcov5vYzWOmJjfXHcZBpPHkA0JXeKHm9K1doam/PoETMb3j1gHdDApaVYmB1R2v+LPp1nhW3Hb6OaTaBejLaem5Mo2TBfT3NUKtiDawI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783096491; c=relaxed/simple;
	bh=4csHR21vEsV5Ir5HMnwKLkXsIcEWPNM8ohMaydDmQQs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=gqTJEbgEi6CgsxYeFvmO3vLaqz4qle53Qo1oYA1+k5TST5GxcWj3eVSIcTltZWhYouwp3icIrOtmDClZLLf84+fd4IOeT0/R2Eq79sFYSCvY4s9Kg8MuvkDtzp00DrcqvVxbP0Q0qyGerwf3P5uEIzTefD7ZA5XMUeeD4wBR0z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RTRD8jVv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RTRD8jVv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9546F1F000E9;
	Fri,  3 Jul 2026 16:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783096489;
	bh=tIyAKiYoe3pGFnKQJwbfFwQizmyNbZJmsTlf8OFsSZE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RTRD8jVvApdNTLQ726ecsDZY/hFaAYS1YWSjOn8fR0PwXyIJh9why6zV3b0JSvZVa
	 xDCTOrkSWLRSpWNU5JQBF0TyLFn+hwsSeYhSUVUCluwI4WccKkuez7hJTZwlTNDaRA
	 m3E5a+eiOfS/fE9dbs2DuHlYvSXH9VnI2G5Lier0bx0Ii0nGFt3RECHf4CXb4XI6Ib
	 jWMR2VtdVpQwS0sj2XD4h69VUf0USG2PfprSRGGk09ZMkSDKejr6Fp1tDlYDdDEv3H
	 IJTXpsOi63b8Z7zSip9gMWMIaC3Af/bYvYlLuMeT4xU/mFD6D/hEXDJASalmr81Z7y
	 CyieKnDFjX8gA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 10/40] KVM: arm64: gic-v5: Introduce guest IST alloc
 and management
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260703154811.3355680-11-sascha.bischoff@arm.com>
References: <20260703154811.3355680-1-sascha.bischoff@arm.com>
 <20260703154811.3355680-11-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 16:34:49 +0000
Message-Id: <20260703163449.9546F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Integer truncation of IST allocation size causes zero-sized alloca=
tions and hardware memory corruption.
- [Low] Endianness type mismatch when parsing VMTE state using `FIELD_GET()=
`.
--

commit 1bc57da799f1125b47ee47d0156802cc04200696
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: arm64: gic-v5: Introduce guest IST alloc and management

GICv5 guests use Interrupt State Tables (ISTs) to track and manage the
interrupt state for SPIs and LPIs. This commit provisions memory for
managing a guest's SPI state and shadow LPI ISTs passed to the host IRS.

> diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.c b/arch/arm64/kvm/vgic/v=
gic-v5-tables.c
> index db8cb6a384994..79b305d2d5097 100644
> --- a/arch/arm64/kvm/vgic/vgic-v5-tables.c
> +++ b/arch/arm64/kvm/vgic/vgic-v5-tables.c

[ ... ]

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
> +	ist =3D kzalloc(l1sz, GFP_KERNEL_ACCOUNT);

[Severity: High]
Can this cause integer truncation and zero-sized allocations if a guest
requests a large LPI ID space?

In vgic_v5_alloc_linear_ist(), the allocation size is calculated as BIT(n +=
 1)
and stored in a 32-bit u32 l1sz. The value n is derived from id_bits + 1 +
istsz. If a guest requests a large LPI ID space (e.g., id_bits =3D 31) on a
system that falls back to linear ISTs, n evaluates to 34.

BIT(35) evaluates to a 64-bit value that is silently truncated to 0 when
assigned to l1sz. The subsequent kzalloc(0) succeeds but returns
ZERO_SIZE_PTR. KVM then blindly passes the invalid pseudo-physical address =
to
the hardware VMTE, which can lead to severe host memory corruption or IOMMU
faults when the hardware routes virtual interrupts.

[ ... ]

> +static int vgic_v5_two_level_ist_free(struct kvm *kvm, bool spi)
> +{
> +	unsigned int id_bits, istsz, l2sz;
> +	u32 vm_id =3D vgic_v5_vm_id(kvm);
> +	struct vgic_v5_vm_info *vmi;
> +	struct vmtl2_entry *vmte;
> +	__le64 tmp;
> +	int section;
> +
> +	/* We don't create two-level SPI ISTs, so freeing is a bad idea! */
> +	if (spi)
> +		return -EINVAL;
> +
> +	vmi =3D xa_load(&vm_info, vm_id);
> +	if (!vmi)
> +		return -EINVAL;
> +
> +	section =3D GICV5_VMTEL2_LPI_SECTION;
> +
> +	if (!vmi->h_lpi_ist_structure)
> +		return -EINVAL;
> +
> +	vmte =3D vgic_v5_get_l2_vmte(vm_id);
> +	if (IS_ERR(vmte))
> +		return PTR_ERR(vmte);
> +
> +	tmp =3D le64_to_cpu(READ_ONCE(vmte->val[section]));
> +
> +	id_bits =3D FIELD_GET(GICV5_VMTEL2E_IST_ID_BITS, tmp);

[Severity: Low]
This isn't a bug, but does this cause sparse warnings due to an endianness
type mismatch?

In vgic_v5_two_level_ist_free(), le64_to_cpu() is used to convert the VMTE
entry to native endianness. However, the result is assigned to tmp, which is
declared as __le64. The native value is then passed into FIELD_GET(), which
expects a native unsigned integer type. While this compiles and functions
identically to u64 because __le64 is internally an unsigned 64-bit integer,
it breaks endianness semantic contracts.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703154811.3355=
680-1-sascha.bischoff@arm.com?part=3D10
