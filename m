Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E4A3D45CF
	for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 12:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782216480; cv=none; b=qOKc/gGUsvopjIHSw/P9+cP776a7ujZMChBRtHuLh7cL38X+Ep60k/5PCctWITyro6a8LXouUJbL3XjxbtoYZBo3s9ivWhGAQlclSO6IY2+TYINWEmP8uznHT/kUoPr7YeSx9oGrSJ2xefDZWiwF8V45WJFfJWE4jZsT1HYMJms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782216480; c=relaxed/simple;
	bh=uG29GZI0vrcG5GRipeKGF1BwbjrwuKawomAyVo5/iwc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=M54WQ+RGt0zUPMYA2dASx08Qlc5i5B4pp+1tJ6gWnOmGLjqE6FQ2s8uD1VoTn/hycTjZt9O5hhsnY9W9GM7aLvhigDkOp4ZAC3FAHVgY4O30aBJmuUcnc9XpcAOiR4zElQOCLCZ/BR1F65br39Jqug3AKaPIkxfxTIVSKJeaeI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aDEeKMpI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aDEeKMpI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1A811F000E9;
	Tue, 23 Jun 2026 12:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782216479;
	bh=6LEtw1F2wfEu5UW3gfXV4vCI/YBcZxQgTOmgfV+7uGM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aDEeKMpIQ8A0GfomhEzPAE4XuKC1gLqmxNsS0YH8UF/Y4QJlvaxSBlwxph2wYn/gX
	 Y6PI4oQx1e3qJl3QhIniPTxbr7wBUNJjEUE87t37BSi79fYmj0QQdhJaiZZgCs6KiN
	 9zKflCLyiiygZEKWt2w0aKoJv4TWbRRGS2PDB5UgelId1iQEG8ElcRjbPcbkDaQ6De
	 pTy5XWgwlX4sb5o1JmHwjGG2lbU2PyFuJzmM+/Jh5+7TWYjgG1Jso6Kkedsn4Zp0tV
	 QzF4+VpFbnONObXZJ2bEOcgrUOtT9i10GkCTclvxoMLJuakIj0UxqWtyAXMHZZgtpp
	 KbHHDcPCAnoKw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 7/7] KVM: arm64: Support FFA_NOTIFICATION_INFO_GET in
 host handler
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sebastian Ene" <sebastianene@google.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260623115354.632361-8-sebastianene@google.com>
References: <20260623115354.632361-1-sebastianene@google.com>
 <20260623115354.632361-8-sebastianene@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 23 Jun 2026 12:07:58 +0000
Message-Id: <20260623120758.E1A811F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Overly strict validation of the W1 parameter in `do_ffa_notif_in=
fo_get` incorrectly treats it as a Should-Be-Zero (SBZ) field, rejecting va=
lid `FFA_NOTIFICATION_INFO_GET` requests.
--

commit 8b1c1179ab464455664a3ac244072d9355b5e039
Author: Sebastian Ene <sebastianene@google.com>

KVM: arm64: Support FFA_NOTIFICATION_INFO_GET in host handler

This commit allows the host to query the FF-A notification status by proxyi=
ng
the info get message to Trustzone, whilst ensuring that the SBZ fields are
enforced.

> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index 053efd99bf110..5539fb0d246ee 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
[ ... ]
> @@ -1028,6 +1026,20 @@ static void do_ffa_notif_get(struct arm_smccc_1_2_=
regs *res,
>  	hyp_smccc_1_2_smc(args, res);
>  }
> =20
> +static void do_ffa_notif_info_get(struct arm_smccc_1_2_regs *res,
> +				  struct kvm_cpu_context *ctxt)
> +{
> +	struct arm_smccc_1_2_regs *args;
> +
> +	if (ffa_check_unused_args_sbz(ctxt, 1)) {

[Severity: Medium]
Does this overly strict validation reject valid requests?

For FFA_NOTIFICATION_INFO_GET, W1 is used to specify the ID type (e.g., 1 f=
or
Partition/vCPU IDs). By starting the unused arguments check at index 1, this
incorrectly treats the ID type parameter as a Should-Be-Zero field.

If the host attempts to query notification info for specific partitions or
vCPUs by setting W1 to a non-zero valid ID list type, this will return
FFA_RET_INVALID_PARAMETERS.

Should the SBZ check start from a later index instead?

> +		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> +		return;
> +	}
> +
> +	args =3D (void *)&ctxt->regs.regs[0];
> +	hyp_smccc_1_2_smc(args, res);
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260623115354.6323=
61-1-sebastianene@google.com?part=3D7
