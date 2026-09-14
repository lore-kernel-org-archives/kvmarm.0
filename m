Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E575B35DA6E
	for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 08:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789373625; cv=none; b=n/zEEHrR3bp9cgomWwVtnrenwaJF5eJkh8yrGl7K7wFV4FzulvCnOl2l7Yx+VTH8swLIMWc36aUGqj2O1kR7IOeVD0I3BDwe8WIoBflFYAth6QZ4ZRNpVWbY0QB5mdAD51g4gCC+Gd8L2Yd639HKSBwU2fBCy13y9IL0VVwX/ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789373625; c=relaxed/simple;
	bh=3332vYASxIEtO54QWddAOWYU9gaD3TwuCQjW/OMCQJA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=YGXWln1YOa7xUat8wjT+84QOxi5DzQQa+8faZD5K+73KwNGO8di8vvq7BtYz9hv8aHw/RquxH3ymHJ+xetwAkC9gipC+Z7pOY9qlCmynRZHy1vkrmTtFDx8fMWRzRR8xS7JbvfxO1m/CY4G2MqAzaF9pyNJskoPQcPAJLkGMTzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cb8320s6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cb8320s6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FF891F000FF;
	Mon, 14 Sep 2026 08:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789373623;
	bh=oTpgFyyPUfkT/qKJ0CS/w03C/SIV/FYMCPELU9kBEJM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cb8320s6MG3ghssyKi3XqTZxvVOdA+LSwlueOmUvuiSjED1YvrA/oZa36YOsWUV4L
	 iaTniDrkPTzraHvgfaqj0hX/uGY4Y6djnq6jM/OMeuXBwoxr6ZMPyusUQcHuG7TDMr
	 kxUeBvm7HXuYDNI2iJNEQK9QH22bhFU0egjYYqZxgxSgQ7aXc3cuyy1RPgsjaC3g1/
	 SnVsubrxd2szRhGE2yroYdwZua2L8kNEyjI6RJo/0ObSWixtufu3Gft+B94+B8pCAx
	 9ZeJzDuew4XHRyXGRV+SRT44W7ZPWrEB8qkgB49f0QYxPOUCfQEB2/oEWb88DW8JzD
	 MnQ8n28n+3UtA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] KVM: arm64: Fix protected VM fault on system with
 pages larger than 4K
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vincent Donnefort" <vdonnefort@google.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260914075839.4019904-1-vdonnefort@google.com>
References: <20260914075839.4019904-1-vdonnefort@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 08:13:42 +0000
Message-Id: <20260914081343.4FF891F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] The patch incorrectly maps the guest PA (L1 IPA) instead of the gu=
est IPA (L2 IPA) in the shadow stage-2 page tables for nested VMs in `gmem_=
abort()`.
--

commit 3995ce8aa44bf10fe23cdc5e9257510868df129d
Author: Vincent Donnefort <vdonnefort@google.com>

KVM: arm64: Fix protected VM fault on system with pages larger than 4K

This commit aligns the fault IPA down to the page-size for protected VMs to
fix boot issues on systems with larger than 4K pages. It updates
pkvm_pgtable_stage2_map() to require page-aligned arguments and changes the
callers to pass gfn_to_gpa(gfn) instead of the raw fault_ipa.

Link: https://lore.kernel.org/all/20260913173516.3122436-1-vdonnefort@googl=
e.com/

> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 9ba86450fe4af..ee78201a44df1 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1672,10 +1672,10 @@ static int gmem_abort(const struct kvm_s2_fault_d=
esc *s2fd)
>  		 * PTE, which will be preserved.
>  		 */
>  		prot &=3D ~KVM_NV_GUEST_MAP_SZ;
> -		ret =3D KVM_PGT_FN(kvm_pgtable_stage2_relax_perms)(pgt, s2fd->fault_ip=
a,
> +		ret =3D KVM_PGT_FN(kvm_pgtable_stage2_relax_perms)(pgt, gfn_to_gpa(gfn=
),
>  								 prot, flags);
>  	} else {
> -		ret =3D KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, s2fd->fault_ipa, PAGE_=
SIZE,
> +		ret =3D KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, gfn_to_gpa(gfn), PAGE_=
SIZE,
>  							 __pfn_to_phys(pfn), prot,
>  							 memcache, flags);
>  	}

[Severity: High]
Does this change break nested virtualization by mapping the guest PA (L1 IP=
A)
instead of the faulting guest IPA (L2 IPA)?

For nested VMs handled in gmem_abort(), gfn represents the L1 IPA. By
switching from s2fd->fault_ipa to gfn_to_gpa(gfn) in both
kvm_pgtable_stage2_relax_perms() and kvm_pgtable_stage2_map(), the shadow
stage-2 page tables now incorrectly install the mapping at the L1 IPA inste=
ad
of the expected L2 IPA.

This results in the L2 guest continuously faulting at the same L2 IPA, lead=
ing
to an infinite fault loop (DoS for the nested guest) and shadow page table
corruption.=20

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914075839.4019=
904-1-vdonnefort@google.com?part=3D1
