Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F35CD3BADAA
	for <kvmarm@lists.linux.dev>; Mon, 17 Aug 2026 10:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786963636; cv=none; b=cmOjtSdcMYLpgezOvecb8DRm3RkoIFnk8rItQaZ2K58DOgqsjM3g2ybtngU8SvUY64J6zxa0x1vMixOCezmVm7/1KtLHrykYMqoLh35qDdBinT2V9r46J4YhAbVj2wJkIS23Gop0f/2BYXn0XiITTSAQVlFHpN6C8hGvOq+pP2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786963636; c=relaxed/simple;
	bh=vMnAAV8MSf4Nh7Vnl54+ZE2dy1XZGtMH45UOkZVbx5Q=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=bvWwPrjrLYORcAReGe+LVLAJXPn9MAwkslor0rCYkPX2pkCOVn6Cq/J11zZKZ+msyY9JUK9JP5qJAR/SsAu0renZMSYPGfhBg+ptVuedwok+NB0nAxhnVmACP1+OSzcY9SIOsR/GXtc7PvkA9VfaQAfPnL3nifmnfYAl2gUhj1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GOiC4pUy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GOiC4pUy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26A3D1F000E9;
	Mon, 17 Aug 2026 10:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786963631;
	bh=IMbPejEbJZCXof+UvJtcYE05aA1UHg1hVCzLvhOyb1U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GOiC4pUysGRdjSO93O4XN0bOKEzxVQAXSCr4fig0erUABXPYMNz6LjymFBfPmHk0C
	 0nNtOIWUzXyWf/Ng8PrSlkw3H+QI+Cahfq5LJSqzpe/zr3wOeZUxGEeXyJ1+VNW+4m
	 8HL08uVKDMCeJknfKwG7p8pihyUs268JZ5jyJFxO5FDOwFGv1s6y9p2on6iEtnPQHx
	 zGbIekgy91th+HIO6BQt2sCOFAdCSFMMj7jjsZxVHnbPT7eGfNmkrBMDriPbV8E1Wx
	 I69AmcWwsQLUF+/xFhdunqxDylyALLkVguASlVLVUF+nGYBEjs7x1uxQpQ42W7JMVD
	 5vuK6OmLmewCQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/4] KVM: arm64: Reject the GICv5 CPU interface
 hypercalls under pKVM
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260817103228.1203140-3-fuad.tabba@linux.dev>
References: <20260817103228.1203140-1-fuad.tabba@linux.dev>
 <20260817103228.1203140-3-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 17 Aug 2026 10:47:10 +0000
Message-Id: <20260817104711.26A3D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [Medium] The patch manually adds runtime mode checks inside GICv5 handler=
s instead of correctly categorizing the hypercall IDs in the pKVM availabil=
ity bands, resulting in an incorrect SUCCESS return for an unsupported oper=
ation.

Pre-existing issues:
- [Critical] Always-on legacy hypercalls (like `handle___vgic_v3_save_aprs`=
 and `handle___kvm_adjust_pc`) dereference host-provided pointers using `ke=
rn_hyp_va()` without ownership validation, enabling a malicious host to arb=
itrarily corrupt hypervisor memory.
--

--- Patch [2]: [PATCH v2 2/4] KVM: arm64: Reject the GICv5 CPU interface hy=
percalls under pKVM ---
commit b55739e7ec2cd459ba47129f61f967475ca69c49
Author: Fuad Tabba <fuad.tabba@linux.dev>

KVM: arm64: Reject the GICv5 CPU interface hypercalls under pKVM

__vgic_v5_save_apr() and __vgic_v5_restore_vmcr_apr() remain callable
after pKVM finalises. pKVM never registers a GICv5 vgic, so neither has
a valid caller in protected mode, and on a GICv3 machine both reach a
register that is UNDEFINED at EL2 and panic the hypervisor.

> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe=
/hyp-main.c
> index d3c69de698f48..9159bce7515b1 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -695,6 +695,9 @@ static void handle___vgic_v5_save_apr(struct kvm_cpu_=
context *host_ctxt)
>  {
>  	DECLARE_REG(struct vgic_v5_cpu_if *, cpu_if, host_ctxt, 1);
> =20
> +	if (unlikely(is_protected_kvm_enabled()))
> +		return;
> +

[Severity: Medium]
Does this early return leave SMCCC_RET_SUCCESS in the return register
instead of correctly rejecting the call?

Because the hypercall ID remains in the always-on band in
enum __kvm_host_smccc_func, the dispatcher will preload SMCCC_RET_SUCCESS
and route it here. Returning early means the host receives a success code
for an unsupported operation.=20

Would it be better to move these hypercall IDs before
__KVM_HOST_SMCCC_FUNC_MIN_PKVM in asm/kvm_asm.h so the dispatcher
rejects them automatically with SMCCC_RET_NOT_SUPPORTED?

>  	__vgic_v5_save_apr(kern_hyp_va(cpu_if));
>  }
> =20
> @@ -702,6 +705,9 @@ static void handle___vgic_v5_restore_vmcr_apr(struct =
kvm_cpu_context *host_ctxt)
>  {
>  	DECLARE_REG(struct vgic_v5_cpu_if *, cpu_if, host_ctxt, 1);
> =20
> +	if (unlikely(is_protected_kvm_enabled()))
> +		return;
> +
>  	__vgic_v5_restore_vmcr_apr(kern_hyp_va(cpu_if));
>  }

[Severity: Critical]
This is a pre-existing issue, but while looking at how kern_hyp_va()
is used in this file, could a host use the always-on legacy hypercalls
to modify hypervisor memory?

In handle___vgic_v3_save_aprs():

static void handle___vgic_v3_save_aprs(struct kvm_cpu_context *host_ctxt)
{
        DECLARE_REG(struct vgic_v3_cpu_if *, cpu_if, host_ctxt, 1);
        __vgic_v3_save_aprs(kern_hyp_va(cpu_if));
}

And similarly in handle___kvm_adjust_pc():

static void handle___kvm_adjust_pc(struct kvm_cpu_context *host_ctxt)
{
        DECLARE_REG(struct kvm_vcpu *, vcpu, host_ctxt, 1);
        __kvm_adjust_pc(kern_hyp_va(vcpu));
}

Since kern_hyp_va() transforms the pointer without validating page
ownership, what happens if the host passes a pointer that resolves to an
EL2-owned physical page? It appears this might give the host an
arbitrary write or bit-clear primitive against hypervisor memory. Should
these always-on handlers validate the host pointer before dereferencing it?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260817103228.1203=
140-1-fuad.tabba@linux.dev?part=3D2
