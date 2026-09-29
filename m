Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4481F50C2B8
	for <kvmarm@lists.linux.dev>; Tue, 29 Sep 2026 10:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790677831; cv=none; b=cMpOaEvsnAo+Wd/d2/3G8a04GF4TQDoBxTkRriISpseow7g1kHYFW4OreCH8Tq+Q9BWB9QWYakhyyDAbDJ7Z/6f8nHKL3ow4zhePBYsjp6IjT4k+lPx3G325CNoxY53TYKYNLfWCsF8t/646VEZTIrLFF+4IelNMpFmL9RtFjzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790677831; c=relaxed/simple;
	bh=DntTCIUQ0j7NgeaLTznwteean8OpyslV/Zs4s5i2tdw=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=MCeLK3hjIDsvWWk8z32+LR+5hkXOpkH3eQMreK1EMzw6gK8giERT4dfj3sWXix71Mq91QBo5ilZTpSxnO4JI8DceHc2ozknXr+/t2d0y2PsWqnOooGj9YznhyUjbnBgoBCSmODf33rZMPKenuSz64efagEJdCVHD1Ny7jE7let8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=oQDMyzVG; arc=none smtp.client-ip=113.46.200.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="oQDMyzVG"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=EkLqdPxdSLJ7raVGNPbHVI/2jD90kTakfFHeUisjhwo=;
	b=oQDMyzVG0KUbNXrlQWQVUUgqlaxkHcIvP0UyRXSYha/jMxqpVXzhuX7JzocEF+KHQ8CFuZWfQ
	RVkrmt5LsNqvHKSsgtLnndDZqHoZkw0pdq20Iamax3CgIsFWe1TahupnpVNy6Uctf2+KKGlgdsJ
	lnasTD8Tzgck/G26vQR3kaw=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4hvDdv3WJpz1T4dr;
	Tue, 29 Sep 2026 18:18:11 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id 924A140537;
	Tue, 29 Sep 2026 18:30:11 +0800 (CST)
Received: from [10.67.120.103] (10.67.120.103) by
 kwepemr100010.china.huawei.com (7.202.195.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 29 Sep 2026 18:30:10 +0800
Message-ID: <10e3784d-fcb0-4d61-b9e1-27a0ad5c9113@huawei.com>
Date: Tue, 29 Sep 2026 18:30:10 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/5] KVM: arm64: pgtables: Change write bit from
 S2AP_W to DBM
To: Leonardo Bras <leo.bras@arm.com>
CC: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>, Fuad
 Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, Steffen Eiden
	<seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
	<yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, Will
 Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Raghavendra
 Rao Ananta <rananta@google.com>, <linux-arm-kernel@lists.infradead.org>,
	<kvmarm@lists.linux.dev>, <linux-kernel@vger.kernel.org>
References: <20260901171558.2674031-1-leo.bras@arm.com>
 <20260901171558.2674031-2-leo.bras@arm.com> <86bja17cg7.wl-maz@kernel.org>
 <aql8jY4o8SzjJuFU@LeoBrasDK> <aqnku2TcFzIKhjQl@kernel.org>
 <aqp73SxO78o7LJTs@LeoBrasDK>
 <eb629070-a02f-426a-92ee-b2c8f9e2aa9a@huawei.com>
 <arE8EOPh1-NWtFIU@LeoBrasDK>
From: Tian Zheng <zhengtian10@huawei.com>
In-Reply-To: <arE8EOPh1-NWtFIU@LeoBrasDK>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemr100010.china.huawei.com (7.202.195.125)



On 9/21/2026 10:15 PM, Leonardo Bras wrote:
> On Fri, Sep 18, 2026 at 05:39:17PM +0800, Tian Zheng wrote:
>>
>>
>> On 9/16/2026 7:22 PM, Leonardo Bras wrote:
>>> On Tue, Sep 15, 2026 at 05:37:15PM -0700, Oliver Upton wrote:
>>>> On Tue, Sep 15, 2026 at 06:12:45PM +0100, Leonardo Bras wrote:
>>>>>> Yes, the HW should ignore it. But we have also
>>>>>> seen quite a few broken designs in this area...
>>>>>>
>>>>>
>>>>> I lack experience on what bad thing could happen. So I will expand on what
>>>>> I belive to understand up to here:
>>>>>
>>>>> - The PTE is in memory, so the DBM bit can be set regardless of being RES0
>>>>> - For SW pagetable walking, I don't think 'bit 51 == 0' is checked
>>>>> - For HW pagetable walking, maybe some faulty implementation may rely on
>>>>>     bit51 being RES0, and fault otherwise.
>>>>>
>>>>> If that's the case, then we would have to actually support both encodings,
>>>>> and only enable the new one if HAFDBS is available in the system.
>>>>>
>>>>> I just wonder how high are the chances to have such a broken design,
>>>>> or other broken designs did not come to my mind, and if we have to start
>>>>> with that multiple-encoding option.
>>>>
>>>> FWIW, the host stage-1 already uses the DBM bit unconditionally,
>>>> treating it as a software bit on implementations without HAFDBS.
>>>> Although given the quality of any garden variety Arm MMU I understand
>>>> where Marc is coming from.
>>>>
>>>> I don't think the HAFDBS enablement is complicated enough to be done in
>>>> a separate series without any meaningful users, nor would I really be
>>>> interested in taking it without, say, HDBSS.
>>>>
>>>> Can you please work with Tian to get a combined series out for this?
>>>>
>>>
>>> Hi Oliver, thanks for reviewing!
>>>
>>> Sure, one of the reasons I sent like this is so Tian could use it as a base
>>> for his next version.
>>>
>>>
>>
>> Hi Oliver, Leo,
>>
>> Works for us. I plan to send HDBSS v5 maybe next week with this series
>> merged in. Both dirty-tracking consumers are already built on top of the
>> DBM approach: dirty ring and dirty bitmap.
>>
>> Leo, with your blessing, I'd like to pick patches 1-4 into the HDBSS
>> tree with your Signed-off-by preserved and mine added on top, plus some
>> bug fixes on top of this RFC series.
> 
> Yeah, no problem on my side. I would just observe the maintainers' comments
> on those before merging them.
> 

All right, thanks.

Tian

>>
>> For patch 5, I'd like to rework it into a derived hardware dirty mode
>> that replaces both kvm_set_hafdbs() and our earlier HDBSS enable/disable
>> hooks, so the whole thing lands as one series.
>>
> 
> My intention when I wrote that patch was to add a base so you could add
> HDBSS on kvm_arch_commit_memory_region() with new patch such as:
> 
> 	/* Disable HAFDBS when dirty-logging starts */
> 	if (kvm_supports_hafdbs(kvm))
> 		kvm_set_hafdbs(kvm, 0);
> +	else
> +		kvm_enable_hdbss(kvm);
> ...
> 
> 	/* If dirty-logging was canceled, set HAFDBS back on */
> 	if (kvm_supports_hafdbs(kvm) &&
> 	    atomic_read(&kvm->nr_memslots_dirty_logging) == 0)
> 		kvm_set_hafdbs(kvm, 1);
> +	else
> +		kvm_disable_hdbss(kvm);
> 
> 
> That being said, I need to run tests to make sure the usage of HAFDBS
> outside of dirty_tracking makes any sense in terms of performance, but if
> that's not the case, it would be fine to rework it so it does not
> enable/disable HAFDBS there.
> 
>> Performance looks good in both dirty ring and dirty bitmap scenarios so
>> far.
>>
> 
> Awesome!
> 
> Thanks!
> Leo
> 

