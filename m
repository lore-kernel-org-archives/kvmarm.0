Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE65D2F5A36
	for <kvmarm@lists.linux.dev>; Tue, 18 Aug 2026 09:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787046187; cv=none; b=TLFFW92KV/IaHydUvM8IRCtK6KNmjh/BeagOKVvYeZBFae5zJDjQIADCzDsCYOvD117FfYf3OgT/G2TLT26NfEHV1YSWcYQU4NAKbvY5XKY4LMf4q9e8d7PGe8GKxfDm1rJkvS5/pG5cdEGm/Z2vX227iXmb3UERbAFdjmHSiZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787046187; c=relaxed/simple;
	bh=V9/Rpi+RwVqMTgGBIviHbivNeytPhzAuFOrlC7RNIp8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=UR3d7PyPUiDOTmWp1wfY/s0GUzuPj5Fyd9BJMHtRflrFgiq3l0NP7cdK3gSfRkiMLmk8785R/3EMeKg9IP02CzbHBfaawd91mocb8m8QN5Dkw4X3rFyAX2W7kC/aDLYOzkN+OfTz1qxDx7/BTrh/EY8/IERCkk3Gm4knQOcNDj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VNjILgAy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VNjILgAy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 828891F000E9;
	Tue, 18 Aug 2026 09:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787046185;
	bh=KZSTsByPnj7cZyKTh6zZSDSHjLMrZCIc1cj7JNRusj0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VNjILgAy/8RIcrcIazSEfQYkd8qgzfUERDeulpa5kNj4juz+6CCNoAQcCSGvyXgQm
	 q0LH3e+8RIuPJZt+YoGEGM/+/VcpQRMvd+CbojTQmXOp0Pve3vWqhAw4fqTHlyvHvb
	 AmczW+j86zP7h04i8A45K7kK4GULiA/hVEwBy6INXKKuwziMdTB8yYKZAmjrou8Y5w
	 fsLs3yM0IGpq/8rT+ptUATWnozR+TiHL4cSStUy8BmqDIjXc0gXC/xUUNMFFfrOxrH
	 P1iis+eqn2eIMxoTqrzXanlvypXioctF/qILGolIXCcbKijMmGmCpRLJedug7wyZ75
	 qkbKZAkPOocNw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] KVM: arm64: Validate the SVE vector length in
 pkvm_vcpu_init_sve()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260818093117.2379344-1-fuad.tabba@linux.dev>
References: <20260818093117.2379344-1-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 18 Aug 2026 09:43:04 +0000
Message-Id: <20260818094305.828891F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] A fallible memory allocation failure inside `hyp_pin_shared_me=
m()` triggers a `WARN_ON()`, which results in a fatal hypervisor panic.
--

--- Patch [1]: [PATCH] KVM: arm64: Validate the SVE vector length in pkvm_v=
cpu_init_sve() ---
commit f011c5300d433db59b3f2b97e822b9e148c39b84
Author: Fuad Tabba <fuad.tabba@linux.dev>
KVM: arm64: Validate the SVE vector length in pkvm_vcpu_init_sve()

This commit updates pkvm_vcpu_init_sve() to validate the host-provided
SVE vector length before deriving its state size. This prevents an invalid
length from reaching the sve_state_size_from_vl() macro and triggering a
fatal EL2 WARN_ON().

> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkv=
m.c
> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
[ ... ]
> @@ -460,14 +460,15 @@ static int pkvm_vcpu_init_sve(struct pkvm_hyp_vcpu =
*hyp_vcpu, struct kvm_vcpu *h
[ ... ]
> +	sve_state_size =3D sve_state_size_from_vl(sve_max_vl);
> +
>  	ret =3D hyp_pin_shared_mem(sve_state, sve_state + sve_state_size);

[Severity: Critical]
This is a pre-existing issue, but looking at hyp_pin_shared_mem(), could a
memory allocation failure here trigger a fatal hypervisor panic?

If host userspace repeatedly creates VMs and vCPUs to exhaust the
hypervisor's memory pool, pkvm_create_mappings_locked() can return
-ENOMEM.=20

Because hyp_pin_shared_mem() wraps this fallible call in a WARN_ON():

arch/arm64/kvm/hyp/nvhe/mem_protect.c:hyp_pin_shared_mem() {
    ...
    for (cur =3D start; cur < end; cur +=3D PAGE_SIZE) {
        p =3D hyp_virt_to_page(cur);
        hyp_page_ref_inc(p);
        if (p->refcount =3D=3D 1)
            WARN_ON(pkvm_create_mappings_locked((void *)cur,
                                                (void *)cur + PAGE_SIZE,
                                                PAGE_HYP));
    }
    ...
}

And since WARN_ON() is fatal at EL2, does this allow unprivileged host
userspace to intentionally crash the host system if the allocation fails?

>  	if (ret)
>  		goto err;
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260818093117.2379=
344-1-fuad.tabba@linux.dev?part=3D1
