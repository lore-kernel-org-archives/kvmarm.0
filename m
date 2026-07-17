Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F049306741
	for <kvmarm@lists.linux.dev>; Fri, 17 Jul 2026 14:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784297851; cv=none; b=QRQGEXKHj0Tc1Y3kZNnvEuwzp1DKdCvIQHqQcmRShq4q90r0jXey+PiWAmBCZZ8Dm3eh24zkEI0inNZBA2huxRmp+28+BbYK6DMrhff71S8g3ihAemRszlq2SXhNF3dnY1cDV9Oua9gmg/7oO8kCBURMDk1oT8E9yndUiJ/vLpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784297851; c=relaxed/simple;
	bh=vpdlQlUlhwWA5fW4GCWACaMYt9mrlB1EtFpopqlPn90=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JmNGsqNnoJx0509pri5Z0zJaJbAvC1l7uaFu5w+3WhMAZuia7Yp+52BmJPBWUgY6+DhmtPL1MXsLO+9bn7MIrRJPuHappEkxizLNK7e3GNJXkq2w2P4pcfWpKtFftzYZelqYD/+MmtqJ7DapCTen4EiQ86RaSd9+ktBQPlbgDYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LhZ4lNZ5; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LhZ4lNZ5"
X-Gm-Message-State: AOJu0YwdyxSgxZvjJJ7F5XnCG/46EqZMuXFyy9glUoDYwJ0PGiXHGM/0
	Ap7AaxNsKrrI+Aok2O+8FLgo3rbII3QwyniXmjiaS+Lkrf32/dROnsC9M1wAo8gs7WBHk39Abto
	x/0rGN20AWqK/bwmS/5l03aeH7jWCxD6BnrjusDWo
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784297846;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MKiSsrruSxgqSs4lrLJxrjq1eJiRTEmF4VPmduR90h8=;
	b=LhZ4lNZ5GJ35EhRWGsaumLkyYBnodwCOrmWiKk8FPfFlLAJv3Lol304/PJ90d1xyxk3EhA
	iVKe1eUBg70Jlw2ZLJGKzP15PNf1j35rwcXSGfibyBfCY8+CWHnNQZinNcptePbFctVGnF
	Ar7sjzrmhoExxLtNjsBs0uqwYzgsdrM=
X-Received: by 2002:a05:622a:5a0b:b0:51c:7a8b:c3fe with SMTP id
 d75a77b69052e-52212c60ca6mr113021cf.23.1784297831984; Fri, 17 Jul 2026
 07:17:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260717130317.1953574-1-fuad.tabba@linux.dev>
 <20260717130317.1953574-4-fuad.tabba@linux.dev> <20260717131537.71F531F000E9@smtp.kernel.org>
In-Reply-To: <20260717131537.71F531F000E9@smtp.kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Fri, 17 Jul 2026 15:17:00 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzZxa7Yb2GJhbJdtnTgGoiPTmSAotWTF7S7acq6M_trwg@mail.gmail.com>
X-Gm-Features: AUfX_mzZmBnBqC-Gr-icw0K7ZbsBiXqMc93gdpuOW49Urj6_mipYgHljtGsGSb8
Message-ID: <CA+EHjTzZxa7Yb2GJhbJdtnTgGoiPTmSAotWTF7S7acq6M_trwg@mail.gmail.com>
Subject: Re: [PATCH v5 3/7] KVM: arm64: Top up stage-2 memcache for dirty
 logging faults
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>, 
	Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT

On Fri, 17 Jul 2026 at 14:15, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
>
> Pre-existing issues:
> - [High] A malicious nested (L1) guest can crash the KVM host via a Break=
-Before-Make (BBM) violation that triggers a BUG_ON() due to an empty memor=
y cache during a permission fault.

From my understanding of NV code, this looks like a real issue. I
don't think it changes this patch, though: this one only widens the
top-up for the dirty-logging case, and the path you describe is a
non-logging permission fault. So, it would be a separate fix, a top up
for nested permission faults too, the same way we already do for pKVM?

        if (!perm_fault || memslot_is_logging(s2fd->memslot) ||
            is_protected_kvm_enabled() || s2fd->nested) {

If that's right, I'll send a separate fix later. Marc, what do you think?

/fuad



/fuad

> --
>
> --- Patch [3]: [PATCH v5 3/7] KVM: arm64: Top up stage-2 memcache for dir=
ty logging faults ---
> commit bac5488834df4c0a16b08356c8263e8eb67e0fe4
> Author: Bradley Morgan <include@grrlz.net>
>
> KVM: arm64: Top up stage-2 memcache for dirty logging faults
>
> Dirty logging forces new stage-2 mappings to page size but does not alway=
s
> split an existing block first. A non-write permission fault on such a blo=
ck
> still needs a page-table page to split it, but the top-up was previously
> gated on write faults. This patch tops up the memcache for any permission
> fault while dirty logging is active.
>
> Link: https://lore.kernel.org/all/20260623165634.699011F000E9@smtp.kernel=
.org/
>
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 4d7c9bdcef004..74e7e7f7564c8 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -2113,14 +2113,13 @@ static int user_mem_abort(const struct kvm_s2_f=
ault_desc *s2fd)
> >        * Permission faults just need to update the existing leaf entry,
> >        * and so normally don't require allocations from the memcache. T=
he
> >        * only exception to this is when dirty logging is enabled at run=
time
> > -      * and a write fault needs to collapse a block entry into a table=
.
> > +      * and a fault needs to collapse a block entry into a table.
> >        * Under pKVM a permission fault can also collapse pages into a b=
lock,
> >        * which needs a fresh mapping object, and the hypervisor require=
s the
> >        * min-pages memcache even when the install allocates nothing.
> >        */
> >       memcache =3D get_mmu_memcache(s2fd->vcpu);
> > -     if (!perm_fault || (memslot_is_logging(s2fd->memslot) &&
> > -                         kvm_is_write_fault(s2fd->vcpu)) ||
> > +     if (!perm_fault || memslot_is_logging(s2fd->memslot) ||
> >           is_protected_kvm_enabled()) {
>
> [Severity: High]
> This is a pre-existing issue, but does skipping the memcache top-up here
> leave the host vulnerable to a crash from a malicious nested L1 guest?
>
> If a nested L1 guest establishes a 2MB stage-2 block mapping, and then
> maliciously overwrites it with a 4KB page table descriptor without issuin=
g
> a TLBI (an architectural Break-Before-Make violation), an L2 guest can
> trigger a permission fault on the stale 2MB shadow mapping.
>
> Since KVM optimizes permission faults by assuming they only relax
> permissions, the memcache top-up is skipped here.
>
> However, in kvm_s2_fault_map(), if the mapping size and fault granule
> don't match:
>
> arch/arm64/kvm/mmu.c:kvm_s2_fault_map()
>     ...
>         } else {
>                 ret =3D KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, gfn_to_gp=
a(gfn), mapping_size,
>                                                          __pfn_to_phys(pf=
n), prot,
>                                                          memcache, flags)=
;
>         }
>     ...
>
> kvm_pgtable_stage2_map() will attempt to split the block, which requires
> a new page table allocation. Because the cache wasn't topped up,
> kvm_mmu_memory_cache_alloc() will hit WARN_ON(!mc->nobjs) and fall back
> to a GFP_ATOMIC allocation. If this atomic allocation fails under memory
> pressure, it hits BUG_ON(!p) and crashes the host.
>
> >               ret =3D topup_mmu_memcache(s2fd->vcpu, memcache);
> >               if (ret)
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260717130317.19=
53574-1-fuad.tabba@linux.dev?part=3D3
>
