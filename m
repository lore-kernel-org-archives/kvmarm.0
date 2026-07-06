Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0EB6B672
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 18:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783362283; cv=none; b=Unw7GXatv5fmJAK6L9fK2dkvKGvu18yDj7uEIiqOZOWD4hdSt7PnL0zks7H6M3U4YomzFomzwp+oPhw3lZ1Xbc946EZcp048dGyfpmd26EIampSBcC8Ufb1G7uIHAKhS/LasCW/pER3Pb+f7VeXGwXbnFpMsHreIXXKMaaEMhA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783362283; c=relaxed/simple;
	bh=0oQ7dMAry3P2YWF89MoAqyr7inzDg/VABNImZVFkfYE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=UXIAbwPP9qhYQkbpoDd6FdXk8M1osjXn5I4po49TqcbTy2Aaj/6x0+wx8BiAmWTb2QqGOMaPxVMZQ2sM3t3tTg7P3hVQIEMXKPi5EJm389Ayvz5qwCgh/+fiYDYnOI7FpHs0r/vFmrZ9R6A4wVYCRTmsXmaAzK6wbftdT701ECo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cWnLdWh/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cWnLdWh/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43A451F000E9;
	Mon,  6 Jul 2026 18:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783362282;
	bh=5wxJC8nBulvjZ6L//8kUjNM7N7NzgDkGNmjSYrzMLd0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cWnLdWh/KLPdtOaifzGbwAdf63jOmWGs/6Cmm/dQkAyoDUsaOii2uEscirnBbOtcV
	 8Fz78HJ4OOlgp3FqEnTCxlRXnUvDKuED3JcncnraQ8LpM2WD57QstZxePnH2yHM9xZ
	 uNqxQJ5xXlSLOEG+uyALvQaXd5fdQU75Wjir+WXQlt9yZLEB7ZlvMXg8CJW16gdbRj
	 SuwPP1qGZ5jNWvB0W39au1rdLg2no8ByK4KPoDCbpvSnaGyHu7ETbvwdHhHlyGp1Af
	 Xnq0M3LDJkegmkaCKxinx3sEERLkUzXXc5tGvJuTyD6PSSxh4GEaripO6x4XErL8W8
	 D4MZw1ZNxBddA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 16/18] KVM: arm64: Alloc pkvm_hyp_vcpu using pKVM
 heap allocator
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vincent Donnefort" <vdonnefort@google.com>
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260706175415.2604046-17-vdonnefort@google.com>
References: <20260706175415.2604046-1-vdonnefort@google.com>
 <20260706175415.2604046-17-vdonnefort@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 06 Jul 2026 18:24:41 +0000
Message-Id: <20260706182442.43A451F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] The pKVM heap allocator (`hyp_alloc`) guarantees only 8-byte align=
ment, which violates the strict 16-byte alignment requirement of `struct pk=
vm_hyp_vcpu`.
- [High] Delegating `pkvm_hyp_vcpu` allocation to the global EL2 heap bypas=
ses memory cgroup (memcg) accounting, allowing unprivileged userspace to ex=
ceed memory limits.
--

commit 6cb252c4c2be901676d82bdcc257dd6e52864352
Author: Vincent Donnefort <vdonnefort@google.com>

KVM: arm64: Alloc pkvm_hyp_vcpu using pKVM heap allocator

Transition the allocation of the hypervisor vCPU state structure
(pkvm_hyp_vcpu) from the host to the hypervisor using the new pKVM heap
allocator (hyp_alloc()).

> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkv=
m.c
> index 2f616a89f8b35..45ec77e9eca82 100644
> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c

[ ... ]

> @@ -896,16 +863,15 @@ static int register_hyp_vcpu(struct pkvm_hyp_vm *hy=
p_vm,
>  	return 0;
>  }
> =20
> -int __pkvm_init_vcpu(pkvm_handle_t handle, struct kvm_vcpu *host_vcpu,
> -		     unsigned long vcpu_hva)
> +int __pkvm_init_vcpu(pkvm_handle_t handle, struct kvm_vcpu *host_vcpu)
>  {
>  	struct pkvm_hyp_vcpu *hyp_vcpu;
>  	struct pkvm_hyp_vm *hyp_vm;
>  	int ret;
> =20
> -	hyp_vcpu =3D map_donated_memory(vcpu_hva, sizeof(*hyp_vcpu));
> +	hyp_vcpu =3D hyp_alloc(sizeof(*hyp_vcpu));

[Severity: High]
Will this allocation guarantee the 16-byte alignment required by
struct pkvm_hyp_vcpu?

The struct embeds a struct kvm_vcpu, which contains a struct
user_fpsimd_state with a __uint128_t vregs[32] array. The C ABI and
AAPCS64 mandate strict 16-byte alignment for 128-bit types.

If hyp_alloc() only guarantees 8-byte alignment (since its MIN_ALLOC_SIZE
is 8), returning an 8-byte aligned pointer could trigger an alignment fault
during compiler-generated SIMD instructions (like LDP Qx, Qy) when
saving or restoring FPSIMD state, potentially leading to a hypervisor panic.

>  	if (!hyp_vcpu)
> -		return -ENOMEM;
> +		return hyp_alloc_errno();
> =20
>  	hyp_spin_lock(&vm_table_lock);

[ ... ]

> diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> index 8a8b5b84825c7..1899b05d9fc22 100644
> --- a/arch/arm64/kvm/pkvm.c
> +++ b/arch/arm64/kvm/pkvm.c

[ ... ]

> @@ -153,28 +153,19 @@ static void __pkvm_destroy_hyp_vm(struct kvm *kvm)
> =20
>  	kvm->arch.pkvm.handle =3D 0;
>  	kvm->arch.pkvm.is_created =3D false;
> -	free_hyp_memcache(&kvm->arch.pkvm.teardown_mc);
>  	free_hyp_memcache(&kvm->arch.pkvm.stage2_teardown_mc);
>  }
> =20
>  static int __pkvm_create_hyp_vcpu(struct kvm_vcpu *vcpu)
>  {
> -	size_t hyp_vcpu_sz =3D PAGE_ALIGN(PKVM_HYP_VCPU_SIZE);
>  	pkvm_handle_t handle =3D vcpu->kvm->arch.pkvm.handle;
> -	void *hyp_vcpu;
>  	int ret;
> =20
>  	init_hyp_stage2_memcache(&vcpu->arch.pkvm_memcache);
> =20
> -	hyp_vcpu =3D alloc_pages_exact(hyp_vcpu_sz, GFP_KERNEL_ACCOUNT);
> -	if (!hyp_vcpu)
> -		return -ENOMEM;
> -
> -	ret =3D kvm_call_hyp_nvhe(__pkvm_init_vcpu, handle, vcpu, hyp_vcpu);
> +	ret =3D pkvm_call_hyp_req(__pkvm_init_vcpu, handle, vcpu);

[Severity: High]
Does this change bypass memory cgroup (memcg) accounting for the vCPU
allocations?

Previously, alloc_pages_exact() used GFP_KERNEL_ACCOUNT, which ensured the
memory was charged to the allocating process. By delegating the allocation
to the EL2 heap via pkvm_call_hyp_req(), a heap depletion will trigger a
top-up request (PKVM_HYP_REQ_HYP_ALLOC).

The host handler for this top-up (pkvm_hyp_topup()) uses
init_hyp_memcache(), which defaults to GFP_KERNEL and omits the
HYP_MEMCACHE_ACCOUNT_KMEMCG flag.

Could this allow an unprivileged userspace process to bypass memcg limits
and exhaust system memory by creating numerous VMs and vCPUs?

>  	if (!ret)
>  		vcpu_set_flag(vcpu, VCPU_PKVM_FINALIZED);
> -	else
> -		free_pages_exact(hyp_vcpu, hyp_vcpu_sz);
> =20
>  	return ret;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260706175415.2604=
046-1-vdonnefort@google.com?part=3D16
