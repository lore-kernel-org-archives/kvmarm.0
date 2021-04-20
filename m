Return-Path: <SRS0=sayA=JR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 509BCC433B4
	for <kvmarm@archiver.kernel.org>; Tue, 20 Apr 2021 12:59:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9C4D9613CD
	for <kvmarm@archiver.kernel.org>; Tue, 20 Apr 2021 12:59:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9C4D9613CD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0EAEB4B38E;
	Tue, 20 Apr 2021 08:59:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WjIB1FADzakF; Tue, 20 Apr 2021 08:59:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 587FA4B396;
	Tue, 20 Apr 2021 08:59:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BAF444B396
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Apr 2021 08:58:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7G8vKX6xTZnF for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Apr 2021 08:58:58 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BBAC84B38E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Apr 2021 08:58:58 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1618923538;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=InC/09SU2jowBshG+H/mXghIo0fijTDczsPvBvuygWs=;
 b=V9HkKsJEs+iXVBZ19m0IwEmBxNHpDWJprZ4tTQq+3jrsa3cNXxYXC8RyXVuV1lUrhM4v78
 6AQq2KLKklcoh/WI0Zkqa1ZnhQwkAUxK6Hcat645vrhZozNU78d23hwYsz93wtCbgyb+wU
 d90+9bmFH2jXpZiuXJN3hOWyh8tQIjM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-144-XozzrrOeP5iT95knvXkMzQ-1; Tue, 20 Apr 2021 08:58:56 -0400
X-MC-Unique: XozzrrOeP5iT95knvXkMzQ-1
Received: by mail-wr1-f71.google.com with SMTP id
 91-20020adf82e40000b0290106e67e7bfcso8061824wrc.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Apr 2021 05:58:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:organization
 :message-id:date:user-agent:mime-version:in-reply-to
 :content-language:content-transfer-encoding;
 bh=InC/09SU2jowBshG+H/mXghIo0fijTDczsPvBvuygWs=;
 b=tH0Lkwc67JzMxiaL1HIEhnMvDqGDm64aof9o1frarVVEkIh4yxEPAjZvVIYTAvAG3p
 vK88WCuMcZrpu46wXCQl+krqzEdOHpOeRpfdZXmJE0OnULzky9OIkiWVUUhoiX+ykZNr
 G9m31qPJMWuKUchWw5PMck5lmYvCnGOlc1nDo4OLiXULCRx7f5UBth3Ptp7kDqFyLX0Q
 V6DJvMJQX3de/uavnrdMK14JrbREErdqnaQvCimHcpbGHeIXo8QGvCioK5gGs00ptq7f
 +UfwS7C0ixXNiLBJiN6ed4yqqm2AxET3vHjfhAW4VLKIDUcp8o4doKUPRJ79bN7vWy//
 6myw==
X-Gm-Message-State: AOAM531gcX0iwFWyheUxrQwgT+SLBmli1JcKfTaFkR68upGm61wvw6gV
 XhClRpuJ4HLiLqvakhb1m5vlxOaq5UA4VncyC6fJsKm5ms2cvFCXt+w8D1gRhXg+1RMkKC9ogxK
 0rX+790j4duuozeNobJK1WFJ4
X-Received: by 2002:a1c:454:: with SMTP id 81mr4372376wme.186.1618923535248;
 Tue, 20 Apr 2021 05:58:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzN432Bkl8h0VlShbz+ZgmHfmV79yLlF8E3/1xyjGalQUC9+ROSAJDjYzCWA1CcV6ig2Ye5wQ==
X-Received: by 2002:a1c:454:: with SMTP id 81mr4372354wme.186.1618923534988;
 Tue, 20 Apr 2021 05:58:54 -0700 (PDT)
Received: from [192.168.3.132] (p4ff2390a.dip0.t-ipconnect.de. [79.242.57.10])
 by smtp.gmail.com with ESMTPSA id
 x2sm30458360wrg.31.2021.04.20.05.58.54
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 20 Apr 2021 05:58:54 -0700 (PDT)
Subject: Re: [PATCH v1 1/4] include/linux/mmzone.h: add documentation for
 pfn_valid()
To: Mike Rapoport <rppt@kernel.org>
References: <20210420090925.7457-1-rppt@kernel.org>
 <20210420090925.7457-2-rppt@kernel.org>
 <f900f889-f059-7d48-dfc7-145c8cd54cf6@redhat.com>
 <YH7P0J4+1erJK7v5@kernel.org>
From: David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <07216f89-369f-0dcc-7bc0-97c204981396@redhat.com>
Date: Tue, 20 Apr 2021 14:58:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YH7P0J4+1erJK7v5@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=david@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 Mike Rapoport <rppt@linux.ibm.com>, linux-mm@kvack.org,
 kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 20.04.21 14:57, Mike Rapoport wrote:
> On Tue, Apr 20, 2021 at 11:22:53AM +0200, David Hildenbrand wrote:
>> On 20.04.21 11:09, Mike Rapoport wrote:
>>> From: Mike Rapoport <rppt@linux.ibm.com>
>>>
>>> Add comment describing the semantics of pfn_valid() that clarifies that
>>> pfn_valid() only checks for availability of a memory map entry (i.e. struct
>>> page) for a PFN rather than availability of usable memory backing that PFN.
>>>
>>> The most "generic" version of pfn_valid() used by the configurations with
>>> SPARSEMEM enabled resides in include/linux/mmzone.h so this is the most
>>> suitable place for documentation about semantics of pfn_valid().
>>>
>>> Suggested-by: Anshuman Khandual <anshuman.khandual@arm.com>
>>> Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
>>> ---
>>>    include/linux/mmzone.h | 11 +++++++++++
>>>    1 file changed, 11 insertions(+)
>>>
>>> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
>>> index 47946cec7584..961f0eeefb62 100644
>>> --- a/include/linux/mmzone.h
>>> +++ b/include/linux/mmzone.h
>>> @@ -1410,6 +1410,17 @@ static inline int pfn_section_valid(struct mem_section *ms, unsigned long pfn)
>>>    #endif
>>>    #ifndef CONFIG_HAVE_ARCH_PFN_VALID
>>> +/**
>>> + * pfn_valid - check if there is a valid memory map entry for a PFN
>>> + * @pfn: the page frame number to check
>>> + *
>>> + * Check if there is a valid memory map entry aka struct page for the @pfn.
>>> + * Note, that availability of the memory map entry does not imply that
>>> + * there is actual usable memory at that @pfn. The struct page may
>>> + * represent a hole or an unusable page frame.
>>> + *
>>> + * Return: 1 for PFNs that have memory map entries and 0 otherwise
>>> + */
>>>    static inline int pfn_valid(unsigned long pfn)
>>>    {
>>>    	struct mem_section *ms;
>>>
>>
>> I'd rephrase all "there is a valid memory map" to "there is a memory map"
>> and add "pfn_valid() does to indicate whether the memory map as actually
>> initialized -- see pfn_to_online_page()."
>>
>> pfn_valid() means that we can do a pfn_to_page() and don't get a fault when
>> accessing the "struct page". It doesn't state anything about the content.
> 
> Well, I mean valid in the sense you can access the struct page :)
> How about:
> 
> /**
>   * pfn_valid - check if there is a memory map entry for a PFN
>   * @pfn: the page frame number to check
>   *
>   * Check if there is a memory map entry aka struct page for the @pfn and it
>   * is safe to access that struct page; the struct page state may be
>   * uninitialized -- see pfn_to_online_page().
>   *
>   * Note, that availability of the memory map entry does not imply that
>   * there is actual usable memory at that @pfn. The struct page may
>   * represent a hole or an unusable page frame.
>   *
>   * Return: 1 for PFNs that have memory map entries and 0 otherwise.
>   */
> 

Sounds good to me -- thanks!

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
