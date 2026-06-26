Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA5DD3B38BB;
	Fri, 26 Jun 2026 21:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782510502; cv=none; b=NtQcYZPLUlJKN8eT5FAfjO23ThMmnvhxfC0enS5B2NC7XYFt5T7zBgFGeX+BkT03qPxmZBa/afJZzJaeDGAw+kQFrhsswMGFxod/FVEz/gAPRdmOyMeDA4MNbOmNXDY6x6wxFPglbnchV2ITHDcGcMaW9SNLex1O6f8Lod4G+LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782510502; c=relaxed/simple;
	bh=TMwVFhZAUXahtJ9sidOBv9aqseTj59ulA0N0Ta1Dl8Y=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=eV8I8F1YtvY45EQIPqrinZB3ihF7FwoKK4p3ZwBw0aoQXpcMg5kJEqfFR4X+UuIFeE0iUhzxRjSdgRuH4OzdFjEIsfXUF2/PXpTBAGIa0f6j3Q5CTz4Gk9COodvCUEMmaIHsNBmxIRd/Px7vb6tHaJatfDloHlub0IJ7JsD7Bao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T/rk3J5/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T/rk3J5/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC79B1F000E9;
	Fri, 26 Jun 2026 21:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782510500;
	bh=Vhvr3a25c3afoSsPLw5z7QZQ/Fg/gVKyC9kTmTwYq80=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=T/rk3J5/sesUN0A24Xb+vlFOg358xw3eUE/WVvAh0KFguy7VunAuAH52/NuEA7H6y
	 kWGyFIOd7y5Lj1O6BR4Av16w102TxNHsh7KdULzISPEzkWMsKqfnAOUxYixpcRcNzx
	 SS+TIgYNlENrsZ1k4ha7RbLloZQHYFI3bHK6+Jc0UhHIFrf26s+a4PUlXrG+/OhrUn
	 BF0g5Wf/BJNgJX3errN/GvJEXVR5IJZgUaSq89v8zxhiQYstylF+2s4vuZ9Q+dtAng
	 URutmA+LkXevS4HmiIQpCb9GN6OucyrItXiy891F/v6ZDqVhtunVZOMTGg4AHo5e5L
	 1IOtUQavN00YA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 04/20] KVM: selftests: Initialize the default/global
 pRNG during kvm_selftest_init()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sean Christopherson" <seanjc@google.com>
Cc: kvm@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260626213534.3866178-5-seanjc@google.com>
References: <20260626213534.3866178-1-seanjc@google.com>
 <20260626213534.3866178-5-seanjc@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 26 Jun 2026 21:48:19 +0000
Message-Id: <20260626214819.EC79B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Global PRNG state cannot be reseeded for pre-VM usage, breaking =
reproducibility in tests like irq_test.
--

commit 62d9f92bdfe9d424d969de02ee382ed391548f81
Author: Sean Christopherson <seanjc@google.com>

KVM: selftests: Initialize the default/global pRNG during kvm_selftest_init=
()

This commit initializes the default kvm_rng during the selftest constructor=
=20
so tests can use the pRNG before creating a VM. It also extracts the seedin=
g=20
logic into a new kvm_seed_rng() helper.

> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/s=
elftests/kvm/lib/kvm_util.c
> index 875030c22d07b..1016865d3f7a2 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -24,6 +24,13 @@ u32 kvm_random_seed;
>  struct kvm_random_state kvm_rng;
>  static u32 last_kvm_seed;
> =20
> +static void kvm_seed_rng(u32 seed)
> +{
> +	kvm_random_seed =3D last_kvm_seed =3D seed;
> +	pr_info("Random seed: 0x%x\n", kvm_random_seed);
> +	kvm_rng =3D new_kvm_random_state(kvm_random_seed);
> +}
> +

[Severity: Medium]
Does making this function static prevent tests from reseeding the PRNG
early?

If a test draws from kvm_rng before __vm_create() is called (for example,
generating gsi and vector at the start of main() in irq_test), the test
will use the initial seed from the constructor.

Since kvm_seed_rng() is static and only automatically reseeded during
__vm_create(), how can developers override the seed to reproduce CI failures
for these pre-VM random variables?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260626213534.3866=
178-1-seanjc@google.com?part=3D4
