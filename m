Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F7B437F006;
	Fri, 16 Oct 2026 16:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792167443; cv=none; b=GTy//L/2ecW4QZ6QhLwnOLGJiABzN06fiY7ZDRxbxSiCSUCFsSww1XNYUqZSinw6HzdrJEW8TC8Dq6hKxLjQ98ts2vWjl5zX6RXCYY/E8OG58rxzWZxtDlq52nyQq0ZyHDJV+08wAQh1TOarq5QWW5BleEYeaZpcQxRjOvljZsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792167443; c=relaxed/simple;
	bh=3//BKI1A7au1gT4lihfgvCeE1R3WDxaBeIDvT2fzqpw=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=D8hbyoMKQWOR6PN3asnWsEiXsZw5C/oqc+dsAd3QTlVzszyq1p/WNQ5S8YmwnFfjBlnwkqh0OnUhlvcqohEvK/tiZRYYeY46/1lLOQuTnU6BmEFiEu7WQMcP8irM7K6kyvvKMBHVZKJ/dAKSiQ6VFbKfRetlG7nRUslUIjiv/r0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=obQ5Fi29; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="obQ5Fi29"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D7BD1F000C4;
	Fri, 16 Oct 2026 16:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792167438;
	bh=TRr2Z9TQ3bSko9O1jV9gr4++etiR+lopscD5B/GhQgE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=obQ5Fi295B51jEM17PcmdaONBQpLJJ9Cc6YS4pUPPlHz0hIi1YgDdiGSY9rPOnhL8
	 vqlbE+ndLm6FOWinksEArKqIqGcD7U1y0qTl94nOE3zOEopISceHBE+VwR6Yoldph1
	 5we7yduszPN3UkvFmGtH+Ig+/dFSTpKTdWRw9kMN8QCDl6aw9M59cBW+JnUOtq/H8m
	 gDNz5+fcx8D36ntma+b/PDu6nCAyKWQ62ZsfDLlM80UjEMUPUstAujWjHve19SX8P1
	 lpYKsAXZr7dLI66rlmxI8txJ6IgBvFlplT25LNatjHXV+r09WU0iIlBwqlrtz3m5kz
	 vMloeSnuqqvlw==
Message-ID: <sashiko-outbox-174621@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 07/16] KVM: arm64: gic-v5: Add ITS guest table
 translation emulation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <sascha.bischoff@arm.com>, kvmarm@lists.linux.dev, kvm@vger.kernel.org
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261016155741.979985-8-sascha.bischoff@arm.com>
References: <20261016155741.979985-1-sascha.bischoff@arm.com>
 <20261016155741.979985-8-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 16 Oct 2026 16:17:17 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] kvm: typed INTID used directly as XArray index in vgic_add_lpi()
- [Medium] kvm: arm64: gic-v5: Guest can bypass VITS_V5_DEVICE_ID_BITS poli=
cy cap
- [Low] kvm: compilation failure due to mismatched types in min() macro
--

commit c4304c740198b40a23d386e3b547cd38e75a6238
Author: Sascha Bischoff <sascha.bischoff@arm.com>

KVM: arm64: gic-v5: Add ITS guest table translation emulation

The GICv5 ITS consumes guest-owned translation tables. Unlike the
GICv3 ITS, KVM does not maintain a separate software device/table
model for GICv5 translations; the guest's DT and ITTs are the
authoritative source of DeviceID/EventID to LPI mappings.

> diff --git a/arch/arm64/kvm/vgic/vgic-its-v5.c b/arch/arm64/kvm/vgic/vgic=
-its-v5.c
> --- a/arch/arm64/kvm/vgic/vgic-its-v5.c
> +++ b/arch/arm64/kvm/vgic/vgic-its-v5.c
[ ... ]
> +static int get_itt(struct kvm *kvm, struct vgic_v5_its *its, u32 device_=
id,
> +		   gpa_t *itt_base, bool *two_level_itt,
> +		   unsigned int *event_id_bits, unsigned int *itt_l2sz)
> +{
> +	unsigned int dt_l2sz, device_id_bits;
> +	bool two_level_dt;
> +	gpa_t dt_base;
> +
> +	dt_base =3D its->dt_baser.addr;
> +	two_level_dt =3D its->dt_cfgr.structure;
> +	dt_l2sz =3D its->dt_cfgr.l2sz;
> +	device_id_bits =3D its->dt_cfgr.device_id_bits;
> +
> +	if (device_id >=3D 1UL << device_id_bits) {

[Severity: Medium]
Does this check allow the guest to bypass the VITS_V5_DEVICE_ID_BITS policy
cap?

KVM advertises a maximum of 16 device ID bits (VITS_V5_DEVICE_ID_BITS) and a
single-level DT in IDR1. However, when the guest writes to GICV5_ITS_DT_CFG=
R,
the fields are stored directly in its->dt_cfgr without being clamped to
these policy limits.

Since this out-of-bounds check compares against the un-clamped guest value
instead of the VITS_V5_DEVICE_ID_BITS cap, the guest could configure a
2-level DT and process Device IDs up to 31 bits, bypassing the advertised
policy cap.

> +		kvm_debug("Device ID out of range\n");
> +		return -E2BIG;
> +	}
[ ... ]
> +static int parse_two_level_itt(struct kvm *kvm, u32 event_id, gpa_t itt_=
base,
> +			       unsigned int itt_l2sz, __le64 *itt_l2_entry)
> +{
[ ... ]
> +	itt_l2_base =3D FIELD_GET(GICV5_ITTL1E_L2_ADDR_MASK, val) << 3;
> +	l2_event_id_bits =3D
> +		min(FIELD_GET(GICV5_ITTL1E_SPAN, val), itt_split_bits);

[Severity: Low]
Will this min() macro invocation cause a compilation failure due to mismatc=
hed
types?

The arguments to min() are FIELD_GET(GICV5_ITTL1E_SPAN, val) and
itt_split_bits. val is a 64-bit u64, making the FIELD_GET evaluation an
unsigned long long, while itt_split_bits is a 32-bit unsigned int.=20

The Linux kernel's min() macro enforces strict type equality and will cause
a build failure when comparing a 64-bit and 32-bit type. Could we use min_t=
()
here instead to resolve the mismatch?

> +	l2_event_id =3D event_id % (1UL << l2_event_id_bits);
[ ... ]
> +static int __vgic_v5_its_resolve_lpi(struct kvm *kvm, struct vgic_v5_its=
 *its,
> +				     u32 device_id, u16 event_id,
> +				     struct vgic_irq **irq)
> +{
[ ... ]
> +	val =3D le64_to_cpu(itt_l2_entry);
> +	if (!FIELD_GET(GICV5_ITTL2E_VALID, val)) {
> +		kvm_debug("ITTE is not valid\n");
> +		return -EINVAL;
> +	}
> +
> +	lpi =3D FIELD_GET(GICV5_ITTL2E_LPI_ID, val);
> +
> +	*irq =3D vgic_add_lpi(kvm, vgic_v5_make_lpi(lpi), NULL);

[Severity: High]
Does this pass a fully typed INTID directly to vgic_add_lpi()?

Here, the hardware LPI ID is extracted and converted to a full typed INTID
using vgic_v5_make_lpi(), which sets the GICv5 type bits in the upper nibbl=
e.
This typed INTID is passed to vgic_add_lpi(), which then uses it directly
as the array index for the lpi_xa XArray:

arch/arm64/kvm/vgic/vgic.c:vgic_add_lpi() {
    ...
	ret =3D xa_reserve_irq(&dist->lpi_xa, intid, GFP_KERNEL_ACCOUNT);
    ...
}

Using a typed INTID as an array index violates the GICv5 architectural rule
to strip type bits before indexing. It forces the XArray to allocate
unnecessary depth to reach indices over 1 billion, leading to memory waste
and incorrect type dispatch separation.

> +	if (IS_ERR(*irq))
> +		return PTR_ERR(*irq);
> +
> +	return 0;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261016155741.9799=
85-1-sascha.bischoff@arm.com?part=3D7
