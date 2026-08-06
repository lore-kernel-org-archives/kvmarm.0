Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B5983F39FF;
	Thu,  6 Aug 2026 09:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786008947; cv=none; b=h3RXzr/SDLl0C+V8fpKaIjizk9t59UQQAOBAak60FS7Wm4COPFElTUl3jVSlTui1z8IIvESUCEahbjRjLlhwvKUAc8K+/4mgTLR+538FSFbGIsXSPhlMl/ps68TpJZd25Jcz3eMuDXkmewjP6mEkSs/e3YOs+H0jPRZpHTRkW5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786008947; c=relaxed/simple;
	bh=z+rifGlxQke73ntyqLfn2gB1OiNx7oHsKYO5oqJQcJ4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=XVrQaUbD/8ThS8YP+xxSWw4yry7S4Mtjcz2KtHk6HgIqNZ1vkPW0F6sHwwEa29K09/wC21jkDyUlQAF/EaBTYrcArq7RUW0JXpwKYcFO/cmbUotIEkHddvxtmPhpdfuvyNXbn6/H/OTPHBuA1M0ekvYMD9UdYTu6AwWCjK1odJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aC52JX85; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aC52JX85"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AEDE1F000E9;
	Thu,  6 Aug 2026 09:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786008942;
	bh=gk7XrxmnUheJUTn8OFUHhpRZurHsG/Pjki16tEglL2M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aC52JX859PL+yO1O6M0lLA6l7kjwcXLRBVQFrxHGX52TEVfj+DRRcKUGzV827BhXG
	 L6GYIKijDbyk5ynQZXvr1OduL4eHkKfMRXya0/uQeWlmDWGRu06uOthAWhu8Gb/Qj0
	 DJ1fb4+67C7VlW0TM/Y+28XoNhQEa250sit2/yAAOgN4sp2jbSmGiqMbRAGGMacBjn
	 STGKKezp/trkBxIbsbF/yHRAEMTCoZh848ZvVdr6Yqpt/5trsg3jAA6EbrUsE+c7b1
	 DndQtwvlcp13zrSHp+F5zrSTs5jZw5o5uOZY7pO3PoW36g7iSoJh9rEXxbNPMzAf5v
	 snAC8aW5EazIw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/8] KVM: arm64: Remove VM-wide VNCR mapping counter
Reply-To: sashiko-reviews@lists.linux.dev
To: "Marc Zyngier" <maz@kernel.org>
Cc: "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, kvm@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260806091026.620700-2-maz@kernel.org>
References: <20260806091026.620700-1-maz@kernel.org>
 <20260806091026.620700-2-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 06 Aug 2026 09:35:41 +0000
Message-Id: <20260806093541.9AEDE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] S1E2 TLBI instructions fail to invalidate the VNCR pseudo-TLB when=
 TGE=3D0 or E2H=3D0.
- [High] Hardcoded `TR_EL20` in `kvm_translate_vncr` misinterprets `TCR_EL2=
` for non-VHE guests.
--

--- Patch [1]: [PATCH v2 1/8] KVM: arm64: Remove VM-wide VNCR mapping count=
er ---
commit 9a09630623c9341a08c8ecea540015307bde098c
Author: Marc Zyngier <maz@kernel.org>
Subject: KVM: arm64: Remove VM-wide VNCR mapping counter

The global VNCR mapping counter is used to decide whether an L1
provided VNCR page is mapped in L0 on any CPU at the point of
dealing with a TLB invalidation. It is incremented when a mapping
is made in the fixmap, and decremented when unmapped.

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
This is a pre-existing issue, but does this condition incorrectly limit the
slow-path fallback to only E2H=3D1 and TGE=3D1 contexts?

If a non-VHE guest (E2H=3D0) or a VHE guest running a VM (TGE=3D0) executes=
 an
S1E2 TLBI instruction (e.g. TLBI VAE2), the fast-path handler
kvm_hyp_handle_tlbi_el2() performs the hardware TLBI but will evaluate the
above condition as false.

It will then execute __kvm_skip_instr() and return true, bypassing the EL1
slow-path handler entirely.

Since the EL1 handler is exclusively responsible for invalidating the
software VNCR pseudo-TLB, won't this leave stale mappings in the pseudo-TLB
when a guest hypervisor invalidates its EL2 mappings?

>  		return false;
> =20
>  	__kvm_skip_instr(vcpu);

> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index d9486010835a7..983ba0adaf4e6 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c

[ ... ]

[Severity: High]
This is also a pre-existing issue in this file within kvm_translate_vncr(),
where the TR_EL20 translation regime is hardcoded:

kvm_translate_vncr() {
    ...
    vt->wi =3D (struct s1_walk_info) {
        .regime =3D TR_EL20,
        .as_el0 =3D false,
        .pan    =3D false,
    };
    ...
}

Could this misinterpret TCR_EL2 for non-VHE guests?

When setup_s1_walk() parses TCR_EL2 for the TR_EL20 regime, it assumes the
E2H=3D1 register layout (reading TBI from bit 37 and PS from bits 34:32).

However, an untrusted nested guest hypervisor with E2H=3D0 programs TCR_EL2
using the standard E2H=3D0 layout, where TBI is at bit 20 and PS is at bits
18:16.

Won't this cause KVM to use garbage bits to configure the walk, leading to
spurious translation faults or using the wrong physical address size?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260806091026.6207=
00-1-maz@kernel.org?part=3D1
