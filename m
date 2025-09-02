Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA4C72E1C63
	for <kvmarm@lists.linux.dev>; Tue,  2 Sep 2025 09:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756806909; cv=none; b=Q88RNVVS3TAd0jdNRu5aJJ0xmRZLghhGgsJUfAT7N1f/d1P4zM/AaRlihqymqv/fmXbO8q3PPzzaEIdVNJyPlU1q8Qs66GmN1hZ5di/4pcH+RzfvgUotrrhp5CMdG7UCJyx0FMzjYmA5ZSWeTk8IcZQQUVpbPkhxHbHQFu7R+Hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756806909; c=relaxed/simple;
	bh=TKtUye35qm8YxL/06m7CPiKXumZCbfKY2t8sC4FWSxQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q1m2GHNDk+B/mV2MCmUrFMat1U8AxyHlWUDx6J5CnR6rwcyGon0UzHHYa3h2MAcNbtZtWIrG0xsfRrZf7VEXldlIqp/tF+9LnhYgxT8psvkBlpOGkIt+dqYXZzhQKIyZuwgKIEwOMWTyPZI4GzodnEk/A71t1s5X8mTm7b/2sQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e4VAVh10; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e4VAVh10"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756806905;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=4eZCyRyOy/1us8vFre1xbt8cZXKsm7kPVp64LbO26As=;
	b=e4VAVh10s7g+Vs5P+Ta5SZCH96Wp0c+Nj+IzUzCQfc+/LQiEs/pRhd0eaNSY7fzCah5OQ/
	3mSVoDO3gRTEEc2b/mvW1oW8aEcmcAEvqnTGPNCBI2k1r0AA2suTTa6anznT3FolKOJyVB
	hYgwx6AiCdEhNm+4xvuettZ3+4x734Y=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-357-5kFcVgjDOwG2-p7g1sbA8A-1; Tue, 02 Sep 2025 05:55:03 -0400
X-MC-Unique: 5kFcVgjDOwG2-p7g1sbA8A-1
X-Mimecast-MFC-AGG-ID: 5kFcVgjDOwG2-p7g1sbA8A_1756806902
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45b87609663so14345145e9.3
        for <kvmarm@lists.linux.dev>; Tue, 02 Sep 2025 02:55:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756806902; x=1757411702;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4eZCyRyOy/1us8vFre1xbt8cZXKsm7kPVp64LbO26As=;
        b=sg+qeEKELlhAZJG3k4PReCmHg3URpTSkzMJuM2gosMwuPGSZiedv3fPhV2+6E9s/wb
         kC3FUpevVOPzt6i4oLVw1E2As9tw0oQf88jr3Di82xi4HngwY/jS/e9NYECnhqIU25BD
         8FPFTsCKFNAegC6S4MCaKwsGGeK1TxCPrqXOp6B+q0Mz04z0Xd705v8xugNMV/wOpCCs
         ZPctRYm1Vs3IshO89eEUcuhUq4SdNK38D95ziOaP6F7gtLiY//BPhYRPLw6urJkoNg4V
         6pPqZf63PE2MldfMxTyf03IPhVfddffjdXEsHl1l45kZ4noE0nRsa6wBbB+Xpq1spBYe
         e9rw==
X-Forwarded-Encrypted: i=1; AJvYcCW+ztW3rp6BFuZw6Ln6oiFKzvribxNF0nDzDfszUfMzGsl9Po9cOvIVsgy/Ypxp2Dfrza36JqQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy1VBB8tfQFrPYBsxpuzygiP1VQ/2cf/0OKYaPYYqiHfysflMNu
	kCWpftYkwh4w7mhnnAOe+h15/kDkJLhbnj7N1E9lYVbbFcmG4hLoaMxWsoTjseRd5Gck0qvV6sL
	ggbDXf6uRP5KkebkH4G+4KkD5FDqbK0CFKTDb9Gz8ajE6/LxFWRSfIhHyng==
X-Gm-Gg: ASbGncu5mxtNsEmFXLI9kuOkI2ODIu2J8gGAcGUQqqDf+OUDs0Ft5aigkeCKbHMFczC
	fHY3IKe1YWEyrMOZF7JONsPWMJOwIYDtDofVYCOKoShNgmfYR3SLmhAOMn+JnxEaY/Na94pjeAo
	PZn1naYSQ6XtZl2EGxr57EOcPTGSFMuqRNfWZVhDyk4PLrfGsfwr3mCWljvTyBdvoYnW66zWFGx
	22+phhYL+ttSPyaEXebDP6S2Geyg5zTeinCF4IUL5C9zR1VywTzuMcQIG9z31yXmrjiUn8IH5P2
	wzB363GonvRymfmbTQl+kVPcTc2CrriBHc8xtzqOUQi8TfWSu6NC2GzcFmUYL8wz3sSL4L13vyx
	mjrXXgXfOHFeG+guC4QSIsT49rquJK7RebFWNkSj/TjSwqJSl5HSx6gF3INleXA4ZkS8=
X-Received: by 2002:a05:600c:4f45:b0:45b:8b3e:9f66 with SMTP id 5b1f17b1804b1-45b8b3ea168mr63251245e9.13.1756806902124;
        Tue, 02 Sep 2025 02:55:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGw9JfwtwC068M3a+d86/hOvR7JxhwCiBJFNzquGsYRrqR/k0m99Ht4VzLz8N6zCOBMmSesxg==
X-Received: by 2002:a05:600c:4f45:b0:45b:8b3e:9f66 with SMTP id 5b1f17b1804b1-45b8b3ea168mr63250885e9.13.1756806901601;
        Tue, 02 Sep 2025 02:55:01 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1f:3f00:731a:f5e5:774e:d40c? (p200300d82f1f3f00731af5e5774ed40c.dip0.t-ipconnect.de. [2003:d8:2f1f:3f00:731a:f5e5:774e:d40c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b7e7d2393sm190896135e9.3.2025.09.02.02.55.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Sep 2025 02:55:01 -0700 (PDT)
Message-ID: <8f571dc9-f2d4-46c2-a4b4-6854fa31da2e@redhat.com>
Date: Tue, 2 Sep 2025 11:54:59 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 03/12] mm: introduce AS_NO_DIRECT_MAP
To: Fuad Tabba <tabba@google.com>, "Roy, Patrick" <roypat@amazon.co.uk>
Cc: "ackerleytng@google.com" <ackerleytng@google.com>,
 "Manwaring, Derek" <derekmn@amazon.com>, "Thomson, Jack"
 <jackabt@amazon.co.uk>, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "rppt@kernel.org" <rppt@kernel.org>, "seanjc@google.com"
 <seanjc@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
 "will@kernel.org" <will@kernel.org>, "Cali, Marco" <xmarcalx@amazon.co.uk>
References: <CA+EHjTxymfya75KdOrUsSUhtfmxe180DedhJpLQAGeCjsum_nw@mail.gmail.com>
 <20250902091810.4854-1-roypat@amazon.co.uk>
 <CA+EHjTz1JxOy=E3p=So2q+k=UK3cDG6C8gOUgA9NQEpqRdhW5g@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <CA+EHjTz1JxOy=E3p=So2q+k=UK3cDG6C8gOUgA9NQEpqRdhW5g@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: JEL7-uOz3vaiEq1K3RaSXIHg5fjN1waPQGgQ_txnhCw_1756806902
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 02.09.25 11:21, Fuad Tabba wrote:
> On Tue, 2 Sept 2025 at 10:18, Roy, Patrick <roypat@amazon.co.uk> wrote:
>>
>> On Tue, 2025-09-02 at 09:50 +0100, Fuad Tabba wrote:
>>> On Tue, 2 Sept 2025 at 09:46, David Hildenbrand <david@redhat.com> wrote:
>>>>
>>>> On 02.09.25 09:59, Fuad Tabba wrote:
>>>>> Hi Patrick,
>>>>>
>>>>> On Mon, 1 Sept 2025 at 15:56, Roy, Patrick <roypat@amazon.co.uk> wrote:
>>>>>>
>>>>>> On Mon, 2025-09-01 at 14:54 +0100, "Roy, Patrick" wrote:
>>>>>>>
>>>>>>> Hi Fuad!
>>>>>>>
>>>>>>> On Thu, 2025-08-28 at 11:21 +0100, Fuad Tabba wrote:
>>>>>>>> Hi Patrick,
>>>>>>>>
>>>>>>>> On Thu, 28 Aug 2025 at 10:39, Roy, Patrick <roypat@amazon.co.uk> wrote:
>>>>>>>>> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
>>>>>>>>> index 12a12dae727d..b52b28ae4636 100644
>>>>>>>>> --- a/include/linux/pagemap.h
>>>>>>>>> +++ b/include/linux/pagemap.h
>>>>>>>>> @@ -211,6 +211,7 @@ enum mapping_flags {
>>>>>>>>>                                      folio contents */
>>>>>>>>>           AS_INACCESSIBLE = 8,    /* Do not attempt direct R/W access to the mapping */
>>>>>>>>>           AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM = 9,
>>>>>>>>> +       AS_NO_DIRECT_MAP = 10,  /* Folios in the mapping are not in the direct map */
>>>>>>>>>           /* Bits 16-25 are used for FOLIO_ORDER */
>>>>>>>>>           AS_FOLIO_ORDER_BITS = 5,
>>>>>>>>>           AS_FOLIO_ORDER_MIN = 16,
>>>>>>>>> @@ -346,6 +347,21 @@ static inline bool mapping_writeback_may_deadlock_on_reclaim(struct address_spac
>>>>>>>>>           return test_bit(AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM, &mapping->flags);
>>>>>>>>>    }
>>>>>>>>>
>>>>>>>>> +static inline void mapping_set_no_direct_map(struct address_space *mapping)
>>>>>>>>> +{
>>>>>>>>> +       set_bit(AS_NO_DIRECT_MAP, &mapping->flags);
>>>>>>>>> +}
>>>>>>>>> +
>>>>>>>>> +static inline bool mapping_no_direct_map(struct address_space *mapping)
>>>>>>>>> +{
>>>>>>>>> +       return test_bit(AS_NO_DIRECT_MAP, &mapping->flags);
>>>>>>>>> +}
>>>>>>>>> +
>>>>>>>>> +static inline bool vma_is_no_direct_map(const struct vm_area_struct *vma)
>>>>>>>>> +{
>>>>>>>>> +       return vma->vm_file && mapping_no_direct_map(vma->vm_file->f_mapping);
>>>>>>>>> +}
>>>>>>>>> +
>>>>>>>> Any reason vma is const whereas mapping in the function that it calls
>>>>>>>> (defined above it) isn't?
>>>>>>>
>>>>>>> Ah, I cannot say that that was a conscious decision, but rather an artifact of
>>>>>>> the code that I looked at for reference when writing these two simply did it
>>>>>>> this way.  Are you saying both should be const, or neither (in my mind, both
>>>>>>> could be const, but the mapping_*() family of functions further up in this file
>>>>>>> dont take const arguments, so I'm a bit unsure now)?
>>>>>>
>>>>>> Hah, just saw
>>>>>> https://lore.kernel.org/linux-mm/20250901123028.3383461-3-max.kellermann@ionos.com/.
>>>>>> Guess that means "both should be const" then :D
>>>>>
>>>>> I don't have any strong preference regarding which way, as long as
>>>>> it's consistent. The thing that should be avoided is having one
>>>>> function with a parameter marked as const, pass that parameter (or
>>>>> something derived from it), to a non-const function.
>>>>
>>>> I think the compiler will tell you that that is not ok (and you'd have
>>>> to force-cast the const it away).
>>>
>>> Not for the scenario I'm worried about. The compiler didn't complain
>>> about this (from this patch):
>>>
>>> +static inline bool mapping_no_direct_map(struct address_space *mapping)
>>> +{
>>> +       return test_bit(AS_NO_DIRECT_MAP, &mapping->flags);
>>> +}
>>> +
>>> +static inline bool vma_is_no_direct_map(const struct vm_area_struct *vma)
>>> +{
>>> +       return vma->vm_file && mapping_no_direct_map(vma->vm_file->f_mapping);
>>> +}
>>>
>>> vma_is_no_direct_map() takes a const, but mapping_no_direct_map()
>>> doesn't. For now, mapping_no_direct_map() doesn't modify anything. But
>>> it could, and the compiler wouldn't complain.
>>
>> Wouldn't this only be a problem if vma->vm_file->f_mapping was a 'const struct
>> address_space *const'? I thought const-ness doesn't leak into pointers (e.g.
>> even above, vma_is_no_direct_map isn't allowed to make vma point at something
>> else, but it could modify the pointed-to vm_area_struct).
> 
> That's the thing, constness checks don't carry over to pointers within
> a struct, but a person reading the code would assume that a function
> with a parameter marked as const wouldn't modify anything related to
> that parameter.

Ah, thanks, I forgot that detail, it's only for embedded structs but not 
pointers.

I wonder if something (sparse?) could detect such cases.

-- 
Cheers

David / dhildenb

