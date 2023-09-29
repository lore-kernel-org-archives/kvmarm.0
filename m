Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09FCF10E3
	for <kvmarm@lists.linux.dev>; Fri, 29 Sep 2023 06:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695970768;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H9Sl989fc3XGeJWvJ049qDJStIAThFKCuJNqoLbCeZY=;
	b=i4jfHhzzwCCzWSWZCUq2urKtZvJdH+Uf0u4m6Zau/kS1gKyx2NRMSetez0S7iP1fzTZsal
	SIlXI7kxlFRKTgf/LT1ax5Ku4mPVF2i14M9gEntJNzPv/vqqhrLUWkHDZHt1B88W9HX85k
	mVa8Qw+Sg932JI8Qsvz94+tNl8zLYIo=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-583-mPT9-VhxOq2uRJki_UrmbQ-1; Fri, 29 Sep 2023 02:59:27 -0400
X-MC-Unique: mPT9-VhxOq2uRJki_UrmbQ-1
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-577c25cda99so10878707a12.3
        for <kvmarm@lists.linux.dev>; Thu, 28 Sep 2023 23:59:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695970765; x=1696575565;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H9Sl989fc3XGeJWvJ049qDJStIAThFKCuJNqoLbCeZY=;
        b=FSMPzF4gx675RZbp3SVZmU39eEBBpL7rvTdWWjdJ8xDzhvEJnu/mBcyRvLY9ksDoty
         rgJF/d2Qm3ZyN8HsfZKJ+vqc6EcncZ91mIIWfaJVte3K8TNu3vw3EicTetwcPKIp4zyu
         +TSA8oBVwoE+P6Y6HYQ4sTW9re4z8doSpX0d6OnlUl+0lMh7iv0b/Z0elmlbrqkRCvgh
         xNfBWRG1No16upVyKENn3hW1hc0jjqr2oGwvs/3Owx+MfMN0eHdI0rbK1DCzZe4Pa52C
         NpFdrpkhgdAI9Bg4/ggE1D5SYqH0lyfT0iPxmw+rv9qb4/jTH8/snOfahezyAxW9kX6G
         +s1A==
X-Gm-Message-State: AOJu0YyD0rOyBBk/JjWcdogyGCK8GOCuf+QqfFlr6UwwupaHqaza1hrC
	ZkLqBAzy8cMLlX3zr3zbQIX7x1QIhDAyE/YLU2UheLI3s76vQMDZwCnz9J5K61JZ/v1GWkt/qty
	m0ZmlgqCdKGbrZgItVrF+BOkV
X-Received: by 2002:a05:6a20:6da2:b0:161:2389:e34d with SMTP id gl34-20020a056a206da200b001612389e34dmr2643341pzb.34.1695970765676;
        Thu, 28 Sep 2023 23:59:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFLxouqr6ye94a8yUAYYvYdy0IyKmaojkbCIaqzuP8Dl++sswUKRIeO/hUYK+t6zbtLVec+Sg==
X-Received: by 2002:a05:6a20:6da2:b0:161:2389:e34d with SMTP id gl34-20020a056a206da200b001612389e34dmr2643330pzb.34.1695970765383;
        Thu, 28 Sep 2023 23:59:25 -0700 (PDT)
Received: from ?IPV6:2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5? ([2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5])
        by smtp.gmail.com with ESMTPSA id l20-20020a17090ac59400b0026cecddfc58sm691508pjt.42.2023.09.28.23.59.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Sep 2023 23:59:24 -0700 (PDT)
Message-ID: <3a05f8a1-5759-8744-49eb-e975c5cf129c@redhat.com>
Date: Fri, 29 Sep 2023 16:59:20 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v2 1/2] KVM: arm64: Do not transfer page refcount for THP
 adjustment
To: Vincent Donnefort <vdonnefort@google.com>, maz@kernel.org,
 oliver.upton@linux.dev
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 kernel-team@android.com, will@kernel.org, willy@infradead.org
References: <20230928173205.2826598-1-vdonnefort@google.com>
 <20230928173205.2826598-2-vdonnefort@google.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20230928173205.2826598-2-vdonnefort@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/29/23 03:32, Vincent Donnefort wrote:
> GUP affects a refcount common to all pages forming the THP. There is
> therefore no need to move the refcount from a tail to the head page.
> Under the hood it decrements and increments the same counter.
> 
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 587a104f66c3..de5e5148ef5d 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1295,28 +1295,8 @@ transparent_hugepage_adjust(struct kvm *kvm, struct kvm_memory_slot *memslot,
>   		if (sz < PMD_SIZE)
>   			return PAGE_SIZE;
>   
> -		/*
> -		 * The address we faulted on is backed by a transparent huge
> -		 * page.  However, because we map the compound huge page and
> -		 * not the individual tail page, we need to transfer the
> -		 * refcount to the head page.  We have to be careful that the
> -		 * THP doesn't start to split while we are adjusting the
> -		 * refcounts.
> -		 *
> -		 * We are sure this doesn't happen, because mmu_invalidate_retry
> -		 * was successful and we are holding the mmu_lock, so if this
> -		 * THP is trying to split, it will be blocked in the mmu
> -		 * notifier before touching any of the pages, specifically
> -		 * before being able to call __split_huge_page_refcount().
> -		 *
> -		 * We can therefore safely transfer the refcount from PG_tail
> -		 * to PG_head and switch the pfn from a tail page to the head
> -		 * page accordingly.
> -		 */
>   		*ipap &= PMD_MASK;
> -		kvm_release_pfn_clean(pfn);
>   		pfn &= ~(PTRS_PER_PMD - 1);
> -		get_page(pfn_to_page(pfn));
>   		*pfnp = pfn;
>   
>   		return PMD_SIZE;

The local variable @pfn can be dropped either.

                 *pfnp &= ~(PTRS_PER_PMD - 1);

Thanks,
Gavin

