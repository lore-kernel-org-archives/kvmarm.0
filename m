Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F19E3BB118
	for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 13:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782482299; cv=none; b=Ka/L5L199lUwUbeoe3iVvOribhD0a1lXrRYCMQM9Ty7LbVsY/eA5V1xQV3R6C7sVHSFqh11gguzNj8ANXQNJDs646DkStMlM4b/T7gSRFao4/OIc2RLkCrB8gkCoRQzjL9jSMps9b7B+V3+LlOWZTuo8yGFZMs//sTpuhrm6ZKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782482299; c=relaxed/simple;
	bh=HuKd4+hFWd0HoC9TncWQbvtNRRsJDjGkzqQgS8zNHos=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=cCpJ3P0I8Du+2klgovXlzB0a5FKY8W0JKgOI8BlrG3bZNO9dIYZ85euubgrIkpWk51kVZTtLCz4wTCLTFyCo9TrkuixuFdXi+vyXe3JlPmWAxyfmySLlC7/zhonbiMep3RG1JPdMkSAH6JQ2mWMJrOf6TarYzlLzOtuPnRA5Tsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KRoYRiE2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KRoYRiE2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DA521F000E9;
	Fri, 26 Jun 2026 13:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782482297;
	bh=dnlwHKiqrnxPB7g8OdSqhLvB8RcCJtgThe+BcHpMYZA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KRoYRiE2dwuhKKn4+W5OrrNXty27WWis3lrrwklrdfiZDA+Bzx07TTtaqdIA7LXxy
	 G4LKE9VEjf/C6nVfo1JMDvfriIYYGTY2kxo6elwH8z48HLIQs8DfxGcEPiCitXGQJC
	 L7KD9WYyZezVPu0XbJ3fyvp82yHzRc/3U7i2pS9FXuvr7QKeOxByWtlLHfKAq0VHCm
	 hBAlK9C8FF72fQ4FUZOoQzrOP+NkU64RcmDjSisGOI1JJgSDKjCc0L0hwJlAv8Su6U
	 YsNWRsRdsV5YR96FoZjA5ihBU15ghI6lrXCHrSVFOaj65u4MQGi2Dvma5VEgbT/bbI
	 Izm7n8tGLUgQA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6.12] KVM: arm64: Take the SRCU lock for page table
 walks in fault injection and AT emulation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexander Martyniuk" <alexevgmart@gmail.com>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260626134210.228892-1-alexevgmart@gmail.com>
References: <20260626134210.228892-1-alexevgmart@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 26 Jun 2026 13:58:16 +0000
Message-Id: <20260626135817.3DA521F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Stage-2 translation table walk failures (e.g., unbacked memory) re=
turn negative error codes without populating the ESR or updating PAR_EL1, l=
eaving the stage-1 IPA in PAR_EL1 as a false success.
--

commit 6d7bd74abe7bde3942c024259e9d4015f378779c
Author: Hyunwoo Kim <imv4bel@gmail.com>
Date:   Fri Jun 26 13:42:07 2026 +0000

KVM: arm64: Take the SRCU lock for page table walks in fault injection and =
AT emulation

This commit fixes missing SRCU lock acquisitions during page table walks in
AT emulation and fault injection. It wraps the calls to kvm_walk_nested_s2
and __kvm_find_s1_desc_level with scoped_guard to ensure they are protected.

Link: https://patch.msgid.link/aiAZfdeyanIvP8SD@v4bel

> diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
> index 39f0e87a340e8..8192bc0bbc87b 100644
> --- a/arch/arm64/kvm/at.c
> +++ b/arch/arm64/kvm/at.c

[ ... ]

> @@ -1087,7 +1087,8 @@ void __kvm_at_s12(struct kvm_vcpu *vcpu, u32 op, u6=
4 vaddr)
>  	/* Do the stage-2 translation */
>  	ipa =3D (par & GENMASK_ULL(47, 12)) | (vaddr & GENMASK_ULL(11, 0));
>  	out.esr =3D 0;
> -	ret =3D kvm_walk_nested_s2(vcpu, ipa, &out);
> +	scoped_guard(srcu, &vcpu->kvm->srcu)
> +		ret =3D kvm_walk_nested_s2(vcpu, ipa, &out);
>  	if (ret < 0)
>  		return;

[Severity: High]
This is a pre-existing issue, but does this early return incorrectly skip
updating PAR_EL1 with a translation fault?

If a nested guest (L1) executes an AT S12E1R instruction pointing to an
unmapped IPA, __kvm_at_s1e01() successfully translates stage-1 and sets
PAR_EL1 to the IPA. Then, when kvm_walk_nested_s2() attempts to read the
stage-2 descriptor, it can fail (e.g., returning -EFAULT from unbacked
memory in walk_nested_s2_pgd()):

walk_nested_s2_pgd() {
        ...
        ret =3D wi->read_desc(paddr, &desc, wi->data);
        if (ret < 0)
                return ret;
        ...
}

When this negative error code propagates back here to __kvm_at_s12(), we
return immediately. Because compute_par_s12() is bypassed, PAR_EL1 is never
updated with the fault status.

Could this leave the L1 guest to incorrectly observe a successful translati=
on,
mistaking the IPA for the final PA? Should this path populate the ESR and
update PAR_EL1 before returning?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260626134210.2288=
92-1-alexevgmart@gmail.com?part=3D1
