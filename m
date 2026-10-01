Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC0483E172B
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 15:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790869590; cv=none; b=EKkTdaVhp5V9AMCyzMrFZxuX3cf4vXSMa7lcB+yXC7mWZcwAgWHgDBLJ+UYiFXbbRpDjfgfBS0UHH2fevQERHH59l8tzGP05sBFzNAeQf/aZVE7WNxETdPDrlnvjHcfBFIoE8rwm27ETxticMzwpHqtcgLmjRoPvPj1nR0tNOL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790869590; c=relaxed/simple;
	bh=1oUlzvL/JztTRvxT3r/9V4iE5fQ8u5Ozqr/ZFWmg/i0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=KBVSMfiXir8RrIl9QI79SUfRmfTb+r8FkAMcbNobpQw/CfJOVNQbFO0bMIYCmAOdbsL3Ck+eYc2N5GVyHA9P6WxlsYQN/wdun/u1bSfiYNuG/Uql+pCVE5UeA5OlDvYs7IRHE1mUqH2KKkqDnAV4w62xFHzl128eHFyXTngrqu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZVAfKE2/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZVAfKE2/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DD051F00898;
	Thu,  1 Oct 2026 15:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790869588;
	bh=n57wUY9SrDSn+8yMz0KlSRzUmfWLAu1rJddMWjGjbJg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZVAfKE2/7gVMTRTZ7R5oUfii28gUBAxlA9Fp2gD37U9zO1P8nkbJ3Inbzh1DLWh9J
	 38OZ+ECmiseevbdM3N+ZIipC1im2vW9kyicQCeYGLqabfYpmqJMMGiYKWWYK73hDao
	 ug8xhl0L5VH7d0P7URX4CsA5krHl24z6wf7HWh+VB+/LGvvurVRQk8bCWOIaGPqBWF
	 /Eyc+ShZRRbwHKgaes5Imr4qgm6GUFK5CMoAxR+f3U6Dx50nToJDwR5BhWbQo3OOFf
	 TsVnw0yzs1AtcQmsiRXc+jsXRt8uGuK7q5WtmUUlyIdc9mWm5e++dy8P1vT9eGGeZv
	 RqxdCitmlwtfA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 14/18] KVM: arm64: Alloc pkvm_hyp_vcpu using pKVM
 heap allocator
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vincent Donnefort" <vdonnefort@google.com>
Cc: "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20261001142849.3367614-15-vdonnefort@google.com>
References: <20261001142849.3367614-1-vdonnefort@google.com>
 <20261001142849.3367614-15-vdonnefort@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 01 Oct 2026 15:46:27 +0000
Message-Id: <20261001154628.5DD051F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] mm: memcg accounting bypass for pkvm_hyp_vcpu in pKVM heap top-up
--

commit 21d00ea4fd8fbddce7df56c53bb28890af94ad7f
Author: Vincent Donnefort <vdonnefort@google.com>

KVM: arm64: Alloc pkvm_hyp_vcpu using pKVM heap allocator

This commit transitions the allocation of the hypervisor vCPU state structu=
re
to EL2 using the new pKVM heap allocator. The host now uses
pkvm_call_hyp_req() to invoke __pkvm_create_hyp_vcpu, handling any EL2 memo=
ry
top-ups automatically.

> diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> index 8505965dbfb21..36e677e51f7d6 100644
> --- a/arch/arm64/kvm/pkvm.c
> +++ b/arch/arm64/kvm/pkvm.c
[ ... ]
> @@ -174,28 +174,19 @@ static void __pkvm_destroy_hyp_vm(struct kvm *kvm)
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

[Severity: Medium]
Does this replace an accounted host allocation with an unaccounted EL2 top-=
up?

Previously, pkvm_hyp_vcpu was allocated directly by the host using
GFP_KERNEL_ACCOUNT. Now, it triggers an EL2 allocation which, if it runs
out of memory, requests a top-up via PKVM_HYP_REQ_HYP_ALLOC.

The host handles this top-up request in pkvm_hyp_topup() using:

	init_hyp_memcache(&mc);
	ret =3D topup_hyp_memcache(&mc, nr_pages);

Because init_hyp_memcache() initializes mc->flags to 0, it omits the
HYP_MEMCACHE_ACCOUNT_KMEMCG flag. This causes the allocation in
hyp_mc_alloc_fn() to use GFP_KERNEL instead of GFP_KERNEL_ACCOUNT:

	gfp =3D memcache->flags & HYP_MEMCACHE_ACCOUNT_KMEMCG ?
		GFP_KERNEL_ACCOUNT : GFP_KERNEL;

Can an unprivileged userspace attacker exploit this by repeatedly creating
KVM virtual machines and vCPUs to bypass memory cgroup limits and exhaust
host memory?

>  	if (!ret)
>  		vcpu_set_flag(vcpu, VCPU_PKVM_FINALIZED);
> -	else
> -		free_pages_exact(hyp_vcpu, hyp_vcpu_sz);
> =20
>  	return ret;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261001142849.3367=
614-1-vdonnefort@google.com?part=3D14
