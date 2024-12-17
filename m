Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0F6E199FAB
	for <kvmarm@lists.linux.dev>; Tue, 17 Dec 2024 08:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734425296; cv=none; b=KxneI//r8g+pVoodISQoDVKMRYs0KZy+xMwOY7RLXopqZpOr6wFDC3geyp1tH3b4OjFLSAw1Fl26TVtPXIcDTCo1Loy7+UQaIvb9NyvPjVktfByS7RSNLxz6Q/NbsOGOumKdVHozKbWc6obBevLk8L8uBGbievDMH11Jovrj9YI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734425296; c=relaxed/simple;
	bh=f3+wCCi2+3GP9ZXjPr/bYLYTWLWbG8mi+tQ3t2mS/90=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QTWnRcMr+8VWOu5WIjSiMGR2cmng9HmNX1bjCM2Zjoq+UvWK7kEz+awc1CopiHXlypMOeNLhAL/RT35mTRH3BgDiRA2/cVOq0Y4CiB3xOF+XfLNTvevk70qSCPuwpOCZEgyARqE9WTjnsvYQCQCyYz5SI7clar9ByyVW/H+0z2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=phxSB9ZH; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="phxSB9ZH"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-435b0df5dbdso39215e9.0
        for <kvmarm@lists.linux.dev>; Tue, 17 Dec 2024 00:48:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734425293; x=1735030093; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gMYpfoWdpBNaOFR2NyYkq3I9j/Q/VkoKRerwMIo78jE=;
        b=phxSB9ZHbAlsezoUXU5gapjVRTOMSAhD/DM/rkLRPOA6W/hQMFT+ww5GSLLwkd2go/
         wMSNQgw8nGpgQyKo2Ud2vvJTJ1ekAjDwpsqJH7TVQDucs0zQuDQyxBrFYgKYBcO7mUnC
         cWytod5QCwk6QMTJYVbZM/oM/q89okzOAGpw/tjx6ehLeY2DRM9yXxdA4QEc1Fsbw920
         oxvVj6fDvIhe9Ngz9y3iphBEZH02h0KxmaO0lkPdySB+UryjVHtVYbw0YXUuTdwOtlvW
         lhcA16fmOb3nlFFYzZ6ESO5P4nFOpcomYN5voKta6uPTHAATsXy12nZhhRTBI8G6ezq0
         5m+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734425293; x=1735030093;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gMYpfoWdpBNaOFR2NyYkq3I9j/Q/VkoKRerwMIo78jE=;
        b=FABlRrpfOKlWAoHWYc6T/n4Jku9Cym8grvX/mOe0ysY5NBLG4U/CxaJYFmCg1mcSQv
         AjhG4hzpKfWELi7cTMQPQbNchjFJ2yLzuwg+zUh1z32G2exMwxvXKoGu5hN1MaTHHj6n
         DVHcC5cyAvdhph7l9xLb5/hj2eUPgPlb+6ZdJgtalzal+io5C2UXf6SkjfZ35lBr1GCb
         ec6Wh6YPfjHVHgoSkvuSNOvtJvXVz5cSQyJ0MKb29BUFhnkeR1jF9Vz4JQ6AGRUU9IDl
         Jk7OsjcywXwzG5AOWYlKzZbMgt7WHVcm0yXLFx/0mwh/tx15E5sqHT/M+kSagYHhb175
         Nttg==
X-Forwarded-Encrypted: i=1; AJvYcCWj/0UdYOeOoYc90vSsGDFU4ot0YZ8Yi/Kk8voeYwff+NfT/4svuzb85gCXgrTN66gAG5fYomk=@lists.linux.dev
X-Gm-Message-State: AOJu0YyZgMzkAYbAmQtba0NupxeRcNWxX8vahjrFL/LLdeO75QWiqV7W
	1tKyqoD8Hu1GZ9fmgN9JpuR08TtIu3E7LgT6cCeFtMkm+xUH/8TDPk5pGAS7ii9TVTRiwGWYWlU
	qmyDXwfFmt5EBmsWe2QX3dxFwP3LUJ86Y/b2Mt4hGGUOcDdX/hDeb
X-Gm-Gg: ASbGncvbHD2KEVWi27J+LUPqhY4BYkq8kbxES3jI3TfbiOZUtGz22IFcORSjAV+QWGL
	Cft1ehK3RhsFq2AiSUCechQEWLgUGttzsjHoIyefINpv5Erxqft2YK2em+YPR1wg4erg=
X-Google-Smtp-Source: AGHT+IG/Se7TNjDy/dA04D4nI9U71yqzcRt/JnA8mD3zMM8rr+IipCSu6Ag3mBRutPKt603pm6N3vN4f+iqaAFukznc=
X-Received: by 2002:a05:600c:5707:b0:434:f7fc:1b18 with SMTP id
 5b1f17b1804b1-436492cfbfamr896425e9.4.1734425293043; Tue, 17 Dec 2024
 00:48:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241216175803.2716565-1-qperret@google.com> <20241216175803.2716565-7-qperret@google.com>
In-Reply-To: <20241216175803.2716565-7-qperret@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 17 Dec 2024 08:47:35 +0000
Message-ID: <CA+EHjTyf+yjBsQ5zGs+PZJGUJSSftyEepo6A7YmgMnf8cTMH1w@mail.gmail.com>
Subject: Re: [PATCH v3 06/18] KVM: arm64: Pass walk flags to kvm_pgtable_stage2_relax_perms
To: Quentin Perret <qperret@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Vincent Donnefort <vdonnefort@google.com>, 
	Sebastian Ene <sebastianene@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 16 Dec 2024 at 17:58, Quentin Perret <qperret@google.com> wrote:
>
> kvm_pgtable_stage2_relax_perms currently assumes that it is being called
> from a 'shared' walker, which will not be true once called from pKVM. To
> allow for the re-use of that function, make the walk flags one of its
> parameters.
>
> Signed-off-by: Quentin Perret <qperret@google.com>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> ---
>  arch/arm64/include/asm/kvm_pgtable.h | 4 +++-
>  arch/arm64/kvm/hyp/pgtable.c         | 6 ++----
>  arch/arm64/kvm/mmu.c                 | 7 +++----
>  3 files changed, 8 insertions(+), 9 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index 38b7ec1c8614..c2f4149283ef 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -707,6 +707,7 @@ bool kvm_pgtable_stage2_test_clear_young(struct kvm_pgtable *pgt, u64 addr,
>   * @pgt:       Page-table structure initialised by kvm_pgtable_stage2_init*().
>   * @addr:      Intermediate physical address to identify the page-table entry.
>   * @prot:      Additional permissions to grant for the mapping.
> + * @flags:     Flags to control the page-table walk (ex. a shared walk)
>   *
>   * The offset of @addr within a page is ignored.
>   *
> @@ -719,7 +720,8 @@ bool kvm_pgtable_stage2_test_clear_young(struct kvm_pgtable *pgt, u64 addr,
>   * Return: 0 on success, negative error code on failure.
>   */
>  int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
> -                                  enum kvm_pgtable_prot prot);
> +                                  enum kvm_pgtable_prot prot,
> +                                  enum kvm_pgtable_walk_flags flags);
>
>  /**
>   * kvm_pgtable_stage2_flush_range() - Clean and invalidate data cache to Point
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 0470aedb4bf4..b7a3b5363235 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -1307,7 +1307,7 @@ bool kvm_pgtable_stage2_test_clear_young(struct kvm_pgtable *pgt, u64 addr,
>  }
>
>  int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
> -                                  enum kvm_pgtable_prot prot)
> +                                  enum kvm_pgtable_prot prot, enum kvm_pgtable_walk_flags flags)
>  {
>         int ret;
>         s8 level;
> @@ -1325,9 +1325,7 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
>         if (prot & KVM_PGTABLE_PROT_X)
>                 clr |= KVM_PTE_LEAF_ATTR_HI_S2_XN;
>
> -       ret = stage2_update_leaf_attrs(pgt, addr, 1, set, clr, NULL, &level,
> -                                      KVM_PGTABLE_WALK_HANDLE_FAULT |
> -                                      KVM_PGTABLE_WALK_SHARED);
> +       ret = stage2_update_leaf_attrs(pgt, addr, 1, set, clr, NULL, &level, flags);
>         if (!ret || ret == -EAGAIN)
>                 kvm_call_hyp(__kvm_tlb_flush_vmid_ipa_nsh, pgt->mmu, addr, level);
>         return ret;
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index a2339b76c826..641e4fec1659 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1452,6 +1452,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>         enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
>         struct kvm_pgtable *pgt;
>         struct page *page;
> +       enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_HANDLE_FAULT | KVM_PGTABLE_WALK_SHARED;
>
>         if (fault_is_perm)
>                 fault_granule = kvm_vcpu_trap_get_perm_fault_granule(vcpu);
> @@ -1695,13 +1696,11 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>                  * PTE, which will be preserved.
>                  */
>                 prot &= ~KVM_NV_GUEST_MAP_SZ;
> -               ret = kvm_pgtable_stage2_relax_perms(pgt, fault_ipa, prot);
> +               ret = kvm_pgtable_stage2_relax_perms(pgt, fault_ipa, prot, flags);
>         } else {
>                 ret = kvm_pgtable_stage2_map(pgt, fault_ipa, vma_pagesize,
>                                              __pfn_to_phys(pfn), prot,
> -                                            memcache,
> -                                            KVM_PGTABLE_WALK_HANDLE_FAULT |
> -                                            KVM_PGTABLE_WALK_SHARED);
> +                                            memcache, flags);
>         }
>
>  out_unlock:
> --
> 2.47.1.613.gc27f4b7a9f-goog
>
