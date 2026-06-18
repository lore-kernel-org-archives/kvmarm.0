Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D64503C4557
	for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 09:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781774544; cv=none; b=VyzgxKt/BeUSQTpyJIbNftIG8Df5CtVkLd40H0JioOt9xIcyGPbXkGsNuJFD2qTOYL+M/fH6yl4Zg0yHhJoU/ZKqDkqbn530efUzbaUCnTQgQORti3fCU+507TYoOrn1TpRLJy0dlY42444ihDRWk381417kH5Tpukj21Esm4R4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781774544; c=relaxed/simple;
	bh=nK+RwVsXHkH1pfp9wWFhmTyXxg7D9tKAkcONTBnJEfE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=AUVO6x+sToiEwOx58ULHHOmNvJwBzBUhN2o0fTnoXu4gxTYU7cpCqcUFdrWWOXV4rZsoUogJFJyI0nK+sr5n4oDSE/zY93lIiazkCByhLaX93dkO1uvQHJjBfekzrXDxtITVgZ4XzLfkBXJtZHdt4Wg3baGcIUNgN5eW+H3WoBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DYbRXlue; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DYbRXlue"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45D231F00A3A;
	Thu, 18 Jun 2026 09:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781774543;
	bh=tlnachJIsRe65mf0xJdjIt8iHwfGk36JLI4XMbvdYE8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DYbRXlue4twAoLbGYOuGu8139nk9m5C4h038jtUIgBCbBvLnEZ9D4/jsNwhjQymRG
	 GqRhmexJ+ljYizb6eG1UhcgsI7U5eaB9bytNQGgnJBatiqIsUwJQLoHghuAJ0RpDup
	 MBiqF1KnC4+zPawAsXWZZSHhpAWC8paImNxQH0E+bvNZ/oJeVflT9iqm+5NhAObEGh
	 ly5bZFgxq5Su6Pn0orc9ivjDfXJjnTz3v52dapDeXyUoIexBoU9Rx6xSViUqO1BfNT
	 1uQwXzVTHMTtxU/wm0wfbl2TtsZoMMTlkYM7I4ut9F5+Lp0ITNtVOkUM9Z8cgLxjdu
	 Fpga24JDJzaQQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/3] KVM: arm64: Drop redundant READ_ONCE() in
 pkvm_hyp_vm_is_created()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <tabba@google.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260618090128.3913688-4-tabba@google.com>
References: <20260618090128.3913688-1-tabba@google.com>
 <20260618090128.3913688-4-tabba@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 18 Jun 2026 09:22:22 +0000
Message-Id: <20260618092223.45D231F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Teardown sequence inversion in `kvm_arch_destroy_vm()` causes memo=
ry leak of protected guest pages.
--

commit 3c4352fb45fd315836f7f7aa2ad63af580a902d7
Author: Fuad Tabba <tabba@google.com>

KVM: arm64: Drop redundant READ_ONCE() in pkvm_hyp_vm_is_created()

This patch removes an unnecessary READ_ONCE() around the read of
kvm->arch.pkvm.is_created. The read is already serialised against concurrent
writers by either config_lock, slots_lock, or the teardown VM lifecycle.

> diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> index 67b90a58fbea2..008766273912e 100644
> --- a/arch/arm64/kvm/pkvm.c
> +++ b/arch/arm64/kvm/pkvm.c
> @@ -185,7 +185,11 @@ static int __pkvm_create_hyp_vm(struct kvm *kvm)
> =20
>  bool pkvm_hyp_vm_is_created(struct kvm *kvm)
>  {
> -	return READ_ONCE(kvm->arch.pkvm.is_created);
> +	/*
> +	 * Serialised by config_lock/slots_lock, or by VM lifecycle at
> +	 * teardown, so a plain read suffices.
> +	 */

[Severity: High]
This isn't a bug introduced by this patch, but since the comment mentions t=
he
teardown lifecycle, is there a teardown sequence inversion in
kvm_arch_destroy_vm() that leaks protected guest pages?

Looking at kvm_arch_destroy_vm() in arch/arm64/kvm/arm.c, it calls
pkvm_destroy_hyp_vm() before kvm_uninit_stage2_mmu().

Because kvm_uninit_stage2_mmu() hasn't run yet, __pkvm_start_teardown_vm()
is not invoked. This causes the __pkvm_finalize_teardown_vm hypercall inside
pkvm_destroy_hyp_vm() to be rejected by the hypervisor, and the host clears
the handle via __pkvm_destroy_hyp_vm():

arch/arm64/kvm/pkvm.c:__pkvm_destroy_hyp_vm() {
    ...
    kvm->arch.pkvm.handle =3D 0;
}

Subsequently, when kvm_uninit_stage2_mmu() does run, it eventually calls
pkvm_pgtable_stage2_destroy_range(), which returns early due to the cleared
handle:

arch/arm64/kvm/pkvm.c:pkvm_pgtable_stage2_destroy_range() {
    if (!handle)
        return;
    ...
}

Does this sequence skip page reclamation and unsharing, permanently leaking
all memory donated to the protected guest?

> +	return kvm->arch.pkvm.is_created;
>  }
> =20
>  int pkvm_create_hyp_vm(struct kvm *kvm)

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260618090128.3913=
688-1-tabba@google.com?part=3D3
