Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A96471431
	for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 17:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789408714; cv=none; b=XkU4do2FvSiH/H5Glh70NgPA2bYsy5n64tuuzLrZcs0P/Y+Z/yXTg89jyrC4WFUWEMpS0YeIniu0D4oD0BaYz5yOtsgnZnWTVAEkJHspQob/UI2l/JSiTA2mYXaEVjT+gug4BIKknwl2j7HmEiUPQyCzdpUoBPeJHW7ozO6j06E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789408714; c=relaxed/simple;
	bh=QzuPNf/PrxZu7PV/u7kRe31Oe4A2JgsgwdQx3ju9HyU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=r10776s4NmoXC8BMKDY8fVWiC8BrbTBxqooffAgegTHq8R6wQE5CU3a4xkdrEJfkBPpuQnt1j3zg785dE32KvV6bTXw/77NWu3//xm87bzcmuUAKA3ydBfZSGsosQBXCbnhQcaUwf0bgqaSKkAEZULSrjW+KFTtholb8WW/Jbsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KEwz++2H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KEwz++2H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A2D91F000FF;
	Mon, 14 Sep 2026 17:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789408712;
	bh=XQ7fnpyg1lwTxCYVTn8N8j7+70+CzFfUAA52+u+0wjc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KEwz++2HChinyvUNZFryJJopWgIOH/bWZUU7Jz/nDb4UIyLcSnoCZIxaDS2cU/Nz7
	 kfmXXpRn+svTaf499cXvGEzgiBZp5x0VyIbHVR68pwGoEBeuS4K5wI4BqtQbnQy9pE
	 k7J/zMxmBB2byhRs6va3B5peHo/xRKtIsfILyexZNcVKiGNSPy5IDYQwVPhr+HrJKv
	 BXQPmCpDlJOvaHzEWEa0ecLEs6GXNwY5rGpADMXBBQnlK60tILOeB3BJAqGT3TvFYU
	 3pO87wKDO9k7L+fYxL4WmJJCl3yw0ebWtKtw6/l9i/EdnGO8RPf9IaFsc8W2+nyy3O
	 XlMt2Pswp+vrg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] KVM: arm64: Reject the stage-2 MMU pointer hypercalls
 under pKVM
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260914174521.832575-1-fuad.tabba@linux.dev>
References: <20260914174521.832575-1-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 17:58:31 +0000
Message-Id: <20260914175832.2A2D91F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Hypercall handlers `handle___kvm_adjust_pc`, `handle___vgic_v5=
_save_apr`, and `handle___vgic_v5_restore_vmcr_apr` dereference host-provid=
ed pointers via `kern_hyp_va()` without validation, allowing a malicious ho=
st to corrupt EL2-private memory under pKVM.
--

commit 6af3790e411879ef8c99b26ae2afdc619730e489
Author: Fuad Tabba <fuad.tabba@linux.dev>

KVM: arm64: Reject the stage-2 MMU pointer hypercalls under pKVM

This patch updates five stage-2 MMU pointer hypercalls to reject execution =
when
pKVM is enabled. It adds an is_protected_kvm_enabled() check to prevent
invalid execution paths.

Link: https://lore.kernel.org/all/20260914130152.F0D5F1F000FF@smtp.kernel.o=
rg/

> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe=
/hyp-main.c
> index 9a3b92e626adb..4b0d00e55e2ea 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c

[ ... ]

arch/arm64/kvm/hyp/nvhe/hyp-main.c:handle___kvm_adjust_pc() {
	DECLARE_REG(struct kvm_vcpu *, vcpu, host_ctxt, 1);

	__kvm_adjust_pc(kern_hyp_va(vcpu));
}

[Severity: Critical]
This is a pre-existing issue, but does this code allow a malicious host to
corrupt EL2-private memory?

The unvalidated host pointer vcpu is passed directly to __kvm_adjust_pc
which mutates it. An untrusted host could invoke the
__KVM_HOST_SMCCC_FUNC___kvm_adjust_pc hypercall with a crafted pointer (e.g=
.,
an EL2 private-memory pointer which is idempotent under kern_hyp_va()). The
handler handle___kvm_adjust_pc directly passes this unvalidated pointer to =
the
underlying function, which dereferences it. This could allow the host to
overwrite arbitrary EL2 memory or leak its contents into system registers.

arch/arm64/kvm/hyp/nvhe/hyp-main.c:handle___vgic_v5_save_apr() {
	DECLARE_REG(struct vgic_v5_cpu_if *, cpu_if, host_ctxt, 1);

	__vgic_v5_save_apr(kern_hyp_va(cpu_if));
}

arch/arm64/kvm/hyp/nvhe/hyp-main.c:handle___vgic_v5_restore_vmcr_apr() {
	DECLARE_REG(struct vgic_v5_cpu_if *, cpu_if, host_ctxt, 1);

	__vgic_v5_restore_vmcr_apr(kern_hyp_va(cpu_if));
}

[Severity: Critical]
This is a pre-existing issue, but can these handlers corrupt EL2 memory und=
er
pKVM?

Similar to the above, the unvalidated host pointer cpu_if is dereferenced a=
nd
written to by __vgic_v5_save_apr and __vgic_v5_restore_vmcr_apr. An
untrusted host could invoke the corresponding hypercalls with a crafted poi=
nter,
allowing a malicious host to corrupt EL2-private memory.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914174521.8325=
75-1-fuad.tabba@linux.dev?part=3D1
