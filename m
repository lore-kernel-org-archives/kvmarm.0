Return-Path: <SRS0=sayA=JR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F5C5C433B4
	for <kvmarm@archiver.kernel.org>; Tue, 20 Apr 2021 15:19:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BFDD5613C9
	for <kvmarm@archiver.kernel.org>; Tue, 20 Apr 2021 15:19:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BFDD5613C9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 23AB64B3C6;
	Tue, 20 Apr 2021 11:19:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zTXsyrxUpbok; Tue, 20 Apr 2021 11:19:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 49A284B3CB;
	Tue, 20 Apr 2021 11:19:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C32AA4B3C3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Apr 2021 11:19:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eRAJeiVUn35M for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Apr 2021 11:19:01 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 61A5C4B3C1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Apr 2021 11:19:01 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1618931941;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=770vz2JVGNnIzK29NwyJrUqxj03tbV5pp2hzoWbqGVw=;
 b=Q0fX72woI2fvhNall7DJCqEkfuO093ipbFebb60LPf5hwtN9yaB6wNQIuGhL0d1lAgaxAB
 NXSw6MEyO8Mq0dry2tVtSQXWkBD0hrjn+YrkRq0V9Mu+Mb1dmVci4vMlGICfj8oRA2XiLP
 lQ03GBoTUtDNZUxy915BwT5a58Q+W8w=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-482-4aDSnM3PM9CIbjH5-T6J8Q-1; Tue, 20 Apr 2021 11:18:59 -0400
X-MC-Unique: 4aDSnM3PM9CIbjH5-T6J8Q-1
Received: by mail-ej1-f69.google.com with SMTP id
 jl27-20020a17090775dbb029037ccdce96e6so4889096ejc.21
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Apr 2021 08:18:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:organization
 :message-id:date:user-agent:mime-version:in-reply-to
 :content-language:content-transfer-encoding;
 bh=770vz2JVGNnIzK29NwyJrUqxj03tbV5pp2hzoWbqGVw=;
 b=H2qH3sASHa8w8PTE3qF91hPeE6UyLvU5eB/T1fdeIuMR4R4f7l7pkcAM8OUEgUp1O1
 4AmH5+OrINMS77k+9qJeSCwDlaoKtY4OhQtfTrvRN9e0Evy+P3wdm0ZEdXQVeyDvAy6d
 6/Q5VSM9tWDXnwdzi41RTUOP/uhYWaw6kcQuSulSIzTBuiRVSB+CjFpHtAakp3VdCO0Y
 HrzrBWFLqprK1rXRPGt+VJWhq18lxzTWEyxGk3Oo1PcNf3R24z9PJPtNoHIlVkCyekmP
 wlP6kT5Hnn5Qje8crB7hHXT8zd0eGusF3nowxWqBkTSRoJUGrlUjf7KqgWxyOsFVhPDP
 5iPw==
X-Gm-Message-State: AOAM530PuN0G5eTPKn4vFsUpb9a4gjFrGai2dzTNtmkDPiuWOkN6fnS6
 XsN9teG+CN+vZfmwihXTmLtm9D8uKAOxA4SiVuLbIBIXOhRPdCnCfxC339bbMffpMtwF5lDh4bm
 oLEUtGG/PrtPowbwT+dCTZk6a
X-Received: by 2002:a17:906:6d48:: with SMTP id
 a8mr28828664ejt.92.1618931936868; 
 Tue, 20 Apr 2021 08:18:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwX0gjV1YOL8zIlogJIXvYhztp20fRFlx1w9hSqe5B3fLMvw1anl4MLNbGH45aEpi3l71uCRQ==
X-Received: by 2002:a17:906:6d48:: with SMTP id
 a8mr28828644ejt.92.1618931936653; 
 Tue, 20 Apr 2021 08:18:56 -0700 (PDT)
Received: from [192.168.3.132] (p4ff2390a.dip0.t-ipconnect.de. [79.242.57.10])
 by smtp.gmail.com with ESMTPSA id
 v8sm16154073edc.30.2021.04.20.08.18.55
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 20 Apr 2021 08:18:56 -0700 (PDT)
Subject: Re: [PATCH v1 2/4] memblock: update initialization of reserved pages
To: Mike Rapoport <rppt@kernel.org>
References: <20210420090925.7457-1-rppt@kernel.org>
 <20210420090925.7457-3-rppt@kernel.org>
 <ed8f10a0-9b68-1d12-0305-90fd378af6b9@redhat.com>
 <YH7tL77Z9UzTAFca@kernel.org>
From: David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <45a7e13d-3e44-3b94-a253-2df72649a83d@redhat.com>
Date: Tue, 20 Apr 2021 17:18:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YH7tL77Z9UzTAFca@kernel.org>
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

On 20.04.21 17:03, Mike Rapoport wrote:
> On Tue, Apr 20, 2021 at 03:56:28PM +0200, David Hildenbrand wrote:
>> On 20.04.21 11:09, Mike Rapoport wrote:
>>> From: Mike Rapoport <rppt@linux.ibm.com>
>>>
>>> The struct pages representing a reserved memory region are initialized
>>> using reserve_bootmem_range() function. This function is called for each
>>> reserved region just before the memory is freed from memblock to the buddy
>>> page allocator.
>>>
>>> The struct pages for MEMBLOCK_NOMAP regions are kept with the default
>>> values set by the memory map initialization which makes it necessary to
>>> have a special treatment for such pages in pfn_valid() and
>>> pfn_valid_within().
>>
>> Just a general question while thinking about it:
>>
>> Would we right now initialize the memmap of these pages already via
>> memmap_init_zone()->memmap_init_range()? (IOW, not marking the
>> PageReserved?)
> 
> Yep. These pages are part of memblock.memory so they are initialized in
> memmap_init_zone()->memmap_init_range() to the default values.
> 

So instead of fully initializing them again, we mostly would only have 
to set PageReserved(). Not sure how big that memory usually is -- IOW, 
if we really care about optimizing the double-init.

-- 
Thanks,

David / dhildenb

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
