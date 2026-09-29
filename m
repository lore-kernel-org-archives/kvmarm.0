Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C662848BE;
	Tue, 29 Sep 2026 22:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790721044; cv=none; b=N/yvCBsiWH6K4ODsTfty2NlH63urtCgkbtaLUehLxKi9c7OFs1mDjpgSXaG5aZ4iH9pcp04+Oh5L3Wj0+zdhCRumVTsx+f0yXecVZEDw83vEw6RHEu6OZDfg6B1k8dpj1/+RqLtVEkkO22ZLHdp0LatYz1D+O3LVBaqCuuHBFZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790721044; c=relaxed/simple;
	bh=WT0QEWbypzBdoDEFN1sZgN+YU3iCsax/zxN9UK5aQ3I=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=TeCkyh9lmH8WeGKEpkLgfi3UqqI07Boy57YR0Fpyxoq1PuAHs+0/zEqQSv2d/rmLEsbyVJtpxZaKVlWH9w2lPQyCiE8Y3R5B8LdXRmXNcrHfdg3BB2HNeyFEE8y+NZcDKckGp8MLkyoyeHEdrk75MM5OALxXvjC4d+7lOZy9aQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aIMR2JMc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aIMR2JMc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 681D61F000FF;
	Tue, 29 Sep 2026 22:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790721042;
	bh=T180Hb52MtWB1bdwjFkuKEflYgc+bCCM+QhU40hsEC4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aIMR2JMceY+MFiRaDgct1Xt/3jfxIcFALOE9U/DAy9Rr+qLeI7x9t76KZQnaaRh4o
	 o1Hn88HgQVfaDNHenjjAr0jQi0nojyE/kJiLiC8Suoo6a25kQfwJBdbv2kP6EcHZzJ
	 LKGQWM26kxhiPgLtA+s828DQERt28cZ3qiAaG02ieDq2jy43MhTCErNpUbJyEbnuob
	 Y+RWdJdnjRiULU8nRnsN4lDPI9Tn942G8LVsMEaBl3aqLMF/mfHsFp9/UC93BD+k29
	 1hPC+P0+KIRhhse4evsoCxJCccXpndr/H+LUzbx+VTDhHCroXbsMPDQgS9PVWTUbSp
	 +Kb/BfkWXqEwg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v20 4/9] firmware: arm_rmm: Add support for SRO
Reply-To: sashiko-reviews@lists.linux.dev
To: "Suzuki K Poulose" <suzuki.poulose@arm.com>
Cc: "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, kvm@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260929221623.1342076-5-suzuki.poulose@arm.com>
References: <20260929221623.1342076-1-suzuki.poulose@arm.com>
 <20260929221623.1342076-5-suzuki.poulose@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 29 Sep 2026 22:30:41 +0000
Message-Id: <20260929223042.681D61F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [Medium] arm_rmm: SRO cancellation discards partial progress limit leadin=
g to memory corruption
- [Medium] arm_rmm: integer overflow in granule clamp bypasses RMM protecti=
on
- [Medium] arm_rmm: missing validation of block_size_fld leads to division =
by zero
--

commit 44837285c82689401d14180cb932077aa7982b67
Author: Steven Price <steven.price@arm.com>

firmware: arm_rmm: Add support for SRO

This commit introduces support for Stateful RMI Operations (SRO), allowing =
RMI
commands to return incomplete and be resumed. It adds SRO state tracking,
memory donation and reclaim handling, and wrappers for SRO commands.

> --- a/drivers/firmware/arm_rmm/rmi.c
> +++ b/drivers/firmware/arm_rmm/rmi.c
> @@ -14,6 +15,687 @@
> +static long rmi_granule_range_delegate(unsigned long base,
> +				       unsigned long top,
> +				       unsigned long *out_top)
> +{
> +	struct arm_smccc_1_2_regs regs =3D {
> +		SMC_RMI_GRANULE_RANGE_DELEGATE, base, top
> +	};
> +	long ret =3D rmi_sro_execute(&regs);
> +
> +	if (ret =3D=3D RMI_SUCCESS && out_top)
> +		*out_top =3D regs.a1;
> +
> +	return ret;
> +}
[ ... ]
> +static int rmi_sro_donate_contig(struct rmi_sro_state *sro,
> +				 unsigned long sro_handle,
> +				 unsigned long donatereq,
> +				 struct arm_smccc_1_2_regs *out_regs,
> +				 gfp_t gfp)
> +{
[ ... ]
> +mem_donate:
> +	rmi_op_mem_donate(sro_handle,
> +			  virt_to_phys(&sro->addr_list[sro->addr_count]), 1,
> +			  0, out_regs);
> +	donated_size =3D out_regs->a1 << PAGE_SHIFT;
> +
> +	if (WARN_ON(donated_size > size))
> +		donated_size =3D size;

[Severity: Medium]
Is there a risk of an integer overflow here before the bounds check?

If a buggy or compromised RMM returns a maliciously large value for
out_regs->a1, the left shift by PAGE_SHIFT could overflow the 64-bit
donated_size variable. This would result in a small value that bypasses
the WARN_ON() check.

The host kernel might then erroneously believe the RMM consumed fewer
granules than it actually did, freeing the remaining memory back to the
allocator while the RMM is actively using it. This could result in memory
corruption.

[ ... ]
> +static int rmi_sro_donate_noncontig(struct rmi_sro_state *sro,
> +				    unsigned long sro_handle,
> +				    unsigned long donatereq,
> +				    struct arm_smccc_1_2_regs *out_regs,
> +				    gfp_t gfp)
> +{
> +	unsigned long block_size_fld =3D RMI_DONATE_BLOCK_SIZE(donatereq);
> +	unsigned long block_size =3D rmi_addr_block_size_to_bytes(block_size_fl=
d);
> +	unsigned long count =3D RMI_DONATE_COUNT(donatereq);
> +	unsigned long state =3D RMI_DONATE_STATE(donatereq);
> +	unsigned long found =3D 0;
> +	unsigned long donated_granules;
> +	unsigned long granules_per_block =3D block_size >> PAGE_SHIFT;
> +	unsigned long consumed_blocks;
[ ... ]
> +	donated_granules =3D out_regs->a1;
[ ... ]
> +	consumed_blocks =3D donated_granules / granules_per_block;

[Severity: Medium]
Could an unvalidated block_size_fld lead to a division by zero panic here?

While count and state are explicitly validated against anomalies,
block_size_fld from the firmware appears to be blindly trusted. If the
firmware returns an out-of-bounds value (e.g., 6), the shift amount in
rmi_addr_block_size_to_bytes() can evaluate modulo 64, yielding a block_size
smaller than PAGE_SIZE.

This would cause granules_per_block to evaluate to 0, triggering a kernel
panic when donated_granules is divided by granules_per_block.

[ ... ]
> +long rmi_sro_execute(struct arm_smccc_1_2_regs *regs)
> +{
> +	bool cancelled =3D false;
> +	unsigned long sro_handle;
[ ... ]
> +	if (cancelled)
> +		return -ECANCELED;
> +
> +	return regs->a0;
> +}

[Severity: Medium]
When an operation is cancelled, does this unconditionally discard the
output registers containing the partial progress limit?

If a buggy or compromised RMM returns an unexpected MEMREQ during a non-mem=
ory
SRO like SMC_RMI_GRANULE_RANGE_DELEGATE, rmi_sro_execute() issues an
RMI_OP_CANCEL and unconditionally returns -ECANCELED. This drops the final
state in the a1 register.

As a result, callers like rmi_granule_range_delegate() fail to capture
the progress limit. The kernel would then undelegate fewer granules
than the RMM successfully processed before returning them to the normal
allocator, which can lead to fatal Granule Protection Faults when the host
later accesses them.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260929221623.1342=
076-1-suzuki.poulose@arm.com?part=3D4
