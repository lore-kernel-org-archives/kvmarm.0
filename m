Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F302A18B46E
	for <kvmarm@lists.linux.dev>; Tue, 17 Dec 2024 08:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734425284; cv=none; b=YENZTw0JRvNHOa7zCFVQKm3vA7N2HN4+lm3YCQClz/b1iJLMuNbSWATPyQ0oiUUjAQXyMKTHQO0/bIuIiiwKXWV8RarJ+QOqBV5jrSBiROyYfhVQvp++I3AGY5D2gOTipgp2U/smylGUBULBsvrIUk6CPU5MZdbCYgrzeLDF6N8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734425284; c=relaxed/simple;
	bh=y6oO2c62Z7FAKERSlKc3B+GB0QalB/SXetwRKAGhlmc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K0tUzl5hrW8w0nUOvitoXLX/Pe7+qQRf8VejQRf8mH0FWcSGSSaSWTeoA4x7K2rODz+bfD9hkPEjs6fR+g4CZKi2kxos2ZMTK5OPoZ7Xtu7z9XHYHA3ZRVxVj/SRnJIDlkUN1mnghmJIUJJQARDxRLU+Vvobl7PJuYIvqV0Tex8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rsKQMVGP; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rsKQMVGP"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4361d5730caso27185e9.1
        for <kvmarm@lists.linux.dev>; Tue, 17 Dec 2024 00:48:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734425281; x=1735030081; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6hCYoIRnSlinICHyKBQa7JIGTnDJ2BuS+GfwqYyMo7E=;
        b=rsKQMVGPHGyj7WS+WNcPlbZ9udzyBr1mfa/7tD59VA3H4v4yxqvA2pYCfTEu1alm4B
         msCHjQQGjGA1ePHynWkrVlh0Vnm+8RwhGb3Ah9c56RVjnlMXxlpZoVlruNcGqlocEii9
         WYyEwuR14Tf9jYbChtzGEqQVN2ui2JQtYvm4lNI+MNm4NdKkWKELVq6E8dDHIB5KkvfU
         hfIoJqM6c5uAgIpdHh9Az/R/PgGTim1XyBtFW+cO1Jsknji/tHznVvpch2NyibPHgNRw
         52R5NPtGwGIFznqcLmO69F8x2vBJAhbW0fUpXVggFUHj6p+xim7o5Ye+am4FKO3vnb71
         HTbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734425281; x=1735030081;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6hCYoIRnSlinICHyKBQa7JIGTnDJ2BuS+GfwqYyMo7E=;
        b=Ytb8M/Zcvu+znBLq+ZmcpXVcZwYmGxSD6OJn332ufuBP8o3XIol6+53+aIw5hlT4EG
         orWC/OSTyb7Kw5pwB/4yaPn5iEl8d0rfZbTzRb9BSM/FynKIrDfQBPtgnEQQL+cqkzFw
         B8458TY+ZAuV7Qn3z/SIHPeOrauOnRnOaItl0Ys1Bk1PHWqEnJShFlmTGJz5IKFgEcjm
         WqTgx0w/It/5EzdZDK3MYvrBWGJFwxRI1lwAfcrxMFQByoEujhIpWY4nUolQCd4WNQZL
         orTC8f7ukISfBS1mdu9L5V2hE+fDAPQchC/oLKmJRZgD7W/wUEdfmas8UWytT6jzNTO/
         yoEQ==
X-Forwarded-Encrypted: i=1; AJvYcCWK2Wl2+u9BzglOBwwvx31LuKKNYyRexLwpFEH9eG8gejQycRn0HcSJg7Z6Et8b69vWd4tID6I=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzskws6ZkIsFlxkgq9leup9oXBXUgDGEq24+Ia/IF7uY4NejO7H
	JuaF+DeHfyQCxbNgTUz/SB3mO3u1GmitIITXOxczp3gDmCw5u5lmww5FTC06yNihW+KtshI/x1K
	nDv2MvqRv9oiJj/Uza9lg6H3LR0jlzVsE475Y
X-Gm-Gg: ASbGncvtwcO6g6imH22iPu1x+XeahkwiBHd+XSFA1Cnpa6Uht36nzOqdIrdjOzhmnTC
	nR7OdOD8ACDJx1GokCXuqTSYZeFKdYEm+l0GTFn78H1gziB1oD30xVvVYq4O+/cO1cxo=
X-Google-Smtp-Source: AGHT+IFxXKN9usqQV3kNbNh4Lz31/fk7TbK5vkz5uPgTlGxQEqYyZajHdqHVpeCOx8ECqjWbYxVv8GfDoeuTtmoKPxQ=
X-Received: by 2002:a7b:ce88:0:b0:436:186e:13a6 with SMTP id
 5b1f17b1804b1-436492cf51dmr1039795e9.6.1734425281269; Tue, 17 Dec 2024
 00:48:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241216175803.2716565-1-qperret@google.com> <20241216175803.2716565-6-qperret@google.com>
In-Reply-To: <20241216175803.2716565-6-qperret@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 17 Dec 2024 08:47:24 +0000
Message-ID: <CA+EHjTzfqR8=g=VzazL3__TyGpJJtPCoG20sJeUnY+d0b6NSBA@mail.gmail.com>
Subject: Re: [PATCH v3 05/18] KVM: arm64: Pass walk flags to kvm_pgtable_stage2_mkyoung
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
> kvm_pgtable_stage2_mkyoung currently assumes that it is being called
> from a 'shared' walker, which will not be true once called from pKVM.
> To allow for the re-use of that function, make the walk flags one of
> its parameters.
>
> Signed-off-by: Quentin Perret <qperret@google.com>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> ---
>  arch/arm64/include/asm/kvm_pgtable.h | 4 +++-
>  arch/arm64/kvm/hyp/pgtable.c         | 7 +++----
>  arch/arm64/kvm/mmu.c                 | 3 ++-
>  3 files changed, 8 insertions(+), 6 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index aab04097b505..38b7ec1c8614 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -669,13 +669,15 @@ int kvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size);
>   * kvm_pgtable_stage2_mkyoung() - Set the access flag in a page-table entry.
>   * @pgt:       Page-table structure initialised by kvm_pgtable_stage2_init*().
>   * @addr:      Intermediate physical address to identify the page-table entry.
> + * @flags:     Flags to control the page-table walk (ex. a shared walk)
>   *
>   * The offset of @addr within a page is ignored.
>   *
>   * If there is a valid, leaf page-table entry used to translate @addr, then
>   * set the access flag in that entry.
>   */
> -void kvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr);
> +void kvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr,
> +                               enum kvm_pgtable_walk_flags flags);
>
>  /**
>   * kvm_pgtable_stage2_test_clear_young() - Test and optionally clear the access
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 40bd55966540..0470aedb4bf4 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -1245,14 +1245,13 @@ int kvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size)
>                                         NULL, NULL, 0);
>  }
>
> -void kvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr)
> +void kvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr,
> +                               enum kvm_pgtable_walk_flags flags)
>  {
>         int ret;
>
>         ret = stage2_update_leaf_attrs(pgt, addr, 1, KVM_PTE_LEAF_ATTR_LO_S2_AF, 0,
> -                                      NULL, NULL,
> -                                      KVM_PGTABLE_WALK_HANDLE_FAULT |
> -                                      KVM_PGTABLE_WALK_SHARED);
> +                                      NULL, NULL, flags);
>         if (!ret)
>                 dsb(ishst);
>  }
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index c9d46ad57e52..a2339b76c826 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1718,13 +1718,14 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  /* Resolve the access fault by making the page young again. */
>  static void handle_access_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
>  {
> +       enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_HANDLE_FAULT | KVM_PGTABLE_WALK_SHARED;
>         struct kvm_s2_mmu *mmu;
>
>         trace_kvm_access_fault(fault_ipa);
>
>         read_lock(&vcpu->kvm->mmu_lock);
>         mmu = vcpu->arch.hw_mmu;
> -       kvm_pgtable_stage2_mkyoung(mmu->pgt, fault_ipa);
> +       kvm_pgtable_stage2_mkyoung(mmu->pgt, fault_ipa, flags);
>         read_unlock(&vcpu->kvm->mmu_lock);
>  }
>
> --
> 2.47.1.613.gc27f4b7a9f-goog
>
