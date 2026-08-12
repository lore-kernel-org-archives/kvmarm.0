Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DE793793CA
	for <kvmarm@lists.linux.dev>; Wed, 12 Aug 2026 19:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786563476; cv=none; b=lN4igcGw2N8nh5/BLWZT1GSx6PqeCppk52qhbm0Jiub1ul1hyll5NCPETe0O0EgcI3sGVBfN5lFvSF/cSSKOX5hs0BsMqhbUVzlB2i6IUTzwaf1SLQVosV9d62FWqRhSvkQKwL+SPMCv7Aui+244y5e8ZCrEfVHKffh3QcIl9rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786563476; c=relaxed/simple;
	bh=Q7/7vkbIJBqmpH0zo3ytcf6rwOVKfhUWMY+6BfQXFzE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=bk7k7jzoEGLHpUE1hPSf1ihGQlcy7mQ7Vwlt6ybJkapTnUkVoGfbqnwGFhW1h/2CaW16UEtdanARQ1X1Ig8Bk0a00sqqSEdBV+TnsoglEEmQUoZGOpl7JbhHUqJttH3C3nqGd64XuQ4Mv4VGqQlHpU6YDMEG3uR9LODZpJmJic4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DbduQK56; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DbduQK56"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9791E1F00A3A;
	Wed, 12 Aug 2026 19:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786563474;
	bh=XsEpjFfEqcKVaYfL7C/8fZWBxFQH5HsFwkA52+nR/nM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DbduQK56TCFMWcj+AqFP1RhswsweyUSrjoGu9TcCihgEpvzdOeVYxLr4AOMfcPrMC
	 sRjkTliuww6NzYf9w3M/fNE2ty2yMcswUyxPeqJT1R+KAp0Vwq6PG20u/FFfdcbPKm
	 9syoyhiNQ4TQXbA7IAS48xBpCMrKrJ2mZIZpz7234mlqj5W7QAoOJhXP5ZE41KRQyG
	 xZPlNqLyLZ67xVofewmb1nwparsU94dimKHlgyJm8Hnp1ZsTflQNr6lgPJIbBgzf4r
	 AW4UVVCnD3fC8Dq6aADmwsghGG4Rp0J+O9ggVEesDhPTHlt4p/nXXEXM1NieaYQtdo
	 JcUOHCb+jhTxw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v19 14/14] KVM: selftests: arm64: Add GCS EXLOCK
 exception emulation test
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mark Brown" <broonie@kernel.org>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260812-arm64-gcs-v19-14-9105afd828ac@kernel.org>
References: <20260812-arm64-gcs-v19-0-9105afd828ac@kernel.org>
 <20260812-arm64-gcs-v19-14-9105afd828ac@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 12 Aug 2026 19:37:54 +0000
Message-Id: <20260812193754.9791E1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Brittle test state causes confusing assertion failures on unexpe=
cted UNDEF exceptions.
--

--- Patch [14]: [PATCH v19 14/14] KVM: selftests: arm64: Add GCS EXLOCK exc=
eption emulation test ---
commit 3ce6c247a7bdb06355a23e53c25ee48d7bb16f9d
Author: Mark Brown <broonie@kernel.org>
KVM: selftests: arm64: Add GCS EXLOCK exception emulation test

This patch adds a KVM selftest to validate the emulation of GCSCR_EL2.EXLOC=
KEN
when running in vEL2. It uses nested UDFs to observe and modify PSTATE.EXLO=
CK,
testing both fast and slow paths.

> diff --git a/tools/testing/selftests/kvm/arm64/gcs_exceptions.c b/tools/t=
esting/selftests/kvm/arm64/gcs_exceptions.c
> new file mode 100644
> index 0000000000000..de5bc65907272
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/arm64/gcs_exceptions.c

[ ... ]

> +static void guest_undef_handler(struct ex_regs *regs)
> +{

[ ... ]

> +	case UDF_SPSR_EL2:
> +		GUEST_ASSERT_EQ(read_sysreg_s(SYS_GCSCR_EL2) & GCSCR_ELx_EXLOCKEN,
> +				expect_exlock ? GCSCR_ELx_EXLOCKEN : 0);
> +
> +		asm volatile("mrs %0, spsr_el2   \n\
> +			      msr spsr_el2, %0"
> +			     : "=3Dr"(val) :: "memory");
> +		break;
> +
> +	default:
> +		GUEST_FAIL("Invalid udf_mode");
> +	}
> +}

[ ... ]

> +static void guest_code(void)
> +{

[ ... ]

> +	test_udf_exception(true);
> +	test_sysreg(UDF_ELR_EL1, true);
> +	test_sysreg(UDF_ELR_EL2, true);
> +	test_sysreg(UDF_SPSR_EL1, true);
> +	test_sysreg(UDF_SPSR_EL2, true);
> +
> +	/* Force ERET directly through the slow emulation path as well. */
> +	sysreg_clear_set_s(SYS_HFGITR_EL2, 0, HFGITR_EL2_ERET);

[Severity: Medium]
What happens if the vCPU does not support Fine Grained Traps (FEAT_FGT) when
this register is accessed?

Since this access occurs without verifying FGT support, it seems it would
trigger an unexpected UNDEFINED exception on systems where FGT is missing or
hidden.

Because udf_mode is not reset after the last intentional udf and remains se=
t to
UDF_SPSR_EL2, would this unexpected exception incorrectly fall into the
UDF_SPSR_EL2 case in guest_undef_handler(), resulting in a confusing assert=
ion
failure rather than cleanly reporting the unexpected UNDEF?

> +	isb();
> +
> +	test_udf_exception(false);
> +
> +	test_udf_exception(true);
> +
> +	sysreg_clear_set_s(SYS_HFGITR_EL2, HFGITR_EL2_ERET, 0);
> +	isb();
> +	GUEST_DONE();
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260812-arm64-gcs-=
v19-0-9105afd828ac@kernel.org?part=3D14
