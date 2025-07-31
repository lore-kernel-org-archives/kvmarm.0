Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B34CB2222A3
	for <kvmarm@lists.linux.dev>; Thu, 31 Jul 2025 08:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753949220; cv=none; b=sKdME90muuxK74z29+FdjX6I/6MHP0WeK//bXbIptOF8sYu1wvZ3OcZu5uPIQisu5FE3zWslYpgmo6s+qVcKZjtahRjiaqkVPSnMz7N7gNYsNf29lgUDA4tgpe10/tGMxPVidT+1OQoyHttwc31Glpia99gAep85TUr9/S5UBL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753949220; c=relaxed/simple;
	bh=CFMDkMvUsQvR57EG+SSxOQx2PNQckr7GXyE2N/DP0Ag=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kO0fewtODEmJ7EGL7PqxAzJXw0mHDzbUt+HiOAcasZSsm8hzPPCyuaKAi8naKlEqe16O0IwaYgvmNfG+q4Bnv7/n568LUOtBV57iPmADY7jP8uU6HzwXHLv7rGmY9KyWhGFQnXopYGhJQbdDKljbt1ij6MHMp+aOl5J6N6vYsug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H5YOImEE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H5YOImEE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753949217;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=gdDuaWOe4RuxMS+wAr8ek8x+QM6/+KK3Sdkf13YTdto=;
	b=H5YOImEEDAYdDfQyGdAprsYBRQ9Okryt8p0CYFQUA8FAZnrVwsSTOq9DhsDGybQEk8t4mT
	TESiCwmCXCfIFrgbS9pQrT3AUU0LTU1Mbj8srnuSb7mVyIIcJVv7WsBRm8TCJSwlYUGytA
	0sGsYh0g8wea8R8zm5uf6XFBX4BWsJ8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-462-XvmD1enLN7amq107kmDLuA-1; Thu, 31 Jul 2025 04:06:54 -0400
X-MC-Unique: XvmD1enLN7amq107kmDLuA-1
X-Mimecast-MFC-AGG-ID: XvmD1enLN7amq107kmDLuA_1753949213
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-456013b59c1so2980865e9.3
        for <kvmarm@lists.linux.dev>; Thu, 31 Jul 2025 01:06:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753949213; x=1754554013;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gdDuaWOe4RuxMS+wAr8ek8x+QM6/+KK3Sdkf13YTdto=;
        b=IcVkZVc6DEcJG0nbT5ZU0J3VWRgr9r+Pq9mdinxV1N4jwv42pjXiWcxHno2gacHr/5
         yUWWj/Va8pizZPIlZirorQcKntoX4tJzswT/7rmjsZd/NIkeNKZayIS/IL7qgNyEdE9p
         ypPwL44u0sqEjm0xJCbeXOOEVxBo3KXrSC+qP5r4PrGvPfAhfIFrkGvdg7mKwjK/jWHu
         93PwflhvQjt9ZxLQ6RQsCu/jJYhs3vgjjAZ3WNucQSF4zWP/SujC0ZCz1wvVqdlgd810
         L0CVCGphfzw7KTwYvVZtD3fG++YFr66k4EpdZHgpzthvslIbR9RuZiHpz9JVhY96+nUQ
         rH8g==
X-Forwarded-Encrypted: i=1; AJvYcCVDQvcEOiVI2aLNd9yVOZQJKX2+Q4n9PLGMe9XE3Ln4oHgmZJi54U6fOmV/PaHSUIplh+mqCa4=@lists.linux.dev
X-Gm-Message-State: AOJu0YxqkmiaPWPzJhevOCum76bB9mSA6VHxduGvN4YkEl8TuUZuDg9W
	ahzAPXKkzHgwO0IkALOuTLjO8EnDGO+PXR0q8ntFDhVnAvar6Ra6UiYzNo2BYpxBgnaMMMSrFRq
	mDL1SRgZXYkCwGA2TRhKM+Ga5RzzafHUrOgC4kSdbFNvxrRHDYMfG2v7e8A==
X-Gm-Gg: ASbGncsZeSGrd1mhEjhTtMoAhZwjVDxufKJ1Y1m4/K3AF8W+WwEbH+vAJo/ToU9b6ea
	OBGdyrIcfTge8tFyeeezsju6al3SfzhHwMrWhAeWbHkXL1MGv/u18OWGNR+ukzkavMiL2xY10BI
	6+EGTyaWN2ZXFPcnxTEFTlSU8bEpxEIwxYctGHkFAo6HvFaVXrRfuaLkFOXEVYnb1qGgBurTSGf
	9wi5vfy5QBUEKUusWkXgBecCaPDeq3tlnyXiSH0QIK2ALLhOfzbrmOZgjQkO1VLhpbRKYjYmeKt
	0MNZhxQ7Kuk51gsBMd0HK65o5KRzJDPIsumtZ+NWLEahLGTY/RnUIaZBtW1lsNdr0uUEcMU2V/a
	AW6SCg0NZKFTbNEZrWIFKqApOWzU5YSemFaLnxbr62rlxqU34phSAq72kd3Dy3ztTjWI=
X-Received: by 2002:a05:6000:18aa:b0:3b7:8b88:e3a2 with SMTP id ffacd0b85a97d-3b795024a1amr4771331f8f.58.1753949212635;
        Thu, 31 Jul 2025 01:06:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGumOQhXTySJjcOYt9Ti77EPoGWcFbQk5wd32tWIzZh2aJz46IsGG5RZTp29fmETKoqd8N9nA==
X-Received: by 2002:a05:6000:18aa:b0:3b7:8b88:e3a2 with SMTP id ffacd0b85a97d-3b795024a1amr4771292f8f.58.1753949212180;
        Thu, 31 Jul 2025 01:06:52 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f44:3700:be07:9a67:67f7:24e6? (p200300d82f443700be079a6767f724e6.dip0.t-ipconnect.de. [2003:d8:2f44:3700:be07:9a67:67f7:24e6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c3ac158sm1578088f8f.4.2025.07.31.01.06.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Jul 2025 01:06:50 -0700 (PDT)
Message-ID: <39081490-cb20-4ec2-8384-1f1ccfdb336b@redhat.com>
Date: Thu, 31 Jul 2025 10:06:49 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 14/24] KVM: x86/mmu: Enforce guest_memfd's max order
 when recovering hugepages
To: Xiaoyao Li <xiaoyao.li@intel.com>, Sean Christopherson
 <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
 Ira Weiny <ira.weiny@intel.com>, Gavin Shan <gshan@redhat.com>,
 Shivank Garg <shivankg@amd.com>, Vlastimil Babka <vbabka@suse.cz>,
 Fuad Tabba <tabba@google.com>, Ackerley Tng <ackerleytng@google.com>,
 Tao Chan <chentao@kylinos.cn>, James Houghton <jthoughton@google.com>
References: <20250729225455.670324-1-seanjc@google.com>
 <20250729225455.670324-15-seanjc@google.com>
 <e67b0825-abcb-4bac-bc3c-2e8b513f1d57@intel.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <e67b0825-abcb-4bac-bc3c-2e8b513f1d57@intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: bMEr88UDBE-jGoAehuRlnom5hiLBO3kqLkk6U9mE3rk_1753949213
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 30.07.25 09:33, Xiaoyao Li wrote:
> On 7/30/2025 6:54 AM, Sean Christopherson wrote:
>> Rework kvm_mmu_max_mapping_level() to provide the plumbing to consult
>> guest_memfd (and relevant vendor code) when recovering hugepages, e.g.
>> after disabling live migration.  The flaw has existed since guest_memfd was
>> originally added, but has gone unnoticed due to lack of guest_memfd support
>> for hugepages or dirty logging.
>>
>> Don't actually call into guest_memfd at this time, as it's unclear as to
>> what the API should be.  Ideally, KVM would simply use kvm_gmem_get_pfn(),
>> but invoking kvm_gmem_get_pfn() would lead to sleeping in atomic context
>> if guest_memfd needed to allocate memory (mmu_lock is held).  Luckily,
>> the path isn't actually reachable, so just add a TODO and WARN to ensure
>> the functionality is added alongisde guest_memfd hugepage support, and
>> punt the guest_memfd API design question to the future.
>>
>> Note, calling kvm_mem_is_private() in the non-fault path is safe, so long
>> as mmu_lock is held, as hugepage recovery operates on shadow-present SPTEs,
>> i.e. calling kvm_mmu_max_mapping_level() with @fault=NULL is mutually
>> exclusive with kvm_vm_set_mem_attributes() changing the PRIVATE attribute
>> of the gfn.
>>
>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>> ---
>>    arch/x86/kvm/mmu/mmu.c          | 82 +++++++++++++++++++--------------
>>    arch/x86/kvm/mmu/mmu_internal.h |  2 +-
>>    arch/x86/kvm/mmu/tdp_mmu.c      |  2 +-
>>    3 files changed, 49 insertions(+), 37 deletions(-)
>>
>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>> index 20dd9f64156e..61eb9f723675 100644
>> --- a/arch/x86/kvm/mmu/mmu.c
>> +++ b/arch/x86/kvm/mmu/mmu.c
>> @@ -3302,31 +3302,54 @@ static u8 kvm_max_level_for_order(int order)
>>    	return PG_LEVEL_4K;
>>    }
>>    
>> -static u8 kvm_max_private_mapping_level(struct kvm *kvm, kvm_pfn_t pfn,
>> -					u8 max_level, int gmem_order)
>> +static u8 kvm_max_private_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
>> +					const struct kvm_memory_slot *slot, gfn_t gfn)
> 
> I don't see why slot and gfn are needed here. Just to keep consistent
> with host_pfn_mapping_level()?
> 

I assume as a preparation to implement the TODO.


Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb

