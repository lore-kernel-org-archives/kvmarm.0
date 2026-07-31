Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 166B63C3C15
	for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 18:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785523137; cv=none; b=WZgS423W+Qdim1uHbm80zKVelbR3gL/VqpdHKcLhcabPlzBh9Z+VhZ/Lu5bBlbz5MtmCyc0Iit0ykDayVlnuMPpGlHMkdRw2wd+SBg+pxSvp9GTP6AqtIfXT0CX9P4c1VeTL9eHrkJdQhHDLVysvsqQzaPU9dWg4OntRIPo2gT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785523137; c=relaxed/simple;
	bh=eSlCavNVWvK6Is3GaQmXrmH5B2QZKGczv6NlQ3kbAzA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=R+/YDd2NPMC8f0i9Cs+23OeCQbtwfaMj3fo4HjZvle2avrN6J1gUFBjLcbUIwkfKKqBkH8xV6LzOHDynPXiple/qdRltluN5VvieKq96Ry5GWnIvfueSUyn6omq+F5Xci5DxOcInNzM5JY1toGIctD+5oRSUnokMYawwEmEk/gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yw8ZwAQI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yw8ZwAQI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5817F1F00ACA;
	Fri, 31 Jul 2026 18:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785523132;
	bh=b/hO1Eg+BC9JLeLk4hJV0swfHpvMLK7TIFJm6TuU0bE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Yw8ZwAQIoRDg9oN+cLZA9XpiNBH8KEBYZ7UKDlWDo8msXf3GDBEOlNTKKjcxusUa9
	 ZOKB6jV83TXVkmn5YToudYGmnEVbrg4NQzVzSYu4S2kchKJF1ECSxa3f3Vl67avJqk
	 /tKKdGHTRWkB0FIIG1oSCL6uT27aIPz5KosmJt2+z9IhPkQRXbulgwrcFF9DDt5736
	 ekPogoQk6OFS2U7T2+J51mxwkBni9e5DO5cB0yZ9s1XgDCSZQj6MwF3FqJiDjnyO24
	 J/n03G9pFXx7ROupGs8DP/anOWZ8zYCTe45xpnpaq0pXUjl8hchrKKyMCdOS3y59Rl
	 jdCNW6vDCz6MA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] KVM: arm64: Drop %pB on nVHE panic when stage-2 is
 active
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vincent Donnefort" <vdonnefort@google.com>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260731182231.1277064-1-vdonnefort@google.com>
References: <20260731182231.1277064-1-vdonnefort@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 31 Jul 2026 18:38:51 +0000
Message-Id: <20260731183852.5817F1F00ACA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The patch fixes a stage-2 fault deadlock in `print_nvhe_hyp_panic(=
)` by removing the `%pB` modifier, but misses `kvm_nvhe_dump_backtrace_entr=
y()` and `dump_kernel_instr()` which both access lazily-mapped host memory =
later in the exact same panic path, causing the same deadlock.
--

--- Patch [1]: [PATCH] KVM: arm64: Drop %pB on nVHE panic when stage-2 is a=
ctive ---
commit cbd94a7b340a7dc4be01336a040cb8c3d9690ab4
Author: Vincent Donnefort <vdonnefort@google.com>

KVM: arm64: Drop %pB on nVHE panic when stage-2 is active

This commit removes the %pB format specifier from print_nvhe_hyp_panic()
when running in protected KVM mode without stage-2 panic disabling. This
prevents a deadlock caused by a stage-2 fault when accessing unmapped
kallsyms memory while the host stage-2 lock is held.

> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index 54aedf93c78b6..2e1951c215ae8 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -509,8 +509,12 @@ void handle_exit_early(struct kvm_vcpu *vcpu, int ex=
ception_index)
> =20
>  static void print_nvhe_hyp_panic(const char *name, u64 panic_addr)
>  {
> -	kvm_err("nVHE hyp %s at: [<%016llx>] %pB!\n", name, panic_addr,
> -		(void *)(panic_addr + kaslr_offset()));
> +	/* Kallsyms might not be mapped in the host stage-2 */
> +	if (is_protected_kvm_enabled() && !IS_ENABLED(CONFIG_PKVM_DISABLE_STAGE=
2_ON_PANIC))
> +		kvm_err("nVHE hyp %s at: %016llx!\n", name, panic_addr);
> +	else
> +		kvm_err("nVHE hyp %s at: [<%016llx>] %pB!\n", name, panic_addr,
> +			(void *)(panic_addr + kaslr_offset()));
>  }

[Severity: High]
This is a pre-existing issue, but does this same deadlock still trigger
later in the panic path?

While this fixes the memory access in print_nvhe_hyp_panic(), the handler
nvhe_hyp_panic_handler() subsequently calls kvm_nvhe_dump_backtrace() and
dump_kernel_instr().

In arch/arm64/kvm/stacktrace.c:kvm_nvhe_dump_backtrace_entry(), there is
another use of %pB:

	kvm_err(" [<%016lx>] %pB\n", where, (void *)(where + kaslr_offset()));

Additionally, nvhe_hyp_panic_handler() calls dump_kernel_instr() which also
reads the faulting instruction directly from memory in
arch/arm64/kernel/traps.c:

	bad =3D aarch64_insn_read(&((u32 *)kaddr)[i], &val);

Will both of these also access lazily-mapped host stage-2 memory, trigger
a stage-2 data abort, and deadlock when trying to re-acquire host_mmu.lock?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260731182231.1277=
064-1-vdonnefort@google.com?part=3D1
