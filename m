Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 297C547605C
	for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 08:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790584248; cv=none; b=sH+j6vv7AL7nbF3zFq+2IxuDM3zM8sqP+5DK9xOIjy03etY3z7qwIwiix9VtptmaqvpsntTreRxtYBq9ACzVY/JfHl7Ne55OJuWyLN2YTvaO8G5CzcjCCHcohYSxEenSBxoaFRONhdkx3JQmbI3usGmREOrjMJA6hipIdXiUzN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790584248; c=relaxed/simple;
	bh=EXOjLPcF+VLIg3vJR9iV1apAo+paTwpRlhGz1p2GyNA=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=TtKawi7T/coujVopzp7TngANNiXTjoN2J3uF38h/e9rKFwd50VLatCZAP4Y22eVyJgbr/La4cVeuin36RATVCN9VI/mr11tUvOA5pBR3ZwzrQPmBF6iNW3oXy1ioeFMBvIMxuB1tSsULTcBLRUk4zFmN7zU+Gu1HucA7Gcvxyfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=113.46.200.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4htZ2C208mz1prn0;
	Mon, 28 Sep 2026 16:18:27 +0800 (CST)
Received: from kwepemk100011.china.huawei.com (unknown [7.202.194.59])
	by mail.maildlp.com (Postfix) with ESMTPS id 650BB40538;
	Mon, 28 Sep 2026 16:30:37 +0800 (CST)
Received: from [10.67.121.115] (10.67.121.115) by
 kwepemk100011.china.huawei.com (7.202.194.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 28 Sep 2026 16:30:36 +0800
Message-ID: <0ed13d49-fd34-ff80-bd07-be9a998e3d76@hisilicon.com>
Date: Mon, 28 Sep 2026 16:30:35 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [RFC PATCH] KVM: arm64: Restrict CNTP_CVAL/CNTHP_CVAL save/reload
 when ptimer is used
Content-Language: en-US
To: Marc Zyngier <maz@kernel.org>
CC: Oliver Upton <oupton@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>, Joey
 Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, Suzuki K
 Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, Catalin
 Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Mark
 Rutland <mark.rutland@arm.com>, <kvmarm@lists.linux.dev>, Nianyao Tang
	<tangnianyao@huawei.com>
References: <20260921111840.3000905-1-wangzhou1@hisilicon.com>
 <878q4u4u3a.wl-maz@kernel.org>
 <6975605e-6635-f3c6-39ee-8faaae6d9856@hisilicon.com>
 <86mrt64jks.wl-maz@kernel.org>
From: Zhou Wang <wangzhou1@hisilicon.com>
In-Reply-To: <86mrt64jks.wl-maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemk100011.china.huawei.com (7.202.194.59)

On 2026/9/25 1:58, Marc Zyngier wrote:
> On Tue, 22 Sep 2026 11:16:36 +0100,
> Zhou Wang <wangzhou1@hisilicon.com> wrote:
>>
>> On 2026/9/21 21:22, Marc Zyngier wrote:
>>> On Mon, 21 Sep 2026 12:18:40 +0100,
>>> Zhou Wang <wangzhou1@hisilicon.com> wrote:
>>>>
>>>> A guest's physical timer may be used in nested guest or directly used in
>>>> VHE mode. We can check above cases to avoid useless CNTP_CVAL/CNTHP_CVAL save
>>>> and reload.
>>>
>>> Why useless? What cases?
>>
>> I mean we do not use ptimer at least in current Linux kernel, however, for system
>> which has ECV_CNTPOFF capability, we have to handle related logic here.
>>
>> So we can detect if ptimer is been used, if it is been used, then we run into the
>> related codes.
> 
> But where is the actual cost? Is it the saving of these registers?
> Something else?

Just save the cost of the codes in has_cntpoff branch in __activate_traps/__deactivate_traps.

From the KUT test results, for VHE in non-nested mode, it will save:
hvc		758ns		624ns		17.68%
mmio_read_user	3647ns		3479ns		4.61%
mmio_read_vgic	949ns		817ns		13.91%
eoi		29ns		29ns		0.00%
ipi		2534ns		2302ns		9.16%
lpi		2684ns		2442ns		9.02%
timer_10ms	2393ns		2168ns		9.40%

I am not sure it deserves a hacking like this patch, key point is that it seems
we rarely use ptimer, but we have to handle it every VM in/exit.

> 
>>
>> I am not familiar with the nested cases, so just not change related logic.
>>
>>>
>>>>
>>>> Use lazy detection to determine whether a non-nested VHE guest actually uses
>>>> the physical timer.
>>>>
>>>> timer_set_traps() initially traps CNTP_CTL_EL0 writes for non-nested guests.
>>>> On the first write that sets CNTP_CTL.ENABLE=1, the trap handler records
>>>> ptimer_used and clears the trap in CNTHCTL_EL2, allowing the guest direct
>>>> access thereafter.
>>>
>>> I really don't want to go into these micro optimisation to paper over
>>> the bad state of the architecture.
>>>
>>> The options are:
>>>
>>> - Don't use any offset (offsets always set to 0), and there will not
>>>   be any trap
>>
>> Do you mean that in non-nested case, we can make offset always be 0, so
>> related logic in __activate_traps/__deactivate_traps can be skipped?
>>
> 
> The *trapping* of the physical timer/counter will be skipped.

Thanks, I saw related trap setting in timer_set_traps.

Best,
Zhou

> 
> 	M.
> 
