Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0B5F395ADA
	for <kvmarm@lists.linux.dev>; Mon,  3 Aug 2026 11:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785754925; cv=none; b=gqbs/gm8WcVBXnUpnodqQsNLBs9pzDCbrEffa8iKu0vgKSAE1I0MpVuXe5AlNLKMXNIbmzWkdCphMxRmZybAzavayjHUxgvxE6JszpN7eV139SMkevBhoS/XnOshAqwVwm3m7Ean0s+vBVUkR9BixU2eJEWFEQr9UQ54ki63bj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785754925; c=relaxed/simple;
	bh=8nIp4rTRyMi6m7lYN2shotsulP1ixXhChN+xohCcJ5Q=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=dTmzyKKqi1ubidSX0VR+QsD6qix69HrEV30BO8cbVvhN9a7dwjCQQd23kLjz//qsMGp6ubvRFPMVGYYjsxxlHiNHpKQL5ezQcK+oRM3RrkP/PPYnHNXDolKi2wdbShojAlogiYng95OwD1PIPPNWabkAUvnh6x7gAhu4wcchOu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FjZCiu58; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FjZCiu58"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EB441F000E9;
	Mon,  3 Aug 2026 11:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785754923;
	bh=DtotBHbv2NMWZRk2BOiT7/5uMkbgtrD+rDGLME/GMSU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FjZCiu58XzfuyMB4wWLxxH2avMFAxmkrPyWzrg4lEPvYOyi2FFSmNf/820pAuhbFy
	 vNt7r3nT/9EJBspN4Y31cB4wDo/Fk7cKSML7Lj/NKxCsETgqcQSpr01Rr3/HDIIGme
	 mZBcemMMZFZ10MnjVlpFL0zSeoSR7gqQ1Hr77HYskdkDtfY0BimCLUMKZ4+1PbdH5d
	 ZChwDIxYpXiQ9mOm4y9oQ6N5liEiw8LF/a4Sl8ucceGMLDmCCUDvyk7lPsjL1JiS26
	 ICotqtY6EcCstDoZ0lRaO6IVOq/viNxRGa4/sqEHxSFEnu13+ae0jY7/Q7obJw8uB1
	 9YaKbMXUd8Aew==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 19/20] KVM: arm64: Raise PKVM_HYP_REQ_SPLIT on guest to
 host sharing
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vincent Donnefort" <vdonnefort@google.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260803100904.3563942-20-vdonnefort@google.com>
References: <20260803100904.3563942-1-vdonnefort@google.com>
 <20260803100904.3563942-20-vdonnefort@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 03 Aug 2026 11:02:02 +0000
Message-Id: <20260803110203.0EB441F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Concurrent MEM_SHARE or MEM_UNSHARE on the same huge block causes =
the VM to be terminated with -EINVAL.
--

--- Patch [19]: [PATCH 19/20] KVM: arm64: Raise PKVM_HYP_REQ_SPLIT on guest=
 to host sharing ---
commit 267c394d1b60753f90e3da486356d60c47b19643
Author: Vincent Donnefort <vdonnefort@google.com>

KVM: arm64: Raise PKVM_HYP_REQ_SPLIT on guest to host sharing

Pages shared by the guest with the host are annotated into the guest
stage-2. If the shared page is backed by a huge mapping, we need to
split it first.

> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkv=
m.c
> index 3b8e95b83bf45..57f4303aede10 100644
> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c

[ ... ]

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

[Severity: High]
Does this code handle concurrent MEM_UNSHARE or MEM_SHARE requests on the
same huge block correctly?

If two guest vCPUs concurrently execute HVC MEM_SHARE (or MEM_UNSHARE) on
different pages within the same PMD_SIZE stage-2 block, both vCPUs would
receive -E2BIG from get_valid_guest_pte() in EL2 and exit to the host with
PKVM_HYP_REQ_SPLIT.

Host thread A successfully handles the split request, splitting the block in
EL2 and the host's pkvm_mappings tree.

When host thread B handles the split request for the same block, it looks up
the mapping in __pkvm_pgtable_stage2_split():

arch/arm64/kvm/pkvm.c:__pkvm_pgtable_stage2_split() {
    ...
	mapping =3D pkvm_mapping_iter_first(&pgt->pkvm_mappings, ipa,
					  ipa + size - 1);
	if (!pkvm_mapping_can_split(mapping)) {
		ret =3D -EINVAL;
		goto unlock_mmu;
	}
    ...
}

Because it finds a PAGE_SIZE mapping (since it was just split),
pkvm_mapping_can_split() returns false, causing __pkvm_pgtable_stage2_split=
()
to return -EINVAL instead of returning 0 (success) or -EAGAIN to retry.

This -EINVAL error propagates up through pkvm_hyp_req_handle_split() and
handle_exit(), returning -EINVAL to userspace from KVM_RUN, which causes the
VMM to terminate the VM.

> +	}
> +
> +out_guest:
> +	return true;
> +out_host:
> +	return false;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260803100904.3563=
942-1-vdonnefort@google.com?part=3D19
