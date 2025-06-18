Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A7627EFFA
	for <kvmarm@lists.linux.dev>; Wed, 18 Jun 2025 09:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750240751; cv=none; b=l2re+k8Me2Q0b4kHeldrru5PvFH3AFvImgkX88+svknNWoPhPg1vwnXg2UX5/bZ1rLywIvot3GTVDUjfsB37S86S1z/xpoURzKRR6D58jCJ1NhZE2HLP9yBGlsprWIqs3f9u0IoM6wvTpugd0aCVeiXrKaGuZnhKqTcwoB/aSVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750240751; c=relaxed/simple;
	bh=IbU3hL365xQP7VbkDnjYG2EA/bVvmMGDALuPzDAtqY4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FijNAXfoudtCfErredj3U3JLX+g19ORNecek1m2iEeyetZe2kKSThdDRrO2eo/OKH/lsNl5jsfArakhgSdJYzFOLGH2ZPdYYc50BsHfwhGcxenp1VehelLMfNuqR9wWpRan64AjxNBskWpyDNdi5uyTSs9qNmDP+6t6Plq+V+80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cUZrkmsT; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cUZrkmsT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750240749;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=OMRUhO/mp0ieoFZKAr0ag4oZWgeT4zNAS1VJ0ZKVtQY=;
	b=cUZrkmsTbQ3CRfXBvPFg0Y66MAAtAdsTZ50oie5fgceU3UhMm4EmV/0f2n7i2A5ZAgeB4R
	Qzns32SuBzxTv2/oYlyU2h3hI7uvVxBk3chUAPan81vfsBIlcJbC0ye61NT+U3dVbI84rP
	zPNJqft4OWDcN1KkxMgOBppu+ntFAbU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-505-3UjgsMk_P5mHo9pmAdagUw-1; Wed, 18 Jun 2025 05:59:07 -0400
X-MC-Unique: 3UjgsMk_P5mHo9pmAdagUw-1
X-Mimecast-MFC-AGG-ID: 3UjgsMk_P5mHo9pmAdagUw_1750240747
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-450cf229025so24378955e9.1
        for <kvmarm@lists.linux.dev>; Wed, 18 Jun 2025 02:59:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750240747; x=1750845547;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=OMRUhO/mp0ieoFZKAr0ag4oZWgeT4zNAS1VJ0ZKVtQY=;
        b=ANhr6ZqVjv+2N4tc2I1RfuiZFPkrTNtYHXlPiTTpGHfum4STLozxscaKhy2LGOaKz3
         biBR2cHdhNuw7QG4vQEY8uH9AIQr2jRWga84FB3jBjPo3XkBb08QNYtDCkfEDUhsL0Ty
         pzkRN8fVpLAJiGbSC0w9b9uUkSCZc4HyNk5Tr9Vv0wX2E2yM2de5167fvCeSLhZavqFy
         oUAR2WPamM9HLcbFKXK7B0DKU9/nRbYLiy2MSnMiyn2NRkwPefOkH9nEgcXJuU72MLDj
         bGZr+w93ZhuTZsChj6k+0QSNG/aEs+JEoBvkBL/oSveRqz4VPrxlY1eJ+f+N04TU22dG
         tW3Q==
X-Forwarded-Encrypted: i=1; AJvYcCXediEbfqe8pIv9n/yRenPbeh4SB6URLEXREIFMq3I/qj6a6t3aj9L3/2wGDmH/1vbHEtd1y3M=@lists.linux.dev
X-Gm-Message-State: AOJu0YzE8Q9nvQfs5oIOom5gCAnUZw3srLHO6/yuRLrGdnhcJMUer5sv
	Jy1j3FRQrFJIKTKGuCYqcb3iP5sTF8ETTuCuiPXO/nqylab9exkTdtnUPQPhcWOU8RjPUyPM6DE
	QHkaT3Yfu2uUOK+KYmogAP4l7A2mDMD4pEdB02bIIZ/HRG+x2iUmoUz0DWw==
X-Gm-Gg: ASbGncuSh7ndfEbYfnnbPhAJdCb6d+mRswHH6bK0NUEQG3TDSwvvQ7SKM8XtPwX0Ia1
	qhfP/WNLIU0Nd1FV+XaP1886PiFPjYT32nQ/tiaQ8gIRv4Fs4POaAXaV2YyZIM3Uay5ymdbfa8e
	NJZ7W30sgpWbXcILxZ94IaNFJpoBsI56OKXGwikdzsmC4yTLpXSRGTbDMZcENVb43I5gkZ0GSui
	8SvwDK3azZ02lXd2QmR6qyy6kklRCNbsFlcty0Jr1s2e5F9A9f75SJmtfl/XEA/tcpCAachY2Gz
	Jd1DOjrFIoZ2QLEVrfgyZdLqREyBT9T5duOW8O0fAe44OoQlgEXn3szky7oYeMHV3nSO95TxX9k
	dwzECTVkavQfZYoagg7eCsZuuw5dMGzLxMbCMQkdWj3aOBiE=
X-Received: by 2002:a05:600c:8286:b0:450:cfe1:a827 with SMTP id 5b1f17b1804b1-4533cb1a7c4mr183852945e9.31.1750240746614;
        Wed, 18 Jun 2025 02:59:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEeMtZwTMybsmgoNvvOF6VHHHUlk9k2VLtSE0TetBvYZv/PFGE1IGpQe1C5P7HOUSTXSsSYMw==
X-Received: by 2002:a05:600c:8286:b0:450:cfe1:a827 with SMTP id 5b1f17b1804b1-4533cb1a7c4mr183852185e9.31.1750240746083;
        Wed, 18 Jun 2025 02:59:06 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f2d:2400:4052:3b5:fff9:4ed0? (p200300d82f2d2400405203b5fff94ed0.dip0.t-ipconnect.de. [2003:d8:2f2d:2400:4052:3b5:fff9:4ed0])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a568b62ba7sm16812291f8f.91.2025.06.18.02.59.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Jun 2025 02:59:05 -0700 (PDT)
Message-ID: <40a5903b-f747-4eab-8959-06ddd6e88f82@redhat.com>
Date: Wed, 18 Jun 2025 11:59:02 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 08/18] KVM: guest_memfd: Allow host to map guest_memfd
 pages
To: Xiaoyao Li <xiaoyao.li@intel.com>, Sean Christopherson <seanjc@google.com>
Cc: Fuad Tabba <tabba@google.com>, Ira Weiny <ira.weiny@intel.com>,
 kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org,
 kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org,
 mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org,
 amoorthy@google.com, dmatlack@google.com, isaku.yamahata@intel.com,
 mic@digikod.net, vbabka@suse.cz, vannapurve@google.com,
 ackerleytng@google.com, mail@maciej.szmigiero.name, michael.roth@amd.com,
 wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com,
 kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com,
 steven.price@arm.com, quic_eberman@quicinc.com, quic_mnalajal@quicinc.com,
 quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com,
 quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com,
 quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com,
 yuzenghui@huawei.com, oliver.upton@linux.dev, maz@kernel.org,
 will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk,
 shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com,
 jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com
References: <20250611133330.1514028-1-tabba@google.com>
 <20250611133330.1514028-9-tabba@google.com> <aEySD5XoxKbkcuEZ@google.com>
 <68501fa5dce32_2376af294d1@iweiny-mobl.notmuch>
 <bbc213c3-bc3d-4f57-b357-a79a9e9290c5@redhat.com>
 <CA+EHjTxvqDr1tavpx7d9OyC2VfUqAko864zH9Qn5+B0UQiM93g@mail.gmail.com>
 <701c8716-dd69-4bf6-9d36-4f8847f96e18@redhat.com>
 <aFIK9l6H7qOG0HYB@google.com>
 <3fb0e82b-f4ef-402d-a33c-0b12e8aa990c@redhat.com>
 <5ee9bbb8-d100-408c-ac07-ea9c5b603545@intel.com>
 <5a55d95e-5e32-4239-a445-be13228ea80b@redhat.com>
 <45af2c0d-a416-49bc-8011-4ec57a56d6f5@intel.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <45af2c0d-a416-49bc-8011-4ec57a56d6f5@intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: UC2WwniegW96ycZbstLoli_sulfIKnrdhBpEXTN3t-o_1750240747
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 18.06.25 11:44, Xiaoyao Li wrote:
> On 6/18/2025 5:27 PM, David Hildenbrand wrote:
>> On 18.06.25 11:20, Xiaoyao Li wrote:
>>> On 6/18/2025 4:15 PM, David Hildenbrand wrote:
>>>>> If we are really dead set on having SHARED in the name, it could be
>>>>> GUEST_MEMFD_FLAG_USER_MAPPABLE_SHARED or
>>>>> GUEST_MEMFD_FLAG_USER_MAP_SHARED?  But
>>>>> to me that's _too_ specific and again somewhat confusing given the
>>>>> unfortunate
>>>>> private vs. shared usage in CoCo-land.  And just playing the odds, I'm
>>>>> fine taking
>>>>> a risk of ending up with GUEST_MEMFD_FLAG_USER_MAPPABLE_PRIVATE or
>>>>> whatever,
>>>>> because I think that is comically unlikely to happen.
>>>>
>>>> I think in addition to GUEST_MEMFD_FLAG_MMAP we want something to
>>>> express "this is not your old guest_memfd that only supports private
>>>> memory". And that's what I am struggling with.
>>>
>>> Sorry for chiming in.
>>>
>>> Per my understanding, (old) guest memfd only means it's the memory that
>>> cannot be accessed by userspace. There should be no shared/private
>>> concept on it.
>>>
>>> And "private" is the concept of KVM. Guest memfd can serve as private
>>> memory, is just due to the character of it cannot be accessed from
>>> userspace.
>>>
>>> So if the guest memfd can be mmap'ed, then it become userspace
>>> accessable and cannot serve as private memory.
>>>
>>>> Now, if you argue "support for mmap() implies support for non-private
>>>> memory", I'm probably okay for that.
>>>
>>> I would say, support for mmap() implies cannot be used as private memory.
>>
>> That's not where we're heading with in-place conversion support: you
>> will have private (ianccessible) and non-private (accessible) parts, and
>> while guest_memfd will support mmap() only the accessible parts can
>> actually be accessed (faulted in etc).
> 
> That's OK. The guestmemfd can be fine-grained, i.e., different
> range/part of it can have different access property. But one rule never
> change: only the sub-range is not accessible by userspace can it be
> serve as private memory.

I'm sorry, I don't understand what you are getting at.

You said "So if the guest memfd can be mmap'ed, then it become userspace 
accessable and cannot serve as private memory." and I say, with in-place 
conversion support you are wrong.

The whole file can be mmaped(), that does not tell us anything about 
which parts can be private or not.

-- 
Cheers,

David / dhildenb

