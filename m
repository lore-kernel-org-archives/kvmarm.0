Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2EA84ACC68;
	Thu,  1 Oct 2026 09:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790845312; cv=none; b=pGr5wdVCWV0ZUG5o/NvsHxucwT5GS0vmdHm2D8uzvwOt+O+STp7iqR3oSfQr/2qFTD2XcZ6MufwOeUhGoWNeya8+gmtAzwySoeXruVfx1NdsLXc1TNEAsLmiBtLAFy9ztBxPQRcToYM9+NW9k5UCmJnIOcqwOrCXTqrRFy+q0L8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790845312; c=relaxed/simple;
	bh=HzU1/UhvM0s24IX6gMyhXcAaabO4eMNuO+Ipa0vz4l0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=LKm7Gd1ur3QYGdms5ARWmN8mvi/hAkyQo+e46Ui2AoMoNqYoZZtxtezYKfTu5lQwDr7RRSlNmi3UTvof+QtRp2DjmhS1HbiSKbA1hQrdHTYo01XQuKvlQ37pCGXuq0B/S8lu4TCUEIG2crZ7s9MwT/5DaTWh1VbhLVsCNKLpVuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bk9VBDjQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bk9VBDjQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F3381F000FF;
	Thu,  1 Oct 2026 09:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790845310;
	bh=kD9bQmpY5Qu5oRWAwVfQaQLxMlrC5hkl5UkXmQolIm4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bk9VBDjQHVo6tchbVAuzdUgeUEslRHXb4+ooMdTz56X9hSvLMPjAYp6Jh7CgPk1NQ
	 Oc7XM8Sj88TWhFnRgPd/vNkHhMiK58oP+PJpGVga0HtkaW8rE7DE5H41TXbF1zYFth
	 GPpaqC4fF5FWSYzNmTi7ub1uIeqPDISwW0MWnrPDNfEmfJjwyU4RGeLDcWc1zxX5yb
	 RdhXWB9NqXTi+jucGvKOYDalA9NbUMwDdddo4abJYGCNMvWe8JFf1uNQd6nTAqGEIO
	 +Yr2VOS8r8VCaEMxA4+35VpXQPIwq7HnRniXe6Eb8IBRlgWJ+DYmXIcTFuLWuX5u5l
	 fxZs3+FkeZEGg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v21 4/9] firmware: arm_rmm: Add support for SRO
Reply-To: sashiko-reviews@lists.linux.dev
To: "Suzuki K Poulose" <suzuki.poulose@arm.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20261001084555.1456543-5-suzuki.poulose@arm.com>
References: <20261001084555.1456543-1-suzuki.poulose@arm.com>
 <20261001084555.1456543-5-suzuki.poulose@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 01 Oct 2026 09:01:49 +0000
Message-Id: <20261001090150.1F3381F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] arm_rmm: spurious SRO cancellation when contig donate cache fill=
s up
- [Medium] arm_rmm: infinite loop in SRO execution if RMM consumes zero gra=
nules
--

commit 11de55b0945f49bf7651f24a6bc346b286810815
Author: Steven Price <steven.price@arm.com>

firmware: arm_rmm: Add support for SRO

The commit introduces support for Stateful RMI Operations (SRO) in RMM v2.0.
It adds logic to handle memory donate and reclaim operations, allowing SMCs
to return in progress and track state using an rmi_sro_state structure.
Wrappers for SRO RMI commands are also provided to integrate with the state=
ful
command infrastructure.

> diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rm=
i.c
> index b558965a05a2c..7d4e04a5d7c0a 100644
> --- a/drivers/firmware/arm_rmm/rmi.c
> +++ b/drivers/firmware/arm_rmm/rmi.c
[ ... ]
> +static int rmi_sro_donate_contig(struct rmi_sro_state *sro,
> +				 unsigned long sro_handle,
> +				 unsigned long donatereq,
> +				 struct arm_smccc_1_2_regs *out_regs,
> +				 gfp_t gfp)
> +{
[ ... ]
> +	/* Reuse the cached address range if we have one */
> +	for (int i =3D 0; i < sro->addr_count; i++) {
> +		unsigned long entry =3D sro->addr_list[i];
> +
> +		if (RMI_ADDR_RANGE_BLOCK_SIZE(entry) =3D=3D block_size_fld &&
> +		    RMI_ADDR_RANGE_COUNT(entry) =3D=3D count &&
> +		    RMI_ADDR_RANGE_STATE(entry) =3D=3D state &&
> +		    IS_ALIGNED(RMI_ADDR_RANGE_ADDR(entry), size)) {
> +			sro->addr_count--;
> +			swap(sro->addr_list[sro->addr_count],
> +			     sro->addr_list[i]);
> +
> +			goto mem_donate;
> +		}
> +	}
> +
> +	ret =3D rmi_sro_ensure_capacity(sro, 1);
> +	if (ret)
> +		return ret;

[Severity: Medium]
When the cache fills up with unconsumed fragments, rmi_sro_ensure_capacity()
returns -ENOSPC. Does returning the error here cause a valid SRO command to=
 be
spuriously cancelled?

Unlike rmi_sro_donate_noncontig() which handles a full cache by calling
rmi_sro_free() to flush the unconsumed fragments, the contiguous path simply
bails out. Could this be triggered if the firmware requests memory in patte=
rns
that fragment the cache?

> +
> +	virt =3D alloc_pages_exact(size, gfp);
> +	if (!virt)
> +		return -ENOMEM;
[ ... ]
> +mem_donate:
> +	rmi_op_mem_donate(sro_handle,
> +			  virt_to_phys(&sro->addr_list[sro->addr_count]), 1,
> +			  0, out_regs);
> +	donated_size =3D out_regs->a1 << PAGE_SHIFT;
> +
> +	if (WARN_ON(out_regs->a1 > (size >> PAGE_SHIFT)))
> +		donated_size =3D size;
> +
> +	/* All granules consumed by the RMM */
> +	if (donated_size =3D=3D size)
> +		return 0;
> +	/* No granules were consumed by the RMM, cache them */
> +	if (donated_size =3D=3D 0) {
> +		sro->addr_count++;
> +		return 0;
> +	}

[Severity: Medium]
If a buggy or interrupted RMM consumes 0 granules, does caching the block a=
nd
returning 0 here create an infinite loop?

Because 0 is a success return code, the execution loop in
rmi_sro_memxfer_execute() will skip the cancellation logic and re-issue the
same request, as shown below:

> +
> +	/* The granules were partially consumed, reclaim the unused ones. */
> +	free_addr_range(sro->addr_list[sro->addr_count], donated_size);
> +
> +	return 0;
> +}
[ ... ]
> +long rmi_sro_memxfer_execute(struct rmi_sro_state *sro, gfp_t gfp)
> +{
> +	struct arm_smccc_1_2_regs *regs =3D &sro->regs;
> +	bool cancelled =3D false;
> +	unsigned long sro_handle;
> +
> +	rmi_smccc_invoke(regs);
> +
> +	sro_handle =3D regs->a1;
> +	while (RMI_RESULT_STATUS(regs->a0) =3D=3D RMI_INCOMPLETE) {
> +		bool can_cancel =3D RMI_RESULT_CAN_CANCEL(regs->a0) =3D=3D RMI_OP_CAN_=
CANCEL;
> +		int ret =3D 0;
> +
> +		switch (RMI_RESULT_MEMREQ(regs->a0)) {
> +		case RMI_OP_MEM_REQ_NONE:
> +			rmi_op_continue(sro_handle, RMI_CONTINUE_KEEP_GOING,
> +					regs);
> +			break;
> +		case RMI_OP_MEM_REQ_DONATE:
> +			ret =3D rmi_sro_donate(sro, sro_handle, regs->a2, regs,
> +					     gfp);
> +			break;

If ret is 0, the error handling below is skipped, causing the while loop
to re-execute without progress. While firmware is trusted, could we hang the
CPU indefinitely here, bypassing the loop cancellation mechanisms?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261001084555.1456=
543-1-suzuki.poulose@arm.com?part=3D4
