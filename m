Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5268420010A;
	Thu, 30 Jul 2026 08:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785398949; cv=none; b=kN2FB2KRwR+0fqvrYkxOVyQaxQGUUfubowMcLxi9K+4NE00hDz0+yoqwKjwq8UzvIsRXF70q1O9KL4K8Gn2i+t/DMzB+h9s4xnC5qwLN6B5MG5wYp7BEChjsAO5VxPDEmkblNPNVeX3LhIA8G3JYOGUKcw/fn2GkaWn+YYjO19w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785398949; c=relaxed/simple;
	bh=vbIJ6wHYstVYO4F4ITYKUPTTa/6B1jeuMt4mwdgv/7A=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=eEMNBMPNdFshwPp0SYULztbU/0is7iIIw3I1O0ARcIOjqdVSBrdLH4dmllDzEpULKC7PBTj7RiYFkD2QdAgskGQf3t0W318eyIyzOuLOfj6RgRj013kRVSq5dl7Wod+1Zz/tIAc1N5SuEmvYz354QUyEwDaNyrCjG6ir3gQfvKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=evT0eGRx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="evT0eGRx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 820331F000E9;
	Thu, 30 Jul 2026 08:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785398947;
	bh=Z2hWtmEZLNmHY8PiP5RS6rKpQO5SmncyO60fVnqaCks=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=evT0eGRxdY5FEnnP0PGvBHBM/CnWAvySFbQ95MB/V2ofDOt2Cej3R0aBZag20ZB8z
	 SXjZh9rZHbTIQw0UVCNRlkDYULjYjga268j2/bye1eNA1yn+gchGZGmYnm2Fd5MJtT
	 td5WaKrf9SboLshIJmcXRLfQVqgiixL5PLGUUJYRG7U32xAp52UVZHxMXPLo57DMTE
	 TZq0HP4uUUdzCotzohtcBCbnxvZjGGnBySXzPjDX3NUPdLu68BSxcs+f/qMF4QiLIQ
	 raNG3djot2MWRed1+Qs9C66fFn0JRNF5ITuGQDM1wJX0uGTTpCrdLfsZBUxQwVhOmJ
	 6JMLktZlCsoag==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 11/29] KVM: arm64: Expose FEAT_NV2p1 to NV guests
Reply-To: sashiko-reviews@lists.linux.dev
To: "Marc Zyngier" <maz@kernel.org>
Cc: "Marc Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260730071022.296811-12-maz@kernel.org>
References: <20260730071022.296811-1-maz@kernel.org>
 <20260730071022.296811-12-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 30 Jul 2026 08:09:06 +0000
Message-Id: <20260730080907.820331F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Missing context synchronization event (`isb()`) after writing to a=
 control-plane system register (`CNTKCTL_EL1` / `CNTHCTL_EL2`).
--

--- Patch [11]: [PATCH v4 11/29] KVM: arm64: Expose FEAT_NV2p1 to NV guests=
 ---
commit 5b82c2dde5c66c45b12e75de220aab8518c99896
Author: Marc Zyngier <maz@kernel.org>

KVM: arm64: Expose FEAT_NV2p1 to NV guests

This commit exposes FEAT_NV2p1 to nested virtualization guests. By reducing
the number of traps and updating timer configurations, it brings valuable
performance improvements to NV guests.

> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index 4155fe89b58a1..db60facad9f3c 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c
> @@ -876,8 +876,14 @@ static void timer_set_traps(struct kvm_vcpu *vcpu, s=
truct timer_map *map)
>  	assign_clear_set_bit(tvt02, CNTHCTL_EL1NVVCT, clr, set);
>  	assign_clear_set_bit(tpt02, CNTHCTL_EL1NVPCT, clr, set);
> =20
> -	/* This only happens on VHE, so use the CNTHCTL_EL2 accessor. */
> -	sysreg_clear_set(cnthctl_el2, clr, set);
> +	/*
> +	 * This only happens on VHE, so use the CNTHCTL_EL2 accessor, unless
> +	 * we are sure CNTKCTL_EL1 is completely stateful with FEAT_NV2p1.
> +	 */
> +	if (!cpus_have_final_cap(ARM64_HAS_NV2P1))
> +		sysreg_clear_set(cnthctl_el2, clr, set);
> +	else
> +		sysreg_clear_set(cntkctl_el1, clr, set);
>  }

[Severity: High]
Does this write to a control-plane system register require an isb() before
returning?

The ARM64 architecture generally requires an isb() as the very next
instruction after writing to control-plane registers like cnthctl_el2
and cntkctl_el1 to ensure subsequent instructions do not execute with
a stale configuration.

Because sysreg_clear_set() expands to a hardware write without an isb(),
timer_set_traps() returns immediately after the write. Could the CPU execute
subsequent instructions in the caller with stale pipeline state before a
context synchronization event occurs?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260730071022.2968=
11-1-maz@kernel.org?part=3D11
