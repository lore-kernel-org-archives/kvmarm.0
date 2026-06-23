Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90F823D525F
	for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 12:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782216457; cv=none; b=HOOqMOywxtmmmqRPwub3P3p7K2d6P+cfvEJcXe3b7/BD0uD7d4Bk9mDAery+UILEJa7olEMqwto7YvDJHTMRv2S6qlNENVzB7mofjSkQIPiaDBPoiiEHOm42DTlAo1QH2yi2AfAbbCcdePz9GcTzVPO/rxxVe64z/JsesUugc8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782216457; c=relaxed/simple;
	bh=vFFsU9KIxRv3Pjnj/dAorDwLjyoai3eK8g7PEBgwVQ8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=pi0Bydc/osLFe65+oopA7NlhINXK8Eiv8n+vtopJfY4FZuQSXCFqZrgtc2NX9nW9cwmYoKbGSz3Q8SzwgEm5Sy+oMFc93YxV/jqsWRt0D9XC96f7nTy+fYBAqnm3rwWlM/p9ulwke8QiH3NWZ4u03W8iZ0VQRVY9yftaVSrUmwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NyHYfYpG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NyHYfYpG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 254511F000E9;
	Tue, 23 Jun 2026 12:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782216456;
	bh=NqAD/FL5tsc2i3Zir1+aYnJ9TvyqI2CnJTIOoBaCeBg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NyHYfYpG5O1Ff9y8lUTZ52reYeF9W6JjVEJAnqSeyey5iWOyYtquWpD4xXAQaBrWS
	 k4qVfRxvlo0WcFrhHWNI/Ki93vBx9VIOrmRlISG4X65AzMTVzAU+0J+wIEmtPRAbav
	 EORpuahxEO/gXP9FxvPMvkoMRkuu9+yP2E/KdEbsfPgsk/E1Skk8XXdukbz5s9At1K
	 MPiD5eW0PpjqOf7gveCAK82rsbcAcjbk2bx0s5y8KHXPX4bVa8pLh2EzgVnCvxJL4U
	 i2AQpNKgVsebS8b0fjOmME5WqE6ppJr6RMbOZO2NbL45IJmqJupq5C4OJX9gHKmKqP
	 rR4M8EI7/WarQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 3/7] KVM: arm64: Support FFA_NOTIFICATION_BIND in
 host handler
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sebastian Ene" <sebastianene@google.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260623115354.632361-4-sebastianene@google.com>
References: <20260623115354.632361-1-sebastianene@google.com>
 <20260623115354.632361-4-sebastianene@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 23 Jun 2026 12:07:35 +0000
Message-Id: <20260623120736.254511F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] FFA_NOTIFICATION_BIND rejects per-vCPU bindings for VCPU IDs > 0 d=
ue to unconditional unused argument check on w5.

Pre-existing issues:
- [High] `ffa_check_unused_args_sbz()` validates the full 64-bit register f=
or SMC32 calls, violating the SMCCC specification.
--

commit 0b8b8b81a4ddcd427b7ffa364b793f45c2dd4f37
Author: Sebastian Ene <sebastianene@google.com>

KVM: arm64: Support FFA_NOTIFICATION_BIND in host handler

Verify the arguments of the FF-A notification bind call and forward the
message to Trustzone.

> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c

[ ... ]

> @@ -930,6 +931,32 @@ static void do_ffa_notif_bitmap(struct arm_smccc_1_2=
_regs *res,
>  	hyp_smccc_1_2_smc(args, res);
>  }
> =20
> +static void do_ffa_notif_bind(struct arm_smccc_1_2_regs *res,
> +			      struct kvm_cpu_context *ctxt)
> +{
> +	DECLARE_REG(u32, endp_id, ctxt, 1);
> +	DECLARE_REG(u32, flags, ctxt, 2);
> +	struct arm_smccc_1_2_regs *args;
> +
> +	if (ffa_check_unused_args_sbz(ctxt, 5)) {

[Severity: High]
Does this unconditionally reject per-vCPU bindings for VCPU IDs greater
than 0?

According to the FF-A 1.1 specification, when Flags bit 0 is set to 1,
w5 contains the VCPU ID. This means w5 is not an unused argument when
binding a per-vCPU notification.

Could we skip the sbz check for w5 when the per-vCPU flag is set?

[Severity: High]
This is a pre-existing issue, but I noticed a problem with how
ffa_check_unused_args_sbz() processes SMC32 calls like this one.

When it checks the registers:

static bool ffa_check_unused_args_sbz(struct kvm_cpu_context *ctxt, int fir=
st_reg)
{
        ...
        for (reg =3D first_reg; reg <=3D end_reg; reg++) {
                if (cpu_reg(ctxt, reg))
                        return true;
        }
        ...
}

It reads the full 64-bit register using cpu_reg(). However, the SMCCC 1.2
specification states that the upper 32 bits of W0-W7 are unpredictable for
SMC32 calls.

Will this cause KVM to spuriously reject valid SMC32 FF-A calls if the
host OS leaves non-zero garbage in the upper 32 bits of the unused
registers?

> +		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> +		return;
> +	}
> +
> +	if (FIELD_GET(FFA_NOTIF_RECEIVER_ENDP_MASK, endp_id) !=3D HOST_FFA_ID) {
> +		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> +		return;
> +	}
> +
> +	if (flags > 1) {
> +		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> +		return;
> +	}
> +
> +	args =3D (void *)&ctxt->regs.regs[0];
> +	hyp_smccc_1_2_smc(args, res);
> +}

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260623115354.6323=
61-1-sebastianene@google.com?part=3D3
