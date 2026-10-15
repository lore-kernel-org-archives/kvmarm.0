Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B739E4A5EC6
	for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 20:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792095499; cv=none; b=saMUmA3a/dUdHYh6EKv+0xZpR/mNoDEzgyXfh2dMNQx5J3DUoQuKYavM1dEN8KLUXJ2wihf4wYMP8R0Ohfz1sAmT0H7mtx8DJ4XE/zvbtOWpd5sJviwowWClN9ujooGW2xcF14mz4aWQ9E1MWzAY1YoVjuSixzIpmJXTXDeS1MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792095499; c=relaxed/simple;
	bh=23DhRl7o6KMSa1dy0jWxpoL3ZSV84cSUPv9QDJHPs/g=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=pjGH615oggzvZ2+zDJtrTxIvLu3OQf1Tq2jUIKlSMMJdpLXTx+iVhkTLiZOJkndjZBRSUBkAwl6wy6FSdRCEXLosZoVP3mgYFXSGmuvkGbyAxlyHVrrM4OjAIOiPXbwPtvtg2TJp/3CJ90WPEnukZwoNA60CnWLq/JsIgwl+a58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D9G7aG+n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D9G7aG+n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26F011F000C4;
	Thu, 15 Oct 2026 20:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792095498;
	bh=mSDS/xcKbaVgsUHkpjH8YeMebF3B0/5QZ8OnqmUneJM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=D9G7aG+nO28ZbWXFdPXyaYcjxqNDpZ8v1U0G6p/iz56KRMec/wIgWp96SPUHM3PJP
	 xM2apVSdPGB0p/CQVt/0BA13oGnngZ+MT5zIdMlzS6bXdWTvTY/MjBhYZ9cw+wvJnH
	 Mmpcd4QZSlsjZUOhKIc3h+9w4VFIyLgvR2hiss1J31vcz4Xn4Q3HhA9vyYSaqG9zyc
	 OEOnYRPcukOCfJGcoGlJJ7IfOrracgGMPBQjMktJgNHNBkLZ/ftMDlff8awfCmAh0T
	 iT+TjCQIlF3AWMIIKehvuKSXPD5TAHRbGxox+e1uiwD738+aF4fcRWy/tOJ8gLghAr
	 T7Pz+agfvmFOA==
Message-ID: <sashiko-outbox-173376@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 08/25] KVM: arm64: iommu: Add memory pool
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mostafa Saleh" <smostafa@google.com>, kvmarm@lists.linux.dev
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261015200903.2735565-9-smostafa@google.com>
References: <20261015200903.2735565-1-smostafa@google.com>
 <20261015200903.2735565-9-smostafa@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 15 Oct 2026 20:18:17 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] kvm: fatal EL2 panic on IOMMU pool exhaustion
--

commit 4301acf34cc06e2a4b1fab6b934f06ba07d48a9d
Author: Mostafa Saleh <smostafa@google.com>
Subject: KVM: arm64: iommu: Add memory pool

This patch reserves a memory pool for the IOMMU driver's shadow page tables
early during boot based on the kvm-arm.iommu_pgt_mem command line parameter.
The driver later allocates from and frees to this pool at runtime in
protected KVM mode.

> diff --git a/arch/arm64/kvm/hyp/nvhe/iommu.c b/arch/arm64/kvm/hyp/nvhe/io=
mmu.c
> --- a/arch/arm64/kvm/hyp/nvhe/iommu.c
> +++ b/arch/arm64/kvm/hyp/nvhe/iommu.c
> @@ -115,6 +117,11 @@ int pkvm_iommu_init(void)
>  	    !pkvm_iommu_ops->host_stage2_idmap)
>  		return 0;
> =20
> +	ret =3D hyp_pool_init(&iommu_pages_pool, hyp_virt_to_pfn(pool_base),
> +			    nr_pages, 0);
> +	if (ret)
> +		return ret;
> +
>  	ret =3D pkvm_iommu_ops->init();
>  	if (ret)
>  		return ret;

[Severity: High]
Will this trigger a fatal hypervisor panic if the host specifies an undersi=
zed
pool?

The size of the newly introduced iommu_pages_pool is directly controlled by
the host via the kvm-arm.iommu_pgt_mem command line parameter. If the
host-provided pool size is too small, pkvm_iommu_snapshot_host_stage2()
called immediately after this will exhaust the allocator and return -ENOMEM.

Because pkvm_iommu_init() wraps that call in a WARN_ON():

	return WARN_ON(pkvm_iommu_snapshot_host_stage2());

and WARN_ON() at EL2 in nVHE/pKVM expands to a fatal BRK instruction, this
exhaustion will crash the entire machine.

Could this be updated to propagate the error back to the host, instead of
treating hyp_alloc_pages() failure as a fatal invariant violation?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261015200903.2735=
565-1-smostafa@google.com?part=3D8
