Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51ACF446C1D;
	Tue, 18 Aug 2026 09:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787045351; cv=none; b=omQn6t1wR4Rjy3rR9hPYG9lrDUDlpLZz/VFJQ5sRI6Xug7XuqUHWxdsBy0SNm1AF9Sc6ChG+n+zmoxPpVaCdibkXPrxpOlG8/byQ8jjkaQ6AVoAQhqWyo4wn8WfS/Ev+EwwcT3OaCsXzpiLbSbyaHVYgdfPec9DQ8hSDCZzyx2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787045351; c=relaxed/simple;
	bh=ZGgoGnpKb+3QcG7wSj4TZsOAeQwYj1/4MrdDyZFBWw8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=JhWBg8egkdXj1+1+wtr7NEW6bsIV5Vuowv0xqYdXUzSJGhtvsyuMftZu+f+CPo2/4v+gJh6yYkI9GUwIbCYI3e55bOlc70qpIcbTRDJ/9dptWgMbj7OOKsZs3eHGAzDP7otnjviz9OhWETdWr2MI6ldFu6ZuL4kzLl/DiDZFWwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mbUkPXfc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mbUkPXfc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBA151F00A3D;
	Tue, 18 Aug 2026 09:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787045350;
	bh=0rEA3tw2kz2jW+aADmMjINZPRtFOf2RmSZ6b95hUI5U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mbUkPXfcW1J3i/JrASeF1JDOk/Eulmuzp02pDmiiVF6yfexw6/FerBnhIjKPCCQo5
	 T6YHz9pWCVb8GYbLOYKKKMOcWaASm33oYVQ+2ET3Wx7aYgaUMDftHTyUqEqETzAaYi
	 u0mGZrIKq+LfrUsZ3W5kFJHcf6o8pSFBjIT2VKTsKO2xbMCCB/0zHPeipfrLK+c2cz
	 4WThDFnAz09AdhbNl0ZqBkPYFRFcT/JsgWiHAcTsrXEn+xWAoFzXZb1ZESb3oqD/L5
	 EAt3wI/D/V/aXaSc49HVfHxHDbCeGSHZYth9845kQaY7Ow1i0dkeW4zY3zq7m6jvfn
	 yPKCRMhoSvU0w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/4] KVM: SEV: Drop page refcount early during RMP
 fault handling
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ackerley Tng" <ackerleytng@google.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>, kvm@vger.kernel.org
In-Reply-To: <20260818-gmem-no-return-page-v2-2-5298f42d49bb@google.com>
References: <20260818-gmem-no-return-page-v2-0-5298f42d49bb@google.com>
 <20260818-gmem-no-return-page-v2-2-5298f42d49bb@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 18 Aug 2026 09:29:09 +0000
Message-Id: <20260818092909.DBA151F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Dropping the page refcount early introduces a race condition whe=
re a concurrent `guest_memfd` invalidation can trigger a false-positive 'Un=
expected RMP fault' kernel warning.
--

--- Patch [2]: [PATCH v2 2/4] KVM: SEV: Drop page refcount early during RMP=
 fault handling ---
commit 7d0f356d8592ce1804052b0fdb61fccf3a11ecaa
Author: Sean Christopherson <seanjc@google.com>

KVM: SEV: Drop page refcount early during RMP fault handling

When handling an RMP fault, KVM retrieves the PFN for a private GPA from
guest_memfd. This patch drops the page reference immediately after retrievi=
ng
the PFN instead of holding it across the entire handler, and adopts the MMU
invalidation protocol to guard committing anything based on the PFN.

> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index b2738362a928b..b34b11d7f8fad 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c

[ ... ]

> @@ -5030,18 +5031,22 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, =
gpa_t gpa, u64 error_code)
>  		return;
>  	}
> =20
> +	mmu_seq =3D kvm->mmu_invalidate_seq;
> +	smp_rmb();
> +
>  	ret =3D kvm_gmem_get_pfn(kvm, slot, gfn, &pfn, &page, &order);
>  	if (ret) {
>  		pr_warn_ratelimited("SEV: Unexpected RMP fault, no backing page for pr=
ivate GPA 0x%llx\n",
>  				    gpa);
>  		return;
>  	}
> +	kvm_release_page_unused(page);
> =20
>  	ret =3D snp_lookup_rmpentry(pfn, &assigned, &rmp_level);
>  	if (ret || !assigned) {
>  		pr_warn_ratelimited("SEV: Unexpected RMP fault, no assigned RMP entry =
found for GPA 0x%llx PFN 0x%llx error %d\n",
>  				    gpa, pfn, ret);
> -		goto out_no_trace;
> +		return;
>  	}

[Severity: Medium]
Since the page reference is dropped before this lookup in
sev_handle_rmp_fault(), could a concurrent guest_memfd hole-punch drop
the file's reference to the page and free it?

If the page is freed, the RMP entry would transition to shared/unassigned.
Could this then cause snp_lookup_rmpentry() to see the page as unassigned
and incorrectly emit this warning before the mmu_invalidate_retry_gfn()
check happens?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260818-gmem-no-re=
turn-page-v2-0-5298f42d49bb@google.com?part=3D2
