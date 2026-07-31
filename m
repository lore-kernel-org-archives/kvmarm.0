Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE4F429CFA
	for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 13:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785503008; cv=none; b=Ms3ocKHph4lrf6u4WJ4xSYNzO/PAWLfF1op9Rp0+3ViTiJsAlkFm6nkzf/E7AzOZa81Hriv1xUBipyOxlvZXHU6bRYjqJ1Lt/sVTzXMxdw7z3c1Vvk1q9TWCaCqf5tmVtOJ+q/9h+s0SNUnrwFM2KEI/5y1zyMIyaXq42JeqqxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785503008; c=relaxed/simple;
	bh=xwOYZKGq6mXs25PB7Tm6W2hh3Y8hZcqM3y/c7sooAZ0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=t1DgswGFxBkDDatJJTJx3Kq5EtGS2yucsc57gc2uJMae0RIqxmItoFCBeYbckIu10SzBZ5aTkJNWLOg7uOS8UJAC45M0i6Xg/8lN3urLLR7ynLQ6S2bHCaiVCR236W8Msy+hM9kbKbBH3Wn3UXyKlWpCTGqlwtjQNv6P4OQBwIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gWRy/BDR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gWRy/BDR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC5701F00ACA;
	Fri, 31 Jul 2026 13:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785503006;
	bh=N1F0sE9guthW6ScTZXDASF8hqwRSGTEg3OjPDeoF4JA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gWRy/BDRimka6A6GzLaUAm33xMzb5XP+Ztub5gRvqBsgDu7A+BcyuG+ntIZMEa+ti
	 0ZLq++MUbjdp/755X7YlOseFx1nw7m9LrmNxtpo94XaN16Lz1+BBWLliAVz1OEkcGE
	 xTVWa8cU9Pg+Etgsj5+X8S5vKCAw4YCcWwabnfi2QufodBPjQkz1l1Zx6k/X1mHbbP
	 gXDjtwmaLmnPD3RRMHwDmtlmyS21dyMqhcmd0GVN/wWEJdzznJtHg5JWqink+15AyE
	 4+nCCFwuU3vd/G6ZVxv8uewGVuTQ1rdFR9Rdexf/pTc5oeSgReCfZGr7Oh6K5R6NCX
	 fVTILtdsuxwDA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v17 02/14] KVM: arm64: Fix FGT mapping for
 HFGITR_EL2.nGCSEPP
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mark Brown" <broonie@kernel.org>
Cc: "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260731-arm64-gcs-v17-2-5e39ca01b14e@kernel.org>
References: <20260731-arm64-gcs-v17-0-5e39ca01b14e@kernel.org>
 <20260731-arm64-gcs-v17-2-5e39ca01b14e@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 31 Jul 2026 13:03:26 +0000
Message-Id: <20260731130326.AC5701F00ACA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The Fine-Grained Trap mapping for HFGITR_EL2.nGCSPUSHM_EL1 is inco=
mplete because it omits the GCSPOPM instruction.
--

--- Patch [2]: [PATCH v17 02/14] KVM: arm64: Fix FGT mapping for HFGITR_EL2=
.nGCSEPP ---
commit f77ebfc89e5efb51bc091da72e90af3bc7f593a6
Author: Mark Brown <broonie@kernel.org>

KVM: arm64: Fix FGT mapping for HFGITR_EL2.nGCSEPP

This commit updates the encoding-to-trap mapping for HFGITR_EL2.nGCSEPP to
reflect that it controls trapping of GCSPUSHX and GCSPOPCX, fixing an
incorrect mapping to GCSPOPX.

> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nes=
ted.c
> index 3c82f392845d1..b32742d9dd73e 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c

[ ... ]

> @@ -1432,7 +1432,7 @@ static const struct encoding_to_trap_config encodin=
g_to_fgt[] __initconst =3D {
>  	SR_FGT(OP_AT_S1E1A, 		HFGITR, ATS1E1A, 1),
>  	SR_FGT(OP_COSP_RCTX, 		HFGITR, COSPRCTX, 1),
>  	SR_FGT(OP_GCSPUSHX, 		HFGITR, nGCSEPP, 0),
> -	SR_FGT(OP_GCSPOPX, 		HFGITR, nGCSEPP, 0),
> +	SR_FGT(OP_GCSPOPCX, 		HFGITR, nGCSEPP, 0),
>  	SR_FGT(OP_GCSPUSHM, 		HFGITR, nGCSPUSHM_EL1, 0),

[Severity: High]
This isn't a bug introduced by this patch, but is the Fine-Grained Trap
mapping for HFGITR_EL2.nGCSPUSHM_EL1 incomplete here?

It looks like this maps OP_GCSPUSHM to nGCSPUSHM_EL1 but omits the GCSPOPM
instruction.

If an L1 hypervisor clears HFGITR_EL2.nGCSPUSHM_EL1 and the L2 guest
executes GCSPOPM, will L0 KVM fail to find OP_GCSPOPM in encoding_to_fgt
during triage_sysreg_trap() and incorrectly inject an UNDEF exception into
the L2 guest instead of properly forwarding the trap?

If so, does OP_GCSPOPM (sys_insn(1, 3, 7, 7, 1)) need to be defined in
arch/arm64/include/asm/sysreg.h and added to this array?

>  	SR_FGT(OP_BRB_IALL, 		HFGITR, nBRBIALL, 0),
>  	SR_FGT(OP_BRB_INJ, 		HFGITR, nBRBINJ, 0),

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260731-arm64-gcs-=
v17-0-5e39ca01b14e@kernel.org?part=3D2
