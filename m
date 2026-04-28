Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD4A438AC9C
	for <kvmarm@lists.linux.dev>; Tue, 28 Apr 2026 14:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777387050; cv=pass; b=lX8FTq0TeQacdEI0lLwGOugKElgkFUNRte2F0QF9ZIwLH0haHvtqtaNofgh1RBiHGMK3b+CkHx/X3+Da4zU+nCfeTsvSR0BxHW3Mj/RYDZQXklcTfyDyw/VAx5x3SphhyGfnTHMM9EhN9JWlz5PbIzcbdF4Hwr2emcx1ejaVCv4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777387050; c=relaxed/simple;
	bh=SQvI3MhcbO6vWHO1VLcGP7Zz8yqLhVBcHIlEieBeTOc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EH4fph/IXaAwNr8Q/KVc7JuBS8TwkVDQqMfEhfits0/l3coqxKM5v1dVf4FgyMMKRdeTFcmWxQlQ9BdQQZIxhwEoPcd8OY+0tlC+zzXVc3CZOjBwk13w3oAoj4N98dzvF6237yyWPxobt+p5pUvHlb776m1G5Xu0+1ELybu4Rco=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=W6qBbScY; arc=pass smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="W6qBbScY"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-50e61648f10so671801cf.1
        for <kvmarm@lists.linux.dev>; Tue, 28 Apr 2026 07:37:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777387048; cv=none;
        d=google.com; s=arc-20240605;
        b=Cx7fY660Jz4mylgIbUNbtrHmbapO0w+yahGBbxyaS72uJn/VpOxzKMfk7U8GHoIbSo
         anR3jpov6/SZDHA8dLd40CTqTVAiXFC6LOZ5FudL9fT1X4nj5ulA70xQR+x3h39cn66o
         Y7AuZaT2qCAZu3oR/9SYekZhTJqg/bAP/7StsDWVzLkAcsmk4u70t6e8oJu6imD0314j
         g8JNTczgzBOJL4KPW6zG9hKyiS7HMLmOeT/39jAS255eGumb8A8xg7mqZFMdFpD30PYn
         o6kqWj3aabXuWjbcgqur16wYBkv3FL1NTdrFpgPcmrh23Lvb1Etvht2lkNVyuBdsQL7Y
         S97g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6dapWbfdaH3qRNQs2tgvGaffgEEHsGjHti7EKce5ja8=;
        fh=fC6ndb4RIygjEJyzZo6acRhPEJ3UPG0ZQJqw5HmCiKc=;
        b=NyLY5Vz+Qfev5y5tikX7+F0oEjyCdJ3TDDf0dg8Kg5v+ws93cEns1M1rTpnBsAswq6
         UhWxWyBRXJcoMhYtm8XaUWb43+r0pLxg8oCIOhc6XoJ5PnBj8uRo7JlfGg4Lywq7EHkq
         kwzm+p8egapK1okURDfw/WIiL6D/tHKjcZw/Ha1I4Wp1kfGQ9j+GMJKmVkl9ZDqxerfT
         LCQCa4KNN98j/wGBRRoGrPTIM1yCwCkfykgQfd41v7rLEPAjVqHbuxZB7MPokeGvomUn
         CjGmYrmWsfD5+QC/yMZ5nHAA1MPUSJv64cVdhkNikJYix5d0gimp5CPJMae3H6Qxx4k7
         SgBw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777387048; x=1777991848; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6dapWbfdaH3qRNQs2tgvGaffgEEHsGjHti7EKce5ja8=;
        b=W6qBbScYyQa/mDNbHjy5UDfahVQbkMOokRnnljTLvUpDgAZpzc0HMfCloSjjQ/Mm6e
         pCqxQeFc6Q/aY8V748ohTD39Uuo9EHhGAxQ74zn2Wgw4MT5PCdJu20ql5ZkJMXV5iptV
         /446eH8h/JDOUvS13uYg1mPKgEX2bVHRJVcGyMWYoIuwz9VfWcMv/pkAHNhWRty5zZJl
         meswOe/V38ca/zBELzmNgxEZf53qIx6Ge1dUrPzIE5GfkPK8olNa439cXtZ1KAk+MXBH
         pFF3rdT2lY6L51ZxTLB4xGBWJt1fh+60rXBAZ8aA3OqaCc53iqBcSmctoGB/ZwLqaI+y
         ZO6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777387048; x=1777991848;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6dapWbfdaH3qRNQs2tgvGaffgEEHsGjHti7EKce5ja8=;
        b=gRpgH7u6ADNHMtTPKRurFV9doMC2T00lv/idbloXtLT2V15VxhZeAMpGzfqwqSypJM
         8TzBZ5XayxtLcWGWy/dBCNSmMvvcLP8b57JeSgO/q2+ZEfIhFi01puVG8vynkDG9K/cK
         4iMnm/aNO2JjmrrioBcM+xauDWg+XJR68MYebgU1+Xm+ysplO/VnaxKz6hdBAeA9kNpE
         /zwyDLTRCNM5fvIWTfzid+IdmwTs9m5gvssjgKkKtVMZmlbCRoCB7bus4I3Hoo1gLx+z
         n5qDE1cSy7FCwxazdXqqxX/VS2R5wyFxuGZO9r3Khr9g9yo6/6qJnraXEB5htRIVwVAW
         6vaQ==
X-Forwarded-Encrypted: i=1; AFNElJ8tmTIZRQFmCZP4GNAhib4RRg2dK+q30dsOpOH3GEe2jMJzHMQOsNeMD4S20zmJ48VqCX7iQGg=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxiod6NmCDGJGD9W//JwcDlUJCrlPXOUrUZUVQd3NBIj8DJqGSZ
	HLxyl6gXav03+Kt/MjvzhGYJ/i+q9NKebRJkKgUEJ3sbtgnhyXjqtPfH4Qgur3o8s5rC9ywoPUL
	M3Wtn2OpE/vZQRnb/qABTlLqRt8nbv7UueJKMBETB
X-Gm-Gg: AeBDietHjXiBcIbguIhzYgVuf7Iz3XUggPaQBXBj5VxKqMk+tYziQ53ZZD0zveVgXpX
	wGCiEXgcwJEvCuArz5SOjMsaYyIokchty18iHz2Dx8sYsRGYhY/mLBkLJEeVU+ZWx2GZZjAcrnU
	PiiSvihzCRss59lhJX3le3SuScVe3/wKB/zxLpJ8//FQ/YO4ge5NdQvuMk8iWT0s+gYx35+dagK
	5F2p9YS0X1tmACKYbPINtbgT+BkROOQC1Ritj8eoNUJdJpReOHSbqLm/DZ/R2bWILsTpC5APaZn
	gdixDegFzPZc7KavMrNLL+EBYLQfU9PIupD6oyMlkk2/Be6FbnTdLH8Fk3XY+Ts=
X-Received: by 2002:ac8:5d52:0:b0:509:174d:3224 with SMTP id
 d75a77b69052e-5100ddadccdmr13763831cf.11.1777387040604; Tue, 28 Apr 2026
 07:37:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260428103008.696141-1-tabba@google.com> <20260428103008.696141-7-tabba@google.com>
 <afC5_jrTEVRfJ77x@willie-the-truck>
In-Reply-To: <afC5_jrTEVRfJ77x@willie-the-truck>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 28 Apr 2026 15:36:43 +0100
X-Gm-Features: AVHnY4KUvLQVQvqOYoHKFrGRxCQZYRY1ccfXZN-JSVf8ghDHejXfq6Fa9ThLlXs
Message-ID: <CA+EHjTyTy2qLm=CbOOYR6rmjg5tH38PifAV+qAhbZxidY5szxQ@mail.gmail.com>
Subject: Re: [PATCH 6/8] KVM: arm64: Propagate stage-2 map failure on
 host->guest donation
To: Will Deacon <will@kernel.org>
Cc: maz@kernel.org, oliver.upton@linux.dev, james.morse@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, qperret@google.com, 
	vdonnefort@google.com, catalin.marinas@arm.com, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Will,

On Tue, 28 Apr 2026 at 14:45, Will Deacon <will@kernel.org> wrote:
>
> On Tue, Apr 28, 2026 at 11:30:06AM +0100, Fuad Tabba wrote:
> > __pkvm_host_donate_guest() flips the host stage-2 PTE for the donated
> > page to a non-valid annotation (KVM_HOST_INVALID_PTE_TYPE_DONATION,
> > owner =3D PKVM_ID_GUEST) via host_stage2_set_owner_metadata_locked()
> > and then calls kvm_pgtable_stage2_map() to install the matching guest
> > stage-2 mapping. The map's return value was wrapped in WARN_ON() and
> > otherwise discarded.
> >
> > At EL2 in nVHE/pKVM, WARN_ON() is not warn-and-continue: it expands
> > to a BRK that enters the invalid-host-el2 vector and branches to
> > hyp_panic(), declared __noreturn. WARN_ON of a reachable failure at
> > EL2 is a panic primitive, not a debug aid.
> >
> > kvm_pgtable_stage2_map() can fail in reachable ways even at PAGE_SIZE
> > granularity: __pkvm_host_donate_guest() verifies PKVM_NOPAGE for the
> > guest IPA before the map, meaning no valid stage-2 entry exists. The
> > walker must allocate new page-table pages from the vcpu memcache to
> > install the mapping, returning -ENOMEM if exhausted. The host
> > controls the vcpu memcache via the topup interface, so an
> > under-provisioned donation request converts a recoverable error into
> > a fatal hyp panic.
> >
> > Capture the stage-2 map return value and propagate it. The walker
> > may have installed partial leaf entries for the IPA before failing,
> > so unmap the range to clear them; otherwise the guest would retain
> > stage-2 access to a page the host is about to reclaim as
> > PKVM_PAGE_OWNED. Then roll back the host stage-2 mutation: the only
> > forward mutation is host_stage2_set_owner_metadata_locked() flipping
> > the host vmemmap from PKVM_PAGE_OWNED to PKVM_NOPAGE and the host
> > stage-2 PTE from idmap to invalid+annotation.
> > host_stage2_set_owner_locked(_, _, PKVM_ID_HOST) restores both.
> >
> > The rollback calls host_stage2_set_owner_locked() under WARN_ON.
> > This is the correct use: host_stage2_set_owner_metadata_locked()
> > just wrote the host leaf PTE as an invalid+annotation entry, so the
> > reverse idmap rewrite cannot require new page-table allocation =E2=80=
=94 it
> > rewrites the leaf in-place. The WARN_ON asserts an impossible state
> > under correct EL2 execution, semantically distinct from the misuse
> > being fixed.
> >
> > Fixes: 1e579adca177 ("KVM: arm64: Introduce __pkvm_host_donate_guest()"=
)
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/mem_protect.c | 27 ++++++++++++++++++++++++---
> >  1 file changed, 24 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp=
/nvhe/mem_protect.c
> > index 7044913a0758..b8c57a95e9bf 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > @@ -1391,9 +1391,30 @@ int __pkvm_host_donate_guest(u64 pfn, u64 gfn, s=
truct pkvm_hyp_vcpu *vcpu)
> >       meta =3D host_stage2_encode_gfn_meta(vm, gfn);
> >       WARN_ON(host_stage2_set_owner_metadata_locked(phys, PAGE_SIZE,
> >                                                     PKVM_ID_GUEST, meta=
));
> > -     WARN_ON(kvm_pgtable_stage2_map(&vm->pgt, ipa, PAGE_SIZE, phys,
> > -                                    pkvm_mkstate(KVM_PGTABLE_PROT_RWX,=
 PKVM_PAGE_OWNED),
> > -                                    &vcpu->vcpu.arch.pkvm_memcache, 0)=
);
> > +     ret =3D kvm_pgtable_stage2_map(&vm->pgt, ipa, PAGE_SIZE, phys,
> > +                                  pkvm_mkstate(KVM_PGTABLE_PROT_RWX, P=
KVM_PAGE_OWNED),
> > +                                  &vcpu->vcpu.arch.pkvm_memcache, 0);
> > +     if (ret) {
> > +             /*
> > +              * Stage-2 map can fail mid-walk (e.g. -ENOMEM from the
> > +              * memcache), leaving partial leaf entries installed in t=
he
> > +              * guest stage-2. Tear them down before rolling back the =
host
> > +              * stage-2; otherwise the guest would retain access to a =
page
> > +              * the host is about to reclaim as PKVM_PAGE_OWNED.
> > +              */
> > +             kvm_pgtable_stage2_unmap(&vm->pgt, ipa, PAGE_SIZE);
>
> Whoa, whoa, whoa.
>
> First of all, this is mapping a single page, so the comment talking about
> "leaf entries" (plural) is bogus. If an operation to map a single page
> fails, then it makes no sense to try unmapping the mapping which we
> failed to create. What do you expect it to do?
>
> On the other hand, if we extend this to handle ranges in future (which
> presumably we'll want as part of the THP support) then wouldn't this
> mean that a concurrent vCPU could have transiently written to the pages
> that _did_ get mapped, and now we're going to give those back to the
> host? That's really not ok! We're relying on these WARN_ON()s being
> fatal and they shouldn't fail because we perform all the permission
> checks first, in a separate pass.
>
> If you want to improve this, then I think the options are either:
>
>   1. Check that the the memcache is topped up first
>   2. Poison the page (similar to the forced-reclaim path)
>   3. Tell the host about the pages it's lost and maybe it can leak them
>
> (I vote for (1))
>
> But we absolutely cannot do the simple rollback for the ownership
> changes; that's why the code is written to do the checks up-front. Your
> other patches at the end of this series have different flavours of the
> same issue.
>
> If it's just about keeping the LLM happy, then either fix the LLM or
> make these BUG_ON() (in conjunction with (1) above).

You're right, and no, it's not just about keeping em happy :D

The "leaf entries" comment on the single-page donate path is wrong, and
more importantly the rollback model is unsound. The right fix is to tighten
the precondition, not to handle a failure that shouldn't be reachable.

V2 will drop two patches (in addition to the HCR_EL2 one), and will be
as follows:

1. host->guest share and host->guest donate (kept, rewritten): add a
   memcache-sufficiency check during the existing pre-check pass
   (option 1) and return -ENOMEM cleanly without touching any state.
   Restore the WARN_ON() on the subsequent kvm_pgtable_stage2_map() =E2=80=
=94
   with the topup precheck it asserts an established invariant rather
   than ignoring a reachable error.

   For the single-page donate, "topped up" is
   KVM_PGTABLE_LAST_LEVEL - vm->pgt.start_level (mirroring host EL1's
   kvm_mmu_cache_min_pages). For multi-page share I plan to use the
   conservative nr_pages * (LAST_LEVEL - start_level) bound and flag it
   as conservative in the commit message; happy to compute a tighter
   alignment-aware bound if you'd prefer.

2. guest->host share and guest->host unshare (dropped): on reflection
   these shouldn't have been in V1 at all. As I did note in the commit
   message, failure path is not reachable. Again, too eager to make
   use of the new prompts.

I'll repost this as V2 if you agree.

Cheers,
/fuad

>
> Will
