Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA301B0439
	for <kvmarm@lists.linux.dev>; Thu, 31 Jul 2025 08:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753949199; cv=none; b=OQHgLJ3qk3uKGTD6GmeZiqopfeVznWLhVv/gNbK/orP1Dys56naTBMHxHplhomMK2+E2SVSy06LUC9TIGDhOGscX0zjoFQvKp/dnnOEXhP+zq3g4lJIQJnU0AMgAQXAQbQDBBGsVPd58daKXkEzAmbjWQLJpLcOtvoCf3pPQ2JM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753949199; c=relaxed/simple;
	bh=mr0LeiORXgN+VmAIgPtWf5qfGXghcxDMKHFS+n+CGhE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=meaC9q6P0LizZL+ooqfCOMRL6E7MMRicN7xp05zTtJc51rU25byzFIfLIceDlhAnL/J3mh2t/mBYPKmLotmCvahDzL2cGehiX6Z/Qs6hd4hUe68dkeojs2LD9q6Jgq8KF1VNBCgNie1xqX0CE71cpU0MKcrawdwVMAGB7TXoeHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Dj3+OoZ/; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Dj3+OoZ/"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4aaf43cbbdcso137831cf.1
        for <kvmarm@lists.linux.dev>; Thu, 31 Jul 2025 01:06:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753949197; x=1754553997; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=iOwcbIZz6KNHT+FXEYQg3/sY0h2+iUCdrhvHC4IZbB4=;
        b=Dj3+OoZ//T55Kfoe3vITUHyFb1Kqd5OhSAe73DwAUlaGY782/eYDZRhiNHVNPRiDz4
         fKWW5bPmCR1Zk0C38MxAO2hAgjAGK5xawbEvroH/NUasaGwgXVrXVgCERnGZpqK2I+qt
         8bjM2qCYN5Bg014PUsPT2FraXahNxVNGCE8yRDBQ2bXXBKAeH/sD4YfZF5/geMSs3Mrs
         0jxACQBp96ocdLLq3QkABJLONZWvMx26LTAPiePEzBsC9JpUrlTfz9S40YDoEEXTJrVc
         pj69Vy4D+kh8HF7TXmL2vbvjjovLkD0RmBArFXB10iOUdzYHZKbOFxfxDYD5VBzOJwwh
         NUUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753949197; x=1754553997;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iOwcbIZz6KNHT+FXEYQg3/sY0h2+iUCdrhvHC4IZbB4=;
        b=BxT5nQ+AgokONEiwO/yO/H0mbs+vDy6eQu0XxyQpdDPl6veVxzc0WEjLPqH0HoA8Ou
         TlrTDZAyTVa4SX7acW9zim+Z0Ay42Wx9zM5kty28w2/M7nnJavCYF/UOzb6W9cpJjHTu
         +mkVR26PzcuU7ec61zxAujG/FWSFd12H4jdMJ7qLV8+fFiE1Xgk8aaJdFLGxru1hpimn
         6BbPLl3g1GF2YjyYgofwWKSdaTNkl3boj10DGfRJkKHgMofy5zdJcuscgEv6fjhbJeRO
         p6+hqVmrr8fkoJXLjdPh3eA2DDrMMf+MXPL3bXGOhnXcuGDB6uhfyB1ZMC6Qy05klJbx
         EPrw==
X-Forwarded-Encrypted: i=1; AJvYcCXLhXObc5EK8t0DAMMjn5i3oJFywPt6lJSMZ3QM8Ga9Qj9t5uk0ko/++mKRcgeO99mWvj/Itlo=@lists.linux.dev
X-Gm-Message-State: AOJu0YwilMR7NpYbalaEvEJxLibzR3769i+yNQAfDgif1KTGXqu0H6bA
	RFtErr3t0Y9GV6tls0kEH2yehFv7JPK19RWlA+ycuUM/XOP7dPLgvH2QDXAqjEtfgQamDFqxXg0
	23c/vpxVd2T1rXgaFfcRbR1DER4EvEukY6/ZOQNf6
X-Gm-Gg: ASbGncuakvy6izzijwUchv0+IGh8eqVlfy4PM1NUqyVAOULdqRZk+hBwLKENpZBl1OL
	Tvv4JPMLxfAvCv33yMULPA9pMwHvZyDqK6MTumw9KSV99dg7PRDCh3YM0TERTE1D0YbCqPjW2bk
	xxxTgocxb4zX/J6WOq+m3sJwiBMo7eTFapiNoMNKr6zFo5guDJxZyTO1DKusy7U8NBXbn4YYuOD
	uDOKiE=
X-Google-Smtp-Source: AGHT+IHA3J7LZJAKRJ99scN7c7ARq+UBlGN3HkIGNVkFjCG5DU7qogR7qV0uuCgZR4Tq7z9c3HzsMPaQwvZlYCSFprg=
X-Received: by 2002:a05:622a:468e:b0:4a7:1743:106b with SMTP id
 d75a77b69052e-4aeefcc71e5mr1779041cf.6.1753949196737; Thu, 31 Jul 2025
 01:06:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250729225455.670324-1-seanjc@google.com> <20250729225455.670324-14-seanjc@google.com>
In-Reply-To: <20250729225455.670324-14-seanjc@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 31 Jul 2025 09:06:00 +0100
X-Gm-Features: Ac12FXxldpoIc_5xKiLw2SYzn_frwTTJYhqrP2B7q7n9BwFJdyNg9FxkWuacl9I
Message-ID: <CA+EHjTymOVqvWYfMxS=NAa1HuhfGj+aN=zPtTUTephmPbOqNzA@mail.gmail.com>
Subject: Re: [PATCH v17 13/24] KVM: x86/mmu: Hoist guest_memfd max level/order
 helpers "up" in mmu.c
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>, 
	Gavin Shan <gshan@redhat.com>, Shivank Garg <shivankg@amd.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, David Hildenbrand <david@redhat.com>, 
	Ackerley Tng <ackerleytng@google.com>, Tao Chan <chentao@kylinos.cn>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 29 Jul 2025 at 23:55, Sean Christopherson <seanjc@google.com> wrote:
>
> Move kvm_max_level_for_order() and kvm_max_private_mapping_level() up in
> mmu.c so that they can be used by __kvm_mmu_max_mapping_level().
>
> Opportunistically drop the "inline" from kvm_max_level_for_order().
>
> No functional change intended.
>
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Reviewed-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

>  arch/x86/kvm/mmu/mmu.c | 72 +++++++++++++++++++++---------------------
>  1 file changed, 36 insertions(+), 36 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index b735611e8fcd..20dd9f64156e 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3285,6 +3285,42 @@ static int host_pfn_mapping_level(struct kvm *kvm, gfn_t gfn,
>         return level;
>  }
>
> +static u8 kvm_max_level_for_order(int order)
> +{
> +       BUILD_BUG_ON(KVM_MAX_HUGEPAGE_LEVEL > PG_LEVEL_1G);
> +
> +       KVM_MMU_WARN_ON(order != KVM_HPAGE_GFN_SHIFT(PG_LEVEL_1G) &&
> +                       order != KVM_HPAGE_GFN_SHIFT(PG_LEVEL_2M) &&
> +                       order != KVM_HPAGE_GFN_SHIFT(PG_LEVEL_4K));
> +
> +       if (order >= KVM_HPAGE_GFN_SHIFT(PG_LEVEL_1G))
> +               return PG_LEVEL_1G;
> +
> +       if (order >= KVM_HPAGE_GFN_SHIFT(PG_LEVEL_2M))
> +               return PG_LEVEL_2M;
> +
> +       return PG_LEVEL_4K;
> +}
> +
> +static u8 kvm_max_private_mapping_level(struct kvm *kvm, kvm_pfn_t pfn,
> +                                       u8 max_level, int gmem_order)
> +{
> +       u8 req_max_level;
> +
> +       if (max_level == PG_LEVEL_4K)
> +               return PG_LEVEL_4K;
> +
> +       max_level = min(kvm_max_level_for_order(gmem_order), max_level);
> +       if (max_level == PG_LEVEL_4K)
> +               return PG_LEVEL_4K;
> +
> +       req_max_level = kvm_x86_call(gmem_max_mapping_level)(kvm, pfn);
> +       if (req_max_level)
> +               max_level = min(max_level, req_max_level);
> +
> +       return max_level;
> +}
> +
>  static int __kvm_mmu_max_mapping_level(struct kvm *kvm,
>                                        const struct kvm_memory_slot *slot,
>                                        gfn_t gfn, int max_level, bool is_private)
> @@ -4503,42 +4539,6 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
>                 vcpu->stat.pf_fixed++;
>  }
>
> -static inline u8 kvm_max_level_for_order(int order)
> -{
> -       BUILD_BUG_ON(KVM_MAX_HUGEPAGE_LEVEL > PG_LEVEL_1G);
> -
> -       KVM_MMU_WARN_ON(order != KVM_HPAGE_GFN_SHIFT(PG_LEVEL_1G) &&
> -                       order != KVM_HPAGE_GFN_SHIFT(PG_LEVEL_2M) &&
> -                       order != KVM_HPAGE_GFN_SHIFT(PG_LEVEL_4K));
> -
> -       if (order >= KVM_HPAGE_GFN_SHIFT(PG_LEVEL_1G))
> -               return PG_LEVEL_1G;
> -
> -       if (order >= KVM_HPAGE_GFN_SHIFT(PG_LEVEL_2M))
> -               return PG_LEVEL_2M;
> -
> -       return PG_LEVEL_4K;
> -}
> -
> -static u8 kvm_max_private_mapping_level(struct kvm *kvm, kvm_pfn_t pfn,
> -                                       u8 max_level, int gmem_order)
> -{
> -       u8 req_max_level;
> -
> -       if (max_level == PG_LEVEL_4K)
> -               return PG_LEVEL_4K;
> -
> -       max_level = min(kvm_max_level_for_order(gmem_order), max_level);
> -       if (max_level == PG_LEVEL_4K)
> -               return PG_LEVEL_4K;
> -
> -       req_max_level = kvm_x86_call(gmem_max_mapping_level)(kvm, pfn);
> -       if (req_max_level)
> -               max_level = min(max_level, req_max_level);
> -
> -       return max_level;
> -}
> -
>  static void kvm_mmu_finish_page_fault(struct kvm_vcpu *vcpu,
>                                       struct kvm_page_fault *fault, int r)
>  {
> --
> 2.50.1.552.g942d659e1b-goog
>
