Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB7A2286419
	for <kvmarm@lists.linux.dev>; Fri,  6 Jun 2025 09:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749201287; cv=none; b=u8nJL8toTVfvCnZi9laBKT91P2QRDng6l3u2jOrZe/7gxvmfFV/qdpHboBxM1aMqhXbWzveuEgQM+/Rnu4NlfydjBRyZ6q2n9JXvPOQatHxPtUsR9h+5teIHr2oPMTXXswhKJl5hDsrJYVyaCTycuRA0wL+YuoouwxOPkoOJKnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749201287; c=relaxed/simple;
	bh=B1sHZVub/dqRM9/63GetGGqfhY8L0l8Ko9CARf4d3QQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HAa7c/rO9pMg24pzKG6pabQ36ZADcIDaXgC9OtpCPbAxQqumM58NXmoec8b/jfVmuMfCESP2FtRbBmgs/wYc1QcWW72t8zZvNSXgs0YBkAZCn5adDce7K37srybImGJBAZJmTRJczlHyAfznnFUo8HhZsUm49UMr30GQus+YSiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZC3ILgMc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZC3ILgMc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749201284;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=oCj6+Sxcxs0auBfeuChSwk33Y3pn/sByOGMCDkMC3UA=;
	b=ZC3ILgMcGmv1AAnKhsXEdJwARFnLNsAWvVr2PTEbH3gSDLDQH5+qBhHm6G8Wgc4lgB9Kzy
	WpP4V5a3Z2Sgne5RcvpLTiaKrMcPZvTQMe2tOkGd9o+ZROlTMIjSMQXG3FJqQdIduLBwlm
	PY2VVUhz1CVezESrHw8anXGIkVG5DSs=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-425-oWDhlWURNlG0XsQwBVrUTg-1; Fri, 06 Jun 2025 05:14:41 -0400
X-MC-Unique: oWDhlWURNlG0XsQwBVrUTg-1
X-Mimecast-MFC-AGG-ID: oWDhlWURNlG0XsQwBVrUTg_1749201280
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-43e9b0fd00cso10228095e9.0
        for <kvmarm@lists.linux.dev>; Fri, 06 Jun 2025 02:14:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749201280; x=1749806080;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=oCj6+Sxcxs0auBfeuChSwk33Y3pn/sByOGMCDkMC3UA=;
        b=aNfWmZnJtVthHGtoIpcGYn0zNk+ft8TCpVxBbwZqyMdkUZkgdxwu4D+XQp4dkoVVsO
         aBo80vETN/tYwSWG50mseOUgfxKwvnFCRxMgD6uGdNOCMWmE/eP/ay/46H1jVdiXKPtP
         L2l/RlE62nvssy3f3zp1jNnwuzHtnbjKwAiF+kTEnVikUF2H3wSKyYJXFl3OsuEU7YUL
         +GAvQtsa2glexLif0U4we/WMJocrTCsDO05YcUNMLMj+p3Fkp5ax3b9lC65UZNfYz6/0
         4WoNXCwoR39/c75PzEaOBEVW3EJePasPnlqYyXFos8HrSeD7jVQCKmsKo8LNQsACIo85
         ZJPA==
X-Forwarded-Encrypted: i=1; AJvYcCXi62K47nmahWvN8SjEIaJBz+pieiHVsQ1Sfgp9CyYEPM/3xyaKaUA+jzCldaqYQCIJm7O69M0=@lists.linux.dev
X-Gm-Message-State: AOJu0YzNRzTqdv1lGBI4iF4ZDVJcDb4SZ2ETkgn+6QKpmKlCYkgZE1st
	pYg39XREKvcZn7pxJUnfMCIudVhxplTaDRVI2zu9g2TKcaQYehNelhsJKPPsFoBvzdKMRtcdvXW
	UIwGI7eK1lKW3K5WW3od6dUDBcQrsXJUQWnkj8Ye3YtemelCrCgRiiDqCkg==
X-Gm-Gg: ASbGncvE/8x605ZWYlk17Hv37i1N5/WmSavemgT7XfDjvgN1B2a2lFEpAkYK5Tuve7v
	+rJGDDZc5JBRRAs/Pq9wBbqgrbWk00BpDGu5q1U7js1mSEjdrSPgdqL+Utc4YdlBNNaeUUESUEl
	lcJLd9D13yBzVxor4ifD9bg7nylaO+xXpqdzwfIILeLhiAGC3LELLkLRP55OT8Hg3HnIZm0JdVA
	mwMflw7vexKCFN9BbLIFKyKafJbdPzxg32m4IOEYscnYROLqq3FdzECF9ZOj+38iaPDaKSdV6X+
	Yi0BZcO9P382yujZsal5kAR7gQiagAQmrBZRkKS4KID8NH8IQk3+32/TAjFeHIsAsbqr/fgzJfV
	tQGnhSq3tUEVOs6E9KSs+7XWCA4Y8Ns8=
X-Received: by 2002:a05:600c:3510:b0:43c:f509:2bbf with SMTP id 5b1f17b1804b1-451f88d836amr75147675e9.15.1749201280325;
        Fri, 06 Jun 2025 02:14:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFkpLXinHXWxiSI+4PvEC2BPCocHHNYP7TvdS/sSVKr19ttFoE6Pj4byntHDslgrPmFOZSX+A==
X-Received: by 2002:a05:600c:3510:b0:43c:f509:2bbf with SMTP id 5b1f17b1804b1-451f88d836amr75147145e9.15.1749201279824;
        Fri, 06 Jun 2025 02:14:39 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f19:9c00:568:7df7:e1:293d? (p200300d82f199c0005687df700e1293d.dip0.t-ipconnect.de. [2003:d8:2f19:9c00:568:7df7:e1:293d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45209ce1afasm17541465e9.10.2025.06.06.02.14.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Jun 2025 02:14:39 -0700 (PDT)
Message-ID: <aa9701b7-a550-46bf-bb2f-b73462671c7d@redhat.com>
Date: Fri, 6 Jun 2025 11:14:36 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 11/18] KVM: x86: Consult guest_memfd when computing
 max_mapping_level
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
 vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name,
 michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com,
 isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
 suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com,
 quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
 quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
 quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com,
 james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev,
 maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com,
 roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com,
 rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250605153800.557144-1-tabba@google.com>
 <20250605153800.557144-12-tabba@google.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250605153800.557144-12-tabba@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: jGPhTL5CUEWRzn3dtBJrlNetU1Q7As26To3cfsgJI0Y_1749201280
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 05.06.25 17:37, Fuad Tabba wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> This patch adds kvm_gmem_max_mapping_level(), which always returns
> PG_LEVEL_4K since guest_memfd only supports 4K pages for now.
> 
> When guest_memfd supports shared memory, max_mapping_level (especially
> when recovering huge pages - see call to __kvm_mmu_max_mapping_level()
> from recover_huge_pages_range()) should take input from
> guest_memfd.
> 
> Input from guest_memfd should be taken in these cases:
> 
> + if the memslot supports shared memory (guest_memfd is used for
>    shared memory, or in future both shared and private memory) or
> + if the memslot is only used for private memory and that gfn is
>    private.
> 
> If the memslot doesn't use guest_memfd, figure out the
> max_mapping_level using the host page tables like before.
> 
> This patch also refactors and inlines the other call to
> __kvm_mmu_max_mapping_level().
> 
> In kvm_mmu_hugepage_adjust(), guest_memfd's input is already
> provided (if applicable) in fault->max_level. Hence, there is no need
> to query guest_memfd.
> 
> lpage_info is queried like before, and then if the fault is not from
> guest_memfd, adjust fault->req_level based on input from host page
> tables.
> 
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Co-developed-by: Fuad Tabba <tabba@google.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---

[...]

>   static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>   {
>   	return false;
> @@ -2561,6 +2565,7 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>   int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>   		     gfn_t gfn, kvm_pfn_t *pfn, struct page **page,
>   		     int *max_order);
> +int kvm_gmem_mapping_order(const struct kvm_memory_slot *slot, gfn_t gfn);
>   #else
>   static inline int kvm_gmem_get_pfn(struct kvm *kvm,
>   				   struct kvm_memory_slot *slot, gfn_t gfn,
> @@ -2570,6 +2575,12 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm,
>   	KVM_BUG_ON(1, kvm);
>   	return -EIO;
>   }
> +static inline int kvm_gmem_mapping_order(const struct kvm_memory_slot *slot,
> +					 gfn_t gfn)
> +{
> +	BUG();
> +	return 0;

As raised, no BUG(). If this is unreachable for these configs,

BUILD_BUG() might do.

Apart from that

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb

