Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.226
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793066581;
	b=eiZyfKsxKJR68oQo/h0jPDvMtxaDKLc8SMBW7jBZMB427Fd5ChrwA/R82E5m0JOr9Ddp
	 2j9TJ71qWGwVN8HGMlxz+5vuyY8viXCeKhklQJrdYDlEJklKUhiHCuTRhRcnhhruNYNjv
	 yzYXUCISiquHlMLGjU7rDarTZU6NiX9tDLluEwVes6CV7O6ar7oHngXuJ04yLPSXL0kmd
	 xa9p6ThsaA1oi+p5754zJxkknQBRXULZHq5chP6Ec30rjcqul/Yr27ME9zwoNfs/Uy0Yb
	 PyoZG1ZzqvLuPgx7HvA6rbF0krw7E7zHlTdR4h3wDjvqDcHbzwbZs2VEPfkTRkDq8NA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793066581;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=KipWeilMX52B1gYtHkbQRemjgyfXjWvytc5K4t2sbXE=;
	b=LyBSvZMJbrbEOcCMzRD9gEEWVtVxkeW6DfMy5efJy2LBwwID4MAN8wiLw7dBY9wUBlHT
	 MJuxry9gC0Ew13azw6oSgi+coDE7Huz4YANIwh37CXb5M42lvFtxzfeFvanglpAfM0dAM
	 Z4NkLTF1jEUrtXJejixfmjuxoArqOC2iUDL4CnjNAmyiu5YHR8RY4NN21yyAHnYzmm7sQ
	 Y5CN37D2fVjSSerwPksMdjR3/zRHOUagyACvtWRyJoKvBah5ljieWjx+Ddt/h+millbR0
	 giQGbfnPJa4UQib/P1Cj1+LjvUlvYVSnQdri7suFCzhLV5LsQ9WedQ2HBUgrAbwoY8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=KmUU8854;
	arc=none smtp.remote-ip=113.46.200.226
Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DEA4606A31B
	for <kvmarm@lists.linux.dev>; Tue, 27 Oct 2026 02:02:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3DEA4606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=KmUU8854
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=KipWeilMX52B1gYtHkbQRemjgyfXjWvytc5K4t2sbXE=;
	b=KmUU8854S8wCXqnOpSChscuWRYL8hKtL/Gkh2RXgXfyPG8lTp1Ju54qjFIyChnvqPJAQOZiKv
	3tXpg7XK/AOjCI1EWCjrMHiRmCLEjXbsnbOKQ1T9nTc5ltosKXc2dZ34Zmd998oz0KNyOUG1I9R
	dhpLuEPjtziuFLWiN8b7XXI=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4jDDKN2h4FzKmXW;
	Tue, 27 Oct 2026 10:02:48 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id 9762E4055B;
	Tue, 27 Oct 2026 10:02:56 +0800 (CST)
Received: from [10.67.120.103] (10.67.120.103) by
 kwepemr100010.china.huawei.com (7.202.195.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 27 Oct 2026 10:02:55 +0800
Message-ID: <8eaaba87-7881-49c4-a76a-51dec2f29ffc@huawei.com>
Date: Tue, 27 Oct 2026 10:02:55 +0800
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 5/5] KVM: arm64: Enable HAFDBS for guests not on
 migration
To: Leonardo Bras <leo.bras@arm.com>, liuyonglong <liuyonglong@huawei.com>
CC: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>, Fuad
 Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, Steffen Eiden
	<seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
	<yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, Will
 Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Raghavendra
 Rao Ananta <rananta@google.com>, <linux-arm-kernel@lists.infradead.org>,
	<kvmarm@lists.linux.dev>, <linux-kernel@vger.kernel.org>
References: <20260901171558.2674031-1-leo.bras@arm.com>
 <20260901171558.2674031-6-leo.bras@arm.com> <aqneWnlsdpocLIl6@kernel.org>
 <aqqhDs3NyjtkZzXK@LeoBrasDK> <aqsl1_IqnV2r8kUL@kernel.org>
 <aqvt2gnlBZeNsaf4@LeoBrasDK> <as-mH36YSMxAosND@LeoBrasDK>
 <3e464bef-8dfe-44a3-afea-3c276ae87cd8@huawei.com>
 <attMtUqxNsuPooix@LeoBrasDK>
From: Tian Zheng <zhengtian10@huawei.com>
In-Reply-To: <attMtUqxNsuPooix@LeoBrasDK>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemr100010.china.huawei.com (7.202.195.125)



On 10/23/2026 8:01 PM, Leonardo Bras wrote:
> On Fri, Oct 23, 2026 at 03:23:04PM +0800, Tian Zheng wrote:
>>
>>
>> On 10/14/2026 11:56 PM, Leonardo Bras wrote:
>>> On Thu, Sep 17, 2026 at 02:40:42PM +0100, Leonardo Bras wrote:
>>>> On Wed, Sep 16, 2026 at 04:27:19PM -0700, Oliver Upton wrote:
>>>>> On Wed, Sep 16, 2026 at 03:00:46PM +0100, Leonardo Bras wrote:
>>>>>> On Tue, Sep 15, 2026 at 05:10:02PM -0700, Oliver Upton wrote:
>>>>>>> Hi,
>>>>>>>
>>>>>>> On Tue, Sep 01, 2026 at 06:15:56PM +0100, Leonardo Bras wrote:
>>>>>>>> When dirty-logging is disabled, even non-write faults make a page dirty,
>>>>>>>> which avoids a second fault when the page is actually written to.
>>>>>>>>
>>>>>>>> On dirty-logging enable, this approach causes all (writable) pages on the
>>>>>>>> memslot to be marked clean, even if they were not written to, which can
>>>>>>>> take a lot of time, while holding the MMU lock, doing atomic writes to
>>>>>>>> PTEs.
>>>>>>>
>>>>>>> Do you have any performance numbers for this? Enabling HAFDBS seems a
>>>>>>> bit involved to avoid some stores on the first pass.
>>>>>>
>>>>>> Not yet, but if the idea does not look too crazy I can find hardware and
>>>>>> collect some data :)
>>>>>
>>>>> TBH this looks like a micro-optimization so I'm not expecting the
>>>>> performance gains to justify the behavior change.
>>>>>
>>>>
>>>> Okay then, I will get a machine to figure the performance gains :)
>>>
>>> Got the performance numbers here.
>>> I tested both the case where all PTEs are dirty, and the case that 50% of
>>> the PTEs are dirty.
>>>
>>> For that test, actually patch #5 could make kvm_pgtable_stage2_wrprotect()
>>> slower, which is counter-intuitive, in all platforms tested:
>>>
>>> When we walk the S2 pagetable to wrprotect, using the new walker, the
>>> write to the PTE itself is so cheap* that the cost of the branch
>>> misprediction (write PTE or not) for the 50/50 case is significantly higher
>>> than the cost of the 50% extra writes, which makes the 50/50 up to 60%
>>> slower than the 100% dirty case. It is still slower in the '25% dirty' as
>>> well, and starts to get even at '10% dirty'.
>>>
>>> * (non-atomic, everything is in order, walker is small, cpu will probably
>>> bundle it all in a single cacheline write)
>>>
>>> Since the idea of patch #5 was to reduce PTE writes in the first wrprotect
>>> walk, it becomes faster only if only a small portion (<10%) of the VM was
>>> write-faulted while the remaining was read-faulted, which seems to be a
>>> really reduced audience.
>>>
>>> Since this comes with increased complexity, and also carry costs of
>>> having HAFDBS itself enabled outside dirty-tracking, I don't think it's a
>>> good idea to further pursue patch #5. It's only value is that it served as
>>> a base for HDBSS implementation.
>>>
>>> Thanks for reading!
>>> Leo
>>>
>> Hi Leo,
>>
>> Thanks for running this, the numbers are really useful.
>>
>> It means the hardware dirty mode (HD=1) should only be enabled while
>> dirty logging is active with HDBSS support, and stays off otherwise.
> 
> Hi Tian,
> 
> Correct, it's actually counter-productive for it to stay on without HDBSS
> before dirty-logging.
> 
>>
>> With HD only enabled during dirty logging, we also keep the DBM-based
>> encoding for the HD=0 case. On systems that support FEAT_HAFDBS, DBM
>> remains the write bit and S2AP[1] the dirty bit even with HD=0. This
>> works because kvm_s2_fault_compute_prot() maps any writable page of a
>> non-tracked memslot writable-dirty (WD), including on read faults:
>>
>> ```c
>> if (s2vi->map_writable) {
>>          *prot |= KVM_PGTABLE_PROT_W;
>>
>>          if (s2vi->device ||
>>              !memslot_is_logging(s2fd->memslot) ||
>>              kvm_is_write_fault(s2fd->vcpu))
>>                  *prot |= KVM_PGTABLE_PROT_DIRTY;
>> }
>> ```
>>
>> So there is no WC entry for hardware to promote, and HD is simply not
>> needed outside dirty logging.
>>
>> In the next HDBSS version, we'll only turn on HD=1 when dirty logging
>> is active.
>>
> 
> Right!
> I will also send a new version of the pre-patch (4 patches) for us to
> discuss. The first 2 patches will change meaning a bit, but should still
> work as they do today.
> 
> Thanks!
> Leo
> 
Hi Leo,

OK, I've seen the new DBM RFC patchset. HDBSS v6 will be based on it.

Thanks,
Tian
