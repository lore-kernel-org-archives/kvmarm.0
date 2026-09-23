Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39F9345C6E9
	for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 07:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790150282; cv=none; b=qZmtNkh0BwdY/AlK9xAIoP+He+BHWL6/u382EZSjEXqHvSGyffDO3MQcWbE7ysqmEFCRBQWzqNgoJpDwmivsOym04BspokRl7MNkOPcNCWq6cOXhtMZlPOBdBFByA19ZP0GDwR0eFDjU3Kuyeq1aH7xTkUn1e3LHjuB5UCS+gq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790150282; c=relaxed/simple;
	bh=F/xUFkJvmLxfYiU4hY5D9bGAeBitPds/5LbK8elM1nE=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:CC:References:
	 In-Reply-To:Content-Type; b=josSrd4sMnnSKUjg63ERKd4lfb48q//p3vM65dJ8FZG3mzFSrxerVlS+GrzG7T9kE22lY75FXwCzOCJ2PFpo0o2LXw3TLFdZpLPqm+u8j4eoXa1mb9C7m0PV0j9sm1I8D/EJ7gZIy2JhiEBuQFGcupcAn8jcLfyv9gs1KenddoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=g+WmWdQv; arc=none smtp.client-ip=113.46.200.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="g+WmWdQv"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=/YHAq84eIsnUQBlwdqCYIzHZKGq0Ac3NhMXy9IeqxAA=;
	b=g+WmWdQv34ML57rPaosxhODhg//6wGbyYSSxXKMW/k0puhS/BDTaqSKfB+lsGJzlA6/XyThA8
	qF2zCQF4qbNZsDmZ62ZoY2DfB2hGnQZZUrwnYMVHsR+CQOIn3o2CtAtb3zOZXbY0S7C34xRPE42
	IqVqoMkgb57QqLwSSIpwAf0=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4hqTYq22trz12LFc;
	Wed, 23 Sep 2026 15:46:39 +0800 (CST)
Received: from dggpemr200003.china.huawei.com (unknown [7.185.36.25])
	by mail.maildlp.com (Postfix) with ESMTPS id 7C7D340538;
	Wed, 23 Sep 2026 15:57:43 +0800 (CST)
Received: from [10.174.185.234] (10.174.185.234) by
 dggpemr200003.china.huawei.com (7.185.36.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 23 Sep 2026 15:57:42 +0800
Message-ID: <83ffedd4-5912-4a6b-af02-850c556c2fac@huawei.com>
Date: Wed, 23 Sep 2026 15:57:41 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RESEND][PATCH 0/2] Batch register access for live migration
 optimization
From: Yize Wang <wangyize7@huawei.com>
To: Marc Zyngier <maz@kernel.org>
CC: <kvmarm@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <oupton@kernel.org>,
	<catalin.marinas@arm.com>, <will@kernel.org>, <fuad.tabba@linux.dev>,
	<joey.gouly@arm.com>, <seiden@linux.ibm.com>, <suzuki.poulose@arm.com>,
	<yuzenghui@huawei.com>, <mark.rutland@arm.com>, <zhengchuan@huawei.com>,
	<jiangjiacheng@huawei.com>, <yize_w1110@163.com>
References: <20260918081930.4014735-1-wangyize7@huawei.com>
 <861paq69te.wl-maz@kernel.org>
 <68de0ad8-967b-49d4-872a-a9fdff7485fb@huawei.com>
In-Reply-To: <68de0ad8-967b-49d4-872a-a9fdff7485fb@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemr200003.china.huawei.com (7.185.36.25)

kindly ping

在 2026/9/20 20:12, Yize Wang 写道:
>
> 在 2026/9/18 20:08, Marc Zyngier 写道:
>> On Fri, 18 Sep 2026 09:18:13 +0100,
>> Yize Wang <wangyize7@huawei.com> wrote:
>>> This series adds batch register access support to KVM/arm64 to reduce
>>> syscall overhead during VM live migration.
>>>
>>> Currently, QEMU issues one ioctl per register when saving/restoring 
>>> VGIC
>>> state. On large VM configurations this means tens of thousands of 
>>> syscalls,
>>> where lock acquisition and context switch overhead dominates migration
>>> downtime. Thus, we provide a batch register method to allow userspace
>>> read/write multiple distributor and redistributor registers in a 
>>> single call.
>>> In this way, we can significantly reduce syscalls and migration 
>>> downtime.
>>>
>>> Test the VM migration time under pressure conditions.
>>> The VM specifications for migration are as follows:
>>> - VM use 4-K page;
>>> - the number of VCPU is 160;
>>> - the total memory is 320Gigabit;
>>> - use 'Redis SET-benchmark' to pressurize VM;
>>>
>>> Performance results (3-run average, ms):
>>>      | Metric              | Without patch | With patch | Improvement |
>>> |---------------------|---------------|------------|-------------|
>>>      | Migration downtime  |        536    |     321    | 40%     |
>>>      | Source (total)      |        344    |     230    | 33%     |
>>>      |   - VGIC put        |        158    |      40    | 75%     |
>>>      |   - VGIC get        |        120    |      19    | 84%     |
>>>      | Destination (total) |        192    |      91    | 53%     |
>>>      |   - VGIC put        |        132    |      27    | 80%     |
>>>
>>> Yize Wang (2):
>>>    KVM: arm64: Add batch group constant and data structure to UAPI 
>>> header
>>>    KVM: arm64: Add VGIC v3 batch register access implementation
>> Questions:
>>
>> - Why only the MMIO registers?
>>
>> - Why not the sysregs?
>>
>> - Why only the GIC?
>>
>> - Why not all of the state?
>>
>> - Where is the corresponding userspace code?
>>
>> More importantly, since this is about batching system calls:
>>
>> - Why can't this be done with io_uring instead?
>>
>>     M.
>
>
> Hi, Marc! Thank you for the review.
>
>
> These patches focus on optimizing GICv3 register access during live 
> migration. We found that there are a large number of locks (kvm->lock, 
> vcpus, config_lock) in the GIC, these lock operations wil cost large 
> time waste. The batches of sysreg for vcpu optimization will come in 
> follow as a separate series. And let me address these questions one by 
> one.
>
>
> 1. Why only the MMIO registers?
>
> In vgic_v3_batch_access(), we use 'entries' structure to implement 
> batch read/write of register status. The structure is 'struct 
> kvm_dev_arm_vgic_batch_entry', where the group information can be 
> freely specified by userspace. Thus, vgic_v3_batch_access() supports 
> all VGIC device attr groups, not only MMIO registers.
>
>
> 2. Why not the sysregs?
>
> The newly added vgic_v3_batch_access() just forwards the groups 
> received fromQEMU in batches to 'vgic_v3_attr_regs_access()'. And this 
> function already has 'KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS' to handle 
> sysregs. Our patch does not modify the existing sysreg handling logic.
>
>
> 3. Why only the GIC?
>
> During live migration, the GIC is the device with the largest number 
> of registers, and we found that there are a large number of locks in 
> it. If each register is locked and unlocked individually, it would 
> cause large time consumption. Thus, we want to optimize the GIC 
> register time consumption during live migrate. The experimental 
> results also show that batch processing significantly reduces VGIC 
> handling time during migration.
>
> Similarly, vCPU register save/restore also costs significantly time. 
> The patch of vCPU sysreg batch access will be submitted separately in 
> the future.
>
>
> 4. Why not all of the state?
>
> As different devices have different lock hierarchies and access 
> paths(e.g., GIC goes through the device fd, CPU regs go through the 
> vcpu fd), it's difficult for us to realize in a single batch handler. 
> Additionally, introducing too many changes at once would make review 
> harder. These patches focus on GIC-related optimization, and a 
> separate series for vCPU batch processing will follow.
>
>
> 5. Where is the corresponding userspace code?
>
> The QEMU-side implementation has been posted to qemu-devel. The link 
> is below:
>
> https://lore.kernel.org/qemu-devel/20260918092120.370805-1-wangyize7@huawei.com/T/#t 
>
>
>
> 6. Why can't this be done with io_uring instead?
>
> The core idea of io_uring is to reduce the number of context switches 
> between user space and kernel space by utilizing two ring buffers. 
> However, each SQE is still processed independently in kernel space. 
> For the VGIC registers, each SQE still require lock -> read/write -> 
> unlock, so the per-register lock overhead remains unchanged. We hope 
> to read/write a set of register states with a single lock operation to 
> reduce the time cost. Therefore, io_uring does not meet our needs.
