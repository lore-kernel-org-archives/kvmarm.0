Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B735C48A2A6
	for <kvmarm@lists.linux.dev>; Wed, 17 Jun 2026 15:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781710148; cv=none; b=OiBYnbyacJDWoRPGqc0FB5Cfak3XqnzV3bKmb18vI1y6lCmK0V+DJAErYCmeyBq6WsrMP0WjyIvrNNNj6Qd7syrqwfVtGdzLbDHDa8EcWFMxtWa5bfPXFdgUuFkyhBS1TEhJy1e4LutVfqrLiMM+MGNsXJ8fxr+UjvbvBTiK7dE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781710148; c=relaxed/simple;
	bh=/p4z2NrKu9DWhHBfH9F0/u0vnX1wc2HRmAJ8QkrKxGY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=LR5T+9v4jceNW0mnehe+PvGQspIi0BtnFX55fJ7rcwWJJEjYemvpIjJTJAoq/+f85MtIkb9JZyG43urpuXzFDjXrTe5ZEklU7G3mo6z0LupLCog7V+s4HlYdBMhD8y3RMCRge/ncsxeHotHcOaRt2XwWOH7F5gZYTKBPOd9wsIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vn53rc3I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vn53rc3I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C7731F000E9;
	Wed, 17 Jun 2026 15:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781710142;
	bh=sMOY5c/o74c90JjI2I57HePjllCn3Bk7lCty83KOLDM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Vn53rc3IheuZQizpfb+Vzvrhs2zV5MT0kZk7Z6/YEb5VYOnaXFl9vrhqbktF8W8gk
	 CKwRSVmQNe6UbonspB6EMFF1RB2qVCF6MQE78lDwI/jIkIGcNi59553Ux/0lHQrziE
	 ruh4iNkA+3MTfiN/o0B1tW+qPsD1ZIVdUlEOCnhifQjASyKHmu/9Ovqv/7DW9EbsNC
	 IiK5XiJYIxpX3clgyhy+kmpjThub003ZWf3kQbl6yayOM0BU68EUvf0OItNJI27HAi
	 pS8I8HbyalH8COxaIzQFHZgJYF8G21kE9Liy1LKlsL3NAI+bJDNtPexbouIIQQ8kme
	 YPdejVbIDXnDA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 7/7] KVM: arm64: Zero out the stack initialized data
 in the FFA handler
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sebastian Ene" <sebastianene@google.com>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260617145130.3729015-8-sebastianene@google.com>
References: <20260617145130.3729015-1-sebastianene@google.com>
 <20260617145130.3729015-8-sebastianene@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 17 Jun 2026 15:29:01 +0000
Message-Id: <20260617152902.0C7731F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Downgrade responses from EL3 during FF-A version negotiation are s=
ilently ignored and used as a higher version.
--

commit 0d02d44ef9bc090a9ae03e08d6cec358827371ce
Author: Sebastian Ene <sebastianene@google.com>

KVM: arm64: Zero out the stack initialized data in the FFA handler

This commit prevents leaking hypervisor stack data to the host when using
the FFA_VERSION call by explicitly zeroing the stack-allocated variable
before returning data.

Link: https://lore.kernel.org/all/20260616160016.C62C81F000E9@smtp.kernel.o=
rg/

> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> @@ -883,7 +883,7 @@ static void do_ffa_part_get(struct arm_smccc_1_2_regs=
 *res,
> =20
>  bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
>  {
> -	struct arm_smccc_1_2_regs res;
> +	struct arm_smccc_1_2_regs res =3D {0};

[Severity: High]
This isn't a bug introduced by this patch, but while looking at the FF-A
version handling, I noticed an issue with version negotiation in
do_ffa_version().

When EL2 queries EL3 during version negotiation, does the code correctly
handle downgrade responses?

It appears EL2 only checks if the response is FFA_RET_NOT_SUPPORTED:

arch/arm64/kvm/hyp/nvhe/ffa.c:do_ffa_version() {
        hyp_smccc_1_2_smc(&(struct arm_smccc_1_2_regs) {
                .a0 =3D FFA_VERSION,
                .a1 =3D ffa_req_version,
        }, res);
        if ((s32)res->a0 =3D=3D FFA_RET_NOT_SUPPORTED)
                goto unlock;

        hyp_ffa_version =3D ffa_req_version;
}

If EL3 returns a version smaller than the requested ffa_req_version
(a downgrade response), should res->a0 be validated against ffa_req_version
before unconditionally setting hyp_ffa_version =3D ffa_req_version?

Silently using a higher version than EL3 actually supports might cause
struct layout misinterpretations (like mismatched offsets) leading to
memory corruption or out-of-bounds reads during subsequent memory sharing
calls.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260617145130.3729=
015-1-sebastianene@google.com?part=3D7
