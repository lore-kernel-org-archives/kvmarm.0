Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA6DF4963D8
	for <kvmarm@lists.linux.dev>; Wed, 17 Jun 2026 15:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781708680; cv=none; b=mE3XIFFHuj97Sfr92JHZ9ZWR9jzFQ2C1lmSB50QX4+CQQGc9dbbstnq3rs3Bl2mLGxIj7wq+coBUDehdYpk/OpgIqs0Y5BuYHv/iXA1ad/XIsRMSMZcKakQj5m1hHk1V2mHpAieCb5XOnrF0g24Yk4bFoaBpzjeoK6+c/huKbg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781708680; c=relaxed/simple;
	bh=Aiba23iLMXKL7jqRcmVbXGHBqJSHLXHGI+0nKIWhNEE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=jGHjn+47mP2MsbFB+6o3E8fd6CpLt6Fy1aaz+WJ9FcxyKllGPNm5leOrrUGtn53PkyrtAfLZdVxqPpTggI9nxUtmWgmnu8qlwz8UXga7CoXNqCm8YopZTQnAkA8DESQ+OMh8bWihBvziFyYvP7BwOgZbwzFBkoJEis/vglT7Enc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B8HSmUft; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B8HSmUft"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66E3A1F000E9;
	Wed, 17 Jun 2026 15:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781708678;
	bh=TxQXL0aQ7gL6Bifk0cI8v90rNHW6U2kupUKrpSsniE8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=B8HSmUft+fzO/oZHqmWvsFz3vhDiYpqv3qi/PVHxChid5MNgrceFRKP3vfLAi0aDv
	 qRBAXNAgNz0V8drU0dPNU1cXTmFpXjQnTKEUMdVp1+uk1T4oiH2drNQZakOMW5x+b5
	 mTZqDcELOAI3rLxdN7RqOx4UOvPDIGSgMSoaJhdjNEac3teC1gtvz4CdByPvpd7k7Q
	 pgWnBAVmx4Splx43kChrTh8yRUXSrrm08XD/0nBnQtWk5SYeIBZeRfM3ngInwD+kzd
	 JsMLrfklyE4uC/EanqCY+wLpU/RpCE4C8PCCsIfMYYy4lkYu1ROTL6w1HMcRqAaShz
	 IYSa4063IB2QQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] KVM: arm64: nv: Fix PSTATE construction on illegal
 exception return
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <tabba@google.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260617144907.2972095-1-tabba@google.com>
References: <20260617144907.2972095-1-tabba@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 17 Jun 2026 15:04:38 +0000
Message-Id: <20260617150438.66E3A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Incomplete PSTATE allowlist on illegal exception return causes gue=
st state corruption
--

commit 93d5c5c2769fe9f58076ca66eb01cbe04fd87921
Author: Fuad Tabba <tabba@google.com>

KVM: arm64: nv: Fix PSTATE construction on illegal exception return

This commit updates PSTATE construction during an illegal exception return
to correctly source flags and masks from the SPSR being returned to, as
per ARM rule R_VWJHB. It constructs the PSTATE by taking these fields from
the SPSR while preserving EL, SP, nRW, and EXLOCK from the current PSTATE.

Link: https://lore.kernel.org/all/86wlvxs5r0.wl-maz@kernel.org/

> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nes=
ted.c
> index dba7ced74ca5e..ace2b40cf8756 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -2738,17 +2738,30 @@ static u64 kvm_check_illegal_exception_return(str=
uct kvm_vcpu *vcpu, u64 spsr)

[ ... ]

> +		mask =3D PSR_D_BIT | PSR_A_BIT | PSR_I_BIT | PSR_F_BIT |
> +		       PSR_N_BIT | PSR_Z_BIT | PSR_C_BIT | PSR_V_BIT;
> +
> +		if (kvm_has_feat(vcpu->kvm, ID_AA64MMFR1_EL1, PAN, IMP))
> +			mask |=3D PSR_PAN_BIT;
> +		if (kvm_has_feat(vcpu->kvm, ID_AA64PFR1_EL1, NMI, IMP))
> +			mask |=3D ALLINT_ALLINT;
> +		/* FEAT_SPE_EXC and FEAT_TRBE_EXC also gate PSTATE.PM one day... */
> +		if (kvm_has_feat(vcpu->kvm, ID_AA64DFR1_EL1, EBEP, IMP))
> +			mask |=3D BIT_ULL(32);	/* PSTATE.PM */
> +
> +		spsr &=3D mask;

[Severity: High]
This is a pre-existing issue, but this explicit allowlist approach seems to
omit several architecturally defined and KVM-supported PSTATE fields.

For example, PSR_SSBS_BIT, PSR_DIT_BIT, PSR_UAO_BIT, PSR_TCO_BIT, and
PSR_BTYPE_MASK are not included in the mask. Because spsr is masked with
this incomplete allowlist, won't these valid bits be silently zeroed out
instead of being preserved?

When the guest takes the resulting Illegal State Exception, its SPSR_ELx
will have lost these bits, which could corrupt the guest's architectural
state and break guest exception handlers that rely on them.

Would a denylist approach (masking out only the mode bits and EXLOCK from
SPSR and taking them from CPSR) be safer to ensure all relevant bits are
retained?

> +		spsr |=3D cpsr & (PSR_MODE_MASK | PSR_MODE32_BIT);
> +		if (kvm_has_feat(vcpu->kvm, ID_AA64PFR1_EL1, GCS, IMP))
> +			spsr |=3D cpsr & BIT_ULL(34);	/* PSTATE.EXLOCK */
>  		spsr |=3D PSR_IL_BIT;
>  	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260617144907.2972=
095-1-tabba@google.com?part=3D1
