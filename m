Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1DF43BFE2B
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 16:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790009964; cv=none; b=KJEvZwU1Ti9TDFWBvXTx8T3BDaBKpQ4sxRuGro3vy/WUtsRYVnkFJGX5DjNkxkQ8TY9UKMyTuqnoIRsJqXQk23kplJ26sLsXV3te/X3BRxNnlB++0va52k2iBvJRnmiTYS3SI6f+L9qVCZ6HTZyzQfYOvpOfkhXOrtvF/1pchy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790009964; c=relaxed/simple;
	bh=2YavPmuSqqe/BkVWIb5GEIFhtnqoYJ8ohpnLcNp6sc8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=tvrUxY3worBSfNN81Nsz7yKHU87pI94dAuIcfmU27D4VoYyCXxa5dO7h15YTgBWAeLgKmmzXBB9xT+MwgohAxea2KOGpVNBK2wlQib75wnYtOmVr9k+jHlChBY+n0H93skUrgcubY4ipfr8Wo0wHvgHq+lia6/Zfcv5euGX1/w0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DXznph2W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DXznph2W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 657751F000FF;
	Mon, 21 Sep 2026 16:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790009962;
	bh=98AdR5OQVsECzz2h4uZLhERgGE7GPsAS98uXAves/a8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DXznph2WjQJ159wOraSqChngEAetmgZ87JChPAKOUfWrt2dlKT0o+1TmAY4UvThRB
	 yYNBb6tu/iPocYqeLkuW2KL+QXO0YI2g1hRIb8B2vf/KiPJudf/BQ5jear/ysyzUCc
	 W3oWFzmPnWR4syzKmp68U7qkgmeoh3cnJbEegd7EkpOdCVhiDyy2MoJgYMOZiL/aq8
	 m4PBWsBV8ApinvwpTPYYfUqEulJLKZuiitiG5sz2bSBdGGDypBR4BH47BYz9RN1T1q
	 OHcghcWyZdBUI1U4nYYeCKvDhRPRMbPiNJ1hf0CwQxJZySev2EBCcJ8u6vt6GZfn/C
	 oGfRAqHn+IgpA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/2] KVM: arm64: Support FFA_FN64_MEM_RECLAIM2 in host
 handler
Reply-To: sashiko-reviews@lists.linux.dev
To: "Snehal Koukuntla" <snehalreddy@google.com>
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260921164748.2958578-3-snehalreddy@google.com>
References: <20260921164748.2958578-1-snehalreddy@google.com>
 <20260921164748.2958578-3-snehalreddy@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 21 Sep 2026 16:59:21 +0000
Message-Id: <20260921165922.657751F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] kvm: arm64: incorrect buffer bounds in do_ffa_mem_reclaim2()
--

commit 9e4ba2a6fb44613f009459976518be9371118818
Author: Snehal Koukuntla <snehalreddy@google.com>

KVM: arm64: Support FFA_FN64_MEM_RECLAIM2 in host handler

This commit adds support for the FFA_MEM_RECLAIM2 interface in the host
FF-A proxy handler. It forwards the SMC call to the SPMD and unshares the
reclaimed page ranges in the host stage-2 page tables.

Link: https://support.arm.com/documentation/den0140/j

> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index 5ad74ab265b57..e0fba07a67bc9 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
[ ... ]
> @@ -611,6 +624,107 @@ static void __do_ffa_mem_xfer(const u64 func_id,
[ ... ]
> +static void do_ffa_mem_reclaim2(struct arm_smccc_1_2_regs *res,
> +				struct kvm_cpu_context *ctxt)
> +{
> +	DECLARE_REG(u64, handle, ctxt, 1);
> +	DECLARE_REG(u64, flags, ctxt, 2);
> +	DECLARE_REG(u64, x3, ctxt, 3);
> +	DECLARE_REG(u64, x4, ctxt, 4);
> +	DECLARE_REG(u64, x5, ctxt, 5);
> +	u32 req_desc_cnt =3D (u32)(x3 >> 32);
> +	u32 total_pages =3D (u32)x3;
> +	u32 desc_size =3D (u32)x4;
> +	u32 offset =3D (u32)x5;
> +	u32 page_index =3D (u32)(x5 >> 32);
[ ... ]
> +	if (offset >=3D (u64)req_desc_cnt * desc_size) {
> +		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> +		return;
> +	}

[Severity: High]
Could this check incorrectly reject valid offsets? By checking offset again=
st
the total length of the requested descriptors (req_desc_cnt * desc_size), it
seems to conflate the descriptor count with the total buffer capacity.

> +
> +	hyp_spin_lock(&host_buffers.lock);
> +	if (!host_buffers.tx) {
> +		ret =3D FFA_RET_INVALID_PARAMETERS;
> +		goto out_unlock;
> +	}
> +
> +	memcpy(hyp_buffers.tx, host_buffers.tx, (u64)req_desc_cnt * desc_size);

[Severity: High]
Is there a risk that this copies too few bytes when offset is greater than
zero? Since the start of the required descriptors in the buffer is shifted =
by
offset bytes, copying only req_desc_cnt * desc_size bytes from the beginning
of the host buffer misses the trailing descriptors.

If the host EL1 intentionally issues a hypercall with an offset greater than
zero, this might lead to the SPMD reading uninitialized or stale memory from
the hypervisor TX buffer.

> +
> +	range =3D (void *)hyp_buffers.tx + offset;
> +	if (page_index >=3D range->pg_cnt) {
> +		ret =3D FFA_RET_INVALID_PARAMETERS;
> +		goto out_unlock;
> +	}
> +
> +	ffa_mem_reclaim2(res, handle, flags, x3, x4, x5);
> +	if (res->a0 !=3D FFA_SUCCESS)
> +		goto out_unlock;
> +
> +	reclaimed_pages =3D res->a3;
> +
> +	for (in_idx =3D offset / desc_size; in_idx < req_desc_cnt; in_idx++) {

[Severity: High]
Does this loop iterate fewer times than the number of descriptors reclaimed
by the SPMD?

Starting the loop index at offset / desc_size and ending it at req_desc_cnt
means the loop only executes (req_desc_cnt - offset / desc_size) times.
This appears to unshare fewer descriptors than the SPMD actually processed.

If the untrusted host EL1 triggers this path, it could leave the hypervisor
stage-2 ownership tracking permanently desynchronized from the SPMD state.

> +		struct ffa_mem_region_addr_range temp;
> +		u32 pg_cnt, to_reclaim;
> +
> +		if (reclaimed_count >=3D reclaimed_pages)
> +			break;
[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260921164748.2958=
578-1-snehalreddy@google.com?part=3D2
