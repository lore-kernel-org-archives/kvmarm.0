Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AB5D32824B
	for <kvmarm@lists.linux.dev>; Fri, 11 Sep 2026 14:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789136073; cv=none; b=lSODBjyveD5M2Cs18Rjzj/admaTJVpHo4n/+V73QsUlP2vkGw3q+azxM3q6kPwPJf974gfF6HzzHlQnndXVZERnZfEtdVpaA375f8jJ7woyfmwVveyT6QumZnb3scmRmqa/mWb/9iqsnw5sxDvTBZG/5vSiBM6878SsVzF2qt90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789136073; c=relaxed/simple;
	bh=pDUN6d9xf/0Ulv2yBbDG+SaBrY/qmiZW0EilfI6Nl14=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=mUsuiGDSe/NOkIL9yp+YMAz/pRH0PdJOYvOr/lTsNKBirJXQm6G2AEIzm6T5dMMOZXdRfLCKu2Gv1Ce2ASwTZ8WkNr3ojedBHvXd4R2JeuZn7XS8pJjUICXF6+9bXV2lj87M/huV62COnyK+zi4tAQq+D5VhFy14omL5q+tju2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DsdezBld; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DsdezBld"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CA051F008A2;
	Fri, 11 Sep 2026 14:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789136071;
	bh=uhiEkK7UzITRRpRszCuyQ+mu/5yUf0Hn7ecNX/FbbzA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DsdezBld4QdhYtI0rw3VHIj1QHQcEhxBm2Yslk/WjCHUqSR1IvaLnNzIoyae7JyLm
	 NkBJNy/VGA44EqvWVOJqPJ52ctc96k3B1eNWI8bAP9F3DYXPGW2H0POC9jaK6wGQT0
	 VW9wCJSMaSewmEAvWnigVjevTbnvfVNS5SDNWQWfnN5mvcN9qx2+EdCM1/F+EEoQ1m
	 8X9v+Lmgrmzt/g4mRZSmu7Btencp/tNk0btVgwstyfpEXBv0tBDrbTVVGWYVqpSj6j
	 OUUXkuHqN61x7luSjTr4Fxlm8gDYhX1zR45soFCri9ox/3Swj47ncsARP0KauKOgfm
	 XKtD4pKOuzD/A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 05/22] KVM: arm64: Make pKVM ownership selftest an
 HVC
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vincent Donnefort" <vdonnefort@google.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260911135053.146435-6-vdonnefort@google.com>
References: <20260911135053.146435-1-vdonnefort@google.com>
 <20260911135053.146435-6-vdonnefort@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 11 Sep 2026 14:14:31 +0000
Message-Id: <20260911141431.9CA051F008A2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Exposing the pKVM ownership selftest as an HVC allows the untruste=
d host to trigger an Out-Of-Bounds (OOB) write in hypervisor memory.
- [Medium] Missing NULL check on `init_selftest_vm()` return value leads to=
 an EL2 panic on malicious host input.
--

commit 8fb13365545b2fb6e99ef459c949f368c81f9f88
Author: Vincent Donnefort <vdonnefort@google.com>

KVM: arm64: Make pKVM ownership selftest an HVC

In preparation for testing the pKVM ownership with huge mappings,
refactor the selftest to be triggered via an HVC using dynamically
allocated memory from the host. This avoids wasting memory which would
be even worse for testing ownership transitions for huge stage-2
mappings.

> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/n=
vhe/mem_protect.c
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -1748,24 +1748,36 @@ static void assert_page_state(void)
[ ... ]
> +int __pkvm_ownership_selftest(u64 pfn, u64 pgtable_pfn, unsigned long pg=
table_nr_pages)
>  {
[ ... ]
> +	selftest_vcpu =3D vcpu =3D init_selftest_vm(hyp_phys_to_virt(hyp_pfn_to=
_phys(pgtable_pfn)),
> +						pgtable_nr_pages);
>  	vm =3D pkvm_hyp_vcpu_to_hyp_vm(vcpu);

[Severity: Medium]
Is there a possibility of a NULL pointer dereference leading to an EL2 panic
here? If the host issues the selftest HVC with pgtable_nr_pages set to 0,
init_selftest_vm() evaluates seeded < min_pages as true and returns NULL.
This NULL return is then unconditionally assigned to vcpu and immediately
dereferenced in pkvm_hyp_vcpu_to_hyp_vm(vcpu).

Should there be a check on the return value of init_selftest_vm() before
using it?

> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkv=
m.c
> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> @@ -762,7 +762,7 @@ static struct pkvm_hyp_vcpu selftest_vcpu =3D {
[ ... ]
> -struct pkvm_hyp_vcpu *init_selftest_vm(void *virt)
> +struct pkvm_hyp_vcpu *init_selftest_vm(void *virt, u64 nr_pages)
>  {
[ ... ]
>  	selftest_vm.kvm.arch.pkvm.handle =3D __pkvm_reserve_vm();
>  	insert_vm_table_entry(selftest_vm.kvm.arch.pkvm.handle, &selftest_vm);
>  	return &selftest_vcpu;
>  }
> =20
>  void teardown_selftest_vm(void)
>  {
> +	struct kvm_hyp_memcache *vcpu_mc =3D &selftest_vcpu.vcpu.arch.pkvm_memc=
ache;
> +	struct kvm_hyp_memcache mc =3D { 0 };
> +
> +	while (vcpu_mc->nr_pages)
> +		hyp_put_page(&selftest_vm.pool, pop_hyp_memcache(vcpu_mc, hyp_phys_to_=
virt));
> +
>  	hyp_spin_lock(&vm_table_lock);
>  	remove_vm_table_entry(selftest_vm.kvm.arch.pkvm.handle);

[Severity: High]
Can this sequence cause an out-of-bounds write in hypervisor memory?

If the host calls the __pkvm_ownership_selftest HVC when the VM table is
full, __pkvm_reserve_vm() fails and returns -ENOMEM. In init_selftest_vm(),
this negative error code is assigned blindly to the handle.

While insert_vm_table_entry() safely rejects the negative handle,
teardown_selftest_vm() unconditionally calls remove_vm_table_entry()
with it. Inside remove_vm_table_entry(), vm_handle_to_idx() converts
the negative handle into a massive 32-bit unsigned index without bounds
checking, resulting in an out-of-bounds write when vm_table[idx] =3D NULL
executes.

>  	hyp_spin_unlock(&vm_table_lock);
> +
> +	reclaim_pgtable_pages(&selftest_vm, &mc);
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260911135053.1464=
35-1-vdonnefort@google.com?part=3D5
