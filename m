Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08BC42147E6;
	Sat,  1 Aug 2026 13:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785589687; cv=none; b=rNJHPiTpHlQiAkp5qAbK168tu+tjoTifjljhx9QGcPRngyRMppKBeMvdgdZY1oWNvX2Zr2gsNqfypKwXMg7JkRIWYD40csXzc80/TA93uwp6z6pJf/+yYh0Ow2AVAf/R/1Hg8CxLGqUbYJWLwfo1LAAhVRwVRhF7fQagqV8pCZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785589687; c=relaxed/simple;
	bh=zVPqef95qJ1wHLlJOToIFqTX2pCV2k1IFUD18zu6Vp0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=dh98yVA4NWTIaCqdR8pNTStiDdEgzZdYJpmWlvvautcPloiu9C4nIyX2A0RivPSy5lTb4CnTDlz5wKtTwC3GalfD7SndCZvmiudUJajmjgx/E0qaqxWYVbgeikP+7p8g6hQT26gKI0dxC4dbbVOHK2Cc8APug46ehjTluAdirFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S84A19fH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S84A19fH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D81B1F00AC4;
	Sat,  1 Aug 2026 13:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785589685;
	bh=rWRGVR7rR8/V4GXUPqfLW4Iw65bWUbqT8I+oo0WXjWU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=S84A19fHNJ+PYZYfpDo9WUxmJ3BPtMlbV0gQPD8hd4aAG3KBZCq2xlcwWVQLcGOhd
	 jeC78CKmgWuBAytvYp6RzD+DN1NhEa8Ay5kKePlqMEE7V5Gz0Blco7fL/0NhN9YjM3
	 7IfaABCb7mSu1TnAqYxXkkXkkGjx2xmfJca4uWOG4cGKLyvwyF7oxWgsGjgqKL1E1S
	 17JI5OF1bfcZp47NRBUYAFOKaAqxjS40VMGYgUY4JLowvZZdIP0vRWbZK+VuL31jFj
	 JopFaNkqsPZ1DbCQJ75PBRlDy7ubhqfnoJx8XV1n1JYgyn9QkiZ/oZxHyMzhYDkzuw
	 a/IMTHfyIrDGQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/6] KVM: arm64: Remove VM-wide VNCR mapping counter
Reply-To: sashiko-reviews@lists.linux.dev
To: "Marc Zyngier" <maz@kernel.org>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, kvm@vger.kernel.org
In-Reply-To: <20260801124818.366274-2-maz@kernel.org>
References: <20260801124818.366274-1-maz@kernel.org>
 <20260801124818.366274-2-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 01 Aug 2026 13:08:05 +0000
Message-Id: <20260801130805.8D81B1F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The fast-path TLBI handler (`kvm_hyp_handle_tlbi_el2`) fails to in=
validate the `vncr_tlb` for EL2 TLBI instructions when the guest hypervisor=
 has `E2H=3D0` or `TGE=3D0`.
--

--- Patch [1]: [PATCH 1/6] KVM: arm64: Remove VM-wide VNCR mapping counter =
---
commit 47ea057c11b9c9218fbfb24b57715b00bd1a72d7
Author: Marc Zyngier <maz@kernel.org>

KVM: arm64: Remove VM-wide VNCR mapping counter

This commit removes the global VNCR mapping counter used to decide if a VNCR
page is mapped in L0 during TLB invalidations. The tracking was deemed flaw=
ed
and only served as a performance optimization, so it is completely removed.

[ ... ]

> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/swi=
tch.c
> index bbe9cebd3d9d5..c09b1d411c584 100644
> --- a/arch/arm64/kvm/hyp/vhe/switch.c
> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> @@ -427,8 +427,7 @@ static bool kvm_hyp_handle_tlbi_el2(struct kvm_vcpu *=
vcpu, u64 *exit_code)
>  	 * If we have to check for any VNCR mapping being invalidated,
>  	 * go back to the slow path for further processing.
>  	 */
> -	if (vcpu_el2_e2h_is_set(vcpu) && vcpu_el2_tge_is_set(vcpu) &&
> -	    atomic_read(&vcpu->kvm->arch.vncr_map_count))
> +	if (vcpu_el2_e2h_is_set(vcpu) && vcpu_el2_tge_is_set(vcpu))

[Severity: High]
This is a pre-existing issue, but does this fast-path logic inadvertently
skip invalidating the vncr_tlb for EL2 TLBI instructions when E2H=3D0 or
TGE=3D0?

Since kvm_hyp_handle_tlbi_el2() only falls back to the slow path
(returning false) when vcpu_el2_e2h_is_set(vcpu) && vcpu_el2_tge_is_set(vcp=
u)
is true, it seems that for a non-VHE guest hypervisor or a VHE guest hyperv=
isor
preparing an L2 environment (TGE=3D0), this returns true and bypasses the s=
low
path.

The slow path handle_tlbi_el2() in arch/arm64/kvm/sys_regs.c normally calls
kvm_handle_s1e2_tlbi() to handle vncr_tlb invalidation. By bypassing this,
could the vncr_tlb retain stale translations, causing KVM to map the VNCR
fixmap to the wrong guest physical page and corrupting the nested guest's
memory?

>  		return false;
> =20
>  	__kvm_skip_instr(vcpu);
>=20
>  	return true;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260801124818.3662=
74-1-maz@kernel.org?part=3D1
