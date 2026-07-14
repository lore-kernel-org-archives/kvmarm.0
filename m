Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CA3043F4B5;
	Tue, 14 Jul 2026 09:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784022489; cv=none; b=dRLJ1hkGf34YS/tcQ/iRMwDHUGJAgwcalbRONH8j2Aie8+Lqld7RKJRa0UgdOxn440+NMNWLb+5TT04ViVyxRYV3X9PvUCz1t9t4zV7Y6Bj5YSM0meD2hdhb+QoiNwDDGGxpExqbKbjCf06OsTYzTwACkGw2ST759jriBN1FS+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784022489; c=relaxed/simple;
	bh=rBaQSpN6PLbdyg/Mnd3Njbzm22x7FFxu6sD4tLtdwr0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=uifOwiNQGt38tPhthfhYeS8uPnVij8BqQ1wZOJqDJ9Hoy2lNA2oYaB03xWLat4TRFrSuK79LrH2oAIKcysUzQPbFpkfBc4Gd8HyZNsrypeYWFd7mlSyTaf8pl7innusZhHIaDjU8ZL6ldtthk74Z9MvoVcVHtB381OYwyrIkbaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JpzsGFcf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JpzsGFcf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3C371F000E9;
	Tue, 14 Jul 2026 09:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784022483;
	bh=bGK0ER9Hb6NMoajTKYxaP18onOXcqieGADslBbXzSOg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JpzsGFcfiEmEVA7rMVE0EKu8V/MxwWWDkbE0uX0k4yJGtgx8Vq47jVyErP4a1QsnH
	 BQfnzoJSy9lSZut5k4DV5GeziVvo0vQ+znhuzOLtLNCmmnyKSKxJr/0/iKRhUGKSTh
	 ey+YQ1VJIH/snqsUVVyM6YUaKENtBSgeMwny4znIf/+vkILoKIuCmCNeXKRMMsXMVL
	 sHYg2/p4o4lTQiQ6YW3kPyMS2GD1phPnhmOvVB9BT/9R6jBhkje2oCdieZtwu4xBWB
	 AlWFUfmTD5NsVe/7+i4W/Swx88Zra/hBwjqbJ0K1YQPgQe4FaEj2HFn6zHAtpBjm1q
	 gEAOEO2l6K2Lw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 18/28] KVM: arm64: Add kvm_has_nv{2,3}() predicates
Reply-To: sashiko-reviews@lists.linux.dev
To: "Marc Zyngier" <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>, kvm@vger.kernel.org
In-Reply-To: <20260714091641.1970822-19-maz@kernel.org>
References: <20260714091641.1970822-1-maz@kernel.org>
 <20260714091641.1970822-19-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 14 Jul 2026 09:48:03 +0000
Message-Id: <20260714094803.B3C371F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] kvm_has_nv3() will always return false because ARM64_HAS_NV3 is =
never populated in the capabilities bitmap.
--

--- Patch [18]: [PATCH v2 18/28] KVM: arm64: Add kvm_has_nv{2,3}() predicat=
es ---
commit e61ff01470e9cbe730c6702e605c3c17d525ca4e
Author: Marc Zyngier <maz@kernel.org>

KVM: arm64: Add kvm_has_nv{2,3}() predicates

This commit adds a new set of predicates indicating whether a VM is capable
of NV2, NV3, and is in a nested NV3 context.

> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/as=
m/kvm_emulate.h
> index 9831166695186..c562d8171d5e1 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h

[ ... ]

> +static inline bool kvm_has_nv3(struct kvm *kvm)
> +{
> +	return (cpus_have_final_cap(ARM64_HAS_NESTED_VIRT) &&
> +		cpus_have_final_cap(ARM64_HAS_NV3) &&

[Severity: Medium]
Will kvm_has_nv3() always return false here?

It appears the ARM64_HAS_NV3 capability was added to the cpucaps tools, but
the corresponding hardware detection entry is missing from the arm64_featur=
es
array in arch/arm64/kernel/cpufeature.c. Since it is never populated,
cpus_have_final_cap(ARM64_HAS_NV3) will unconditionally evaluate to false,
turning any code relying on this predicate into dead code.

> +		kvm_has_feat(kvm, ID_AA64MMFR4_EL1, NV_frac, NV3));
> +}

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260714091641.1970=
822-1-maz@kernel.org?part=3D18
