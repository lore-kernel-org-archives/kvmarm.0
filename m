Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 634E1372063;
	Fri, 26 Jun 2026 21:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782510286; cv=none; b=KpnDINO5hcDzpH8QmcX6SmrSdjQAB1AvGLcy6oj53/Klam7PAUkmAJU6b7KNDD+eK2XSTHi8Hejhl2+dOCFsHsrIarMosZy3FAnxcnSIlXros4uGoAbpZjzy8HHuv2aLH+GBthsyb5hZtDCyyZruKbcuFC4GvteVoSoTRX8GKBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782510286; c=relaxed/simple;
	bh=TMfdYLWa6jHJIP4gqNPJcB43oRhnDCqgw8DULZPcChc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=UCDGj6FS+6nHFAW+4CFstAyCCgBLvK5GTZifnXFO8MsjAPI3FtYsRSry0BCIQo9oZk6aBR1r50v4NQeMJ4PD5N/QQ6z/XRzjdvj/v6jrWfK7bBSZshV+zvY0znsExYHbw3znkq8T8GGnERHHZWccmOY27kjdlBedKWcb13EppS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C+cygxuN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C+cygxuN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C52711F000E9;
	Fri, 26 Jun 2026 21:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782510285;
	bh=yUjwzxR9D3gk8N0nZW0RzZjaqCR4SW8ZFywmKyRYiZA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=C+cygxuNWZGrH9SOdD6atPYapiuwtiJEiL/8CEksuqLQwtJDSOXTq+wbcZia7ehtm
	 vn8fG591w1ClOr1HhlE76sbkumRq0h+Fznb2azGlmBFNnvhTkWjp6MOrZTfP4M+6if
	 VnoUp/8XsOwmgDngnKVFe+A5rUD+90sD8S+x/HbZ19/28ooTJpg2ZTHRVR5UP0/+Wr
	 cb4eHdHb+F4Iu8/a0G7oZzBNsT2iqsFu7XkA2/0iSh8BP1eK4AXqvSWPIOnqTpVRvO
	 YeHJLOL53YxjV4WizYiwT888/WNurHx4+JDCltcwFC39wNDdyUoNX/aVVlbQf4N8QS
	 kdnWrHUDZoMHA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 06/20] KVM: selftests: Add helper to generate random
 u64 in range [min,max]
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sean Christopherson" <seanjc@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260626213534.3866178-7-seanjc@google.com>
References: <20260626213534.3866178-1-seanjc@google.com>
 <20260626213534.3866178-7-seanjc@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 26 Jun 2026 21:44:44 +0000
Message-Id: <20260626214444.C52711F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] kvm_random_u64() never sets bits 31 and 63, causing kvm_random_u=
64_in_range() to have severe blind spots.
--

commit 5a3dcffb3cb35a622072ea5194b7875f774cb3a7
Author: Josh Hilke <jrhilke@google.com>

KVM: selftests: Add helper to generate random u64 in range [min,max]
   =20
Introduce kvm_random_u64_in_range(state, min, max) to return a random u64=20
within an inclusive range.

> diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/=
selftests/kvm/lib/test_util.c
> index e98ca7ef439c4..e208a57f190cf 100644
> --- a/tools/testing/selftests/kvm/lib/test_util.c
> +++ b/tools/testing/selftests/kvm/lib/test_util.c
[ ... ]
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

[Severity: Medium]
Will this result in severe blind spots within the generated range?

Looking at how the random value is constructed:

tools/testing/selftests/kvm/include/test_util.h:kvm_random_u64() {
    return ((u64)kvm_random_u32(state) << 32) | kvm_random_u32(state);
}

And considering kvm_random_u32() limits its return value with a modulo of=20
((u32)(1 << 31) - 1), it appears bits 31 and 63 will always remain zero.

Does this mean the subsequent modulo operation in this function:

> +
> +	range =3D max - min;
> +	if (range =3D=3D ULLONG_MAX)
> +		return value;
> +
> +	return min + (value % (range + 1));
> +}

will fail to cover large portions of requested ranges? For example, if a=20
test requests a 4GB range, could this only ever return values in the lower=
=20
2GB of that range?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260626213534.3866=
178-1-seanjc@google.com?part=3D6
