Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09E043955C9;
	Fri, 12 Jun 2026 16:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781282153; cv=none; b=KKQc9uK0r4bi6tXKX6ZRjmznJ30ZKFt2acU/5BG/8UxB2QqwK+3OewhqOQD70Igv8P9nN8cJEkA6lKZrrzJsEJGDeafYIlpSU/xX/PSHyzZ9MmHb5PntcJ8X/C/LqeO/mHt3B+QF7U0x+rPdX5A1/RciUENFUoeUfbGvCfxscLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781282153; c=relaxed/simple;
	bh=kwLDEZjb/hiFZYLZfCDu2P7zGVNRaWQjPMpzFrWco5g=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=FxctcVchPfo4euez1eBdzse/pOct6uzHZuGIq3TTSnbY1B01lJx0j2Q3o53vaIaFk9g8YRCJzDnrrQyNLUTIdYEOzmQQ9nqTWGDyeK76o7X5ggh+EQna+8WPWXNwlK3eB3gnrB2CmavyPwi0f3kNh1/tqtOSRygwLEd4+nQM2qQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gHP7F+UF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gHP7F+UF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28AB91F00A3A;
	Fri, 12 Jun 2026 16:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781282150;
	bh=FTrOSNGS/YIYhjkDg1aa8r2Esa00blqrB5ZCllbCUDU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gHP7F+UFvA+3HJHYH4oUr83M+UkVaANHUICTJC2DqTRpkSFYQMsuwfdFryt68Rlsr
	 dHb9B12IHss2cnrJ8yIHqe/Py9wdyx3rQSYSVvls0PBUKFY3Dt+ylAxWJAI9nPYKRs
	 isX2plYshttjB+cH4SXXZBQgjXVIroZWSDuxa6FbHgXdtmIPBTThCryxsx9pyByl+D
	 t1ILtt4xEgdaGlKcP3g1l4Ixp+G18MZHz2ljcOu82Yf1IN/B96Wz0b01La2R7cm/Wi
	 NlaqPVEayCirK7WRHygkBFAw0b/Atbtb33owRZiuSaNUl2z9vh/HzB92YwCBu2GC9g
	 bGebzYiI7a6bQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 5/5] KVM: selftests: Add nested pre-fault test for
 arm64
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jack Thomson" <jackabt.amazon@gmail.com>
Cc: kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260612162354.73378-6-jackabt.amazon@gmail.com>
References: <20260612162354.73378-6-jackabt.amazon@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 12 Jun 2026 16:35:49 +0000
Message-Id: <20260612163550.28AB91F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The `KVM_PRE_FAULT_MEMORY` ioctl loop in `pre_fault()` fails to =
handle partial success, causing spurious test failures if the ioctl yields =
or is interrupted.
--

commit ee1e827d8efbd103bf9ab1322ee50ba8c3895869
Author: Jack Thomson <jackabt@amazon.com>

KVM: selftests: Add nested pre-fault test for arm64

This commit adds an arm64 nested-virt selftest for KVM_PRE_FAULT_MEMORY to
verify that prefaulting correctly targets the canonical stage-2 when the
guest's last-run context has a nested/shadow stage-2 MMU.

> diff --git a/tools/testing/selftests/kvm/arm64/nv_pre_fault_memory_test.c=
 b/tools/testing/selftests/kvm/arm64/nv_pre_fault_memory_test.c
> new file mode 100644
> index 0000000000000..2bbd5540599c0
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/arm64/nv_pre_fault_memory_test.c

[ ... ]

> +static void pre_fault(struct kvm_vcpu *vcpu, u64 gpa, u64 size)
> +{
> +	struct kvm_pre_fault_memory range =3D {
> +		.gpa =3D gpa,
> +		.size =3D size,
> +	};
> +	int ret;
> +
> +	do {
> +		ret =3D __vcpu_ioctl(vcpu, KVM_PRE_FAULT_MEMORY, &range);
> +	} while (ret < 0 && errno =3D=3D EINTR);

[Severity: Medium]
Does this loop handle partial successes correctly? If the ioctl is interrup=
ted
by a signal or yields after successfully mapping at least one page, it retu=
rns
0 and updates range.size with the remaining bytes to process.

If that happens, this loop will exit immediately and the test will spurious=
ly
fail the TEST_ASSERT_EQ(range.size, 0) assertion below. Should this loop
continue as long as ret =3D=3D 0 and range.size > 0?

> +
> +	TEST_ASSERT(!ret, "KVM_PRE_FAULT_MEMORY failed, ret: %d errno: %d",
> +		    ret, errno);
> +	TEST_ASSERT_EQ(range.size, 0);
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260612162354.7337=
8-1-jackabt.amazon@gmail.com?part=3D5
