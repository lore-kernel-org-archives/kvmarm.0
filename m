Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B2CD24C07A
	for <kvmarm@lists.linux.dev>; Sat, 18 Oct 2025 03:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760757457; cv=none; b=Ra5At65GdKm6m6B+ic9to3U8EaLMBVhTcOzO9TsdkXVIr2mnaCHyhBVVRx0DWF+mJIFv6Yp4+li/7tW3pHkRaxhqm9tthaaZbuiI2+kVwElN2ORskdIoNR3ucPexMwVZ2rzhVL0//Vuh/Bvcdg8AiIebVU0iO8Cdyof/F7YhYAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760757457; c=relaxed/simple;
	bh=3N0cduiKQK/LRs3KE0nIV2g3d2wba9To1du2FFDNakY=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=W8gF8tHyZK64j5yDdwBk+RSSuoFFc3o5gT+CaTztVkW+EOEovXdY/0r+uyNapJvg4I3aJgLeVUG2Sj/qEifQ24PexAhOwGQqyDDoh+LAxHKN6l7sA9VIi/2wSlqQ8wH7W7BH9vPQ9roQPsPrizseKkcWjbNzamtMQyTw9M5f7ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=113.46.200.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4cpRgg4m53z1prPw;
	Sat, 18 Oct 2025 11:17:03 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 0825918048E;
	Sat, 18 Oct 2025 11:17:26 +0800 (CST)
Received: from kwepemq200004.china.huawei.com (7.202.195.237) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 18 Oct 2025 11:17:25 +0800
Received: from [10.67.121.115] (10.67.121.115) by
 kwepemq200004.china.huawei.com (7.202.195.237) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 18 Oct 2025 11:17:25 +0800
Message-ID: <c349eb9f-9f8a-f268-c765-a59c94bf6613@hisilicon.com>
Date: Sat, 18 Oct 2025 11:17:24 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: Question about heterogeneous VM live migration
Content-Language: en-US
To: Marc Zyngier <maz@kernel.org>
CC: <kvmarm@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>
References: <866aca63-1f6b-2109-fa76-6d68cb7c547a@hisilicon.com>
 <86wm4twu3c.wl-maz@kernel.org>
From: Zhou Wang <wangzhou1@hisilicon.com>
In-Reply-To: <86wm4twu3c.wl-maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemq200004.china.huawei.com (7.202.195.237)

On 2025/10/17 21:12, Marc Zyngier wrote:
> On Thu, 16 Oct 2025 03:00:07 +0100,
> Zhou Wang <wangzhou1@hisilicon.com> wrote:
>>
>> Hi,
>>
>> We are now trying to do heterogeneous VM live migration among HiSilicon ARM
>> servers, seems there are problems about disabling a feature in guest.
>>
>> For a feature, if we disable it in VM by configure related ID register field,
>> we should make it actually been disabled, e.g. configure related control
>> register in EL2 or trap EL0/EL1 access to EL2.
> 
> This is in general not possible.
> 
>> Possible problems:
>>
>> 1. Some features can not be disabled actually in EL0/EL1, e.g. FEAT_AFP,
>>    FEAT_RPRES, FEAT_CSSC, FEAT_LRCPC3...
>>
>>    Disabling it by ID can not avoid a stupid user to directly use it without ID
>>    checking, which may bring subtle problem in heterogeneous VM live migration.
> 
> Yes. There is no solution to that.
> 
>> 2. For some features, it can be trapped, but KVM does not support yet. Not sure
>>    if we should support them in future.
>>
>>    E.g. If we disable ID of FEAT_HAFT for guest, we need configure
>>         HCRX_EL2.TCR2En to 0, so access to TCR2_EL1.HAFT will be trapped.
> 
> That's wrong. If you force TCR2EN to 0, none of the TCR2_EL1 controls
> will work. For example, you'd lose the POE/PIE controls.

Yes, it will impact other control bits, same as SCTLR_EL1 trapping mentioned below.

> 
>>         For FEAT_PAN3, it instroduces EPAN to SCTLR_EL1，if we disable ID of
>> 	FEAT_PAN3, we need make SCTLR_EL1 to trap by setting HFGRTR_EL2.SCTLR_EL1.
>>
>>    Seems there are no trap setting in above cases. Just a quick look, maybe I
>>    miss something.
>>
>> I am not sure if we already consider above problems, any help will be appreciated.
> 
> we know about most of these things already. In general, you cannot
> hide features that the host has, other than indicating to the guest
> that they may not exist. The underlying HW is still there and will act
> as expected.
> 
> I think you're simply expecting too much from the architecture.

Many thanks about above explanation, I get the situation now.

Best,
Zhou

> 
> 	M.
> 
