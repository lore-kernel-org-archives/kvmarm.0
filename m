Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B90BA3DC4D9;
	Tue, 29 Sep 2026 16:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790699686; cv=none; b=mOjiHrlCtOFF3IUmNaVai6CVQei+eDt3C98W/H3z+DC+6fnnD/SjT6Z0rrn3emSigGW1WlP67a9Lm2w/sMBrQ0Y8ud4tnAz2jxHY0J3Ew5wkr11bYZl4k7d2wEbcG75SK94jFkOpsUTCYmlhj1VQYhMG7PfOFgQwYaOdoatyGjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790699686; c=relaxed/simple;
	bh=/RlUaNp7ESsUNTsQ78aDLbcIgYZBCJnfMT0JwG/EBVA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=PQLvsy/TVOAAEPPlLhs+4B+mV6YHLCzLf34bVWvu0hAdRCB6Ex3rZ/P7EX+sDjt5dV1m9XTnO/O50GBAXFaAg3PMv0Oq9jEcUQzkBd5cjEGKYNR4cukBtZcKkPTxwK35SxhhtG3IyxL1t5TDLRbK0P0KFR3IXDgGZiCXzrNcJu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ATdZgBV2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ATdZgBV2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D9331F000FF;
	Tue, 29 Sep 2026 16:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790699685;
	bh=hxVpYW1U5mn59DtEB4a2wle1hjbaPLJ4tafyEETllNE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ATdZgBV21gNXmdEwF8irAXfO3dLUZGA+7DHP2yXxXPabQLh765LnaP5doxKuO1aVv
	 djwg5aajBcuyMEyC+2qt/QKhkPDwHVNWdnoqyZFwV/NItBW/0fpil9FXtYnLZL3M42
	 K+C6jqHzCnC+E8RagRbZfkQzROkRXqG+BTK2J8JNvzh9AnU9NHvnvUH8ZqfqGt0Yjm
	 ag4GJLAp/kAZtKc7JRJrspQKQqYTOI8dDGxiJ0pwKcjRRqsL2tKEtvRLhPMSnCtZ4o
	 s5e9Vfqr0mSdXNTpVrcUt75bhTl6ok/EecM+lb0uk2gpqF49totdehVZW05L1E17/Z
	 spfLgU2BWfcwg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 3/3] KVM: selftests: arm64: Make set_id_regs bitfield
 validity checks non-fatal
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mark Brown" <broonie@kernel.org>
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org
In-Reply-To: <20260929-kvm-arm64-set-id-regs-aarch64-v8-3-58aabe2c2fac@kernel.org>
References: <20260929-kvm-arm64-set-id-regs-aarch64-v8-0-58aabe2c2fac@kernel.org>
 <20260929-kvm-arm64-set-id-regs-aarch64-v8-3-58aabe2c2fac@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 29 Sep 2026 16:34:44 +0000
Message-Id: <20260929163445.0D9331F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] selftests: set_id_regs uses fatal vcpu_set_reg() for valid writes
--

commit d230119197ae572759175fc9da082ab1dada3cca
Author: Mark Brown <broonie@kernel.org>

KVM: selftests: arm64: Make set_id_regs bitfield validity checks non-fatal

This commit modifies the set_id_regs selftest to use standard kselftest
reporting instead of fatal assertions when validating writes to feature
registers. This allows the test program to continue executing and report
all affected bitfields even if some validation checks fail.

> diff --git a/tools/testing/selftests/kvm/arm64/set_id_regs.c b/tools/test=
ing/selftests/kvm/arm64/set_id_regs.c
> index 3aa8886e8b70e..43dd9506036cf 100644
> --- a/tools/testing/selftests/kvm/arm64/set_id_regs.c
> +++ b/tools/testing/selftests/kvm/arm64/set_id_regs.c
[ ... ]
> @@ -422,6 +422,7 @@ static u64 test_reg_set_success(struct kvm_vcpu *vcpu=
, u64 reg,
>  	u8 shift =3D ftr_bits->shift;
>  	u64 mask =3D ftr_bits->mask;
>  	u64 val, new_val, ftr;
> +	bool match;
> =20
>  	val =3D vcpu_get_reg(vcpu, reg);
>  	ftr =3D (val & mask) >> shift;
> @@ -434,7 +435,10 @@ static u64 test_reg_set_success(struct kvm_vcpu *vcp=
u, u64 reg,
> =20
>  	vcpu_set_reg(vcpu, reg, val);

[Severity: Low]
Does using vcpu_set_reg() here defeat the stated goal of making write
validation checks non-fatal?=20

In the KVM selftests framework, vcpu_set_reg() contains a fatal assertion
that triggers if the underlying ioctl fails. If KVM unexpectedly rejects a
"valid" write by returning an error like -EINVAL, wouldn't this still fatal=
ly
abort the test suite instead of printing the affected bitfield and continui=
ng?

Looking at test_reg_set_fail() further down in this patch, it explicitly
uses __vcpu_set_reg() and manually checks the return code and errno to
avoid fatal assertions on the ioctl. Should __vcpu_set_reg() be used here
in test_reg_set_success() as well?

>  	new_val =3D vcpu_get_reg(vcpu, reg);
> -	TEST_ASSERT_EQ(new_val, val);
> +	match =3D new_val =3D=3D val;
> +	if (!match)
> +		ksft_print_msg("%lx !=3D %lx\n", new_val, val);
> +	ksft_test_result(match, "%s valid write succeeded\n", ftr_bits->name);
> =20
>  	return new_val;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260929-kvm-arm64-=
set-id-regs-aarch64-v8-0-58aabe2c2fac@kernel.org?part=3D3
