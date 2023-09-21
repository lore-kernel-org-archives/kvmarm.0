Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DED917EF
	for <kvmarm@lists.linux.dev>; Thu, 21 Sep 2023 03:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695266867;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s5/sthSUevT7DX5juFR893/1sq1rr4ICjUQIPG0QZ6I=;
	b=ccs8bZQj1H8HEkkuFf194ll8wwT+Fsnl3QbcxRAl981v6WUf5T+C3gyA3/pwWnMo4JA74Y
	MlMLM0Daf0e18Vu1XXzHEoVNjPGUuJqyrZGZCH1KXv4y9A3mwrJ9YgMMGn0o1yaGTnhdbB
	T95LoBf5v1M35U93DDAzFIIWNj9KC8A=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-73-njAHt2VxP5iuda4RiIiPdg-1; Wed, 20 Sep 2023 23:27:45 -0400
X-MC-Unique: njAHt2VxP5iuda4RiIiPdg-1
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-1c0d58f127fso4348485ad.2
        for <kvmarm@lists.linux.dev>; Wed, 20 Sep 2023 20:27:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695266864; x=1695871664;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s5/sthSUevT7DX5juFR893/1sq1rr4ICjUQIPG0QZ6I=;
        b=ZU2TQqmxItvPb8y3Z82UWE1kFE6NTxs3iMJtYyg0A5hHpKTYxlPjsag5YMS+B9l1E5
         h96MSDjybPesCp+RZhtHPliRP8Ibp/qn2d5QBcIwCvpKRxmTzNTxBOe9N1lMuLSq8nft
         bA62N67HJ/Ox677kK+rdeZKk/gqzfE0qKaueOMfqtGfWpM8WVuU08fg/64GomBV5OMCG
         PoTlF/VK/6hWkJfATwiY0NBl720kKNzK3KdQ890lh0trrb9eJfgvTVyLS54AdKIddyLQ
         acwn/fB5EepQp1xV5YeYKKXd1/OqRmzzupZeOQAbMaCdVsoWpaYbYNQtxYCcHCkmCgZR
         h7mg==
X-Gm-Message-State: AOJu0YzoDw2uOkPv5TR5IQ+KbRp9Melvf639k0MQWlY3XESWFulUKgqa
	DWyZSvNJTt/EIt8EoYallv9JQndY+w01xX3JyUWdDCc1qlSOl8k9I2tYMeKHPje3TG5gmA5iCwk
	uZPurBvdb6ekvWv8bPNdmmwEx
X-Received: by 2002:a17:903:24d:b0:1b8:2c6f:3248 with SMTP id j13-20020a170903024d00b001b82c6f3248mr5215810plh.39.1695266864399;
        Wed, 20 Sep 2023 20:27:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF0sRczFvE5VCVI6nFmcS9nD8GuAx11yzzuDlFnsQwzOPoY+wfQJsSqx7ebYvPWlwrg5RHDEA==
X-Received: by 2002:a17:903:24d:b0:1b8:2c6f:3248 with SMTP id j13-20020a170903024d00b001b82c6f3248mr5215800plh.39.1695266864123;
        Wed, 20 Sep 2023 20:27:44 -0700 (PDT)
Received: from ?IPV6:2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5? ([2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5])
        by smtp.gmail.com with ESMTPSA id c24-20020a170902b69800b001bb1f0605b2sm237330pls.214.2023.09.20.20.27.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Sep 2023 20:27:43 -0700 (PDT)
Message-ID: <3a592951-5dda-258d-56fc-ddb11a00fdf1@redhat.com>
Date: Thu, 21 Sep 2023 13:27:37 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH 1/2] arm64: tlbflush: Rename MAX_TLBI_OPS
To: Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 linux-arm-kernel@lists.infradead.org
References: <20230920080133.944717-1-oliver.upton@linux.dev>
 <20230920080133.944717-2-oliver.upton@linux.dev>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20230920080133.944717-2-oliver.upton@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/20/23 18:01, Oliver Upton wrote:
> Perhaps unsurprisingly, I-cache invalidations suffer from performance
> issues similar to TLB invalidations on certain systems. TLB and I-cache
> maintenance all result in DVM on the mesh, which is where the real
> bottleneck lies.
> 
> Rename the heuristic to point the finger at DVM, such that it may be
> reused for limiting I-cache invalidations.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>   arch/arm64/include/asm/tlbflush.h | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>
Tested-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
> index b149cf9f91bc..3431d37e5054 100644
> --- a/arch/arm64/include/asm/tlbflush.h
> +++ b/arch/arm64/include/asm/tlbflush.h
> @@ -333,7 +333,7 @@ static inline void arch_tlbbatch_flush(struct arch_tlbflush_unmap_batch *batch)
>    * This is meant to avoid soft lock-ups on large TLB flushing ranges and not
>    * necessarily a performance improvement.
>    */
> -#define MAX_TLBI_OPS	PTRS_PER_PTE
> +#define MAX_DVM_OPS	PTRS_PER_PTE
>   
>   /*
>    * __flush_tlb_range_op - Perform TLBI operation upon a range
> @@ -413,12 +413,12 @@ static inline void __flush_tlb_range(struct vm_area_struct *vma,
>   
>   	/*
>   	 * When not uses TLB range ops, we can handle up to
> -	 * (MAX_TLBI_OPS - 1) pages;
> +	 * (MAX_DVM_OPS - 1) pages;
>   	 * When uses TLB range ops, we can handle up to
>   	 * (MAX_TLBI_RANGE_PAGES - 1) pages.
>   	 */
>   	if ((!system_supports_tlb_range() &&
> -	     (end - start) >= (MAX_TLBI_OPS * stride)) ||
> +	     (end - start) >= (MAX_DVM_OPS * stride)) ||
>   	    pages >= MAX_TLBI_RANGE_PAGES) {
>   		flush_tlb_mm(vma->vm_mm);
>   		return;
> @@ -451,7 +451,7 @@ static inline void flush_tlb_kernel_range(unsigned long start, unsigned long end
>   {
>   	unsigned long addr;
>   
> -	if ((end - start) > (MAX_TLBI_OPS * PAGE_SIZE)) {
> +	if ((end - start) > (MAX_DVM_OPS * PAGE_SIZE)) {
>   		flush_tlb_all();
>   		return;
>   	}

