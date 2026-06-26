Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C2AE3C10A7;
	Fri, 26 Jun 2026 21:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782510203; cv=none; b=o86Bt3tp0TEvM1aRXKDKze/J9FPlaF8L9rwxaAAIaMgQrITT5R/VJcB6tcHQe7uVOv64vXHP5w3r5Od9WY8mmod8rxxeDuj7TaqgXd8x21G99CcA71yLewKC95m5YJyCgzpgDk0d+KBGV8ddn1PgcZ47pwxxob10mz+Nq4pvAyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782510203; c=relaxed/simple;
	bh=hD7A/LvhIgMaoKfVfwomxwVj69xJb4iSvRpNSnOeROY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=fNbPDr/O0CtqmIu4b01lKLs2ldEIK/ULgZbHUTQ5TDzG2p6ALPomwWQHnTRBjeFsnG82RBfylve4kXjXJyIgBYJaLEWC3IRObdJS0ctWneLVYZ26FDkzkjFOFIMcnzj/Yzr/+cytL56paUR975UjIWpTvA4E6VkJ9Ky7jtu9ElI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=heifRiDR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="heifRiDR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADB201F000E9;
	Fri, 26 Jun 2026 21:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782510201;
	bh=WtywsyDUBQb9Q3ry1cFLSJy+zFrx34gsASjo9GYMn6w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=heifRiDRVHUNoHwJ4ZAJ2pQ5RALwPwZplxpKYhZKTKt1nk2+/YLvTrsJF0mQDvsG4
	 93OUtBnIGKAEIKwHKymPkHeuUQkt5LbxsOORVSh5v1T9Mgha0mxdy1IcDg3R0Ow4EP
	 xpiE2zuMvSSCB1o74Y6kUrbhLk9GFJ0U7V7rYRC7FDSd0zahxgcPjMhKLqph3H4Jng
	 5KrgMx8IXOvVMxp+8W09+N9NINiJgvttNJ+h67ZVCB74Zo2nRx/FX661+roDpfPY76
	 1vKykQd1irLVQbTeB5DcJjfuX8xYFWkWxBDuss9+SAUcOnhq+O1ifGLXJk5K6GWsEL
	 AoylSx7xwzjKg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 05/20] KVM: selftests: Seed libc's RNG before using
 it to generate a seed for KVM's pRNG
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sean Christopherson" <seanjc@google.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260626213534.3866178-6-seanjc@google.com>
References: <20260626213534.3866178-1-seanjc@google.com>
 <20260626213534.3866178-6-seanjc@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 26 Jun 2026 21:43:20 +0000
Message-Id: <20260626214320.ADB201F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The KVM pseudo-random number generator gets trapped generating o=
nly 0s if `random()` returns 0 or 2147483647.
--

commit cb357af51bf4702a2c21b353556fb23a80cc5efe
Author: Sean Christopherson <seanjc@google.com>

KVM: selftests: Seed libc's RNG before using it to generate a seed for KVM'=
s pRNG

This commit initializes the libc RNG with the current time before using it
to generate the initial seed for KVM's selftest pseudo-random number
generator.

> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/s=
elftests/kvm/lib/kvm_util.c
> index 1016865d3f7a2..277166ab1aa99 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c

[ ... ]

> @@ -2284,6 +2285,7 @@ void __attribute((constructor)) kvm_selftest_init(v=
oid)
>  	sigaction(SIGILL, &sig_sa, NULL);
>  	sigaction(SIGFPE, &sig_sa, NULL);
> =20
> +	srandom(time(0));
>  	kvm_seed_rng(random());

[Severity: Medium]
Can this cause the KVM PRNG to get stuck returning only 0s, resulting in
intermittent test failures?

If random() happens to return 0 or 2147483647 (the modulus), passing it
to kvm_seed_rng() will cause the Lehmer LCG calculation in kvm_random_u32()
to permanently evaluate to 0:

tools/testing/selftests/kvm/lib/test_util.c:kvm_random_u32() {
    ...
    state->seed =3D (u64)state->seed * 48271 % ((u32)(1 << 31) - 1);
    return state->seed;
}

When state->seed becomes 0, all subsequent PRNG calls will endlessly return=
 0.
Does it make sense to sanitize the result of random() here to avoid these
pathological seeds?

> =20
>  	kvm_selftest_arch_init();

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260626213534.3866=
178-1-seanjc@google.com?part=3D5
