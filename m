Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793629923;
	b=UPMl8jPVnh5eeshTG2qvfQ5KwKSlwLBe+NwW6kGWpJh8h2IzIh48XXqW/shHRmBxDiav
	 6YLieyc5c3BsKPaCy1pKaQfY/SWGZF3FvqemhrjpJIFNnK3/z0A+eOheffbrDpylIqLG9
	 6FjgBi1yNPqiAYsd54acNnGv94d/XSKfz5TGI6fhdjx+JlXdp9M5RX3G4rMuR+50RGwIb
	 pexlkIGoJGmJ+YpfKcns7i9whO2afTiHzFwl5/SxmLYAzwBRRN6iU0bIeCy1C77fYuNuu
	 pwGohifNkKIafFurx4kefuCi2gqXxzvlfMEmw99as2yAMmNeN5VppuiJ8Dd3344WBWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793629923;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=elHo9t/45wo3a6bfYRsZpPRc2KYwvtn0yEJ/5IXz+SQ=;
	b=F7IAIX3DTRQQ+NH9NpI5fHKI8t/zRn3W/JtLeQJ2pwhoEy8nb+DsuEsW+dX4KtcQWaNU
	 TAh6dLiA1esZQoP070rnTBTAZyfIEJwfTVRE9LlWA8rwAVhCiAvje2kwPuigscabYdn+s
	 gHT0KkAzMJ7NkX8C1ZcBlhOZ0QlPwk1nXx7xj3Yydfv3v/qitN0WeRER/IB4Fmn1phWJF
	 UT9WeOdp5M+UjeXkZXJgv7bMIE/M89xZkMg+jmV7op7LkqpA0RJ6psFI3eNjApWlB9ooe
	 xLEMAJToYnT7FABPBhZRbYgMh3p2oNDb/5bomzczwORN2pCHFeQW9mDo+VpfHJx8Tvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DT+Kqcve;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ED0A606A934
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 14:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DT+Kqcve
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E14D31F00A16;
	Mon,  2 Nov 2026 14:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793629923;
	bh=elHo9t/45wo3a6bfYRsZpPRc2KYwvtn0yEJ/5IXz+SQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DT+Kqcve/IT/MnbMzL6rtC+5R5fgauEJZ+0NhsrcfqxFrzouD29K3ohqbhbQy6Rgl
	 VE1binUjpbyw8jr+kXV9XxfHjWI5xvMAeOyzlibIEp2BC3nd5r8qdqe2ISAp0TUZ5n
	 lIgDng3ar+J66ZYaxcADC7o9vjmmlHaBROGCUcMVIx+G2G7X2QZedrft0uK3GFgCdA
	 0GKgAI92FxNViZ2VxAmxpiogrhPIgIqzzN4WLCLUL78JE3eswNLlxJF4jJlI+nY+af
	 ANFlYs6h9X7iMxbVaCUJ9dycnobtlmpX6RATeTUhSnlZvv/JL2GZ/SjE2O+UmZkwfG
	 w7OJGSP3oDVUA==
Message-ID: <sashiko-outbox-193580@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 2/2] KVM: arm64: Support FFA_MEM_RECLAIM2 in host
 handler
Reply-To: sashiko-reviews@lists.linux.dev
To: "Snehal Koukuntla" <snehalreddy@google.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20261102141444.1830221-3-snehalreddy@google.com>
References: <20261102141444.1830221-1-snehalreddy@google.com>
 <20261102141444.1830221-3-snehalreddy@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Nov 2026 14:32:02 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] KVM: arm64: missing PAGE_SIZE alignment check in do_ffa_mem_recl=
aim2()
--

commit 98f8a09e41b961093f58b8b2216332b0f1fd7346
Author: Snehal Koukuntla <snehalreddy@google.com>

KVM: arm64: Support FFA_MEM_RECLAIM2 in host handler

This commit adds support for the FF-A v1.3 FFA_MEM_RECLAIM2 interface to the
host FF-A proxy handler in pKVM, validating the constituent descriptors in
the hypervisor TX buffer before forwarding the request to the SPMD and
unsharing the reclaimed ranges from the host stage-2 page tables on success.

Link: https://support.arm.com/documentation/den0140/k

> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index 5ad74ab265b57..2f49ffaa93617 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c

[ ... ]

> @@ -611,6 +624,116 @@ static void __do_ffa_mem_xfer(const u64 func_id,
>  		__do_ffa_mem_xfer((fid), (res), (ctxt));	\
>  	} while (0);
> =20
> +static void do_ffa_mem_reclaim2(struct arm_smccc_1_2_regs *res,
> +				struct kvm_cpu_context *ctxt)
> +{

[ ... ]

> +	memcpy(hyp_buffers.tx, host_buffers.tx, (u64)req_desc_cnt * desc_size);
> +
> +	for (in_idx =3D 0; in_idx < req_desc_cnt; in_idx++) {
> +		range =3D (void *)hyp_buffers.tx + in_idx * desc_size;
> +		if (check_add_overflow(declared_pages, range->pg_cnt, &declared_pages)=
) {
> +			ret =3D FFA_RET_INVALID_PARAMETERS;
> +			goto out_unlock;
> +		}
> +	}
> +
> +	range =3D (void *)hyp_buffers.tx + offset;
> +	if (declared_pages !=3D total_pages || page_index >=3D range->pg_cnt) {
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
> +		struct ffa_mem_region_addr_range temp;
> +		u32 pg_cnt, to_reclaim;
> +
> +		if (reclaimed_count >=3D reclaimed_pages)
> +			break;
> +
> +		range =3D (void *)hyp_buffers.tx + in_idx * desc_size;
> +		if (!range->pg_cnt)
> +			continue;
> +
> +		pg_cnt =3D range->pg_cnt - page_index;
> +		to_reclaim =3D min(pg_cnt, reclaimed_pages - reclaimed_count);
> +
> +		temp =3D (struct ffa_mem_region_addr_range) {
> +			.address =3D range->address + (u64)page_index * FFA_PAGE_SIZE,
> +			.pg_cnt =3D to_reclaim,
> +		};
> +
> +		WARN_ON(ffa_host_unshare_ranges(&temp, 1));

[Severity: Medium]
On systems where the kernel PAGE_SIZE is larger than FFA_PAGE_SIZE (16 KiB =
or
64 KiB pages vs. 4 KiB FF-A pages), should do_ffa_mem_reclaim2() in
arch/arm64/kvm/hyp/nvhe/ffa.c verify that each constituent range's address =
and
byte size, as well as the starting page_index offset, are aligned to PAGE_S=
IZE
before forwarding the ffa_mem_reclaim2() SMC to EL3?

On the share paths (__do_ffa_mem_xfer() and do_ffa_mem_frag_tx()),
ffa_host_share_ranges() runs prior to the SMC and enforces PAGE_SIZE alignm=
ent
in __ffa_host_share_ranges().

In do_ffa_mem_reclaim2(), however, the pre-SMC validation only checks
check_add_overflow(declared_pages, range->pg_cnt, &declared_pages),
declared_pages !=3D total_pages, and page_index >=3D range->pg_cnt. Once
ffa_mem_reclaim2() succeeds in the SPMC, do_ffa_mem_reclaim2() calls
ffa_host_unshare_ranges(&temp, 1) -> __ffa_host_unshare_ranges():

	for (i =3D 0; i < nranges; ++i) {
		struct ffa_mem_region_addr_range *range =3D &ranges[i];
		u64 sz =3D (u64)range->pg_cnt * FFA_PAGE_SIZE;
		u64 pfn =3D hyp_phys_to_pfn(range->address);

		if (!PAGE_ALIGNED(sz | range->address))
			break;

If the host passes a descriptor or starting page_index that is not aligned =
to
PAGE_SIZE, __ffa_host_unshare_ranges() breaks out and returns an error after
EL3 has already reclaimed the pages. Does this trigger the EL2 WARN_ON() and
leave those pages permanently stuck in the PKVM_PAGE_SHARED_OWNED state in =
the
host stage-2 page tables?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102141444.1830=
221-1-snehalreddy@google.com?part=3D2
