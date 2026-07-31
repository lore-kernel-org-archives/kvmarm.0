Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 205F142DA55
	for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 15:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785510267; cv=none; b=md+Ur+dBNhdYpeFCmaxxR+UzPN4QMV4b6bSQKOAzYax0zcKqXt3K7IMJ1No1c/IcOejjV3nBi2lo/I/+QUTaPHW7t7S72p+RpmuoJKa1Opc4ezNkJMgWV2ssrzEmzyzwRu3WcIMexVDfzs4u7WTlOcj0rcloYb2T8KbmzmzlUYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785510267; c=relaxed/simple;
	bh=PfaeGriOJVsPAnuKURjvzdIeg5vyj0XAcld4PXnM8kc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=tsVdbCsF9xJ9KymenHlCPRWsGMIqr2pfcJkra+xmlabpJQDRwQRtQOek2pKbJbMaqcqI8ATaZSIAWJ5MliMdHUps8zHQyYoqMUD3oq5UbSp5CgJr//o07xIGT0JTdCgreu5LwNNSWXEEXZpfnkoTfaEAVRail8CfO8yJdYE/CpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bNaEybyG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bNaEybyG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 858E31F00A3A;
	Fri, 31 Jul 2026 15:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785510265;
	bh=68lut/4oVpNfi3C4Z7FQr1mpSqRXyw5A/qlkUDAlm9E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bNaEybyGXjAR58raSga+fviO/rOthmstev7RvPASmrSJ5W+Rtwx5oasWt7EIKRYJ4
	 TkQu+Qc068Pb1D8DCBCmLf1Msxj9EFeGpsQf6K4edWBCrI2CrqZajTor7UbtAZpScW
	 zilbBJXXVfvOW8JiiU8wfJwU4ldJXwGX6fk9JI54HE56e6SW5INmsG1I2jI1atTkl3
	 gI3hBRMvLxKpanBIYyzpdHBxtnaQdwWZkyosEAI8Krdte6BB8Ia6yA4guX9zeY/v5N
	 ajn8LGYpClQi8hpaXHCwZImSJb1Dinj00T9oJnnvrXLRCXkWYXFP86MTZ6Q+odBLlW
	 uZLqSbICatpcA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 14/17] KVM: arm64: Alloc pkvm_hyp_vcpu using pKVM
 heap allocator
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vincent Donnefort" <vdonnefort@google.com>
Cc: "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260731143541.956291-15-vdonnefort@google.com>
References: <20260731143541.956291-1-vdonnefort@google.com>
 <20260731143541.956291-15-vdonnefort@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 31 Jul 2026 15:04:25 +0000
Message-Id: <20260731150425.858E31F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] The dynamic allocation of the hypervisor vCPU and VM state structu=
res via the pKVM heap allocator bypasses memory cgroup (kmemcg) accounting,=
 allowing an unprivileged userspace process to bypass memcg limits.
--

--- Patch [14]: [PATCH v4 14/17] KVM: arm64: Alloc pkvm_hyp_vcpu using pKVM=
 heap allocator ---
commit b0e52464780692d209150dd491713c25a5d1c1c0
Author: Vincent Donnefort <vdonnefort@google.com>

KVM: arm64: Alloc pkvm_hyp_vcpu using pKVM heap allocator
   =20
Transition the allocation of the hypervisor vCPU state structure (pkvm_hyp_=
vcpu)
from the host to the hypervisor using the new pKVM heap allocator. The host=
 now
uses the pkvm_call_hyp_req wrapper to handle top-up requests if the hypervi=
sor
runs out of heap memory.

> diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> index a9b85ad37787a..3b29b3f43ffa5 100644
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
Does this change unintentionally drop memory cgroup (kmemcg) accounting for
the vCPU state structure?

Previously, this structure was allocated with GFP_KERNEL_ACCOUNT. By switch=
ing
to pkvm_call_hyp_req() and relying on the EL2 heap top-up mechanism, it app=
ears
the accounting is bypassed. When the top-up path calls pkvm_hyp_topup(), it=
 uses
init_hyp_memcache() which lacks the HYP_MEMCACHE_ACCOUNT_KMEMCG flag. This
causes the host allocation in hyp_mc_alloc_fn() to fall back to GFP_KERNEL
instead of GFP_KERNEL_ACCOUNT.

Could this allow an unprivileged userspace process to bypass memcg limits by
repeatedly creating VMs and vCPUs, leading to a host out-of-memory conditio=
n?

While a previous commit noted that heap donations cannot be accounted for a
specific VM because they are shared and recycled, active VM and vCPU struct=
ures
remain in use for the lifetime of the VM and cannot be reclaimed by the new=
 pKVM
shrinker. This might allow a malicious tenant to systematically exhaust host
memory.

>  	if (!ret)
>  		vcpu_set_flag(vcpu, VCPU_PKVM_FINALIZED);
> -	else
> -		free_pages_exact(hyp_vcpu, hyp_vcpu_sz);
> =20
>  	return ret;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260731143541.9562=
91-1-vdonnefort@google.com?part=3D14
