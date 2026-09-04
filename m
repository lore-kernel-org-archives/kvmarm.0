Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7360F1FC0EA;
	Fri,  4 Sep 2026 12:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788525046; cv=none; b=ltJbQSlHGUosf/zNfR185PAO4wHhCqvPN0r4sX2Ox9DMz0VAzE9ifUkbKiV5CxmasguDAvuCuhpMTXKA9p5ELoq53HOCLlrkKRb2tduxVve+EC0E+Q/FHlrkr49ymfhOHHGoO7b+wHSsPNMzVPXGr7mDtBh2+nL0fNO5JWFnL2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788525046; c=relaxed/simple;
	bh=I4dONQeT+3uUQctSUds3N3GEumZBobJuky9CcdrmntQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Q8EowqowS37EkcFXMzKVqWDsGhZ2HG8RHRs1KKQqM+Xlzi9ctIb03lEbORkDnK7UkNWbs3i2VwB3sVT9x6F5fs9OLLfXFlZzVXNK/0aYoFDUhrpFQBHK9zJEAnoe2IhqjtAya07WAZJnQBmEtFHQKMwQKZidXC+oT/AqdpyEr/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jMAlS0dI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jMAlS0dI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D64931F00A3D;
	Fri,  4 Sep 2026 12:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788525045;
	bh=r76Md1r2sa9jbgvLRSl91g22lbxr4bctxjEUplgh9aA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jMAlS0dI3HyEHNcUlfnmWvK4Rw7yDcuOMCmvN3EfyIsGEDoILl425caUb4FilvSPY
	 /gi47Ni+Vumd2Ev7uumqmUzRqfIpMTqW7ZOAXrg7097OUUHyZ5x4mO1lZ7ZCPOP1gU
	 4d7hFynIYEfhe4Z5HmxU+ijA2y1VaFXdO5/xr0alsXex/HQI6C9reoL/0fZwVmYHL6
	 bDkPXtTmV6JfU+ZMo0IhLgD1MoKraPKR4+UNTHRyLMjxorLxcfrc4l/DDACUI9rYMB
	 Gn9wIW6Eoe1KLkjXJyXHeWNRAirLZdLiGSi6VXfvuuDie4zfUZWDJPnsBGhSMWjG5j
	 YLXwKzu9+qk5A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 10/49] KVM: arm64: gic-v5: Introduce guest IST alloc
 and management
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260904113404.4051341-11-sascha.bischoff@arm.com>
References: <20260904113404.4051341-1-sascha.bischoff@arm.com>
 <20260904113404.4051341-11-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 04 Sep 2026 12:30:44 +0000
Message-Id: <20260904123044.D64931F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Integer overflow in `l1sz` calculation causes a zero-size allocati=
on and subsequent kernel panic during cache maintenance.
- [High] DMA coherency cacheline-sharing bug in VMTE array causes the host =
CPU to overwrite and destroy hardware IRS updates.
--

commit 6ec34cb3226f9d34ed3b83ac3a0c85077a487f20
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: arm64: gic-v5: Introduce guest IST alloc and management

This commit introduces the machinery to allocate guest Interrupt State Tabl=
es
(ISTs) for SPIs and LPIs in KVM for ARM64 GICv5. It provides functions to
allocate linear and two-level ISTs, assign them to a VM via IRS doorbell
commands, and free them on VM teardown.

> diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.c b/arch/arm64/kvm/vgic/v=
gic-v5-tables.c
> index 7252d48431a5a..f088006f39674 100644
> --- a/arch/arm64/kvm/vgic/vgic-v5-tables.c
> +++ b/arch/arm64/kvm/vgic/vgic-v5-tables.c

[ ... ]

> @@ -679,3 +722,511 @@ int vgic_v5_vmte_free_vpe(struct kvm_vcpu *vcpu)

[ ... ]

> +static int vgic_v5_vmte_assign_ist(struct kvm *kvm, phys_addr_t ist_base,
> +				   bool two_level, unsigned int id_bits,
> +				   unsigned int l2sz, unsigned int istsz,
> +				   bool spi_ist)
> +{

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

[Severity: High]
Does this code inadvertently overwrite concurrent hardware IRS updates?

The struct vmtl2_entry is exactly 32 bytes (__le64 val[4]), meaning two
adjacent entries (e.g., vmte[0] and vmte[1]) share a single 64-byte CPU
cache line. Assigning an IST requires an IRS doorbell operation, which caus=
es
the IRS hardware to write the VALID bit into the VMTE in main memory.

If the host CPU concurrently writes to vmte[1] to configure another VM, the
entire shared cache line becomes dirty in the CPU's cache. When the host
executes vgic_v5_clean_inval() (dc civac), it writes back the entire
dirty cache line to main memory. If the CPU's cache holds a stale copy of
vmte[0] (without the VALID bit set by the IRS), this writeback will
overwrite and destroy the IRS's update to vmte[0].

Should struct vmtl2_entry be padded and aligned to SMP_CACHE_BYTES to
prevent this false-sharing writeback corruption?

> +	}

[ ... ]

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
> +	ist =3D kzalloc(l1sz, GFP_KERNEL_ACCOUNT);

[Severity: High]
Can this calculation overflow l1sz and cause a zero-size allocation?

If the hardware IRS reports support for a large LPI ID space (e.g., 32 bits,
idr2.id_bits =3D 31) but does not support two-level ISTs, the guest can
request 32 bits of LPI IDs. The vgic_v5_alloc_linear_ist() function
calculates n =3D max(5, 31 + 1 + 3) =3D 35. The size calculation BIT(n + 1)
evaluates to BIT(36). Because l1sz is typed as a 32-bit integer (u32),
1UL << 36 overflows and truncates to 0, causing kzalloc() to return the
ZERO_SIZE_PTR (0x10).

> +	if (!ist)
> +		return -ENOMEM;
> +
> +	if (spi_ist) {
> +		vmi->h_spi_ist =3D ist;
> +	} else {
> +		vmi->h_lpi_ist_structure =3D false;
> +		vmi->h_lpi_ist =3D ist;
> +	}
> +
> +	vgic_v5_clean_inval(ist, l1sz);

[Severity: High]
If ist is ZERO_SIZE_PTR (0x10) due to the overflow above, doesn't this
cache maintenance operation panic the host?

On arm64, dcache_by_line_op aligns this to 0x0 and executes a dc civac
on address 0x0, which immediately causes an EL1 Translation Fault and a
kernel panic. This appears reachable by an unprivileged guest via the emula=
ted
GICv5 IRS MMIO registers.

> +
> +	return 0;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260904113404.4051=
341-1-sascha.bischoff@arm.com?part=3D10
