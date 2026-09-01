Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A0BB38A720
	for <kvmarm@lists.linux.dev>; Tue,  1 Sep 2026 08:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788251659; cv=none; b=FrlUuFOLQCHdETLo6NHfhp2yc/omlH0NvdQK9X4dez/7X5G2uLm9p1T82vXdzZiX34n8l0w2h9oxmeoIlmD7KLkWJhMqk9o10YCOS4btNiETa3kRSg+cNYmp3m4rbOBw2bJXJZG2XhiLyD4yP6HQbJ9s17QN8u67Jhs0tTqnjes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788251659; c=relaxed/simple;
	bh=zKbjMSCz2qrIGCHnmwbc/GdUkcfpqVCOSy5hlBxnHjs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=hlN7qM8sc3lNARBb+mOyf/S3S53do5rPWRaf7VML0FsVnIwD8VCop8m8BVRuoxtey3CC4jRbAb/WhhSNY621U4Q91gBCi0wJu/4yM50KWxfWpniJYxJiN+W28P1b9NbpFfcYKsl9Q9WhnC9NXy5YiFFqEj2Mney2784q0/VBtH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kk9F9mTK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kk9F9mTK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E690A1F00A3D;
	Tue,  1 Sep 2026 08:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788251658;
	bh=HOpfP4vZ+r84k5Sv0GCQabgBe6hh67poC3d7A1kSx4k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Kk9F9mTKTEjmoM75GOZ0duDvtygN9bN0/3MtQA10NGrbuesMplka+OgE5bEoD31Jb
	 gndbF2HO+o2BaVqca6hvLIGVFMMGGLxoiPSZx1k3xJrl5cR0GnhIUrk9t84DqAZ4Vr
	 t8LD3hb8aPNl5IljR7p6YvissgztPH8ZT1U/1J20l2iAR7Wkvv7ie+2aZ/ko6dBPL1
	 a/PmtHk0dSw6UciG8QQyDmQCTscvhzwZTV0q+T5A2Q4mXmzh8GFFPbouBHxRsH6TYU
	 +5fsxAnYqfW/vXRRZA2g5d2S6UtdcsDe9Qj2jpafcKFFjBliQMsjw01jrdRG2EpAR8
	 AG93EYq8YGWPg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 14/18] KVM: arm64: Alloc pkvm_hyp_vcpu using pKVM
 heap allocator
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vincent Donnefort" <vdonnefort@google.com>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260901080941.997769-15-vdonnefort@google.com>
References: <20260901080941.997769-1-vdonnefort@google.com>
 <20260901080941.997769-15-vdonnefort@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 01 Sep 2026 08:34:17 +0000
Message-Id: <20260901083417.E690A1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Loss of memory cgroup (memcg) accounting for hypervisor heap top-u=
ps enables host memory exhaustion (DoS).
--

commit 1ea96bec624ff9de3986b5d4e5708b17bd70343c
Author: Vincent Donnefort <vdonnefort@google.com>

KVM: arm64: Alloc pkvm_hyp_vcpu using pKVM heap allocator

This patch transitions the allocation of the hypervisor vCPU state structure
(pkvm_hyp_vcpu) from the host to the hypervisor using the new pKVM heap
allocator. The host now uses pkvm_call_hyp_req() to invoke
__pkvm_create_hyp_vcpu, which automatically handles top-up requests if the
hypervisor runs out of heap memory.

> diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> index 8505965dbfb21..36e677e51f7d6 100644
> --- a/arch/arm64/kvm/pkvm.c
> +++ b/arch/arm64/kvm/pkvm.c
[ ... ]
> @@ -174,28 +174,19 @@ static void __pkvm_destroy_hyp_vm(struct kvm *kvm)
[ ... ]
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
Does this change lose memory cgroup (memcg) accounting for the hypervisor v=
CPU
allocations?

Previously, alloc_pages_exact() used GFP_KERNEL_ACCOUNT directly, ensuring
the allocation was charged to the caller's memcg. With this patch, the
allocation transitions to the EL2 heap. If the heap is exhausted,
pkvm_call_hyp_req() triggers a top-up request.

However, it appears the top-up path handles the allocation without the memcg
accounting flag. For instance, when the EL2 heap needs memory:

arch/arm64/kvm/pkvm.c:pkvm_hyp_topup() {
	init_hyp_memcache(&mc);
	ret =3D topup_hyp_memcache(&mc, nr_pages);
	...
}

Because init_hyp_memcache() explicitly omits the HYP_MEMCACHE_ACCOUNT_KMEMCG
flag, the subsequent allocation in hyp_mc_alloc_fn() uses GFP_KERNEL instead
of GFP_KERNEL_ACCOUNT:

arch/arm64/kvm/mmu.c:hyp_mc_alloc_fn() {
	gfp =3D memcache->flags & HYP_MEMCACHE_ACCOUNT_KMEMCG ? GFP_KERNEL_ACCOUNT=
 : GFP_KERNEL;
	addr =3D (void *)__get_free_page(gfp);
	...
}

Could this allow an unprivileged container with access to /dev/kvm to bypass
its memory limits by repeatedly creating VMs and VCPUs, potentially leading=
 to
host memory exhaustion?

>  	if (!ret)
>  		vcpu_set_flag(vcpu, VCPU_PKVM_FINALIZED);
> -	else
> -		free_pages_exact(hyp_vcpu, hyp_vcpu_sz);
> =20
>  	return ret;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260901080941.9977=
69-1-vdonnefort@google.com?part=3D14
