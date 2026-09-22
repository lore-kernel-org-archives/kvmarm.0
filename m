Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E63542810
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 13:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790083533; cv=none; b=sDpiN6+kkfkl/BrJJ5ihPs65W6fcZ2FOZkr7QBfx7vx0M9YZlS9+qF3f6e+ZjTs+tCWVW801DSg/vS6YzV7+Ur8qiAAdoE62zGE7UMhui0zq8F5U/gKwEGQDOJdGr2rU0BpZGhDKvqSG/i+F8mBkktHlEj/d8ZcYkfhe6W7c2Rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790083533; c=relaxed/simple;
	bh=yocfUNLd+wGI+Hup/mFOCqFAWgnwWJKtRAOjrneCiVw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=rcnYEDXOMX0w3aQXxbkknpU7mB1f8n2Gjy+LEXvczkdy+kVh3a9EB5R4cET0C7nmaHepNWcW9QGNOHkZbEtt5RmK5u7DXHv89dfiHCWOUoQRqOGx6/tGG0CPCMyJ3PC5TOeNSMG8wyyqtgR2DxxFc9p4lFPR113XxlOCFLoMr34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kBqCp4k/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kBqCp4k/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E3C91F000FF;
	Tue, 22 Sep 2026 13:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790083531;
	bh=BLoQrRj7hMfKqrI8oQq+KfHMIYhfQlKpcPv7C3i/BZs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kBqCp4k/5XHhiCgsO1AZmnTuaznB4v5EUEsc2Y1h+ArUfidBIMZE6lwERSPA8sO/5
	 JfnVeeNMz5pJRSDnb+FbzK521iYutNCjfKxMzWSMWL90HsxC4zZ4SkmxkFUK+Y9Vd5
	 CFlvl8UFSq0vrPlU5q0Bxp0JvtZdQWpzi7rSV4hYEoruJc/WpjdHW54TEugeFKOvQb
	 uVemRcmeq4wUOvcerPgki5StAW60K1tJPCaz2wjQU6ncgovh1EDjRsL+2Abj0hl+UF
	 fssdhTyIKNCR2rurR+DN/FRzf11R3t1X0Wc9iaCI3p9b47QLnrL0Apo2FFzOYFZ9kh
	 H5TMwgXpnusYA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 08/25] KVM: arm64: iommu: Add memory pool
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mostafa Saleh" <smostafa@google.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260922131259.2975334-9-smostafa@google.com>
References: <20260922131259.2975334-1-smostafa@google.com>
 <20260922131259.2975334-9-smostafa@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 13:25:30 +0000
Message-Id: <20260922132531.4E3C91F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] kvm: incorrect WARN_ON() on expected OOM during IOMMU shadow pag=
e table allocation
- [Low] kvm: math error in early_iommu_pgt_mem() bounds check artificially =
limits IOMMU pool to 4GB
--

commit c0283e6a54103e1cdad88307cf87917d222a0087
Author: Mostafa Saleh <smostafa@google.com>

KVM: arm64: iommu: Add memory pool

This commit introduces an IOMMU memory pool for shadow page tables, allocat=
ing
it early from the KVM carveout based on the kvm-arm.iommu_pgt_mem command
line parameter.

> diff --git a/arch/arm64/kvm/hyp/nvhe/iommu.c b/arch/arm64/kvm/hyp/nvhe/io=
mmu.c
> --- a/arch/arm64/kvm/hyp/nvhe/iommu.c
> +++ b/arch/arm64/kvm/hyp/nvhe/iommu.c
[ ... ]
> @@ -122,6 +123,14 @@ int pkvm_iommu_init(void)
>  	    !pkvm_iommu_ops->host_stage2_idmap)
>  		return 0;
> =20
> +	if (!nr_pages)
> +		return -ENOMEM;
> +
> +	ret =3D hyp_pool_init(&iommu_pages_pool, hyp_virt_to_pfn(pool_base),
> +			    nr_pages, 0);
> +	if (ret)
> +		return ret;
> +
>  	ret =3D pkvm_iommu_ops->init();
>  	if (ret)
>  		return ret;

[Severity: Medium]
Does wrapping pkvm_iommu_snapshot_host_stage2() in WARN_ON() safely
handle expected out-of-memory conditions?

Looking at the rest of pkvm_iommu_init(), it ends with:

	return WARN_ON(pkvm_iommu_snapshot_host_stage2());

The snapshot function walks the host page tables and allocates memory for
IOMMU shadow mappings from the fixed-size pool configured by the host via
kvm-arm.iommu_pgt_mem.

If the user-provided pool is too small, the allocation fails and returns
-ENOMEM. At EL2, WARN_ON() expands to a fatal BRK instruction, which panics
the hypervisor and crashes the host.

Could we return the error directly without panicking, since this turns a
recoverable initialization failure into a host-trusted denial of service
vector?

> diff --git a/arch/arm64/kvm/iommu.c b/arch/arm64/kvm/iommu.c
> --- a/arch/arm64/kvm/iommu.c
> +++ b/arch/arm64/kvm/iommu.c
[ ... ]
> +static int __init early_iommu_pgt_mem(char *arg)
> +{
> +	unsigned long long requested_size;
> +
> +	if (!arg)
> +		return -EINVAL;
> +
> +	requested_size =3D memparse(arg, NULL);
> +
> +	if (requested_size > UINT_MAX) {

[Severity: Low]
Is this math check bounding the IOMMU pool size to 4GB?

The early_iommu_pgt_mem() function parses the user-requested size into
bytes, and bounds requested_size against UINT_MAX.

Since the target variable hyp_kvm_iommu_pages stores a page count as an
unsigned int, the byte limit could safely be much larger, up to
(u64)UINT_MAX * PAGE_SIZE.

Does this artificially reject valid configurations on systems with massive
RAM that might require larger page table pools?

> +		kvm_err("kvm-arm.iommu_pgt_mem is too large\n");
> +		return -EINVAL;
> +	}
> +
> +	kvm_nvhe_sym(hyp_kvm_iommu_pages) =3D DIV_ROUND_UP(requested_size, PAGE=
_SIZE);
> +	return 0;
> +}
> +early_param("kvm-arm.iommu_pgt_mem", early_iommu_pgt_mem);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922131259.2975=
334-1-smostafa@google.com?part=3D8
