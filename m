Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0985439E185
	for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 17:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784569284; cv=none; b=an+aw5OSfIvncFPjmg1iJhqGZPMdKQkQaf6l1v19FV85x+1dQlEopCbJTTqThnKTWs7uO7VxQJorvEH8iRuOGoL1hOdIVhdgdr+VIc8Gjijr5BDM6OkHYvLxtzvEA8cTgzTUDov+guKMkOjLuO4VstRkmfHvtpoAyqE4/qh9t6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784569284; c=relaxed/simple;
	bh=DvaacB3Mb5On56MJMYHrYXnivqLWMEpXurtA5LPTGT8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=TkEQoP+CcpE0VEiWI7lHB1MUb7TiBwtSpJg2j6IL3bvTO3QyBSJXkhddBetoC3qlkNe26qWgqD65qSwj+vVPtGRa8DVV2XfHKjJ3DnhJlfn885W6h0pqxMpYyxsDIZ7vsgEbYEo6vi6S02v4Pmr8wKat9W/q6qa6hKvrd01ImEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GPxUwBF6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GPxUwBF6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62C951F000E9;
	Mon, 20 Jul 2026 17:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784569282;
	bh=/LkDhx6cRFFOLcI+7Px7Uo6/TIwWcckc5aNZZFz39RY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GPxUwBF6it1jjYz9YUSRYEEDRR19FFk8+mgsPPjq+1S0Xfmbdgm/9ussVgTynLhIr
	 fi+rzENjXFaxPoFRhw5a5pV+3Aq2Hg41a/T8le59+Q85oz8K1TfU41dUOEpvuQ2U3e
	 Q6g0K7CIUO2cuQep1kgUOse1yea94kOgBSduinhVYJ5Feeu/hmJDLePNxm+7B+Tsaw
	 NHvZsg/y1kGYzLQb34yOSqm2ndy3kGaxOdSr/8RD2QsM5vJa2ru9+XNkTVTBseAsUA
	 JDlYhAg5lbwZwLEeCveSp5AFH8eRglipl/LvdKqhrgK5QqjKYQhkWq6q660plFWZBr
	 /Ns6v3OCe3YIg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 14/17] KVM: arm64: Alloc pkvm_hyp_vcpu using pKVM
 heap allocator
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vincent Donnefort" <vdonnefort@google.com>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260720171513.1415357-15-vdonnefort@google.com>
References: <20260720171513.1415357-1-vdonnefort@google.com>
 <20260720171513.1415357-15-vdonnefort@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 20 Jul 2026 17:41:21 +0000
Message-Id: <20260720174122.62C951F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Moving pkvm_hyp_vcpu allocation to the global EL2 heap allocator b=
ypasses memory cgroup (memcg) accounting and introduces a charge lifecycle =
mismatch.
--

--- Patch [14]: [PATCH v3 14/17] KVM: arm64: Alloc pkvm_hyp_vcpu using pKVM=
 heap allocator ---
commit cc29b34f40079b23129d4e94199fd0029bedc7c5
Author: Vincent Donnefort <vdonnefort@google.com>
Subject: KVM: arm64: Alloc pkvm_hyp_vcpu using pKVM heap allocator

This commit transitions the allocation of the hypervisor vCPU state
structure (pkvm_hyp_vcpu) from the host to the hypervisor using the new
pKVM heap allocator (hyp_alloc()). The host now uses pkvm_call_hyp_req()
to invoke __pkvm_create_hyp_vcpu, which automatically handles any top-up
requests if the hypervisor runs out of memory.

> diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> --- a/arch/arm64/kvm/pkvm.c
> +++ b/arch/arm64/kvm/pkvm.c
[ ... ]
> @@ -153,28 +153,19 @@ static void __pkvm_destroy_hyp_vm(struct kvm *kvm)
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
Does this transition to the EL2 heap allocator bypass memory cgroup
(memcg) accounting?

Previously, pkvm_hyp_vcpu was allocated with GFP_KERNEL_ACCOUNT. By
switching to pkvm_call_hyp_req(), top-up requests are handled by the host
using init_hyp_memcache(), which omits the HYP_MEMCACHE_ACCOUNT_KMEMCG
flag. This falls back to an unaccounted GFP_KERNEL allocation, which could
allow an unprivileged host-userspace process to exhaust host kernel memory
by repeatedly creating VMs and vCPUs.

>  	if (!ret)
>  		vcpu_set_flag(vcpu, VCPU_PKVM_FINALIZED);
> -	else
> -		free_pages_exact(hyp_vcpu, hyp_vcpu_sz);
> =20
>  	return ret;
>  }
> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkv=
m.c
> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
[ ... ]
> @@ -896,16 +872,15 @@ static int register_hyp_vcpu(struct pkvm_hyp_vm *hy=
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
Does using the global EL2 heap break the memcg lifecycle?

Even if the top-up were accounted during the host allocation, pages from the
global EL2 heap are not returned to the host upon VM teardown. This means t=
he
memory would remain charged indefinitely to the original container while be=
ing
reused for other VMs.

>  	if (!hyp_vcpu)
> -		return -ENOMEM;
> +		return hyp_alloc_errno();

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260720171513.1415=
357-1-vdonnefort@google.com?part=3D14
