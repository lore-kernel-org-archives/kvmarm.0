Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793922095;
	b=V17OqKCUw3YsYCGGYTgB8p9sgju0+FFA6D38pm03LMCkhCaZMN2GbqjFFXF6XgEYAMvS
	 N7hQhfYrM2mgUCreGWsWx0fUVVsEllZiuY0RKsmfA+P2pnW993A4tluLfPhKETywtU9Qq
	 Ut/wSwswKEV/+YsOW9TCCnnHB6Vf615ZjUMCR9PPEqXBTVj0uhXM33tKyVBvM7lcDeCE0
	 Sid5xqNPoX3HMf0lA40ulPb+X/nIC5bMvXxOrnl1JBVahy9cykYR4GRro9Bp8nqwOoctY
	 3txup25mg/3g7IFfDsumql601FX8cMjY4nlT6M9YN+jd7KOYqfeBuCEvbSXosIwJmcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793922095;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=WYbhLKxHN01P51zEe2mBVQqMbcchWHUsW1p+VEoLFJo=;
	b=H6ncw8KljJBx8E1igTgcUBgkarycL+nGyX1LFejpgX03J9dSG1Dy1F8ZXWP7Bc7U4KCY
	 HOqakTKNMDXtVLJ+WarX2/cLAEBKvnqfQDkJ05ZIYmix2GpA7biIOB8a7Pef0OiNysW3f
	 MOtmK6KOtImzKjdpl7fyjAYAXlG//6LO5KSUD6bqfONmbfROkNGadq7fz9BmTZVRwXPep
	 7pvfzMTHg4pXXG7J0KnqfffA6K51Ten8amHWEM4ZqEvyKX7CZ+k0oClFtuwGUuOyLZuXu
	 cg0zMdVasn9dJ3SMdoevk36hVr4+DnUDCmywRhYDY/auBkWhfqRVKPmOokDwWjluCVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kVEru8Us;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E72E5606A326
	for <kvmarm@lists.linux.dev>; Thu,  5 Nov 2026 23:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kVEru8Us
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D5711F0089F;
	Thu,  5 Nov 2026 23:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793922094;
	bh=WYbhLKxHN01P51zEe2mBVQqMbcchWHUsW1p+VEoLFJo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kVEru8Usw35MhKQZk5G8W4o6JyroV2SEh0wc1rvbPb7ZHweSxHCqAH8pTUzXeYIQZ
	 zJ/Gf4pkDlLH4rDVHZj1Wurk/P4jl7HWN/jIkPJEd1MjNV7aCcceq5fspQsXG5AbwS
	 +WD1fpB2f9UFU0wHAlLy6mhY4ySOXKdUSZJipN5a+cNqqiF3DxZi7VkY6IxMeEjMq2
	 YcPEosUOJnRjKSnLhw6m6OzGJv4VS4e+3VMSMzmWfo/PC3v+Zd8aty+bot0/q2nudq
	 8zSj2XS1i5W+07QMUY668hjUmj7jOMiS7XBa54uiMT3zK2aIcqztnJuRKVkQV9vppF
	 DeWsH2MNhtLvA==
Message-ID: <sashiko-outbox-200389@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC] KVM: arm64: Document that overlapping MEM_SHARE and
 MEM_UNSHARE are unordered
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xuheng Li" <xuheng@cs.columbia.edu>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20261105-mem-share-unshare-v1-1-e4c7d12d5d1d@cs.columbia.edu>
References: <20261105-mem-share-unshare-v1-1-e4c7d12d5d1d@cs.columbia.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 23:41:34 +0000
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
- [Medium] KVM: arm64: hypercall doc gives insufficient condition for priva=
te region
--

commit 39c34714b27ef8c9e3ad559a667906cddd707b8b
Author: Xuheng Li <xuheng@cs.columbia.edu>

KVM: arm64: Document that overlapping MEM_SHARE and MEM_UNSHARE are unorder=
ed

This commit documents in Documentation/virt/kvm/arm/hypercalls.rst that
overlapping calls to ARM_SMCCC_KVM_FUNC_MEM_SHARE and
ARM_SMCCC_KVM_FUNC_MEM_UNSHARE for the same memory region are unordered with
respect to each other.

> diff --git a/Documentation/virt/kvm/arm/hypercalls.rst b/Documentation/vi=
rt/kvm/arm/hypercalls.rst
> index 7400a89aabf88..ad7082da1b9fc 100644
> --- a/Documentation/virt/kvm/arm/hypercalls.rst
> +++ b/Documentation/virt/kvm/arm/hypercalls.rst
> @@ -99,6 +99,16 @@ Revoke access permission from the KVM host to a memory=
 region previously shared
>  with ``ARM_SMCCC_KVM_FUNC_MEM_SHARE``. The size of the region is equal t=
o the
>  memory protection granule advertised by ``ARM_SMCCC_KVM_FUNC_HYP_MEMINFO=
``.
> =20
> +Calls to ``ARM_SMCCC_KVM_FUNC_MEM_SHARE`` and ``ARM_SMCCC_KVM_FUNC_MEM_U=
NSHARE``
> +for the same region that overlap in time, for example on different vCPUs=
, are
> +not ordered with respect to each other: a share that has not yet returne=
d may
> +take effect after an unshare of the region has returned, leaving the reg=
ion
> +shared. A share of a region that is not yet mapped is restarted after th=
e host
> +has mapped it, so such a share can remain pending for as long as the host
> +delays the vCPU. A guest must therefore not treat a region as private ag=
ain
> +until every ``ARM_SMCCC_KVM_FUNC_MEM_SHARE`` it issued for the region has
> +returned.

[Severity: Medium]
Is waiting until every issued ARM_SMCCC_KVM_FUNC_MEM_SHARE has returned
sufficient for a guest to treat the region as private again?

In the race described by the commit message, if vCPU A issues
ARM_SMCCC_KVM_FUNC_MEM_SHARE while the page is unmapped at stage-2, and vCP=
U B
issues ARM_SMCCC_KVM_FUNC_MEM_SHARE followed by
ARM_SMCCC_KVM_FUNC_MEM_UNSHARE, vCPU B's __pkvm_guest_unshare_host() returns
the page state to PKVM_PAGE_OWNED in the guest stage-2 and PKVM_NOPAGE in t=
he
host stage-2.

When vCPU A's pending ARM_SMCCC_KVM_FUNC_MEM_SHARE subsequently runs,
arch/arm64/kvm/hyp/nvhe/mem_protect.c:__pkvm_guest_share_host() sees the pa=
ge
back in PKVM_PAGE_OWNED state and shares it again:

	if (pkvm_getstate(kvm_pgtable_stage2_pte_prot(pte)) !=3D PKVM_PAGE_OWNED)
		goto unlock;
	if (__host_check_page_state_range(phys, PAGE_SIZE, PKVM_NOPAGE))
		goto unlock;

	ret =3D 0;
	WARN_ON(kvm_pgtable_stage2_map(&vm->pgt, ipa, PAGE_SIZE, phys,
				       pkvm_mkstate(KVM_PGTABLE_PROT_RWX, PKVM_PAGE_SHARED_OWNED),
				       &vcpu->vcpu.arch.stage2_mc, 0));
	WARN_ON(__host_set_page_state_range(phys, PAGE_SIZE, PKVM_PAGE_SHARED_BORR=
OWED));

Once vCPU A's call returns, every ARM_SMCCC_KVM_FUNC_MEM_SHARE issued for t=
he
region has returned, satisfying the documented condition, yet the region is
still shared with the host rather than private.

Should the documentation instead state that every prior
ARM_SMCCC_KVM_FUNC_MEM_SHARE for a region must have returned before issuing
ARM_SMCCC_KVM_FUNC_MEM_UNSHARE for the guest to treat the region as private
once the unshare succeeds?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-mem-share-=
unshare-v1-1-e4c7d12d5d1d@cs.columbia.edu?part=3D1
