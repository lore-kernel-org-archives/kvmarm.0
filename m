Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD8A6406276
	for <kvmarm@lists.linux.dev>; Tue,  5 May 2026 12:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777982467; cv=pass; b=IqMGY/9qeyto1/NwswtXwjyq+BkvkBo/j6gMK+uZ7/3vvQjW5Sm2UTCsGKrTI/94L92G3aY+ahzZBhdJj5Y0jjAS5pRqvm4NPpw+oR6wBqHHpx6hD0uirFljX2QJU4+BXek88MZ8936s7Ixin4XKTOy0SHFVCY8HvQZiGNk4R14=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777982467; c=relaxed/simple;
	bh=xjN0BV92hJMeJh4HWOHhhfDdSUg30H5ySa2J0+tra+s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ToYbOEpsecmbT3g7knNj1tWspfkh0EcohBanxZOURao6rFiEQ8cmVxJQ3VME/xopEpnEk3ErZFtLr/gjrGv0cqtr+igpiDeKrS/iH0DCJd3BfktzddVzLw2UKfN7ABcv02JUE5Rsbkwi99kbVNHvOGEzFY+OSjcBMmgKa7c4Tv8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iHXz91H2; arc=pass smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iHXz91H2"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-50d864c23bdso497831cf.1
        for <kvmarm@lists.linux.dev>; Tue, 05 May 2026 05:01:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777982465; cv=none;
        d=google.com; s=arc-20240605;
        b=E4bI5rXIpxES1CX4Zne9lEB9dZ62K8yoVE8OQ2de+JEhqFs758fd+A3ajRxIIw2y0j
         e5da5miG3VFfn9iAXK+Yz0xNH8WPjr7xG/cVRpnauZFiP2JyHSqX2LNXupsyIk9y8gVQ
         gqI2zsYTvgaAh5d4795jZYMd+7+7gNi9huCoGXNDJn2v1aEtx3p1+m7oGRAFXmoXK93w
         5vtriaAIxpEngDqlCs3z+TWY8vnMsFFfECuNIjAmrmUbycki+hX8kA1yl0dPW1f43+zG
         mxbvo/KE4xmqxNWxtlh47ZhUt/PHorCev1WQm8+iJmpiwY5y3zqdVB2rI3+yLtDS+tDw
         2qdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=/BvEwyq6RtfUN9ToJaYs9n24jZfPYPRCO7RFZzu7hcY=;
        fh=gGgkuj+nNJppMXkdF44tQsGdFyTGpGN8m/Ea/jmeqEA=;
        b=AnQfPzhxW7akhMnrKqnnAVIFchsBOA9N4c0O4J8v4MyfUERpvL6BBthq6iOJg+2XAG
         uuJzXb+TQs4d7izCfwfwXXYOnvmQKjtHTz+mmeUv6iFsY5oqvANS0I02AQn3unwIzzEd
         xaEm3G97s3NJftfy+PL/NH7x1ZvTFJHXSz1yRM6c945QbDAdTjvl4iJA0ig3fOANyzhk
         n0OMzebFSqkffBTQqKXuwHjHRWe73GZz5O+UnItvd6+yJDVGkEyJarTkAHjUSU1AVvcf
         FhxueEbSYjV7/Z1kKPRep55a8CooHB6M3dqOJVeZnhjLVYOv8Wn9gNnW8iGZnos9hgy1
         KTzQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777982465; x=1778587265; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/BvEwyq6RtfUN9ToJaYs9n24jZfPYPRCO7RFZzu7hcY=;
        b=iHXz91H2H2V0Tn51Mbh4P7JrW0+D/682dA6PmMn3r3SyGL0yfZ0TAE4aihx/sVtj/v
         ZJ1qioSHBjEuYorTeKyrL7yuMfjFO++obSv8ORiqutRf5Nra5rty9/BeWLaWOr9n6zZR
         6ng1uIHSlnuwG/uo7RROSDzTm5BkB0YRnL5CyOBQ6PT8cKLeuIcSjIsjcO8UNiAozmv4
         VrgQFpYsbTq1oKLZIdvyXlOLj0pftpyDyAPrf4+BIyYMKtcTCdX9GtYaainfGYcmWGbQ
         4nLEXpD69quL0IXJGxzp067QEgF7r5udJqohURTepLmtoCedzPYHUo1I0ImlDy9Hcr1E
         WALQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777982465; x=1778587265;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/BvEwyq6RtfUN9ToJaYs9n24jZfPYPRCO7RFZzu7hcY=;
        b=mlDyRfabpqRcVH0GznaTj2QOTiL16d/yyzPxw1LZkQOLuA/CV2Asiuj0NKu4IioJXC
         KsxIkNYZ8T7B+d2OXnVJ+KBi+pbpB8I608SkF2zG8TzjSS/Yb1HZX0ocPSoqYgPY51wN
         zQ2tUD7vJgh2GXBW1VEuN6K+FJqVOrkTmmbDiLQ+Awc7n9g7v6UUEdDbit3VDoA1Xc5U
         I7VfrSQupFPtzuAQ/tSrk2tc5qI+sScgJwmy4j5egdOoI7PgKS7cInqxGwoPvDZlsVVS
         aMDJk7+PnLXAwMTUxcApAE+psiJYd879gZho6D/qUeXslk5jEYqgsnq98G6TrfNtEI/N
         vl3A==
X-Forwarded-Encrypted: i=1; AFNElJ+NlWSnnh/3ibtc3ZBYQ1YmdtFN8dRrhZMv3L0EglqInYmXTx/nAFbX7mGRnuokxgVZkIyXV2E=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw/xflcPt0oUh4pwlguDtJQ8GOtYBNnfMIytiRTWa0Nwq4W7LlQ
	E3biboWlIMtr58KwwTDQQuylzU5n2lJWOcFsoIDzqUSo5UxrsUx5bZZbGr9bWBthp7HiJ/LWUwG
	5sNIdxDpFAcpxp6v4PnCLxuqiGjd2e0t+3z4F02e2
X-Gm-Gg: AeBDievmpc3l+dtCEY4zsCiT77VLRFdyJ9XTqxK67FSHwvmZIZcu0diAztOW1/zpoeE
	/6J/DQE9w8QvAQpSXf/TpxDUuQQYfjIRNq9JcHakWCzEqFiWR5oiVzalOzxltZWYhwVE8lJDlGT
	N2JvaQB+Qxn2TuH/iHwPhdeWv1HVsdb2JD8mf+bhLWll+T6tym81mba7mx6ztf3wWhZfqB2L43H
	1oEQN6/fKVAjl2fI5xTRUHw3lCWPqcF6R56n/tG+Lf1x+Esp4JZQfhU2hT207L0VcGR1vRwp1ks
	afZMejUwDfs3vx46Zw+LSOHl+rpqag==
X-Received: by 2002:a05:622a:a95c:b0:50e:5eba:cadd with SMTP id
 d75a77b69052e-51305867464mr11541251cf.2.1777982463977; Tue, 05 May 2026
 05:01:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260505094913.75317-1-alexandru.elisei@arm.com>
In-Reply-To: <20260505094913.75317-1-alexandru.elisei@arm.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 5 May 2026 13:00:00 +0100
X-Gm-Features: AVHnY4JaDYMfB-bS23GJEZJxoVLgopq4yapMzLa4Y79cLpgf8PCSU_XNoIqvWqg
Message-ID: <CA+EHjTy1FDraLaj520-gdP6E201qLUA9jDjDWuE4ODwXKF5V5A@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: arm64: Handle permission faults with guest_memfd
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	mark.rutland@arm.com
Content-Type: text/plain; charset="UTF-8"

On Tue, 5 May 2026 at 10:49, Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>
> gmem_abort() calls kvm_pgtable_stage2_map() to make changes to stage 2. It
> does this for both relaxing permissions on an existing mapping and to
> install a missing mapping.
>
> kvm_pgtable_stage2_map() doesn't make changes to stage 2 if there is an
> existing, valid entry and the new entry modifies only the permissions.
> This is checked in:
>
> kvm_pgtable_stage2_map()
>   stage2_map_walk_leaf()
>      stage2_map_walker_try_leaf()
>        stage2_pte_needs_update()
>
> and if only the permissions differ, kvm_pgtable_stage2_map() returns
> -EAGAIN and KVM returns to the guest to replay the instruction. The
> assumption is that a concurrent fault on a different VCPU already mapped
> the faulting IPA, and replaying the instruction will either succeed, or
> cause a permission fault, which should be handled with
> kvm_pgtable_stage2_relax_perms().
>
> gmem_abort(), on a read or write fault on a system without DIC (instruction
> cache invalidation required for data to instruction coherence), installs a
> valid entry with read and write permissions, but without executable
> permissions. On an execution fault on the same page, gmem_abort() attempts
> to relax the permissions to allow execution, but calls
> kvm_pgtable_stage2_map() to change the existing, valid, entry.
> kvm_pgtable_stage2_map() returns -EAGAIN and KVM resumes execution from the
> faulting instruction, which leads to an infinite loop of permission faults
> on the same instruction.
>
> Allow the guest to make progress by using kvm_pgtable_stage2_relax_perms()
> to relax permissions.
>
> Fixes: a7b57e099592 ("KVM: arm64: Handle guest_memfd-backed guest page faults")
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> ---
>
> v1: https://lore.kernel.org/kvmarm/20260430132351.280766-1-alexandru.elisei@arm.com/
>
> Changes from v1:
> - Rebased on top of v7.1-rc2.
> - Initialised memcache to NULL (Fuad).
> - Copied kvm_pgtable_stage2_relax_perms() comment from kvm_s2_fault_map()
>   (Fuad).
> - Fixed KVM_PGT_FN() macro invocation (Fuad).
>
> Same as before, tested booting a linux VM on Orion O6, no pkvm, no nested virt.
>
>  arch/arm64/kvm/mmu.c | 29 +++++++++++++++++++++--------
>  1 file changed, 21 insertions(+), 8 deletions(-)
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index d089c107d9b7..4da9281312eb 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1576,21 +1576,24 @@ struct kvm_s2_fault_desc {
>  static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
>  {
>         bool write_fault, exec_fault;
> +       bool perm_fault = kvm_vcpu_trap_is_permission_fault(s2fd->vcpu);
>         enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_SHARED;
>         enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
>         struct kvm_pgtable *pgt = s2fd->vcpu->arch.hw_mmu->pgt;
>         unsigned long mmu_seq;
>         struct page *page;
>         struct kvm *kvm = s2fd->vcpu->kvm;
> -       void *memcache;
> +       void *memcache = NULL;
>         kvm_pfn_t pfn;
>         gfn_t gfn;
>         int ret;
>
> -       memcache = get_mmu_memcache(s2fd->vcpu);
> -       ret = topup_mmu_memcache(s2fd->vcpu, memcache);
> -       if (ret)
> -               return ret;
> +       if (!perm_fault) {
> +               memcache = get_mmu_memcache(s2fd->vcpu);
> +               ret = topup_mmu_memcache(s2fd->vcpu, memcache);
> +               if (ret)
> +                       return ret;
> +       }
>
>         if (s2fd->nested)
>                 gfn = kvm_s2_trans_output(s2fd->nested) >> PAGE_SHIFT;
> @@ -1631,9 +1634,19 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
>                 goto out_unlock;
>         }
>
> -       ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, s2fd->fault_ipa, PAGE_SIZE,
> -                                                __pfn_to_phys(pfn), prot,
> -                                                memcache, flags);
> +       if (perm_fault) {
> +               /*
> +                * Drop the SW bits in favour of those stored in the
> +                * PTE, which will be preserved.
> +                */
> +               prot &= ~KVM_NV_GUEST_MAP_SZ;
> +               ret = KVM_PGT_FN(kvm_pgtable_stage2_relax_perms)(pgt, s2fd->fault_ipa,
> +                                                                prot, flags);
> +       } else {
> +               ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, s2fd->fault_ipa, PAGE_SIZE,
> +                                                        __pfn_to_phys(pfn), prot,
> +                                                        memcache, flags);
> +       }
>
>  out_unlock:
>         kvm_release_faultin_page(kvm, page, !!ret, prot & KVM_PGTABLE_PROT_W);
>
> base-commit: 7fd2df204f342fc17d1a0bfcd474b24232fb0f32
> --
> 2.54.0
>
