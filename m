Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 618AB483815;
	Fri,  4 Sep 2026 12:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788524701; cv=none; b=Iva9BNA6VGpZY8R5500o4+XjJLdZgoU+Mt7UFSiMtgsoiAImrIEqnBxgS4NxxxPYnf95raesGm+/dj7wtO0adpxyF8UykXJGUsHa8+iEJBGbHdqLp/Oh6HkYqbBQBPKNCeN2LlX3zzgyivm7y50JYsOa+iD2z78FHn7YRrIyB2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788524701; c=relaxed/simple;
	bh=uJ7pu17YHRaKmgRtXA04K8SLek1ClTdMjBON17JgbeE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=RwakQFhDNCKIHMc91Oy8WlFBFvNzqRxgL4lZu77OFmOQh9IhhSmn0X/VRBjo2zshpV+uyEfAR4WRL99gQKonCy+uOblJV+sWIXlAGMnl8Y6vODpsZ6mnZnET/uZxd2WkqquP41sx5+Nnb1PPhqjqdel3ODU96SyNx34Ijl4m0XY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XmI+VCti; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XmI+VCti"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6977B1F00A3F;
	Fri,  4 Sep 2026 12:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788524699;
	bh=uk3uHY1cPdZeA3snDZT2ocy72h5PzOV9PL0yPO27JQk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XmI+VCtiYOMyEcgJ94cyT1nMFarbCktopAetnqQtjlvSbiEfvaLpysWYwW1kU6FQl
	 xa/WyG7am2FfWdSxF26xoJ/s5/AAqKHWFVDH37bD1zTYJxVcyOJaF8L8hA51KMC1Ob
	 O6U/K1U6EjS2JwU76iJnNyTPksBwAfvnzf8ed8oLqtn09vHzWouNk/Bzgky35b36vK
	 z7b2tIQ7O+DJ7BVrOMHQGUwq57PCoHcc2jmCp8HMplvZDeWKBKkwyPCYWnfUjcfuAz
	 Dxf5o6ylngjKc5d5m3xgRKiAbD844D8YORGa7WZuwNI419VluaQtX2fD80/zq/SHjW
	 18v7bWY7PsteQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 09/49] KVM: arm64: gic-v5: Create and manage VM and
 VPE tables
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260904113404.4051341-10-sascha.bischoff@arm.com>
References: <20260904113404.4051341-1-sascha.bischoff@arm.com>
 <20260904113404.4051341-10-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 04 Sep 2026 12:24:58 +0000
Message-Id: <20260904122459.6977B1F00A3F@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] The Level 1 and linear Virtual Machine Table (VMT) allocations are=
 not rounded up to `dma_get_cache_alignment()`, creating a severe risk of D=
MA cacheline sharing and memory corruption on non-coherent systems.
--

commit 2a6fdf9c9daff6b8431875f64f4c14a50786f815
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: arm64: gic-v5: Create and manage VM and VPE tables

This commit introduces support for allocating and managing Virtual Machine
Tables (VMT) and Virtual PE Tables (VPET) required by GICv5. It handles both
linear and two-level VMT allocations, manages cache maintenance for
non-coherent systems, and coordinates access between the CPUs and the
Interrupt Routing System (IRS).

> diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.c b/arch/arm64/kvm/vgic/v=
gic-v5-tables.c
> new file mode 100644
> index 0000000000000..7252d48431a5a
> --- /dev/null
> +++ b/arch/arm64/kvm/vgic/vgic-v5-tables.c

[ ... ]

> +static int vgic_v5_alloc_vmt_linear(unsigned int num_entries)
> +{
> +	vmt_info->linear.vmt_base =3D kzalloc_objs(*vmt_info->linear.vmt_base,
> +						 num_entries);

[Severity: High]
Since the VMT is shared with the IRS and requires cache maintenance on
non-coherent systems, should this allocation be rounded up to
dma_get_cache_alignment()?

If num_entries is small, this allocates exactly the requested size. For
example, if this results in an 8-byte allocation, it could be placed in a
generic slab cache (like kmalloc-8) and share a cacheline with unrelated
objects. When vgic_v5_clean_inval() later issues a cache clean and
invalidate to the Point of Coherency, it could write back the CPU's cached
copy of the entire cacheline. If an unrelated object sharing the cacheline
is undergoing concurrent DMA writes, those writes would be silently
overwritten.

> +	if (!vmt_info->linear.vmt_base)
> +		return -ENOMEM;
> +
> +	vgic_v5_clean_inval(vmt_info->linear.vmt_base,
> +			    num_entries * sizeof(struct vmtl2_entry));
> +
> +	return 0;
> +}
> +
> +/*
> + * Allocate the first level of a two-level VM table. The second-level VM=
 tables
> + * are allocated on demand (by vgic_v5_alloc_l2_vmt()).
> + */
> +static int vgic_v5_alloc_vmt_two_level(unsigned int num_entries)
> +{

[ ... ]

> +	vmt_info->l2.num_l1_ents =3D (num_entries / GICV5_VMT_L2_TABLE_ENTRIES);
> +	vmt_info->l2.vmt_base =3D kzalloc_objs(*vmt_info->l2.vmt_base,
> +					     vmt_info->l2.num_l1_ents);

[Severity: High]
Similar to the linear VMT allocation, does this exact-sized allocation for
the L1 VMT risk DMA cacheline tearing?

If vmt_info->l2.num_l1_ents is small, it creates a severe risk of sharing a
cacheline with unrelated slab objects. Padding it to
dma_get_cache_alignment() (as is correctly done for vpet_base and vped_base
in vgic_v5_vmte_init) would prevent cache maintenance from corrupting memory
belonging to other subsystems.

> +	if (!vmt_info->l2.vmt_base)
> +		return -ENOMEM;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260904113404.4051=
341-1-sascha.bischoff@arm.com?part=3D9
