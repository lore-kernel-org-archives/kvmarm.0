Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DC4D40D579
	for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 07:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781853760; cv=none; b=fUBiG+wpx9ZuNckkeaeTUFiyx5eUnk7FBFM05EpxTtcxtt+TMsFVWcrkGEJXE5JS9EOUyBHpfM8KeO2dcjLfYaAYO8/BuqvyT8UYEbY1Kmg7hq+9u4JT0C0azIKeWgwUdY/Yo4HHDGIIlVoYtK0B+0zRg9tbIP7Fcdq8SK1Yozc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781853760; c=relaxed/simple;
	bh=9usO1gH+G6vRIAHNqrOPaYA56+3tYmHCB4YusFgD+K0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=oxp8b7sUIfwayMPUbI34QeGtxabWh8UyrOwsfvHvNNaQVNwAmbPdKvncIm42TpgkLxuvQcpy7Dk+0a2zvdInQdjK/KNXGI3QgrHPqzzSvY07BbMjvxDzFUZTEcqyZv30Q15yxsNr7AzZcoGpsL8MZdd400Nn4S6sShRj7odi7pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SotWI7nz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SotWI7nz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBAD51F000E9;
	Fri, 19 Jun 2026 07:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781853759;
	bh=1ck5yQeP/pC9EkQTp8la3jZWpeKEi89AUn5pWJE/bBc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SotWI7nz43fiuAayjvzMxa4jeczjHyKaI7LP3tERy79/Jm1bOzp9g+L7O6Lb4lt6c
	 VNjA7m9mBDyL3fon/xA2G+VV7TwUdUeBIO/DPEWi+WQSKCtbx2FijUzBFImKWZDv+E
	 qNiJz/Ahaq4282KpKUyr7zkso8qJ0sNQ6QrEa7zsDpD/XVhgTsu4hTv5/q6cB3+p3B
	 Se/dueDgRfoUufBiT75KPuvEGQm50gCIeMqUR7+YXF083MJx6yZYkoNM+POASU4oua
	 Oxt3T2zJriAHvigZtA0hFekQFoYoj/t/EgW42YRCxdL0EHpE/BmD+CGiVYh3OlYegC
	 tnOfBfDy45lSw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6/8] KVM: arm64: Minimise EL2's exposure of host VGIC
 state during world switch
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <tabba@google.com>
Cc: "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260619070508.802802-7-tabba@google.com>
References: <20260619070508.802802-1-tabba@google.com>
 <20260619070508.802802-7-tabba@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 19 Jun 2026 07:22:38 +0000
Message-Id: <20260619072238.CBAD51F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Missing trust boundary validation for host-provided pointers i=
n several hypercalls (`handle___vgic_v5_save_apr`, `handle___vgic_v5_restor=
e_vmcr_apr`, `handle___kvm_adjust_pc`, `handle___kvm_tlb_flush_vmid_ipa`), =
leading to arbitrary EL2 memory dereference.
--

commit 5fa49efc0aabdcdf925969737165624792f92f6c
Author: Marc Zyngier <maz@kernel.org>
KVM: arm64: Minimise EL2's exposure of host VGIC state during world switch

This patch minimises EL2's exposure of host VGIC state by recovering the ho=
st
vCPU from the supplied cpu_if via container_of() and copying only the
necessary registers. This avoids directly dereferencing the host's
vgic_v3_cpu_if pointer.

> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe=
/hyp-main.c
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c

[ ... ]

>  static void handle___kvm_adjust_pc(struct kvm_cpu_context *host_ctxt)
>  {
>  	DECLARE_REG(struct kvm_vcpu *, vcpu, host_ctxt, 1);
> =20
>  	__kvm_adjust_pc(kern_hyp_va(vcpu));
>  }

[Severity: Critical]
This is a pre-existing issue, but while this patch fixes the trust boundary
for the VGIC v3 aprs hypercalls, other always-on hypercalls like
handle___kvm_adjust_pc() still unconditionally use kern_hyp_va() on
host-provided pointers.

Can a malicious host provide a crafted EL2 linear-map pointer (for example,
the address of a protected VM's vCPU) here? Since kern_hyp_va() is idempote=
nt
for linear-map objects, it leaves the pointer as-is.

This would allow the host to dereference this pointer, potentially modifying
protected guest state via __kvm_adjust_pc() and bypassing pKVM isolation.

[ ... ]

>  static void handle___kvm_tlb_flush_vmid_ipa(struct kvm_cpu_context *host=
_ctxt)
>  {
>  	DECLARE_REG(struct kvm_s2_mmu *, mmu, host_ctxt, 1);
>  	DECLARE_REG(phys_addr_t, ipa, host_ctxt, 2);
>  	DECLARE_REG(int, level, host_ctxt, 3);
> =20
>  	__kvm_tlb_flush_vmid_ipa(kern_hyp_va(mmu), ipa, level);
>  }

[Severity: Critical]
This is a pre-existing issue, but similar to the above, does this allow
the host to pass a crafted mmu pointer?

If kern_hyp_va() leaves an EL2 linear-map pointer untouched, could the host
use this to load arbitrary values into hardware registers like VTTBR_EL2 via
__kvm_tlb_flush_vmid_ipa()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260619070508.8028=
02-1-tabba@google.com?part=3D6
