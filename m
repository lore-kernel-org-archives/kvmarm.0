Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79C17176226
	for <kvmarm@lists.linux.dev>; Sun,  8 Sep 2024 23:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725839643; cv=none; b=r1lgI6VoXFYCV1PJ/qibHH55uTx/zwKy131d1ydFgEy3Vum8iDjmut536hgftp9arDH216oFwuUMxESSmnG4Z1fGK5UDkKKLlIErL/4wmH+/maagsEqKEPwVruDBfVV4eEvh6WUGtPlYR12F/O7nhdWf+jG7aGKQDEZL3r/Kv0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725839643; c=relaxed/simple;
	bh=qwN6aTuK14BJZiNEg06ambo4ndmvNdA+B4b3NhYEMic=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cnvpzAtjR6LCI0YjJPsqyWbtVVIzSr4KE4407pVz++DXisFU/Nb23MrkIlgK/6RwUdiIwRC7caOL9tETyY2beCMPNcqY0I6k0/eoIrFl4U5yGtedRTQIZZv4mBZHJhoG/6WiF38E98qt59+JoMGbqIVXbdClgD9JOnbR5pLLATI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bpttvt7z; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bpttvt7z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725839639;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wi0uDfX5sgX+oLv1lO6K16Ep91IJ96aWPDPwqIWLlPg=;
	b=bpttvt7zrlKHG8d1+F84x6ToJ5P7gT+g+m4Ztx73vR6V3PAlLojeDlTh0Tg+Yf48dpgaDj
	/3yOQwbdQ8R8fiXHcQOXUcmpOCh2SBlTTbAB+mt+j1+0B44IyQe8r5G/8cXLWQ7I4CyR/T
	jDCi4r9X0XMf3PcxpNQ9XKVhUSK/4go=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-604-RfYnQmziOrSKOwstByAhIg-1; Sun, 08 Sep 2024 19:53:57 -0400
X-MC-Unique: RfYnQmziOrSKOwstByAhIg-1
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-2d8abc9b3e4so4040411a91.2
        for <kvmarm@lists.linux.dev>; Sun, 08 Sep 2024 16:53:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725839636; x=1726444436;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wi0uDfX5sgX+oLv1lO6K16Ep91IJ96aWPDPwqIWLlPg=;
        b=CkYrXOjJbh93UdOVAt063G+1zyxeFamyBCjB2O9x5aYTj6VadkF+18uBGypOGqMd3r
         I6gAmi3L9WyAKBGIWakejL8VPaWwaGs2ImO7okwoGZEfAPIafMMjYhJPc1axPyLoZq9P
         KWFfEJpIjHnOVM7D5wSQ7kO2rQWbrfy5A1WUIu6T2KaOCgLv1bO7NrAQgqgTTQeGNClQ
         Xte97kNfuuX2OpvHcgSQga4MIbAa+FXiAEmDo65VrJQxLpBNED2GvAK2kkZEeOzLAM4M
         vVv+uJe2jGzN/RSOwphO/EgijWCt9wVEoQHcG9Sx/hn6s79YijFChp7qkmxabzhSqaAm
         bfOw==
X-Forwarded-Encrypted: i=1; AJvYcCUCda+ai6F7hU+rC94kDMXs714TI7iy3ENIrfzL7SAJPPfSXuzvHNkh+1s8rMl43JDuvaR/N4M=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx1/OhwGVuYpFib8hqLxJPm3+s6LqJOh4MKKddBfIoyAedYcb3y
	sQH30EBRqfDs2KqXvrkI674fz4+1zlYq5f3Mz1Q4TBsIhIHmLMYWLLF9k6blPJ+wadjpP0VF+CD
	zRqpzBckl3kQaCmVbzgiIByxZw81JsP/C257nvF3RTacYxqg/2Bie9Q==
X-Received: by 2002:a17:90b:e8b:b0:2d8:a672:1869 with SMTP id 98e67ed59e1d1-2daffd0bf58mr7417913a91.32.1725839636442;
        Sun, 08 Sep 2024 16:53:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGnXND6LKMPjrt0KKzz0KFo7SeRMM4AcKKnPnTFybXe+F72ZSBtfd/QDe02gIE0c1lTfUVnXA==
X-Received: by 2002:a17:90b:e8b:b0:2d8:a672:1869 with SMTP id 98e67ed59e1d1-2daffd0bf58mr7417893a91.32.1725839635739;
        Sun, 08 Sep 2024 16:53:55 -0700 (PDT)
Received: from [192.168.68.54] ([103.210.27.31])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2db049873b0sm3208257a91.47.2024.09.08.16.53.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Sep 2024 16:53:54 -0700 (PDT)
Message-ID: <8ed3b6da-8bd2-4c98-9364-8b14c1baae7f@redhat.com>
Date: Mon, 9 Sep 2024 09:53:46 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 07/19] arm64: rsi: Add support for checking whether an
 MMIO is protected
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun <alpergun@google.com>
References: <20240819131924.372366-1-steven.price@arm.com>
 <20240819131924.372366-8-steven.price@arm.com>
 <fe3da777-c6de-451d-8a8a-19fdda8e82e5@redhat.com>
 <8a675a19-52c1-43c7-b560-fbadce0c5145@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <8a675a19-52c1-43c7-b560-fbadce0c5145@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/6/24 11:55 PM, Steven Price wrote:
> On 06/09/2024 05:32, Gavin Shan wrote:
>> On 8/19/24 11:19 PM, Steven Price wrote:
>>> From: Suzuki K Poulose <suzuki.poulose@arm.com>
>>>
>>> On Arm CCA, with RMM-v1.0, all MMIO regions are shared. However, in
>>> the future, an Arm CCA-v1.0 compliant guest may be run in a lesser
>>> privileged partition in the Realm World (with Arm CCA-v1.1 Planes
>>> feature). In this case, some of the MMIO regions may be emulated
>>> by a higher privileged component in the Realm world, i.e, protected.
>>>
>>> Thus the guest must decide today, whether a given MMIO region is shared
>>> vs Protected and create the stage1 mapping accordingly. On Arm CCA, this
>>> detection is based on the "IPA State" (RIPAS == RIPAS_IO). Provide a
>>> helper to run this check on a given range of MMIO.
>>>
>>> Also, provide a arm64 helper which may be hooked in by other solutions.
>>>
>>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>>> Signed-off-by: Steven Price <steven.price@arm.com>
>>> ---
>>> New patch for v5
>>> ---
>>>    arch/arm64/include/asm/io.h       |  8 ++++++++
>>>    arch/arm64/include/asm/rsi.h      |  3 +++
>>>    arch/arm64/include/asm/rsi_cmds.h | 21 +++++++++++++++++++++
>>>    arch/arm64/kernel/rsi.c           | 26 ++++++++++++++++++++++++++
>>>    4 files changed, 58 insertions(+)

[...]

>>> diff --git a/arch/arm64/kernel/rsi.c b/arch/arm64/kernel/rsi.c
>>> index e968a5c9929e..381a5b9a5333 100644
>>> --- a/arch/arm64/kernel/rsi.c
>>> +++ b/arch/arm64/kernel/rsi.c
>>> @@ -67,6 +67,32 @@ void __init arm64_rsi_setup_memory(void)
>>>        }
>>>    }
>>>    +bool arm64_rsi_is_protected_mmio(phys_addr_t base, size_t size)
>>> +{
>>> +    enum ripas ripas;
>>> +    phys_addr_t end, top;
>>> +
>>> +    /* Overflow ? */
>>> +    if (WARN_ON(base + size < base))
>>> +        return false;
>>> +
>>> +    end = ALIGN(base + size, RSI_GRANULE_SIZE);
>>> +    base = ALIGN_DOWN(base, RSI_GRANULE_SIZE);
>>> +
>>> +    while (base < end) {
>>> +        if (WARN_ON(rsi_ipa_state_get(base, end, &ripas, &top)))
>>> +            break;
>>> +        if (WARN_ON(top <= base))
>>> +            break;
>>> +        if (ripas != RSI_RIPAS_IO)
>>> +            break;
>>> +        base = top;
>>> +    }
>>> +
>>> +    return (size && base >= end);
>>> +}
>>
>> I don't understand why @size needs to be checked here. Its initial value
>> taken from the input parameter should be larger than zero and its value
>> is never updated in the loop. So I'm understanding @size is always larger
>> than zero, and the condition would be something like below if I'm correct.
> 
> Yes you are correct. I'm not entirely sure why it was written that way.
> The only change dropping 'size' as you suggest is that a zero-sized
> region is considered protected. But I'd consider it a bug if this is
> called with size=0. I'll drop 'size' here.
> 

The check 'size == 0' could be squeezed to the overflow check if you agree.

     /* size == 0 or overflow */
     if (WARN_ON(base + size) <= base)
         return false;
     :
     
     return (base >= end);


>>         return (base >= end);     /* RSI_RIPAS_IO returned for all
>> granules */
>>
>> Another issue is @top is always zero with the latest tf-rmm. More details
>> are provided below.
> 
> That suggests that you are not actually using the 'latest' tf-rmm ;)
> (for some definition of 'latest' which might not be obvious!)
> 
>>From the cover letter:
> 
>> As mentioned above the new RMM specification means that corresponding
>> changes need to be made in the RMM, at this time these changes are still
>> in review (see 'topics/rmm-1.0-rel0-rc1'). So you'll need to fetch the
>> changes[3] from the gerrit instance until they are pushed to the main
>> branch.
>>
>> [3] https://review.trustedfirmware.org/c/TF-RMM/tf-rmm/+/30485
> 
> Sorry, I should probably have made this much more prominent in the cover
> letter.
> 
> Running something like...
> 
>   git fetch https://git.trustedfirmware.org/TF-RMM/tf-rmm.git \
> 	refs/changes/85/30485/11
> 
> ... should get you the latest. Hopefully these changes will get merged
> to the main branch soon.
> 

My bad. I didn't check the cover letter in time. With this specific TF-RMM branch,
I'm able to boot the guest with cca/host-v4 and cca/guest-v5. However, there are
messages indicating unhandled system register accesses, as below.

# ./start.sh
   Info: # lkvm run -k Image -m 256 -c 2 --name guest-152
   Info: Removed ghost socket file "/root/.lkvm//guest-152.sock".
[   rmm ] SMC_RMI_REALM_CREATE          882860000 880856000 > RMI_SUCCESS
[   rmm ] SMC_RMI_REC_AUX_COUNT         882860000 > RMI_SUCCESS 10
[   rmm ] SMC_RMI_REC_CREATE            882860000 88bdc5000 88bdc4000 > RMI_SUCCESS
[   rmm ] SMC_RMI_REC_CREATE            882860000 88bdd7000 88bdc4000 > RMI_SUCCESS
[   rmm ] SMC_RMI_REALM_ACTIVATE        882860000 > RMI_SUCCESS
[   rmm ] Unhandled write S2_0_C0_C2_2
[   rmm ] Unhandled write S3_3_C9_C14_0
[   rmm ] SMC_RSI_VERSION               10000 > RSI_SUCCESS 10000 10000
[   rmm ] SMC_RSI_REALM_CONFIG          82b2b000 > RSI_SUCCESS
[   rmm ] SMC_RSI_IPA_STATE_SET         80000000 90000000 1 0 > RSI_SUCCESS 90000000 0
[   rmm ] SMC_RSI_IPA_STATE_GET         1000000 1001000 > RSI_SUCCESS 1001000 0
      :
[    1.835570] DMA: preallocated 128 KiB GFP_KERNEL|GFP_DMA32 pool for atomic allocations
[    1.865993] audit: initializing netlink subsys (disabled)
[    1.891218] audit: type=2000 audit(0.492:1): state=initialized audit_enabled=0 res=1
[    1.899066] thermal_sys: Registered thermal governor 'step_wise'
[    1.920869] thermal_sys: Registered thermal governor 'power_allocator'
[    1.944151] cpuidle: using governor menu
[    1.988588] hw-breakpoint: found 16 breakpoint and 16 watchpoint registers.
[   rmm ] Unhandled write S2_0_C0_C0_5
[   rmm ] Unhandled write S2_0_C0_C0_4
[   rmm ] Unhandled write S2_0_C0_C1_5
[   rmm ] Unhandled write S2_0_C0_C1_4
[   rmm ] Unhandled write S2_0_C0_C2_5
      :
[   rmm ] Unhandled write S2_0_C0_C13_6
[   rmm ] Unhandled write S2_0_C0_C14_7
[   rmm ] Unhandled write S2_0_C0_C14_6
[   rmm ] Unhandled write S2_0_C0_C15_7
[   rmm ] Unhandled write S2_0_C0_C15_6

Thanks,
Gavin

