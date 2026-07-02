Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9F71394E93;
	Thu,  2 Jul 2026 16:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009467; cv=none; b=SXc2mDkuLosZrFfAHBh2hGL2g5H4xrolfljTZaPO4neiebT82aAc08ZGhBYZze242rbNHOySsee8sLCVru5lnLwgtOrFbocDbas/UFH7xa+VCdx15D5hqtE8boFZdhP/ODPjTrFVPsE2M60UTc4JBcmh3zoofmDD/ZxOkiHiSeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009467; c=relaxed/simple;
	bh=p77CmyKLej7ggQ4sdhLRx3abllVKHSNzecfJynKbwMA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=DcoM8mFhBY4+DaDZ1+rRzhxu8XSF2SUaDnQ3fF+S4z8u59Wsgzk45f6COxyrL9eI4GGNdLtawmUoBXa/5HM1wmQsk01fj1eQlWrVklP/tEyfF3cMU80jSKVwxl0NWli+mpL3sAlGkOT0hrAKJxHj1GVfAdnFkUq63KUW4f9l5HU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BiRSer55; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BiRSer55"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A13F1F00A3A;
	Thu,  2 Jul 2026 16:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783009464;
	bh=+b1XUyN1LzBwI26d/4AvBffEZn3dOrPgjnTZt0OB7do=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BiRSer55yzIgNbWb+7Bl3n5+u9kAdskVLKePyjq4uSNfMcAZ3PH+xbKJlD2pFP+W4
	 9mWBlpmuTiXTi1MRtYubfRtQLRjji/q9MvqPIhw3cebq1UREX9jj5muu/uLkRKGbhY
	 oCDla0fa+iTPta9ZlpqU40wqESDeeCvyh/PvrVLGzi+/jGlmEWUuuLPh4NhgESmwrH
	 LI1/XJ+S6TfsBzOvonYE2cimr/kD9rFqX8UCat63u5JUcbUH2OAGve6qOyGmtPiW4G
	 XeD9FKaJ/WJi7q64oSZveF2TxsJFkqWHcVBmJDH/RqxLX7UnEw+3dW6p7xV3jAC58l
	 o4EL2hI28eOPQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 07/28] KVM: arm64: Don't evaluate HCR_EL2.NV on ERET
 fast path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Marc Zyngier" <maz@kernel.org>
Cc: kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260702160248.1377250-8-maz@kernel.org>
References: <20260702160248.1377250-1-maz@kernel.org>
 <20260702160248.1377250-8-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 02 Jul 2026 16:24:23 +0000
Message-Id: <20260702162424.4A13F1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The `kvm_hyp_handle_eret` fast-path incorrectly evaluates an L1 =
hypervisor's virtual `HFGITR_EL2` register to determine if L1's own `ERET` =
should be optimized. Because `is_nested_ctxt(vcpu)` is false for L1, the co=
ndition falls through to check `__vcpu_sys_reg(vcpu, HFGITR_EL2) & HFGITR_E=
L2_ERET`. This virtual register reflects L1's trap configuration for its L2=
 guest, and has no architectural bearing on L1's own execution. If L1 confi=
gures L2's ERETs to trap, KVM will spuriously abort the fast-path for L1's =
local ERETs. (For L2, the check is dead code since `is_nested_ctxt(vcpu)` s=
hort-circuits it).
--

commit b3baa466fe54b91fd60bc2025656ec74bb249ab9
Author: Marc Zyngier <maz@kernel.org>

KVM: arm64: Don't evaluate HCR_EL2.NV on ERET fast path

This commit replaces the check for HCR_EL2.NV in the ERET fast path with
a check for is_nested_ctxt(). This ensures we evaluate if we are actually
running an L2 guest, rather than just checking if HCR_EL2.NV is set.

> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/swi=
tch.c
> index bbe9cebd3d9d5..3b76e0468317b 100644
> --- a/arch/arm64/kvm/hyp/vhe/switch.c
> +++ b/arch/arm64/kvm/hyp/vhe/switch.c

[ ... ]

> @@ -349,8 +349,8 @@ static bool kvm_hyp_handle_eret(struct kvm_vcpu *vcpu=
, u64 *exit_code)
>  	 * Unless the trap has to be forwarded further down the line,
>  	 * of course...
>  	 */
> -	if ((__vcpu_sys_reg(vcpu, HCR_EL2) & HCR_NV) ||
> -	    (__vcpu_sys_reg(vcpu, HFGITR_EL2) & HFGITR_EL2_ERET))
> +	if (is_nested_ctxt(vcpu) ||
> +	    __vcpu_sys_reg(vcpu, HFGITR_EL2) & HFGITR_EL2_ERET)

[Severity: Medium]
Will this apply L1's virtual trap configuration to L1's own execution?

Since is_nested_ctxt(vcpu) is true for L2 guests, this condition will
short-circuit and the HFGITR_EL2 check becomes dead code for L2.

For an L1 guest, is_nested_ctxt(vcpu) is false, causing it to evaluate the
HFGITR_EL2 check. However, this virtual register reflects L1's trap
configuration for its L2 guest and doesn't apply to L1's own execution.

If L1 configures L2's ERETs to trap, won't KVM spuriously abort the
fast-path for L1's local ERETs and incorrectly fall back to the slow path?

>  		return false;
> =20
>  	spsr =3D read_sysreg_el1(SYS_SPSR);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260702160248.1377=
250-1-maz@kernel.org?part=3D7
