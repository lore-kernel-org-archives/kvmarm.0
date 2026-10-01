Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0AAC547059
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 15:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790869443; cv=none; b=c9qg6lSOjmc4xl4TX/Oj3xVEwaf22cDGe9RcSWAL15Niu6x31FYiFbaJ35IyXFAI5Kp6TJPgUIb2aq5dEbbFK+n3YlyePMjqcLEQwRtpAep7j3nUno9RzrDH0odKinU51fuxX0xKfdVpU44VYuhpjnWVaU2CJiOSfWE83jC8iVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790869443; c=relaxed/simple;
	bh=cexjKtI1U1qSwkxzpc2F384rZpe5XL3xVZx+TkpH9Fo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=So7+kbbFn38SPEX1mNbbq8t7vmN+fGYBwiWdWqxyvUn16d/BTfAPLIRTwebXlw+2DDnE/DFmuqnNB2RWHFnhSTIYvIO9NbphZJLMxYeaCbOl4EZJQqMQdbChyCZ1zwWcytcndKq3bNxCyzC5Tv4hoGNiSstmk8htGFq/GDgIHPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A9pIOlO1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A9pIOlO1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19DF41F00898;
	Thu,  1 Oct 2026 15:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790869438;
	bh=24IuG/aOfZ42e5qOhdBE6CEdR6ynjuynrQ7XnzJRNyQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=A9pIOlO1qUHj/aHGNoLmRL8Y9atekvFGPtJjhT5VzD7+TTi2uSVCLiaYhC9buIFop
	 b0Nn1Td8BxTTqLQkGLtOlkGSWrBSfPQ19kUxSsaWmVL5TmeSMWfsiwk0WOoYp+S9Xb
	 GPJErNuklQ8TvSLB1Te37ebX+CiL427bmYCWKiDmim2h7PAhOcFkjYckDXWUjNW0LF
	 nfC4yJEiprwwwsNpvvNfsqaE+0jwY+dDuOz+1/O6Ti2VJfEXue0dROEeIYPhd4cUTB
	 vOH6l09NLYIMfp/MEShFe9kY+6TL9aCTVtTuPD21Bi/dcH9M3Si15hmBK5n0spwwMj
	 6FZurmrbvZTVQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 13/18] KVM: arm64: Alloc pkvm_hyp_vm using pKVM heap
 allocator
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vincent Donnefort" <vdonnefort@google.com>
Cc: "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20261001142849.3367614-14-vdonnefort@google.com>
References: <20261001142849.3367614-1-vdonnefort@google.com>
 <20261001142849.3367614-14-vdonnefort@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 01 Oct 2026 15:43:57 +0000
Message-Id: <20261001154358.19DF41F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] kvm: arm64: memcg accounting bypass in pKVM hyp allocator top-ups
--

commit c6ba9fe98ea9532d6a486e0ae326359e821cd9d4
Author: Vincent Donnefort <vdonnefort@google.com>

KVM: arm64: Alloc pkvm_hyp_vm using pKVM heap allocator

Transition the allocation of the hypervisor VM state structure (pkvm_hyp_vm)
from the host to the hypervisor using the new pKVM heap allocator. The host
now uses pkvm_call_hyp_req() to invoke __pkvm_init_vm, automatically handli=
ng
any top-up requests if the hypervisor runs out of heap memory.

> diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> index ea96744f41fb0..8505965dbfb21 100644
> --- a/arch/arm64/kvm/pkvm.c
> +++ b/arch/arm64/kvm/pkvm.c
> @@ -230,28 +230,15 @@ static int __pkvm_create_hyp_vm(struct kvm *kvm)
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
Does this change bypass memory cgroup accounting for the VM structure?

The previous implementation explicitly used GFP_KERNEL_ACCOUNT to charge the
allocation to the calling process. By migrating the allocation to the
hypervisor, the memory is now satisfied by the host's unaccounted top-up
path.

When the hypervisor needs more memory and returns a top-up request, the
host handles this in pkvm_hyp_topup() using a temporary memcache:

arch/arm64/kvm/pkvm.c:pkvm_hyp_topup() {
    ...
    init_hyp_memcache(&mc);
    ret =3D topup_hyp_memcache(&mc, nr_pages);
    ...
}

Because init_hyp_memcache() clears all flags and drops
HYP_MEMCACHE_ACCOUNT_KMEMCG, top-up pages are allocated with GFP_KERNEL
instead of GFP_KERNEL_ACCOUNT.

Since KVM relies on memcg limits rather than static quotas to constrain VM
memory, could an unprivileged userspace process bypass its container memory
limits by creating numerous VMs, potentially exhausting host kernel memory
and causing a denial of service?

>  	if (ret)
> -		goto free_vm;
> +		goto free_pgd;
> =20
>  	kvm->arch.pkvm.is_created =3D true;
>  	init_hyp_stage2_memcache(&kvm->arch.pkvm.stage2_teardown_mc);
>  	kvm_account_pgtable_pages(pgd, pgd_sz / PAGE_SIZE);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261001142849.3367=
614-1-vdonnefort@google.com?part=3D13
