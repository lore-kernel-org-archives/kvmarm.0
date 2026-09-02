Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE4C5349CE2;
	Wed,  2 Sep 2026 16:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788367828; cv=none; b=PorjjsLChg3Zyv/cqSD6iuMGezGpguaF/Uk6B6omxXwvggvOgGuza2Jc5Pc58MEUraz17EX2N9gv9/XVhuytvdO+/V8h7V8iTv68FEX4e29H5kmy2eWxyYIX+GnoJX1tbwE+ggHm4I5ftom+6IvxlpJzhOb1M8qSzVCvheJ6pRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788367828; c=relaxed/simple;
	bh=5kFE6fWNldy6npXcmkOgvu5bgRtTp6gJYODwWyIcYWA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=PbgzHCkMKlV6ivImH1rOHy0LAcSJ1zGB7iqSEuAQi+ooJdMFyAYMbfhYa7zJ4+7qNhurJMRcF1hfME3/10x6qgcfsOnu+TgjORjwDuYnLbE4mSZrdxRmSC1+w/+d67o2fn/6/DX7Lhr5KHROQeXqhoj5JLyjIqt2omBjTkTORfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W8uBPNbZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W8uBPNbZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 456F71F000E9;
	Wed,  2 Sep 2026 16:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788367826;
	bh=jXJ9q+tgTdnvFpG4GlzqeJAilk8If3NHT1HY+tYzkLg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=W8uBPNbZiYcT2iDumr5RcOKZkcZpGoXsNs/Bn1Vm5EyYl8O87QD5Mrcz9Ze7fzGp7
	 YjqPOydR+zmGu/U06eJ6qQcznyK5iDSFRnNEl8JrjoAFlLaC56xloclKmREsBwSksp
	 xgV0YixFMj7CgukljNjLqfA+3AIWJVrejYkzGxTakmzFIJfsJbK6tSMYOQ5lTrh/dQ
	 xE6h0kswvEbdddDSttZsEFQBYAToWuXX7vSZGiZCK3aCf6rUDk8bSfNYBlv7LETGQ/
	 G8vXdvqh+0s4aWOr1KjZD0D0X/Yy+IptSOMQvzu0Ao/vUO1OyjH/hPokytvGtnceOv
	 UQc1Zc2MepKXA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 01/20] KVM: selftests: Use MEM_REGION_PT memslot
 instead of '0' for s390 regions/segments
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sean Christopherson" <seanjc@google.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, kvm@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260902164123.2546762-2-seanjc@google.com>
References: <20260902164123.2546762-1-seanjc@google.com>
 <20260902164123.2546762-2-seanjc@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 02 Sep 2026 16:50:25 +0000
Message-Id: <20260902165026.456F71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [Medium] Out-of-bounds memory write in s390 `virt_alloc_region` due to mi=
smatched allocation and initialization sizes when setting up a page table.
--

commit 6a3a77e3cef84a1f8a83db6921ea5e3f5b11c1ed
Author: Sean Christopherson <seanjc@google.com>

KVM: selftests: Use MEM_REGION_PT memslot instead of '0' for s390 regions/s=
egments

This commit updates s390's virtual memory allocator to use MEM_REGION_PT
instead of hardcoding memslot '0'. This acts as a preparatory step for
allowing the physical memory allocator to take the allocation type rather
than the raw memslot.

> diff --git a/tools/testing/selftests/kvm/lib/s390/processor.c b/tools/tes=
ting/selftests/kvm/lib/s390/processor.c
> index a9adb3782b352..fb9dab92d4d18 100644
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

[Severity: Medium]
This is a pre-existing issue, but does this memset cause an out-of-bounds w=
rite
when allocating a page table?

When ri =3D=3D 4, exactly 1 page is allocated by vm_phy_pages_alloc(), but =
this
memset() unconditionally clears PAGES_PER_REGION (4) pages. This overwrites
3 adjacent physical pages, which may corrupt other page tables, guest code,
or test data during s390 guest page table setup in virt_arch_pg_map().

> =20
>  	return (taddr & REGION_ENTRY_ORIGIN)

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260902164123.2546=
762-1-seanjc@google.com?part=3D1
