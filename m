Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A98C2DCBEC
	for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 18:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782241091; cv=none; b=pT8hzgWHiJ1wSiX6NflRx27XBlz2o0oKdsaI4XvgtVRbKssI/AxxCNMeelq/hvCn1nSK6c3TEHMcRbzwAsiHstyGUMEaM3Sr35D5TVC1D8bCsCG3TwqdZQ3igdYu595PsfUXk0DDN5XfCvJpf7p4Z/3ehZO4v19vCfXKgbZcr2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782241091; c=relaxed/simple;
	bh=MbZbCPYu3cHPEK6O2xnPjDTwbIs/5Rds52nWX3wUvCE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=iLQZtNHlpzzoWYGSvYhE/XHCdrcw2j9zPJJu3IIh+FIswTLyye968ZO3Cbf5E47zd80730OgFr/CJt3cCECzggCxQqraQOpeQuzsm8RYuiOiT7w7tg/wlzfhI8X9VR6cjZiGdTWREhB0m4eQ8ebtpBgVFhzT8yxADkW9Ks7hhys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fzlv29Df; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fzlv29Df"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08CC61F000E9;
	Tue, 23 Jun 2026 18:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782241090;
	bh=THgL3tbxunaKjvyboJqgRF55Yl3UykTVt1Og0GvvFfI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fzlv29Df7197SkR1EId1iTQH5Tf+Xgjbhra6rZQbNn2ERBBLREqEiKQp4R0IlTItb
	 G9IBEFYYzojCKj70RgreCUl/xDEdmTX+0HuNPP56MsNHitN8kJLw7qpVfSrpeynJLF
	 O+m0irsa/jgvmKd98jppW19jsiTqjyIgS5cC2MlXvTECv1zsgGemPpsyvlG11xnkcw
	 HOf7hAqwzRSm75N/SFNSoAN8Kcal8JMK56F9JS98SWRupX2T1liDam9BLoCswIWh74
	 lYSN7eXq3a6O2ARkylwBzrLnc2XJ9C4Npjif0bExs0pZ1Pzd37vlZsHmz7CDs4AkUd
	 Ege1s7BhHAEjA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 04/22] KVM: arm64: nv: Only shadow writable-dirty guest
 descs as writable
Reply-To: sashiko-reviews@lists.linux.dev
To: "Oliver Upton" <oupton@kernel.org>
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20260623184201.1518871-5-oupton@kernel.org>
References: <20260623184201.1518871-1-oupton@kernel.org>
 <20260623184201.1518871-5-oupton@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 23 Jun 2026 18:58:09 +0000
Message-Id: <20260623185810.08CC61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] Uninitialized or incorrectly evaluated `wr->dirty` field during St=
age-1 page table walks causes an infinite VNCR trap loop.

Pre-existing issues:
- [High] Write-Only VNCR mappings cause an infinite trap loop because KVM f=
alls back to `PAGE_KERNEL_NONE` but considers write faults resolved.
--

commit fb5a66a1eb4ac6175aad6cbbd38f45328f4f937b
Author: Oliver Upton <oupton@kernel.org>

KVM: arm64: nv: Only shadow writable-dirty guest descs as writable
   =20
KVM will soon add support for hardware dirty state management for nested
guests. In order to emulate dirty state transitions on the guest
desciptor, KVM will need to use read-only hardware mappings and re-walk
the guest page tables upon taking a permission fault.
   =20
Prepare by limiting shadow stage-2 and shadow VNCR translations to
read-only for writable-clean guest translations.

> diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
> index 86b499e7a9a06..7a84495a2e6d4 100644
> --- a/arch/arm64/kvm/at.c
> +++ b/arch/arm64/kvm/at.c
[ ... ]
> @@ -1317,6 +1317,7 @@ static void compute_s1_permissions(struct kvm_vcpu =
*vcpu,
>  			  (pan3_enabled(vcpu, wi->regime) && wr->ux));
>  	wr->pw &=3D !pan;
>  	wr->pr &=3D !pan;
> +	wr->dirty =3D !(wr->desc & BIT(7));

[Severity: High]
Could the unconditional use of BIT(7) here cause issues when S1PIE is
enabled?

With S1PIE, BIT(7) becomes PIIndex[3], so using it to evaluate the dirty
state might be incorrect.

Also, if the Stage-1 MMU is disabled, __kvm_translate_va() returns early
without initializing wr->dirty:

arch/arm64/kvm/at.c:__kvm_translate_va() {
        if (wr->level =3D=3D S1_MMU_DISABLED) {
                wr->ur =3D wr->uw =3D wr->ux =3D true;
                wr->pr =3D wr->pw =3D wr->px =3D true;
                return 0;
        }
        ...
}

Since wr->dirty remains false (0-initialized), could this lead to an
infinite VNCR trap loop? If wr->dirty is false, the shadow fixmap mapping
is downgraded to PAGE_KERNEL_RO in kvm_map_l1_vncr().

When a guest writes to the redirected register, kvm_handle_vncr_abort()
sees vt->wr.pw is true, considers the fault handled without injecting a
permission fault, and the hardware immediately retries and traps again.

> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index b247bc1d83fa7..dcc7d0cc7c952 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
[ ... ]
> @@ -1603,7 +1605,7 @@ static void kvm_map_l1_vncr(struct kvm_vcpu *vcpu)
> =20
>  	vt->cpu =3D smp_processor_id();
> =20
> -	if (vt->hpa_writable && vt->wr.pw && vt->wr.pr)
> +	if (vt->hpa_writable && vt->wr.pw && vt->wr.dirty && vt->wr.pr)
>  		prot =3D PAGE_KERNEL;
>  	else if (vt->wr.pr)
>  		prot =3D PAGE_KERNEL_RO;

[Severity: High]
This is a pre-existing issue, but how does this code handle Write-Only VNCR
mappings?

If a nested guest maps its VNCR page as Write-Only (which is possible using
POE/S1PIE), vt->wr.pr will be false. The logic here then falls through to
mapping it as PAGE_NONE:

arch/arm64/kvm/nested.c:kvm_map_l1_vncr() {
        ...
        else if (vt->wr.pr)
                prot =3D PAGE_KERNEL_RO;
        else
                prot =3D PAGE_NONE;
        ...
}

When the guest writes to the register, kvm_handle_vncr_abort() sees
vt->wr.pw is true, assumes the write fault is permitted, and returns 1
without injecting a fault.

The hardware then retries against PAGE_NONE and immediately traps again,
creating an infinite loop that can lock up the host CPU.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260623184201.1518=
871-1-oupton@kernel.org?part=3D4
