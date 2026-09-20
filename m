Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B38D447ACEB;
	Sun, 20 Sep 2026 21:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789940328; cv=none; b=iqtBTpSU7TYVmzNCRjKbOzLWUIahs9l4bkwRzUqk9+WvHLifP2mj8ArYuzwxWkQXZKbG57jZolw3dOgdsb2jJTWsHVhexcXN459ZP+t6yzwc9dUBQ1IcVTnG/BsYKBW7ZLyJ1yxuTzq9at6Xi108TdRqpQzqBOnAz4rQoTKXtYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789940328; c=relaxed/simple;
	bh=G1BBIx2Gf8U+dWpTIAGva/UtiTXBVUPy5h79F8Abp7s=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=R0ecVeXpV7+aYe2HWr1bppOQMKrgghy01LW37W1SUWQKbEFYmDqjHxLHx07o7QOIBTo0U1OfCYCRJ4jhs+mbqmV/k4nrRZxDCn7NxWsQ+bOLNIf8w27gzYWk/mNcB9VHgNhhz+ldNE+a1Hn1IjtN6/TgOW1AnPzhbVAXShVLPQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DquADkVr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DquADkVr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 411DE1F000FF;
	Sun, 20 Sep 2026 21:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789940318;
	bh=NiXnL7R3Ia8WFqWlgEzb7e90baUkz5w8lwWBHfm289I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DquADkVrVaPnPc/vj9H7vU+3JyR+bn/VNV0f3QGbjn7iJydctcnzLzMz8xlPw1I5A
	 YG9IDuhGFqhptfYZ3GePh3CYOt9VXZRqQ5SzAev9LMxfH0J3ZadzSlGNfTrNiz0L7i
	 Y63YpwSviVt3cLiPuljc4BWJt/N8j28CrrhgM/yTML1fL3Xh7Qq7WcHXFS5p+VFuCM
	 dhNcp6y+CmAWGPv77Q1v1u4iOiAGYcYp+bNTmELjkLGws3+25R8TL3aRINHuPtcmOe
	 ubAK6ZR+SfDHh5avK26fU1dbWWWO+Rqn0V3TVe9ngYV6bFbXNZ703Jx+DOAOgTn0RT
	 tOo+6/tDXhdTA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v19 05/20] KVM: arm64: Track the type of VM in kvm_arch
Reply-To: sashiko-reviews@lists.linux.dev
To: "Suzuki K Poulose" <suzuki.poulose@arm.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260920212845.707-6-suzuki.poulose@arm.com>
References: <20260920212845.707-1-suzuki.poulose@arm.com>
 <20260920212845.707-6-suzuki.poulose@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 20 Sep 2026 21:38:37 +0000
Message-Id: <20260920213838.411DE1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] kvm: arm64: missing READ_ONCE() when reading untrusted host_kvm =
vm_flavor at EL2
--

commit d04a2a8ee6aa64b39d1116da1e8bfebec72b4499
Author: Suzuki K Poulose <suzuki.poulose@arm.com>

    KVM: arm64: Track the type of VM in kvm_arch
   =20
    KVM arm64 has different types of VMs with all the different modes in wh=
ich
    the hypervisor code can be run. e.g., VHE, nVHE, pKVM etc. Then there is
    protected VM and normal VMs with pKVM. We might soon add other types,
    e.g., Arm CCA Realm.

> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkv=
m.c
> index 459bd9eb7e4bc..57e2eef6d7426 100644
> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> @@ -432,7 +432,11 @@ static void init_pkvm_hyp_vm(struct kvm *host_kvm, s=
truct pkvm_hyp_vm *hyp_vm,
> =20
>  	hyp_vm->host_kvm =3D host_kvm;
>  	hyp_vm->kvm.created_vcpus =3D nr_vcpus;
> -	hyp_vm->kvm.arch.pkvm.is_protected =3D READ_ONCE(host_kvm->arch.pkvm.is=
_protected);
> +	if (kvm_vm_is_protected(host_kvm))
> +		hyp_vm->kvm.arch.vm_flavor =3D VM_PROTECTED_PKVM;
> +	else
> +		hyp_vm->kvm.arch.vm_flavor =3D VM_PKVM;

[Severity: Medium]
Does init_pkvm_hyp_vm() evaluate the untrusted host memory directly without
READ_ONCE()?

The pKVM EL2 trust boundary requires that data from host memory must be
copied to private EL2 memory before validating or acting on it.

The macro kvm_vm_is_protected(host_kvm) evaluates host_kvm->arch.vm_flavor =
in
the condition. The previous code safely used
READ_ONCE(host_kvm->arch.pkvm.is_protected).

Could we wrap the host memory read with READ_ONCE() to prevent
compiler-induced tearing or optimization issues?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260920212845.707-=
1-suzuki.poulose@arm.com?part=3D5
