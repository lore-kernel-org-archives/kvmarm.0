Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793649933;
	b=3ZGWROT61vPFCMiKV+Up9SLJbQQaWTpVtZ6SXW41FBNvxRcVMY6n8CPDhl2dEVWU4IWe
	 k560ZKOG1xxmxGgJUq8+uz2kxldqnEKOhpyiqvzxGnNrjkspECUAy7xb3u2oJTk401KBR
	 /mkg4QG5QyNInV6nfwhO1LOJ8TtOFgfI31xukHFzD8xwqYRn8mEZc3M4We+9J43wGoa0Q
	 RseTdb8mZ5X9mvMmMsOZhG/+1RQKKH6Yn1isCvTq/QNV0FI4POffjc/M0sbiOZ58/Rjy2
	 GHjWVekaQPx8ThP3xwCRbVrIJkoPDis7succEUbe3fuZ71vwOYR5gdlMYWjunihbU+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793649933;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=9HK/8271O9tRFDuPGRWAfiiNEO0MDZcci8EHSCzCM0Y=;
	b=aftTaY8+NxOO/XUs3l3GmAkwU8TuHFB6Y4SyV9LH7ZXgHTelKeelEqhZP1dkLMZgyr/T
	 qc2Eb2kClTm3JWgfqjAIcZEEJPECgUNQK7Dz2hHP9Cab0yC2Z+UAKPS74zdKG8wU8e+ym
	 TQIxobxJuJeCYUDa8Sgk33hmALlqLSggOpU2X+gKk64vN63oPd87VJ86PttL/Tkn7GcAb
	 NwbU7cbJGL97jzBBjg/Ym5cMSY0hj8bcyhkDPukhSaMQzE6Pbh5+IRMvOF2Dmy57qgf2M
	 3dOg6dv5VP93zILpBanhSoJaEmREA/iRBFSQkZaOZW/YcmWW83hdBhf2+Rlz5Pz9zsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cP1DKGNf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 003F1606A326;
	Mon,  2 Nov 2026 20:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cP1DKGNf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 836481F00A16;
	Mon,  2 Nov 2026 20:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793649932;
	bh=9HK/8271O9tRFDuPGRWAfiiNEO0MDZcci8EHSCzCM0Y=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cP1DKGNfOlUxRruSgb9QrCzOU4ZvJ/yHz+wcURWl+dxrsp4aRzoJICjw46NHh3ROq
	 so0tkGRN2OYVzWgoj8PXn1Zq2E2CLnVPmwAR9g2ytSCrXjST5+lTpdS7NCrgRynnO1
	 GjMDgKvbzFyuVL/CsaNwanhOKZAs7VR7M7otk5bNsSFDcv2uYEZ42h866+5WgOfbLB
	 E6/FYC/w141XZjqOsspcWKaqGzZUshaa9yvxkEgGGDgL6EfmnmAbpO9cYXcf6bTY2k
	 5fn135FFoojG8SDVQzryh8Htpip64/8AeN8ynQkOX0MP5gYYaKLhe3XNGa/gpwGX5N
	 YPqYTbH4GZzvQ==
Message-ID: <sashiko-outbox-194056@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 06/16] KVM: arm64: gic-v5: Add ITS MMIO state
 emulation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <sascha.bischoff@arm.com>, kvmarm@lists.linux.dev, kvm@vger.kernel.org
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261102194454.4086911-7-sascha.bischoff@arm.com>
References: <20261102194454.4086911-1-sascha.bischoff@arm.com>
 <20261102194454.4086911-7-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Nov 2026 20:05:32 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] KVM: arm64: gic-v5: GICV5_ITS_SYNCR registered as 32-bit instead=
 of 64-bit
- [Medium] KVM: arm64: gic-v5: vgic_v5_its_reset() sets idr1.l2sz=3D0 for 2=
-level tables
--

commit 26a03544ad8ae134679e971108dc975221b2093a
Author: Sascha Bischoff <sascha.bischoff@arm.com>

KVM: arm64: gic-v5: Add ITS MMIO state emulation

This commit replaces the placeholder GICv5 ITS IODEV region with the
architected register layout and adds MMIO read/write handlers and reset
state for the ITS configuration and translation-control registers.

> diff --git a/arch/arm64/kvm/vgic/vgic-its-v5.c b/arch/arm64/kvm/vgic/vgic=
-its-v5.c
> index 5790b029f09b6..f04161c315b78 100644
> --- a/arch/arm64/kvm/vgic/vgic-its-v5.c
> +++ b/arch/arm64/kvm/vgic/vgic-its-v5.c

[ ... ]

> +static void vgic_v5_mmio_write_its_dt_itt(struct kvm *kvm, void *dev,
> +					  gpa_t addr, unsigned int len,
> +					  unsigned long val)
> +{
> +	struct vgic_v5_its *its =3D dev;
> +	size_t offset =3D addr & (SZ_64K - 1);
> +
> +	guard(mutex)(&its->its_lock);
> +
> +	switch (offset) {

[ ... ]

> +	case GICV5_ITS_INV_EVENTR:
> +		its->inv_eventr.l1 =3D
> +			FIELD_GET(GICV5_ITS_INV_EVENTR_L1, val);
> +		its->inv_eventr.itt_l2sz =3D
> +			FIELD_GET(GICV5_ITS_INV_EVENTR_ITT_L2SZ, val);
> +		its->inv_eventr.i =3D FIELD_GET(GICV5_ITS_INV_EVENTR_I, val);
> +		return;
> +	case GICV5_ITS_SYNCR:
> +	case GICV5_ITS_READ_EVENTR:
> +		return;

[ ... ]

> @@ -31,11 +298,153 @@ static void vgic_v5_mmio_write_its_wi(struct kvm *k=
vm, void *dev, gpa_t addr,
>  	}
> =20
>  static const struct vgic_register_region vgic_v5_its_registers[] =3D {

[ ... ]

> +	REGISTER_ITS_V5_DESC(GICV5_ITS_STATUSR, vgic_v5_mmio_read_its_dt_itt,
> +			     vgic_v5_mmio_write_its_wi, 4, VGIC_ACCESS_32bit),
> +	REGISTER_ITS_V5_DESC(GICV5_ITS_SYNCR, vgic_v5_mmio_read_its_raz,
> +			     vgic_v5_mmio_write_its_dt_itt, 4,
> +			     VGIC_ACCESS_32bit),

[Severity: Medium]
Should GICV5_ITS_SYNCR be registered as an 8-byte register with
VGIC_ACCESS_64bit | VGIC_ACCESS_32bit (and handle GICV5_ITS_SYNCR + 4 in
vgic_v5_mmio_write_its_dt_itt())?

In include/linux/irqchip/arm-gic-v5.h, GICV5_ITS_SYNCR is a 64-bit register
with GICV5_ITS_SYNCR_SYNC at BIT_ULL(63) and GICV5_ITS_SYNCR_SYNCALL at
BIT_ULL(32):

#define GICV5_ITS_SYNCR_SYNC			BIT_ULL(63)
#define GICV5_ITS_SYNCR_SYNCALL			BIT_ULL(32)
#define GICV5_ITS_SYNCR_DEVICEID		GENMASK_ULL(31, 0)

In drivers/irqchip/irq-gic-v5-its.c, gicv5_its_syncr() performs a 64-bit MM=
IO
write to this register:

	syncr =3D FIELD_PREP(GICV5_ITS_SYNCR_SYNC, 1) |
		FIELD_PREP(GICV5_ITS_SYNCR_DEVICEID, its_dev->device_id);

	its_writeq_relaxed(its, syncr, GICV5_ITS_SYNCR);

With length 4 and VGIC_ACCESS_32bit in vgic_v5_its_registers[],
vgic_get_mmio_region() -> check_region() rejects 64-bit guest accesses to
GICV5_ITS_SYNCR, and vgic_find_mmio_region() fails to match 32-bit accesses=
 to
the upper word at GICV5_ITS_SYNCR + 4. This also causes the
KVM_DEV_ARM_VGIC_GRP_ITS_REGS userspace attribute access added later in the
series to treat GICV5_ITS_SYNCR as a 32-bit register rather than a 64-bit
register.

[ ... ]

> +static void vgic_v5_its_reset(struct vgic_v5_its *its)
> +{
> +	u64 mmfr0;
> +
> +	its->enabled =3D false;
> +
> +	mmfr0 =3D read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1);
> +	its->idr0.pa_range =3D cpuid_feature_extract_unsigned_field(
> +		mmfr0, ID_AA64MMFR0_EL1_PARANGE_SHIFT);
> +	its->idr0.domain =3D GICV5_ITS_IDR0_DOMAIN_NON_SECURE;
> +	its->idr0.mec =3D 0;
> +	its->idr0.mpam =3D 0;
> +	its->idr0.swe =3D 0;
> +	its->idr0.its_id =3D 0;
> +
> +	its->idr1.dt_levels =3D 1;
> +	its->idr1.itt_levels =3D 1;
> +	its->idr1.l2sz =3D 0;

[Severity: Medium]
In vgic_v5_its_reset(), dt_levels and itt_levels are set to 1 to advertise
2-level Device Tables and Interrupt Translation Tables, while its->idr1.l2sz
is initialized to 0.

In include/linux/irqchip/arm-gic-v5.h, GICV5_ITS_IDR1_L2SZ (bits [10:8]) is=
 a
3-bit support bitmap rather than the 2-bit size encoding used in
GICV5_ITS_DT_CFGR_L2SZ:

#define GICV5_ITS_IDR1_L2SZ		GENMASK(10, 8)
#define GICV5_ITS_IDR1_ITT_LEVELS	BIT(7)
#define GICV5_ITS_IDR1_DT_LEVELS	BIT(6)
#define GICV5_ITS_IDR1_DEVICEID_BITS	GENMASK(5, 0)

#define GICV5_ITS_IDR1_L2SZ_SUPPORT_4KB(r)	FIELD_GET(BIT(8), (r))
#define GICV5_ITS_IDR1_L2SZ_SUPPORT_16KB(r)	FIELD_GET(BIT(9), (r))
#define GICV5_ITS_IDR1_L2SZ_SUPPORT_64KB(r)	FIELD_GET(BIT(10), (r))

When a guest reads GICV5_ITS_IDR1 through vgic_v5_mmio_read_its_misc(),
FIELD_PREP(GICV5_ITS_IDR1_L2SZ, its->idr1.l2sz) reports 0b000, indicating t=
hat
none of the 4KB, 16KB, or 64KB L2 granule sizes are supported. In
drivers/irqchip/irq-gic-v5-its.c, gicv5_its_l2sz_two_level() checks those
support bits and fails all of them (falling back to 4KB even on 16KB or 64KB
page size guests, despite parse_two_level_dt() and parse_two_level_itt()
supporting all three sizes).

Should its->idr1.l2sz be initialized with the supported L2 table size bits =
set
instead of 0?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102194454.4086=
911-1-sascha.bischoff@arm.com?part=3D6
