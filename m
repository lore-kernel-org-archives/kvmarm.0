Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E7CB39021D
	for <kvmarm@lists.linux.dev>; Mon, 31 Aug 2026 21:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788210898; cv=none; b=qfjVfFDh6FH6eFXfRw2GzXiuRY/+/9O8AeWOGv7xOi+b5W5PAh2h3f9hQa88WHF4Z7tJg14Ckg6OOhTmdIOBkLRBMO4jun6E4eeQF+P2MdB68MQKYVt9giS+gDcOcPWDOIGp6q+I/VNWKnWyR3DYiSUikAczA2Sf3ybYJ+QEBbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788210898; c=relaxed/simple;
	bh=Do0FATuur9F6zuX0lrSA1H2ftzNv4CxNC6PC3i5Zs5Y=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=KIQykzTYoVyofVhU6bBwSP0SZBGaeEjf1xO7ZruZ+SC3+aa6yFQQBcIlHpJ5gthfQSnAxx1Bn4vjFJnWDi3b/9TRAprbCbHzyZrja0IIl9/0JwJvoI82HTEWOeh/59vULJSl5Gttw2XPPx6aMKMnTmgqy069bEvxTYQKKiF7Yrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YMy6+1RO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YMy6+1RO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AE451F00A3D;
	Mon, 31 Aug 2026 21:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788210897;
	bh=HbWdAvJL/YM/GPVxdgt+y77taCw7FfI6B59UBk54oIk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YMy6+1ROQ2Epxpy5PmMo4plqBLvLjGUglNoa14APUYcsozeeYVRYNqNZvik1niLYU
	 qUqjneJIVAopk8N1LeY7u3RXMdyWe3KfU/bYgs8FpoaaMMPhrx+ToOZJDv/p+XL6gh
	 HAbhMTtFePOpt05mVYJNhyxKxzb9ONxQDHj8MmX423+E+1sHSZaVpkZ/Y6YwosD6ZK
	 YeUoMlCSaHFaVGkJRneGEUZhmAWNC5c1JCvA7l4eszqntnb9UZMCyrcB8XP+hj9WkQ
	 4QOoa1VppKL6MubztjW9v5BUIxt+JoIb4BYGXHZTBTxtOxjveGK/TmhTWBAIxLUwL5
	 F+M4ei8lVaSyg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 09/17] KVM: arm64: Handle PSCI calls for protected VMs
 at EL2
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260831163421.272420-10-fuad.tabba@linux.dev>
References: <20260831163421.272420-1-fuad.tabba@linux.dev>
 <20260831163421.272420-10-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 31 Aug 2026 21:14:56 +0000
Message-Id: <20260831211457.1AE451F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Malicious host can hijack guest execution flow via CPU_ON TOCTOU r=
ace caused by stale reset_state.reset flag.
--

commit f4181bbdd19d9d3775a4f479d2c7c70dc5c753b8
Author: Fuad Tabba <fuad.tabba@linux.dev>

KVM: arm64: Handle PSCI calls for protected VMs at EL2

This patch implements PSCI 1.1 for protected VMs in EL2, handling power sta=
te
transitions (CPU_ON, CPU_OFF, AFFINITY_INFO) within the hypervisor, while
keeping non-protected VMs unchanged. It defines protected vCPU power states
and synchronizes racing transitions via cmpxchg and release/acquire barrier=
s.

> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe=
/hyp-main.c
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
[ ... ]
> @@ -37,27 +40,103 @@ typedef void (*hyp_entry_exit_handler_fn)(struct pkv=
m_hyp_vcpu *);
> =20
>  static void __maybe_unused handle_pvm_entry_hvc64(struct pkvm_hyp_vcpu *=
hyp_vcpu)
>  {
[ ... ]
> +			prev =3D cmpxchg_relaxed(&target_vcpu->power_state,
> +					       PSCI_0_2_AFFINITY_LEVEL_ON_PENDING,
> +					       PSCI_0_2_AFFINITY_LEVEL_OFF);
> +			switch (prev) {
> +			case PSCI_0_2_AFFINITY_LEVEL_ON_PENDING:
> +				/*
> +				 * Leave reset_state.reset set: clearing it
> +				 * races a concurrent CPU_ON's re-publish and
> +				 * wedges the target at ON_PENDING. The stale
> +				 * pc/r0/be are the guest's own.
> +				 */
> +				ret =3D PSCI_RET_INTERNAL_FAILURE;
> +				break;

[Severity: High]
Does this rollback logic allow a malicious host to hijack guest execution f=
low
by exploiting a TOCTOU race?

If guest vCPU A calls CPU_ON for target T with PC1, the hypervisor sets
power_state =3D ON_PENDING. If the host then rejects the call, this rollback
logic resets power_state to OFF but intentionally leaves reset_state.reset =
=3D
true and pc =3D PC1.

If guest vCPU B then calls CPU_ON for target T with PC2, pvm_psci_vcpu_on()
sets power_state =3D ON_PENDING. Before the hypervisor writes PC2, a malici=
ous
host could concurrently issue KVM_RUN for target T on another CPU.

Because the stale reset flag is still true from the previous failure, targe=
t T
will immediately boot using the stale PC1 instead of PC2, redirecting the
guest control flow.

Should this rollback clear the reset state, or is there another way to prev=
ent
the host from forcing a boot with a stale PC?

[ ... ]
> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkv=
m.c
> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
[ ... ]
> +int pkvm_reset_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
> +{
> +	struct vcpu_reset_state *reset_state =3D &hyp_vcpu->vcpu.arch.reset_sta=
te;
> +	int prev;
> +
> +	/*
> +	 * Pairs with smp_store_release(&reset_state->reset, true) in
> +	 * pvm_psci_vcpu_on(). The acquire must precede the cmpxchg: reversed, a
> +	 * winning cmpxchg with a false acquire would leave power_state =3D=3D =
ON
> +	 * with the reset skipped.
> +	 */
> +	if (!smp_load_acquire(&reset_state->reset))
> +		return -ECANCELED;

[Severity: High]
Can the host force pkvm_reset_vcpu() to succeed prematurely here?

Since the rollback in handle_pvm_entry_hvc64() leaves reset_state.reset
set to true, if a new CPU_ON sets power_state to ON_PENDING, a host-control=
led
KVM_RUN can enter this function and pass this smp_load_acquire() check befo=
re
the new PC is actually written by pvm_psci_vcpu_on().

[ ... ]
> +static bool pvm_psci_vcpu_on(struct pkvm_hyp_vcpu *hyp_vcpu)
> +{
[ ... ]
> +	/*
> +	 * vCPUs race to power on the same target. Relaxed: reset_state
> +	 * is published by the release on reset_state.reset below.
> +	 */
> +	power_state =3D cmpxchg_relaxed(&target->power_state,
> +				      PSCI_0_2_AFFINITY_LEVEL_OFF,
> +				      PSCI_0_2_AFFINITY_LEVEL_ON_PENDING);

[Severity: High]
Does setting power_state to ON_PENDING here open a TOCTOU window?

If the target already has a stale reset_state.reset =3D=3D true from a prev=
iously
failed CPU_ON attempt, making the target ON_PENDING here allows the host to
schedule the target and boot it before the new PC/r0/be states are updated
below.

> +	switch (power_state) {
[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260831163421.2724=
20-1-fuad.tabba@linux.dev?part=3D9
