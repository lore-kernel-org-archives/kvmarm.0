Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD901F8EF6
	for <kvmarm@lists.linux.dev>; Thu, 13 Mar 2025 06:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741846204; cv=none; b=HLd3eoFho3rQ1QF7zIc6zZZNy1xi1h9nFf+7XUW72IbftQ4NlJv01+pojcAEU/c/I0k4IWF1I26E+UGvPgK5fEnbaGaxNo+w3vZL9tXErTX688W63MH/81XPwuiwSSaDpfpIfocpVs30tw+MNSR58Jgmvo9hd/9Z4/NbO299U0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741846204; c=relaxed/simple;
	bh=epheoX7sjBBeNLQYhjvA1n4fUP7DKzJ46vLVpbCOOe0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m+g9JHKd2omTRAj/XCNJzLPVfdvkNu5bDKALpMHuWWyNFPfdiSNz7ZLrG6rkLQeqVu4PVDTNSrrvz9mlgB0ibBYNRCd6+3afB2EIeq0MnRGrc/hb2Skp6XE7gab9Uo49ExpWdalHlb/xrDB4V2HKPqsCaXCSLvrMERwx91Hq4L4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IBSZJpGp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IBSZJpGp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741846200;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ccm3JgzdOSGH62qHobc9OF3iYrGg3m8/wnqVF4zJglU=;
	b=IBSZJpGpfTqdJMfEg7u/Mx0mMVwh0zmkReNE8CrZFXg8P+K5RacuSvqjBRep6UYtZ5Br17
	EOkJ9n3IWJPvH+b7pHr5VimYNSYCxEbQfkt5q7wf3xqRuV9qGyNx9geQD3HkJ6XwBgNV3f
	ucDSpDYABUqt7uiYwV6KBqVI5E17d3Q=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-691-AVhijEeaOFyrjrDP9JEUOA-1; Thu, 13 Mar 2025 02:09:59 -0400
X-MC-Unique: AVhijEeaOFyrjrDP9JEUOA-1
X-Mimecast-MFC-AGG-ID: AVhijEeaOFyrjrDP9JEUOA_1741846198
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-225ab228a37so9424495ad.2
        for <kvmarm@lists.linux.dev>; Wed, 12 Mar 2025 23:09:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741846198; x=1742450998;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ccm3JgzdOSGH62qHobc9OF3iYrGg3m8/wnqVF4zJglU=;
        b=v2OCQEx2ZubimAcaJ6wcX02cA1UKUHsMAo8We53f8iY6n2Tb0AS2tIM3NLUrUkvB7e
         EiSyAHmTaXi7p/KtWvVE/kw337Ipwax1mNga83co3CLKnVImog4TCIhBOJHkY4XSZgGD
         6jBru2NrnQEimqyN9shqY9sB/W3b/B2IKZy3xV5nIiEnzhYHyPTS61FBCgVpb8iwz6bV
         VutAoKXL8EPaOo8SHqPvc3DedzzhqKtFGKVbKoSE1lBGZvLUEL54QVVsojIVPqYkm86s
         NhVLrKCYTeVCODTvCiCvy/B+XilCKtBO/ZJeoL3JWatPx4L4TdjCAxcA5T04l9hYeXQQ
         gTBA==
X-Forwarded-Encrypted: i=1; AJvYcCWhxhF6r69t2QCj+viiDClXtaJPEXvBD3bqvaInKMsWK+SjgAMu0JkGNtJ51lX14NfjVV2Y0Eo=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyg5x0cjgBlo6ppiVbh3HTr8uwhpmkk++jWbVBtXrjz7rJ/6p8i
	BTCWAXvfbF+YWw5wykxzyILepvyjwHJiheVAf1xc2rYMP+EtwJj+7oCrjyJ38y3YFfOCgYI8VrD
	pttiaEoUfOkfpzD+5iPZu82tHHDiDjkZMhfTn3/Xk2g+8Mys8UywXXw==
X-Gm-Gg: ASbGnctylgnFXPw7WAA5AU5CRzsKK4ZcHS0T4ZoG8i7zETXNlBK9HNMt5nUXRVAbA0X
	m/JLlRI+DgOn9+GuwLKKpAr/7eHtWa/BcRog17fH2NGH2UaSiC4Mh+ln+z/cVp5jILPlvQJ/WUK
	1srC9Wz2YL1hSzsQe6dQ7M/zKf7gQYZxiwIo1iapFC4+dDssIsJzVrSVSpGlNSm+K3FIXj5ZGOA
	nXk1M5MpTVA4BKS9Djt1HlOoiHHh2FjmP81XUC+l0eH+S2abFQ+FbTzZJK180F3O4MYf+gBCq7f
	byWfADNKQyyawvTAwg==
X-Received: by 2002:a17:902:d488:b0:223:3ef1:a30a with SMTP id d9443c01a7336-225931ad489mr119271345ad.45.1741846198238;
        Wed, 12 Mar 2025 23:09:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFS/0CiPnvYXrr/SnOgpCHMu4/dKvSfoPKfZt54v9+3wLfVsHrnCrsLrPLUwz74zt1y5GmQxA==
X-Received: by 2002:a17:902:d488:b0:223:3ef1:a30a with SMTP id d9443c01a7336-225931ad489mr119271035ad.45.1741846197900;
        Wed, 12 Mar 2025 23:09:57 -0700 (PDT)
Received: from [192.168.68.55] ([180.233.125.167])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-225c68a403fsm5710305ad.61.2025.03.12.23.09.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Mar 2025 23:09:57 -0700 (PDT)
Message-ID: <88c66ec3-5b03-4488-9733-ae917cbc0536@redhat.com>
Date: Thu, 13 Mar 2025 16:09:51 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: arm64: Drop sort_memblock_regions()
To: Anshuman Khandual <anshuman.khandual@arm.com>, kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 qperret@google.com, maz@kernel.org, oliver.upton@linux.dev,
 joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 catalin.marinas@arm.com, will@kernel.org, shan.gavin@gmail.com
References: <20250311043718.91004-1-gshan@redhat.com>
 <34b8242b-529b-4ad5-ac17-e1200965ae1d@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <34b8242b-529b-4ad5-ac17-e1200965ae1d@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: KUAKwus_sZIRF1EEA0GbLaT1Vgkc5rY6XGRlwYNNIm4_1741846198
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/13/25 12:53 PM, Anshuman Khandual wrote:
> On 3/11/25 10:07, Gavin Shan wrote:
>> Drop sort_memblock_regions() and avoid sorting the copied memory
>> regions to be ascending order on their base addresses, because the
>> source memory regions should have been sorted correctly when they
>> are added by memblock_add() or its variants.
>>
>> This is generally reverting commit a14307f5310c ("KVM: arm64: Sort
>> the hypervisor memblocks"). No functional changes intended.
> 
> Just wondering what prompted this change ?
> 

I found the unnecessary sorting by code inspection. Hope there is nothing I
missed and it's why Quentin Perret has been copied, to confirm it. Commit
a14307f5310c was introduced by the initial series [1/2] to support pKVM.

[1] https://lore.kernel.org/kvmarm/20201117181607.1761516-1-qperret@google.com/
[2] https://lore.kernel.org/all/20210319100146.1149909-1-qperret@google.com/

Thanks,
Gavin

>>
>> Signed-off-by: Gavin Shan <gshan@redhat.com>
>> ---
>>   arch/arm64/kvm/pkvm.c | 19 -------------------
>>   1 file changed, 19 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
>> index 930b677eb9b0..d9c9174f89a1 100644
>> --- a/arch/arm64/kvm/pkvm.c
>> +++ b/arch/arm64/kvm/pkvm.c
>> @@ -10,7 +10,6 @@
>>   #include <asm/kvm_mmu.h>
>>   #include <linux/memblock.h>
>>   #include <linux/mutex.h>
>> -#include <linux/sort.h>
>>   
>>   #include <asm/kvm_pkvm.h>
>>   
>> @@ -24,23 +23,6 @@ static unsigned int *hyp_memblock_nr_ptr = &kvm_nvhe_sym(hyp_memblock_nr);
>>   phys_addr_t hyp_mem_base;
>>   phys_addr_t hyp_mem_size;
>>   
>> -static int cmp_hyp_memblock(const void *p1, const void *p2)
>> -{
>> -	const struct memblock_region *r1 = p1;
>> -	const struct memblock_region *r2 = p2;
>> -
>> -	return r1->base < r2->base ? -1 : (r1->base > r2->base);
>> -}
>> -
>> -static void __init sort_memblock_regions(void)
>> -{
>> -	sort(hyp_memory,
>> -	     *hyp_memblock_nr_ptr,
>> -	     sizeof(struct memblock_region),
>> -	     cmp_hyp_memblock,
>> -	     NULL);
>> -}
>> -
>>   static int __init register_memblock_regions(void)
>>   {
>>   	struct memblock_region *reg;
>> @@ -52,7 +34,6 @@ static int __init register_memblock_regions(void)
>>   		hyp_memory[*hyp_memblock_nr_ptr] = *reg;
>>   		(*hyp_memblock_nr_ptr)++;
>>   	}
>> -	sort_memblock_regions();
>>   
>>   	return 0;
>>   }
> 

