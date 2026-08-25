Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2DA63EDE42
	for <kvmarm@lists.linux.dev>; Tue, 25 Aug 2026 09:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787649499; cv=none; b=bEzLVWpUg7FxSRjzrFKPMjXXZjVaHwZHNAwVHq4TeiKz4mGDqhKh3RB0n3chwZLTSNGPhVduE+koD4QV3h24lXGhcU83TcypGLqzq0iA+O+af+sRhXYby5WMgKXlru+4VGvkVb5DKuiFwQRgiCXVnc2wwV5UvaW9KqusOrweyrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787649499; c=relaxed/simple;
	bh=V7evrKTnx9JCsxJ5fp5RU5JhUVhU6ff2+S3b+Lc0YZE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=kaR5EOzTZnDZ/TB8gYUIoPMnInJIaoChetD3jbp9gAitUSQ4niPauMgNiuUPXOS6O1fYk6A8t880J+fUIfxMhqwQQbEeTgMRheWJT4H7xbxyrhhw4YGcjdo/DWObBwJVXSFUupGuOyx6C6Fg36m1vosUK/G/OBQIcjonyarxbrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R1npv4WN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R1npv4WN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F361E1F00A3A;
	Tue, 25 Aug 2026 09:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787649497;
	bh=KYCwRnhxG4FtUSbxkf8Es8ZPoM3/qMnv+YgfCrJzMsI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=R1npv4WNytlIf8lYIkPJ+u8AIJZzFo8H6Mlt/viiwudb0Vxii/xsZRUUpdTWEFmhK
	 +kx2L3GcuujaD3Lsl+JBp8rIctlYIJE/JimmhMcRug88k7hylpwUO6j8UpiK23CVtm
	 7opplLCvUIZ2Ko2EROvXX/1xTsCnmFTvgoXLvXfWvlsr/QCUvXdXAPwajw5V4BI7vh
	 oexQLpOnUYnsJ+lT6PW9xfAIfZ3V246r4JFAtLZKF3xGJt5YnXuYs4XCvgnUW3/SFj
	 4xdk0iLvdp1UeRN4zJLAGfc6Y6o5odYfnl8HDEpJS3YDOvCg3ghDCOI9kc65uEEaCc
	 UqSjHoNJpJC9Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/4] KVM: arm64: Do not clear VM-wide SVE feature on
 vCPU init failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260825085948.1674721-3-fuad.tabba@linux.dev>
References: <20260825085948.1674721-1-fuad.tabba@linux.dev>
 <20260825085948.1674721-3-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 25 Aug 2026 09:18:16 +0000
Message-Id: <20260825091816.F361E1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Hypervisor DoS via WARN_ON() upon page table allocation failure
--

--- Patch [2]: [PATCH 2/4] KVM: arm64: Do not clear VM-wide SVE feature on =
vCPU init failure ---
commit 1188c411e2a65143d7371d1038c2752c0f2de6c0
Author: Fuad Tabba <fuad.tabba@linux.dev>

KVM: arm64: Do not clear VM-wide SVE feature on vCPU init failure

pkvm_vcpu_init_sve() clears KVM_ARM_VCPU_SVE in kvm->arch.vcpu_features
when it fails, but vcpu_has_sve() tests KVM_ARCH_FLAG_GUEST_HAS_SVE,
which is left set. Later vCPUs on that VM then skip the SVE setup and
register with a NULL sve_state, which the guest's first FP access hands
to sve_load_state().

Return the error without touching vcpu_features.

> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkv=
m.c
> index c31b9d46b8b60..4340b13ee295b 100644
> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c

[ ... ]

> @@ -462,24 +462,19 @@ static int pkvm_vcpu_init_sve(struct pkvm_hyp_vcpu =
*hyp_vcpu, struct kvm_vcpu *h
>  	sve_max_vl =3D min(READ_ONCE(host_vcpu->arch.sve_max_vl), kvm_host_sve_=
max_vl);
>  	sve_state =3D kern_hyp_va(READ_ONCE(host_vcpu->arch.sve_state));
> =20
> -	if (!sve_vl_valid(sve_max_vl) || !sve_state) {
> -		ret =3D -EINVAL;
> -		goto err;
> -	}
> +	if (!sve_vl_valid(sve_max_vl) || !sve_state)
> +		return -EINVAL;
> =20
>  	sve_state_size =3D sve_state_size_from_vl(sve_max_vl);
> =20
>  	ret =3D hyp_pin_shared_mem(sve_state, sve_state + sve_state_size);
>  	if (ret)
> -		goto err;
> +		return ret;

[Severity: High]
This is a pre-existing issue, but can the call to hyp_pin_shared_mem()
trigger a hypervisor panic if EL2 memory is exhausted?

Looking at hyp_pin_shared_mem() in arch/arm64/kvm/hyp/nvhe/mem_protect.c,
it wraps the mapping allocation in a WARN_ON:

        if (p->refcount =3D=3D 1)
                WARN_ON(pkvm_create_mappings_locked((void *)cur,
                                                    (void *)cur + PAGE_SIZE,
                                                    PAGE_HYP));

At EL2 under nVHE/pKVM, WARN_ON() expands to a BRK instruction which panics
the hypervisor and brings down the host.

Since host userspace can repeatedly invoke KVM ioctls to create VMs or vCPUs
and exhaust the bounded EL2 memory pool, pkvm_create_mappings_locked()
might eventually fail and return -ENOMEM.

Does this allow an unprivileged host process to hit the WARN_ON and crash
the host system?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260825085948.1674=
721-1-fuad.tabba@linux.dev?part=3D2
