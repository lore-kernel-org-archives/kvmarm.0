Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793653674;
	b=axqaJIgQ6K3U9cjA4EORQ8a3cXKpj3mY4javbiG3bp7KnMqoKvnraWrEsbpHoRfzsijz
	 PMxq4Gq0SQ5b2a/qH0VgczJ7i8x1VTHL3xPeX/W8oRHKoBBLS1PT79yOFk8r1XXWHjkhU
	 7R7UvOXVJIYzPY4F7sxzunhJKy76iDctVL6Gl0ge7r6xYHpBH+jj/B9eHU3DB+swPKJOK
	 SzjjHGMpZQ2K1auCm7nUXsCK652zzZO3c4T1RNg2hxGhdG8caXWe6OIzVENLj5a7McHDt
	 DKavm7MgNCLkC1v1jUu4zjD1nakksHMhpA8ZYxQfL4vuHbps2iwWcD+tgQOS/kaLciA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793653674;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=34wlRtXrl139Acrqe2fqnsN5SeBEhgrFeZH0Z1UsZxA=;
	b=GNS7rOsuT4dMwmBVtUOfBNAxO60mxRQFKVQfK1x6325AGeXZNJbcJckF78hwQ4O2WfRl
	 8jwqDaGoqdLP9HOdk/hU4QDv7uLTOyRKdOrqtRvNqFcMPG9mlzMZ4LyHhyE+luV1iRI5H
	 W6/qsMsoJopMZ0V82XBprHRl1pUZ7CisgxkmM99auYIe3w9jMG834CbXZM0BzoH/QmC1f
	 ltVxh8Pd8Zze43fZhN+YfXihQkLn3CNpex8xneG4Dlwuis2NGyQuL9a9WlV2b9tLZVBF1
	 V7aTaesOpNoNhtjR4M0Rfn8PChUQVlhfL5SaF+YfofEEZw7wXkAxBA+qrgh8FUXG+8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S9s3KK1z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E0A606A326;
	Mon,  2 Nov 2026 21:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S9s3KK1z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E95C1F00A16;
	Mon,  2 Nov 2026 21:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793653673;
	bh=34wlRtXrl139Acrqe2fqnsN5SeBEhgrFeZH0Z1UsZxA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=S9s3KK1zyF7gcU6hb7fRG1Ga3n834wg0djiFSacPVzRj9cp8BBgRlvi+djcPYSJld
	 kicjbR/OCs0faegJjqrfd02NWVl6HWSTiwmtFHd9VVqENvrENgJWLhHS0TfJ3yNylX
	 XyGaySP3TlnRRVhYJfbHhtZayFN1zVjHJRgBZRFDijzbLzZh6GxL6TkdjROmmIGP0u
	 nRLC5zv8tLxi6BPoyQgp4tVx9MlfALrYbTZGfCwkdDbZ8AXVUKWG1gHdIUbyhLCjNI
	 gm8HDWM8CAQl1rZhge/wI7+gvQ2XOPkxIUuPIamzv6mhg2BsfnpAwwXYa0r9U/zLIw
	 oQDUyezSKJjeQ==
Message-ID: <sashiko-outbox-194181@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 15/16] KVM: selftests: Add VGICv5 ITS translation
 cache tests
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <sascha.bischoff@arm.com>, kvmarm@lists.linux.dev, kvm@vger.kernel.org
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261102194454.4086911-16-sascha.bischoff@arm.com>
References: <20261102194454.4086911-1-sascha.bischoff@arm.com>
 <20261102194454.4086911-16-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Nov 2026 21:07:52 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] KVM: selftests: IDR1 narrowing clears cache before ITS disable i=
n vgic_v5
--

commit a7e0ed97dc0fc966b7b8a5fa6982c6d6e3d8240f
Author: Sascha Bischoff <sascha.bischoff@arm.com>

KVM: selftests: Add VGICv5 ITS translation cache tests

This commit adds a KVM selftest for VGICv5 ITS translation caching, guest
invalidation commands, register width accesses, and negative KVM_SIGNAL_MSI
paths.

>     KVM: selftests: Add VGICv5 ITS translation cache tests
>    =20
>     Add end-to-end coverage for VGICv5 ITS translation and cache
>     invalidation. The ITS attribute test only checks the userspace API
>     surface; this test verifies that KVM can parse guest-provided linear
>     DT and ITT state and use it to deliver LPIs through guest GEN_EVENTR
>     and KVM_SIGNAL_MSI.
>    =20
>     Build a two-VPE VM with IRS, ITS and an LPI IST. VPE0 programs a
>     linear device table and interrupt translation table, enables the
>     virtual ITS, enables two LPIs targeting VPE1, and sends GEN_EVENTR to
>     populate the translation cache with EventID to LPI A. VPE1 reports the
>     LPI identity it consumed.
>    =20
>     VPE0 then rewrites the ITT to point at LPI B without invalidation, and
>     a host KVM_SIGNAL_MSI injection verifies that the stale cached LPI A
>     translation is reused. VPE0 invalidates the event with ITS_INV_EVENTR
>     and the host verifies that LPI B is delivered.
>    =20
>     VPE0 then rewrites the ITT back to LPI A, invalidates the device with
>     ITS_INV_DEVICER, and the host verifies that LPI A is delivered again.
>     This exercises the guest-side event and device invalidation paths
>     rather than invalidating translations directly from the test host.
>    =20
>     Also cover negative MSI paths by checking that KVM_SIGNAL_MSI rejects=
 a
>     message without KVM_MSI_VALID_DEVID and rejects a message whose addre=
ss
>     does not target the GICv5 ITS. Finally, inject once before guest-side
>     ITS disable to prove delivery still works, then have VPE0 disable the
>     ITS and verify that a cached KVM_SIGNAL_MSI delivery is rejected with
>     ENXIO.
>    =20
>     Check 32-bit accesses to both halves of DT_BASER and preservation of
>     the untouched half. Verify that guest writes to the ITS ID registers
>     and READ_EVENT_DATAR are ignored, and that READ_EVENT_DATAR can be re=
ad
>     at both 32-bit and 64-bit widths.
>    =20
>     Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
>=20
> diff --git a/tools/testing/selftests/kvm/arm64/vgic_v5.c b/tools/testing/=
selftests/kvm/arm64/vgic_v5.c
> index 92da9753ce8e6..a9b0bca24ec08 100644
> --- a/tools/testing/selftests/kvm/arm64/vgic_v5.c
> +++ b/tools/testing/selftests/kvm/arm64/vgic_v5.c

[ ... ]

> @@ -2312,6 +2644,183 @@ static void test_vgic_v5_ist_save_restore(void)

[ ... ]

> +static void test_vgic_v5_its_translation_cache(void)
> +{

[ ... ]

> +	/*
> +	 * Device invalidation must cover all cached EventIDs for the
> +	 * DeviceID. The guest has again re-written the event to translate to
> +	 * LPI A.
> +	 */
> +	ret =3D run_vcpu(vcpus[0]);
> +	TEST_ASSERT(!ret, "Failed to run GICv5 ITS device invalidation");
> +	vgic_v5_expect_sync(vcpus[0], GUEST_CMD_ITS_DEVICE_INVALIDATED,
> +			    "GICv5 ITS guest did not invalidate device");
> +	vgic_v5_expect_its_lpi(&v, vcpus[1], ITS_TEST_LPI_A);
> +
> +	/* A narrower userspace IDR1 must invalidate the cached DeviceID. */
> +	ret =3D __kvm_device_attr_get(v.its_fd, KVM_DEV_ARM_VGIC_GRP_ITS_REGS,
> +				    GICV5_ITS_IDR1, &idr1);
> +	TEST_ASSERT(!ret, "GICv5 ITS_REGS failed to read IDR1");
> +	idr1 =3D (idr1 & ~GICV5_ITS_IDR1_DEVICEID_BITS) |
> +		FIELD_PREP(GICV5_ITS_IDR1_DEVICEID_BITS, 2);
> +	ret =3D __kvm_device_attr_set(v.its_fd, KVM_DEV_ARM_VGIC_GRP_ITS_REGS,
> +				    GICV5_ITS_IDR1, &idr1);
> +	TEST_ASSERT(!ret, "GICv5 ITS_REGS failed to narrow DeviceID width");
> +	ret =3D __vgic_v5_signal_msi(v.vm, GICV5_ITS_BASE_GPA +
> +				   GICV5_ITS_TRANSLATER,
> +				   ITS_TEST_DEVICE_ID, ITS_TEST_EVENT_ID,
> +				   KVM_MSI_VALID_DEVID);
> +	TEST_ASSERT(ret =3D=3D 0,
> +		    "GICv5 ITS did not block MSI after DeviceID width changed");
> +
> +	/* Disabling the ITS must also prevent delivery from cached entries. */
> +	ret =3D run_vcpu(vcpus[0]);
> +	TEST_ASSERT(!ret, "Failed to run GICv5 ITS disable");
> +	vgic_v5_expect_sync(vcpus[0], GUEST_CMD_ITS_DISABLED,
> +			    "GICv5 ITS guest did not disable ITS");
> +
> +	/*
> +	 * We should fail to inject this MSI. Use the raw call to ensure we
> +	 * catch the return value.
> +	 */
> +	ret =3D __vgic_v5_signal_msi(v.vm, GICV5_ITS_BASE_GPA +
> +				   GICV5_ITS_TRANSLATER,
> +				   ITS_TEST_DEVICE_ID, ITS_TEST_EVENT_ID,
> +				   KVM_MSI_VALID_DEVID);
> +	TEST_ASSERT(ret < 0 && errno =3D=3D ENXIO,
> +		    "GICv5 ITS accepted cached MSI while disabled");

[Severity: Medium]
Does this final check in test_vgic_v5_its_translation_cache() actually test
disabling the ITS while a valid entry is present in the translation cache?

In the preceding block, writing GICV5_ITS_IDR1 via
KVM_DEV_ARM_VGIC_GRP_ITS_REGS to narrow GICV5_ITS_IDR1_DEVICEID_BITS to 2
causes vgic_v5_uaccess_write_its_idr() -> its_cache_clear_translations() to
flush the translation cache, and leaves ITS_TEST_DEVICE_ID (5) out of range
so the subsequent __vgic_v5_signal_msi() call fails in get_itt() without
repopulating the cache.

Because GICV5_ITS_IDR1 is not restored and vgic_v5_expect_its_lpi() is not
called again before VCPU0 runs to GUEST_CMD_ITS_DISABLED, the cache is
already empty when the ITS is disabled, which also differs from the sequence
described in the commit message ("Finally, inject once before guest-side ITS
disable to prove delivery still works, then have VPE0 disable the ITS and
verify that a cached KVM_SIGNAL_MSI delivery is rejected with ENXIO").

Should GICV5_ITS_IDR1 be restored and the translation cache repopulated via
vgic_v5_expect_its_lpi() before disabling the ITS (and should the commit
message also mention the IDR1 narrowing, read-only DT register, and DeviceID
cap checks)?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102194454.4086=
911-1-sascha.bischoff@arm.com?part=3D15
