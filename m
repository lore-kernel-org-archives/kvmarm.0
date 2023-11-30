Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1DD351016
	for <kvmarm@lists.linux.dev>; Thu, 30 Nov 2023 14:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DwwjFSyB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701355182;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/AqGlRrDsos2DSPP9yGmIJQFx/oRnqCKEogsu6TRXiA=;
	b=DwwjFSyB+ZAWPuYNRfqGF74V6cZKAURlBIICe5joFIAhEWnZNfmDksw4Raz0H3XLs3msJd
	mwzYeO0RVotFVOEC4y0KmhFQaKw6ll8S/Ey9IFuB9AaPx7Vf2+/4L1/eInZ/9J6TqfbNIA
	Gawfqp0XQayoOmtEPHOC5/wpenaVC1E=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-90-rpwkvPQyOnCnL9LiVgmDzA-1; Thu, 30 Nov 2023 09:39:39 -0500
X-MC-Unique: rpwkvPQyOnCnL9LiVgmDzA-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-40b2977d7c5so8371885e9.2
        for <kvmarm@lists.linux.dev>; Thu, 30 Nov 2023 06:39:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701355178; x=1701959978;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :references:cc:to:content-language:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/AqGlRrDsos2DSPP9yGmIJQFx/oRnqCKEogsu6TRXiA=;
        b=VWGXs/2BwrynVM7sOVxyJaItz6d7c9jjBboLNOC/dnwwuxCsNqLVNG2N+JsbLQUeIW
         nhhyOPo3SBIuspmUM1kZg0K/TIDBjxcwv919S0J3XkdCoSBXl2S1wGbI5CNomU+VIvh8
         dDxz4rlGHHUHKtMvXxwpsXKEy5H8GTl4rshenwdiKXrIV396YZnL50ZYCWOuCDGS51SH
         GNMYF9FAlMcWN1R1JIZYwK20J6Qy02Nz7dQD3BNsApJbJ8fWJN9nyd7qY+BqqRWuXQwq
         yTxu4S7VSOdYuNvc9OXAE2nvHR5wJjTy/+AjcTDGUQ5tGcORHsIEwR6WdcLnZWnRkesj
         GQpA==
X-Gm-Message-State: AOJu0YzFoJxaDd++fowTWYt0EyU4//xiySET6mJTvy6nuC8ih34uKsAt
	3aMPsiQpmO2K+z6qqmvN/5gSUv5B2IqRm55zA3YDhXJxYWZjRKmr8u60ermy/dbDavl7ObZXGCE
	rStVxUJXVKKeDF78M
X-Received: by 2002:adf:ef0c:0:b0:332:c9eb:87dc with SMTP id e12-20020adfef0c000000b00332c9eb87dcmr13849322wro.44.1701355177838;
        Thu, 30 Nov 2023 06:39:37 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGmmUOvY7BaMyvhwtzzzHkQGdJ3HD/gQl886sBV5QKgh0Olugnr3WiObakVrAK2MV7Js3nzQA==
X-Received: by 2002:adf:ef0c:0:b0:332:c9eb:87dc with SMTP id e12-20020adfef0c000000b00332c9eb87dcmr13849292wro.44.1701355177396;
        Thu, 30 Nov 2023 06:39:37 -0800 (PST)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id r4-20020adff104000000b003313e4dddecsm1698979wro.108.2023.11.30.06.39.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Nov 2023 06:39:36 -0800 (PST)
Message-ID: <92833873-cd70-44b0-9f34-f4ac11b9e498@redhat.com>
Date: Thu, 30 Nov 2023 15:39:35 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 19/27] mm: mprotect: Introduce PAGE_FAULT_ON_ACCESS
 for mprotect(PROT_MTE)
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Hyesoo Yu <hyesoo.yu@samsung.com>, catalin.marinas@arm.com,
 will@kernel.org, oliver.upton@linux.dev, maz@kernel.org,
 james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 arnd@arndb.de, akpm@linux-foundation.org, mingo@redhat.com,
 peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org,
 dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com,
 mgorman@suse.de, bristot@redhat.com, vschneid@redhat.com,
 mhiramat@kernel.org, rppt@kernel.org, hughd@google.com, pcc@google.com,
 steven.price@arm.com, anshuman.khandual@arm.com, vincenzo.frascino@arm.com,
 eugenis@google.com, kcc@google.com, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org
References: <20231119165721.9849-1-alexandru.elisei@arm.com>
 <CGME20231119165921epcas2p3dce0532847d59a9c3973b4e41102e27d@epcas2p3.samsung.com>
 <20231119165721.9849-20-alexandru.elisei@arm.com>
 <20231129092725.GD2988384@tiffany> <ZWh6vl8DfXQbKo9O@raptor>
 <4e7a4054-092c-4e34-ae00-0105d7c9343c@redhat.com> <ZWiO4PWfK2gKDLGr@raptor>
 <d7e0574d-c74d-4e91-bf60-aa6691df78e3@redhat.com> <ZWidOFYNjd7xM0c7@raptor>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <ZWidOFYNjd7xM0c7@raptor>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 30.11.23 15:33, Alexandru Elisei wrote:
> On Thu, Nov 30, 2023 at 02:43:48PM +0100, David Hildenbrand wrote:
>> On 30.11.23 14:32, Alexandru Elisei wrote:
>>> Hi,
>>>
>>> On Thu, Nov 30, 2023 at 01:49:34PM +0100, David Hildenbrand wrote:
>>>>>>> +
>>>>>>> +out_retry:
>>>>>>> +	put_page(page);
>>>>>>> +	if (vmf->flags & FAULT_FLAG_VMA_LOCK)
>>>>>>> +		vma_end_read(vma);
>>>>>>> +	if (fault_flag_allow_retry_first(vmf->flags)) {
>>>>>>> +		err = VM_FAULT_RETRY;
>>>>>>> +	} else {
>>>>>>> +		/* Replay the fault. */
>>>>>>> +		err = 0;
>>>>>>
>>>>>> Hello!
>>>>>>
>>>>>> Unfortunately, if the page continues to be pinned, it seems like fault will continue to occur.
>>>>>> I guess it makes system stability issue. (but I'm not familiar with that, so please let me know if I'm mistaken!)
>>>>>>
>>>>>> How about migrating the page when migration problem repeats.
>>>>>
>>>>> Yes, I had the same though in the previous iteration of the series, the
>>>>> page was migrated out of the VMA if tag storage couldn't be reserved.
>>>>>
>>>>> Only short term pins are allowed on MIGRATE_CMA pages, so I expect that the
>>>>> pin will be released before the fault is replayed. Because of this, and
>>>>> because it makes the code simpler, I chose not to migrate the page if tag
>>>>> storage couldn't be reserved.
>>>>
>>>> There are still some cases that are theoretically problematic: vmsplice()
>>>> can pin pages forever and doesn't use FOLL_LONGTERM yet.
>>>>
>>>> All these things also affect other users that rely on movability (e.g., CMA,
>>>> memory hotunplug).
>>>
>>> I wasn't aware of that, thank you for the information. Then to ensure that the
>>> process doesn't hang by replying the loop indefinitely, I'll migrate the page if
>>> tag storage cannot be reserved. Looking over the code again, I think I can reuse
>>> the same function that migrates tag storage pages out of the MTE VMA (added in
>>> patch #21), so no major changes needed.
>>
>> It's going to be interesting if migrating that page fails because it is
>> pinned :/
> 
> I imagine that having both the page **and** its tag storage pinned longterm
> without FOLL_LONGTERM is going to be exceedingly rare.

Yes. I recall that the rule of thumb is that some O_DIRECT I/O can take 
up to 10 seconds, although extremely rare (and maybe not applicable on 
arm64).

> 
> Am I mistaken in believing that the problematic vmsplice() behaviour is
> recognized as something that needs to be fixed?

Yes, for a couple of years  I'm hoping this will actually get fixed now 
that O_DIRECT mostly uses FOLL_PIN instead of FOLL_GET.

-- 
Cheers,

David / dhildenb

