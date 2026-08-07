Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E3593655C4;
	Fri,  7 Aug 2026 17:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786124371; cv=none; b=h2cCneZQ3GpTB/WvIXvhdVY5i2ihrYzs3k9LLJdNvpEgpb0NZo9CrK/k6+eH3wJLeCn2qRtiebRUQ8EgtWqoC2dgKTOIJlt+is/3YiZCVbamBQZ6S5q+4G+I6Zu/4DamuGfLFSC3WfTQei1DXT4aiZZ4w3hELZRrLD1fDT1PM08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786124371; c=relaxed/simple;
	bh=Sijy8JmW1OlL8il3uSNyN7lipFJrlmOJM7IC7JOTOQg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=gc8Zq1TRi7kADIwOUHeWEEIhiM0noMOAuV88T16W8fc9UoyNMrH9JKo9BTwrTiYv1jAZPtqSPVlaFFnifz+giMXGpncsG44R+kAHRibZQnF5coxtdq919TTKDpqULrqbpn/L01SNtKS4okUpFgFk5yBkcC/6RjJv6hAdEr/Zph8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EhoNKmWW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EhoNKmWW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F6731F000E9;
	Fri,  7 Aug 2026 17:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786124368;
	bh=c+Wh046HJBoVOeqBhvYXxbJ6fF+5wfp9zmC/A6Mgoow=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EhoNKmWW330A4feZ6Wl/h6vLqJiMYjyfgZgFl5jSkWgzVMLhd7AafBpWotHrjRj4M
	 XnyvRffhmzYSgfLtKWIdWmDRVGNwZeGFD+tZ5K5o4B0dcCn/yNSlQOFAySTlgHoatN
	 pSG4P6HL3ieQc5dzSbBAptpHONwnPfADfzGszp8F3sv5jRhEytFfek61+lq1iclyCz
	 8NolrWawLM2NpLb2akK2dxuaTL6wbU1zUOUU6t7tsaZXAIsDC4kmqlSOUT7GX75jWu
	 kC8K4jjQOmhQ+VEasycWw5mP+IIkmlllxzzR+pZ65keVsRH2r0adkrfC8nRxzDvLAV
	 mQRWTWDaC4c7Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 47/49] KVM: selftests: Add VGICv5 LPI delivery tests
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260807111159.429128-48-sascha.bischoff@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
 <20260807111159.429128-48-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 07 Aug 2026 17:39:27 +0000
Message-Id: <20260807173928.3F6731F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The system instruction GIC CDEOI requires the fixed register XZR=
, but is emitted using a compiler constraint which may select a general-pur=
pose register.
--

--- Patch [47]: [PATCH v5 47/49] KVM: selftests: Add VGICv5 LPI delivery te=
sts ---
commit 1dca3130863c08b0c3a19e09294df6edd1534a20
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: selftests: Add VGICv5 LPI delivery tests

Add a two-VPE VGICv5 LPI delivery test. Exercise the virtual IRS ID
registers and IST base configuration path before checking interrupt
delivery.

> diff --git a/tools/testing/selftests/kvm/arm64/vgic_v5.c b/tools/testing/=
selftests/kvm/arm64/vgic_v5.c
> index 23fbd2db50c43..71bda5661c74e 100644
> --- a/tools/testing/selftests/kvm/arm64/vgic_v5.c
> +++ b/tools/testing/selftests/kvm/arm64/vgic_v5.c

[ ... ]

> @@ -209,6 +298,67 @@ static void guest_spi_line_code(void)
>  		wfi();
>  }
> =20
> +static void guest_lpi_irq_handler(struct ex_regs *regs)
> +{
> +	u32 vcpu_id =3D guest_get_vcpuid();
> +	u32 expected_lpi =3D vcpu_id ? LPI_TEST_TO_VPE1 : LPI_TEST_TO_VPE0;
> +	u64 expected_hwirq =3D gicv5_lpi_hwirq(expected_lpi);
> +	u32 hwirq;
> +	u64 ia;
> +
> +	ia =3D gicr_insn(CDIA);
> +	if (!GICV5_GICR_CDIA_VALID(ia))
> +		return;
> +
> +	gsb_ack();
> +	isb();
> +
> +	hwirq =3D FIELD_GET(GICV5_GICR_CDIA_INTID, ia);
> +	GUEST_ASSERT_EQ(hwirq, expected_hwirq);
> +
> +	gic_insn(hwirq, CDDI);
> +	gic_insn(0, CDEOI);

[Severity: Medium]
Will this lead to misencoded instructions?

The system instruction GIC CDEOI requires the fixed register XZR, but is
emitted using the gic_insn() macro which expands to write_sysreg_s() using a
compiler constraint instead of a hardcoded register.

If the compiler selects a general-purpose register other than XZR, this cou=
ld
result in CONSTRAINED UNPREDICTABLE behavior. Should this instruction use an
inline assembly block that explicitly hardcodes the exact register in the
instruction string?

> +
> +	if (vcpu_id) {
> +		gicv5_send_lpi(LPI_TEST_TO_VPE0);
> +		GUEST_SYNC(GUEST_CMD_LPI_REPLIED);
> +		while (1)
> +			wfi();
> +	}
> +
> +	GUEST_DONE();
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260807111159.4291=
28-1-sascha.bischoff@arm.com?part=3D47
