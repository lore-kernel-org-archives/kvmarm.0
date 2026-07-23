Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0513F4582E9
	for <kvmarm@lists.linux.dev>; Thu, 23 Jul 2026 12:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784809869; cv=pass; b=UL3ML5sQY3C2mDxtHqauQqSbkSozwYsrJpIYYH7yEKqBqbDv7V21FOXNPIwM4RDeuaqaTF5iRBrP2Yntnm4/jyHZgjPPhVpW/c2jt22MQjmgd8VumRpk/PzY1Ydo4FZSYkC2DA+qB61hNXkUjZ320LV4D5ZZiFHAYzMKl9K2+Pw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784809869; c=relaxed/simple;
	bh=06iDKLczRvCXxSLT++O3Y0NkJyqxBrSp99UT3VGYPv0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jcWYOA5FV9XTfVqEEfEoZABKule1D/hrtH+QxpI+JWWXk2/pyaeXqJH7ApyUHvWcnBG7gVrWaCHTGCjPYbTqUgGKCLy1RSxNdVzmV1JId2D5XsQcd+l2+snBFw6igpxfP5oEt06L4ed002ovlndLF9K+r14PjAHTu59ifaReGZU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=l55JGNmG; arc=pass smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="l55JGNmG"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-51c10e86e52so179571cf.1
        for <kvmarm@lists.linux.dev>; Thu, 23 Jul 2026 05:31:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784809867; cv=none;
        d=google.com; s=arc-20260327;
        b=QwhFUVxVaIGj838Cs0m+OZiJBYVG6P6wK9IGUnkghWD6urgRbX8fCJBWOaS1gaWZso
         qD/s/JRj0XL43cPsr/CFSJieuhRELaq9T+nLB9utXYca25SALCfgzZnsygxveGWUl27I
         EYNPeXe86ISMmYDu6kU9ssBHY63fyBqyowkIEmG+FDgLJeIfXSFbeUUNEI72nTxbIHRz
         vZZxiDfZ8iwNgo57bKmQuU/9m+DOg5+4FvbDkfJwdkReRuLuxvkVNV/nq/dJ4caemsaX
         fgg1iT1tCXU8+aLsUtrsUcWtGjns3tuLY8dhK1UD4dXhAAonRanLs86X44iBqYzR73sz
         cWTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=GjKwg502tyZxWCtZ7RYBVZ1wpUQ9BQEXF5pbpjIjcNs=;
        fh=AqEYjXFQD0Tk+uLl0yTOkkHt63Thw5m2KtrjrvxBrzQ=;
        b=HAXx6pOKuW6dYdlix1ledSRQZea86jNyH3UMkVIG1FUgCfo1zxFTZxTXp/vCuCysy+
         SKirSmR113WZ1YIijw/oicN8eUOGXSK4gaG+cNSdM7XVU2zvKRKSfJKhfidIyoENRIeb
         d3CKdlMTEu367R/Vdlr7i+FN3PFfGfymQqQUqMxaGMTUkG2ze36uxtPLSnGp7XPkIzIJ
         y77ZfZkkikLOw4Rf37fZM+OrxYHdluIKqo3w2n4C/9LIiezlqJ1mH8/oyPC5tK7FNHqV
         VqjCiX2Kcbyq0QRPPxJJC1S7UCWoMq5zdbnAUCnx9xlGcT81p4cDY6pQ6uqKzdgIDOQg
         Ws9Q==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784809867; x=1785414667; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GjKwg502tyZxWCtZ7RYBVZ1wpUQ9BQEXF5pbpjIjcNs=;
        b=l55JGNmGCe2uqCCMG/E4ZfDsZYS1XPbp1ZZwv9Cg2xI3NJ4DUJPhvaUe1F8Vkgfdqk
         J8mAqvUoJ6cLybItPUPjg3GTEnA1vmN61VTJl6dgrS9NvaehwpHzag/lf7i9YZcYuBLm
         v45820SCZF1pbggxLUKSEU5wGBOBy3gzQ/swPooNO8Q9x7s6f+U3wq3mBIcmI4kCifd4
         yX0RYIyZOxK60xW6HmIy3njtuXonR1kuzsDi+vcBWER3JtsTwletIioboF/4keQ4Oows
         vBQ/VVtC9EX3NECP6hWlynu6pLiu8GIxVneZ26EX3Ozjiq5OYWJXnPO++2RUHXRV3E0y
         RASQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784809867; x=1785414667;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=GjKwg502tyZxWCtZ7RYBVZ1wpUQ9BQEXF5pbpjIjcNs=;
        b=h4mNCKGCEhiDivjJ/O8wkayiwzkYePr/lXGI1jODdqBPSZ8WaZ2iRKmsOc1vOklacl
         eL0V9YIa+1RsbYqSACi4t9yl0Y9p6xeGaA1kHjHJ5ILIHhtSXrGA0RkEaJywr4bg2nBl
         P1ZdTKnFc/Gi0p6Jw7nAI4+StbHmbCfIMCsK1Sdji46pvWPQZKe7Byjx//ScCkL3LNPI
         T7RrVYF0KCddH7R0MHVWJVXiqBF6m2cBcdgqpEEkDZ02Lp1XGgz8hO9eJ1gURQvVcJ1J
         0EYf0Umj5NO8acCDgSnhBjY8fn99rGk+hS8cMwxNnjh9LbvNX2Cv9OpMmpF2AccW4Byn
         PGZg==
X-Forwarded-Encrypted: i=1; AHgh+RrCOQO5D5Yrc6wuZ/VLUSJ3JdPWww6fYKrWMSfsJprdw11RtdYWwxLP/K+MOiaANLUgOU0uYWs=@lists.linux.dev
X-Gm-Message-State: AOJu0YyJd7HPtekBp/MfHpgFP5OyisabuIQtzloulveNmnEd6n6ckeK0
	V9pLPiBDzMvx/0DT2Jr8BBcSo7PUn5tRCZja+KfGAu6YFJY0t+X3mIsMn+3NtusO/QeXZPUxUZO
	FBQy7S8sxIQ7UcaN7pkfUzpgximLfkbpW5oRZtRaI
X-Gm-Gg: AR+sD11KEnFeG3RJaPsZjILtR9+LgXW0WBkdeCRazl10d7iIOnBf8+NXiyDXENmsJz7
	V+VKpZenjEHgErswaqc1J7ZwzdDcytpl189/8BMluqLjCz/OIhEOZIo71dyZrXmnFixQqByZDOJ
	ksX2Gtr2uWAgcPV8ht3Chi9YX7ZNzRcXbDlO4v+QVbToseVW0mDYf3vV2hVOQZuW7I0Wb4suepf
	I+cWIWnpwQMenQtU3uZ6IrxIwWyqfveA2s33bmBMinqJ95vsczGHUSDeGJ8Lg==
X-Received: by 2002:a05:622a:aa43:20b0:51c:7a90:a797 with SMTP id
 d75a77b69052e-5283d85b7b0mr7596281cf.23.1784809866173; Thu, 23 Jul 2026
 05:31:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260720171513.1415357-1-vdonnefort@google.com> <20260720171513.1415357-4-vdonnefort@google.com>
In-Reply-To: <20260720171513.1415357-4-vdonnefort@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 23 Jul 2026 13:30:28 +0100
X-Gm-Features: AUfX_mzbQdbtQwzjAF4zylFKz0WUrBhvIzo9qg77xEfFDecvyAhNZcw6XIXOZ00
Message-ID: <CA+EHjTy0ghocNgufEbieYuKn03f7_kCHH85YcmQ+xviO9GtaLg@mail.gmail.com>
Subject: Re: [PATCH v3 03/17] KVM: arm64: Add pkvm_map_private_va_range
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com, 
	qperret@google.com
Content-Type: text/plain; charset="UTF-8"

On Mon, 20 Jul 2026 at 18:15, Vincent Donnefort <vdonnefort@google.com> wrote:
>
> In preparation for the pKVM heap allocator, introduce
> pkvm_map_private_va_range() to map a physical range into the pKVM
> private range.
>
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad

>
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/mm.h b/arch/arm64/kvm/hyp/include/nvhe/mm.h
> index 00cadd13ee5d..ea97ea49820e 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/mm.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/mm.h
> @@ -31,6 +31,7 @@ int __pkvm_create_private_mapping(phys_addr_t phys, size_t size,
>                                   unsigned long *haddr);
>  int pkvm_create_stack(phys_addr_t phys, unsigned long *haddr);
>  int pkvm_alloc_private_va_range(size_t size, unsigned long *haddr);
> +int pkvm_map_private_va_range(void *haddr, phys_addr_t phys, size_t size);
>  phys_addr_t pkvm_private_va_range_pa(void *va);
>
>  #endif /* __KVM_HYP_MM_H */
> diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
> index 5cd2f1fe51e4..20e4445dd57b 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mm.c
> @@ -25,6 +25,7 @@ struct memblock_region hyp_memory[HYP_MEMBLOCK_REGIONS];
>  unsigned int hyp_memblock_nr;
>
>  static u64 __io_map_base;
> +static u64 __hyp_private_va_start;
>
>  struct hyp_fixmap_slot {
>         u64 addr;
> @@ -90,6 +91,31 @@ int pkvm_alloc_private_va_range(size_t size, unsigned long *haddr)
>         return ret;
>  }
>
> +/**
> + * pkvm_map_private_va_range() - Map a physical range into the private VA range
> + * @haddr:     The virtual address in the private range.
> + * @phys:      The physical address to map.
> + * @size:      The size of the range to map.
> + *
> + * The hypervisor VA @haddr must have been first allocated with pkvm_alloc_private_va_range()
> + *
> + * Return: 0 on success, negative error code on failure.
> + */
> +int pkvm_map_private_va_range(void *haddr, phys_addr_t phys, size_t size)
> +{
> +       unsigned long addr = (unsigned long)haddr;
> +
> +       if (!PAGE_ALIGNED(addr | phys | size))
> +               return -EINVAL;
> +
> +       guard(hyp_spinlock)(&pkvm_pgd_lock);
> +
> +       if (addr < __hyp_private_va_start || addr + size > __io_map_base)
> +               return -EINVAL;
> +
> +       return kvm_pgtable_hyp_map(&pkvm_pgtable, addr, size, phys, PAGE_HYP);
> +}
> +
>  phys_addr_t pkvm_private_va_range_pa(void *va)
>  {
>         kvm_pte_t pte = 0;
> @@ -450,6 +476,7 @@ int hyp_create_idmap(u32 hyp_va_bits)
>          */
>         __io_map_base = start & BIT(hyp_va_bits - 2);
>         __io_map_base ^= BIT(hyp_va_bits - 2);
> +       __hyp_private_va_start = __io_map_base;
>         __hyp_vmemmap = __io_map_base | BIT(hyp_va_bits - 3);
>
>         return __pkvm_create_mappings(start, end - start, start, PAGE_HYP_EXEC);
> --
> 2.55.0.229.g6434b31f56-goog
>
