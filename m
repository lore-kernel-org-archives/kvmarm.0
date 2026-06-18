Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A23703F4852
	for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 12:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781785689; cv=none; b=EbtekpHTaAYRbTuha7FKhGf1AXcFys1mSP8UInIq+FSWjNzUi+2PBXtNDlvWchqMAD8S7wtpCtvK2r5rV1bOL4XGf4rlnrZFFLZmkON38EoV42gBgCKDMctY4m7hbYUf6YuMw7NyAWRmsHzmojDks/JwX1K1jKkAKnJt9SgL/8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781785689; c=relaxed/simple;
	bh=sk1Qva+YXgYf86Ryzh0MN11nsEJFqtocEKqUITm5US8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ONAzFPM3xdK0cmsFo9XWPQfdNOHn4SnFAcaKBrI7+4Gi66pKRuVkmJLYt1UGb9mE6YnBzOmLmPdkLAjvlE7i1XZWgTkb7Sgm1JhGMQG5KBhptSKLl5yip14W19Ct8AY1vBKnVzH6L7RH5PhPLEp4P3k7bDKlFJoE/A9T9xEd9P4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L5MkCGKG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L5MkCGKG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1369D1F000E9;
	Thu, 18 Jun 2026 12:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781785688;
	bh=bTN0aK5Z12U9KMOmKQf6/plC9i4R5emol+4r+sB2kHI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=L5MkCGKGeEB+D7hPiDE+bTCVYNkzZwSsSLbt+Wi1bflK/WRysoHV/j3fSgB+lx2yt
	 bdujOL9OTUgue6jM5BTpcTKjYSJmrt4dYemCQHJtlzDYVgTAFGVrk0MVSJV9gPWwT/
	 vCV44pbMX9MVtyseBE1uy4ubk+OyZgLApBhcmKFmmJFV5BaTuEvIyxateRaycJbJoX
	 1UO+7bsiVeKvLfZB9OscmkL495zySLojNwzO0Jd5JGZ916f45DHTWz77ToljKLvjB+
	 TR67RSkoQA7/nYMkLzx0E7tR8hI9Atz5gKM7s3CZi50LxPNaWMyIxYxmX8TR3fC+3s
	 T8vdclYN+Ohxg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 4/7] KVM: arm64: Set IL for injected FPAC exceptions
 during ERET emulation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <tabba@google.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260618121643.4105064-5-tabba@google.com>
References: <20260618121643.4105064-1-tabba@google.com>
 <20260618121643.4105064-5-tabba@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 18 Jun 2026 12:28:07 +0000
Message-Id: <20260618122808.1369D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The constructed FPAC exception syndrome incorrectly maps the ERET =
ISS encoding directly to the FPAC ISS encoding, resulting in malformed ISS[=
2:0] bits being injected into the guest.
--

commit 27996a8004c4285e2d114067b3fc644f3f649d64
Author: Fuad Tabba <tabba@google.com>
KVM: arm64: Set IL for injected FPAC exceptions during ERET emulation

This commit sets the IL (Instruction Length) bit for the FPAC syndrome
constructed during nested ERET emulation. Since ERET and its authenticated
variants are always A64 32-bit instructions, the IL bit must be set to 1.

> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nes=
ted.c
> index dba7ced74ca5e..b74369e9ad7ff 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -2776,7 +2776,7 @@ void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu)
>  		 * ERET handling, and the guest will have a little surprise.
>  		 */
>  		if (kvm_has_pauth(vcpu->kvm, FPACCOMBINE) && !(spsr & PSR_IL_BIT)) {
> -			esr &=3D ESR_ELx_ERET_ISS_ERETA;
> +			esr &=3D (ESR_ELx_ERET_ISS_ERETA | ESR_ELx_IL);

[Severity: High]
This isn't a bug introduced by this patch, but does this mapping of the ERET
ISS to the FPAC ISS result in malformed ISS[2:0] bits being injected into
the guest?

For an ERET trap (EC=3D0x1A), ISS[0] indicates the key used (0 for ERETAA,
1 for ERETAB). For an FPAC exception (EC=3D0x1C), ISS[0] is the Instruction
Type (must be 1 for a branch/return instruction), and ISS[2:1] indicates
the Authentication Key.

By retaining the ERET ISS[0] bit and clearing the rest, it appears KVM
inadvertently maps the ERET key type directly into the FPAC Instruction
Type bit, while leaving the FPAC key type (ISS[2:1]) always at 00.

Consequently, wouldn't ERETAA be injected with an FPAC ISS of 0 (wrong
instruction type), and ERETAB get an FPAC ISS of 1 (wrong key type)?

>  			esr |=3D FIELD_PREP(ESR_ELx_EC_MASK, ESR_ELx_EC_FPAC);
>  			kvm_inject_nested_sync(vcpu, esr);
>  			return;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260618121643.4105=
064-1-tabba@google.com?part=3D4
