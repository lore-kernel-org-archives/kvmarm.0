Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 069E852FE27
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 15:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790868914; cv=none; b=eDY3zJJArdtbAM8dYhij1UAsuu7sDXcyiWaTAuKJj1Zaifr+hTo/fjR7fmxSsLLPnVPAzdB69BuA8HJqBY++/0GtPN3MabRpoySLlk0Yk4pQVzoiU9ksujsN6tyD/ZB0erp0NCVtV+asg/Pg3iiTiY0289qWbUwRf5QQUuzML4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790868914; c=relaxed/simple;
	bh=J8SPXMxNSOFyJ12yTZ000L4ggUtP99MIWpjJjVBEfvc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=AP0jPLILeykwviwAKgpQt8JAwFPKPav8PRBSfqqC7ayeh3HWKoDDZo1fO9RgAEaR5YPD0HLDFOxqYmWyEyEgXUvrug8Y9UCiwh/9srTXoTVSC++shQ1ggbW8VL315PgBMFyk1uC9jkRgduMy0OoQzC0i+U7fPezd2IjDA6G9NIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gL9mlzcX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gL9mlzcX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46EFA1F000FF;
	Thu,  1 Oct 2026 15:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790868912;
	bh=8RtmO2USYkU2p9s8Ji4Zr67f9baaK6FX+xN8ZCaatuw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gL9mlzcXhrxlVWCMekcqOQy6swzcWq6+HsM2oTeKDVvUn01Wk0OjmgiVUgMD3clZX
	 g9BacAG1KkpkNhPlU5J0AgsMSPymPksBWE5JjTdxtJ8bVEDzR50noXWvxP07K91wje
	 ZetOfb0A43/801brSXmRtMGsR0jNNuJrhEEDEeZec/fZjrTHPIIUNJv6Ven/MwuOfA
	 7IjWQNpwPKSlPiRU82rM2NHXHMxxTWGB3sw8jEe243T+VRj8TvqNV/tUEoiXoiTKZY
	 no3z4rsGW7TncZSCd8rlmjYNIJwxE2ICOrUttGlEcQIRbclTHZfgghRl1LeKsKyRO5
	 +KcnlZj7CJGSg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 11/18] KVM: arm64: Filter out non-kernel addresses in
 kern_hyp_va
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vincent Donnefort" <vdonnefort@google.com>
Cc: "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20261001142849.3367614-12-vdonnefort@google.com>
References: <20261001142849.3367614-1-vdonnefort@google.com>
 <20261001142849.3367614-12-vdonnefort@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 01 Oct 2026 15:35:11 +0000
Message-Id: <20261001153512.46EFA1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] mm: EL2 memory corruption via kern_hyp_va bypass for non-TTBR1=
 addresses
--

commit 8768ff7b59b5b3eb8674eb929fc20e711a216dbf
Author: Vincent Donnefort <vdonnefort@google.com>

KVM: arm64: Filter out non-kernel addresses in kern_hyp_va

kern_hyp_va() is idempotent for the hypervisor linear space, which is handy
for nVHE hypervisor callers. This commit adds a check based on PAGE_OFFSET
to filter out non-kernel addresses, extending idempotence to the hypervisor
private range.

> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kv=
m_mmu.h
> index 57f65257bb56d..04d9f59db976f 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -128,6 +128,9 @@ static __always_inline unsigned long __kern_hyp_va(un=
signed long v)
>   * replace the instructions with nops.
>   */
>  #ifndef __KVM_VHE_HYPERVISOR__
> +	if (is_protected_kvm_enabled() && !is_ttbr1_addr(v))
> +		return v;
> +

[Severity: Critical]
Does this bypass address translation for untrusted host-provided pointers
when they are not TTBR1 addresses?

While this makes kern_hyp_va() idempotent for EL2 private addresses,
kern_hyp_va_host() also uses __kern_hyp_va() on unvalidated host arguments.

For example, if the host issues a hypercall like __vgic_v5_save_apr and
passes an EL2 private address:

arch/arm64/kvm/hyp/nvhe/hyp-main.c:handle___vgic_v5_save_apr() {
    ...
    __vgic_v5_save_apr(kern_hyp_va_host(cpu_if));
    ...
}

Because is_ttbr1_addr(v) is false, __kern_hyp_va() will return the EL2
private address unmodified. The handler then dereferences it:

arch/arm64/kvm/hyp/vgic-v5-sr.c:__vgic_v5_save_apr() {
    ...
    cpu_if->vgic_apr =3D read_sysreg_s(SYS_ICH_APR_EL2);
    ...
}

Could this regression allow an untrusted host (EL1) to execute an arbitrary
write into EL2 private memory and break the pKVM trust boundary?

>  	asm volatile(ALTERNATIVE_CB("and %0, %0, #1\n"         /* mask with va_=
mask */
>  				    "ror %0, %0, #1\n"         /* rotate to the first tag bit */
>  				    "add %0, %0, #0\n"         /* insert the low 12 bits of the tag =
*/

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261001142849.3367=
614-1-vdonnefort@google.com?part=3D11
