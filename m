Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE6DF33F390
	for <kvmarm@lists.linux.dev>; Thu, 12 Mar 2026 17:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773338267; cv=pass; b=JnREKVrmi+d8PjsQZ3Na/FrPCHxaYjf4F7TqoGCu/w16FrDebYIIL+p2H3sra80aD//phMz85wGih93e79JHuKvAckNplhjhmMVbJQFBWTAfoTddGYa9tpI71TywHv0nOimPEyJ28kc4f/Rg7IGqA3N8GHNj3bzTPGFQYXYGjkE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773338267; c=relaxed/simple;
	bh=7JLVE47jKFSPedfhmxxS98Op8it4T0TV0xIFGIW+fPE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Q+BE8AoAbwDOTGeDZEn+hEbppF1gWfvYz0RnV3tzG+ZOMgRCmejsRxdSrbPRhU6osXnzvbM1Zzxsc4AbtLp1jYLKiqoIXPEcJ81BuArb7n8jD9N8eWdIgHvWz/8xkEFXIMAtSJOXb2Kl3rcQfL65dadEj3Lt0ZHs29GpcIVp0XQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QNM5YXhH; arc=pass smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QNM5YXhH"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-50906a98ffeso59441cf.0
        for <kvmarm@lists.linux.dev>; Thu, 12 Mar 2026 10:57:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773338265; cv=none;
        d=google.com; s=arc-20240605;
        b=AUmlyIU4i8Iwrg0iy0THLUtsJNpIuVOFGqpVaUqxOHDcrHdfcO4JNvb2lnQoJzI6ph
         cscL9neUglN9hUFWJWzIAcKZJPgMX0yhgi8MC0YlOUoQvuHKjXHUjpeynvzYx8mLoBco
         EjORXuM5Is0NnuTura5pmKcspuT8U1UWKv0DOT3nHDrzOFLL+IjTynBNCo9jci998Dvd
         xDJUOjcnyDCVrtf3TeNR2LPvW/LuiDhGf5GEDsv069eJVNt4SvVvtbP843Z/EbFrsHAt
         EUeSWjFA4IeDr4GSQ8fnEqlvvyovx5outputDVFsyu7z0DMWhdj6fEPL2OBMYnvpX3u7
         p1bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zvAML1TXhwJrNBapt3bY/fy2P/HQmzT8RWNB/11cH/k=;
        fh=99RKD11IZjkreBS7j5nDp/emRLRFimR/3i4ZfFvLG28=;
        b=jDqxBvEuPcNywP93qYC8rcigjBNyrDkNziAU7gjYkZFzxWjLV3++BUOUG2fdGFNwbM
         dIww3rf3JDWiWjqbuPejFjubhphvvV4sgFSfPP1kZ6hsXX8/pD9Da4DwU5YD7cBvxzDx
         E2ZaE7lPiksilUg9pbCWGT2wKZcWC4mnu0rKN3rG3EtXZeYY8VyMhGmbk3Ux+aGeTEFd
         e7CLzA3cOUhl4q7LuofBupIw7j2Iu/JN6HBCit9ID8m1dMVCQGU/emIVtxVjDFvhI4fW
         u9Pb6zw+7SMB49w+y0wDepUXhroV+G5QaswxhXKkEFbQ9mhhj2EdWxWhVvOaydCPbKyB
         hVUA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773338265; x=1773943065; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zvAML1TXhwJrNBapt3bY/fy2P/HQmzT8RWNB/11cH/k=;
        b=QNM5YXhHu4pFPQ3BmnuBepLVxnyWVOdpD9uTCaUNYzwVDj5BC1kMrr3IbmBq/cTJU7
         Sn4Xt/GCXnmoIMpY0mdz7Z/+6pvNDU8hZWeJrYoQntNhBMpkOSkv+I81AlTclLVHSouO
         bSDQzjUlgUKEJqhGjWLR5o1Sgnt6nn9jflQcubFYzpNOQddpUOeBl4+tQSr6BPxPxdTR
         5kTobZnhXiXOIqQDHemnN5LNtxb6fTFsY/M11W5YYTeHCZBgdusr61UX/f7wisI/0uOd
         i50c6e5gpPjJEaJ/GKFrjzF6Lq49yXJYmuEGYSKv8sbMBzFI/b706O1dVIVQP8WqnC2O
         ybzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773338265; x=1773943065;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zvAML1TXhwJrNBapt3bY/fy2P/HQmzT8RWNB/11cH/k=;
        b=cO3w7GGCZ2URgBMkfYO19Bh6RYgVZpUXCI7XuGoT4KKlNdGbZ/hDoYtBed9GD0ad6e
         dMfuKX3wyHITRKCSxTp1DIQHlAYHD6kvKz693iRbFnz+RYLLgEIVx4N3ffWVLTySwAVC
         XPnJdzevu5fkXO/FF8urlcYCdGw3ZKsQHxeFOK6aVgcfDoIa3/3a4O7wzCg4DxbCDchK
         BR6v7wfNUgbo6pHAEO8TOWHlYBJxVAqsdIIl/AypOgoApMhTXKfrAvFqPJ53xjGMEL8i
         qrrUEEdmnftS3iAfG2zO5ekY+JlS1l4vYoIUe5zhZisFJxfU/ytK1S9Z82uH9MxjnLZs
         pxTA==
X-Forwarded-Encrypted: i=1; AJvYcCVNdbjLkV87Ljil33w1gLn8k21gvKiKtmpJGay7GjYcgw7CN2FC/onG6bCCNCllidbqjpYr/iI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy2fQJe77CzzgHGhRNrVghPYLyD3Syb56JwEB+WKlP5P0UXq/fn
	EFFdbZsVUUYT8sJKbhXc3upuX9C7k83O1pPw0JAAP1sDJ6HLQpfd17Y84dxbSaflac4mdz6GIJ2
	ywbJ4fMKMO/KYi6q0hRS949FmLvUkrGAxNzYBuu/i
X-Gm-Gg: ATEYQzysoSWrSyaEMUsXnDkgreg8HYHtXTNrPyBoYws3Cx31tEdQJpo3/PEMQo9JECO
	yOLT7WR2w8MkpO0fuBAiy6imHBdd7/yR9sxogsl0Zq02k3ZCe+6fVYbGmn764env3KngUzXFgdp
	WEhgZdpG04NqTUjwO5wrC30hFrSclRNLzBEgLGh0AxNGBKmEDg//Rdr8cQ/uli6XO89s641J3WP
	OUv9YCxHkJL4X35Q1T7FSk+Y+bIZCiQbeiqsw0dxrBGymWmk5dsQaGNuAdgxGsFrbfefI3hEMTD
	IgJ27++hw+ofGGTjbV8=
X-Received: by 2002:a05:622a:54f:b0:509:174d:3224 with SMTP id
 d75a77b69052e-509585fc0dfmr794461cf.11.1773338263919; Thu, 12 Mar 2026
 10:57:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260310124933.830025-1-sebastianene@google.com> <20260310124933.830025-2-sebastianene@google.com>
In-Reply-To: <20260310124933.830025-2-sebastianene@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 12 Mar 2026 17:57:06 +0000
X-Gm-Features: AaiRm50UHS0HJHwYvTvytsFBXYKCFdJYIPpWhfhpkM3kMBPTBsr_hCDbfbubjhg
Message-ID: <CA+EHjTxSgAbak_j+emSHNk9Em-m=gU44w_S2DtFovz5Q_Ci=Wg@mail.gmail.com>
Subject: Re: [PATCH 01/14] KVM: arm64: Donate MMIO to the hypervisor
To: Sebastian Ene <sebastianene@google.com>
Cc: alexandru.elisei@arm.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	android-kvm@google.com, catalin.marinas@arm.com, dbrazdil@google.com, 
	joey.gouly@arm.com, kees@kernel.org, mark.rutland@arm.com, maz@kernel.org, 
	oupton@kernel.org, perlarsen@google.com, qperret@google.com, 
	rananta@google.com, smostafa@google.com, suzuki.poulose@arm.com, 
	tglx@kernel.org, vdonnefort@google.com, bgrzesik@google.com, will@kernel.org, 
	yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Sebastian (and Mostafa),

On Tue, 10 Mar 2026 at 12:49, Sebastian Ene <sebastianene@google.com> wrote=
:
>
> From: Mostafa Saleh <smostafa@google.com>
>
> Add a function to donate MMIO to the hypervisor so IOMMU hypervisor
> drivers can use that to protect the MMIO of IOMMU.
> The initial attempt to implement this was to have a new flag to
> "___pkvm_host_donate_hyp" to accept MMIO. However that had many problems,
> it was quite intrusive for host/hyp to check/set page state to make it
> aware of MMIO and to encode the state in the page table in that case.
> Which is called in paths that can be sensitive to performance (FFA, VMs..=
)
>
> As donating MMIO is very rare, and we don=E2=80=99t need to encode the fu=
ll
> state, it=E2=80=99s reasonable to have a separate function to do this.
> It will init the host s2 page table with an invalid leaf with the owner I=
D
> to prevent the host from mapping the page on faults.
>
> Also, prevent kvm_pgtable_stage2_unmap() from removing owner ID from
> stage-2 PTEs, as this can be triggered from recycle logic under memory
> pressure. There is no code relying on this, as all ownership changes is
> done via kvm_pgtable_stage2_set_owner()
>
> For error path in IOMMU drivers, add a function to donate MMIO back
> from hyp to host.
>
> Signed-off-by: Mostafa Saleh <smostafa@google.com>
> ---
>  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  2 +
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 90 +++++++++++++++++++
>  arch/arm64/kvm/hyp/pgtable.c                  |  9 +-
>  3 files changed, 94 insertions(+), 7 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/k=
vm/hyp/include/nvhe/mem_protect.h
> index 5f9d56754e39..8b617e6fc0e0 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> @@ -31,6 +31,8 @@ enum pkvm_component_id {
>  };
>
>  extern unsigned long hyp_nr_cpus;
> +int __pkvm_host_donate_hyp_mmio(u64 pfn);
> +int __pkvm_hyp_donate_host_mmio(u64 pfn);
>
>  int __pkvm_prot_finalize(void);
>  int __pkvm_host_share_hyp(u64 pfn);
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/n=
vhe/mem_protect.c
> index 38f66a56a766..0808367c52e5 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -784,6 +784,96 @@ int __pkvm_host_unshare_hyp(u64 pfn)
>         return ret;
>  }
>
> +int __pkvm_host_donate_hyp_mmio(u64 pfn)
> +{
> +       u64 phys =3D hyp_pfn_to_phys(pfn);
> +       void *virt =3D __hyp_va(phys);
> +       int ret;
> +       kvm_pte_t pte;

nit: prefer reverse-christmas tree ordering for declarations.


> +
> +       if (addr_is_memory(phys))
> +               return -EINVAL;
> +
> +       host_lock_component();
> +       hyp_lock_component();
> +
> +       ret =3D kvm_pgtable_get_leaf(&host_mmu.pgt, phys, &pte, NULL);
> +       if (ret)
> +               goto unlock;
> +
> +       if (pte && !kvm_pte_valid(pte)) {
> +               ret =3D -EPERM;
> +               goto unlock;
> +       }
> +
> +       ret =3D kvm_pgtable_get_leaf(&pkvm_pgtable, (u64)virt, &pte, NULL=
);
> +       if (ret)
> +               goto unlock;
> +       if (pte) {
> +               ret =3D -EBUSY;
> +               goto unlock;
> +       }
> +
> +       ret =3D pkvm_create_mappings_locked(virt, virt + PAGE_SIZE, PAGE_=
HYP_DEVICE);
> +       if (ret)
> +               goto unlock;
> +       /*
> +        * We set HYP as the owner of the MMIO pages in the host stage-2,=
 for:
> +        * - host aborts: host_stage2_adjust_range() would fail for inval=
id non zero PTEs.
> +        * - recycle under memory pressure: host_stage2_unmap_dev_all() w=
ould call
> +        *   kvm_pgtable_stage2_unmap() which will not clear non zero inv=
alid ptes (counted).
> +        * - other MMIO donation: Would fail as we check that the PTE is =
valid or empty.
> +        */

Rephrasing this to see if I got this right. Because MMIO pages are not
tracked in the hyp_vmemmap, the host's stage-2 PTE serves as the sole
record of ownership. We encode PKVM_ID_HYP into an invalid PTE (a
"counted" PTE) to ensure:
- Fault Handling: host_stage2_adjust_range() will explicitly fail if
the host attempts to legitimately map or adjust the protected range.
- Reclaim Protection: Under memory pressure,
host_stage2_unmap_dev_all() will not erase this ownership marker,
because you changed stage2_unmap_walker() to preserve counted PTEs.
- Exclusive Ownership: Subsequent donation attempts (to HYP or a
guest) will safely fail, as donation requires the host PTE to be
either valid (host-owned) or completely empty.

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad









> +       WARN_ON(host_stage2_try(kvm_pgtable_stage2_set_owner, &host_mmu.p=
gt, phys,
> +                               PAGE_SIZE, &host_s2_pool, PKVM_ID_HYP));
> +unlock:
> +       hyp_unlock_component();
> +       host_unlock_component();
> +
> +       return ret;
> +}
> +
> +int __pkvm_hyp_donate_host_mmio(u64 pfn)
> +{
> +       u64 phys =3D hyp_pfn_to_phys(pfn);
> +       u64 virt =3D (u64)__hyp_va(phys);
> +       size_t size =3D PAGE_SIZE;
> +       int ret;
> +       kvm_pte_t pte;
> +
> +       if (addr_is_memory(phys))
> +               return -EINVAL;
> +
> +       host_lock_component();
> +       hyp_lock_component();
> +
> +       ret =3D kvm_pgtable_get_leaf(&pkvm_pgtable, (u64)virt, &pte, NULL=
);
> +       if (ret)
> +               goto unlock;
> +       if (!kvm_pte_valid(pte)) {
> +               ret =3D -ENOENT;
> +               goto unlock;
> +       }
> +
> +       ret =3D kvm_pgtable_get_leaf(&host_mmu.pgt, phys, &pte, NULL);
> +       if (ret)
> +               goto unlock;
> +
> +       if (FIELD_GET(KVM_INVALID_PTE_OWNER_MASK, pte) !=3D PKVM_ID_HYP) =
{
> +               ret =3D -EPERM;
> +               goto unlock;
> +       }
> +
> +       WARN_ON(kvm_pgtable_hyp_unmap(&pkvm_pgtable, virt, size) !=3D siz=
e);
> +       WARN_ON(host_stage2_try(kvm_pgtable_stage2_set_owner, &host_mmu.p=
gt, phys,
> +                               PAGE_SIZE, &host_s2_pool, PKVM_ID_HOST));
> +unlock:
> +       hyp_unlock_component();
> +       host_unlock_component();
> +
> +       return ret;
> +}
> +
>  int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages)
>  {
>         u64 phys =3D hyp_pfn_to_phys(pfn);
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 9b480f947da2..d954058e63ff 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -1152,13 +1152,8 @@ static int stage2_unmap_walker(const struct kvm_pg=
table_visit_ctx *ctx,
>         kvm_pte_t *childp =3D NULL;
>         bool need_flush =3D false;
>
> -       if (!kvm_pte_valid(ctx->old)) {
> -               if (stage2_pte_is_counted(ctx->old)) {
> -                       kvm_clear_pte(ctx->ptep);
> -                       mm_ops->put_page(ctx->ptep);
> -               }
> -               return 0;
> -       }
> +       if (!kvm_pte_valid(ctx->old))
> +               return stage2_pte_is_counted(ctx->old) ? -EPERM : 0;
>
>         if (kvm_pte_table(ctx->old, ctx->level)) {
>                 childp =3D kvm_pte_follow(ctx->old, mm_ops);
> --
> 2.53.0.473.g4a7958ca14-goog
>
