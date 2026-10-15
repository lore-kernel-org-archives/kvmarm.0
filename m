Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC27E4F799E;
	Thu, 15 Oct 2026 10:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792059385; cv=none; b=EokkxL5ImtbVPn7HSWthmMy+3hTCVMViILyhqg24i7yLDHAPxpCatvRHbUXfiC2yagnKFbNo0ms9aSK0bKXgBhwmtHZ0fv13uwF9wG4UTUEH/F0re/HjeIPs/4WYyLg3Xy2PPjNUFlQDpBGD/NItuzQhmZoBJeVc86yFrhmqA4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792059385; c=relaxed/simple;
	bh=4ceMpPHG/axm7Sg/O1PX8NmO2dqKW+WVLDUlpY56jf8=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=p4mDmsSsA89iQwt8s46cJXE3V63TwnIn42qLv6BFVJLovDCi//nZJ/y4fZHAUpL7PFXP1c/d8hYJFr4gbMOeqyhebPfPwkj+4mQoH3l53bQb4JPyrCFmt0Et0BJOHPIgRuPbjvuiE0QSNOknP/duFswZnc3pXsVWOYc8awS2Dmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XiDZc059; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XiDZc059"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ADDF1F000C6;
	Thu, 15 Oct 2026 10:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792059384;
	bh=qYkTEoKAJ0Rc6lX1Wr/y466XfQVk2zZsukTT702hnfY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XiDZc059Nik5E+eH+24irr0rDp6BD4cPOhHOaQE/o3ABMWicLeO9KZbafHLi2IXWm
	 Es4umXqP51PiKmGRv82zNXb0z/kvYFdMxI4s5eolI3vgvn8VE1Uo/hgUJAMLosZHzj
	 SZm/C/vSzrtAAW0SNdKvSF8MXvYIogcCdehkJ3T6QGVMWs9vFmBUWd7AgnfMh1rtmm
	 AcN77lBxKZRULfmqUfTFnAbIhIcSInFWh44gkWsnjuhAH6LStndh40fH1etnZQ38Pp
	 TroVZMdMIEjiSz4HskYEqO9PCmgMtOmTC0Tl2wnRRRsi3xUgs4Acys0L42sDJF+gqg
	 nqvVky2vBIX5w==
Message-ID: <sashiko-outbox-172647@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/7] KVM: arm64: nv: Move L2->L1 switch on interrupt
 early
Reply-To: sashiko-reviews@lists.linux.dev
To: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, kvm@vger.kernel.org
Cc: "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20261015100539.1011760-2-maz@kernel.org>
References: <20261015100539.1011760-1-maz@kernel.org>
 <20261015100539.1011760-2-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 15 Oct 2026 10:16:23 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] kvm: Outdated comment block in kvm_vgic_flush_hwstate()
--

commit 8603da24ffa95dd560817192077ee16c16570bf2
Author: Marc Zyngier <maz@kernel.org>

KVM: arm64: nv: Move L2->L1 switch on interrupt early

This commit moves the nested request generation for L2->L1 switch on
interrupt and the maintenance interrupt (MI) generation to earlier in
the vCPU entry sequence.

> diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
> index b25303d9919fd..1748e7758681b 100644
> --- a/arch/arm64/kvm/vgic/vgic.c
> +++ b/arch/arm64/kvm/vgic/vgic.c
> @@ -1141,7 +1141,7 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
[ ... ]
>  	 * - Otherwise, do exactly *NOTHING* apart from enabling the virtual
>  	 *   CPU interface. The guest state is already loaded, and we can
>  	 *   carry on with running it.
>  	 *
>  	 * If we have NV, but are not in a nested state, compute the
>  	 * maintenance interrupt state, as it may fire.
>  	 */
>  	if (vgic_state_is_nested(vcpu)) {

[Severity: Low]
This isn't a bug, but should this comment block in kvm_vgic_flush_hwstate()
be updated?

The patch moves the execution of vgic_v3_nested_update_mi() to
kvm_nested_flush_hwstate(), so the note about computing the maintenance
interrupt state here appears to be outdated now.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261015100539.1011=
760-1-maz@kernel.org?part=3D1
