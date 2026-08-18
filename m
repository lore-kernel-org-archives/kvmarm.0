Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFDBC43B6D2;
	Tue, 18 Aug 2026 09:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787045239; cv=none; b=eJkUUv++ZWyvG6bgEzw4SkvlBHY3nCkrHq8dAWHAvY0QKXpFpbGhzR04GOZoR2wYNtBX9ZaarN+Ain9oB+uh7OimmM8PWw5qkiJYXEl1sU6VFSYpb/hojUnNIqefzivkOZOHQvHPEMBQATpZsmMu/HvY0sUZBTylapcU5S15Dlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787045239; c=relaxed/simple;
	bh=y8TClyfQxq2E4+Rkz0/hbmO4+7Vod2AUGtiOc+bPwKo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=nWb8A7tONVfuQBup0PilB55WHuIfnP+Qw6Ky6QeyxW0oRoA42euAl/N+yD3lEM5Z6csF6YB/0C3+vYRkNSK18q/YqYg5rzIhRuhvWIQEqySCd0v64648a5b+EgWqK7cV0LG060UCIm2XoG0S/ghUS8DbBXg5Rt9IsMGQ+7V2560=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NBMlTbRE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NBMlTbRE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F4871F000E9;
	Tue, 18 Aug 2026 09:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787045237;
	bh=4YQhO6aHYpk8c1/jnOOz0yNaRvPZuDN81KrlNGR4pqk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NBMlTbREvb5qncUlZ8A6v9LA9NW8OSi/94/cr75Ja9r0HPrDAsNWVsXZy5BtYiho0
	 c3T9VuB8uTbdhMBMRGhXcouVpKhHFjWunXvZw5ATjKeXamN7iyhaGj01a/Yg/PHLoE
	 GUb53rEqipfJIe37RJDT45u5qIDueisbgSe26G1bfNPdIWT1cj/HuI2GNlFwkkfTnZ
	 Auu0Ozi1BbmvuasVPrgbKnFu1Ipz4SlixrP248gRapivBocE/btfobNCv+WTTdbnHY
	 xmxfWfg0CRU059YOUTg/hUoM2mFh+jfnUZf21r2ntxvSIBMvm29PJtNCv6WCQC2Xi2
	 d6itwRw+W3zkg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 3/4] KVM: SEV: Drop page refcount early in VMSA
 reload
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ackerley Tng" <ackerleytng@google.com>
Cc: "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260818-gmem-no-return-page-v2-3-5298f42d49bb@google.com>
References: <20260818-gmem-no-return-page-v2-0-5298f42d49bb@google.com>
 <20260818-gmem-no-return-page-v2-3-5298f42d49bb@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 18 Aug 2026 09:27:16 +0000
Message-Id: <20260818092717.3F4871F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] A preexisting vulnerability in `sev_gmem_make_shared` allows a=
 malicious SEV-SNP guest to cause a host kernel panic by transitioning a `g=
uest_memfd` page to VMSA state. When the page is subsequently freed, KVM fa=
ils to reclaim it and returns the still-firmware-owned page to the host pag=
e allocator.
--

--- Patch [3]: [PATCH v2 3/4] KVM: SEV: Drop page refcount early in VMSA re=
load ---
commit 597ff1c52e82911967f2122ff1d77aa79a4a2d9b
Author: Ackerley Tng <ackerleytng@google.com>

KVM: SEV: Drop page refcount early in VMSA reload

This commit modifies the guest VMSA reload path for SEV-SNP vCPUs to drop
the page reference immediately after retrieving the PFN from guest_memfd.
This avoids holding the reference across MMU lock acquisition and prepares
for future changes. The page's presence remains governed by KVM's MMU
invalidation protocol.

> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index b34b11d7f8fad..d3d620bc04dce 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -4062,6 +4062,7 @@ static void __sev_snp_reload_vmsa(struct kvm_vcpu *=
vcpu, gpa_t gpa)
>  	 */
>  	if (kvm_gmem_get_pfn(vcpu->kvm, slot, gfn, &pfn, &page, NULL))
>  		return;
> +	kvm_release_page_clean(page);
> =20
>  	read_lock(&kvm->mmu_lock);
>  	/*
> @@ -4076,8 +4077,6 @@ static void __sev_snp_reload_vmsa(struct kvm_vcpu *=
vcpu, gpa_t gpa)
>  	else
>  		svm->vmcb->control.vmsa_pa =3D pfn_to_hpa(pfn);
>  	read_unlock(&kvm->mmu_lock);
> -
> -	kvm_release_page_clean(page);
>  }

[Severity: Critical]
This is a pre-existing issue, but can this allow a malicious guest to
cause a host kernel panic?

Looking at sev_gmem_make_shared() in arch/x86/kvm/svm/sev.c:

arch/x86/kvm/svm/sev.c:sev_gmem_make_shared() {
    ...
		rc =3D rmp_make_shared(pfn, use_2m_update ? PG_LEVEL_2M : PG_LEVEL_4K);
		if (WARN_ONCE(rc, "SEV: Failed to update RMP entry for PFN 0x%llx error %=
d\n",
			      pfn, rc))
			goto next_pfn;
    ...
}

If an untrusted SEV-SNP guest modifies a guest_memfd page state to VMSA
using RMPADJUST, and the page is subsequently freed, rmp_make_shared()
will architecturally fail on the VMSA page.

Because the error is bypassed without calling snp_leak_pages(), the
firmware-owned page is returned to the host page allocator.

Could this lead to an RMP violation and a host kernel panic when the host
later attempts to access the freed page?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260818-gmem-no-re=
turn-page-v2-0-5298f42d49bb@google.com?part=3D3
