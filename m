Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACC5C3B42F8
	for <kvmarm@lists.linux.dev>; Fri,  3 Jul 2026 10:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783073605; cv=none; b=U4ZpABwjcbd91y2LjxBZ3FtkdCH937m1lLRzcF2qa6DpuD08niHhsrjg5/fhy02b2TxmMEVQRwCQo8D6beDxZlGRFxNs+nkwg5rOb5vQeOa9UJ/OuN3Xepifu4AWAFHXmC9BmjrU3v4G0PMa69Qpix/cSlPJLE7be56D8qMs/uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783073605; c=relaxed/simple;
	bh=9hla3t+c5zqJimSduN+LQTaDyhccWGBvvsfkaUe/QuU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=jTJSPCFs3cyhg+9z5sKjyjuM1MGwKlGLxjCWPueOgb7AYUY1FrN/eHAbZH6b0Q+c//S5G50b5d8fh2IxVJuPlxeUBSjMUI9gJFPLeWzCnTE2VASUuE0zfdkw6mX7nqLFXliQPSAcBGJb7di8gsjTUp2CldCsvrg24G/svz6R1+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hid7gq88; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hid7gq88"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB4141F00ADE;
	Fri,  3 Jul 2026 10:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783073603;
	bh=ZOxZaDzzEMtDCNjx0frIMwgVtHY0saQRjvWOWQpODqo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hid7gq88u/Y8ZNitoDA2xuXjI5FqYQf1sVZEgJNR24M63MhBk1tAOzC19MlkD8KvD
	 ASJh7gv/E30xzTPspqYkUJmNqAPORD1pYyYQF++emZvtDt8F7u0MzFmCYujODO1BMq
	 pIwUmvKGTb74YpdwiHZgkIKrabV0iHP4Iytu+i1zbG8UNd+lUTPY7gWH5FR6u3MvQf
	 VmxFlGaeI4juhWO99MXtiY6fjUZpJhtjwaGPGZP1KcWc4daFfhGqJ+0Rw+kQizQ7UJ
	 jZCS62zlmABHHKzINQi3+7FQNX85PvozyCoWlUFmPSN4TRtFAUbALMC3glY2CUrPSG
	 VA6UYNO4xBhkQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 11/17] KVM: arm64: Hide FEAT_NMI from guests
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jinjie Ruan" <ruanjinjie@huawei.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260703100135.2512312-12-ruanjinjie@huawei.com>
References: <20260703100135.2512312-1-ruanjinjie@huawei.com>
 <20260703100135.2512312-12-ruanjinjie@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 10:13:22 +0000
Message-Id: <20260703101322.EB4141F00ADE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] The HCRX_EL2.TALLINT trap is inadvertently bypassed for the guest =
and erroneously enabled for the host due to a register overwrite and a poll=
uted host context save.
- [High] Missing Context Synchronization Event (ISB) after writing to the c=
ontrol-plane system register SYS_HCRX_EL2.
--

commit 8eef1f43bfda118ac8512933d8d6a2f3483208ee
Author: Mark Brown <broonie@kernel.org>

KVM: arm64: Hide FEAT_NMI from guests

This commit hides FEAT_NMI from guests pending vGIC support. It masks out
the feature from the ID register and sets HCRX_EL2.TALLINT to trap guest
writes to ALLINT.ALLINT.

Link: https://lore.kernel.org/r/20221112151708.175147-10-broonie@kernel.org

> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp=
/include/hyp/switch.h
> index 18131e395e24c..21b19f331a12f 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -346,6 +346,9 @@ static inline void __activate_traps_common(struct kvm=
_vcpu *vcpu)
>  		vcpu_set_flag(vcpu, PMUSERENR_ON_CPU);
>  	}
> =20
> +	if (cpus_have_final_cap(ARM64_HAS_NMI))
> +		sysreg_clear_set_s(SYS_HCRX_EL2, 0, HCRX_EL2_TALLINT);
> +
>  	if (cpus_have_final_cap(ARM64_HAS_HCX)) {
>  		u64 hcrx =3D vcpu->arch.hcrx_el2;

[Severity: High]
Does this sequence inadvertently drop the trap for the guest and pollute the
host context?

Because FEAT_HCX is mandatory with FEAT_NMI, the code will execute the HCX
block immediately after setting TALLINT:

arch/arm64/kvm/hyp/include/hyp/switch.h:__activate_traps_common() {
    ...
    if (cpus_have_final_cap(ARM64_HAS_HCX)) {
        u64 hcrx =3D vcpu->arch.hcrx_el2;
        ...
        ctxt_sys_reg(hctxt, HCRX_EL2) =3D read_sysreg_s(SYS_HCRX_EL2);
        write_sysreg_s(hcrx, SYS_HCRX_EL2);
    }
}

Since SYS_HCRX_EL2 is immediately overwritten with the guest's hcrx_el2
(which lacks the TALLINT bit), it appears the trap is bypassed for the gues=
t.

Additionally, this reads the newly modified SYS_HCRX_EL2 (with TALLINT set)
into the host's context. When the host context is later restored, will it
leave the host running with the TALLINT trap incorrectly active?


[Severity: High]
Can this read-back observe architecturally undefined pipeline state?

Immediately after sysreg_clear_set_s() writes to the control-plane system
register SYS_HCRX_EL2, the ARM64_HAS_HCX block executes a read-back via
read_sysreg_s(SYS_HCRX_EL2) without an intervening context synchronization
event (isb()).

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703100135.2512=
312-1-ruanjinjie@huawei.com?part=3D11
