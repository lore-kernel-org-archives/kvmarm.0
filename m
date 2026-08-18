Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A50434028D9;
	Tue, 18 Aug 2026 09:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787045463; cv=none; b=M8GCV2upzNGWlFLsQpmX3nvwVRLRFPmTnmzc51SU+yOVT/txSjFT07nkLoicPDxdSMBW3Gb7Ke+5/rRFrWLfRirQ+8XOES9yYtx6UtZ7O4BpmFC0QslvkhNYdfnPTcWKncfCTksvnwSKYTyS8FPsTfhP89mwHWcTXvcMumsfO9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787045463; c=relaxed/simple;
	bh=zH2XG0yQHbYJo26rLCQlwgP/VDLB2Q5TIZ+mJ+Zp8Eg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=bbeS0Ei4fvkoAz3R3IUFTtaCweNKtKteyEXYvkElbcxWGB9yWYr+pD/ULMHMZBH1hxb1pUl26p0Mg8cC5zXa55XhOjkj5yVjtSeUUIu/4A3FxwnlVQ+U/X4w08x2N3MKTn0IJ8IZENbBrLtwLk5DzSvnak7VxuONYtIZYNgAoCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EsCCpvsJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EsCCpvsJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06F091F000E9;
	Tue, 18 Aug 2026 09:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787045462;
	bh=o+vfpjpgOc39vNsTj+Hh22TnoTdBcr4/j23WmKPBFSg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EsCCpvsJ7RKbl4o2MjoDM5ZDmJUeLvDTrofCAPqmAc3CYYZK8FqHgKeXFLx2zpZux
	 AfMfu1QM/MtDL/uALdmIntbRpzh34a2E5wevWNNwGQLPubbR2O/WnRKOejMHRmlBgl
	 3v4/cpDnAUo+HdGIr3q9CE7l0xHoe2cKjh3Rd8bt+kZ6+WLC4P5prCj1olvT9ZAoQv
	 u/qxMzUGx7RxXBruxLtTHY8hqzPEBoYxXseC9xIvvhWs+rX3Iil0P5iSobI8cC7GU3
	 hk+iupxE0kR64t5NeEM0Ah+eXssxyXr69tWc2zGSEyW7QujJNNrEFSEj0a8KF7l+3E
	 FVOFNcLAq/4gA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 4/4] KVM: guest_memfd: Stop returning struct page
 from PFN lookup
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ackerley Tng" <ackerleytng@google.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260818-gmem-no-return-page-v2-4-5298f42d49bb@google.com>
References: <20260818-gmem-no-return-page-v2-0-5298f42d49bb@google.com>
 <20260818-gmem-no-return-page-v2-4-5298f42d49bb@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 18 Aug 2026 09:31:01 +0000
Message-Id: <20260818093102.06F091F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Concurrent execution of KVM_SEV_SNP_LAUNCH_UPDATE and a vCPU p=
age fault triggers a race condition leading to a host kernel panic.
--

--- Patch [4]: [PATCH v2 4/4] KVM: guest_memfd: Stop returning struct page =
from PFN lookup ---
commit 766989bc1910148a83bffa481ae22b1d1eb71f01
Author: Sean Christopherson <seanjc@google.com>

KVM: guest_memfd: Stop returning struct page from PFN lookup

This commit stops returning a refcounted struct page from guest_memfd PFN
lookups, dropping the folio reference immediately instead. This prevents
concurrent guest page faults from holding elevated refcounts that would
interfere with in-place memory conversions between shared and private state=
s.

Link: https://lore.kernel.org/all/anZ4W9o5pTWIEgMY@yzhao56-desk.sh.intel.co=
m/

> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index b596486d184ca..589762140c3ef 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c

[ ... ]

> @@ -780,11 +779,7 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_mem=
ory_slot *slot,
>  #endif
> =20
>  	folio_unlock(folio);
> -
> -	if (!r)
> -		*page =3D folio_file_page(folio, index);
> -	else
> -		folio_put(folio);
> +	folio_put(folio);
> =20
>  	return r;
>  }

[Severity: Critical]
This is a pre-existing issue, but is it possible for a concurrent page
fault to trigger a host kernel panic via a hardware RMP fault here?

Looking at kvm_gmem_get_pfn() in virt/kvm/guest_memfd.c, if the folio is
not up to date, it zeroes the page and marks it up to date:

    if (!folio_test_uptodate(folio)) {
        clear_highpage(folio_page(folio, 0));
        folio_mark_uptodate(folio);
    }

However, in the KVM_SEV_SNP_LAUNCH_UPDATE path, __kvm_gmem_populate()
fetches a folio, unlocks it, and calls post_populate() (which maps to
sev_gmem_post_populate() and calls rmp_make_private()) before finally
marking the folio up to date.

If a malicious userspace process races a vCPU page fault against
KVM_SEV_SNP_LAUNCH_UPDATE, could the vCPU thread running kvm_gmem_get_pfn()
acquire the lock on the not-yet-uptodate folio and call clear_highpage()
after rmp_make_private() has already executed?

If clear_highpage() writes to the page after it has been made RMP-private,
this would trigger a fatal hardware RMP fault on the host CPU. If it writes
just before, it appears it could silently corrupt the encrypted firmware
payload.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260818-gmem-no-re=
turn-page-v2-0-5298f42d49bb@google.com?part=3D4
