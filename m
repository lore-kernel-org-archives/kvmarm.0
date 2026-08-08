Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 245FD229B18
	for <kvmarm@lists.linux.dev>; Sat,  8 Aug 2026 00:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786150756; cv=none; b=dtD8KjZOVylxt/HqHI/myuTAQGJjUMbRusNaHB4IX5gqPPVjiF3NLdNV/dqD1hyeETZmYqng65tuvoc4EnruWLgGyJ+l5yXQJGcoGGSW1G1CcNYQFpk8uY8BlsfkNE4hxuKDHG+4N9Va+Mmdqs+rWZxkDNT3q1Km5OF65bAa8KM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786150756; c=relaxed/simple;
	bh=fiixmHVoY87WR2DvBW9o2NL95qXZ3OpFQTS76hbtVpo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=rbIjVIyOU/8I4omaklSadcQXXYGyU8eRjlURbx1cez42U4MO0ZnmfqDJVt0Ifb3xEyJST0GjnBYCP0mJaFAUOpNm+/FfHQsVSlgUkLQgDzOQQZ3wm78Z5z8Jn4Vaa1hqMRM4HS4uLjR7at8ulfGwrLG5CsLgYTkOth91jbWD3ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bj5OElD4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bj5OElD4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 448D31F000E9;
	Sat,  8 Aug 2026 00:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786150754;
	bh=jVVYh5UKIl9kJ9I8oDG32e85s6Rw8ND8Oz2CUO/ltno=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Bj5OElD43Xh7o+NvQJPl3klNSXiynVcNSQbUw6KDr7ytWQ/sFgs+qlF/UZwZAfDzo
	 mCHdtf490KpyXgrZwRQ/lJrNzQlQMqfOcg8XpaC1XE8pAOGHSOETmZJT+hdmj9g2hU
	 37OHB5nC4Y/mWLrgWaCoVSlNVdD9pCu88kus9eV4BhmznBtvfL+ceoIrQS110vQr9Y
	 2YE9faEx4s5C9vielSR15MrSNt4xCZIURzHMRgzCXn1nQozoR/mRsA2YOjqUgU1aS8
	 e+A1zoradWoxtMT6TaE1PkHMl3g5ytaIXQXUDk900Bym2DMLHduHg2YO6H9XThyBf4
	 ij8KOwgRuBLtA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5] KVM: arm64: nv: Keep the shadow S2 MMUs at fixed
 addresses
Reply-To: sashiko-reviews@lists.linux.dev
To: "Karl Mehltretter" <kmehltretter@gmail.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260808003943.60963-1-kmehltretter@gmail.com>
References: <20260808003943.60963-1-kmehltretter@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 08 Aug 2026 00:59:13 +0000
Message-Id: <20260808005914.448D31F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] `kvm_arch_flush_shadow_all` incorrectly frees the fixed `nested_mm=
us` pointer table, causing a guaranteed NULL pointer dereference on subsequ=
ent VCPU initialization.
- [Low] Inconsistent error path label ordering in `kvm_vcpu_init_nested` by=
passes the cleanup of `vncr_array` if MMU object allocation fails.
--

--- Patch [1]: [PATCH v5] KVM: arm64: nv: Keep the shadow S2 MMUs at fixed =
addresses ---
commit f14f067b1d63cdcaee4dee273e4e4dcdb1e8d284
Author: Karl Mehltretter <kmehltretter@gmail.com>

KVM: arm64: nv: Keep the shadow S2 MMUs at fixed addresses

This commit refactors nested S2 MMUs to use a fixed-size pointer table
allocated during VM creation. The MMU objects are allocated separately so
their addresses remain stable, fixing a use-after-free bug.

> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
[ ... ]
> @@ -82,52 +95,46 @@ int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
[ ... ]
> +	for (i =3D 0; i < S2_MMU_PER_VCPU; i++) {
> +		mmu =3D kzalloc_obj(*mmu, GFP_KERNEL_ACCOUNT);
> +		if (!mmu) {
> +			ret =3D -ENOMEM;
> +			goto err_free_mmus;
>  		}
[ ... ]
> +err_free_vncr:
> +	free_page((unsigned long)vcpu->arch.ctxt.vncr_array);
> +	vcpu->arch.ctxt.vncr_array =3D NULL;
> =20
> -	kvm->arch.nested_mmus_size =3D num_mmus;
> +err_free_mmus:
> +	while (i--)
> +		free_nested_s2_mmu(kvm->arch.nested_mmus[kvm->arch.nested_mmus_size + =
i]);
> =20
> -	return 0;
> +	return ret;
>  }

[Severity: Low]
Does this error path unwind in the correct order?

If kzalloc_obj() fails during initialization, the code jumps to the
err_free_mmus label, which completely bypasses the cleanup in err_free_vncr.

This leaves the newly allocated vncr_array anchored to
vcpu->arch.ctxt.vncr_array instead of freeing it immediately. While it will
eventually be freed when the VCPU is destroyed, this seems to create an
inconsistent state compared to the other error paths in this function.

[ ... ]
> @@ -1272,10 +1279,10 @@ void kvm_arch_flush_shadow_all(struct kvm *kvm)
>  	int i;
> =20
>  	for (i =3D 0; i < kvm->arch.nested_mmus_size; i++) {
> -		struct kvm_s2_mmu *mmu =3D &kvm->arch.nested_mmus[i];
> +		struct kvm_s2_mmu *mmu =3D kvm->arch.nested_mmus[i];
> =20
>  		if (!WARN_ON(atomic_read(&mmu->refcnt)))
> -			kvm_free_stage2_pgd(mmu);
> +			free_nested_s2_mmu(mmu);
>  	}
>  	kvfree(kvm->arch.nested_mmus);
>  	kvm->arch.nested_mmus =3D NULL;

[Severity: High]
Can this lead to a NULL pointer dereference on subsequent VCPU
initialization?

The patch redesigns nested_mmus to be a fixed-size pointer table allocated
once at VM creation. However, it appears this legacy cleanup remains, freei=
ng
and nulling kvm->arch.nested_mmus when kvm_arch_flush_shadow_all() runs.

If a VM's file descriptor is kept alive by another process, and a
subsequent KVM_ARM_VCPU_INIT ioctl is issued, kvm_vcpu_init_nested() will
attempt to append to the array:

    kvm->arch.nested_mmus[kvm->arch.nested_mmus_size + i] =3D mmu;

Since the dynamic reallocation logic was removed in this patch, nested_mmus
will still be NULL here, triggering a kernel panic. Should this teardown
path avoid freeing the array itself now?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260808003943.6096=
3-1-kmehltretter@gmail.com?part=3D1
