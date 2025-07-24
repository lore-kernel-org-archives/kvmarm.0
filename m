Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41F312367CD
	for <kvmarm@lists.linux.dev>; Thu, 24 Jul 2025 23:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753398225; cv=none; b=IVmcNMMna08gXQfqLeppjUcGpym80YgXB241qZ0/A0MocNrQYV5+dtT8jzsmi+5ZSaTjGcQ+X2H5cCXjNiAG6XIvxr5Utq1meZNBPTF+pcN6c40sz+po3ZnE7SWmojjA7trALxPMYwVw9qJcuQ+9Hpln7aaCXWDVcgAeDRl21bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753398225; c=relaxed/simple;
	bh=Lbu1j2VeC+YUlaGAQB1et29Lmaxg0KeQQE+Hwd4SVNM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=i/J74UuSlOnX8/+MCAvFZM4PWZ34qa3YumE2GyNK/9sNU/tWsnDC5Cd4/z1m0+SuZASmUSoRyVWNwWntftQWWfnLJG//KUDH4FeCbqz9HU067TcKHMme36WLQiA5LCaXn/oPsM3EnPi+Rspc9iliQHzaZ8QxS5Y95FdR7Ip/OvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FqgdRclC; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FqgdRclC"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b3bde4d4d5cso1119566a12.2
        for <kvmarm@lists.linux.dev>; Thu, 24 Jul 2025 16:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753398224; x=1754003024; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ISsvFCUycsXMABHVDYSoSHE4WtWUnZpEr5ejibgkla0=;
        b=FqgdRclCAuvE3rL53nPCuClwDZzjJcaVG7tZ/og7WxhGSOb0+nnCQdqVXRQvsZcZBC
         iyvJRlCy5fzBlvXl9xwCrRCKxmLbif/fakQAK/CLd9D8Zk3bHTLLhVWmIQH1BG2/d7w9
         fkTIIVQFCcJbEWkXRoGTFLvPEZjb9QpsPXCwTK3iMtmtE5ZS7aIxvuIXwUqRy7XKuUdI
         fU0jG2jpMXJRUT4stsgbEJXRoRtuxs7GB/5bbR+HM1r2kRygIEQU8JySYy9XoM+VDHg9
         vNyTe2jkdYDJmmw3K+myoSBOKQaggdJWuCi3SJlpPNp/aM1tLzqFCw0R0JkhktrDAzE4
         UVkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753398224; x=1754003024;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ISsvFCUycsXMABHVDYSoSHE4WtWUnZpEr5ejibgkla0=;
        b=Df3LZSS9fnjhC3pv7UcXODTOIEvTg0NRqkj5uTjcSiVwNsaQ0B6OrTLH0rkMYtncv/
         w5/XRDwnYINrgsLPdq8Z4yUfPMVvJURhTaVZBwt9OqqPOx33hX5DzTlNQCc7HO5BLPC6
         LcnfVyX80UnAr/6cdcbIj0UkJ6hyX3u+XAzjGkxLMCTeC/HDzzBA49JODok+olQxBH1V
         3IiGJB/Hnf/qtShHRbz35JBe7A9KOl6m0zB7RdCfQ+TCKlhN/USc26/xC/mst/Qd2QSs
         v8zy4EaRfJe8CMNS/zNplvmknDdywrVsQEwI5RngCvgth0/eOQHKw5pHz/TbBV4z/3zY
         Q9UA==
X-Forwarded-Encrypted: i=1; AJvYcCVnhJsEmWXoGOXxHMBcaWoJ2AmzFcGmf6xbWvx1bEXrGtyU/e/l3CJm5BWtzEZk9SE//lSOwGo=@lists.linux.dev
X-Gm-Message-State: AOJu0YwarmGclhuOkX5FnT4a1FoYjxOSwm87fnX3pmAY73BQEGpNQCcf
	Z/6345e0j7+vRMNgl3ThCTlM9IvtvC/OS+mPDbdVumY/PqL4RzSE7XD8WI3BXMkYQyJLCJ2p/y4
	2bBt/hwACuFPvLZJmpMWDk0zjbg==
X-Google-Smtp-Source: AGHT+IHz2z61bSSBHE5WkJFRSn/f5Uz7Cdl50VxK06WJGcmxGFRErbOEdHF7gB/snCT71JrhZi9xeqGE6W9rTkxcyA==
X-Received: from pgam17.prod.google.com ([2002:a05:6a02:2b51:b0:b2f:5023:640d])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:998f:b0:239:eed:43a6 with SMTP id adf61e73a8af0-23d491220ecmr15740822637.22.1753398223391;
 Thu, 24 Jul 2025 16:03:43 -0700 (PDT)
Date: Thu, 24 Jul 2025 16:03:41 -0700
In-Reply-To: <20250723104714.1674617-14-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com> <20250723104714.1674617-14-tabba@google.com>
Message-ID: <diqzldoddwdu.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [PATCH v16 13/22] KVM: x86/mmu: Hoist guest_memfd max level/order
 helpers "up" in mmu.c
From: Ackerley Tng <ackerleytng@google.com>
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-mm@kvack.org, kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, mail@maciej.szmigiero.name, david@redhat.com, 
	michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com, 
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com, 
	suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, 
	quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com, 
	oliver.upton@linux.dev, maz@kernel.org, will@kernel.org, qperret@google.com, 
	keirf@google.com, roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, 
	jgg@nvidia.com, rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, 
	hughd@google.com, jthoughton@google.com, peterx@redhat.com, 
	pankaj.gupta@amd.com, ira.weiny@intel.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Fuad Tabba <tabba@google.com> writes:

> From: Sean Christopherson <seanjc@google.com>
>
> Move kvm_max_level_for_order() and kvm_max_private_mapping_level() up in
> mmu.c so that they can be used by __kvm_mmu_max_mapping_level().
>
> Opportunistically drop the "inline" from kvm_max_level_for_order().
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 72 +++++++++++++++++++++---------------------
>  1 file changed, 36 insertions(+), 36 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index b735611e8fcd..20dd9f64156e 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3285,6 +3285,42 @@ static int host_pfn_mapping_level(struct kvm *kvm, gfn_t gfn,
>  	return level;
>  }
>  
> +static u8 kvm_max_level_for_order(int order)
> +{
> +	BUILD_BUG_ON(KVM_MAX_HUGEPAGE_LEVEL > PG_LEVEL_1G);
> +
> +	KVM_MMU_WARN_ON(order != KVM_HPAGE_GFN_SHIFT(PG_LEVEL_1G) &&
> +			order != KVM_HPAGE_GFN_SHIFT(PG_LEVEL_2M) &&
> +			order != KVM_HPAGE_GFN_SHIFT(PG_LEVEL_4K));
> +
> +	if (order >= KVM_HPAGE_GFN_SHIFT(PG_LEVEL_1G))
> +		return PG_LEVEL_1G;
> +
> +	if (order >= KVM_HPAGE_GFN_SHIFT(PG_LEVEL_2M))
> +		return PG_LEVEL_2M;
> +
> +	return PG_LEVEL_4K;
> +}
> +
> +static u8 kvm_max_private_mapping_level(struct kvm *kvm, kvm_pfn_t pfn,
> +					u8 max_level, int gmem_order)
> +{
> +	u8 req_max_level;
> +
> +	if (max_level == PG_LEVEL_4K)
> +		return PG_LEVEL_4K;
> +
> +	max_level = min(kvm_max_level_for_order(gmem_order), max_level);
> +	if (max_level == PG_LEVEL_4K)
> +		return PG_LEVEL_4K;
> +
> +	req_max_level = kvm_x86_call(gmem_max_mapping_level)(kvm, pfn);
> +	if (req_max_level)
> +		max_level = min(max_level, req_max_level);
> +
> +	return max_level;
> +}
> +
>  static int __kvm_mmu_max_mapping_level(struct kvm *kvm,
>  				       const struct kvm_memory_slot *slot,
>  				       gfn_t gfn, int max_level, bool is_private)
> @@ -4503,42 +4539,6 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
>  		vcpu->stat.pf_fixed++;
>  }
>  
> -static inline u8 kvm_max_level_for_order(int order)
> -{
> -	BUILD_BUG_ON(KVM_MAX_HUGEPAGE_LEVEL > PG_LEVEL_1G);
> -
> -	KVM_MMU_WARN_ON(order != KVM_HPAGE_GFN_SHIFT(PG_LEVEL_1G) &&
> -			order != KVM_HPAGE_GFN_SHIFT(PG_LEVEL_2M) &&
> -			order != KVM_HPAGE_GFN_SHIFT(PG_LEVEL_4K));
> -
> -	if (order >= KVM_HPAGE_GFN_SHIFT(PG_LEVEL_1G))
> -		return PG_LEVEL_1G;
> -
> -	if (order >= KVM_HPAGE_GFN_SHIFT(PG_LEVEL_2M))
> -		return PG_LEVEL_2M;
> -
> -	return PG_LEVEL_4K;
> -}
> -
> -static u8 kvm_max_private_mapping_level(struct kvm *kvm, kvm_pfn_t pfn,
> -					u8 max_level, int gmem_order)
> -{
> -	u8 req_max_level;
> -
> -	if (max_level == PG_LEVEL_4K)
> -		return PG_LEVEL_4K;
> -
> -	max_level = min(kvm_max_level_for_order(gmem_order), max_level);
> -	if (max_level == PG_LEVEL_4K)
> -		return PG_LEVEL_4K;
> -
> -	req_max_level = kvm_x86_call(gmem_max_mapping_level)(kvm, pfn);
> -	if (req_max_level)
> -		max_level = min(max_level, req_max_level);
> -
> -	return max_level;
> -}
> -
>  static void kvm_mmu_finish_page_fault(struct kvm_vcpu *vcpu,
>  				      struct kvm_page_fault *fault, int r)
>  {
> -- 
> 2.50.1.470.g6ba607880d-goog

Reviewed-by: 
