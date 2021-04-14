Return-Path: <SRS0=hZsu=JL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21DCDC433B4
	for <kvmarm@archiver.kernel.org>; Wed, 14 Apr 2021 15:53:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9601F61222
	for <kvmarm@archiver.kernel.org>; Wed, 14 Apr 2021 15:53:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9601F61222
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 02BCD4B648;
	Wed, 14 Apr 2021 11:53:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id t2vI7eaWIxpv; Wed, 14 Apr 2021 11:53:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DD3194B65E;
	Wed, 14 Apr 2021 11:53:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 082BB4B648
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Apr 2021 11:53:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4tOds0gjt6XE for <kvmarm@lists.cs.columbia.edu>;
 Wed, 14 Apr 2021 11:53:02 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B5F04B63F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Apr 2021 11:53:01 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1618415581;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=5YzCxsnnijC//XX+MlJqJz04Lu4zT3zQq8qLb1/6PL8=;
 b=N3azEr1ngxbg5Okfzokn3K+Vj8x1YT1chtg/3cPj88jYlzCSUj97TjSeFM+icr/ZSz9UjK
 n8nyxXERFsZid/76ryc48rtDYfhUgd7Hr2CH7xzLpw/rKyfA3OsHjkzjaOEmzgCxy6r5Dc
 8gRIO4EFpV1RVIW6vdrADRh67QLnPbg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-62-wxX6_0tQO-qdsFuLmH3I3w-1; Wed, 14 Apr 2021 11:53:00 -0400
X-MC-Unique: wxX6_0tQO-qdsFuLmH3I3w-1
Received: by mail-wr1-f71.google.com with SMTP id
 y13-20020adfdf0d0000b02901029a3bf796so1258538wrl.15
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Apr 2021 08:53:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:to:cc:references:from:organization:subject
 :message-id:date:user-agent:mime-version:in-reply-to
 :content-language:content-transfer-encoding;
 bh=5YzCxsnnijC//XX+MlJqJz04Lu4zT3zQq8qLb1/6PL8=;
 b=BB4sLNBb9wDMfeqcQqXMRw4/ctHOU+2csTHbGljGsQnAVYVaNQDEghH16w2ulN5cDs
 wkQC+TAIo4WQcVfN5LgVpRqr9FGcxsDBwyhC/tZhnc0GeDke0SXzJ7bPc4BfrZ8LHlwn
 N/ah+LOk7jYtDBHsrl4kwZ9A3ZP5k1kF90VcGVgvjXxuR+4bf70R2Lf+qxJH+Ov2vXRE
 6AH/sJb0KfUkVrASjQoqR86b8h506OIRrLZR7p2u7rTu1sxQA9Vl6e067XW0kWMcqPKW
 x2nM4Z5KGNdmJFC3OBHW7+/WhRrqSfh5fMTZ4xApr1i7jahNfP+0M7CribFJotLD6R8w
 eQcQ==
X-Gm-Message-State: AOAM533FP7pRLW0q1RoCgSQJ/PoxpnnPF22hiEMAOEUjHfpR9HV+juIX
 X/W5eXm0mpy4hGDK9X7kx0ZWiTVYoBwUJeOzYrwfDH4a13jQE9iGrvz7QrVEzfA4OIH1a4nvO7k
 Fqf0sB38nxfBt/FfhzdVOiRT/
X-Received: by 2002:a05:6000:1449:: with SMTP id
 v9mr19611109wrx.295.1618415579020; 
 Wed, 14 Apr 2021 08:52:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwwrSOMpK/YVN66pneA+j1TjD57EZ3NUFrkJFb4IkiDMz2r4seRtxhdfypbvJbPgTdVs+mLkw==
X-Received: by 2002:a05:6000:1449:: with SMTP id
 v9mr19611079wrx.295.1618415578737; 
 Wed, 14 Apr 2021 08:52:58 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c6470.dip0.t-ipconnect.de. [91.12.100.112])
 by smtp.gmail.com with ESMTPSA id u3sm5657582wmg.48.2021.04.14.08.52.57
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 14 Apr 2021 08:52:58 -0700 (PDT)
To: Ard Biesheuvel <ardb@kernel.org>
References: <20210407172607.8812-1-rppt@kernel.org>
 <20210407172607.8812-2-rppt@kernel.org>
 <0c48f98c-7454-1458-15a5-cc5a7e1fb7cd@redhat.com>
 <CAMj1kXGw97epyP2HdHjA8Yp6+VF1j5xmd0AgVBBv3k+h_B610w@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [RFC/RFT PATCH 1/3] memblock: update initialization of reserved
 pages
Message-ID: <3811547a-9057-3c80-3805-2e658488ac99@redhat.com>
Date: Wed, 14 Apr 2021 17:52:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CAMj1kXGw97epyP2HdHjA8Yp6+VF1j5xmd0AgVBBv3k+h_B610w@mail.gmail.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=david@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Mike Rapoport <rppt@linux.ibm.com>,
 Linux Memory Management List <linux-mm@kvack.org>,
 Mike Rapoport <rppt@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, kvmarm <kvmarm@lists.cs.columbia.edu>,
 Linux ARM <linux-arm-kernel@lists.infradead.org>
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

On 14.04.21 17:27, Ard Biesheuvel wrote:
> On Wed, 14 Apr 2021 at 17:14, David Hildenbrand <david@redhat.com> wrote:
>>
>> On 07.04.21 19:26, Mike Rapoport wrote:
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
>> I assume these pages are never given to the buddy, because we don't have
>> a direct mapping. So to the kernel, it's essentially just like a memory
>> hole with benefits.
>>
>> I can spot that we want to export such memory like any special memory
>> thingy/hole in /proc/iomem -- "reserved", which makes sense.
>>
>> I would assume that MEMBLOCK_NOMAP is a special type of *reserved*
>> memory. IOW, that for_each_reserved_mem_range() should already succeed
>> on these as well -- we should mark anything that is MEMBLOCK_NOMAP
>> implicitly as reserved. Or are there valid reasons not to do so? What
>> can anyone do with that memory?
>>
>> I assume they are pretty much useless for the kernel, right? Like other
>> reserved memory ranges.
>>
> 
> On ARM, we need to know whether any physical regions that do not
> contain system memory contain something with device semantics or not.
> One of the examples is ACPI tables: these are in reserved memory, and
> so they are not covered by the linear region. However, when the ACPI
> core ioremap()s an arbitrary memory region, we don't know whether it
> is mapping a memory region or a device region unless we keep track of
> this in some way. (Device mappings require device attributes, but
> firmware tables require memory attributes, as they might be accessed
> using misaligned reads)

Using generically sounding NOMAP ("don't create direct mapping") to 
identify device regions feels like a hack. I know, it was introduced 
just for that purpose.

Looking at memblock_mark_nomap(), we consider "device regions"

1) ACPI tables

2) VIDEO_TYPE_EFI memory

3) some device-tree regions in of/fdt.c


IIUC, right now we end up creating a memmap for this NOMAP memory, but 
hide it away in pfn_valid(). This patch set at least fixes that.

Assuming these pages are never mapped to user space via the struct page 
(which better be the case), we could further use a new pagetype to mark 
these pages in a special way, such that we can identify them directly 
via pfn_to_page().

Then, we could mostly avoid having to query memblock at runtime to 
figure out that this is special memory. This would obviously be an 
extension to this series. Just a thought.

-- 
Thanks,

David / dhildenb

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
