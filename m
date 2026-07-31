Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C4F03033E3
	for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 15:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785510404; cv=none; b=j6bxoJq7StEMUEK7GLFmnWCCQbnwLTSVm0/KYECvqa9H5FKeRPHHfO+ggAF2VqSnAF7dddXQl0N/4H35xpiDdW3M0yAugppHsKxGK5sYGsf+RtHBXncToHjja5h6oEpe2+6wHJLBWLe37tnEZa4/YU6AZvRhuJyyJCscq6Leeu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785510404; c=relaxed/simple;
	bh=MydWr/9ulZaUMjrqXaz3RfupII/Omyz/aEvcEMyB2wE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=eNc+X06RD3+5GAvwq/BiZ03o2XyfuEtaXQHrI4yBe3tsuiqITO4Tyl2lfiZi8vbb+Qg7aH/dCN0qr/FGND6Q4c0fQ6RoAq6p9UHNJ5s0gFwthfvsXlB3+NjN13IQbQXolRA4hvZCaUa01CwglRez/50cE34WrXEkU8Zxze1KlmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j8qRocDP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j8qRocDP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1D231F000E9;
	Fri, 31 Jul 2026 15:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785510403;
	bh=n5HxEPJHg8Og0E/KXy/iMY7Exgtt44WyaHsAGH9etBo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=j8qRocDPNGcZiAyfrmH4ZlLkQ/4v6znj9vOkFtMoAZv1n7ljIgzhdu2gLo3IPoU06
	 UbGC7sp4L73RUsEXOmkNS4AHLmoX3K2v85wQ/uV2KVuWdW6xc+u4fbdCJYydHHzSqR
	 QJ1ORrNd7hyYX7AguYQ29YGJyjt62jGTY4J7ckrqczuivHYWBKt++L6VRiP+7V5dkw
	 uMq45IL6Ag8VqunFCVywqVdcTedU2BcuDfzFOAsdDY7nI6ZoBMZ0jOe4QxrgUxZMpO
	 B67EXziiwgLuYzQ6MOmD5OevZtFUO7/CZ+5paVIN9jtJC/VaITc1EkyEADDdKrtIva
	 DZTnuVaJ7/K1g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 13/17] KVM: arm64: Alloc pkvm_hyp_vm using pKVM heap
 allocator
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vincent Donnefort" <vdonnefort@google.com>
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260731143541.956291-14-vdonnefort@google.com>
References: <20260731143541.956291-1-vdonnefort@google.com>
 <20260731143541.956291-14-vdonnefort@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 31 Jul 2026 15:06:42 +0000
Message-Id: <20260731150642.E1D231F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Memory allocated for the hypervisor heap is not accounted to the m=
emcg of the container creating the VM, creating a memory limit bypass. Prio=
r to this patch, `hyp_vm` was allocated on the host using `GFP_KERNEL_ACCOU=
NT`, correctly attributing the memory to the calling process's memcg. With =
the shift to EL2 dynamic allocation via `hyp_alloc()`, when the heap requir=
es more memory, EL2 requests a top-up from the host via `PKVM_HYP_REQ_HYP_A=
LLOC`. The host handles this in `pkvm_hyp_topup()` by creating a temporary =
memcache and initializing it with `init_hyp_memcache(&mc)`. However, `init_=
hyp_memcache()` zeroes the memcache flags, meaning `HYP_MEMCACHE_ACCOUNT_KM=
EMCG` is not set. Consequently, when `topup_hyp_memcache()` allocates host =
pages, `hyp_mc_alloc_fn()` falls back to `GFP_KERNEL` instead of `GFP_KERNE=
L_ACCOUNT`. This hides the hypervisor heap allocations from memcg limits, a=
llowing a container to exhaust host memory by creating VMs with maximum vCP=
Us without being charged.
--

--- Patch [13]: [PATCH v4 13/17] KVM: arm64: Alloc pkvm_hyp_vm using pKVM h=
eap allocator ---
commit 3a3fbdf527ba4d3c04e2e5d3272e58f6042e8822
Author: Vincent Donnefort <vdonnefort@google.com>

KVM: arm64: Alloc pkvm_hyp_vm using pKVM heap allocator
   =20
This commit transitions the allocation of the hypervisor VM state structure
(pkvm_hyp_vm) to the pKVM heap allocator at EL2. The host now uses
pkvm_call_hyp_req() to invoke __pkvm_init_vm, handling any EL2 heap top-up
requests dynamically instead of donating pre-allocated host memory.

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
Does this new allocation path lose the memcg accounting for the hyp_vm
structure?

Previously, hyp_vm was allocated on the host using GFP_KERNEL_ACCOUNT, which
correctly attributed the memory to the calling process's memcg.

With the shift to EL2 dynamic allocation, when the heap requires more memor=
y,
EL2 requests a top-up via PKVM_HYP_REQ_HYP_ALLOC. When the host handles this
in pkvm_hyp_topup(), it creates a temporary memcache using
init_hyp_memcache(), which leaves the HYP_MEMCACHE_ACCOUNT_KMEMCG flag
cleared.

Because of this, when topup_hyp_memcache() allocates host pages,
hyp_mc_alloc_fn() falls back to GFP_KERNEL instead of GFP_KERNEL_ACCOUNT.
This hides the hypervisor heap allocations from memcg limits.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260731143541.9562=
91-1-vdonnefort@google.com?part=3D13
