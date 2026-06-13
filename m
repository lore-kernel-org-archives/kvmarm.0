Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47BEC175A64;
	Sat, 13 Jun 2026 00:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781310670; cv=none; b=ShWs37HV5K+GokC84doqOPuBgdfxvwF1ZykxO6EZKU9cxK7hfFCFF7aw0sN39syW9Y2bg+ynVvAvGYpVBLtYLcN/dFoGdxSZF7yWu0G6rVg0dcnpSyGEuy5G6mAhpzxDFC884mm2LXsFRbS1vK/iPEe/8XqZOAPgdjeb66aLL+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781310670; c=relaxed/simple;
	bh=huX2cPspGZSUR69Zg4DCOfTdm6FLaZXkBhT2O5o0f3c=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=IOBA1+eqtz+fgn3P0WY9t8VAaH6B0rruV2WKwGKPf2TyCuXpcwQSHA2ByvoVpdku/2lVQOSCMKLd4AGZAWRzTRKCx7K9Rr5cEbgTZWWtkwsdwTjwxGoDc/t2FlxJNIMuXfEkNeSmUYB6w+Frw2n1eVSpxWJaEYeZ3FPywakmRlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VFzOEQxo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VFzOEQxo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AF391F000E9;
	Sat, 13 Jun 2026 00:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781310668;
	bh=wXAIoJd7dQs2FVJvkREj9RCGXsTcfoLvBLoNcnytBGU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VFzOEQxopkGmK1i264DXfdvN5YLLzbfR3NzVgHitHw1IOkXtBfZy77TQVwxU123kn
	 0d4d915ZgMG2dp2a2Nw7LTr7END8rr7SnCkeuVjNOban8f3Wd/8AD5/sICxHHNmnto
	 k6vwl9zAmbLbnG5RQyBT3+a2WA6pMYYL1+sRhnZ6b5m8TsyczRfHs7OkK14o4aX3+B
	 Tyz+5SQKjTPYMn+8iRBUPMMKZuCF4suBK2st9eh3e0cfv598lsTal2V72aqJ//gEac
	 Pf686QUJ/vmo0BMNoXN1Y3xlsMlrlctH3dpDy9ZTrUvLp0yFfrXcPjNX2hSpAxmN27
	 1T3+zt93ofE8g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 06/20] KVM: selftests: Add helper to generate random
 u64 in range [min,max]
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sean Christopherson" <seanjc@google.com>
Cc: "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260613002031.745413-7-seanjc@google.com>
References: <20260613002031.745413-7-seanjc@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 13 Jun 2026 00:31:07 +0000
Message-Id: <20260613003108.3AF391F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The generic PRNG helper `kvm_random_u64_in_range()` is fundament=
ally incapable of generating values in large portions of the requested rang=
e due to the structural limitations of the underlying generator.
--

commit 9b7095f015b8aad9cb0b24b2b051b56cd3917145
Author: Josh Hilke <jrhilke@google.com>

KVM: selftests: Add helper to generate random u64 in range [min,max]

Introduce kvm_random_u64_in_range(state, min, max) to return a random u64 in
the inclusive range of [min, max] using a struct kvm_random_state.

> diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/=
selftests/kvm/lib/test_util.c
> index e98ca7ef439c4..e208a57f190cf 100644
> --- a/tools/testing/selftests/kvm/lib/test_util.c
> +++ b/tools/testing/selftests/kvm/lib/test_util.c
> @@ -42,6 +42,24 @@ u32 kvm_random_u32(struct kvm_random_state *state)
>  	return state->seed;
>  }
> =20
> +/* Returns a random u64 in the inclusive range [min, max] */
> +u64 kvm_random_u64_in_range(struct kvm_random_state *state, u64 min,
> +			    u64 max)
> +{
> +	u64 value;
> +	u64 range;
> +
> +	TEST_ASSERT(min <=3D max, "PEBKAC, min =3D 0x%lx, max =3D 0x%lx", min, =
max);
> +
> +	value =3D kvm_random_u64(state);
> +
> +	range =3D max - min;
> +	if (range =3D=3D ULLONG_MAX)
> +		return value;

[Severity: Medium]
Can this regression cause tests to silently miss important edge cases?

Since kvm_random_u32() uses a linear congruential generator modulo 0x7FFFFF=
FF,
its 31st bit is permanently 0, and it never returns 0.

Because kvm_random_u64() concatenates two such values:

tools/testing/selftests/kvm/include/test_util.h:kvm_random_u64() {
	return ((u64)kvm_random_u32(state) << 32) | kvm_random_u32(state);
}

bits 31 and 63 of the resulting 64-bit number are permanently 0, and the lo=
wer
32 bits are never 0.

When this is called with a large range like min =3D 0 and max =3D ULLONG_MA=
X, it
directly returns this 64-bit value. Thus, it can never generate numbers abo=
ve
0x7FFFFFFE7FFFFFFE, any numbers with bit 31 or 63 set, or any numbers below
2^32.

Does this give a false illusion of full mathematical coverage for randomized
inputs?

> +
> +	return min + (value % (range + 1));
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260613002031.7454=
13-1-seanjc@google.com?part=3D6
