Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 804862E0B5C;
	Tue, 29 Sep 2026 10:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790679234; cv=none; b=VHhRle19KbalEuXop3ZQEOs51LYsD2SN7rEEjDUg1X8K6Sf9SqI6NeJYBOsSzicjW3AkvhSUrEffE+H4/g5fRv1dO+lrSuPUqFWS+deTtaUr9ge9IpbiV552Wh7/rNAIiaqIQq9tRkK2tr64YGYQvRvLooK6VlkYAYPBYzRTKt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790679234; c=relaxed/simple;
	bh=7O/e9Ld8xUYI9IBX6OlAxL3SOSLv92tRZwVO46ntfXg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=M4eJSxap4sOdOV7JkmfkP3z12+J7W673kZYljGgSFQgTBMYxZJbh91TUhX/vD1zpHsJSQ42Y2sauTNGIgQv+AiymCazxWr+5g4s4tbK5TBancmFNKX/u7kwZ4TJVL3TqxdUdcFTvSQkMiebMMKR1wVGSdXY+BrcAXFzplLhXlSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ofHGj+/x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ofHGj+/x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3CB21F000FF;
	Tue, 29 Sep 2026 10:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790679229;
	bh=fLauXofaVGzaJUTrfNYISw7i+jXs1j6Mat75lwXeeFc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ofHGj+/xknncoqwZPuIGIlnFEYbRf8Y0wZ6f8uy+gX13gKblb7QIp01oAxGkxo2v6
	 vHSOlQD0dN6AftIg2OJYNzB9th26pIpCPAWh/lDun0sxXlwnXZnXlU72pmyLJrss3i
	 EchjAg20GRc5wo/FsL4vsZTB06C6uOzoNsnXzu9apFzDrMaOss7TxiSEcWv1RFfRzH
	 +xFda1lDPAkSzYP81SJJkzioNCUQRem77gz3kn3FcwKrgsV4W08r7ju54l4auuFzw3
	 mQnMd0xYidLjMCZANbge5OaKFfmgWy6Z+K/fzJopbZ/rHfRyyVI2i3Mljz3Ox4IGYL
	 kAwoLuuF5K4Hw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 09/15] KVM: arm64: Handle HDBSS faults
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tian Zheng" <zhengtian10@huawei.com>
Cc: "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, kvm@vger.kernel.org
In-Reply-To: <20260929103655.85107-10-zhengtian10@huawei.com>
References: <20260929103655.85107-1-zhengtian10@huawei.com>
 <20260929103655.85107-10-zhengtian10@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 29 Sep 2026 10:53:48 +0000
Message-Id: <20260929105348.E3CB21F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] arm64: KVM checks DABT-specific HDBSSF bit on Instruction Aborts
- [High] KVM: guest-reachable WARN_ON_ONCE assertions in HDBSS fault handler
--

commit 93c9cd523cd96ee876cb40ad4d3ecad32cc8aeff
Author: Eillon <yezhenyu2@huawei.com>

KVM: arm64: Handle HDBSS faults

This commit introduces handling for hardware stopped promoting writable-cle=
an
descriptors, which raises a stage-2 Permission fault with ESR_EL2.ISS2.HDBS=
SF.
It dispatches these from kvm_handle_guest_abort() via a new helper to clear
the fault and report -EFAULT.

> diff --git a/arch/arm64/kvm/dirty_bit.c b/arch/arm64/kvm/dirty_bit.c
> index be0d12555c848..893a8c4248bcc 100644
> --- a/arch/arm64/kvm/dirty_bit.c
> +++ b/arch/arm64/kvm/dirty_bit.c
[ ... ]
> +int kvm_handle_hdbss_fault(struct kvm_vcpu *vcpu)
> +{
> +	u64 prod;
> +	u64 fsc;
> +
> +	if (WARN_ON_ONCE(!system_supports_hdbss()))
> +		return -EFAULT;
> +
> +	if (WARN_ON_ONCE(!vcpu_hdbss_enabled(vcpu)))
> +		return -EFAULT;

[Severity: High]
Are these WARN_ON_ONCE assertions safe to expose on a guest-reachable path?

If a guest manages to inadvertently route execution here (for instance, via=
=20
an Instruction Abort matching the HDBSSF bit in its ISS2 field), these=20
assertions can be triggered directly by the guest.

If the host has panic_on_warn enabled, this could lead to a host kernel
panic and a complete denial of service. Should these be standard error
returns without the warnings instead?

> +
> +	prod =3D read_sysreg_s(SYS_HDBSSPROD_EL2);
> +	fsc =3D FIELD_GET(HDBSSPROD_EL2_FSC_MASK, prod);
> +
> +	if (fsc =3D=3D HDBSSPROD_EL2_FSC_OK)
> +		/* Buffer full: the exit path drained it before handle_exit. */
> +		return 1;
> +
> +	if (fsc !=3D HDBSSPROD_EL2_FSC_ExternalAbort &&
> +	    fsc !=3D HDBSSPROD_EL2_FSC_GPF)
> +		WARN_ONCE(1,

[Severity: High]
Similarly, could this WARN_ONCE be triggered by a guest-driven event?

> +			  "Unexpected HDBSS fault type, FSC: 0x%llx (prod=3D0x%llx, vcpu=3D%d=
)\n",
> +			  fsc, prod, vcpu->vcpu_id);
> +
> +	/* Clear FSC so hardware dirty state updates can resume. */
> +	write_sysreg_s(prod & ~HDBSSPROD_EL2_FSC_MASK, SYS_HDBSSPROD_EL2);
> +	return -EFAULT;
> +}
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 85a98d2c23a99..7bf82d65041c8 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
[ ... ]
> @@ -2315,6 +2316,9 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
> =20
>  	is_iabt =3D kvm_vcpu_trap_is_iabt(vcpu);
> =20
> +	if (esr_iss2_is_hdbssf(esr))
> +		return kvm_handle_hdbss_fault(vcpu);
> +

[Severity: High]
Does this inadvertently check the HDBSSF bit for Instruction Aborts?

The esr_iss2_is_hdbssf() helper in arch/arm64/include/asm/esr.h extracts
the ISS2 bit without verifying the Exception Class. Because the ISS layout
is per-EC, an Instruction Abort's ISS2 field might coincidentally have this
bit set for an entirely unrelated reason.=20

If that happens, a valid Instruction Abort would be misidentified as a
HDBSS fault, routing execution into kvm_handle_hdbss_fault() and causing
guest breakage. Should this check be gated by !is_iabt or a specific
Exception Class check?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260929103655.8510=
7-1-zhengtian10@huawei.com?part=3D9
