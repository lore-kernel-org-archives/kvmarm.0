Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58748450903
	for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 17:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784570120; cv=none; b=J/eVTPNAiSXkJ/nvEi3AnecP/gPB3iHdd+ZVujw3RYi1sCSRfq44swehc0zT4srvmRPIN93Vx3ojU0k3yw0KfJL2MJ5PT5y1PoUEDegvAsKWIbkqDzAzQREqp5M1Tp0HYFrOrFkHDh+wS5GzH6JXlFi9Y7UbL6vFyycbkFBiTWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784570120; c=relaxed/simple;
	bh=VOMXgbgsC5LW7qn4YzmPLwyDSO8MkVLKOUNt1RRhFA0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=RI96u6k8E+0+OEF1icTZzD6MXfxMnRJTv917J3Mq+HZ4hcd7gvHmahXiobJfVgqOjsHFBrbzrWrbpTWbBfIEmiM7guA6aKFS/iXelCvDBDkmt93a/ZmzMNiyrqvJ0GpsRyeeKARc+rQaII5GhtdnH5c/RrrF+j9guF4v132NN/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MAsc+Xm5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MAsc+Xm5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D4DF1F00A3A;
	Mon, 20 Jul 2026 17:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784570114;
	bh=EvtwgKob90Kqw/vuQAR5BMr7eGHLbwtw6ts07iL3wVA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MAsc+Xm5OyHzJrPgKCKqKr/4YNwn4yU/UqhuYpZImsAOj+pNJpOjJn8zrMFJjIYUf
	 BTOV/ql4Ph7Z+MBz/AOn1+E+AmV13VopOINhwya7lXu2RMvrrDsMoJQDdQf9PBupIT
	 9DawznTngoZ0TIMclFQXOG+cbtEoFQ3S5T+7Tis0iVEC7U8+IhBDAEQcbopIx6tmSN
	 rQsGHq/7xAsQ8o+BUHWS8Wp3pZu61Hub7+R/5hdou9nJP2dQY+QEx50vmeDKJJfnSd
	 J0x6SSChzy4LrnT1R63MBI6jUPcfSnulAAu17ltA9o4zApcaU3P9ws+CiZSgAcvJSQ
	 FN5GXAXiDhg+A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 11/11] KVM: arm64: Tag host-VA hypercall parameters
 __hostva
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260720162412.1401272-2-fuad.tabba@linux.dev>
References: <20260720161343.1367007-1-fuad.tabba@linux.dev>
 <20260720162412.1401272-1-fuad.tabba@linux.dev>
 <20260720162412.1401272-2-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 20 Jul 2026 17:55:13 +0000
Message-Id: <20260720175513.8D4DF1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [Medium] `kern_hyp_va_host()` macro fails to strip the `__hostva` address=
 space tag for Sparse.

Pre-existing issues:
- [Critical] Missing host pointer ownership validation in always-on hyperca=
lls allows a malicious host to corrupt EL2-private memory (Confused Deputy).
--

--- Patch [11]: [PATCH v1 11/11] KVM: arm64: Tag host-VA hypercall paramete=
rs __hostva ---
commit 4acf0dff6116caffddce5517211ac9136d9b0ee1
Author: Fuad Tabba <fuad.tabba@linux.dev>

KVM: arm64: Tag host-VA hypercall parameters __hostva

This commit introduces the __hostva sparse address space to tag host virtual
addresses passed as hypercall arguments in the nVHE hypervisor. It adds
kern_hyp_va_host() to explicitly unwrap and translate these tagged pointers,
ensuring that untranslated host VAs are caught by sparse checks.

> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kv=
m_mmu.h
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h

[ ... ]

> @@ -140,6 +142,14 @@ static __always_inline unsigned long __kern_hyp_va(u=
nsigned long v)
> =20
>  #define kern_hyp_va(v) 	((typeof(v))(__kern_hyp_va((unsigned long)(v))))
> =20
> +/*
> + * Translate a __hostva-tagged host VA, dropping the tag: the only sanct=
ioned
> + * unwrap. Translation only, no ownership or bounds validation; the resu=
lt
> + * carries the pointee type stripped of the tag and of any cv-qualifiers.
> + */
> +#define kern_hyp_va_host(v)						\
> +	((TYPEOF_UNQUAL(*(v)) *)__kern_hyp_va((unsigned long)(__force void *)(v=
)))

[Severity: Medium]
Does TYPEOF_UNQUAL() actually strip the address space tag in Sparse?

Sparse treats address spaces as type qualifiers that typeof_unqual (and
by extension TYPEOF_UNQUAL) does not remove, unlike const or volatile.
Consequently, this cast evaluates to a pointer that still carries the
__hostva tag.

When assigned to a regular kernel pointer, this will trigger incorrect type
in assignment (different address spaces) false positive warnings across the
codebase when running make C=3D2.

Should this use an explicit cast to __kernel (address_space(0)) to
correctly strip the tag, similar to how per_cpu_ptr handles __percpu?

> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe=
/hyp-main.c
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c

[ ... ]

> @@ -421,9 +421,9 @@ DEFINE_KVM_HOST_HCALL(int, __pkvm_host_mkyoung_guest,=
 1,
>  }
> =20
>  DEFINE_KVM_HOST_HCALL_VOID(__kvm_adjust_pc, 1,
> -	struct kvm_vcpu *, vcpu)
> +	struct kvm_vcpu __hostva *, vcpu)
>  {
> -	__kvm_adjust_pc(kern_hyp_va(vcpu));
> +	__kvm_adjust_pc(kern_hyp_va_host(vcpu));
>  }

[Severity: Critical]
This is a pre-existing issue, but does this lack of ownership validation
allow the host to corrupt EL2-private memory?

Under pKVM, the host is treated as an adversary. If the host provides a
TTBR1 virtual address that maps to an EL2-private physical address,
kern_hyp_va_host() will translate it into a valid EL2 linear map pointer
without verifying ownership.=20

The hypervisor will then write into EL2-private memory when modifying
flags in __kvm_adjust_pc() or hardware register state in
__vgic_v3_save_aprs(), corrupting its own state or the state of
protected guests.

Should there be an explicit ownership check before dereferencing
pointers from these always-on hypercalls?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260720162412.1401=
272-1-fuad.tabba@linux.dev?part=3D11
