Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D112343713E;
	Thu,  3 Sep 2026 16:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788453171; cv=none; b=EfOVxwkoDBALeptJC0Cz5I6fhP0MjYmcknJeT2OrmSlnNl2qjIWm9IOAmOAhXDHDNazxlXZa+UnT15r+V5dCg11+sW22JmlFet4bjbDjKJo1nJh8CG9fVi6OQfF02IddVUzR+vtf8NwJGlO4h+F7fsanp2Wqdu2XAm9Vs+TfvrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788453171; c=relaxed/simple;
	bh=zglb0k8xuJtFF2qkmR/Xj7vUhHak4L9ylMhtThSmW3I=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Z8/j4vNxG11V+OQt1YcQXeLs8o5lG0zylVG0P2upvS5KgqBE2wcYopuaXecCFr/xroGfUNL/7WUxKijovTaktZtFk16RyAjKX3k3wvGkcH0q6+UEbLA2HdqhyMgjPvqf1Zle/VoQCZz80PLGDPPJO/INxAAOPNmp+sLS7nFeqIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l4NKBTaz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l4NKBTaz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F3531F00A3D;
	Thu,  3 Sep 2026 16:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788453170;
	bh=tgIgqbvvVh6+/RpEDrcOzUZkvt0vNLDWdbH3WFNlMfk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=l4NKBTaz4EmtIKlwcYmxFsvrGWo2XxNtEBiFRZ52QmNlQMmJGNbIyL8EhS+j/mspL
	 qsiXmJ2zGlxpw28oHQGlhTVyOe0Hj7XO9s6CTLWOrvLKWKi6G3GLFAV+X58VzFpWN4
	 1+DsDaWuDRmvv9dOHMHkoMSvk5xkO10/TlZIQ/f9//gy5r/LspeEq6wsLnIg/1xaL6
	 1JBhgPQGPf+Ld6sChJUZLcuYLuiUg9+Gf3QBKpCNcnT7qkJJda2qrkaSJzztzc9gNE
	 2LoG/sSPVvISSBI26nLtq6yUJWHTxxbK9bL3ui/uBIiXcxRFmXGV4G8xH3k7qXnQ66
	 T+1v8GIysBA7A==
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v7 16/28] KVM: arm64: Add SPE system registers to
 VCPU context
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexandru Elisei" <alexandru.elisei@arm.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, linux-perf-users@vger.kernel.org
In-Reply-To: <20260903160623.315525-17-alexandru.elisei@arm.com>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-17-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 16:32:49 +0000
Message-Id: <20260903163250.3F3531F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] WARN_ON_ONCE is incorrectly called with a string literal instead of=
 a boolean condition.
--

commit aa1092f112d707ae630c6edfaa06e1cf58da7524
Author: Alexandru Elisei <alexandru.elisei@arm.com>

KVM: arm64: Add SPE system registers to VCPU context

This commit adds SPE registers to the VCPU context. It only traps the buffer
registers, allowing KVM to track the buffer enabled state for dirty page
logging and to sanitise writes to PMBLIMITR_EL1 based on exposed VM feature=
s.

[ ... ]

> diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
> index 4426d614a9e0b..6a00a44c73edf 100644
> --- a/arch/arm64/kvm/spe.c
> +++ b/arch/arm64/kvm/spe.c

[ ... ]

> @@ -82,6 +83,34 @@ void kvm_spe_destroy_vm(struct kvm *kvm)
>  	module_put(spe_pmu->pmu.module);
>  }
> =20
> +bool kvm_spe_write_sysreg(struct kvm_vcpu *vcpu, int reg, u64 val)
> +{
> +	switch (reg) {
> +	case PMBLIMITR_EL1:
> +	case PMBSR_EL1:
> +	case PMBPTR_EL1:
> +		__vcpu_assign_sys_reg(vcpu, reg, val);
> +		break;
> +	default:
> +		WARN_ON_ONCE("unexpected trap");

[Severity: Low]
Does this macro call miss a boolean condition? The WARN_ON_ONCE macro
expects a boolean expression, but it is being passed a string literal here.
While this functionally evaluates to true because the string decays into a
non-null pointer, could this be considered an API misuse? Perhaps this
should use WARN_ONCE(1, "unexpected trap") or WARN_ON_ONCE(1) instead when
an unexpected trapped SPE register access falls through to the default case
in kvm_spe_write_sysreg().

> +	}
> +
> +	return true;
> +}
> +
> +u64 kvm_spe_read_sysreg(struct kvm_vcpu *vcpu, int reg)
> +{
> +	switch (reg) {
> +	case PMBLIMITR_EL1:
> +	case PMBSR_EL1:
> +	case PMBPTR_EL1:
> +		return __vcpu_sys_reg(vcpu, reg);
> +	default:
> +		WARN_ON_ONCE("unexpected trap");

[Severity: Low]
Similarly, should this use WARN_ONCE(1, "unexpected trap") instead of
passing a string literal directly into WARN_ON_ONCE when an unexpected
trapped read falls through to the default case in kvm_spe_read_sysreg()?

> +		return 0;
> +	}
> +}

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903160623.3155=
25-1-alexandru.elisei@arm.com?part=3D16
