Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED7D31D47AC
	for <kvmarm@lists.linux.dev>; Thu, 25 Jun 2026 14:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782399424; cv=none; b=eQETQIdweRTC6hS8JZMkkmX2oReR/bLF4lYWH/Ff9WIC060uM8HsxIYF2A87fujllHOy0xRzgCUtgBDt41lmRPDHxL6u5eSoj7M2DgKGKZz8uzUYQb6yH4bcIdrVR5+cajtFjjzZHutNk7RhZIaK2a//1yN09xi4iX2WbIlHKOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782399424; c=relaxed/simple;
	bh=PGnvVnyMcfUhH3SGOpwNsTLsQQU895NxQ7hIjf3udNs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=EJZZMiI0dDMg47Xdp8zBE3QiJU0qrx/KsW4U0eis1TyFHFGaP3+Io6j57jTpCgi3KW1R6tB/jWaHCYd0zuHH7cprpze+2MJzpMh6nbrkkhqbieY61yxfVezCXvDHDQBJSSkT1yf+zndlO8Z/fTTjTKEU4SivGuZAva/NoeOnHTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LPbfun79; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LPbfun79"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 460B41F000E9;
	Thu, 25 Jun 2026 14:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782399423;
	bh=Xa/WRv0cFRK5aoN0lmaUv7IA1w9KZhgUATY4lNHsf0k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LPbfun79XX3jtrm492956jzrVZbO9Z2BdpNvfD3ECg61J5FRb+/QRRhD39iFwhiEh
	 xon+wcJFvNbX61B/f1Jr1TDkRbvqWgPwz0TceeS1vyvzwPlko96IBPei0a4akymbQG
	 cULDsgzmEY5t0I9frRBbFMDCUIgqQnTwStTsrrbrhsIljcs3mN3Tka5hKqSmGKu+rx
	 Pi5QyjVxdF+rNUBm3aSlEZ28UYfD4vfpeWajoI37nV0qUp0WmvPVsyK8yBR5SwAIlv
	 znmNtvIm9AQNDf06RCy62fumIR9gstl3DNU8nBfOl3JjuQLxMhnxmf/5QZsaW63bHP
	 z7UmGrpGXzUbA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/2] KVM: arm64: selftests: Add MMIO sign-extending
 load test
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260625144807.2603272-3-fuad.tabba@linux.dev>
References: <20260625144807.2603272-1-fuad.tabba@linux.dev>
 <20260625144807.2603272-3-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 25 Jun 2026 14:57:02 +0000
Message-Id: <20260625145703.460B41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Guest EL1 will crash with an Instruction Abort because the `el0_=
be_loads` assembly block shares a page with EL1 test code and is marked as =
EL0-accessible.
--

commit 60c24b3648e8f92661ec2d484d27ac4580cad60a
Author: Fuad Tabba <fuad.tabba@linux.dev>

KVM: arm64: selftests: Add MMIO sign-extending load test

Adds a test for sign-extending MMIO loads (LDRSB, LDRSH, LDRSW) into Xt
and Wt destinations, with and without the sign bit set. The host supplies
the MMIO data and checks the guest register holds the sign-extended value.

> diff --git a/tools/testing/selftests/kvm/arm64/mmio_sign_ext.c b/tools/te=
sting/selftests/kvm/arm64/mmio_sign_ext.c
> new file mode 100644
> index 0000000000000..06708ab6db8c0
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/arm64/mmio_sign_ext.c

[ ... ]

> +extern char el0_be_loads[], el0_be_loads_end[];
> +asm(
> +"	.pushsection .text, \"ax\"\n"
> +"	.global el0_be_loads\n"
> +"el0_be_loads:\n"

[Severity: Medium]
Will this crash guest EL1 with an Instruction Abort?

The el0_be_loads assembly block lacks page alignment directives, placing it
adjacent to EL1 executable code in the same page of the .text section.

When make_el0_accessible() is called in main():

    make_el0_accessible(vm, (uint64_t)el0_be_loads,
                        el0_be_loads_end - el0_be_loads);

It makes the shared page EL0-accessible by setting PTE_USER. This
inadvertently makes the EL1 guest_code on the same page EL0-accessible. In
the ARMv8 EL1&0 translation regime, an instruction fetch by EL1 from an
EL0-accessible memory page unconditionally generates a Permission Fault.

> +"	ldrsb	x19, [x0]\n"
> +"	ldrsb	x20, [x0]\n"
> +"	ldrsb	w21, [x0]\n"

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260625144807.2603=
272-1-fuad.tabba@linux.dev?part=3D2
