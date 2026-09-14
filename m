Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFA913D8122;
	Mon, 14 Sep 2026 12:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789388653; cv=none; b=dOYQD76CT2A+oJKdX4Wr0pJ2brPqp5WqcPTUqaXEmSBfYV5Qx92ctrtkvAxs239KJV3+NFey7rB0Nkae5xxei8bBYj4Qqmj4H+6yJX7k8CINdIqSqoVZOfkW9szdyH3lfA44jDKiL3ZFq0xMeSDvIX1M+lX2HMdjEVo57wUkjy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789388653; c=relaxed/simple;
	bh=yufSdBbFpXzXEVfdix/XFSDqBRbGf6ORkkNeojbkAw8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=VPJLPU5YKQewCTUJNO2LjSZj6MKDteKmXkxjrp/Jy55LyBhNqQpNMMtFNbPRJFhX4+YHnPzL0eIO46/UMmCR58ZgZ7rnOKH9YvDYm6rl2OXJOprmY4FZptjpiYvUIZJmTsDSawh8QRss9DFAYEpqAdTaAQzhDYo3GdYd7YFqzqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c2bulrOe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c2bulrOe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A6E91F000FF;
	Mon, 14 Sep 2026 12:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789388651;
	bh=xZIACiGEGDW4ntgXwrzMw0RdNU+StMM1bJnuvjNsNAY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=c2bulrOeI859lV2logPQ2CR1QNAKpNbH2+0S6b/vrbIZJrjPlKvy1LgFqKStks9Hn
	 tTZSeOwAPfoHPpN5ae/H9I893oy4ghnTzYXOMLnBhcTfyRBoKATmOCYVJEHI8NAyi9
	 ojzNPp6ZLRtaYdp0Hq545urplET/zYvPsxlwg6hgRC9/7oItT6smMSt0Aq0cCqG6cd
	 9N1Rz+VfBIkNPtQeZxoFSvNug+mR6GmOva2FOvC07GENFG4Txq+HrSIYs7NrEc9CDq
	 vh5hHHZxvlQpZc3+3D6DAfwWD2AbX0P5XJYXrRE/9uNa4TUJnQE5TNNS+vfPn8kfAJ
	 Nx+IBqgfHR9UQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v10 06/20] KVM: arm64: PMU: Preserve EL2 bitmap state
 during migration
Reply-To: sashiko-reviews@lists.linux.dev
To: "Akihiko Odaki" <odaki@rsg.ci.i.u-tokyo.ac.jp>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260914-hybrid-v10-6-92788053a691@rsg.ci.i.u-tokyo.ac.jp>
References: <20260914-hybrid-v10-0-92788053a691@rsg.ci.i.u-tokyo.ac.jp>
 <20260914-hybrid-v10-6-92788053a691@rsg.ci.i.u-tokyo.ac.jp>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 12:24:10 +0000
Message-Id: <20260914122411.5A6E91F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Guest reads of PMU bitmap registers from EL1/EL0 fail to mask out =
EL2-reserved counters (HPMN), violating the architectural RAZ requirement a=
nd leaking EL2 PMU state.
--

commit 02155ef34a95aa6d00cf6402f40fbdccdad7a563
Author: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>

KVM: arm64: PMU: Preserve EL2 bitmap state during migration

KVM_GET_ONE_REG and KVM_SET_ONE_REG transfer raw vCPU state for
migration. Masking PMU bitmap registers with counters accessible at the
current EL drops EL2-reserved bits when the vCPU is stopped in EL1 or
EL0.

Use the implemented counter mask for these userspace accesses so the
complete bitmap state survives migration. Guest register accesses
continue to use the accessible counter mask.

Closes: https://sashiko.dev/#/patchset/20260720-hybrid-v9-0-2b713ca1b5dc@rs=
g.ci.i.u-tokyo.ac.jp?part=3D5

> Use the implemented counter mask for these userspace accesses so the
> complete bitmap state survives migration. Guest register accesses
> continue to use the accessible counter mask.

[Severity: High]
This isn't a bug introduced by this patch, but do the guest register access=
es
actually use the accessible counter mask for read paths?

When Nested Virtualization (NV) is active, an L1 hypervisor configures
MDCR_EL2.HPMN to reserve PMU counters for itself. If the L2 guest (running
at vEL1/vEL0) reads the PMU bitmap registers, it should read zero for these
reserved counters to satisfy architectural RAZ requirements.

However, looking at the read paths in arch/arm64/kvm/sys_regs.c, the raw st=
ate
is returned without applying the accessible counter mask:

arch/arm64/kvm/sys_regs.c:access_pmcnten() {
    ...
	} else {
		p->regval =3D __vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
	}
    ...
}

arch/arm64/kvm/sys_regs.c:access_pminten() {
    ...
	} else {
		p->regval =3D __vcpu_sys_reg(vcpu, PMINTENSET_EL1);
	}
    ...
}

arch/arm64/kvm/sys_regs.c:access_pmovs() {
    ...
	} else {
		p->regval =3D __vcpu_sys_reg(vcpu, PMOVSSET_EL0);
	}
    ...
}

Could this leak the L1 hypervisor's PMU configuration and overflow state
to the untrusted L2 guest?

> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 44aae52c473d7..42b6705bc21d1 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1326,7 +1326,7 @@ static bool access_pmu_evtyper(struct kvm_vcpu *vcp=
u, struct sys_reg_params *p,
> =20
>  static int set_pmreg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r=
, u64 val)
>  {
> -	u64 mask =3D kvm_pmu_accessible_counter_mask(vcpu);
> +	u64 mask =3D kvm_pmu_implemented_counter_mask(vcpu);
> =20
>  	__vcpu_assign_sys_reg(vcpu, r->reg, val & mask);
>  	kvm_make_request(KVM_REQ_RELOAD_PMU, vcpu);
> @@ -1336,7 +1336,7 @@ static int set_pmreg(struct kvm_vcpu *vcpu, const s=
truct sys_reg_desc *r, u64 va
> =20
>  static int get_pmreg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r=
, u64 *val)
>  {
> -	u64 mask =3D kvm_pmu_accessible_counter_mask(vcpu);
> +	u64 mask =3D kvm_pmu_implemented_counter_mask(vcpu);
> =20
>  	*val =3D __vcpu_sys_reg(vcpu, r->reg) & mask;
>  	return 0;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914-hybrid-v10=
-0-92788053a691@rsg.ci.i.u-tokyo.ac.jp?part=3D6
