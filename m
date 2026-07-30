Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA46623392C;
	Thu, 30 Jul 2026 08:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785398731; cv=none; b=nOJMWG27yORpCV6RnQKjME57KuE+jv5Ir8knga7v3F4kD8Oh7wMJaZMaUnOYFn62+3/ge1HBeqFQJdof1GOfbZ1N6FIKbU/D5LWNWlY0TWCHmGXtaAGSp2KobydagAafQeAotHwcxQpQ6gyuMETccsVAvsvoiCNUVstvOqA/KOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785398731; c=relaxed/simple;
	bh=3q6L9nK0PRoXGOlsLDQbKcxqVVnZn69uLAYcK3btG9E=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=VqfXfncU6iA7MxOOd9c1oEHqoDDu16IwbD4bFvwZ/1ZHJ6M35XoG2VCrnFZUO16szOFFBLsYXUuIUfZV6//3yQWEehfRb6C9p3OA9LbUXJoOYbD4SckRkgwAH2cT1VwMCOYyJk1TA4kMK3Sekkn7QB/ZDLyHj6WRXJvSCYx5j+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lBDsLRm1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lBDsLRm1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29E051F00A3D;
	Thu, 30 Jul 2026 08:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785398729;
	bh=kMGihNNaZQS3ispxCa9nBmwiDMJyERf0PGQLCeRRgUo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lBDsLRm188Rht2/2By0Mb1hIsKOYlavIEmtRmyWpF0wUHgmkwV8a4/YJGzoqgNPSe
	 z9yhxwqyJVXlz75YabjMFh823Z+W5uMIzFvL4Vh+bZxRDy23/+oQtSQbK/Vaa946F2
	 LAKqeox0wEKfIM9G7V6ZLEdXpJjiqJs8muuxBEXxTStlsM5+jozXKQQXPh++2dlI5y
	 B2wj8nhrhmzskVAL5kaAp4136AwONzUrOUYRZfvnC0x7s7PhDVI2W7Ux31OoxKTQyr
	 iR17Y8XWLRLjHrg3MY0ZvAX3I5HpLwTmE4fvUoa0/aUOC/KeTMgt0EoTOOCDggBRuq
	 oUNj8H1pc/6LQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 23/29] KVM: arm64: Add NVHCR_EL2 context switching
Reply-To: sashiko-reviews@lists.linux.dev
To: "Marc Zyngier" <maz@kernel.org>
Cc: kvm@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260730071022.296811-24-maz@kernel.org>
References: <20260730071022.296811-1-maz@kernel.org>
 <20260730071022.296811-24-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 30 Jul 2026 08:05:28 +0000
Message-Id: <20260730080529.29E051F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] TOCTOU vulnerability in NV3 context switching leading to cross-VM =
information leak
--

--- Patch [23]: [PATCH v4 23/29] KVM: arm64: Add NVHCR_EL2 context switchin=
g ---
commit f6089755f833008f36c0718e0727dbb85a4f24ae
Author: Marc Zyngier <maz@kernel.org>

KVM: arm64: Add NVHCR_EL2 context switching

This commit introduces NVHCR_EL2 context switching. For a guest in hyp
context, NVHCR_EL2 reflects HCR_EL2 and is eagerly synced. For an L2 guest,
it is context switched like any EL1 register, conditioned on the guest using
NV3.

> diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/=
hyp/include/hyp/sysreg-sr.h
> index a17cbe7582de9..c382848d31947 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> @@ -172,6 +172,10 @@ static inline void __sysreg_save_el1_state(struct kv=
m_cpu_context *ctxt)
> =20
>  	if (ctxt_has_sctlr2(ctxt))
>  		ctxt_sys_reg(ctxt, SCTLR2_EL1) =3D read_sysreg_el1(SYS_SCTLR2);
> +
> +	/* Retrieve L2's HCR_EL2, and save it for future use */
> +	if (is_nested_nv3_ctxt(ctxt_to_vcpu(ctxt)))
> +		ctxt_sys_reg(ctxt, NVHCR_EL2) =3D read_sysreg_s(SYS_NVHCR_EL2);

[Severity: High]
Does this introduce a TOCTOU regression leading to a cross-VM information
leak?

KVM uses the guest-modifiable VNCR state to decide whether to read the
hardware register, allowing a TOCTOU that reads uninitialized or stale
hardware state.

Looking at is_nested_nv3_ctxt(), it evaluates HCRX_EL2.NVTGE directly from
the guest-modifiable VNCR page:

arch/arm64/include/asm/kvm_emulate.h:is_nested_nv3_ctxt() {
    ...
    return (... && (__vcpu_sys_reg(vcpu, HCRX_EL2) & HCRX_EL2_NVTGE));
}

If an L1 guest concurrently modifies its VNCR page from another vCPU to
change NVTGE from 0 to 1 during an L2 guest's execution, KVM might read from
SYS_NVHCR_EL2 here on vcpu_put() or during sysreg trap handling. This could
copy the leaked hardware state into the L2 guest's context, where it can be
read.

[ ... ]

> @@ -285,6 +289,13 @@ static inline void __sysreg_restore_el1_state(struct=
 kvm_cpu_context *ctxt,
> =20
>  	if (ctxt_has_sctlr2(ctxt))
>  		write_sysreg_el1(ctxt_sys_reg(ctxt, SCTLR2_EL1), SYS_SCTLR2);
> +
> +	/*
> +	 * Publish the L2 view of HCR_EL2 to the HW if L1 is using NV3.
> +	 * Otherwise, the data is already in place in the L1's own VNCR.
> +	 */
> +	if (is_nested_nv3_ctxt(ctxt_to_vcpu(ctxt)))
> +		write_sysreg_s(ctxt_sys_reg(ctxt, NVHCR_EL2), SYS_NVHCR_EL2);

[Severity: High]
Can the same concurrent VNCR page modification cause KVM to skip initializi=
ng
the hardware register?

If NVTGE is 0 during vcpu_load(), KVM skips initializing the hardware
register, leaving the previous VM's state in hardware. A malicious L1 guest
can trigger this by configuring an L2 guest, spawning a concurrent vCPU to
modify the VNCR page, and executing a trapped instruction in L2.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260730071022.2968=
11-1-maz@kernel.org?part=3D23
