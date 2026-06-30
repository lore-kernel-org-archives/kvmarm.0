Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7397D3ED134
	for <kvmarm@lists.linux.dev>; Tue, 30 Jun 2026 11:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782818360; cv=none; b=qNsjFXL2SYGov99FwQA3t1VIzpu1/up9xDYHQzzevAb06KXe/rMQtf2pVzF6zSqTFfXpTMKWsofM/JR2WwzK/SHvZFEP1BvD/boTKcSJStF8KokHr4Aqob8g65iYGPlOqhKmGP/K5AdcQ6euVOQ/ZOL71Sc4SqSrkTDO3LjXTdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782818360; c=relaxed/simple;
	bh=YS31gDUf3HUt/ASvyg4yNlz1M1r31UJAJoHXui6Fk3c=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=azD6aeqYwI1vrOyPxdtZnHhBpyZKBGvxwQ9vF3uhqR5+zeV7CmW0Sx3Ozu+D52V/2P8GzEVoFL2vBHMfcSSocA4rDIdUJQedjPWXMpN/7RtA32TJaDwp+0sX5+Vzy9d+5+O+mlm1C9yWrmozWiJlSvtaf8zOn0Qn5vQjMp76xjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bbZGSVw/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bbZGSVw/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1701F1F000E9;
	Tue, 30 Jun 2026 11:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782818359;
	bh=VHIxdGBkHXe0YmpgBcl2rOY+NOrZaFoP4iRrlegEvCc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bbZGSVw/CKCSar1LtDHDx+XIjXHgTvXeB5uOUhufZQuCzIKBk/22Xdv1uK9XVa/kv
	 hBSoG5yfUWvUZAWk9DWU716Sy3Z7ZAt3cCUlHujvKsCtyJi67HBSEpJ+H3lLAJ1hHj
	 +VBIvNytePIWoTmsCpE9LBhTr5BksMSIDn+DYYaemGw+xoyy8PsL6Mp01qjvy2F79I
	 ZhEkZOJxwg875veR5s7XU6ZY7htdJ1co2YUhm8YtK5RDmP36dhqB0KP5r4A0MqEUgz
	 vImIaDPkqFHsXnH9dod5uZoeoPZVYUMzqoTcyj1ik8deyiTqLWrya+LFsrM+wlS+5H
	 xhoFLfk6K39Sg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 6/6] KVM: arm64: Zero out the stack initialized data
 in the FFA handler
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sebastian Ene" <sebastianene@google.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260630102058.3219867-8-sebastianene@google.com>
References: <20260630102058.3219867-2-sebastianene@google.com>
 <20260630102058.3219867-8-sebastianene@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 30 Jun 2026 11:19:18 +0000
Message-Id: <20260630111919.1701F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Downgrade responses from EL3 during FF-A version negotiation are s=
ilently used as a higher version, leading to version desynchronization.
--

commit 301ff1e27b3be974b47bb143428c88b8db810a28
Author: Sebastian Ene <sebastianene@google.com>

KVM: arm64: Zero out the stack initialized data in the FFA handler

Don't leak hypervisor stack data when using the FFA_VERSION call.
When the compiler doesn't support -ftrivial-auto-var-init=3Dzero option
we need to zero out the stack initialized variable before returning data
to the host caller.

Link: https://lore.kernel.org/all/20260616160016.C62C81F000E9@smtp.kernel.o=
rg/

> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index bb01d8f830561..7407bc4b547af 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> @@ -881,7 +881,7 @@ static void do_ffa_part_get(struct arm_smccc_1_2_regs=
 *res,
> =20
>  bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
>  {
> -	struct arm_smccc_1_2_regs res;
> +	struct arm_smccc_1_2_regs res =3D {0};

[Severity: High]
This is a pre-existing issue, but while looking at how res is handled
during FF-A version negotiation, is it possible for EL2 to silently use
a downgrade response from EL3 as a higher version?

Looking at do_ffa_version() in arch/arm64/kvm/hyp/nvhe/ffa.c:

	hyp_smccc_1_2_smc(&(struct arm_smccc_1_2_regs) {
		.a0 =3D FFA_VERSION,
		.a1 =3D ffa_req_version,
	}, res);
	if ((s32)res->a0 =3D=3D FFA_RET_NOT_SUPPORTED)
		goto unlock;

	hyp_ffa_version =3D ffa_req_version;

If the host requests a minor version lower than the current hyp_ffa_version,
and EL3 returns a version lower than requested (and not FFA_RET_NOT_SUPPORT=
ED),
EL2 appears to blindly set hyp_ffa_version =3D ffa_req_version. It ignores =
the
lower version returned by EL3 in res->a0.

Can this version desynchronization lead to ABI mismatches across the EL2/EL3
security boundary, such as mismatched structure sizes or missing fields?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260630102058.3219=
867-2-sebastianene@google.com?part=3D6
