Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793653825;
	b=IcwjyE5Q9yUlTRCKFPtIXmhZ5/BPbtY+ss5MCmF9dlE5mTsxgY9F5o9P+UsbopWcb5hK
	 IerbEQqPODjuKBN8jtXF14r/ErKkVPDGhO181RGY1Uel9GbVg9OvYwHK8jDxaLUY+vXaO
	 5BbAJ3yEId9G0G5szpvMWIYGSLARc1i/qiU985IEtBrAI4eb7uh5PWCOjvDkQLQoNV7hv
	 TSgrorMNnPizjO4JiwPpa1muj0SNCG9epEatcEmhRWKJsGN+adFGma8nyk4G4MhZTILd2
	 aSojX2zSLFCS/Qek2bRueKGnfaJVw/LVf/qHJtZgxEFvnxlGbwxGR5LHO+zxiC8dyFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793653825;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Wlm2d+Fq1WMlOcQj4TO/7g8bQ/QFX9DP+H+2zPFCKJE=;
	b=wAfQcqdPNrR/fEE3sI9VUPTL86tg3F/h2d3GBdza6eyS79NWuxA9npEqj3kUdeGV+/1A
	 Ph4d0/KnSZznF9M0PQrw5hCk1NynJJVEyuD5F1rvpcP4PydYlxTUEP6sJK8u1JHwmFyWt
	 wgofXtf2iU6yH+xlJXNmDZvVk2bAZRywDKhL+yGu9s+Yy2no6JYX45qUVGZ0+6+r0HFTm
	 0RZHRO4IF8aG2aBKyRrMuAchds/dhPtjbVLJaJOKZDFr787j39IAjK6FTZSQyax95RR9D
	 cgs5gsQ6+zU1okWlrpraaZTiM52Sj0Uvu2oiwMUJ7+YJAicr/T9B6q10OFsbpU45BsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n+VldVZs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FEA3606A327
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 21:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n+VldVZs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A2451F00A18;
	Mon,  2 Nov 2026 21:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793653824;
	bh=Wlm2d+Fq1WMlOcQj4TO/7g8bQ/QFX9DP+H+2zPFCKJE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=n+VldVZsGqkFy5+47RJ8EYLKkfYItiuN3XNqKtqTj11dRUllSXIUv9De0WlB9JdCM
	 OcWown5+uylpzrhmmu76IC0lmjSeQkvdu0hNoZENuoboB+BAb5y266qPj8f/1OEOB1
	 01/VQWOH1e07OOqISXKK4oAfEB5WbgzD08ijnDbp8MMiMMIq92IMHPysfEKDOjICgV
	 5Kak6dY1oXjC762HkljucIzgJQ+YJkNb2KpPxg13Iaa8JMSurfvdW6vO+Czy+eT391
	 UUnz0WyVmDx2xR3lfkrrc9UtMZEIxFN7W7/nwKiQ81TkgmhYt2tE8mxBpWjN6/Omj6
	 u1zFsLNKU4EHQ==
Message-ID: <sashiko-outbox-194183@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 22/23] KVM: arm64: Raise PKVM_HYP_REQ_SPLIT on guest
 to host sharing
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vincent Donnefort" <vdonnefort@google.com>, kvmarm@lists.linux.dev
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261102204628.401871-23-vdonnefort@google.com>
References: <20261102204628.401871-1-vdonnefort@google.com>
 <20261102204628.401871-23-vdonnefort@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Nov 2026 21:10:24 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] KVM: arm64: unwanted block split and latent panic in pkvm_memuns=
hare_call()
--

commit 8b44fbe0de868cf9681f0eef63a65d11368c1c9d
Author: Vincent Donnefort <vdonnefort@google.com>

KVM: arm64: Raise PKVM_HYP_REQ_SPLIT on guest to host sharing

This commit raises a PKVM_HYP_REQ_SPLIT hypervisor request and rewinds
ELR_EL2 when a guest MEM_SHARE or MEM_UNSHARE hypercall encounters a huge
stage-2 block mapping (-E2BIG) so that the host can split the block and
replay the hypercall.

> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkv=
m.c
> index d92f4da1c1807..6c126fcc3831b 100644
> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c

[ ... ]

> @@ -1197,17 +1218,29 @@ static bool pkvm_memshare_call(u64 *ret, struct k=
vm_vcpu *vcpu, u64 *exit_code)
>  	return false;
>  }
> =20
> -static void pkvm_memunshare_call(u64 *ret, struct kvm_vcpu *vcpu)
> +static bool pkvm_memunshare_call(u64 *ret, struct kvm_vcpu *vcpu, u64 *e=
xit_code)
>  {
>  	struct pkvm_hyp_vcpu *hyp_vcpu;
>  	u64 ipa =3D smccc_get_arg1(vcpu);
> +	u64 gfn =3D hyp_phys_to_pfn(ipa);
> =20
>  	if (!PAGE_ALIGNED(ipa))
> -		return;
> +		goto out_guest;
> =20
>  	hyp_vcpu =3D container_of(vcpu, struct pkvm_hyp_vcpu, vcpu);
> -	if (!__pkvm_guest_unshare_host(hyp_vcpu, hyp_phys_to_pfn(ipa), 1))
> +	switch (__pkvm_guest_unshare_host(hyp_vcpu, gfn, 1)) {
> +	case 0:
>  		ret[0] =3D SMCCC_RET_SUCCESS;
> +		goto out_guest;
> +	case -E2BIG:
> +		*exit_code =3D pkvm_request_split(hyp_vcpu, gfn, 1);
> +		goto out_host;
> +	}

[Severity: Medium]
Should pkvm_memunshare_call() request a block split when
__pkvm_guest_unshare_host() returns -E2BIG?

In arch/arm64/kvm/hyp/nvhe/mem_protect.c, __pkvm_guest_unshare_host() calls
get_valid_guest_pte() before checking whether the page state is
PKVM_PAGE_SHARED_OWNED:

arch/arm64/kvm/hyp/nvhe/mem_protect.c:__pkvm_guest_unshare_host() {
	...
	ret =3D get_valid_guest_pte(vm, ipa, size, &pte, &phys);
	if (ret)
		goto unlock;

	ret =3D -EPERM;
	if (pkvm_getstate(kvm_pgtable_stage2_pte_prot(pte)) !=3D PKVM_PAGE_SHARED_=
OWNED)
		goto unlock;
	...
}

If a protected guest issues ARM_SMCCC_VENDOR_HYP_KVM_MEM_UNSHARE_FUNC_ID on
an IPA backed by an unshared (PKVM_PAGE_OWNED) PMD block mapping,
get_valid_guest_pte() sees size =3D=3D PAGE_SIZE against the level-2 block =
leaf
and immediately returns -E2BIG.

With this change, pkvm_memunshare_call() catches -E2BIG and exits to the
host via pkvm_request_split() to shatter the unshared 2MB block in both
guest and host stage-2 page tables (and split its pkvm_mapping into 512
entries), only for the replayed MEM_UNSHARE hypercall to fail the
PKVM_PAGE_SHARED_OWNED check with -EPERM.

Furthermore, if a PMD block were ever shared with the host in the future as
mentioned in the commit message, __pkvm_guest_share_host() ->
__host_set_page_state_range() installs a valid PKVM_HOST_MEM_PROT entry in
host_mmu.pgt (replacing the invalid donation metadata PTE). If
pkvm_memunshare_call() then triggers PKVM_HYP_REQ_SPLIT on that shared
block, the host split path calls:

  __pkvm_host_split_guest()
    -> host_stage2_split_gfn_meta()
      -> host_stage2_decode_gfn_meta()

which hits WARN_ON(kvm_pte_valid(pte)) and panics EL2:

arch/arm64/kvm/hyp/nvhe/mem_protect.c:host_stage2_decode_gfn_meta() {
	...
	if (WARN_ON(kvm_pte_valid(pte)))
		return -EINVAL;
	...
}

Would it be better not to request PKVM_HYP_REQ_SPLIT in
pkvm_memunshare_call() while MEM_SHARE is single-page only (or check the
guest PTE state before returning -E2BIG)?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102204628.4018=
71-1-vdonnefort@google.com?part=3D22
