Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9174148D879;
	Thu, 24 Sep 2026 17:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790272229; cv=none; b=A6YFi8pq1raXqxTdg+FNtiSBEgiYKCgRQglAr5o/mqwXb4aOXnwt/wBGTm5T9tG9LaPij+I0cXL897oXKtaDQ/KqaVKxMgUzjkXjMM5MGzD6+mruBD3QvPhkaY6/MZVYcHgdTPqrcKX8a7GPWhC+Qc5u/x475s4VAwU4pSVrncc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790272229; c=relaxed/simple;
	bh=1WetD8ckHl9HqQYytxZYZrLirzwggAh1zd07SHC5w8s=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=DCV2Puj3cuMIyqp0vLdmDFxUv3hjNEkNnj58YPXIHBbFqgUtXv8AcU2jR7uhm7QeWbnJOAwkZWNHKBEY+ttTSSt5i/j52SM7dq4JPH/4kGyERQfdaDO3+RRLMfXdRD+AWSkuDJypBTlyK4gWHNh9hrXRLte25ri/k3Z9r9x2S2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VTC34l5F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VTC34l5F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8FFC1F000FF;
	Thu, 24 Sep 2026 17:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790272228;
	bh=j5FxsE/C23/XEsftmnQSYxqVyCh6eEhXIOQ41WAf7CE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VTC34l5FCigunXBF7cWvTvwtFFap2aA496jHo31R3LkLrlE3TUwVImMHuj0PfuCPH
	 1A3FiQYuDBnYRBuLZpznWXZcE78i6ElDXmSiPqI+s9OIzTOa0440LZfFKkh4HOxVC3
	 EJUX9yNK7/t4wzdib7dQKxMOo+D02Tb4baAz9LOm+wCmvQmW3ICkAah+btV8enQq8G
	 g2vpWmwHjhLbkmFKeimbvvJ/qJewQ+9Z+7shz6ljVg334hmTVxG/SkFiBKocyBkJJO
	 3Zeanp9pVXtPTSep/sIBvM5QBoWlNlbflvvfsY73txsOa4hEfgmb7yLfHduqa+dRsx
	 Q6lqXh2vFJWmg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 10/22] KVM: arm64: Add Partitioned PMU register trap
 handlers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Colton Lewis" <coltonlewis@google.com>
Cc: "Oliver Upton" <oupton@kernel.org>, linux-perf-users@vger.kernel.org, kvm@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260924172928.2110956-11-coltonlewis@google.com>
References: <20260924172928.2110956-1-coltonlewis@google.com>
 <20260924172928.2110956-11-coltonlewis@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 24 Sep 2026 17:50:27 +0000
Message-Id: <20260924175027.E8FFC1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] arm64: range-check over enum vcpu_sysreg
--

commit 35ffc169e71bb4303b4d3e6f955bbc06a22fd20d
Author: Colton Lewis <coltonlewis@google.com>

KVM: arm64: Add Partitioned PMU register trap handlers

This commit adds handling for partitioned PMU register accesses that are=20
trapped when FEAT_FGT is unavailable. It passes through or filters accesses=
=20
to registers like PMCR_EL0, PMEVCNTR, and PMCCFILTR based on the partitioni=
ng=20
configuration.

> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index f7f750b7a91c4..c8210a8b10389 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
[ ... ]
> @@ -1092,9 +1092,204 @@ static u64 reset_pmcr(struct kvm_vcpu *vcpu, cons=
t struct sys_reg_desc *r)
>  	return __vcpu_sys_reg(vcpu, r->reg);
>  }
> =20
> +/**
> + * pmu_reg_write() - Register writes for Partitioned PMU
[ ... ]
> +static void pmu_reg_write(struct kvm_vcpu *vcpu, enum vcpu_sysreg reg, u=
64 val, bool set)
> +{
[ ... ]
> +	switch (reg) {
[ ... ]
> +	case PMEVCNTR0_EL0 ... PMCCNTR_EL0:
> +		idx =3D reg - PMEVCNTR0_EL0;

[Severity: Low]
Is it safe to use a numeric range and arithmetic over enum vcpu_sysreg valu=
es
here in pmu_reg_write()? Since the enum indexes sparse VNCR-mapped registers
by byte offset rather than declaration order, range checks and arithmetic
can cover unintended registers. Should this use an explicit per-register
allowlist instead?

> +
> +		if (kvm_pmu_is_partitioned(vcpu->kvm)) {
[ ... ]
> +	case PMEVTYPER0_EL0 ... PMCCFILTR_EL0:
> +		idx =3D reg - PMEVTYPER0_EL0;

[Severity: Low]
Does this range check and subtraction also rely on contiguous enum values?
Like the previous case, should this be converted to an explicit per-register
match to avoid issues with the sparse enum numbering?

[ ... ]
> @@ -1276,18 +1471,21 @@ static bool access_pmu_evcntr(struct kvm_vcpu *vc=
pu,
>  			      struct sys_reg_params *p,
>  			      const struct sys_reg_desc *r)
>  {
[ ... ]
>  	if (!pmu_counter_idx_valid(vcpu, idx))
>  		return false;
> =20
> +	reg =3D PMEVCNTR0_EL0 + idx;
> +

[Severity: Low]
Does this arithmetic over the enum value in access_pmu_evcntr() assume a
contiguous layout? Using addition on enum vcpu_sysreg values might point to=
=20
an unintended register due to the sparse byte-offset mapping. Should this=20
be explicitly mapped instead?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260924172928.2110=
956-1-coltonlewis@google.com?part=3D10
