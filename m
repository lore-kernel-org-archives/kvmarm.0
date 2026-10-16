Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 446D24DC551;
	Fri, 16 Oct 2026 16:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792167120; cv=none; b=eYK1N6Zm/qr2cGaDrmIwFdgybLn/x+A1t1+S3dd6E5h5wwS6Km03Coqk1kv2HAs9iEMNMK7SBF9AYBkos6zmUgjbBuRySDL62OekFgjX2XkTcaNmT+vKG1EZLmE4ChEAyUAw2Bs7I9QZS8YC0K/sS5Bz+0FSSGQ0PddkHZDMJXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792167120; c=relaxed/simple;
	bh=8udg7/Y0vtPLb+YaEi+XK54yOn96d5LjgawTcIHB74o=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=Rozk73IUYI/Kwmr6CT6y485r43MDE6J9wCnT83pSVGGEIh1ch1wJXVxl5SPDpCGdB/ynUVz735KQAI1Y6bOyqc0SiCOUjAySB2Lxb3nPDHtHIh1X/nClUqCKRZ5Zv+aN6o2WkISr9UPZcOvJYGr5DYdzFDC985P4fQVx9oz8suQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g1h0r5Pb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g1h0r5Pb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 911BF1F000C4;
	Fri, 16 Oct 2026 16:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792167117;
	bh=31YHdC5GLg308gpID/McJsemnIVZ+YQAgJBEq+aKVXw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=g1h0r5PbyCG2q71h7CY8qBrNr8VG2Mf/iot359vHdOMDcD8+x9T9kYaBBL76tONsU
	 GHCWjbgeOdWGpQc3g3jz7cUElwBTd3cAiCQOkzOIlvJsIbO4xbWNxD3YmZ21sCqObM
	 vyYHX1WS/l74fjemjaVS1nf4wiuy1xs3HTWqluSUI5UYGvNY0Zmy4vI5S0T85ptnyP
	 +58qe8vM4JcfALPAqQ1A9RheRCqfZc5OqreDR76nNbX1rbs/XaUFG2I31rWvEzJHMR
	 Mg547eKyvP1+gzl0TgiER43Yy1W4ziVx86TkEo+GzcabagO6xVbvryad9bfQT9y8XQ
	 blh1J6bS+XCEA==
Message-ID: <sashiko-outbox-174609@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 06/16] KVM: arm64: gic-v5: Add ITS MMIO state emulation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <sascha.bischoff@arm.com>, kvmarm@lists.linux.dev, kvm@vger.kernel.org
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261016155741.979985-7-sascha.bischoff@arm.com>
References: <20261016155741.979985-1-sascha.bischoff@arm.com>
 <20261016155741.979985-7-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 16 Oct 2026 16:11:57 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] kvm: arm64: Data race and TOCTOU due to missing its_lock in MMIO h=
andlers
- [High] kvm: arm64: gic-v5: Userspace writes to ITS READ_EVENT_DATAR and I=
D registers are silently dropped
--

commit cda638a2b9c74f59afeb5648c53ce1083d96d5c3
Author: Sascha Bischoff <sascha.bischoff@arm.com>

KVM: arm64: gic-v5: Add ITS MMIO state emulation

In order to expose a virtual GICv5 ITS to the guest, KVM needs to
emulate the ITS CONFIG_FRAME and its translation-control registers.
Replace the placeholder ITS IODEV region with the GICv5 ITS register
layout and handlers for the architected MMIO state.

> diff --git a/arch/arm64/kvm/vgic/vgic-its-v5.c b/arch/arm64/kvm/vgic/vgic=
-its-v5.c
> index f8184b4ae0ccd..fda75314229a5 100644
> --- a/arch/arm64/kvm/vgic/vgic-its-v5.c
> +++ b/arch/arm64/kvm/vgic/vgic-its-v5.c

[ ... ]

> +static void vgic_v5_mmio_write_its_misc(struct kvm *kvm, void *dev, gpa_=
t addr,
> +					unsigned int len, unsigned long val)
> +{
> +	struct vgic_v5_its *its =3D dev;
> +	size_t offset =3D addr & (SZ_64K - 1);
> +
> +	switch (offset) {
> +	case GICV5_ITS_CR0:
> +		its->enabled =3D FIELD_GET(GICV5_ITS_CR0_ITSEN, val);
> +		return;
> +	case GICV5_ITS_CR1:
> +		its->cr1.sh =3D FIELD_GET(GICV5_ITS_CR1_SH, val);
> +		its->cr1.oc =3D FIELD_GET(GICV5_ITS_CR1_OC, val);
> +		its->cr1.ic =3D FIELD_GET(GICV5_ITS_CR1_IC, val);
> +		its->cr1.dt_ra =3D FIELD_GET(GICV5_ITS_CR1_DT_RA, val);
> +		its->cr1.itt_ra =3D FIELD_GET(GICV5_ITS_CR1_ITT_RA, val);
> +		return;
> +	default:
> +		return;
> +	}
> +}

[Severity: High]
Does this code introduce a data race or TOCTOU vulnerability?

The vgic_v5_mmio_write_its_misc() function modifies the its->enabled flag
and its->cr1 fields without acquiring its->its_lock. Concurrently,
vgic_v5_mmio_write_its_dt_itt() uses guard(mutex)(&its->its_lock) to safely
evaluate !its->enabled and modify table bases.

Allowing lockless modification of its->enabled could bypass the check
if another vCPU is simultaneously writing to translation base registers.
Additionally, this permits torn reads of the multi-field cr1 struct. Should
this function acquire its->its_lock?

[ ... ]

>  static const struct vgic_register_region vgic_v5_its_registers[] =3D {
> -	REGISTER_ITS_V5_DESC(0, vgic_v5_mmio_read_its_raz,
> -			     vgic_v5_mmio_write_its_wi, KVM_VGIC_V5_ITS_SIZE,
> +	REGISTER_ITS_V5_DESC(GICV5_ITS_IDR0, vgic_v5_mmio_read_its_misc,
> +			     vgic_v5_mmio_write_its_wi, 4, VGIC_ACCESS_32bit),
> +	REGISTER_ITS_V5_DESC(GICV5_ITS_IDR1, vgic_v5_mmio_read_its_misc,
> +			     vgic_v5_mmio_write_its_wi, 4, VGIC_ACCESS_32bit),
> +	REGISTER_ITS_V5_DESC(GICV5_ITS_IDR2, vgic_v5_mmio_read_its_misc,
> +			     vgic_v5_mmio_write_its_wi, 4, VGIC_ACCESS_32bit),

[ ... ]

> +	REGISTER_ITS_V5_DESC(GICV5_ITS_READ_EVENT_DATAR,
> +			     vgic_v5_mmio_read_its_dt_itt,
> +			     vgic_v5_mmio_write_its_wi, 8,
> +			     VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),

[Severity: High]
Are userspace writes to restore migration state being silently dropped?

Both the ID registers (e.g. IDR0) and READ_EVENT_DATAR are configured
with the vgic_v5_mmio_write_its_wi write-ignore handler. Since there is no
explicit userspace override provided for these registers, a userspace write
will fall back to the guest MMIO write handler, accepting the write and
returning success (0) but discarding the value.

For ID registers, ignoring the write prevents the VMM from detecting
incompatibility across migration. For READ_EVENT_DATAR, the result of an
inflight READ_EVENTR command is lost. Does this violate the ABI contract
that userspace writes must either take effect or return an error?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261016155741.9799=
85-1-sascha.bischoff@arm.com?part=3D6
