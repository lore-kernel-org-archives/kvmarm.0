Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA109448D0C
	for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 17:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784569462; cv=none; b=rh4xqCsYKMvEEfFoRxPvjvRFNWJ+PctHTIaQm5OvHvkkbnhOVho7mEH3Xy24CtWTuPNeGIvUsAi6TH/teDBcI4+JxVHYRFRvGnUBr2SnoWR7X3KXT6kuty4tbdY0KiHQWDCiejvE7Bge4G8qCJPpiLPNwhGZTHbpdWiC4NZxsvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784569462; c=relaxed/simple;
	bh=n9Xxik5+CXgDCCIBOk2WJeYoDHO0aQFu16V5+FSjSGo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=m6c33Z1mG8JP7EYadIStdTson/3NAG8sJIrfH1Cs/jO4jV3bBfIyp7la7znh2TYUUAA9uYZWbtDX9x7QgWAeyUnNxNu7Kmsun1/CgTr9yyXdGFKuIEOLPOiWNQfac2LXhJ/T6EQ3NSX0vLYiOoy91pdAjIsndQ00JVbBD38mphQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A8P4wati; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A8P4wati"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 844D01F000E9;
	Mon, 20 Jul 2026 17:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784569458;
	bh=L97yKe6jwR7PeARTs5oYgZog7f2jAgI8Z7p8GU7X60o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=A8P4watiilFs1feHAJa4mcPMwJWOmi/TqQU25gJ7cucBCWVjt57JKnBbrEuqRj5az
	 v8NomhWohXVFoucucANbHRr/yW84c78XZMe8q29TssWygJYscLb1Q/NbRMfkg+Sy6P
	 d3NuMV2ZN6sx8jt9EQdgzy1smvkEYsOcVqa0mvqKi129MeKni73a8T6LTulJNXiCZj
	 Hr71btfJfRHHqYV8fm8ofuLcmGPKxzisiLjHdijl4BploFjQBoRB1hnYFcSaXAogwD
	 06lcmVb4S9iFfTaBUX9jkb5rYVYWDLiqhvt4oAHRSDicq7Q2SVk1S0Ey7UGIncnC9m
	 3pEWFhB/YgH3w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 13/17] KVM: arm64: Alloc pkvm_hyp_vm using pKVM heap
 allocator
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vincent Donnefort" <vdonnefort@google.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260720171513.1415357-14-vdonnefort@google.com>
References: <20260720171513.1415357-1-vdonnefort@google.com>
 <20260720171513.1415357-14-vdonnefort@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 20 Jul 2026 17:44:18 +0000
Message-Id: <20260720174418.844D01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] The transition to the EL2 heap allocator bypasses memcg limits for=
 the hypervisor VM state (pkvm_hyp_vm), allowing an attacker to exhaust ker=
nel memory.
--

--- Patch [13]: [PATCH v3 13/17] KVM: arm64: Alloc pkvm_hyp_vm using pKVM h=
eap allocator ---
commit c6efe6070fc3bbf691ec525e89c4a8f6d1c0cae1
Author: Vincent Donnefort <vdonnefort@google.com>

KVM: arm64: Alloc pkvm_hyp_vm using pKVM heap allocator
   =20
This commit transitions the allocation of the hypervisor VM state structure
from the host to the hypervisor using the new pKVM heap allocator. The host
now invokes __pkvm_init_vm using pkvm_call_hyp_req(), which handles heap to=
p-up
requests if the hypervisor runs out of memory during initialization.

> diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> index bfbb1266491d1..a9b85ad37787a 100644
> --- a/arch/arm64/kvm/pkvm.c
> +++ b/arch/arm64/kvm/pkvm.c
[ ... ]
> @@ -209,28 +209,15 @@ static int __pkvm_create_hyp_vm(struct kvm *kvm)
>  	if (!pgd)
>  		return -ENOMEM;
> =20
> -	/* Allocate memory to donate to hyp for vm and vcpu pointers. */
> -	hyp_vm_sz =3D PAGE_ALIGN(size_add(PKVM_HYP_VM_SIZE,
> -					size_mul(sizeof(void *),
> -						 kvm->created_vcpus)));
> -	hyp_vm =3D alloc_pages_exact(hyp_vm_sz, GFP_KERNEL_ACCOUNT);
> -	if (!hyp_vm) {
> -		ret =3D -ENOMEM;
> -		goto free_pgd;
> -	}
> -
> -	/* Donate the VM memory to hyp and let hyp initialize it. */
> -	ret =3D kvm_call_hyp_nvhe(__pkvm_init_vm, kvm, hyp_vm, pgd);
> +	ret =3D pkvm_call_hyp_req(__pkvm_init_vm, kvm, pgd);

[Severity: High]
Does this transition to the EL2 heap allocator bypass memcg limits for the
hypervisor VM state?

Previously, the host allocated this memory with GFP_KERNEL_ACCOUNT. With th=
is
patch, if EL2's heap allocator runs out of memory, it triggers a top-up
request (PKVM_HYP_REQ_HYP_ALLOC).=20

When this top-up request is handled by pkvm_hyp_topup() in the host, it app=
ears
to initialize a temporary memcache without the HYP_MEMCACHE_ACCOUNT_KMEMCG
flag:

arch/arm64/kvm/pkvm.c:pkvm_hyp_topup() {
    ...
    init_hyp_memcache(&mc);
    ret =3D topup_hyp_memcache(&mc, nr_pages);
    ...
}

This causes hyp_mc_alloc_fn() to fall back to unaccounted GFP_KERNEL
allocations, as it relies on that flag to use GFP_KERNEL_ACCOUNT:

arch/arm64/kvm/mmu.c:hyp_mc_alloc_fn() {
    ...
    gfp =3D memcache->flags & HYP_MEMCACHE_ACCOUNT_KMEMCG ?
          GFP_KERNEL_ACCOUNT : GFP_KERNEL;
    ...
}

Could this allow an unprivileged userspace process inside a container to
exhaust host kernel memory by repeatedly creating pKVM VMs?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260720171513.1415=
357-1-vdonnefort@google.com?part=3D13
