Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74B9A36492A
	for <kvmarm@lists.linux.dev>; Mon,  3 Aug 2026 13:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785764677; cv=none; b=j0Ak44VEc+mHv0iCAZwMDXzMEa0SX4U4NJ0XYIfm4U/WdbKA++NQhek3AOlMNvlqEb8i/2YH3XZle5SHzsII1XUQ/BhMiibAr0IvlUnM1oneAhQjZxxZhRVEg6bC6YKbcHNjkdzC1TlFj0Pj9lXVs5vL+l1GWSazIw46Fdyr3zA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785764677; c=relaxed/simple;
	bh=s/EOUAimm0zo+akYs9U4Ty9b1IXz1ihqIU/GVPXCBEU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Qhxab8Wko0pSy9Z8fDrdVEuHO2NDZ6q4JUnkSMVeLOlPMqEKmW/V6SaFc0YGBI19uum5b6FpQbQyof24NmyaH/BekDHZ2CqmqiKNyMbugWAnam3coDkGGb9rw1WQgJC1VOx6ShQRic/0WWFB1mcqkYE+ksGmbJUZdsT6Q70m/ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eN29kLxk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eN29kLxk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D34A41F00A3F;
	Mon,  3 Aug 2026 13:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785764676;
	bh=lR0TUN1a58a98GxfoDBrIjFs8I6K1mPys5WBfRO6s0U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eN29kLxkJfTqBNzZDnzZxjUusPPK6Qyn10joj/8bEWwfLq9vAjjjg8vflP9n5c/bn
	 qY6REWaLSE/Egeag50U/xyzLy+8W6MAmFmuBafl6LBNKMQrnjIPHA0taNmskkABGRg
	 MNrS9gszHd+crOdmMDcb4SL8ym8RP3R2TbfIqqPjwmkfsyOyUkhEwVCKOuezTm2QEy
	 ra0LpIGfrl2t5m8xR0tE/HKwSPCNxt8k9ELbNUPgD+9WvaiUtSLso7m/nXpR0eFYiT
	 +gogHKQxepBrCVGQk0dGa3dpc5hRwds8A/tmUUuy78N1G6xwIGYCfKbPKbtg+g5+yg
	 RcRZ2k9k2O7KQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 11/11] KVM: arm64: Tag host-VA hypercall parameters
 __kern
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260803124220.332248-12-fuad.tabba@linux.dev>
References: <20260803124220.332248-1-fuad.tabba@linux.dev>
 <20260803124220.332248-12-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 03 Aug 2026 13:44:33 +0000
Message-Id: <20260803134435.D34A41F00A3F@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [Medium] The `kern_hyp_va_host()` macro strips the `__kern` tag using `(_=
_force void *)` and returns a plain pointer, undermining the static analysi=
s guarantees for both misapplied unwraps and subsequent TOCTOU bugs.

Pre-existing issues:
- [Critical] Always-on hypercalls (e.g., `__vgic_v3_save_aprs`, `__kvm_adju=
st_pc`) accept host VAs, translate them via `kern_hyp_va_host()`, and read/=
write to them without validating physical page ownership, enabling a Confus=
ed Deputy arbitrary memory corruption attack.
--

--- Patch [11]: [PATCH v2 11/11] KVM: arm64: Tag host-VA hypercall paramete=
rs __kern ---
commit 0acf480afb506d5122464f1024574511fad649b3
Author: Fuad Tabba <fuad.tabba@linux.dev>

KVM: arm64: Tag host-VA hypercall parameters __kern

The nVHE hypervisor takes host virtual addresses as hypercall arguments
and translates each with kern_hyp_va() before use. This patch adds a __kern=
=20
sparse address space for EL2 code to tag host-VA parameters and introduces=
=20
kern_hyp_va_host() to unwrap them.

> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kv=
m_mmu.h
> index 6eae7e7e2a684..57f65257bb56d 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
[ ... ]
> @@ -140,6 +142,14 @@ static __always_inline unsigned long __kern_hyp_va(u=
nsigned long v)
> =20
>  #define kern_hyp_va(v) 	((typeof(v))(__kern_hyp_va((unsigned long)(v))))
> =20
> +/*
> + * Translate a __kern-tagged host VA, dropping the tag: the only sanctio=
ned
> + * unwrap. Translation only, no ownership or bounds validation; the resu=
lt
> + * carries the pointee type stripped of the tag and of any cv-qualifiers.
> + */
> +#define kern_hyp_va_host(v)						\
> +	((TYPEOF_UNQUAL(*(v)) *)__kern_hyp_va((unsigned long)(__force void *)(v=
)))

[Severity: Medium]
Since the __force void * cast unconditionally strips all sparse address spa=
ce
information, does this suppress warnings if the macro is accidentally appli=
ed
to an untagged EL2 private-VA-range pointer?

Additionally, because the returned pointer has no address space tag, doesn't
this prevent sparse from warning if a developer directly double-fetches or =
acts
on the translated untrusted host memory instead of copying it first?

For example, in __pkvm_init_vm(), host_kvm is passed as a plain pointer and
loses its sparse static analysis protection despite still aliasing untrusted
memory.

[ ... ]
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe=
/hyp-main.c
> index 6986ce55fd9ef..f8ea1661b3166 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
[ ... ]
> @@ -500,15 +500,15 @@ DEFINE_KVM_HOST_HCALL0_VOID(__vgic_v3_init_lrs)
>  }
> =20
>  DEFINE_KVM_HOST_HCALL_VOID(__vgic_v3_save_aprs,
> -	struct vgic_v3_cpu_if *, cpu_if)
> +	struct vgic_v3_cpu_if __kern *, cpu_if)
>  {
> -	__vgic_v3_save_aprs(kern_hyp_va(cpu_if));
> +	__vgic_v3_save_aprs(kern_hyp_va_host(cpu_if));
>  }

[Severity: Critical]
This is a pre-existing issue, but by retaining the lack of bounds validation
through kern_hyp_va_host(), can the host EL1 trigger an arbitrary memory
corruption in the hypervisor?

Since kern_hyp_va_host() explicitly performs no ownership or bounds validat=
ion,
it appears the host kernel could provide a forged pointer that translates t=
o a
physical page owned by EL2.

The hypervisor then passes this pointer directly to __vgic_v3_save_aprs()
after unvalidated translation:

arch/arm64/kvm/hyp/vgic-v3-sr.c:__vgic_v3_save_aprs() {
    ...
    cpu_if->vgic_ap0r[3] =3D __vgic_v3_read_ap0rn(3);
    ...
}

which directly writes to the untrusted pointer, potentially allowing the ho=
st
to corrupt EL2 private memory and bypass isolation.

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260803124220.3322=
48-1-fuad.tabba@linux.dev?part=3D11
