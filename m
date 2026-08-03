Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF3053655CA
	for <kvmarm@lists.linux.dev>; Mon,  3 Aug 2026 09:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785750619; cv=none; b=dbirREJMJEzs/ZNGUzeNh804/K+Jbp+4rbgpup309/jDh08rCgoUXxRzfXUjEM5OEUZRcM/B+0nRB+l9fdrQkFgXHinI0szOUfLJ4bYMnoA6+RI+zDRczvwo7HnJXLRieZcvIvvtbx9HeqmbIFkekoxJ/RcoH3aHpIQN3WI1fvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785750619; c=relaxed/simple;
	bh=GABTDUc3etktVSEpL8HchQbjC4AyRVM/if7LGg+XL+A=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=rqJutHii/gcZ7PeGSz2FHDoSeiN8MM5k0mD5Kwch1HegQty571DVfnhebvAStqWbeGbakBGrsbWeF//nyiPJaUn+MG3QaB5i4x5zQ4fo+Kydg0RfvWlJbSnHXHDwnBlSTF4yj2OqGOl8yu19GxKxrZ9wRA4DVsWSz65+V2G+j10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oiVbyIgj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oiVbyIgj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A9D01F000E9;
	Mon,  3 Aug 2026 09:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785750617;
	bh=E0hnqiO0GefmHeqcOZZlUVCpTwlxn4XxfGDWNGHe0x8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oiVbyIgjHwYklVKFcBoLWlSyocOwJUm0WQZDiAOBSBcAEidMaPWv9HEUcmcrhiK9e
	 ljqk7j94Q02xowe0NT82nnUn4/H32DwKiTMRG2w9mpm7jkFG7rXXRDEra/CUS86mp7
	 kaLjVAmbSKuU9TVsl0Tpe2A2BNnZDd2ALKLKp9EcPpbT5DPxNKCB2rGOlfKsLZNCBv
	 Ts6OG4bmnUAMIH8x/oKESESp/65JfzdTO3y9S+F7TcimQ3zOecujKGDuwpGv1faxw8
	 Lgp77GlmgkkVP5VYkr2Kh2ymO9xF5JXTVeGg8Elu5SHhGrGl5jECifrrQe5JUbFsdl
	 A6Pk+yX0ukaBg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] KVM: arm64: Drop %pB on nVHE panic when stage-2 is
 active
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vincent Donnefort" <vdonnefort@google.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260803093906.3531699-1-vdonnefort@google.com>
References: <20260803093906.3531699-1-vdonnefort@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 03 Aug 2026 09:50:16 +0000
Message-Id: <20260803095017.4A9D01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Incomplete fix for host stage-2 deadlock in nVHE hyp panic handler.
--

--- Patch [1]: [PATCH v2] KVM: arm64: Drop %pB on nVHE panic when stage-2 i=
s active ---
commit 6bd2e7dd3552f4e44146bf3e1065ca1511de7411
Author: Vincent Donnefort <vdonnefort@google.com>

KVM: arm64: Drop %pB on nVHE panic when stage-2 is active

This patch introduces nvhe_hyp_panic_host_s2_disabled() to skip %pB
formatting during a hyp panic when host stage-2 is active. It aims to preve=
nt
deadlocks that occur if the host stage-2 lock is held and a fault happens
when accessing lazily mapped kallsyms data.

> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index 54aedf93c78b6..88dcb8cb36f3c 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
[ ... ]
> @@ -538,8 +548,7 @@ void __noreturn __cold nvhe_hyp_panic_handler(u64 esr=
, u64 spsr,
>  		unsigned int line =3D 0;
> =20
>  		/* All hyp bugs, including warnings, are treated as fatal. */
> -		if (!is_protected_kvm_enabled() ||
> -		    IS_ENABLED(CONFIG_PKVM_DISABLE_STAGE2_ON_PANIC)) {
> +		if (nvhe_hyp_panic_host_s2_disabled()) {
>  			struct bug_entry *bug =3D find_bug(elr_in_kimg);
> =20
>  			if (bug)

[Severity: High]
This is a pre-existing issue, but does this fully resolve the host stage-2
deadlock?

Further down in this same function, the backtrace and instruction dumpers
are called unconditionally:

	/* Dump the nVHE hypervisor backtrace */
	kvm_nvhe_dump_backtrace(hyp_offset);

	/* Dump the faulting instruction */
	dump_kernel_instr(panic_addr + kaslr_offset());

kvm_nvhe_dump_backtrace() iterates over stack frames and calls
kvm_nvhe_dump_backtrace_entry(), which uses the exact same %pB formatter
to print the frames:

arch/arm64/kvm/stacktrace.c:kvm_nvhe_dump_backtrace_entry() {
    ...
	kvm_err(" [<%016lx>] %pB\n", where, (void *)(where + kaslr_offset()));
    ...
}

Similarly, dump_kernel_instr() reads the faulting instruction directly from
kernel memory, which could trigger a stage-2 data abort if the page is not
present in the lazy host stage-2 page tables:

arch/arm64/kernel/traps.c:dump_kernel_instr() {
    ...
		bad =3D aarch64_insn_read(&((u32 *)kaddr)[i], &val);
    ...
}

If a panic occurs while the host stage-2 lock is held, won't these
unconditional calls still trigger the stage-2 fault and deadlock that
this patch is trying to avoid?

Should these operations also be gated by nvhe_hyp_panic_host_s2_disabled()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260803093906.3531=
699-1-vdonnefort@google.com?part=3D1
