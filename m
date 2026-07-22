Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1E7447255D;
	Wed, 22 Jul 2026 08:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784707918; cv=none; b=d7wXoOwOwy5Y7GBG6bUsWzyxgiCJzH32Sd/9lATdS1g3f1AOtZJUaZAhmFfwgsrkQeL9p+n3f1QENGUc+r6MYqhg/KzF6ZZvPecFHDYBtBjkElr+FtodKPrSJ1LGBLv9rHRhh+UbsRTuPt4XCxkOlLcxqpWNtTbBUbFTToM2MHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784707918; c=relaxed/simple;
	bh=zycOxJ2KaKa4ba5/KXUChvPHkp9D5UsdqkpwO0ZvYD8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Wyg238nhBc+pwfkSEBqf7w4qpxTO+NjZvkArAzsvxOahBkW1kXhxnTw/d9f2BbT0RN/Q08EI6EOn+lRah81g1NQTvwAoxCRkh4LgxVVVyLw8B4qvHYP57hJbJ6ILrzxQBfW9JMrcNDro4NGV5ZzqTSVv/haeh74YT6scjYfToDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bLkPA2em; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bLkPA2em"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E30171F000E9;
	Wed, 22 Jul 2026 08:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784707915;
	bh=naNSPmayR8ZBqVMAdBjvD2tc5rxL3V/GvPB4I4qQGJo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bLkPA2emL1O4EbMe5O1SoBHbIPtlVbahDJVhzqxgW4PSKRPxXazUVeqKaFjddzwyB
	 8xae1KoDSy7H5HYif/YkkjerJap9OnFflJL7jH7hLdHzYtoUn9KPaJ9cf7ohmcv/dj
	 d3yHTzH/bBhvBbcA3/vIlMVxg6WiPLZasGfT8uJb0y1P1HdWZi7uYzbUhZT9Fz2vKt
	 o87UeEfsTwkZB0ZlkYJvtSUK0+PagGzluz6KMKLkxPv4skpCNx6y96Ct0mmbgJd0Qu
	 mcaO8e2e0QI2O4m4EN36C3iRb9acU2798U6BBK1PuXqPOzAmqw2F7WGNUxk9An4PGC
	 cnhe7JDyCU6/Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 14/28] arm64: sysreg: Add HCRX_EL2 bits related to
 FEAT_NV3
Reply-To: sashiko-reviews@lists.linux.dev
To: "Marc Zyngier" <maz@kernel.org>
Cc: kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260722074234.3330999-15-maz@kernel.org>
References: <20260722074234.3330999-1-maz@kernel.org>
 <20260722074234.3330999-15-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 22 Jul 2026 08:11:54 +0000
Message-Id: <20260722081154.E30171F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] A `.sysreg` declarative change alters the generated `HCRX_EL2_RES0=
` mask by allocating new fields, but KVM's feature maps were not updated, l=
eading to semantic drift.
--

--- Patch [14]: [PATCH v3 14/28] arm64: sysreg: Add HCRX_EL2 bits related t=
o FEAT_NV3 ---
commit 60811bd1f3efd334ec0429ff21afed15626dfb76
Author: Marc Zyngier <maz@kernel.org>

arm64: sysreg: Add HCRX_EL2 bits related to FEAT_NV3

FEAT_NV3 introduces 4 new HCRX_EL2 control bits. Describe them
in the sysreg file.

> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index 42839d2b15ae4..67d013b376a3c 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -4548,7 +4548,12 @@ Fields	ZCR_ELx
>  EndSysreg
> =20
>  Sysreg	HCRX_EL2	3	4	1	2	2
> -Res0	63:27
> +Res0	63:35
> +Field	34	NVnTTLBOS
> +Field	33	NVnTTLBIS
> +Field	32	NVnTTLB
> +Res0	31:28
> +Field	27	NVTGE

[Severity: High]
Will this change to the declarative definition of HCRX_EL2 inadvertently br=
eak
KVM's guest register sanitization?

By changing bits 27, 32, 33, and 34 from Res0 to Field, this silently remov=
es
them from the auto-generated HCRX_EL2_RES0 mask.=20

However, KVM's hcrx_feat_map in arch/arm64/kvm/config.c relies on that mask
and was not updated to explicitly restrict these newly defined FEAT_NV3 fie=
lds:

arch/arm64/kvm/config.c:hcrx_feat_map[] =3D {
    NEEDS_FEAT(HCRX_EL2_SRMASKEn, FEAT_SRMASK),
    ...
};

Because these fields are now unmapped, check_feat_map() strictly enforces t=
he
initialization check and will fail unconditionally on host boot:

arch/arm64/kvm/config.c:check_feat_map() {
    ...
    if (mask !=3D ~resx)
        kvm_err("Undefined %s behaviour, bits %016llx\n",
            str, mask ^ ~resx);
}

More importantly, KVM uses these feature maps in compute_reg_resx_bits() to
calculate the valid bits a guest can modify. Without the fields present in
HCRX_EL2_RES0 or mapped in hcrx_feat_map, KVM fails to mark these bits as
RES0 for guests.=20

Could this allow an untrusted L1 nested guest to write to these unsanitized
EL2-level nested virtualization control bits, propagating to physical hardw=
are
when context-switching?

>  Field	26	SRMASKEn
>  Res0	25
>  Field	24	PACMEn

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260722074234.3330=
999-1-maz@kernel.org?part=3D14
