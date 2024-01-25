Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EA681EF1F
	for <kvmarm@lists.linux.dev>; Thu, 25 Jan 2024 13:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706189209; cv=none; b=MZ6CmjFxBsbwy1ghspNWA7vPR2v01N3giAjGoS5BTWbEHHm+8wLQ6zBilyFpNT3Z+1vnZKsK8cEZCTZ6InLJJ5cDo5Ns4YkH1wSNm4QEuL0txZPUXZxWQKVRyC1r/DUiGDkwegiDh7yW2ONv46vrwJsThDPys2ll7dxK5XCu/Ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706189209; c=relaxed/simple;
	bh=6aRyImlj4ycKsBHnQ12//RVsPX0PTtNmLuHIWsmV5mI=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=qyTUnUR0s2LFKTOH3RqiO48NKMc4fAMyrTvMMn0flSd1iU0cEDzh+ZFTwSDVOrztU5a0iD0eDtHul/1WPKI84725W2JgtI8sLQ1B7JD5Kq3wpGAWDBq3QN0JnoXK+EH0ew+j8iQ70y8ADsgQIl+QIl0Ye/MWaXphgzvH6dFgJgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4TLM5P4qbRzXghn;
	Thu, 25 Jan 2024 21:25:29 +0800 (CST)
Received: from kwepemm600007.china.huawei.com (unknown [7.193.23.208])
	by mail.maildlp.com (Postfix) with ESMTPS id 9D1A518005C;
	Thu, 25 Jan 2024 21:26:43 +0800 (CST)
Received: from [10.174.185.210] (10.174.185.210) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 25 Jan 2024 21:26:42 +0800
Subject: Re: [bug report] GICv4.1: doorbell interrupts will be lost in a
 corner case
To: Marc Zyngier <maz@kernel.org>
CC: Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
	moderated for non-subscribers <linux-arm-kernel@lists.infradead.org>,
	<kvmarm@lists.linux.dev>, "wanghaibin.wang@huawei.com"
	<wanghaibin.wang@huawei.com>
References: <4edc4d02-5c0b-a2e5-897a-7e60fbb0f3e3@huawei.com>
 <86cytq9a0r.wl-maz@kernel.org>
From: Kunkun Jiang <jiangkunkun@huawei.com>
Message-ID: <a5d9cdc1-cfc4-b6d9-ceb8-a9c2db55384c@huawei.com>
Date: Thu, 25 Jan 2024 21:26:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <86cytq9a0r.wl-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600007.china.huawei.com (7.193.23.208)

Hi Marc,

On 2024/1/24 20:43, Marc Zyngier wrote:
> On Wed, 24 Jan 2024 08:54:24 +0000,
> Kunkun Jiang <jiangkunkun@huawei.com> wrote:
>> Hi all，
>>
>> In chapter 8.5 ("Doorbells") of the GIC spec, the affinity of
>> doorbell interrupt is described like this:
>>
>>> Doorbell interrupts target the Redistributor the vPE is
>>> currently mapped to, based on the previous VMAPP or VMOVP
>>> command for the vPE.
>> The doorbell interrupt here should refer to all types of
>> doorbell interrupt, right?
> There is only one type of doorbell.
>
>> When GICv4.1 is enabled, the doorbell interrupt will be
>> truned on only when kvm handles WFI exit. There is a
>> corner case where will lost doorbell interrupt:
>> 1. doorbell interrupt enabled
>> 2. the cpu which the vPE is mapped to is manually offline
>>    through 'echo 0 > /sys/device/system/cpu/cpuX/online'
>> 3. According to the description of chapter 8.5 ("Doorbells"),
>>    the doorbell interrupt coming at this time will still
>>    be sent to the offline cpu.Then the interrupt will be
>>    lost.
>>
>> Should we add a cpu offline callback to handle the
>> doorbell interrupt mapped to this cpu?
> That seems gross. The right way to do it is to track the affinity of
> the doorbell (which we already do), and let the core code move the
> interrupt somewhere else in this case (which is should already do).
>
> Have you actually witnessed this issue? Or is that just idle
> conjecture?
When cpu offline, all interrupts will be migrated through
irq_migrate_all_off_this_cpu.The doorbell interrupts will
also try to move to other cpu via VMOVP in
its_vpe_set_affinity.

However, according to the current implementation, GICv4.1
allows us to skip VMOVP if moving to a cpu whose RD is
sharing its VPE table with the current one. And I have
verified this:
0. Each cpu die shares a VPE table and contains 32 CPUs
   die0(CPU0-31) die1(CPU32-63)...
1. Enable GICv4.1
2. Create a 1U VM and bind the vcpu to CPU32, doorbell
   affinity to CPU32
3. Bind the vcpu to CPU16, doorbell affinity to CPU16
3. Manually offline CPU16 on the host side.
   echo 0 > /sys/devices/system/cpu/cpu16/online
4. VMOVP will be skipped.
   (The doorbell is migrated to CPU0 by default.)

Looking forward to your reply.

Kunkun Jiang
