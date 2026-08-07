Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56043317164;
	Fri,  7 Aug 2026 17:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786123273; cv=none; b=lmmnIRhsGYcKVd6NLNTtj1lQftPLgCjlvyd8GkQi708cGEgG3cYyo3PKlHwM3+OrTCpLdyIAKTxJ9xoJ2uhNWijOJPibTGwfdmjuOlLl49Ftmfa+gfsXnFCTQzhsdq0zOduoIV0+delQgIHm3ilE+g9vsbS0Lj29Lbk/Qf5E/So=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786123273; c=relaxed/simple;
	bh=lDkP3zcrOYYiTFLW7DAzu7pDiV+M3vSSRV7EdV8nZ78=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=fbnJPhSMARmcmc4cfAXGpHSTKsZESmu2iHOxpeDyA4e5NzfiUD0L+lN8frsM7Ii3uEVLB3gdZ1R9z/95PKTel37OYgBzcuvLxXOaSE850Nrxl3iJjKpseK4zWvNRgwNccaWYDhVmGUUrMIJdp7jSqNFHXEv0OPgT/HnevpgLOIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ggrD2eay; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ggrD2eay"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ACBF1F000E9;
	Fri,  7 Aug 2026 17:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786123271;
	bh=GjE62yf0K9dWF+khzym+a+bEUb+JNR1nry+wAk8N7k0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ggrD2eaycigsdBqzJu0dh6xm0HrQaY5UGVj/2ghJUchmSaZHWWDsUicCW54cGB+IC
	 GZ31xlxiafBc5K02/TNBxXRrfDW8FACmaUPcQCu3B9p8rggn8ncrIaF6ktmVvcZFT2
	 pqlbO6AARin/tHPSkZaxf5wU5OyArap0u7HoybjyX8dldblDNvC2QX/GlcN/F74K7b
	 6bT8VLYx2Ih3HZQ4BXim6D2YOhEwZyowGIXeLXTa7UNYXTxUdYw2zt8+bLnmJulWgI
	 1puUKKku88hdUXQEGmfyah/IIB0i/66x+HappttJvZdzN4ycftzGNtReMPtyIixfCL
	 vCySNQ8kbZ0wQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 43/49] KVM: selftests: Add VGICv5 IST attribute tests
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260807111159.429128-44-sascha.bischoff@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
 <20260807111159.429128-44-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 07 Aug 2026 17:21:11 +0000
Message-Id: <20260807172111.9ACBF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Incomplete test coverage for VGICv5 IST attribute validation
--

--- Patch [43]: [PATCH v5 43/49] KVM: selftests: Add VGICv5 IST attribute t=
ests ---
commit 9ba6d67381650763d50c218233de98711d15304f
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: selftests: Add VGICv5 IST attribute tests

This commit adds selftests for the VGICv5 IST attribute group. It verifies
that KVM reports the attribute group correctly and rejects invalid operatio=
ns,
such as out-of-order save/restore attempts and badly sized IST buffers.

> diff --git a/tools/testing/selftests/kvm/arm64/vgic_v5.c b/tools/testing/=
selftests/kvm/arm64/vgic_v5.c
> index 54fa13906990b..e053b01bb5be3 100644
> --- a/tools/testing/selftests/kvm/arm64/vgic_v5.c
> +++ b/tools/testing/selftests/kvm/arm64/vgic_v5.c

[ ... ]

> @@ -523,6 +534,114 @@ static void test_vgic_v5_irs_regs_attrs(void)
>  	vm_gic_destroy(&v);
>  }
> =20
> +static void test_vgic_v5_ist_attrs(void)
> +{

[ ... ]

> +	/* Check missing and incorrectly sized SPI IST buffers. */
> +	ist_attr =3D vgic_v5_ist_attr(NULL, 0, NULL, 0);
> +	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IST,
> +				    0, &ist_attr);
> +	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 IST get accepted missing=
 SPI buffer");
> +
> +	ist_attr =3D vgic_v5_ist_attr(spi_ist, sizeof(spi_ist) - sizeof(__u32),
> +					 NULL, 0);
> +	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IST,
> +				    0, &ist_attr);
> +	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 IST set accepted bad SPI=
 size");

[Severity: Medium]
Does this test leave coverage gaps for the set/get paths? For the missing
SPI buffer, the test only checks __kvm_device_attr_get(), but neglects
__kvm_device_attr_set(). Similarly, for the incorrectly sized SPI buffer,
it checks __kvm_device_attr_set() but not __kvm_device_attr_get().=20

Would it make sense to test both the get and set paths for these validation
checks, similar to how the NULL descriptor checks were handled earlier?

> +
> +	/* LPI storage must be absent when no LPI IST is configured. */
> +	ist_attr =3D vgic_v5_ist_attr(spi_ist, sizeof(spi_ist), spi_ist,
> +					 sizeof(__u32));
> +	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IST,
> +				    0, &ist_attr);
> +	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 IST get accepted unexpec=
ted LPI buffer");

[Severity: Medium]
Is this test missing the corresponding check for the set path? As with the
SPI buffer tests above, it only validates that __kvm_device_attr_get()
rejects the unexpected LPI buffer, but does not check if
__kvm_device_attr_set() correctly rejects it as well.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260807111159.4291=
28-1-sascha.bischoff@arm.com?part=3D43
