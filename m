Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E906392C2A;
	Wed, 26 Aug 2026 23:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787786032; cv=none; b=dm37YNZ9xhJfMyUxRTS39VQ1gc+jCk3bbjofctJadsvTtHAOgai79man6owu2O/PZmTSMwDfXv9lhsmGJlc2rNu3Mr49oq5tQ6zqeiF6EIbNZYyU07/tLTzBdnmSUu+nFZ0SX86Nb2G9sTxSfkA5fA9Pe4R1AmZdGZyg0LhA/as=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787786032; c=relaxed/simple;
	bh=Dv/nhmHkmdGbbgf+w7B99Rs3brmZ7MoEF/g0515jht0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=IVoc/MBpePFvYMq7Ash5rt+TQq9AC7pau3ZbYXaxbgAh0Lp7Z4CwJLl7IFOKpLDBo688TjPM1/piIRfnD3cCbBBNIzNwdKlUfSl9OH9KwzBC9jbrOh2Gdn7ag4G6APV8ZJ1B2YFA/AepoBvxOBTdWIcHmGCmQNzdTyesZ/DIumw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=laB97RU1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="laB97RU1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAB381F000E9;
	Wed, 26 Aug 2026 23:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787786031;
	bh=vGNMkPzDuXPxa3PTwn75iGqbmfgqUaN8WVDy6rEaWNA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=laB97RU16bxU6Sjkq+0uyQ420k736vmgyq3eQ3a5RuFZYSNmDMvcyPup68k9+7Gto
	 ugPktI25C0Z1ofdU5uYCH1BcSsqFwLyRC+M/QZVFuuAK2DttmOnhf2+CyR4S8p0Cg2
	 AMBECRor1+i++o8iMZY4SdqxNzZU71CwTR7ym1wHskjqdaSHucNA9YQAYdglN2/+IM
	 naubRXV8uo//FlJStgDRgawxOaaeuXna7eHCJnHiz13njx6DHM2X79LBr5TRpymmzH
	 0wUHXDlCaIOazxqR8EkzQZDwPqPaDxkG0xb90aeiRZ8TMEgD3zet9pqFVAdzzlyyKo
	 H2sCiktHzxs5Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 01/20] KVM: selftests: Use MEM_REGION_PT memslot instead
 of '0' for s390 regions/segments
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sean Christopherson" <seanjc@google.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org
In-Reply-To: <20260826230511.972824-2-seanjc@google.com>
References: <20260826230511.972824-1-seanjc@google.com>
 <20260826230511.972824-2-seanjc@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 26 Aug 2026 23:13:50 +0000
Message-Id: <20260826231350.CAB381F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Out-of-bounds write (buffer overflow) when initializing guest page=
 tables in `virt_alloc_region`.
--

commit a213aecc3a3df3f801c303737240f0d76e5332fa
Author: Sean Christopherson <seanjc@google.com>

KVM: selftests: Use MEM_REGION_PT memslot instead of '0' for s390 regions/s=
egments

This commit updates the s390 virtual memory allocator to use MEM_REGION_PT
to indirectly specify the memslot instead of hardcoding it to 0. This is a
step toward taking the allocation type instead of the exact raw memslot in
the physical memory allocator.

> diff --git a/tools/testing/selftests/kvm/lib/s390/processor.c b/tools/tes=
ting/selftests/kvm/lib/s390/processor.c
> --- a/tools/testing/selftests/kvm/lib/s390/processor.c
> +++ b/tools/testing/selftests/kvm/lib/s390/processor.c
> @@ -39,7 +39,8 @@ static u64 virt_alloc_region(struct kvm_vm *vm, int ri)
>  	u64 taddr;
> =20
>  	taddr =3D vm_phy_pages_alloc(vm,  ri < 4 ? PAGES_PER_REGION : 1,
> -				   KVM_GUEST_PAGE_TABLE_MIN_PADDR, 0);
> +				   KVM_GUEST_PAGE_TABLE_MIN_PADDR,
> +				   vm->memslots[MEM_REGION_PT]);
>  	memset(addr_gpa2hva(vm, taddr), 0xff, PAGES_PER_REGION * vm->page_size);

[Severity: High]
This is a pre-existing issue, but does this memset cause a buffer overflow
when ri =3D=3D 4?

When ri =3D=3D 4, vm_phy_pages_alloc() allocates 1 page, but the memset bli=
ndly
clears PAGES_PER_REGION * vm->page_size (4 pages) with 0xff.=20

Since virt_arch_pg_map() unconditionally loops from ri =3D 1 to ri =3D 4, w=
ould
calling virt_alloc_region() with ri =3D=3D 4 write 3 pages past the end of =
the
allocation every time a page table is allocated on s390x, potentially
corrupting adjacent memory or causing a segmentation fault in the test proc=
ess?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260826230511.9728=
24-1-seanjc@google.com?part=3D1
