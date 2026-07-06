Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A3893F5BE4
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 18:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783362278; cv=none; b=IlXz/jo8Nja9TlzMwJfxVjUXYCxQPW/g+lR/L7qOe/jVXTT2tWR2q6aadcBgJLScpgn/KrNScUKwanpn/iu11fmEzJNmxgLP27OLlNsbzKcdZ2Vrl6O7rTkgyme+gtxrswyL9HaSih77Hdr5CZZpjxGrrBOMupQ17Wwfp9ujRLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783362278; c=relaxed/simple;
	bh=uWJdxzrMUlIjqCp38TWMK0Tztu9xBjabrNNu3z06Wps=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=gFmjLF+ZVu+SIP3qSrvesHuFEw3+xMQ+ceYN4xSYaLP9iPxmHbCEc/dnFYboweniRy4jZWdFoCrFDjdyeFN4xL+IAXGyIGAfFcjzVG3nVb1kbDickfwXrRa/pIgpK+UomNlxltszDHQBz4Rp857UTCNZZNM/pvQkL3VUBR4ZvNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kKZGNVIW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kKZGNVIW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 766D91F000E9;
	Mon,  6 Jul 2026 18:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783362276;
	bh=ablQ1bwTf/I0G3LXvUS+xC3s132wQi++XeO7jomQ5Gc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kKZGNVIWn9bFaXn7dPkjkqP1jiuVUytBJXJVp1YXv+o+/zRZ8kNvaOO2EGWXgTJ57
	 su+ugfDiSfwR6oZJLTc8JEryc/LDsblzB7flbZUOTY58J/Bc/+lEpxDGunSY6E/tsu
	 VIx0OPENqTAWvHPB1KOwBfp+bCk2EBvz31XOGRSfQhi7UYIxiScZWqNUWhoPwCI9YR
	 fiCHK/D/hwYO26JFJ0wTKCG9UUngW1QQIZB7YRnszlpynHu7PYzFwZo6jfy/7lD7XV
	 9E74/mPk+f/7iE0B83ieMFVEDIR7YGRIkQym69aAcBx46N9zV0EyUVmPyjgS78tWuj
	 XNZdGjTqt9CgA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 15/18] KVM: arm64: Alloc pkvm_hyp_vm using pKVM heap
 allocator
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vincent Donnefort" <vdonnefort@google.com>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260706175415.2604046-16-vdonnefort@google.com>
References: <20260706175415.2604046-1-vdonnefort@google.com>
 <20260706175415.2604046-16-vdonnefort@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 06 Jul 2026 18:24:36 +0000
Message-Id: <20260706182436.766D91F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Memcg accounting bypass in EL2 heap top-up allows host memory exha=
ustion
--

commit 66032df021feb40dc76572f7b2d6e0341f8b7e65
Author: Vincent Donnefort <vdonnefort@google.com>

KVM: arm64: Alloc pkvm_hyp_vm using pKVM heap allocator

Transition the allocation of the hypervisor VM state structure
(pkvm_hyp_vm) from the host to the hypervisor using the new pKVM heap
allocator (hyp_alloc()).

> diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> index f7e1846d6093f..8a8b5b84825c7 100644
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
Does this change bypass memory cgroup accounting for the VM allocation?

Previously, the host allocated hyp_vm using GFP_KERNEL_ACCOUNT. With this
patch, the allocation is deferred to EL2, and if the EL2 heap is
depleted, it triggers a top-up request handled by pkvm_call_hyp_req()
and pkvm_hyp_topup() on the host.

Looking at how pkvm_hyp_topup() initializes the memcache:

init_hyp_memcache(&mc);
ret =3D topup_hyp_memcache(&mc, nr_pages);

The init_hyp_memcache() helper zeros the memcache flags, meaning it omits
the HYP_MEMCACHE_ACCOUNT_KMEMCG flag. As a result, the subsequent host page
allocations in hyp_mc_alloc_fn() will use a plain GFP_KERNEL without
__GFP_ACCOUNT.

Could an unprivileged container repeatedly trigger KVM_CREATE_VM to exhaust
host memory without being restricted by its memory cgroup limits?

>  	if (ret)
> -		goto free_vm;
> +		goto free_pgd;
> =20
>  	kvm->arch.pkvm.is_created =3D true;
>  	init_hyp_stage2_memcache(&kvm->arch.pkvm.stage2_teardown_mc);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260706175415.2604=
046-1-vdonnefort@google.com?part=3D15
