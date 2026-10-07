Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D2EE42A173;
	Wed,  7 Oct 2026 08:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791360240; cv=none; b=suHDDCpl0yvi9sTT9xvQH9N1q8jdU9D8rZlivkB9+hR+Aj9Z5Cc7PP7m6QKltrGBHamqE+WgDgfAfxQTELH2BwnTkjQ5FGTZAKdFpgluGirXPwrHheFvPOeRGbU/CvnEOcTLDjvrUKi3YuDTj1EcTGWyLzhKOqL2rdQHjAIyNRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791360240; c=relaxed/simple;
	bh=q9fFWovl648Mg0qphZOJpKtQYG4cl2PggTL2WjDDql4=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=RNbQklPtBYg1HLDnduHJ4BxcDta7CAFfONlhBXaEKraDM3PqbigMdLCkDHUGuXMDTxnewpZbCyrYn9PPm1i4PYFF91aQY0VR1fr0NfVEs69kUMjz8MSAOqNmzRyyS+Y7CEdzBj8hv7mxdZsvTwrG7/Xop9es0RO8mTpf7ExwiRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MKhi8UAw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MKhi8UAw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66BE61F0089B;
	Wed,  7 Oct 2026 08:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791360231;
	bh=YW5DLhGCUfABX+a+qvu/+5kyljL/KzZiFSmnXS91+mM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MKhi8UAwvd+rY/CgMcF6ssrryu60VZIAQ2iOtggKgH79vHRtcWvfLKq6h1M5VU2RO
	 dPEOoJIxmxDqUJf71LZtI3tjiORpKBNynZ9WgWv+Xngu4uMbYxQ64NQG/OoWun1VVm
	 16Uhy03zF8zS+c+N4/UwyM8rXLXbg2uSifKz+wrm8hwoNDG2mC4NiHTwyHyQl0kjcb
	 it+0DkU1oA/nwTlbgpQRygmAnN4aiBbib2JPS/M9xxSv3ksn193y+l4upFVRUb9dTb
	 DU1kYf8fQ+HZscYzyyUWSW6dkVAwKO9ArJdZpZ9ocNJmFFpVMgsI25i2yQJPZDbgJg
	 5EXcA+EO6CJiA==
Message-ID: <sashiko-outbox-162738@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v23 03/14] KVM: arm64: Include kvm_emulate.h in
 kvm/arm_psci.h
Reply-To: sashiko-reviews@lists.linux.dev
To: "Suzuki K Poulose" <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20261007073537.2454351-4-suzuki.poulose@arm.com>
References: <20261007073537.2454351-1-suzuki.poulose@arm.com>
 <20261007073537.2454351-4-suzuki.poulose@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 07 Oct 2026 08:03:51 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] Commit message incorrectly claims fix for vcpu_has_feature instead =
of vcpu_set_reg
--

commit 2bee02b3a3b5f85d378a4e48c38b6750bc566ae1
Author: Suzuki K Poulose <suzuki.poulose@arm.com>

KVM: arm64: Include kvm_emulate.h in kvm/arm_psci.h

This commit adds an include for asm/kvm_emulate.h in include/kvm/arm_psci.h
to fix an implicit function declaration build error.

>     ./include/kvm/arm_psci.h: In function =E2=80=98kvm_psci_version=E2=80=
=99:
>     ./include/kvm/arm_psci.h:29:13: error: implicit declaration of functi=
on
>        =E2=80=98vcpu_has_feature=E2=80=99; did you mean =E2=80=98cpu_have=
_feature=E2=80=99? [-Werror=3Dimplicit-function-declaration]
>        29 |         if (vcpu_has_feature(vcpu, KVM_ARM_VCPU_PSCI_0_2)) {
>                      |             ^~~~~~~~~~~~~~~~
>                                    |             cpu_have_feature

[Severity: Low]
Is this compiler error accurately reflecting the issue fixed by the patch?

Looking at the headers, vcpu_has_feature is actually defined in
arch/arm64/include/asm/kvm_host.h, which is already included via
linux/kvm_host.h at the top of the file.

The added asm/kvm_emulate.h header does not define vcpu_has_feature. Instea=
d,
it provides the inline definitions for vcpu_set_reg and vcpu_get_reg, which
are necessary for kvm_psci_narrow_to_32bit further down in the same header.

Could the commit message be misattributing the fix to vcpu_has_feature inst=
ead
of the register accessors?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261007073537.2454=
351-1-suzuki.poulose@arm.com?part=3D3
