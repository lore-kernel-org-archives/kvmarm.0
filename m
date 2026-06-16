Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B042244D6B2
	for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 15:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625287; cv=none; b=XTSmX/Yt+GeeJmR0xzDHlSfnpyFp7ConfVr7GF3wu9kvEeGCZnTTWizf3cb7QgTHZb9v+ISHbn+LUFRku7TIEhmyUW0BGdTpD7uTPf8Vhbg+mPAhAF3x3rycIVj/hjE0rFydX60Mm8ZaX4gU3RGmI2fcQ6sTkJsl2Gob5e1L4CE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625287; c=relaxed/simple;
	bh=ihUY5R0fnsUjNMk6M6xMCX2+IXqtAa3qEDye31Zq7/E=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=StuRW6abgkDI7VZE4lml81McMC7Ob+2uzZQC04lS5R8Hmlks9H8wWUJut6Vm9StZi55pX45nHIHtLM68tSLVnLnLM0ORDKpXvXgnabI1M1670tVYO5zrdc1PRDtBH0twacQUrizXLf5nbLAMT6ZUwecMLyJamsboGtXrQOhERvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ceCjvn6A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ceCjvn6A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F34C51F000E9;
	Tue, 16 Jun 2026 15:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781625286;
	bh=A+sJB8wkHYDgGFkQckr8UvaY/OzcBGl5Ff+5SGijcws=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ceCjvn6ARHB19wlHkGh2afkK5MkDOa0IUm+x9qR+u4oRYDsCDx4HJAIJ7EdFHGOWc
	 PopFogLGdZlGBqWNiIY/7xGE1Rgl8idUB2+hCd7uz2jCpV/3eMRJC0fgDWj4xePO2N
	 OKEBRaMG66vxlh0rbaW17SvzKttgkbyxQUA4/sjQtj8wjHB/nmAoEJ3eYMubyqZoja
	 ParVIJ0Tchr/xLni24njWAs9Wu9pdnFQBKqE4CIUA1UVqKJQyNgohCvzWsbnGi4mYz
	 j1xLGDccRoiYnOKym2mIjTnrZMX9jT7aqqtBd1eT2N6SJbvIE6Ld6oOX0vwzILPII+
	 NDiu4rtJXroHQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 5/7] KVM: arm64: Support FFA_NOTIFICATION_SET in host
 handler
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sebastian Ene" <sebastianene@google.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260616154149.2763214-6-sebastianene@google.com>
References: <20260616154149.2763214-6-sebastianene@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 16 Jun 2026 15:54:45 +0000
Message-Id: <20260616155445.F34C51F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The MBZ (Must Be Zero) check for the `flags` parameter (W2) in `=
do_ffa_notif_set` uses an incorrect mask, leaving bits [31:16] completely u=
nvalidated.
--

commit 18c05e4ad6759f3bb72be1916c4e1abac54bcb30
Author: Sebastian Ene <sebastianene@google.com>

KVM: arm64: Support FFA_NOTIFICATION_SET in host handler

This commit adds support for proxying FF-A notification SET messages from t=
he
pKVM hypervisor to TrustZone. It introduces validation to enforce MBZ and S=
BZ
fields before forwarding the call.

> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index adf8680f32663..fdf1e5fb67267 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c

[ ... ]

> @@ -975,6 +975,32 @@ static void do_ffa_notif_unbind(struct arm_smccc_1_2=
_regs *res,
>  	hyp_smccc_1_2_smc(args, res);
>  }
> =20
> +static void do_ffa_notif_set(struct arm_smccc_1_2_regs *res,
> +			     struct kvm_cpu_context *ctxt)
> +{
> +	DECLARE_REG(u32, endp_id, ctxt, 1);
> +	DECLARE_REG(u32, flags, ctxt, 2);
> +	struct arm_smccc_1_2_regs *args;
> +
> +	if (FIELD_GET(FFA_NOTIF_SENDER_ENDP_MASK, endp_id) !=3D HOST_FFA_ID) {
> +		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> +		return;
> +	}
> +
> +	if (ffa_check_unused_args_sbz(ctxt, 5)) {
> +		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> +		return;
> +	}
> +
> +	if (flags & GENMASK(15, 2)) {
[Severity: Medium]
Does this mask properly validate all reserved bits?

The FF-A specification dictates that for the FFA_NOTIFICATION_SET interface,
bits 31 through 2 of the flags parameter passed in W2 are reserved and must
be zero. By using GENMASK(15, 2), the upper 16 bits of the 32-bit flags
variable are completely ignored.

Can this allow a malicious or buggy host to pass non-zero upper bits that
silently bypass validation and get proxied to EL3?

> +		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> +		return;
> +	}
> +
> +	args =3D (void *)&ctxt->regs.regs[0];
> +	hyp_smccc_1_2_smc(args, res);
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260616154149.2763=
214-1-sebastianene@google.com?part=3D5
