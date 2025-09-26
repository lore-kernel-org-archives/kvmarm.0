Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26118272814
	for <kvmarm@lists.linux.dev>; Fri, 26 Sep 2025 11:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758886097; cv=none; b=aSJU9RT5yuLuev3XVn4McyfTxAvSJKLvcxdg7RcmNGM7LkS8hM+DmNE4SlOlZK9dkZ5HR6zYet/FPibUvo7DT1ce5IJQTddfN/nh3Jux+sHYUyNsCTy7dJIZ7aYN+wnPe3CVxL7rA4UxBDm78fkq/8thqqoGuEAJccokDAdw4To=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758886097; c=relaxed/simple;
	bh=iH2Mk5EYcSufiuPrsYsiNX/5GAr8NvOuTM6FZJQNSMs=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=mBISfrI6LCNzikkqiPH1/fPCmPrR8Mz6ES15W4o++JHB1vzigk8e5vJ1lQpBhtQBtP2y7e42CB2fm57Uk8SLWhUsOU1KmrO4H8ULv3R74ZEmkaN9AL2lqDvytA1PJvBkdXYhCh7Pp1BhvSjKBp93RAOPmhvuiz3VuTNFwvxhnIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4cY7Xk0gyvz1R9XG;
	Fri, 26 Sep 2025 19:24:54 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id E613A1A016C;
	Fri, 26 Sep 2025 19:28:03 +0800 (CST)
Received: from kwepemq200004.china.huawei.com (7.202.195.237) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 26 Sep 2025 19:28:03 +0800
Received: from [10.67.121.115] (10.67.121.115) by
 kwepemq200004.china.huawei.com (7.202.195.237) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 26 Sep 2025 19:28:03 +0800
Message-ID: <d7027fe7-01fc-d72f-078b-ed28564a413f@hisilicon.com>
Date: Fri, 26 Sep 2025 19:28:02 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v2 0/4] Add workaround for HIP10/HIP10C erratum 162200802
Content-Language: en-US
To: Marc Zyngier <maz@kernel.org>
CC: <kvmarm@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>,
	<oliver.upton@linux.dev>, <tangnianyao@huawei.com>, <wangwudi@hisilicon.com>,
	<liuyonglong@huawei.com>, <prime.zeng@hisilicon.com>
References: <20250825023954.3516381-1-wangzhou1@hisilicon.com>
 <fc7763d5-bed6-ace6-ace8-a50c031cab36@hisilicon.com>
 <87wm5uxwvc.wl-maz@kernel.org>
 <3d518b64-d66b-ca1e-0893-5b1f0faa17ee@hisilicon.com>
 <861pnt1tgt.wl-maz@kernel.org>
From: Zhou Wang <wangzhou1@hisilicon.com>
In-Reply-To: <861pnt1tgt.wl-maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemq200004.china.huawei.com (7.202.195.237)

On 2025/9/26 16:57, Marc Zyngier wrote:
> On Fri, 26 Sep 2025 08:15:16 +0100,
> Zhou Wang <wangzhou1@hisilicon.com> wrote:
>>
>> On 2025/9/19 23:52, Marc Zyngier wrote:
>>> On Mon, 01 Sep 2025 11:55:49 +0100,
>>> Zhou Wang <wangzhou1@hisilicon.com> wrote:
>>>>
>>>> On 2025/8/25 10:39, Zhou Wang wrote:
>>>>> As the discussion from V1 series, V2 series firstly adds GICD.num_LPIs
>>>>> writable support, then add HiSilicon erratum 162200802.
>>>>>
>>>>> Erratum number should be 162200802, make a mistake in V1, so fix it as
>>>>> well.
>>>>>
>>>>> Zhou Wang (4):
>>>>>   KVM: arm64: Allow userspace to write GICD_TYPER.num_LPIs
>>>>>   KVM: arm64: selftests: Add test for GICD.num_LPIs
>>>>>   Documentation: KVM: arm64: Add GICD_TYPER.num_LPIs writable
>>>>>     description
>>>>>   ARM64: errata: Add workaround for HIP10/HIP10C erratum 162200802
>>>>
>>>> Hi Marc and Oliver,
>>>>
>>>> As the discussion in V1 series, this series firstly adds GICD.num_LPIs
>>>> writable support, then add erratum patch.
>>>
>>> Given the state of this HW (as per [1]), I'd rather we start by
>>> working out the strategy at the GIC level, rather than exposing stuff
>>> to userspace before we agree on a way to make it work in the kernel.
>>
>> This bug is in GICv4.0([1] is in GICv4.1), and seems having a clear way
>> to fix. How about merging this fix firstly, then continue to try to solve [1]?
> 
> No. It has to be worked out the other way around, because this is
> introducing a new userspace ABI, and adding new ABIs to cope with
> design bugs is not really acceptable, specially when you have a
> perfectly good way to deal with the issue (don't enable GICv4).
> 
> I also don't understand your 4.0 vs 4.1 point. This is for HIP10 and
> HIP10C. [1] clearly says that both HIP9/10/10C are GICv4.1
> implementations. So what is what here?

HIP09/10/10C support both 4.0 and 4.1, which could be selected by a BIOS
switch.

> 
> I'm mildly annoyed at being spoon-fed bits of errata with
> contradicting statements instead of being given the full picture for
> what looks like an implementation train-wreck. From what I can see,
> these implementations are broken, and not worth salvaging. There is a
> perfectly valid workaround that keeps VMs running without any extra
> change. Why can't you simply use that?
> 
> Thanks,
> 
> 	M.
> 
> [1] https://lore.kernel.org/r/20250909110615.129179-1-wangzhou1@hisilicon.com
> 
