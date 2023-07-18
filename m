Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81AE715A9
	for <kvmarm@lists.linux.dev>; Tue, 18 Jul 2023 06:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689661300;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RvSmM7MQhdDXRVA2Uryq4YVNwYFzTKNqJe4q9sLr7I8=;
	b=B2dgonFpE7SM7Z+2R3VYzFpfSEUOvoKM3VvmV6GV/rImT+pba9BkKfOj32JzLqkUuXAw7P
	HdNmpj0gSSrVODGdqJ0jFaDCPW6sNf+tlWptiOb36umD3v9AeuHCqH8LMcOe4oblzEjMXa
	MkBLxqthngysHhf/Ldi8s/sZwLOJ5HM=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-319-_TYgqdGzMHyOppAukiZ5Kw-1; Tue, 18 Jul 2023 02:21:39 -0400
X-MC-Unique: _TYgqdGzMHyOppAukiZ5Kw-1
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-1baff697979so7372415ad.0
        for <kvmarm@lists.linux.dev>; Mon, 17 Jul 2023 23:21:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689661297; x=1690266097;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RvSmM7MQhdDXRVA2Uryq4YVNwYFzTKNqJe4q9sLr7I8=;
        b=TAnB5H2a6hx0RByE/b2To4dI8zMhoBoM2SNBIdnwzC9+rMMHLVcJMUP47q6o27tALE
         2T/+vJbUZUHKhNJ4DcjR/awpwx1hMunxSWYMJe4xHgy228bQOebgH6k5oknLX8iGErRX
         /+4jjH8Iqnxt47C1+77KL3CFk/IiCi0BglTSyQ+saSV0s1bmtZc+vM0je2sQFnSPofKX
         KabrMZLc4QHcf5o7FJhHLDmMu+/ZHcLK6qOYX0Yvo4ktvRQZQjgRyxw3OsW0lv8VvrUY
         ZseSpE+tuj24/kDZmYi3CmhEKWoM4gV6PgfPsWGhR4M6zMVcFnVknX5K/t/LLobjbf2H
         oa7A==
X-Gm-Message-State: ABy/qLYeS6QSRDzLOC4BChYmzW8cpqSskLTWTBLXqyluqUi/aRDukfyd
	ETY7F2O/MTKhV8h1PtqT3y1M/yNDkq7ulozhWi12uxtLuRayehPMP4t716lfJouEWN2xT3rrFuj
	kfWmglBL4B5RsZ7N8
X-Received: by 2002:a17:902:da85:b0:1b8:9fc4:2733 with SMTP id j5-20020a170902da8500b001b89fc42733mr10753847plx.3.1689661297274;
        Mon, 17 Jul 2023 23:21:37 -0700 (PDT)
X-Google-Smtp-Source: APBJJlGwK4O80e6YQEGnzMYTYf6ot+mFwRDf85YBN8hCoLDeCfJGnn+lZlhDjDiUb0dFs/RD5ECIfQ==
X-Received: by 2002:a17:902:da85:b0:1b8:9fc4:2733 with SMTP id j5-20020a170902da8500b001b89fc42733mr10753835plx.3.1689661296887;
        Mon, 17 Jul 2023 23:21:36 -0700 (PDT)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 13-20020a170902c20d00b001b392bf9192sm941082pll.145.2023.07.17.23.21.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Jul 2023 23:21:36 -0700 (PDT)
Message-ID: <8987d68b-d62a-7a9b-3aa3-cd5cc7ad551c@redhat.com>
Date: Tue, 18 Jul 2023 14:21:30 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v6 05/11] arm64: tlb: Refactor the core flush algorithm of
 __flush_tlb_range
To: Raghavendra Rao Ananta <rananta@google.com>,
 Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>, Huacai Chen
 <chenhuacai@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
 Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>,
 Jing Zhang <jingzhangos@google.com>, Colton Lewis <coltonlewis@google.com>,
 David Matlack <dmatlack@google.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linux-mips@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, Gavin Shan <gshan@redhat.com>
References: <20230715005405.3689586-1-rananta@google.com>
 <20230715005405.3689586-6-rananta@google.com>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230715005405.3689586-6-rananta@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 7/15/23 08:53, Raghavendra Rao Ananta wrote:
> Currently, the core TLB flush functionality of __flush_tlb_range()
> hardcodes vae1is (and variants) for the flush operation. In the
> upcoming patches, the KVM code reuses this core algorithm with
> ipas2e1is for range based TLB invalidations based on the IPA.
> Hence, extract the core flush functionality of __flush_tlb_range()
> into its own macro that accepts an 'op' argument to pass any
> TLBI operation, such that other callers (KVM) can benefit.
> 
> No functional changes intended.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   arch/arm64/include/asm/tlbflush.h | 109 +++++++++++++++---------------
>   1 file changed, 56 insertions(+), 53 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
> index 412a3b9a3c25..f7fafba25add 100644
> --- a/arch/arm64/include/asm/tlbflush.h
> +++ b/arch/arm64/include/asm/tlbflush.h
> @@ -278,14 +278,62 @@ static inline void flush_tlb_page(struct vm_area_struct *vma,
>    */
>   #define MAX_TLBI_OPS	PTRS_PER_PTE
>   
> +/* When the CPU does not support TLB range operations, flush the TLB
> + * entries one by one at the granularity of 'stride'. If the TLB
> + * range ops are supported, then:
> + *
> + * 1. If 'pages' is odd, flush the first page through non-range
> + *    operations;
> + *
> + * 2. For remaining pages: the minimum range granularity is decided
> + *    by 'scale', so multiple range TLBI operations may be required.
> + *    Start from scale = 0, flush the corresponding number of pages
> + *    ((num+1)*2^(5*scale+1) starting from 'addr'), then increase it
> + *    until no pages left.
> + *
> + * Note that certain ranges can be represented by either num = 31 and
> + * scale or num = 0 and scale + 1. The loop below favours the latter
> + * since num is limited to 30 by the __TLBI_RANGE_NUM() macro.
> + */
> +#define __flush_tlb_range_op(op, start, pages, stride,			\
> +				asid, tlb_level, tlbi_user)		\
> +do {									\
> +	int num = 0;							\
> +	int scale = 0;							\
> +	unsigned long addr;						\
> +									\
> +	while (pages > 0) {						\
> +		if (!system_supports_tlb_range() ||			\
> +		    pages % 2 == 1) {					\
> +			addr = __TLBI_VADDR(start, asid);		\
> +			__tlbi_level(op, addr, tlb_level);		\
> +			if (tlbi_user)					\
> +				__tlbi_user_level(op, addr, tlb_level);	\
> +			start += stride;				\
> +			pages -= stride >> PAGE_SHIFT;			\
> +			continue;					\
> +		}							\
> +									\
> +		num = __TLBI_RANGE_NUM(pages, scale);			\
> +		if (num >= 0) {						\
> +			addr = __TLBI_VADDR_RANGE(start, asid, scale,	\
> +						  num, tlb_level);	\
> +			__tlbi(r##op, addr);				\
> +			if (tlbi_user)					\
> +				__tlbi_user(r##op, addr);		\
> +			start += __TLBI_RANGE_PAGES(num, scale) << PAGE_SHIFT; \
> +			pages -= __TLBI_RANGE_PAGES(num, scale);	\
> +		}							\
> +		scale++;						\
> +	}								\
> +} while (0)
> +
>   static inline void __flush_tlb_range(struct vm_area_struct *vma,
>   				     unsigned long start, unsigned long end,
>   				     unsigned long stride, bool last_level,
>   				     int tlb_level)
>   {
> -	int num = 0;
> -	int scale = 0;
> -	unsigned long asid, addr, pages;
> +	unsigned long asid, pages;
>   
>   	start = round_down(start, stride);
>   	end = round_up(end, stride);
> @@ -307,56 +355,11 @@ static inline void __flush_tlb_range(struct vm_area_struct *vma,
>   	dsb(ishst);
>   	asid = ASID(vma->vm_mm);
>   
> -	/*
> -	 * When the CPU does not support TLB range operations, flush the TLB
> -	 * entries one by one at the granularity of 'stride'. If the TLB
> -	 * range ops are supported, then:
> -	 *
> -	 * 1. If 'pages' is odd, flush the first page through non-range
> -	 *    operations;
> -	 *
> -	 * 2. For remaining pages: the minimum range granularity is decided
> -	 *    by 'scale', so multiple range TLBI operations may be required.
> -	 *    Start from scale = 0, flush the corresponding number of pages
> -	 *    ((num+1)*2^(5*scale+1) starting from 'addr'), then increase it
> -	 *    until no pages left.
> -	 *
> -	 * Note that certain ranges can be represented by either num = 31 and
> -	 * scale or num = 0 and scale + 1. The loop below favours the latter
> -	 * since num is limited to 30 by the __TLBI_RANGE_NUM() macro.
> -	 */
> -	while (pages > 0) {
> -		if (!system_supports_tlb_range() ||
> -		    pages % 2 == 1) {
> -			addr = __TLBI_VADDR(start, asid);
> -			if (last_level) {
> -				__tlbi_level(vale1is, addr, tlb_level);
> -				__tlbi_user_level(vale1is, addr, tlb_level);
> -			} else {
> -				__tlbi_level(vae1is, addr, tlb_level);
> -				__tlbi_user_level(vae1is, addr, tlb_level);
> -			}
> -			start += stride;
> -			pages -= stride >> PAGE_SHIFT;
> -			continue;
> -		}
> -
> -		num = __TLBI_RANGE_NUM(pages, scale);
> -		if (num >= 0) {
> -			addr = __TLBI_VADDR_RANGE(start, asid, scale,
> -						  num, tlb_level);
> -			if (last_level) {
> -				__tlbi(rvale1is, addr);
> -				__tlbi_user(rvale1is, addr);
> -			} else {
> -				__tlbi(rvae1is, addr);
> -				__tlbi_user(rvae1is, addr);
> -			}
> -			start += __TLBI_RANGE_PAGES(num, scale) << PAGE_SHIFT;
> -			pages -= __TLBI_RANGE_PAGES(num, scale);
> -		}
> -		scale++;
> -	}
> +	if (last_level)
> +		__flush_tlb_range_op(vale1is, start, pages, stride, asid, tlb_level, true);
> +	else
> +		__flush_tlb_range_op(vae1is, start, pages, stride, asid, tlb_level, true);
> +
>   	dsb(ish);
>   }
>   

-- 
Shaoqin

