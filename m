Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC8282D6E5A;
	Fri,  3 Jul 2026 16:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783096669; cv=none; b=WFW88N1isN+OXzktbuDUP89zNBSR2RFjHKfSgaUGUazcNm8qVQA5IugHsKAhRB+0dMQH10oHwrPx8XerJvN/iJ6dem3ymxJBSm0V2k42NSyBXkwmb2oAm9aHo/zFJH0TEhNbGmzfMLzkp3ws9WNeqECCsEWBIennC3Pmn92BzpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783096669; c=relaxed/simple;
	bh=t0uH00xXI0oJ/OcnNoTf+BQy0GLQ7AK7akC1EaPqK1o=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=EZwc2fGaCYKdabDSZb1LWWkfO0RZXZ3L0xgPS7+bzf2pFMdYtJtysymmWX/8dW/DUvKuwEYtR6zu5jQxVuHOqZRS7N93JSN6UgvTCLERz7vJXm12AIDwWWeYKk6u3OYGP5yGubQN02vy9/WRFBJ8lIcgVAoIORYDuCXyBfUrV78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Us2pBfp8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Us2pBfp8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A56551F000E9;
	Fri,  3 Jul 2026 16:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783096667;
	bh=0hIJwKf4MLosN3Wh4rj8FaG8Pu1Sm2ZdSq5HtejWblg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Us2pBfp84Khs1nLYrelQClOrqnPo9liwwG5+c6PymK4KmwZyGc5HP0o46IQH2+c+H
	 tHkupZ8bYOkbOdJoDHnRzZTeWtjqgK4K9bYj1cVrTtjHGqnQzDrkkaywG+T1fup6rS
	 bjjB1WL+Rn2T+EikL+uqJHdYX39kGgmGvQBH2CrAGl52JR7QGjuHiPg9W0yOb0+z3R
	 sf6ulfb/JcirsV4p8eoWFMT4Nq7V4L9cWVEbqw1gWHWBcHhE2mzArVhcTWMZUqtZku
	 4BsvDhyaIVqVqX7BqTMeUSic8XSphuWi8Neu9lXPgjIbFeqMIVMbLX02aWIdqImRtI
	 ERRlcokBsRnQg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 38/40] Documentation: KVM: Add
 KVM_DEV_ARM_VGIC_GRP_IRS_REGS to VGICv5 docs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260703154811.3355680-39-sascha.bischoff@arm.com>
References: <20260703154811.3355680-1-sascha.bischoff@arm.com>
 <20260703154811.3355680-39-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 16:37:45 +0000
Message-Id: <20260703163746.A56551F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Low] The documentation for the -EINVAL error condition is incomplete, mi=
ssing validation failures and uninitialized VCPU conditions.
- [Low] The documentation incorrectly lists IRS_IDR3 and IRS_IDR4 as except=
ions to the rule that writes to read-only registers are ignored.
--

commit da96eb3893a4c95a449b213ede4d5106eb17a5a3
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

Documentation: KVM: Add KVM_DEV_ARM_VGIC_GRP_IRS_REGS to VGICv5 docs

Document the KVM_DEV_ARM_VGIC_GRP_IRS_REGS attribute group used to
read and write the virtual IRS's MMIO register state. This provides a
GICv5-specific interface for state that is conceptually similar to the
VGICv3 ITS register interface, but uses IRS terminology instead of ITS.

> diff --git a/Documentation/virt/kvm/devices/arm-vgic-v5.rst b/Documentati=
on/virt/kvm/devices/arm-vgic-v5.rst
> index e2045b09f27d0..217a1ecfbdc5f 100644
> --- a/Documentation/virt/kvm/devices/arm-vgic-v5.rst
> +++ b/Documentation/virt/kvm/devices/arm-vgic-v5.rst
> @@ -141,3 +141,39 @@ Groups:
>      ICC_CR0_EL1
>      ICC_PCR_EL1
>      =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D

[ ... ]

> +      Writes to read-only registers are ignored by the kernel except for:
> +
> +      - IRS_IDR0 - IRS_IDR2 and IRS_IDR5 - IRS_IDR7: These are sanity ch=
ecked to
> +        ensure that they match a sane config.
> +      - IRS_IDR3 and IRS_IDR4: These are RAZ/WI as nested virtualization=
 is not
> +        supported.

[Severity: Low]
This isn't a bug, but is it correct to list IRS_IDR3 and IRS_IDR4 as
exceptions to the rule that writes to read-only registers are ignored?

Since RAZ/WI means write-ignored, shouldn't they just fall under the general
rule rather than being listed as an exception?

[ ... ]

> +  Errors:
> +
> +    =3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +    -ENXIO   Offset does not correspond to any supported register
> +    -EFAULT  Invalid user pointer for attr->addr
> +    -EINVAL  Offset is not 32-bit aligned for 32-bit MMIO registers, or =
not
> +             64-bit aligned for 64-bit registers

[Severity: Low]
This isn't a bug, but is the description for -EINVAL fully complete?

Does the kernel also return -EINVAL for validation failures on the
sanity-checked registers mentioned above, or if userspace attempts to
configure the IRS before any VCPUs are created?

> +    -EBUSY   VGIC is not initialized, or one or more VCPUs are running
> +    =3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703154811.3355=
680-1-sascha.bischoff@arm.com?part=3D38
