Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 428EA4071E8
	for <kvmarm@lists.linux.dev>; Mon,  7 Sep 2026 07:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788765381; cv=none; b=hHhVyCJJlEtn/a9RxgT2HtWypd0oimXsrpjm2vYWdJlYB16ODuOlehNj9Eruc4ADEtO58jApuYQK/hm2PORGVOdJX+VxEZ5eTrb+jszfNXLXxz4ojsPfrTyvF67FXcYFqpPNsbzHVTF99TtShmWGiYzlgFNpcRBnioyqJlX2i7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788765381; c=relaxed/simple;
	bh=E4qaCch6+WQ4BMUf6YPRRICFuwLs4CbOE3vFzuWxCwg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ukm4ksRJOCt9hlU5ccn7WaXtZWu7JkI8j443LhLqtY7dVycD/OJUUxPkOLjnHPT4qxaSbzKYxLy8oBi9Pkc45gC32LgT7XyhBbx7CJf3IiI/MsLW7yw/8jumfAK1T11fQ9MBMJ+2UoR1gB2g/eZ/It0QBukaVoLtyCZG9yurJ+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mzK2s+S8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mzK2s+S8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BB6D1F00A3A;
	Mon,  7 Sep 2026 07:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788765377;
	bh=nhJMAN8oyMRW8mKzZ8cDiPaP7zCYMbHxfgtlf5Jw5a4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mzK2s+S8qaKPWbqo1TpyPlwUCQ/d037lVAE5+FxEGzVjwdBXyV4mWb0xkvCczHcG3
	 9uVm7isg3SpJWykZKM3HcKpg26LuY53BNKXFGgdRfMMcA8xE8H03fpSSkqN/mioSID
	 iUUvUnb1omm8LJuNdZ9TGcob/NxIH1afrrGq80SxCUNJmW1OJG1Jdj7JJy/bcxQx5x
	 rNH9ox7JD8npkrFTCs2meoQCdEOwWneivMiPoh/MZ1i9pngME74ohMU8mGAYAVVK1y
	 WLkLrUm1+PbGtYGXmDxPy78AyWr/ZPIC7hT585/gILYPtWvs7Diyy9gqHDbtTd7SSw
	 450EyZO3LbCGA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 06/17] KVM: arm64: Add system register reset
 framework for protected VMs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260907070002.3333525-7-fuad.tabba@linux.dev>
References: <20260907070002.3333525-1-fuad.tabba@linux.dev>
 <20260907070002.3333525-7-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 07:16:16 +0000
Message-Id: <20260907071617.2BB6D1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] Missing EL1 system registers from the pKVM reset array `pvm_sys_=
reg_reset_vals`.
- [Medium] Invalid numeric comparison (>=3D) over sparse `enum vcpu_sysreg`=
 values to enforce fragile array sorting.
--

commit 7a5dc29475a7c4550659db2df410ae56a785635e
Author: Fuad Tabba <fuad.tabba@linux.dev>
Subject: KVM: arm64: Add system register reset framework for protected VMs

This patch introduces the system register reset framework for protected VMs,
adding kvm_reset_pvm_sys_regs() and its driving array pvm_sys_reg_reset_val=
s.
It populates reset values for sysregs that need to be reset to UNKNOWN or
explicit values for pKVM guests.

> diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe=
/sys_regs.c
> index 8758c68017765..03d2c2447e0fd 100644
> --- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> +++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c

[ ... ]

> +/* Sorted ascending by reg; kvm_check_pvm_sysreg_table() enforces it. */
> +static const struct sys_reg_desc_reset pvm_sys_reg_reset_vals[] =3D {
> +	RESET_FUNC(MPIDR_EL1, reset_mpidr),
> +	RESET_UNKNOWN(TPIDR_EL0),
> +	RESET_UNKNOWN(TPIDRRO_EL0),
> +	RESET_UNKNOWN(TPIDR_EL1),

[Severity: Medium]
Are we missing several EL1 system registers from this array? The commit
message mentions this table is supposed to hold the registers that
sys_regs.c resets to UNKNOWN. However, it seems to omit several newer
architectural registers (like PIR_EL1, PIRE0_EL1, POR_EL1, POR_EL0,=20
TFSR_EL1, TFSRE0_EL1) which __sysreg_restore_state_nvhe() explicitly restor=
es
for a protected vCPU.

Because the hyp vCPU page is zeroed, these omitted registers will be
zero-initialized instead of receiving the intended poison value
(0x1de7ec7edbadc0deULL) when kvm_reset_pvm_sys_regs() is called for a
protected VM.

[ ... ]

> @@ -550,16 +610,21 @@ void kvm_init_pvm_id_regs(struct kvm_vcpu *vcpu)

[ ... ]

>  int kvm_check_pvm_sysreg_table(void)
>  {
>  	unsigned int i;
> =20
>  	for (i =3D 1; i < ARRAY_SIZE(pvm_sys_reg_descs); i++) {
> -		if (cmp_sys_reg(&pvm_sys_reg_descs[i-1], &pvm_sys_reg_descs[i]) >=3D 0)
> +		if (cmp_sys_reg(&pvm_sys_reg_descs[i - 1], &pvm_sys_reg_descs[i]) >=3D=
 0)
> +			return 1;
> +	}
> +
> +	for (i =3D 1; i < ARRAY_SIZE(pvm_sys_reg_reset_vals); i++) {
> +		if (pvm_sys_reg_reset_vals[i - 1].reg >=3D pvm_sys_reg_reset_vals[i].r=
eg)
>  			return 1;
>  	}

[Severity: Medium]
Is it safe to use a numeric comparison (>=3D) over the .reg field here?=20
Since pvm_sys_reg_reset_vals[].reg contains enum vcpu_sysreg values,
and these are indexed by their VNCR-page byte offset rather than in
declaration order, a layout change or new enum value could reorder their
integer values.

If that happens, the static array's manually sorted order would break,=20
triggering a fatal BUG_ON() at boot during hypervisor initialization.=20
Should this enforce an explicit allowlist or a different sorting mechanism
instead of a numeric range check?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907070002.3333=
525-1-fuad.tabba@linux.dev?part=3D6
