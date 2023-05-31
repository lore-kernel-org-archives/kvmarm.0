Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD2683C0A5
	for <kvmarm@lists.linux.dev>; Wed, 31 May 2023 20:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685564095;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nTJ77IxJoCf3R6qu07kat3hn+MjqbGQgNapLEu9GtEI=;
	b=Gy873x6muFst0xkg7wPJe7ZoH+gIaHpvhN11e2Ogis/zXDQf38PBfPsl6M645cxX2z938T
	GMaXcVZhO0i62zA9tYn6WLaB8PRMhKHqVrBFMINOCvPZqdFS62htsDW4YxrwAQDgRgqHrT
	tRQq8+ZlXumLAAFUzA8/XVfyl3OkD9M=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-650-UUqeuMahMKW5SubGnzW3Wg-1; Wed, 31 May 2023 16:14:54 -0400
X-MC-Unique: UUqeuMahMKW5SubGnzW3Wg-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-3f6ffc456e7so408525e9.2
        for <kvmarm@lists.linux.dev>; Wed, 31 May 2023 13:14:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685564093; x=1688156093;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nTJ77IxJoCf3R6qu07kat3hn+MjqbGQgNapLEu9GtEI=;
        b=G1qkQQhS2pcwLC3bKdQIROoPWU7ZGguyYZfyYa+RjotPNrBM4X9qQdIZZROo/CGN5I
         G0RJYjfMEdoAv6ZiGFrB/UUcTXVMJlhjkgHKNl0s1+iHT4lHkAA+4zco1FtjYvDI8spd
         ql1zukGsrgYFq75uYcJnw4UYGELKbVAFI0W7O5VPQs64iHQsf+pkX9Ne3FfW6zy7Q9lQ
         vpA9e70fWSnA0KUScfa8EWhBp07BFkbo7blMbDeB3Sojs5H7aeiCx2/O4QmTwmjDVxLd
         +OioRW1wUQRw5P7SkOjHyDP1vjNJquxwNQcd26fQEXDB6w4CdySIQxnbtOplPorXFQt6
         dJsw==
X-Gm-Message-State: AC+VfDx5e1wfeqt34dzLwHcOWavoJMXG/oRtpw/sh54dI+iJ9JULkDa6
	8Yil2Tb7frBEONr/MJNe7MXTpOnkcXFKoZpkEHS1D0/4C2A7SgQbwPCKa6tu3dJmJ9GpbB46n6q
	YDjhEnceBo4PisFH7
X-Received: by 2002:a05:600c:2187:b0:3f6:15c:96fc with SMTP id e7-20020a05600c218700b003f6015c96fcmr241483wme.17.1685564093249;
        Wed, 31 May 2023 13:14:53 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5+R0GqxjLbGqYKkiI0OmLEj0ylpNNXiOUNparec4Ek/XM684Cdlf1oXcU19RgnhhawQ/X+9w==
X-Received: by 2002:a05:600c:2187:b0:3f6:15c:96fc with SMTP id e7-20020a05600c218700b003f6015c96fcmr241479wme.17.1685564092987;
        Wed, 31 May 2023 13:14:52 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id m19-20020a7bcb93000000b003f605566610sm25488288wmi.13.2023.05.31.13.14.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 May 2023 13:14:52 -0700 (PDT)
Message-ID: <3b823b3a-16cf-058e-61cd-f02da2614314@redhat.com>
Date: Wed, 31 May 2023 22:14:51 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH 3/6] arm: pmu: Add extra DSB barriers in
 the mem_access loop
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: eric.auger.pro@gmail.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 andrew.jones@linux.dev, maz@kernel.org, will@kernel.org,
 oliver.upton@linux.dev, ricarkol@google.com, reijiw@google.com
References: <20230315110725.1215523-1-eric.auger@redhat.com>
 <20230315110725.1215523-4-eric.auger@redhat.com>
 <ZEJkozep6M4EqxPW@monolith.localdoman>
 <48ea7b8f-8bc3-def5-3bfa-e4a1ee41971a@redhat.com>
 <ZEfO8DwsseerTKfK@monolith.localdoman>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <ZEfO8DwsseerTKfK@monolith.localdoman>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Alexandru,
On 4/25/23 15:00, Alexandru Elisei wrote:
> Hi,
>
> On Mon, Apr 24, 2023 at 10:11:11PM +0200, Eric Auger wrote:
>> Hi Alexandru,
>>
>> On 4/21/23 12:25, Alexandru Elisei wrote:
>>> Hi,
>>>
>>> On Wed, Mar 15, 2023 at 12:07:22PM +0100, Eric Auger wrote:
>>>> The mem access loop currently features ISB barriers only. However
>>>> the mem_access loop counts the number of accesses to memory. ISB
>>>> do not garantee the PE cannot reorder memory access. Let's
>>>> add a DSB ISH before the write to PMCR_EL0 that enables the PMU
>>>> and after the last iteration, before disabling the PMU.
>>>>
>>>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>>> Suggested-by: Alexandru Elisei <alexandru.elisei@arm.com>
>>>>
>>>> ---
>>>>
>>>> This was discussed in https://lore.kernel.org/all/YzxmHpV2rpfaUdWi@monolith.localdoman/
>>>> ---
>>>>  arm/pmu.c | 2 ++
>>>>  1 file changed, 2 insertions(+)
>>>>
>>>> diff --git a/arm/pmu.c b/arm/pmu.c
>>>> index b88366a8..dde399e2 100644
>>>> --- a/arm/pmu.c
>>>> +++ b/arm/pmu.c
>>>> @@ -301,6 +301,7 @@ static void mem_access_loop(void *addr, long loop, uint32_t pmcr)
>>>>  {
>>>>  	uint64_t pmcr64 = pmcr;
>>>>  asm volatile(
>>>> +	"       dsb     ish\n"
>>> I think it might still be possible to reorder memory accesses which are
>>> part of the loop after the DSB above and before the PMU is enabled below.
>>> But the DSB above is needed to make sure previous memory accesses, which
>>> shouldn't be counted as part of the loop, are completed.
>>>
>>> I would put another DSB after the ISB which enables the PMU, that way all
>>> memory accesses are neatly sandwitches between two DSBs.
>>>
>>> Having 3 DSBs might look like overdoing it, but I reason it to be correct.
>>> What do you think?
>> I need more time to investigate this. I will come back to you next week
>> as I am OoO this week. Sorry for the inconvenience.
> That's fine, I'm swamped too with other things, so don't expect a quick reply
> :)

My apologies for following up so late. I took your suggestion into
account and added this new DSB.

Thanks

Eric
>
> Thanks,
> Alex
>
>> Thank you for the review!
>>
>> Eric
>>> Thanks,
>>> Alex
>>>
>>>>  	"       msr     pmcr_el0, %[pmcr]\n"
>>>>  	"       isb\n"
>>>>  	"       mov     x10, %[loop]\n"
>>>> @@ -308,6 +309,7 @@ asm volatile(
>>>>  	"       ldr	x9, [%[addr]]\n"
>>>>  	"       cmp     x10, #0x0\n"
>>>>  	"       b.gt    1b\n"
>>>> +	"       dsb     ish\n"
>>>>  	"       msr     pmcr_el0, xzr\n"
>>>>  	"       isb\n"
>>>>  	:
>>>> -- 
>>>> 2.38.1
>>>>
>>>>

