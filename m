Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20F8D3A3822
	for <kvmarm@lists.linux.dev>; Fri, 17 Apr 2026 17:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776446333; cv=pass; b=TuohT9J8EgM4ZzXO5m09Ysn6tyLDH++u5F7XqEg3d3lTCL7/ptI8i/sD5k2ot78W9gis57sdDXKRwISAkXCZrW8tVE+yl0cf+IrLXawxtlj/CkgGrG2sVw8B8xe7FkBiVxHL92jXOmgwyIkiSBR9mXUf9XU/wlvDzkxFEDnf7Sw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776446333; c=relaxed/simple;
	bh=oqtrB1nDoWwh6mJFd306PSswiA0qyumTQ+FJTQjk/Jo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IsBc4e5HYlMkbEuX+E05O94FSJg+gx7ZJ4dj+zBaEmdx84xBQfcc/AFuiS4+mfVxniHcEtqn+RY9eAQT5G65Z/bl4KGQC2Xgt3YtmFQfxyAUG9BpXmWqBakOoQiDOVleeaUz82aQXa6/t16ccAi6KwBvczGN1+fwR/f1JNWtTns=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bPOVmiz/; arc=pass smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bPOVmiz/"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-50e237ae754so26391cf.1
        for <kvmarm@lists.linux.dev>; Fri, 17 Apr 2026 10:18:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776446322; cv=none;
        d=google.com; s=arc-20240605;
        b=BQ5b2jbxLb/ogYrLXHUfKbS+pWUlS0QLPfZ8gjaZigTy5MJTMxFITmGxMG1Vj7+POk
         a6wZWuVAVrmg2gPxMVKYQR+qUXa/WQGCyHDD80KI69POy5P64XC1Be5cMQXS1muA8xHm
         sO7lmToLAilNAgsCexOOzEhZJMFyZHbh25o0gadXSIyqVtaRCG5OfsXlKDwYhhQggIxS
         mLEFYJ91xmkN/ZH1YeOkOyISemr1gGJJ6uDFtmeW2YdecZsRN+uufAu7cysRDxE4KQz6
         aXilfync/dhOPQL8FP7aygecf58EvucoovkWGeR3BQ9k8+syhhkb4oo/fG0Z8ahtv2y+
         8wsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=biaOA0d6mhik4+C4B1k5xj1AmZCR/Js0cBd8UJ64e+A=;
        fh=dwUrJo5Il70xjn/LK//q7wqTiSkgi+98rUozyv/uNp8=;
        b=kq+u1uePY64coMA7D7VzIOSqncgbrrFXM3Dlk3eEFwC/LYU6SrrwbvOWXp4L5YZy2X
         4aLjdYx8n+EeUGF1+BwwFPCN3NvXIeWveWUt7wtR7IE0dS5ZVcCFcs2Zz4ean5RRMcL6
         92F1uNzw6P9PDvt81u4EP4I7HzQVpWl3AGMXdJWn80JgYsi7e9F4cQ8Vgkz+2QUtg21d
         K6035IVvjalZrl5cvUfUtlbcy/Lr+bgb38sknOpS0+cUOuzUwc+NV1MQkogvuf8WBVuF
         Gg1kY0xOWk19Rq4Nuf+a0OhOVN0KN6z8c0+NMXx9KjV0fk2zuE/4hFb9L+MCir+f88Et
         CphA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776446322; x=1777051122; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=biaOA0d6mhik4+C4B1k5xj1AmZCR/Js0cBd8UJ64e+A=;
        b=bPOVmiz/HlER8cehSkYoEukyWrYndGQ5QOGO6k0UO+TcotGhcTIVNQkU6evrP2BVca
         UfeWFkefYautu+z7MwmnGlA5IdjvH6cd9jB5V4gUXxuc1l1Eu52khaDvgQOCTD7JDh4O
         dKavA8dqU/WWrMuYzF0UDikLVr/O26RY3Fz5y0EucaGBPjslb3YD6Z5rbBX5JCeTfTYA
         lXLN9I7tK9i8DhQOh7nnH2atgGPFPt64BbTUtwXja0acGqmE9M8kMBQ47ufkKoceDXky
         t34lnWJeoK66VNz+q9O7DnhtR7inKHCeInEs2am7RGBvMi7y7qYztEqXup499LRG2+Jk
         nQnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776446322; x=1777051122;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=biaOA0d6mhik4+C4B1k5xj1AmZCR/Js0cBd8UJ64e+A=;
        b=Bj2ygWmAn/ZuFRx8sDC7AvubnrP/L7v8m/Mmh7MeUi7tE9TNB5VZZsXT1CSRTX0aDG
         o+jyZFLj0PMy0ooTl+JiQy9hktx57yznWRyEXUUfa3d9FOjzciJZfy6O5crdRWsHJNkg
         wkHlSKpSiqQorNs4+iE7ocXy/BZ/JLJ+MnS46fc8/DUI+sRLUbm5G32UzLJINvyQvSu2
         Jx1nyr5DJnF9nwJ6jUz4GFoWS7PWpcFVBe9Ex5gl1rmUIRBVMmQPiPkOscYdCiFuLw6y
         xCgUrPPhGU12pG7baaVZvXqD6dw/deV2uLRyoqlBa911C1SLkMQsdfr0BqCAd8nYpoB1
         jQXg==
X-Forwarded-Encrypted: i=1; AFNElJ8DX+QXfE7C2Zp560bEWKtpCj5ebnKr7f/DasuIkNl+czWeyJCwapGNWOok/ojavl2dARSGNQs=@lists.linux.dev
X-Gm-Message-State: AOJu0YzbRdfJzE1IeyRiNFAYzXGDrT9fED4sxcTkniwskbRXKPANC2JN
	aJaLm/4EcQIznB6+97+Bblct8uYVhTYzC9fygumOT/02AQIPw71V1P5AbQ2snjJdKngCxcMe0PG
	1ocNDGbe3OdZTg+EUFw5loJvksCaSb6lOD5bfKx6G
X-Gm-Gg: AeBDiesUpXspEGc+P0OA4Bgbo2OUD0NwcIwbtWO5aTxa5TNelHrixCGoeGOp6dR8Apw
	Jp404H8amK5SADuarB55ioJTnSzh3jw90f0mWPTPdTdmwNoOeqhT1MlodQiqkNWdxwo4Cet1M+y
	jhVql3uzCb1vR1kkwL9kb348MxJykHz1UuiRroIRDmuKESYfIMBSGZNHy0TMUlW9QYK8OBTLCXb
	wbx3oNsvDtrQ+dn/Lf5QNVAKu9HnnwMWbwTiARjZ+HWddvVABlffblSs/Ts4zMbSjHFlq1qJhj5
	t04w5OFDupeP9gNdirNk3KeUB2c1oK8EoUln78cHdIwgRHzcqVUDT024CqaB4w==
X-Received: by 2002:ac8:7d47:0:b0:4ff:bfd9:dd31 with SMTP id
 d75a77b69052e-50e42b292c2mr172191cf.5.1776446320593; Fri, 17 Apr 2026
 10:18:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260310124933.830025-1-sebastianene@google.com>
 <20260310124933.830025-2-sebastianene@google.com> <acJpy7unwLbRahPL@google.com>
In-Reply-To: <acJpy7unwLbRahPL@google.com>
From: Mostafa Saleh <smostafa@google.com>
Date: Fri, 17 Apr 2026 18:18:28 +0100
X-Gm-Features: AQROBzCCTRSV62IVPx6y330qpXgmkId4e0KId71ugobNpu16Ggl0mg0GgHYUJBg
Message-ID: <CAFgf54r3YmFXU+=btPtgtT2wUM0y0+qmPnJYvUX2ncdijHQCGw@mail.gmail.com>
Subject: Re: [PATCH 01/14] KVM: arm64: Donate MMIO to the hypervisor
To: Vincent Donnefort <vdonnefort@google.com>
Cc: Sebastian Ene <sebastianene@google.com>, alexandru.elisei@arm.com, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, android-kvm@google.com, catalin.marinas@arm.com, 
	dbrazdil@google.com, joey.gouly@arm.com, kees@kernel.org, 
	mark.rutland@arm.com, maz@kernel.org, oupton@kernel.org, perlarsen@google.com, 
	qperret@google.com, rananta@google.com, suzuki.poulose@arm.com, 
	tabba@google.com, tglx@kernel.org, bgrzesik@google.com, will@kernel.org, 
	yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 24, 2026 at 10:39=E2=80=AFAM Vincent Donnefort
<vdonnefort@google.com> wrote:
>
> On Tue, Mar 10, 2026 at 12:49:20PM +0000, Sebastian Ene wrote:
> > From: Mostafa Saleh <smostafa@google.com>
> >
> > Add a function to donate MMIO to the hypervisor so IOMMU hypervisor
> > drivers can use that to protect the MMIO of IOMMU.
> > The initial attempt to implement this was to have a new flag to
> > "___pkvm_host_donate_hyp" to accept MMIO. However that had many problem=
s,
> > it was quite intrusive for host/hyp to check/set page state to make it
> > aware of MMIO and to encode the state in the page table in that case.
> > Which is called in paths that can be sensitive to performance (FFA, VMs=
..)
> >
> > As donating MMIO is very rare, and we don=E2=80=99t need to encode the =
full
> > state, it=E2=80=99s reasonable to have a separate function to do this.
> > It will init the host s2 page table with an invalid leaf with the owner=
 ID
> > to prevent the host from mapping the page on faults.
>
> I am not sure I agree here:
>
> * Differentiating between MMIO and Memory is just a fast binary search in=
to the
>   memory regions.
>
> * host_donate_hyp isn't a fast path even for memory regions anyway.
>
> * Having common functions for changing ownership is more and more helpful=
 (see the
>   SME dvmsync workaround).
>
> * There's nothing preventing from having a range here which is safely han=
dled
>   already by host_donate_hyp()
>

I am working on v6 now. I'm not convinced that's a good enough reason
to have full-fledged MMIO state tracking, it will be unncessary
complicated and quite intrusive.

It might be useful when supporting device assignment where VMs can own
MMIO, otherwise, I'd try to avoid it.

Thanks,
Mostafa


> >
> > Also, prevent kvm_pgtable_stage2_unmap() from removing owner ID from
> > stage-2 PTEs, as this can be triggered from recycle logic under memory
> > pressure. There is no code relying on this, as all ownership changes is
> > done via kvm_pgtable_stage2_set_owner()
> >
> > For error path in IOMMU drivers, add a function to donate MMIO back
> > from hyp to host.
> >
> > Signed-off-by: Mostafa Saleh <smostafa@google.com>
> > ---
> >  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  2 +
> >  arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 90 +++++++++++++++++++
> >  arch/arm64/kvm/hyp/pgtable.c                  |  9 +-
> >  3 files changed, 94 insertions(+), 7 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64=
/kvm/hyp/include/nvhe/mem_protect.h
> > index 5f9d56754e39..8b617e6fc0e0 100644
> > --- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> > +++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> > @@ -31,6 +31,8 @@ enum pkvm_component_id {
> >  };
> >
> >  extern unsigned long hyp_nr_cpus;
> > +int __pkvm_host_donate_hyp_mmio(u64 pfn);
> > +int __pkvm_hyp_donate_host_mmio(u64 pfn);
> >
> >  int __pkvm_prot_finalize(void);
> >  int __pkvm_host_share_hyp(u64 pfn);
> > diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp=
/nvhe/mem_protect.c
> > index 38f66a56a766..0808367c52e5 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > @@ -784,6 +784,96 @@ int __pkvm_host_unshare_hyp(u64 pfn)
> >       return ret;
> >  }
> >
> > +int __pkvm_host_donate_hyp_mmio(u64 pfn)
> > +{
> > +     u64 phys =3D hyp_pfn_to_phys(pfn);
> > +     void *virt =3D __hyp_va(phys);
> > +     int ret;
> > +     kvm_pte_t pte;
> > +
> > +     if (addr_is_memory(phys))
> > +             return -EINVAL;
> > +
> > +     host_lock_component();
> > +     hyp_lock_component();
> > +
> > +     ret =3D kvm_pgtable_get_leaf(&host_mmu.pgt, phys, &pte, NULL);
> > +     if (ret)
> > +             goto unlock;
> > +
> > +     if (pte && !kvm_pte_valid(pte)) {
> > +             ret =3D -EPERM;
> > +             goto unlock;
> > +     }
> > +
> > +     ret =3D kvm_pgtable_get_leaf(&pkvm_pgtable, (u64)virt, &pte, NULL=
);
> > +     if (ret)
> > +             goto unlock;
> > +     if (pte) {
> > +             ret =3D -EBUSY;
> > +             goto unlock;
> > +     }
> > +
> gg> +   ret =3D pkvm_create_mappings_locked(virt, virt + PAGE_SIZE, PAGE_=
HYP_DEVICE);
> > gg+   if (ret)
> > +             goto unlock;
> > +     /*
> > +      * We set HYP as the owner of the MMIO pages in the host stage-2,=
 for:
> > +      * - host aborts: host_stage2_adjust_range() would fail for inval=
id non zero PTEs.
> > +      * - recycle under memory pressure: host_stage2_unmap_dev_all() w=
ould call
> > +      *   kvm_pgtable_stage2_unmap() which will not clear non zero inv=
alid ptes (counted).
> > +      * - other MMIO donation: Would fail as we check that the PTE is =
valid or empty.
> > +      */
> > +     WARN_ON(host_stage2_try(kvm_pgtable_stage2_set_owner, &host_mmu.p=
gt, phys,
> > +                             PAGE_SIZE, &host_s2_pool, PKVM_ID_HYP));
> > +unlock:
> > +     hyp_unlock_component();
> > +     host_unlock_component();
> > +
> > +     return ret;
> > +}
> > +
> > +int __pkvm_hyp_donate_host_mmio(u64 pfn)
> > +{
> > +     u64 phys =3D hyp_pfn_to_phys(pfn);
> > +     u64 virt =3D (u64)__hyp_va(phys);
> > +     size_t size =3D PAGE_SIZE;
> > +     int ret;
> > +     kvm_pte_t pte;
> > +
> > +     if (addr_is_memory(phys))
> > +             return -EINVAL;
> > +
> > +     host_lock_component();
> > +     hyp_lock_component();
> > +
> > +     ret =3D kvm_pgtable_get_leaf(&pkvm_pgtable, (u64)virt, &pte, NULL=
);
> > +     if (ret)
> > +             goto unlock;
> > +     if (!kvm_pte_valid(pte)) {
> > +             ret =3D -ENOENT;
> > +             goto unlock;
> > +     }
> > +
> > +     ret =3D kvm_pgtable_get_leaf(&host_mmu.pgt, phys, &pte, NULL);
> > +     if (ret)
> > +             goto unlock;
> > +
> > +     if (FIELD_GET(KVM_INVALID_PTE_OWNER_MASK, pte) !=3D PKVM_ID_HYP) =
{
> > +             ret =3D -EPERM;
> > +             goto unlock;
> > +     }
> > +
> > +     WARN_ON(kvm_pgtable_hyp_unmap(&pkvm_pgtable, virt, size) !=3D siz=
e);
> > +     WARN_ON(host_stage2_try(kvm_pgtable_stage2_set_owner, &host_mmu.p=
gt, phys,
> > +                             PAGE_SIZE, &host_s2_pool, PKVM_ID_HOST));
> > +unlock:
> > +     hyp_unlock_component();
> > +     host_unlock_component();
> > +
> > +     return ret;
> > +}
> > +
> >  int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages)
> >  {
> >       u64 phys =3D hyp_pfn_to_phys(pfn);
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.=
c
> > index 9b480f947da2..d954058e63ff 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -1152,13 +1152,8 @@ static int stage2_unmap_walker(const struct kvm_=
pgtable_visit_ctx *ctx,
> >       kvm_pte_t *childp =3D NULL;
> >       bool need_flush =3D false;
> >
> > -     if (!kvm_pte_valid(ctx->old)) {
> > -             if (stage2_pte_is_counted(ctx->old)) {
> > -                     kvm_clear_pte(ctx->ptep);
> > -                     mm_ops->put_page(ctx->ptep);
> > -             }
> > -             return 0;
> > -     }
> > +     if (!kvm_pte_valid(ctx->old))
> > +             return stage2_pte_is_counted(ctx->old) ? -EPERM : 0;
> >
> >       if (kvm_pte_table(ctx->old, ctx->level)) {
> >               childp =3D kvm_pte_follow(ctx->old, mm_ops);
> > --
> > 2.53.0.473.g4a7958ca14-goog
> >
