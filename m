Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D1211D86E4
	for <kvmarm@lists.linux.dev>; Tue, 30 Jun 2026 11:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782817740; cv=none; b=Dmt6E02kZou/WWKYxuk5wZPpESeQwF1RWUd86wMhrpYKDpZZQNtHnxtVybGKUUCCTEZRG+oEWmktr2mLmYrEfteDaD4mJ+/4rI6P0UB+rUzCCQO4X37CIklcE2tHgWSMB75rfBxsJSOed6rBVAwPqzMswGGz+niuS4QbWTqjooY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782817740; c=relaxed/simple;
	bh=iY8MVDm8yiWVaqinCVFKup5AQbK1KT5sXXnj50LwX+w=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=OhavrrfIvK/ZI1Ev8m0ALAAjzINnoKH8DWtOs8Dmw1H4Dz08D3h7McltbWFoilRHkV3pVHwpMyzpVMuQf91g9Y5p2dMEzyFJV8W4IPjGujYFu3j5wsh2mEg8cI4dpVEa1eK7aRqNMlT8TyflyWNtDYtf5zaTA8BqeGyK8hQY3z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T/9HQO5C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T/9HQO5C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDA0F1F000E9;
	Tue, 30 Jun 2026 11:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782817739;
	bh=lVRN6/d7i2Dsd54AnBmrDfcWe3VEzUIJJgJyLop8ev0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=T/9HQO5CRU/lt76c0RIx3sBlPutA0qTD3kWe/BFAVpdMhSRy8U+ql/1dhNTOCNp8o
	 GbmRAFT8cwSDFk6uxkY+afimlsSUPvrpRZLI/DCGa426lpGoZWaV1ygXb/RPbBDbJ2
	 6Cx7I69ZwBSkM0iN6dsLQ9NFpl3BBrJTZ7AX/im+mJPd24NCuol/o/tQRjYrDSAnIi
	 Y4lQvHmxKHp3ao9CnAK8BiXSBfCjB9o+4rT534BHMUBqJjDsDBTSVoZtQ6jpQ6e7wN
	 OBZu3d55FC3f0QUqrak5kzR3x0xwHBhf+YGOo5y4zrwL516xxMAUF6tqgkpgEjy70+
	 Hed1GE/dB2BWw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 5/6] KVM: arm64: Ensure FFA ranges are page aligned
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sebastian Ene" <sebastianene@google.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260630102058.3219867-7-sebastianene@google.com>
References: <20260630102058.3219867-2-sebastianene@google.com>
 <20260630102058.3219867-7-sebastianene@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 30 Jun 2026 11:08:58 +0000
Message-Id: <20260630110858.BDA0F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Host-controlled invalid handles in FFA_MEM_FRAG_TX trigger a fatal=
 hypervisor panic via WARN_ON.
--

commit b0b1c44dd777f162d56e942a3bb04410af9b98a8
Author: Mostafa Saleh <smostafa@google.com>

    KVM: arm64: Ensure FFA ranges are page aligned
   =20
    Harden the check for the constituent memory region page alignment
    to prevent over-sharing when the negotiated FFA_PAGE_SIZE size is
    smaller than the system PAGE_SIZE.
    At the moment we only check that the size of the range is page
    aligned, and truncate the address to the page boundary which can
    annotate more memory than needed as being used by the FF-A.

> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index 14aa37846059a..bb01d8f830561 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> @@ -352,7 +352,7 @@ static u32 __ffa_host_share_ranges(struct ffa_mem_reg=
ion_addr_range *ranges,
>  		u64 sz =3D (u64)range->pg_cnt * FFA_PAGE_SIZE;
>  		u64 pfn =3D hyp_phys_to_pfn(range->address);
> =20
> -		if (!PAGE_ALIGNED(sz))
> +		if (!PAGE_ALIGNED(sz | range->address))
>  			break;

[Severity: High]
This isn't a bug introduced by this patch, but I have a question about the
error handling when ffa_host_share_ranges() fails due to these alignment
checks.

If the host kernel issues an FFA_MEM_FRAG_TX SMC with a valid fraglen but an
invalid handle_lo or handle_hi, and a fragment whose descriptor contains an
unaligned address, ffa_host_share_ranges() will fail.

Looking at do_ffa_mem_frag_tx() in arch/arm64/kvm/hyp/nvhe/ffa.c:

do_ffa_mem_frag_tx() {
    ...
	ret =3D ffa_host_share_ranges(buf, nr_ranges);
	if (ret) {
		/*
		 * We're effectively aborting the transaction, so we need
		 * to restore the global state back to what it was prior to
		 * transmission of the first fragment.
		 */
		ffa_mem_reclaim(res, handle_lo, handle_hi, 0);
		WARN_ON(res->a0 !=3D FFA_SUCCESS);
		goto out_unlock;
	}
    ...
}

Because the host provided a bogus handle, the SPMD firmware will reject this
reclaim and return an error (e.g., FFA_INVALID_PARAMETERS). Doesn't this ca=
use
the WARN_ON() to fire, leading to a fatal hypervisor panic triggered by
untrusted host input?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260630102058.3219=
867-2-sebastianene@google.com?part=3D5
