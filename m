Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3CC5394793;
	Thu, 30 Jul 2026 07:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785397207; cv=none; b=Uv8fpGPsi6QEEykZfOVZV/KelAE8tbKRkIK0vfZo5u1pN0XlJIFTtBlhbkFp7X7st35nNtkWB45GPLoEDyRfU+ECeuerFG01fmswUQMCczF14uCIVDsUrZPPQfjdJkBG4HNhwhMk/0uVCts4XnfuxWelo4L3PbliNOYWOXxxMyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785397207; c=relaxed/simple;
	bh=UqmIo035RLB5GZ2eONbUIzEfvxJ+WIFGLMXLB39gFew=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=JMTwCGwouuWe1Zlh7LCVQd9Ef23sWCmkCFz4OJBNLrPIU4C/JtMtunE7MOSe6xUuOvzcBbwwKiR7j0Lo7JqhTZ+AMEaQxc5Z6jsaEpnEG54bgbiLPM4xjBWFK3trYUJEmA7oGT94e4UCL1BZUcGhe+uLHgAL8SuEeG+LHgCSy8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QAtrAh8o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QAtrAh8o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07CE71F000E9;
	Thu, 30 Jul 2026 07:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785397206;
	bh=tHRwLzYCAfinQxpL1fk/S7vX/ShxAQIz6+RCQwOARvw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QAtrAh8osIXklayJm8If92O49sU/v+RarMqGqAjIbnIhWmhPtFLB3kdanWhxBDmEV
	 oxRW4BPk2HxKuneftpVBh+2R4NEa7pBDo7CVGMxy0k+lBp9TNLzc7xbR+OaDst2hRX
	 LWkGvvdlz9Z/4vez+/6saF02lvUZndeGrFuBic4TjG2d8cv03m3KyUIM2p+qjtYSzE
	 DId5KbJMEFvMn97AuFsRbgenZcnjCaZJcciqoRcekSzj3eEvuW14KerTdlTrJhQQ/w
	 bvqsI7Ax4au1H/IC8fdCE/PtbZXLziOdJ28gTaxx8EbJoGYV/S70lGMuUkZOAsSS+Q
	 2/VvlYwFqAQgw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 14/29] arm64: sysreg: Add HCRX_EL2 bits related to
 FEAT_NV3
Reply-To: sashiko-reviews@lists.linux.dev
To: "Marc Zyngier" <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260730071022.296811-15-maz@kernel.org>
References: <20260730071022.296811-1-maz@kernel.org>
 <20260730071022.296811-15-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 30 Jul 2026 07:40:05 +0000
Message-Id: <20260730074006.07CE71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Adding new HCRX_EL2 fields (NVnTTLBOS, NVnTTLBIS, NVnTTLB, NVTGE) =
to the sysreg file silently removes them from the auto-generated HCRX_EL2_R=
ES0 mask, but KVM's feature map was not updated to handle them. This semant=
ic drift breaks KVM validation and allows guests to inject unvirtualized CP=
U features into the host.
--

--- Patch [14]: [PATCH v4 14/29] arm64: sysreg: Add HCRX_EL2 bits related t=
o FEAT_NV3 ---
commit 98082153874cf6a7ea1e64f1536725fa89404dc8
Author: Marc Zyngier <maz@kernel.org>

arm64: sysreg: Add HCRX_EL2 bits related to FEAT_NV3
   =20
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
By changing these bits from Res0 to Field, they are silently removed from t=
he
auto-generated HCRX_EL2_RES0 mask. Does this cause KVM's boot-time validati=
on
loop to fail?

In arch/arm64/kvm/config.c, check_feat_map() asserts that all non-RES0 bits
are accounted for. Since hcrx_feat_map is not updated with NEEDS_FEAT()
mappings for these new fields, it seems this will unconditionally trigger an
error on boot:

arch/arm64/kvm/config.c:check_feat_map() {
    ...
    if (mask !=3D ~resx)
        kvm_err("Undefined %s behaviour, bits %016llx\n",
                str, mask ^ ~resx);
    ...
}

Furthermore, without these bits being tracked in KVM's feature map, can a
nested guest set them in its virtual HCRX_EL2 register?

If the guest writes these bits, it appears they could bypass filtering duri=
ng
guest entry and be written directly into the physical CPU register:

arch/arm64/kvm/hyp/include/hyp/switch.h:__activate_traps_common() {
    ...
    hcrx |=3D (val & ~NV_HCRX_GUEST_EXCLUDE);
    hcrx &=3D ~(~val & ~NV_HCRX_GUEST_EXCLUDE);
    ...
}

Could this allow an untrusted guest to misconfigure unvirtualized hardware
state?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260730071022.2968=
11-1-maz@kernel.org?part=3D14
