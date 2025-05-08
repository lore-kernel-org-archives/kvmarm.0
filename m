Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B78C23E25B
	for <kvmarm@lists.linux.dev>; Thu,  8 May 2025 09:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746694809; cv=none; b=dmHs2WyOhVyoZxtgNyYmhKJNegjZUMAsGa3KRpGys6pjD0HRHNMm7twSSDfaOco2FA2hEf5ihexlKOznfzhKRTA2e6O6+fB38Nnd5LxGVWyOvhkQYPzLnzJKznZzXOjdZzQCt20IsRwc3ycgqpnvFG3SIeThHfVGGdEu359KGg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746694809; c=relaxed/simple;
	bh=ndQF1JUtQPfbpS9NlJ5rMEcSRWoZDITUT4WBSrSdAsA=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=UmfHE8zvtexZ549mV/U3HEzLxt41V33nDqLc/Re/m7Vm6sGCe2H1qfbav7Ul6AWrMeECYy+1OmnSHYugT+z0B0CJiKoF0OYCQGc5HPXyaf6IMTdkZh/7VGDfm7lTwQWmUVpbdeMRxM10EbSPQ8ESywnLqkrPJHmSXMr9TMWBU5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cKajrVnb; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cKajrVnb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746694804;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qOQcTqANU1leNfWALhEgYRCRqcO0Qjjft1AKNAg4mjA=;
	b=cKajrVnbEiG80rsvUKLLdUFWsT3PnGNSmuxBmjBqO1YMTGxD6HGGkUnLWepfZCt8p/J512
	xY0NBwY55Y9cyFauH8VHl4dR0HvCtv87CoBYiTS0dxiMr0imEYSQfo+7u7cCKRnQwO5Rgl
	dlBzyvpXx/rVqG7weq9KFukQFRQgVa8=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-147-MJMyJS-UMzuhOZBhFYWnsQ-1; Thu, 08 May 2025 05:00:02 -0400
X-MC-Unique: MJMyJS-UMzuhOZBhFYWnsQ-1
X-Mimecast-MFC-AGG-ID: MJMyJS-UMzuhOZBhFYWnsQ_1746694799
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-739525d4d7bso739415b3a.2
        for <kvmarm@lists.linux.dev>; Thu, 08 May 2025 02:00:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746694798; x=1747299598;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qOQcTqANU1leNfWALhEgYRCRqcO0Qjjft1AKNAg4mjA=;
        b=SR6llxKXbh2K0fDaqpREpaq87LwBmrhJMtV69a/VAl6u/FudCLv3nWhUuRS3y5L/iF
         kzasqfqX8YqC6H3a0kQfbIuKspGaKvNYiJG6TjiND64fRVbDgg1wjn0MEQ7YCfCCOTvD
         OfmqvEwONdm7+EPV42/GsylZK8+I/S1zv634li5/6SRVMQC7LVs03mBW6FTaQy/KsXOM
         sV8gABXejnu/zRye2K3NH6dtoGsdbxd3Okt3sPPmd2+ESuvyw5pdeKhFIkaXpG2Vrh5t
         zWalKgBrb03iXlahgekguJ12jDwrSUbOYf454Qs5ZfW7likcaSLPkBYe9gPIldSO7Ki0
         fAYw==
X-Gm-Message-State: AOJu0YwsSPUH3Zrtl7gSt6rmHbLxwpaJnVukyvtqGKZ+5nqTTxfSo9jL
	0Dy3kVVbjk2vCdgLtLvghUzhaYyG+BxGYmBc2gPbxDgo52MYYsDxahZvOAC9+DoBL2bF/7rKWzI
	QmUZQwL/yaYKPLserGHjAntlU8pj8Hx47wqLzlYtDg19EjcKKRSllooS/GYWP1e5tRg0WYts4vJ
	H9rlqz2Vtydz+AmwLdlXQvLnU6kJ6OFq5wwg==
X-Gm-Gg: ASbGncuUc2BpcHSqgB9XKu8aNbgmuKlvizjaAXaClNMmBflGC5/Ren+gyeETlV+2+Bp
	io7ZIblcnTvFcYckAWmpknTq1gY9oVlWH3cergC8iyTGC+JIrILGwOWbYpLIMw0+cc9IASCwN2s
	FxPPoTvi1ADKXJ44N869ROEzn8NWRFnx05qUzayGF4QETVIQgY0Q5+wxVsbGdJLkpvvkKXPQYFK
	Yf9S3rv5gBTaJWD+GcDujV9ejR+YZLzhFuwr09pB9RZXdwhzhPCFPC8bp68H385HFubLszQJ6FW
	s3+xEKUXDTJG
X-Received: by 2002:a05:6a21:3a83:b0:1f5:8d3b:e294 with SMTP id adf61e73a8af0-2148b526dd7mr10023549637.16.1746694798109;
        Thu, 08 May 2025 01:59:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF1EwAUJsR9DPVq6ks/wjHy3vUPtJEluOMLF3EubNvy3Xr+lYJJSx5JADt/lM5REM16u/RwNw==
X-Received: by 2002:a05:6a21:3a83:b0:1f5:8d3b:e294 with SMTP id adf61e73a8af0-2148b526dd7mr10023516637.16.1746694797754;
        Thu, 08 May 2025 01:59:57 -0700 (PDT)
Received: from [192.168.68.51] ([180.233.125.65])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7405906372fsm13173105b3a.148.2025.05.08.01.59.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 May 2025 01:59:57 -0700 (PDT)
Message-ID: <8a05e7da-3640-4e79-b215-c705b879472f@redhat.com>
Date: Thu, 8 May 2025 18:59:50 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: arm64: Drop sort_memblock_regions()
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 qperret@google.com, maz@kernel.org, oliver.upton@linux.dev,
 joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 catalin.marinas@arm.com, will@kernel.org, shan.gavin@gmail.com
References: <20250311043718.91004-1-gshan@redhat.com>
In-Reply-To: <20250311043718.91004-1-gshan@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: txJNygwx65fH2YHU_epjR7SFmDgSBOgwa9zdfGr69H8_1746694799
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Marc/Oliver,

On 3/11/25 2:37 PM, Gavin Shan wrote:
> Drop sort_memblock_regions() and avoid sorting the copied memory
> regions to be ascending order on their base addresses, because the
> source memory regions should have been sorted correctly when they
> are added by memblock_add() or its variants.
> 
> This is generally reverting commit a14307f5310c ("KVM: arm64: Sort
> the hypervisor memblocks"). No functional changes intended.
> 
> Signed-off-by: Gavin Shan <gshan@redhat.com>
> ---
>   arch/arm64/kvm/pkvm.c | 19 -------------------
>   1 file changed, 19 deletions(-)
> 

Please let me know if I need to resend after a rebase, or anything I need to
do so that it can be merged? :-)

Thanks,
Gavin

> diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> index 930b677eb9b0..d9c9174f89a1 100644
> --- a/arch/arm64/kvm/pkvm.c
> +++ b/arch/arm64/kvm/pkvm.c
> @@ -10,7 +10,6 @@
>   #include <asm/kvm_mmu.h>
>   #include <linux/memblock.h>
>   #include <linux/mutex.h>
> -#include <linux/sort.h>
>   
>   #include <asm/kvm_pkvm.h>
>   
> @@ -24,23 +23,6 @@ static unsigned int *hyp_memblock_nr_ptr = &kvm_nvhe_sym(hyp_memblock_nr);
>   phys_addr_t hyp_mem_base;
>   phys_addr_t hyp_mem_size;
>   
> -static int cmp_hyp_memblock(const void *p1, const void *p2)
> -{
> -	const struct memblock_region *r1 = p1;
> -	const struct memblock_region *r2 = p2;
> -
> -	return r1->base < r2->base ? -1 : (r1->base > r2->base);
> -}
> -
> -static void __init sort_memblock_regions(void)
> -{
> -	sort(hyp_memory,
> -	     *hyp_memblock_nr_ptr,
> -	     sizeof(struct memblock_region),
> -	     cmp_hyp_memblock,
> -	     NULL);
> -}
> -
>   static int __init register_memblock_regions(void)
>   {
>   	struct memblock_region *reg;
> @@ -52,7 +34,6 @@ static int __init register_memblock_regions(void)
>   		hyp_memory[*hyp_memblock_nr_ptr] = *reg;
>   		(*hyp_memblock_nr_ptr)++;
>   	}
> -	sort_memblock_regions();
>   
>   	return 0;
>   }

