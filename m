Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F9CF441627;
	Tue, 14 Jul 2026 09:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784022341; cv=none; b=XmwjAX0c8uCaQhPzORENpXNK5Xn23yrLKtbJLhF0RgYDEJ3MiirKWcJVhEusisA/MVpSsCkiIpKiDRHO5rCfZQsAqLV/0lgzdiCDhQzN9m3KzWJsFBgh1pW3BF2nY8gy3UcO0wZHhMmUcp1YJDiKAcbZh4omvUVfgFWLfbj3/M4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784022341; c=relaxed/simple;
	bh=XB8FvJrj7GjhiRFoAVhkI2fSXHjlJGTUb9qPADYMbRQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ZxWBUCWRPz3SS/Rvav8j5JQ2x09nBlFo5Z00htEEtXAgNo+4zBXLHOJ/qIBJW8MReEMBol0hRwcma8N56NW2d7EF+JgskNISb5RTzaUv/zIlNjyeLtGI5bJPwvxtkho9rC5RYgRSHON0j4Itm26o3Wb/D34HA5YQVrRTDfB2M6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gAsm2Nga; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gAsm2Nga"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B7131F00A3A;
	Tue, 14 Jul 2026 09:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784022337;
	bh=CHTD/kyX08yqDtXu9cIcHqnYlH+tMOWAUnSCbdjIUPk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gAsm2NgaBxdN7XdMmQ0ae78lg5dEbd3hkFMWiLPaCLItK5N24nOMEMdXnUVbsWVJk
	 zW7Bpvd3VH6V065BoSwaScHg/ywVNJhwD7hnYeM80mLAqQLF6B8Vav20bR2mPpnSrU
	 Qevi7DPohwZDQG9Wnak//rGwC/PuH8cAfaHZveV+0h8WyCjLZAE5XUZwjJjEmxBEnM
	 XQhS/FGCYl1dUB2nXVy7rFc21q1uhByQbS+Rs+xvbH6g4qXfJ4TyEZ2R0grsXwrfng
	 jIWTjtVyxX6g9Nfnxv+PJBXn7nQw6liS+iPsc4tcWYskRjJ74hWlL1oKMVTVNyNQd+
	 u0muAYZXkMH+w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 14/28] arm64: sysreg: Add HCRX_EL2 bits related to
 FEAT_NV3
Reply-To: sashiko-reviews@lists.linux.dev
To: "Marc Zyngier" <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>, kvm@vger.kernel.org
In-Reply-To: <20260714091641.1970822-15-maz@kernel.org>
References: <20260714091641.1970822-1-maz@kernel.org>
 <20260714091641.1970822-15-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 14 Jul 2026 09:45:36 +0000
Message-Id: <20260714094537.5B7131F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Adding FEAT_NV3 fields to HCRX_EL2 in the sysreg file silently alt=
ers the auto-generated HCRX_EL2_RES0 mask. Because KVM's manually maintaine=
d feature maps were not updated to account for this change, it triggers a b=
oot-time verification failure and allows guests to unconditionally set thes=
e unsupported bits, breaching hypervisor isolation.
--

--- Patch [14]: [PATCH v2 14/28] arm64: sysreg: Add HCRX_EL2 bits related t=
o FEAT_NV3 ---
commit c8a8a5e81c8baa4b59a436c9bd034245cdeb5fa4
Author: Marc Zyngier <maz@kernel.org>

arm64: sysreg: Add HCRX_EL2 bits related to FEAT_NV3

This patch introduces 4 new HCRX_EL2 control bits related to FEAT_NV3 and
describes them in the sysreg file.

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
Does this change require a corresponding update to KVM's feature map?

By defining these new fields here, the auto-generated HCRX_EL2_RES0 mask is
shrunk. Because KVM's manually maintained feature map consumes this mask
without adding NEEDS_FEAT rules for the new bits:

arch/arm64/kvm/config.c:hcrx_feat_map[] =3D {
        ...
        FORCE_RES0(HCRX_EL2_RES0),
        FORCE_RES1(HCRX_EL2_RES1),
};

Will this trigger a deterministic verification failure during host boot?=20
When check_feat_map() validates the map coverage, it checks the mask:

arch/arm64/kvm/config.c:check_feat_map() {
        ...
        if (mask !=3D ~resx)
                kvm_err("Undefined %s behaviour, bits %016llx\n",
                        str, mask ^ ~resx);
        ...
}

Furthermore, without these bits being tracked, could a nested guest be
permitted to unconditionally modify these FEAT_NV3 configuration bits via=20
MSR HCRX_EL2, escaping the hypervisor's RES0 masking protections?

>  Field	26	SRMASKEn
>  Res0	25
>  Field	24	PACMEn

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260714091641.1970=
822-1-maz@kernel.org?part=3D14
