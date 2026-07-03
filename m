Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D1B4224FA
	for <kvmarm@lists.linux.dev>; Fri,  3 Jul 2026 10:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783073740; cv=none; b=We3dkub+Na/CBEVXMqu4szlLAg209t6vfqRJwm92S+2DbZk7ZidUA7Zr0aapWEUxA55womCbzvwAdfiv7gN0TQm7zcMFJ4UE5eZZwyBVFtTpdaqU6QmOwbsqX00TCPWgmD0dAMyROpLRUCjGTzR2FOTGdP4nOoeZC+aw4jnD+K8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783073740; c=relaxed/simple;
	bh=VCiCaMi4q04cK7jQAYRYngR/21HF4LGgolIgPcv8FbQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=KEXOARoURYxClzAmpOF/d9pNgGc5BptkTl2YPHCDpCVy6vG9xHR7zUzhOUBQiZXo89AORhWvgv/LFeEooPFJoc1MOirfun/XZSfsaQPkIvL4T4nu/2q2b/+CRPEkh/n5Z0pV4Lo7uozmXwC6RlqwI2Nu16Egr7yMQNgZYR0iKwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NRMySUJB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NRMySUJB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 180161F000E9;
	Fri,  3 Jul 2026 10:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783073739;
	bh=PAhcGfiCRXGSeWh8vddYPOYsZPSepyne6ZPdVnBUk7w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NRMySUJBTYtiJGQ5zufiAtGYTvdnFDgSgVoHDbtEuAZCrAXqmtfRuQZr0vEIoWFZk
	 TIFvsi1XvNB95HCfWVMfHuB+FmnuFc8/U+ShdDFgTOkEPJNz1ZrOrCEkYA2bQOXYk6
	 Tdzgz+qID/BqH7xuh3hcHDQHuTU6svUE0Jq0MR1VLXSldrZ0YYCeEN7wAX+pbAK4Dg
	 hAEegMioYCjTmcSZFdSno5pG+10iN1W1C0nsVFjttoUC5AgMEz7dOnglYcSmumpv7q
	 nof7pPxDMANm88JdmkssmmVHFrkjQSxIUakd4LAhXyOFY4aN4I3HCgDLVIHcS+nvw6
	 et1EkuuWoqaNw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 06/17] arm64/booting: Document boot requirements for
 FEAT_NMI
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jinjie Ruan" <ruanjinjie@huawei.com>
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260703100135.2512312-7-ruanjinjie@huawei.com>
References: <20260703100135.2512312-1-ruanjinjie@huawei.com>
 <20260703100135.2512312-7-ruanjinjie@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 10:15:38 +0000
Message-Id: <20260703101539.180161F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Missing `isb()` after writing to the `MDSCR_EL1` control-plane sys=
tem register.
--

commit 46ea647f84f4a1084bfe385f4fadb172648a5a6f
Author: Mark Brown <broonie@kernel.org>

arm64/booting: Document boot requirements for FEAT_NMI
   =20
In order to use FEAT_NMI we must be able to use ALLINT, require that it
behave as though not trapped when it is present.

Link: https://lore.kernel.org/r/20221112151708.175147-2-broonie@kernel.org

> diff --git a/Documentation/arch/arm64/booting.rst b/Documentation/arch/ar=
m64/booting.rst
> index 13ef311dace83..aaabe8fa4cdd7 100644
> --- a/Documentation/arch/arm64/booting.rst
> +++ b/Documentation/arch/arm64/booting.rst
> @@ -419,6 +419,12 @@ Before jumping into the kernel, the following condit=
ions must be met:
> =20
>      - HCR_EL2.ATA (bit 56) must be initialised to 0b1.
> =20
> +  For CPUs with Non-maskable Interrupts (FEAT_NMI):
> +
> +  - If the kernel is entered at EL1 and EL2 is present:
> +
> +    - HCRX_EL2.TALLINT must be initialised to 0b0.
> +
>    For CPUs with the Scalable Matrix Extension version 2 (FEAT_SME2):
> =20
>    - If EL3 is present:

[Severity: High]
This isn't a bug introduced by this patch, but there is a pre-existing issue
in arch/arm64/kernel/debug-monitors.c:

arch/arm64/kernel/debug-monitors.c:mdscr_write() {
	struct exception_mask mask;

	mask =3D local_exception_save_and_mask();
	write_sysreg(mdscr, mdscr_el1);
	local_exception_restore(mask);
}

Is an isb() missing after writing to the MDSCR_EL1 control-plane system
register?

The write_sysreg(mdscr, mdscr_el1) call is not immediately followed by an i=
sb()
instruction. Instead, local_exception_restore() executes multiple instructi=
ons
against architecturally undefined pipeline state.

Can this missing context synchronization cause the CPU to operate under a s=
tale
configuration for several cycles?

Because this path is reachable by unprivileged userspace via the ptrace sys=
tem
call, could this lead to unexpected traps or violations of architectural
invariants?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703100135.2512=
312-1-ruanjinjie@huawei.com?part=3D6
