Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75AB63515C9
	for <kvmarm@lists.linux.dev>; Mon,  3 Aug 2026 23:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785798722; cv=none; b=GTNvUWHLJ5RKzckMgECa6LiMWM5g15c8WH71UFdcoESgFHoHPdOK3/S8pnxbKHXLV3gP5NHjuXuqd7KYNuA+uSEaHQLAG8xhQcz6jYrGSKoLo8yO3zQSAGTtbLHwVtfCPgKMTo7UWw+VXGCfz5hRJL808DzAb1c9/1f9iKEq3AQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785798722; c=relaxed/simple;
	bh=s1r2kglOzKKSZBCx1tfCl+lv+N4ue/umL0vvMq4tDeI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=PMrllKj9UFgGnut+vSS9iahSEb5z0Or8h4MIMNsXuM6/fXUIdnuQPfsTKN1INQLEQoXRoq05WYzrdgIoutzaT7Iyo8okofAlupbiivaq7wIiTtRUmQkulL5qgCc/Ocf9kGLdXuIn4orjWhlnsnXBlVpcahQ5qRuIMIkrQ5aQF9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cyqAr1Ap; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cyqAr1Ap"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D62F81F000E9;
	Mon,  3 Aug 2026 23:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785798721;
	bh=kVTdIQCsNL0wBLIv8vv5YIy/wL5yhOhP/ywZCaqHABM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cyqAr1ApiWNMh4AvzkUVTw+97l0XjMXy11cVOSMdoleaBY3BcH9BxQfQT1+swH8Zk
	 /xlPIZc3m6QqwUUiPT1z3N0xkn0m4Wn8sLvf11XFTuIjfuFN0z5hd3TjdB5/iqrSwH
	 qZhyKcRnj6xzgrwF1Waw3Pi9RcCYrZ/ApGIzxAkAl6niKVLbSnqLN/nvhlqqut0qqQ
	 TcFwj/8YDHn44xrzdXxB9BMcrFvsV93395npQHSu8DLvjJUajakBD61MiB8ADbZnVq
	 4Cc7Kf584GKn7FVK/yzd5mctofiWO4TUEaCw18eARq0gADiBRstGqdPqj8e91A7rWF
	 g4wPd8VIeETUw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/2] KVM: arm64: Finalize guest-wide sysregs prior to
 per-vCPU sysregs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mark Brown" <broonie@kernel.org>
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260803-kvm-arm64-idreg-final-v2-1-d7d7e4efc640@kernel.org>
References: <20260803-kvm-arm64-idreg-final-v2-0-d7d7e4efc640@kernel.org>
 <20260803-kvm-arm64-idreg-final-v2-1-d7d7e4efc640@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 03 Aug 2026 23:12:00 +0000
Message-Id: <20260803231200.D62F81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Numeric range comparison over sparse `enum vcpu_sysreg` covers uni=
ntended registers.
--

--- Patch [1]: [PATCH v2 1/2] KVM: arm64: Finalize guest-wide sysregs prior=
 to per-vCPU sysregs ---
commit d51df44c26211dddcc71c5fe7798bb6cbbc7e67e
Author: Mark Brown <broonie@kernel.org>

KVM: arm64: Finalize guest-wide sysregs prior to per-vCPU sysregs

This commit splits the sysreg initialization into a per-VM and a per-vCPU
function to ensure that guest-wide settings are finalized before per-vCPU
NV initialization runs.

> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 5d5c579d45790..958d7ef78785f 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
[ ... ]
> @@ -5825,6 +5814,29 @@ int kvm_finalize_sys_regs(struct kvm_vcpu *vcpu)
[ ... ]
> +int kvm_vcpu_finalize_sys_regs(struct kvm_vcpu *vcpu)
> +{
[ ... ]
> +	if (vcpu_has_nv(vcpu)) {
> +		ret =3D kvm_init_nv_sysregs(vcpu);

[Severity: High]
This isn't a bug introduced by this patch, but does the initialization in
kvm_init_nv_sysregs() touch unintended registers by iterating over the
sparse vcpu_sysreg enumeration?

Looking at the loop at the end of kvm_init_nv_sysregs() in
arch/arm64/kvm/nested.c:

    for (enum vcpu_sysreg sr =3D __SANITISED_REG_START__; sr < NR_SYS_REGS;=
 sr++)
        __vcpu_rmw_sys_reg(vcpu, sr, |=3D, 0);

Because VNCR-mapped entries are numbered by their VNCR-page byte offset
rather than declaration order, iterating using a numeric range comparison
over the enum covers unassigned gaps and other registers that happen to fall
in that byte span.

Could this loop inadvertently corrupt or desync guest state by treating
offsets as sequential enum entries?

> +		if (ret)
> +			return ret;
> +	}
> +
> +	return 0;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260803-kvm-arm64-=
idreg-final-v2-0-d7d7e4efc640@kernel.org?part=3D1
