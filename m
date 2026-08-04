Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57B4A368D73
	for <kvmarm@lists.linux.dev>; Tue,  4 Aug 2026 11:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785843659; cv=none; b=XCgaMphOtt/NkFVLcEaPTFIqoJyLdimHlJft8A6aPJgHSyUaBc8Rn+wpihQHnbejZWttIJ4tq6ACQ4FaKv7u3EAxQASLUXTFRkhm/bLRWtOuRXcVJH1dENLaq9GpGQEvJNXXWlRPrhIh6PLhFPqqwofNJeHDtugFxn9v9qBjU/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785843659; c=relaxed/simple;
	bh=9x5aZlgHWLbfukLG/6BVtazCWvAY3UmKBbIWv4yADDE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=SrjTuQZcWZXKtSzd8878z01rfbM6WocfBeC5NKJs6MTtF3QatbQqh5GItjzMZHQXcJD0VNWW/Da6MzJVue3cFBY2qlxCasybpe1ZTIfDwqhg15gHE3r4x0ReB1RaVHScdK6vFGYJMFrg86uYGXtD5kNRnG62xVRsfChjRK5DTw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j9MZ4C63; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j9MZ4C63"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 922561F000E9;
	Tue,  4 Aug 2026 11:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785843656;
	bh=Zb0g7U/vxo6pSKfDGkErujFVmDqdnDQCH+sowG5Jvds=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=j9MZ4C63EdXf57He4Y722WIrbmmOd4tEFks4gcKNEx2V110G3/owepcvdGu4ImgZ3
	 C+dPeZTn2P8svufu6DLLjgzCvUfKlz3GSPHwx+xdKCGCKvhJAWzpaDdINcLmZ2Dg4N
	 E+ljHUzkOcfib+6wXvwY4OjXBHEtwHNyGrRO1717Uk8vF9FwGvDMM09PgeA9ztaRUN
	 IrdiML/+k/dYfogOlno32OMFqvvNAJPKFcB11HvwiJxTqX9VOwcOvXJvxqDZSvdlgS
	 UiQ3xz0EIDXYgfrz9ldojF6fuSbo2wKbUx5vdvv6vltwoKZPhxexeiRKHKsEhzpXWo
	 qdCQBUq5YorLQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 10/11] KVM: arm64: nVHE: Check hypercall handlers
 against the declared ABI
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260804112317.1937387-11-fuad.tabba@linux.dev>
References: <20260804112317.1937387-1-fuad.tabba@linux.dev>
 <20260804112317.1937387-11-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 04 Aug 2026 11:40:56 +0000
Message-Id: <20260804114056.922561F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Missing context synchronization event (ISB) after writing to SYS_S=
CTLR.
- [High] Double-fetch of untrusted host memory in pkvm_refill_memcache() le=
ading to a TOCTOU vulnerability.
--

--- Patch [10]: [PATCH v3 10/11] KVM: arm64: nVHE: Check hypercall handlers=
 against the declared ABI ---
commit c02cd7851991d5d8c9aac5af1e86684fe8258ca4
Author: Fuad Tabba <fuad.tabba@linux.dev>
KVM: arm64: nVHE: Check hypercall handlers against the declared ABI

This patch replaces manually unmarshalled hypercall arguments using
DECLARE_REG() with generated handlers via DEFINE_KVM_HOST_HCALL() and
DEFINE_KVM_HOST_HCALL0(). This ensures that the parameter list is type-chec=
ked
against the signature declared in <asm/kvm_hcall.h> to prevent mismatches
between caller and handler.

> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe=
/hyp-main.c
> index 23cb4313c60a2..675d607727929 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c

[ ... ]

>  static int pkvm_refill_memcache(struct pkvm_hyp_vcpu *hyp_vcpu)
>  {
>  	struct kvm_vcpu *host_vcpu =3D hyp_vcpu->host_vcpu;
> =20
>  	return refill_memcache(&hyp_vcpu->vcpu.arch.pkvm_memcache,
>  			       host_vcpu->arch.pkvm_memcache.nr_pages,
>  			       &host_vcpu->arch.pkvm_memcache);
                               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

[Severity: High]
This is a pre-existing issue, but could this double-fetch of untrusted host
memory lead to a TOCTOU race condition?

The host memory is dereferenced here to read nr_pages and then passed as a
pointer to refill_memcache(), which fetches from it again:

arch/arm64/kvm/hyp/nvhe/mm.c:refill_memcache() {
    ...
    struct kvm_hyp_memcache tmp =3D *host_mc;
    ...
}

If the host concurrently modifies the struct between the fetches, EL2 might
use a min_pages target that differs from the actual struct state. Should the
struct be copied to EL2 private memory first before acting on it?

>  }

[ ... ]

> -static void handle___kvm_enable_ssbs(struct kvm_cpu_context *host_ctxt)
> +DEFINE_KVM_HOST_HCALL0(void, __kvm_enable_ssbs)
>  {
>  	u64 tmp;
> =20
>  	tmp =3D read_sysreg_el2(SYS_SCTLR);
>  	tmp |=3D SCTLR_ELx_DSSBS;
>  	write_sysreg_el2(tmp, SYS_SCTLR);
>  }
   ^

[Severity: High]
This isn't a bug introduced by this patch, but should an isb() instruction =
be
issued after the write to SYS_SCTLR?

Updates to control-plane system registers like SYS_SCTLR require a Context
Synchronization Event (CSE) to be visible to subsequent instructions.
Returning without an immediate isb() might leave the processor operating wi=
th
an architecturally undefined pipeline state.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260804112317.1937=
387-1-fuad.tabba@linux.dev?part=3D10
