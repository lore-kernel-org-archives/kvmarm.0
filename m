Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A8FE33688A
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 17:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786123027; cv=none; b=nWZzV2gYO4+61YvS3LrFrnPSW5KX7Dzz/QaJnafEQWwks36nWiJHtrtr6GHMty7wCkun29vh34I2GHfI6XzoN0EnO5r33qt743TZVqucaDeBRlJHL07RupdopjjMaEkmK1m9JPQhTPqiJUHp8UnnbjyJWuxoYs9l0oYPFI8jOzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786123027; c=relaxed/simple;
	bh=8hU4iklGM5Qf4s4y9hB4kX6uRvPTpGjFPTyIUVWKrHc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=mjxcGMIOKaB6o17LzQBFSVJs2Rmz5isufZ9ouZKoJdnalJ28b6gF7Ykp1u9JtO4jBsw0bgIWLOycCYyWIdmsKBrwx8vIXZKTmzc/QMFF//rM+KSP9utNHx5hjl2MrGWdxxHYAXsl2jjnMm4rTw2PVD/0h1YOyrqk5Ciz4DfRlXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hRY8O6F9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hRY8O6F9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4B501F000E9;
	Fri,  7 Aug 2026 17:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786123026;
	bh=/d75zqd3UXPS8pTe6p3uaaBCjRJm7C4IKPanVrhi3XY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hRY8O6F9sw8X9jxlwFBJGRVq5cCINfKT+OowLq3S5ARr3VuFwpd5cBum2gvdoaLZj
	 1AwInzY25m/z50KVh4iOJgVlZ6c7MaRgma85movY+8s/ElS5IJ/IkawkX43mpsWA4E
	 J37cPvUCl9u7k1zz44ZRfb8cc5L4Uye0qJgzEHF+QOMxdjpKZCoEcnj3Ugw1YEl1Fl
	 r0odEsaMSzEHixaT4OLd/rASILYtLj1Qfp++i/7XtrXo6AIvdNWzDY+6NcTTnve4Ix
	 OdN/tSFBknxzjgoxjVNwu2d5TPRV1MIkfMpSH1SFNIzYNo/AoK2lzQzepTRCOlqk83
	 VhPaHPPKy/o/Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 13/13] KVM: arm64: Implement HVC interface for ITS
 emulation setup
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sebastian Ene" <sebastianene@google.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260807164322.2970811-15-sebastianene@google.com>
References: <20260807164322.2970811-2-sebastianene@google.com>
 <20260807164322.2970811-15-sebastianene@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 07 Aug 2026 17:17:05 +0000
Message-Id: <20260807171705.B4B501F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:
- [Critical] The `psz` (page size) field read from the untrusted `host_stat=
e` is not validated, allowing a malicious host to bypass ownership transfer=
 of Level 2 ITS tables.
- [High] Calling `on_each_cpu()` with local interrupts disabled causes a sy=
stem-wide deadlock and triggers a kernel warning.
- [High] Allocating memory via `alloc_pages_exact(..., GFP_ATOMIC)` while h=
olding a `raw_spin_lock` violates locking hierarchy and PREEMPT_RT constrai=
nts.
- [High] The error path in `pkvm_its_emulate_setup()` rolls back the `priv_=
state` donation using a hardcoded size of 1 page instead of `priv_num_pages=
`, leaking hypervisor memory.
- [High] An error rollback loop in `pkvm_setup_its_shadow_cmdq()` uses an u=
nsigned 64-bit integer, resulting in an infinite loop.
--

--- Patch [13]: [PATCH v2 13/13] KVM: arm64: Implement HVC interface for IT=
S emulation setup ---
commit b5e04e3693da3938b3ebc14d5487e70eddc3c941
Author: Sebastian Ene <sebastianene@google.com>

KVM: arm64: Implement HVC interface for ITS emulation setup

This patch introduces a new HVC to allow the host to trigger the ITS emulat=
ion
setup. It uses the API in the GIC ITS driver to lock the ITS before pKVM
finalize, switches to a different command queue, and allocates memory to tr=
ack
internal state. The initial MMIO handler is replaced with a full-featured
emulation handler.

> diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> index 5e80da18f3120..9cd562349f249 100644
> --- a/arch/arm64/kvm/pkvm.c
> +++ b/arch/arm64/kvm/pkvm.c
[ ... ]
> @@ -312,8 +312,28 @@ static void __init _kvm_host_prot_finalize(void *arg)
[ ... ]
> +static int pkvm_init_its_emulation(phys_addr_t dev_addr, struct its_host=
_state *host)
> +{
> +	size_t priv_state_sz =3D ITS_PAGES << PAGE_SHIFT;
> +	void *priv_state;
> +	int ret;
> +
> +	priv_state =3D alloc_pages_exact(priv_state_sz, GFP_ATOMIC);

[Severity: High]
Does this allocation violate locking hierarchy constraints?

This function is invoked as a callback from its_emulate_release_locks() in
drivers/irqchip/irq-gic-v3-its.c, which iterates over ITS nodes and calls t=
his
while holding both its_lock and the per-node its->lock raw spinlocks.

On PREEMPT_RT kernels, internal page allocator spinlocks are sleeping
rt_mutexes. Furthermore, GFP_ATOMIC contains __GFP_KSWAPD_RECLAIM, which can
wake kswapd and acquire scheduler runqueue locks while holding a true raw
spinlock.

> +	if (!priv_state)
> +		return -ENOMEM;
[ ... ]
>  static int __init pkvm_drop_host_privileges(void)
>  {
> +	unsigned long its_flags;
>  	int ret =3D 0;
> =20
>  	/*
> @@ -321,8 +341,10 @@ static int __init pkvm_drop_host_privileges(void)
>  	 * once the host stage 2 is installed.
>  	 */
>  	static_branch_enable(&kvm_protected_mode_initialized);
> +
> +	its_emulate_acquire_locks(&its_flags);
>  	on_each_cpu(_kvm_host_prot_finalize, &ret, 1);

[Severity: High]
Can this sequence cause a system-wide deadlock?

its_emulate_acquire_locks() explicitly disables local hardware interrupts v=
ia
raw_spin_lock_irqsave(). Immediately after, on_each_cpu() is called, which
relies on smp_call_function_many() to broadcast an IPI and synchronously wa=
it
for completion.

Waiting for an IPI while local IRQs are disabled is an AB-BA deadlock
scenario.

> -	return ret;
> +	return its_emulate_release_locks(ret, &its_flags, pkvm_init_its_emulati=
on);
>  }

[ ... ]

For the items identified in arch/arm64/kvm/hyp/nvhe/its_emulate.c, the
following observations were made based on the underlying emulation setup:

arch/arm64/kvm/hyp/nvhe/its_emulate.c:pkvm_setup_its_shadow_cmdq() {
    ...
    for (i =3D i - 1; i >=3D 0; i--)
        __pkvm_host_unshare_hyp(start_pfn + i);
}

[Severity: High]
Can this error rollback trigger an infinite loop?

If the loop counter i is declared as an unsigned 64-bit integer, the condit=
ion
i >=3D 0 is universally true. When i wraps around to 0xFFFFFFFFFFFFFFFF, it=
 will
continually execute out-of-bounds __pkvm_host_unshare_hyp() calls instead of
terminating.


arch/arm64/kvm/hyp/nvhe/its_emulate.c:pkvm_host_unmap_last_level() {
    ...
    ret =3D __pkvm_host_donate_hyp(hyp_phys_to_pfn(table_addr), psz >> PAGE=
_SHIFT);
}

[Severity: Critical]
Does this bypass pKVM isolation guarantees by trusting the host-provided pa=
ge
size?

The psz field appears to be read directly from the untrusted host_state
without validation. If a malicious host sets psz to a value strictly less t=
han
PAGE_SIZE (e.g., 0), psz >> PAGE_SHIFT evaluates to 0. The donation will
silently succeed without actually transferring page ownership, allowing the
host to retain ownership and concurrently modify the tables.


arch/arm64/kvm/hyp/nvhe/its_emulate.c:pkvm_its_emulate_setup() {
    ...
err_with_priv:
    WARN_ON(__pkvm_hyp_donate_host(hyp_virt_to_pfn(priv_state), 1));
}

[Severity: High]
Does this error path leak hypervisor memory?

The setup successfully donates priv_num_pages from the host to EL2, but if a
subsequent operation fails, this rollback hardcodes 1 instead of using
priv_num_pages. If priv_num_pages is 2 for ITS setup, the remaining pages a=
re
permanently left in the HYP-owned state.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260807164322.2970=
811-2-sebastianene@google.com?part=3D13
