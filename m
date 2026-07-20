Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE1A21A92F;
	Mon, 20 Jul 2026 05:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784527041; cv=none; b=tvp8G3IaA48aCM0VIWkcbBNDtkXHku2UJVTbJHgTSO0/oatYKEVglik9A9CYzXQXFxEPyFUuuliPSouy/9Hl2BSQ3t6MFhJR8K7ii0BmSTsZ1dY6+tBq6oYddJql0M57J5uMaLg3JGJpvKwhCLj7ARuPxFaQ9x4OGYXk3089wT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784527041; c=relaxed/simple;
	bh=pKV96A0SWIuMUjufu8YLcZPrJyCsCuol8SuZON9D6Lw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=eK6anc9GgaoiQ68/UYC1KRA1hq1OIfYDpn6uDhCcEzA3jnh8UQzae8Q6GGqr6+3gzGwC8WX9ATmJclpYuOaPU/0ekcczqtkLZwXdSZuPBjqyjBNL8p0Z885GU1lMEMBCn9+0G5jLEeNcdCYWzDgLVmt4jGBIjGb7kdWxH6OmeFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SvtRMAAJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SvtRMAAJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A33B61F00A3A;
	Mon, 20 Jul 2026 05:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784527025;
	bh=af9/u+LaaZlDDkKvWMsapxUkCR3N5wMytPgxrWxL3bw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SvtRMAAJI7B35kQiWGqorul5EBzNzJ198wjYnuWvHzd+tGde4hm4TWWfcjNj0VIOA
	 N1zD+2vxXUmgtAd4gYRL/wBy06Hd5lob2Hu+ar12S++l+Tq6L02+bhnbV4aCbXXG2U
	 LQP9Zi9s08N6DOeuNeL4a36gg2vlyOSEG1CNgah1ahgZZW6tr96iK7kWRbZDt82ceB
	 esX+ccG95Hcg5OsDDbPSM+Tij/rtegqKnUfuPNWh6J/zBO9x1D76/MKxaoocCoipmF
	 xDhvmbhRt0MBnfhVpjgeZNkpmzNm4lISOF6xGxvXDZlM8TY57dNK4jrOhsYpx9TINV
	 u/2LPGErP5lIQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 06/16] KVM: arm64: PMU: Recreate events after
 MDCR_EL2 changes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Akihiko Odaki" <odaki@rsg.ci.i.u-tokyo.ac.jp>
Cc: kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260720-hybrid-v9-6-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp>
References: <20260720-hybrid-v9-0-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp>
 <20260720-hybrid-v9-6-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 20 Jul 2026 05:57:05 +0000
Message-Id: <20260720055705.A33B61F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [Medium] Modifying PMCR_EL0.LC or PMCR_EL0.LP does not recreate perf even=
ts, leading to stale sample periods for active counters.
- [Medium] Userspace modification of PMEVTYPERn_EL0 or PMCCFILTR_EL0 via KV=
M_SET_ONE_REG does not trigger a PMU reload or recreate the backing perf_ev=
ent.
--

--- Patch [6]: [PATCH v9 06/16] KVM: arm64: PMU: Recreate events after MDCR=
_EL2 changes ---
commit 55bb4c8121d4871eb781b7b2feafd0970dbee364
Author: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>

KVM: arm64: PMU: Recreate events after MDCR_EL2 changes

MDCR_EL2.HPMN changes which counters are reserved for EL2 and thus which
enable control, event filter, and overflow width apply. Route guest writes,
userspace writes, and reset through a common helper to mark the vCPU's
perf events for recreation when HPMN, HPMD, or HLP changes.

> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c

[ ... ]

> @@ -606,6 +609,21 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 =
val)
>  	}
>  }
> =20
> +void kvm_pmu_handle_mdcr(struct kvm_vcpu *vcpu, u64 old, u64 val)
> +{
> +	u64 changed =3D old ^ val;
> +
> +	/*
> +	 * HPMN determines which counters HPMD and HLP apply to. Changes to
> +	 * these fields require new perf event filters and sample periods.
> +	 */
> +	if (changed & MDCR_EL2_PMU_RECREATE_MASK)
> +		vcpu->arch.pmu.events_need_recreate =3D true;
> +
> +	if (changed & (MDCR_EL2_HPME | MDCR_EL2_PMU_RECREATE_MASK))
> +		kvm_make_request(KVM_REQ_RELOAD_PMU, vcpu);
> +}

[Severity: Medium]
This is a pre-existing issue, but modifying PMCR_EL0.LC or PMCR_EL0.LP
doesn't seem to recreate perf events.

Guest writes to PMCR_EL0 in kvm_pmu_handle_pmcr() only trigger a PMU reload
if the E bit changes, and never mark events for recreation when LC or LP
change. This also applies to userspace KVM_SET_ONE_REG writes to PMCR_EL0 v=
ia
set_pmcr(), which request a reload but fail to set
events_need_recreate =3D true.

Because PMCR_EL0.LC and LP determine whether the PMU counters overflow at 32
or 64 bits, does this leave the events using stale sample periods, leading
to incorrect performance statistics and mistimed overflow interrupts?

> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c

[ ... ]

> @@ -3741,7 +3751,8 @@ static const struct sys_reg_desc sys_reg_descs[] =
=3D {
>  	EL2_REG_FILTERED(SCTLR2_EL2, access_vm_reg, reset_val, 0,
>  			 sctlr2_el2_visibility),
>  	EL2_REG_VNCR(HCR_EL2, reset_hcr, 0),
> -	EL2_REG(MDCR_EL2, access_mdcr, reset_mdcr, 0),
> +	SYS_REG_USER_FILTER(MDCR_EL2, access_mdcr, reset_mdcr, 0,
> +			    NULL, set_mdcr, el2_visibility),

[Severity: Medium]
This is also a pre-existing issue, but userspace modifications of
PMEVTYPERn_EL0 or PMCCFILTR_EL0 via KVM_SET_ONE_REG don't appear to trigger=
 a
PMU reload or recreate the backing perf_event.

Because the macros defining PMEVTYPERn_EL0 and PMCCFILTR_EL0 in
sys_reg_descs lack a .set_user accessor, kvm_sys_reg_set_user() falls back =
to
__vcpu_assign_sys_reg() without requesting a PMU reload or event recreation.

If userspace modifies a vCPU's PMU event type registers after the vCPU has
already run, does the PMU continue counting the old events, leading to
incorrect statistics?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260720-hybrid-v9-=
0-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp?part=3D6
