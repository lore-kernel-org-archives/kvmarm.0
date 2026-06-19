Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29347C15C
	for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 07:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781853363; cv=none; b=qZSEB3sRfZfnlx1nsqyl266WC4tILTZJ4COrNt0LCD6gWfOC4bQFQyg9c88EvBNx2vU64rDDmYoIBxSK42s1VCtljiIeejGLsIMff9VJUtxoSbRS4SxCgtqG4UaH5ub4w8TC7DizPomM8d2+igdWYyMhMz/V4iHZyv+NJzRZSmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781853363; c=relaxed/simple;
	bh=FJ5UqyMfLS16NdKoO/DLl8Z8RxI4zEretoI3RwFA5eU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=rV7H7D40Q25IUaEh4ZpJxlKnyODX5RVL1nNkqv9Hiv1NTa5yjhiCkN2alBv2gBXwhWPfL/280/ERFZX7FVu2SY7/2QPIFUGXst1NwiMNbZDynvypOrzBGRf7AdmJxL0SvVwZOUCygJIg3+M0uq5AHYncWU+0mblcSvxC01Ene8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k10wx8nH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k10wx8nH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5E641F000E9;
	Fri, 19 Jun 2026 07:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781853361;
	bh=SPhQbePrlF1GobQGOOj8sAxFWwm8YDl52qF2rsX32V0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=k10wx8nH7pWrcr0Z3FT7f0fWoNn4681nlqeEcLZzGbGeIYkkH8kalGvBa1ikt+Rzn
	 6vunf77IcnU/Y1BKqiXlmumNDeE/A9AmAXAAdI/l8cxzVU94pbf6Bc8KrqP9TO0djn
	 auecnNI5bmEhTE+FduQ7Dr62bLpIb53uDLlzjbRx+efYZaF2EiWFsJrDGNXzcdQRKO
	 FRzDgbMAzZ1wLvbwJrFmyiJwdygobofMKQzatXGuqojjxbymexDuPQljMWM1fN80GA
	 D5gCt3sIa7F1DoOE/041oQ2pkHlvJI8AcD0IwZavg+5Z0StNHegO9ei3iVc/CoXSdw
	 VAcjF7iZ4d9kQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 4/8] KVM: arm64: Move PSCI helper functions to a shared
 header
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <tabba@google.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260619070508.802802-5-tabba@google.com>
References: <20260619070508.802802-1-tabba@google.com>
 <20260619070508.802802-5-tabba@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 19 Jun 2026 07:16:01 +0000
Message-Id: <20260619071601.A5E641F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] The header `include/kvm/arm_psci.h` is not self-contained due to mi=
ssing includes for dependencies used in the newly added inline functions.
--

commit 5533f45659b895d2266b9d4cfb6fd00ea1dc5f92
Author: Fuad Tabba <tabba@google.com>

KVM: arm64: Move PSCI helper functions to a shared header

This commit moves several PSCI helper functions out of psci.c and into the
shared include/kvm/arm_psci.h header. This includes kvm_psci_valid_affinity=
()
and kvm_psci_narrow_to_32bit(), along with renaming psci_affinity_mask().

[ ... ]

> diff --git a/include/kvm/arm_psci.h b/include/kvm/arm_psci.h
> index cbaec804eb839..f86a006d67136 100644
> --- a/include/kvm/arm_psci.h
> +++ b/include/kvm/arm_psci.h
> @@ -38,6 +38,33 @@ static inline int kvm_psci_version(struct kvm_vcpu *vc=
pu)
>  	return KVM_ARM_PSCI_0_1;
>  }
> =20
> +/* Narrow the PSCI register arguments (r1 to r3) to 32 bits. */
> +static inline void kvm_psci_narrow_to_32bit(struct kvm_vcpu *vcpu)
> +{
> +	int i;
> +
> +	/*
> +	 * Zero the input registers' upper 32 bits. They will be fully
> +	 * zeroed on exit, so we're fine changing them in place.
> +	 */
> +	for (i =3D 1; i < 4; i++)
> +		vcpu_set_reg(vcpu, i, lower_32_bits(vcpu_get_reg(vcpu, i)));

[Severity: Low]
Does this change leave arm_psci.h relying on implicit includes?

The moved inline function kvm_psci_narrow_to_32bit() relies on vcpu_set_reg=
()
and vcpu_get_reg() which are defined in asm/kvm_emulate.h, as well as
lower_32_bits() which comes from linux/wordpart.h.

Should this header explicitly include those files to ensure it remains
self-contained, so that future users don't encounter build errors if they
include this file first?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260619070508.8028=
02-1-tabba@google.com?part=3D4
