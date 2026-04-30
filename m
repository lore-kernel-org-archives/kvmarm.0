Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBFD3428851
	for <kvmarm@lists.linux.dev>; Thu, 30 Apr 2026 14:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777560541; cv=pass; b=CbOh89v+uyKqEyOD3k+yPhf+8asv9eiLFZZR9s4VarsMU54sjJgrvXb/ce9gnQpQ2bmTct8gtM451lmXBYTmDi27zLIs02PbCgvqCsJJmZTqAIvHnaVRr6HQuiXPZ75WFXbo9WKaXnE2Y8LIpWsqi6Y+PphaWkhhgaQFhIk12Zs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777560541; c=relaxed/simple;
	bh=RoAcOrIHVPRxFDCBIiYB6DsdX0Bha8J73vrrAeYRd0w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Me50416R7w+f5lqqZry21RCAoWnL8SvompYwwfou099Uo27AcZsCRBcVAJEBBeKJ/MbAI1nXZKJUC3eCVqpxgv4hOWhu+AUNiAir1ZeDb0heDV2MWGjWwnHexo6VltDO46MOo1944Y9yTY5lv9u+zT9huoVQ0LC/ZcUtLrV94B8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZSqbx92p; arc=pass smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZSqbx92p"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-50d836552daso616081cf.0
        for <kvmarm@lists.linux.dev>; Thu, 30 Apr 2026 07:48:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777560539; cv=none;
        d=google.com; s=arc-20240605;
        b=EJfhc8eikr6Y6jvBZzezmx+HbEEQoK+DgPjwqMILpQwufQ30xZ65Utj7UAVBmruRvk
         sTXUSBzd+AolAKCZ/CLyYlpH6IlDHgiFeJyMzMimUXr3VrZ/cULz8QtkdsALfNVdy/Fr
         dPt7tfQoyPkN6CcIx2rDT09FO8s914PuH+a/kMQiF/ZwiidKM2ihyAxzCuEo21U7ixY+
         0U3volLXTcLhHKEkzp/DC1E3609dzophQRBisJ04R2cIyWhfy7NUYSv1hixgvOhcmxLV
         hz7d5RUpyHoV5DW6VfUghESdo/2H47xV2Rf8aC+z5RadUc5b0mUq8EQoMQtuhR7BL4xh
         K0Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=YywTAYzjXFOYP3ncEM1wtVzQAWbVsUfph15jdqDNJS4=;
        fh=217KzJZDUbEVauIDIUsffRrOYQ5tzvqT7o7Ld0ArmhU=;
        b=dMEVq6BPi6wcHg4kqK+tVeQHOq4nanR3VqtUd8g251gXYoZL0nSex9tM/YqeE8REaQ
         sTtk+JUQ5SOo6OthFS89vauXtsl2jCiZEHF9EZB3qEgURrttaWiXhFcDtprsMvBbaKlJ
         UnnnDCJkiHBz54U9Qi3Y7iZWR8FvxF/nG876pMWYBZ3SzTj92T2TajuNwJcUxAeZa1Ge
         1bmHaMZ684H6f0KwIT7286V1PU7W56pP3vlLidCMlKpjPw+WdWZU1oX0AEicFZBO5Upd
         WYd+mlFVz5pHPRHOjMQY1AU3GbEmlc+XFAj/YukjHUM/1ud4TTE4PPhQmbAwQRkI0uqA
         +J6g==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777560539; x=1778165339; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YywTAYzjXFOYP3ncEM1wtVzQAWbVsUfph15jdqDNJS4=;
        b=ZSqbx92pBkuAOrhNCDA1LBfLXWBZziiiBJHRO/yFDs8Vd0SZxzlLOpUk14GnPqHVeD
         NBuU2WVEbd1AnMVNOiTX8oGnxEmplvIfPOTYgs+cqqLa0qQ0uLaiAKQFJ6q7ANeNQtu3
         vjaZYCJh7IWlvvMqnkFi9UeZM1dQwGV1DHPO3VLGIPg11TvT6WsuD+k8rQVYB3K+7jns
         Um6TDOoCynY6SrodddIldJcmwFnDgEEexuRRY2lutDuiNIVC0GOmF4qDz0U0aijYboh7
         jxSNnxv5eK0duywxuD5R1J95Y0Enben28osvZ5fIJrZ7Fp3WqWbWSrKGjxU7WJX3nQ1X
         S0fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777560539; x=1778165339;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YywTAYzjXFOYP3ncEM1wtVzQAWbVsUfph15jdqDNJS4=;
        b=Qkx7z+U0eGusjF+xh7QltgI2jqKbZ0v8YfrOZRp5gR0CHe1GWTE0AeqltLV+YiDg4G
         vE0Y6JeqM0OrQETKhpT6HpaSTk4DX08/l/SnGrnc5x4UUE91XGAoE3l8LQXKUQUGHH8t
         81xiAzBV72/7AxJrZHU1SlI0jVqBY5dEhiMEEy3xZI95hVb0zMZvDnrJleNUxS4WlBYe
         bqSbVmKH3ZC7rv1e2Z/608RYmCAxRaxaP+kYqHntUIDbfPeibjlECBXXMC1zPj/MvRLu
         Dl0uN65w10+XEPgS03KCSeA5ODObYqH4lnQbrkIO9dnb+yx4AtigTscpQVggeXNQbqpe
         aqBQ==
X-Forwarded-Encrypted: i=1; AFNElJ9T/cwt2J1I8fWDJFpCO9trZqzCSg//Csa0AbhkZD+Jr2hovnly7EtIo7fgCxiK4karxDDDc8U=@lists.linux.dev
X-Gm-Message-State: AOJu0YwlVjXPQPiuCBm8qE5obPbO0oU/2hEoUgR/YGS56fyeky4KCwtx
	UmQU3KeIGoYQuD62k3wHWIcIA3dakz/dkHzS3k32zShAnt5LDiINoIL/I9cLZkXPw6bjc9yp8H3
	su72vUiAm4/NNeHXz/MpF4NBZ8F4Qns6L2A9NoMFz
X-Gm-Gg: AeBDiev45LF3FTudCZZbAEEz4X0dFGXqUDYSag5NOCspQ2+UwjjaaHQkgqrC8lNGdHu
	EW6VaKrB0nCJhNPsznSDUGhahfFGZGvpZCkkKTJtqKjM9Yxtb6aLavDWVZ/SD3VO47h/4mIHTPo
	9bUtCg9EdasCnZdCv1d7aeQDhQnp+paDOOJIPdoY56/iPV5FLS/XLKv57LBSasbC76+CJlNBUSU
	HEWveE9HAHpP+8Y59QqRaIKZq+o4+S1IsPzx/G/qwAJX5z32DCgKBOGTnLPJJoUSB16p81StKra
	7L8IHbOyskseloOmi47EqBLYT/L0SBJEpqZCDDe/vUO1AAtRGufoZLVkIy8=
X-Received: by 2002:ac8:59ca:0:b0:50e:5e19:587a with SMTP id
 d75a77b69052e-5102a3d3061mr12769181cf.3.1777560537878; Thu, 30 Apr 2026
 07:48:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260430132351.280766-1-alexandru.elisei@arm.com>
In-Reply-To: <20260430132351.280766-1-alexandru.elisei@arm.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 30 Apr 2026 15:48:21 +0100
X-Gm-Features: AVHnY4JRtjA1RscP3600FnieC9wDru5uGeiEf45iBeDn0cWuzxNjfpWJrpgZjCk
Message-ID: <CA+EHjTwZ=yFx_NEyw5YEiGqCjsfM=QotHgsCUVQmWDr6cNKLZw@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Handle permission faults with guest_memfd
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	mark.rutland@arm.com
Content-Type: text/plain; charset="UTF-8"

Hi Alexandru,

On Thu, 30 Apr 2026 at 14:24, Alexandru Elisei <alexandru.elisei@arm.com> wrote:
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
> ---
>
> Lightly tested on an Orion O6 board, without pkvm, and without nested
> virtualisation.
>
> Doesn't apply cleanly on top of a7b57e099592, I can send a patch for that if
> needed.
>
>  arch/arm64/kvm/mmu.c | 24 +++++++++++++++++-------
>  1 file changed, 17 insertions(+), 7 deletions(-)
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index d089c107d9b7..dff58de7703b 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1576,6 +1576,7 @@ struct kvm_s2_fault_desc {
>  static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
>  {
>         bool write_fault, exec_fault;
> +       bool perm_fault = kvm_vcpu_trap_is_permission_fault(s2fd->vcpu);
>         enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_SHARED;
>         enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
>         struct kvm_pgtable *pgt = s2fd->vcpu->arch.hw_mmu->pgt;
> @@ -1587,10 +1588,12 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
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

memcache is now uninitialized when perm_fault, and only read in the
!perm_fault branch below. It's safe today, but initializing it to NULL
would silence any defensive analyzer and keep things robust against
future churn.

>
>         if (s2fd->nested)
>                 gfn = kvm_s2_trans_output(s2fd->nested) >> PAGE_SHIFT;
> @@ -1631,9 +1634,16 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
>                 goto out_unlock;
>         }
>
> -       ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, s2fd->fault_ipa, PAGE_SIZE,
> -                                                __pfn_to_phys(pfn), prot,
> -                                                memcache, flags);
> +       if (perm_fault) {
> +               /* Preserve the software bits from the existing table entry. */
> +               prot &= ~KVM_NV_GUEST_MAP_SZ;

Can you please phrase it the same way as the existing comment in
user_mem_abort, as that phrasing more precisely describes the
rationale? i.e.,

   /*
    * Drop the SW bits in favour of those stored in the
    * PTE, which will be preserved.
    */

> +               ret = KVM_PGT_FN(kvm_pgtable_stage2_relax_perms(pgt, s2fd->fault_ipa,
> +                                                               prot, flags));

nit: args wrapped inside KVM_PGT_FN() is inconsistent with the rest of
the file (and with the else-branch immediately below). Every other
call site uses name-only inside the macro. Both expand the same way,
but it's better to stick to the convention.

> +       } else {
> +               ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, s2fd->fault_ipa, PAGE_SIZE,
> +                                                        __pfn_to_phys(pfn), prot,
> +                                                        memcache, flags);
> +       }
>
>  out_unlock:
>         kvm_release_faultin_page(kvm, page, !!ret, prot & KVM_PGTABLE_PROT_W);

With these fixed:

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

>
> base-commit: 254f49634ee16a731174d2ae34bc50bd5f45e731

> --
> 2.54.0
>
