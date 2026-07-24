Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C68427FAF;
	Fri, 24 Jul 2026 11:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784893180; cv=none; b=m2/JcI4t+plYUhTuPcB0MpYLBQBGKJzKyaWdIPnGvTvMEOpcqPDkCBn/dt2YNvo1tVb9QBj7X8TH4bEtKz+tGaV5INvrFAoSRp9DDpNU9ea6Vm90xpqTbOsEgVmzrezLMspUSwXKdRlkunKkFgHhAfGA5z0pg6EhzT7pZLBidQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784893180; c=relaxed/simple;
	bh=0XEykLSLl2cDLJtHL8XXGmkKRiX0q6TH02c65z1zkow=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=dAhu5H2NTG0nd8Yn7Ed6QgAASK5zwhLEZ4Rr2VZrHw5we4fKjZPwl+5Kh12Hkgve6/IeY8G2exr4VNHm15uWn/ZPXPaaiqan7ScRGcuxXgQtnDlwk0v8FI6EZbRbU58BuTTX2pinivBAi+tQRuNNUjnrusCVybBlQXcrWsLqY9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CBFRfaPN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CBFRfaPN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01D4A1F000E9;
	Fri, 24 Jul 2026 11:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784893173;
	bh=wkmGMRZs+HBCNAkrr8Kxji0vhL0lSdUIHtli4KbEcm8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CBFRfaPNpXnPyTchEmVH5+W3nUQ5vYjsti+MxJDGSDJ8LS5hczWDEiVys06YTF7PN
	 iZ3K/L1ZKnhm3I4hWa8R/Vc/YQ0zaj5315O2MP2y0QspL+FuxUusjsgSlOKCJ85qzf
	 FXfAaZnwtLdOtsvCbqPo4+gclC2pdj4jWTNjZoIC7riF2rRf3KaO1qaDUEEdRfEa2h
	 KjH7YTzvri4xwONIm6ptaW3iVsHqVsqbGIzfd4Puyf374I8MCgwer0DioFJQMrKkyh
	 IllbYZyH1YDHd59XGhqHESFD9gskDwS3q/KwxY8ewhxT5EehQmlSuwvL3ziUv/2qsp
	 KgjaAJKrRPgTg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 26/48] KVM: arm64: gic: Introduce set_pending_state()
 to irq_op
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org
In-Reply-To: <20260724104819.1296803-27-sascha.bischoff@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
 <20260724104819.1296803-27-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 24 Jul 2026 11:39:32 +0000
Message-Id: <20260724113933.01D4A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Incomplete state mirroring: hardware pending state desynchronizes =
from VGIC shadow state on guest MMIO/ITS writes.
- [Medium] Userspace-reachable WARN_ON_ONCE when set_pending_state fails, c=
ausing potential Denial of Service.
--

--- Patch [26]: [PATCH v4 26/48] KVM: arm64: gic: Introduce set_pending_sta=
te() to irq_op ---
commit f6a8b8f38eb780090a64d051bdb9d419dcf75e26
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: arm64: gic: Introduce set_pending_state() to irq_op

This patch introduces a set_pending_state() function pointer to irq_ops.
This allows the VGIC to communicate pending state directly to hardware for
cases where hardware manages parts of the interrupt lifecycle, like GICv5.
It wires this new callback into kvm_vgic_inject_irq().

> The intent is for this to be used after the VGIC shadow
> pending state has changed, allowing the backend to mirror the updated
> state into hardware.
>
> This new function is plumbed into kvm_vgic_inject_irq(), and is only
> called if irq_ops are provided and this function pointer is explicitly
> set.

[Severity: High]
If the intent is to mirror the state after the VGIC shadow pending state
has changed, should this also be wired up for guest MMIO writes and ITS
commands?

For example, when a guest writes to ISPENDR or ICPENDR, the shadow state is
updated in arch/arm64/kvm/vgic/vgic-mmio.c:__set_pending() and
__clear_pending(), but set_pending_state() is not called.

Similarly, in arch/arm64/kvm/vgic/vgic-its.c:vgic_its_cmd_handle_clear(),
the ITS CLEAR command updates the LPI pending state without notifying the
hardware.

Could this omission cause the hardware pending state to become desynchroniz=
ed
from the VGIC shadow state, leading to missed or spurious interrupts?

> diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
> index 169a8664322d0..023792c28fc5c 100644
> --- a/arch/arm64/kvm/vgic/vgic.c
> +++ b/arch/arm64/kvm/vgic/vgic.c
> @@ -563,6 +563,9 @@ int kvm_vgic_inject_irq(struct kvm *kvm, struct kvm_v=
cpu *vcpu,
>  	else
>  		irq->pending_latch =3D true;
> =20
> +	if (irq->ops && irq->ops->set_pending_state)
> +		WARN_ON_ONCE(!irq->ops->set_pending_state(vcpu, irq));

[Severity: Medium]
Can a guest or unprivileged host-userspace trigger this warning?

Since kvm_vgic_inject_irq() is reachable via userspace injection
(e.g., KVM_IRQ_LINE) or guest actions, if an adversary can create
conditions that cause set_pending_state() to fail, they could trigger
this WARN_ON_ONCE. This would violate the KVM guideline against
user-reachable warnings.

Could this be replaced with a pr_warn_once() or handled by returning
an error code?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260724104819.1296=
803-1-sascha.bischoff@arm.com?part=3D26
