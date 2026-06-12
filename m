Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29A1537475C
	for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 14:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781275423; cv=none; b=GrHnjsppfIYoT9WaGFs9VVl98unq3XHRaRl+3TuLq2iKPr/ROJdE9ia6h5Qv4dzsrWasHszbxZvEDa2qKCEfkR7LxhfSGhyr2NGdKYVI7mfyliDt/5qa2+M6uhxAL0i4DCAjMoBpg0uJuuYCrCbcA5OXS3YaJ0OHh1P2SSXbr6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781275423; c=relaxed/simple;
	bh=z5BkPLC1tXmZLciJ5+gttuc8QQ2HMOV7U40B+QW2YyE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=JKD8+jZyaf0b9gj+NzvZIq0hmrq2Y6nA6PFsZY+oog9NDHLssfaSf39lxiyf9TTihSmlD0ZpkLoJmi/Pto25iErTlSrKKpSUq0gAbHnlxGGkcuHi8mDTdJM/b6yfrPr2+YfS1UdSVEs7po2hSDB4yBUT7QRUo+lkKI+kzuApDgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ALzxeCmh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ALzxeCmh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD14C1F000E9;
	Fri, 12 Jun 2026 14:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781275421;
	bh=iLKdZleKhu+FBplW4PCxbaOdPpAJwWuttMh7f3hWzHA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ALzxeCmhohCe7v7gYe0Krxcep3ikDHClB4kFMh96BveKO5fXsvbqVL1kqO0pTd+yt
	 HrUTjr9XC+I8tvR7PHVDcjApG90QFaF2gF2orE/eD1+9EGgNdz6MYWsnUxYuY6vbWq
	 G1fD8CNwYNlQcdXHPtxVNLwTTqCmEroTh8uc15OUr3JnB4skroXVr0QFIKZ4NRiU4M
	 I4pQNvOvo34xqUJnxsWKHfT0As62v7ej/Iu7+rLEfBOJmume5MLKJTQPh79lQXPcpo
	 qjMWgxJXyV02/WRaarah1bJFWae+hH58U2viDFwaW2XTwDQAwCACDyXoMILLojO95e
	 VOOXYwoFs9iiw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 1/4] KVM: arm64: Allow early calls to pKVM
 host_share/unshare_hyp
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vincent Donnefort" <vdonnefort@google.com>
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260612142245.1015744-2-vdonnefort@google.com>
References: <20260612142245.1015744-2-vdonnefort@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 12 Jun 2026 14:43:40 +0000
Message-Id: <20260612144341.AD14C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [High] State desynchronization and memory leak when kvm_call_hyp_nvhe(__p=
kvm_host_share_hyp) fails.
- [High] State desynchronization when kvm_call_hyp_nvhe(__pkvm_host_unshare=
_hyp) fails.
- [Medium] Memory leak in hyp_trace_buffer_alloc_bpages_backing() when __ma=
p_hyp() fails.
--

commit e75dd763b7286e9546dc81b03c493cbab89745cf
Author: Vincent Donnefort <vdonnefort@google.com>

KVM: arm64: Allow early calls to pKVM host_share/unshare_hyp

The hypervisor tracing for pKVM relies on the __pkvm_host_share_hyp and
__pkvm_host_unshare_hyp HVCs. In order to start tracing as early as
possible, allow those two HVCs before the host is deprivileged.

> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kv=
m_asm.h
> index 043495f7fc78b..fb049c40d04f4 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -89,12 +89,12 @@ enum __kvm_host_smccc_func {
>  	__KVM_HOST_SMCCC_FUNC___vgic_v3_restore_vmcr_aprs,
>  	__KVM_HOST_SMCCC_FUNC___vgic_v5_save_apr,
>  	__KVM_HOST_SMCCC_FUNC___vgic_v5_restore_vmcr_apr,
> +	__KVM_HOST_SMCCC_FUNC___pkvm_host_share_hyp,
> +	__KVM_HOST_SMCCC_FUNC___pkvm_host_unshare_hyp,
> =20
>  	MARKER(__KVM_HOST_SMCCC_FUNC_PKVM_ONLY),
> =20
>  	/* Hypercalls that are available only when pKVM has finalised. */
> -	__KVM_HOST_SMCCC_FUNC___pkvm_host_share_hyp,
> -	__KVM_HOST_SMCCC_FUNC___pkvm_host_unshare_hyp,

[Severity: High]
This isn't a bug introduced by this patch, but while looking at
__pkvm_host_share_hyp, I noticed an issue in share_pfn_hyp() in
arch/arm64/kvm/mmu.c when the hypercall fails:

arch/arm64/kvm/mmu.c:share_pfn_hyp() {
    ...
	rb_insert_color(&this->node, &hyp_shared_pfns);
	ret =3D kvm_call_hyp_nvhe(__pkvm_host_share_hyp, pfn);
unlock:
	mutex_unlock(&hyp_shared_pfns_lock);

	return ret;
}

If the hypervisor rejects the share operation and returns an error, the
tracking object is left in the RB tree without rolling back the insertion
(using rb_erase and kfree).

Could subsequent calls to share_pfn_hyp() for the same PFN find this stale
node, increment its reference count, and return success without actually
making another hypercall? This seems like it could leave the host thinking
the page is shared while the hypervisor does not.


[Severity: High]
This is a pre-existing issue, but I also noticed a similar problem with
__pkvm_host_unshare_hyp in unshare_pfn_hyp() in arch/arm64/kvm/mmu.c:

arch/arm64/kvm/mmu.c:unshare_pfn_hyp() {
    ...
	rb_erase(&this->node, &hyp_shared_pfns);
	kfree(this);
	ret =3D kvm_call_hyp_nvhe(__pkvm_host_unshare_hyp, pfn);
unlock:
	mutex_unlock(&hyp_shared_pfns_lock);

	return ret;
}

The tracking node is destroyed unconditionally before verifying that the
hypervisor successfully executed the unshare operation.

If the hypercall fails, does the host irrevocably lose track of the sharing
state? It appears this would create a mismatch where the hypervisor still
considers the page shared, potentially leading to memory corruption or
invalid ownership transitions later.


[Severity: Medium]
This is a pre-existing issue, but since tracing relies on these hypercalls,
I spotted a memory leak in the error path of hyp_trace_load() in
arch/arm64/kvm/hyp_trace.c:

arch/arm64/kvm/hyp_trace.c:hyp_trace_load() {
    ...
	ret =3D hyp_trace_buffer_alloc_bpages_backing(trace_buffer, size);
	if (ret)
		goto err_free_desc;
    ...
err_free_backing:
	hyp_trace_buffer_free_bpages_backing(trace_buffer);

err_free_desc:
	free_pages_exact(desc, desc_size);
	trace_buffer->desc =3D NULL;

	return ERR_PTR(ret);
}

If __map_hyp() fails inside hyp_trace_buffer_alloc_bpages_backing(), it
returns the error to hyp_trace_load(), which then jumps directly to
err_free_desc.

Will this bypass the err_free_backing label and cause the backing pages
allocated in hyp_trace_buffer_alloc_bpages_backing() to be permanently
leaked?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260612142245.1015=
744-1-vdonnefort@google.com?part=3D1
