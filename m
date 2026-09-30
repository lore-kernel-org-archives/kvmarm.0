Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F7FB3AE1A6
	for <kvmarm@lists.linux.dev>; Wed, 30 Sep 2026 22:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790807099; cv=none; b=hwDmzKI2cQ4KmqZBeipdoY9lw7mPflW8186Y4wlxTKbaby5W001FxChbNFfyMXmr8f5eyXX34XiZYBu9G4pRwieVcqe2CFp65lIf3wz7Mnp8p1sk39OJDU8OzLA6KcsARPcVH+8wMKxgujvuGgyFc7HWrfARFYmubyHdDejF7KE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790807099; c=relaxed/simple;
	bh=scQ63q6utOu+hpijNsnQgZZWvIewpIMmMepuneFidKM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=RYfVFR98tgaOzadY3zdjUfrwi2zzlUGUWio60OkyZDTTy2N88zHoIpiJPvj4nAKx4jfMv0gG9Wu/iKUowirHfTmvM6PWyfy8C+PYpPoHibddqd0uxNVEN1vPKpGduRiXlwltQKmBYrQzWrWdnlQayi4VKZYnD9IxjZw7OdMGil8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bpjA1Had; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bpjA1Had"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1B991F000FF;
	Wed, 30 Sep 2026 22:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790807098;
	bh=xZm7buayyD+m24l1+rT9aB4D3hqXFYbp78KTq+w1wgo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bpjA1Hadhe5TbP9VGsFP9pn0NA1ZjR8P2Rdmwlh4Pbq8w+iMME2yTNZqcEor/g1RD
	 7NIKf05uPKvMCy35AY/do/97jtElWnqW4jkNYWj1UUAwtq5Hy1xB0vwPT+ZUmlVoXc
	 +MDmODa93GxXGCPb35yxvOCgWkMrVhbMAwjxUsBy6VonDjpKbyNH3okVsAiE4i887S
	 Ua5CxCqJPEaMnz1FZHx73gOE4825Df62o6uvygpTWqtyQPeDtBPEbgDOMWAQ464nw7
	 GcVlNj6ua4PwJGMqyUZi/i0RruySpGNpBMtbQFW1ZiOCVNSRpSZ6LnjlPbFah9HfvF
	 uMf65igANSsIw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v21 15/15] KVM: selftests: arm64: Add GCS EXLOCK
 exception emulation test
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mark Brown" <broonie@kernel.org>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260930-arm64-gcs-v21-15-3556644cd927@kernel.org>
References: <20260930-arm64-gcs-v21-0-3556644cd927@kernel.org>
 <20260930-arm64-gcs-v21-15-3556644cd927@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 30 Sep 2026 22:24:57 +0000
Message-Id: <20260930222457.E1B991F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] kselftest/arm64: missing fine-grained trap tests mentioned in co=
mmit message
--

commit c63cb70f3a95d5f56914bee1163a8ae38fd9251f
Author: Mark Brown <broonie@kernel.org>

KVM: selftests: arm64: Add GCS EXLOCK exception emulation test

This commit adds a new selftest to validate the emulation of
GCSCR_EL2.EXLOCKEN behavior during exception return (ERET) for KVM on arm64.
It checks that expected exceptions are generated and verifies system regist=
er
interactions.

> We nest handling of two UDFs to allow us to both observe and modify
> PSTATE.EXLOCK, checking that expected exceptions are generated for ERET.
> We also repeat the UDF tests having enabled fine grained traps for ERET
> to try to ensure that the slow paths are taken.

[ ... ]

> diff --git a/tools/testing/selftests/kvm/arm64/gcs_exceptions.c b/tools/t=
esting/selftests/kvm/arm64/gcs_exceptions.c
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/arm64/gcs_exceptions.c

[ ... ]

> +static void guest_code(void)
> +{
> +	GUEST_ASSERT_EQ(get_current_el(), 2);
> +
> +	/*
> +	 * Try straightforwardly generating an exception without and
> +	 * with EXLOCK.
> +	 */
> +	test_udf_exception(false);
> +	test_sysreg(UDF_ELR_EL1, false);
> +	test_sysreg(UDF_ELR_EL2, false);
> +	test_sysreg(UDF_SPSR_EL1, false);
> +	test_sysreg(UDF_SPSR_EL2, false);
> +
> +	test_udf_exception(true);
> +	test_sysreg(UDF_ELR_EL1, true);
> +	test_sysreg(UDF_ELR_EL2, true);
> +	test_sysreg(UDF_SPSR_EL1, true);
> +	test_sysreg(UDF_SPSR_EL2, true);
> +
> +	GUEST_DONE();
> +}

[Severity: Medium]
Is the fine-grained trap testing missing here? The commit message explicitly
states that the UDF tests are repeated with fine-grained traps enabled for
ERET to ensure slow paths are taken.

However, looking at the guest_code() implementation in
tools/testing/selftests/kvm/arm64/gcs_exceptions.c, the tests are only
executed with the enable_exlock parameter set to false and then true. There
does not appear to be any logic to configure fine-grained trap registers
(such as HFGITR_EL2) or an additional pass to repeat these UDF tests with
those traps active.

Does the test need an update to match the commit message, or is this
handled in a different way?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260930-arm64-gcs-=
v21-0-3556644cd927@kernel.org?part=3D15
