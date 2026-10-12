Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7698741A921
	for <kvmarm@lists.linux.dev>; Mon, 12 Oct 2026 11:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791803096; cv=none; b=T13E7jmjRESzis79OGZ6/S55kUHrU6/5Y49sFNeXC0c/uqYaz3ZB3UmMdvnjPo5diGdS0YWB6mVDURwiu2fvwQmQSGxIQ68QOK/e+BFDNOfVNCIvZw2LVVC6Xmr79KbKBo0F10F8ISWDQO7FOdZfZ1aLlib0TpbB04Bw2bLTOYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791803096; c=relaxed/simple;
	bh=Cntu8oydZe03qON8GryQkxB1KO+5pPFV3rgXmrRfFaQ=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:CC:References:
	 In-Reply-To:Content-Type; b=Rrf93OJ6NBbvRt0OWcZlv46WSku8mhg5mqta/tWYmwJdeL57PrCPZB4l5zYt2g5u/ti2zV0oNzcE91oSa6bdaijIybu9rqDUF/2dWqg4nqMqf1sq2BaJsZLQS10ICl9z+PlvYDzXz6TATV8lx7ABrFYbdZt5GN0iBo0zrMZzisw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=t+B+sJs8; arc=none smtp.client-ip=113.46.200.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="t+B+sJs8"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=6iGDId3KBgK0IM1Sb2lP0rsPu/sGEUwNU7C75TQ+NnQ=;
	b=t+B+sJs8gGXBn4HhheHU+yhFK044D8088DXFCuJaCVEvxTSwEbyL/8/+VhF7EUqNa77vrz8G0
	XlDciYLuXS0XJNLydxU50IPMkQvOFk4mW0Pkv6vhlYlUkyIrD88WnQmhIZxxK77b90aPyCh3UKi
	h+aUKXjROC+sUvNGR1TfwdM=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4j3DnD4x1jzpStW;
	Mon, 12 Oct 2026 18:52:16 +0800 (CST)
Received: from dggpemr200003.china.huawei.com (unknown [7.185.36.25])
	by mail.maildlp.com (Postfix) with ESMTPS id 81E8B4057D;
	Mon, 12 Oct 2026 19:04:48 +0800 (CST)
Received: from [10.174.185.234] (10.174.185.234) by
 dggpemr200003.china.huawei.com (7.185.36.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Mon, 12 Oct 2026 19:04:47 +0800
Message-ID: <d4487bbb-ff89-4604-82b4-13a4a92067d8@huawei.com>
Date: Mon, 12 Oct 2026 19:04:46 +0800
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
	<linux-kernel@vger.kernel.org>, <catalin.marinas@arm.com>, <will@kernel.org>,
	<fuad.tabba@linux.dev>, <joey.gouly@arm.com>, <seiden@linux.ibm.com>,
	<suzuki.poulose@arm.com>, <yuzenghui@huawei.com>, <mark.rutland@arm.com>,
	<zhengchuan@huawei.com>, <jiangjiacheng@huawei.com>, <yize_w1110@163.com>
References: <20260918081930.4014735-1-wangyize7@huawei.com>
 <861paq69te.wl-maz@kernel.org>
 <f70c6fe3-e3c5-4912-b4bb-8a418fec4346@huawei.com>
 <86ece63kes.wl-maz@kernel.org>
 <6890def8-168d-4951-b6bd-bcbbcbf3595a@huawei.com>
In-Reply-To: <6890def8-168d-4951-b6bd-bcbbcbf3595a@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemr200003.china.huawei.com (7.185.36.25)

Kindly Ping

在 2026/10/8 20:50, Yize Wang 写道:
>
> 在 2026/10/3 22:53, Marc Zyngier 写道:
>> On Sun, 20 Sep 2026 10:15:25 +0100,
>> Yize Wang <wangyize7@huawei.com> wrote:
>>> 在 2026/9/18 20:08, Marc Zyngier 写道:
>>>> On Fri, 18 Sep 2026 09:18:13 +0100,
>>>> Yize Wang<wangyize7@huawei.com> wrote:
>>>>> This series adds batch register access support to KVM/arm64 to reduce
>>>>> syscall overhead during VM live migration.
>>>>>
>>>>> Currently, QEMU issues one ioctl per register when 
>>>>> saving/restoring VGIC
>>>>> state. On large VM configurations this means tens of thousands of 
>>>>> syscalls,
>>>>> where lock acquisition and context switch overhead dominates 
>>>>> migration
>>>>> downtime. Thus, we provide a batch register method to allow userspace
>>>>> read/write multiple distributor and redistributor registers in a 
>>>>> single call.
>>>>> In this way, we can significantly reduce syscalls and migration 
>>>>> downtime.
>>>>>
>>>>> Test the VM migration time under pressure conditions.
>>>>> The VM specifications for migration are as follows:
>>>>> - VM use 4-K page;
>>>>> - the number of VCPU is 160;
>>>>> - the total memory is 320Gigabit;
>>>>> - use 'Redis SET-benchmark' to pressurize VM;
>>>>>
>>>>> Performance results (3-run average, ms):
>>>>>       | Metric              | Without patch | With patch | 
>>>>> Improvement |
>>>>> |---------------------|---------------|------------|-------------|
>>>>>       | Migration downtime  |        536    |     321 |     40%     |
>>>>>       | Source (total)      |        344    |     230 |     33%     |
>>>>>       |   - VGIC put        |        158    |      40 |     75%     |
>>>>>       |   - VGIC get        |        120    |      19 |     84%     |
>>>>>       | Destination (total) |        192    |      91 |     53%     |
>>>>>       |   - VGIC put        |        132    |      27 |     80%     |
>>>>>
>>>>> Yize Wang (2):
>>>>>     KVM: arm64: Add batch group constant and data structure to 
>>>>> UAPI header
>>>>>     KVM: arm64: Add VGIC v3 batch register access implementation
>>>> Questions:
>>>>
>>>> - Why only the MMIO registers?
>>>>
>>>> - Why not the sysregs?
>>>>
>>>> - Why only the GIC?
>>>>
>>>> - Why not all of the state?
>>>>
>>>> - Where is the corresponding userspace code?
>>>>
>>>> More importantly, since this is about batching system calls:
>>>>
>>>> - Why can't this be done with io_uring instead?
>>>>
>>>>     M.
>>>
>>> Hi, Marc! Thank you for the review.
>>>
>>>    These patches focus on optimizing GICv3 register access during live
>>> migration. We found that there are a large number of locks (kvm->lock,
>>> vcpus, config_lock) in the GIC, these lock operations wil cost large
>>> time waste. The batches of sysreg for vcpu optimization will come in
>>> follow as a separate series. And let me address these questions one by
>>> one.
>> All these locks should be non-blocking by the time you save anything
>> related to the GIC, because:
>>
>> - none of the vcpu can be running
>>
>> - this must be a single threaded operation
>>
>> So if you are seeing anything contended, this is either the sign of a
>> bad KVM bug, or an indication that you are violating the above
>> requirements.
>>
>>     M.
>
>
> Hi, Marc! Thanks for your review.
>
> You are right that when saving the GIC state during live migration 
> process, all vCPUs are not running and it is a single threaded 
> operation. Our patches process the packaged register states from the 
> userspace under the same lock. These operations only aim to reduce the 
> lock opreation downtime and do not involve lock contention.
>
> In addition, these patches focus on reducing the syscalls of ioctl. 
> Now, every register requires an ioctl, resulting in (num_cpu * 
> registers_per_cpu) system calls. This will cost lots of time during 
> the large-scale VM  migration. Our patches batch registers by category 
> in qemu and then send them to kernel in batches. This operations 
> significantly reduce the number of ioctl syscalls and save a great 
> amount of downtime.
>
> The comparison is as follow:
> BEFORE:
>
>        QEMU (Userspace)                  Kernel (Kernelspace)
>   +------------------------+        +----------------------------+
>   |                        |        |                            |
>   |  kvm_arm_gicv3_get()   |        |  vgic_v3_attr_regs_access  |
>   |                        |        |                            |
>   |  for ncpu in num_cpu:  |        |                            |
>   |    for each register:  |        |                            |
>   |                        |        |                            |
>   |  GICR_CTLR             | ioctl->| mutex_lock(&kvm->lock)    |
>   |                        |        |  kvm_trylock_all_vcpus     |
>   |                        |        | mutex_lock(&config_lock)  |
>   |                        | <-val  |  read/write register       |
>   |                        |        |  mutex_unlock              |
>   |                        |        |  kvm_unlock_all_vcpus      |
>   |                        |        | mutex_unlock(&kvm->lock)  |
>   |                        |        |                            |
>   |  GICR_STATUSR          | ioctl->|  (repeat lock/read         |
>   |                        | <-val  |   -> unlock)               |
>   |  ...                   |        |                            |
>   |                        |        |                            |
>   |  GICR_WAKER            | ioctl->|  (repeat lock/read         |
>   |                        | <-val  |   -> unlock)               |
>   |  ...                   |        |                            |
>   |                        |        |                            |
>   |  ICC_SRE_EL1           | ioctl->|  (repeat lock/read         |
>   |                        | <-val  |   -> unlock)               |
>   |  ...                   |        |                            |
>   |                        |        |                            |
>   +------------------------+        +----------------------------+
>
>
> AFTER:
>
>        QEMU (Userspace)                  Kernel (Kernelspace)
>   +------------------------+        +----------------------------+
>   |                        |        |                            |
>   |  kvm_arm_gicv3_get()   |        |  vgic_v3_batch_access      |
>   |                        |        |                            |
>   |  Collect Phase:        |        |                            |
>   |    add(GICR_CTLR)      |        |                            |
>   |    add(GICR_STATUSR)   |        |                            |
>   |    add(GICR_WAKER)     |        |                            |
>   |    add(GICR_IGROUPR0)  |        |                            |
>   |    ...                 |        |                            |
>   |    add(ICC_SRE_EL1)    |        |                            |
>   |    ...                 |        |                            |
>   |                        |        |                            |
>   |  Commit Phase:         | BATCH->| copy_from_user            |
>   |    batch_commit()      |        | mutex_lock(&kvm->lock)    |
>   |                        |        |  kvm_trylock_all_vcpus     |
>   |                        |        | mutex_lock(&config_lock)  |
>   |                        |        |                            |
>   |                        |        |  Process Each Entry:       |
>   |                        |        |    entry[0]: GICR_CTLR     |
>   |                        |        |    entry[1]: GICR_STATUSR  |
>   |                        |        |    entry[2]: GICR_WAKER    |
>   |                        |        |    ...                     |
>   |                        |        |    entry[N]: ICC_SRE       |
>   |                        |        |    FLAG_LOCKED: skip       |
>   |                        |        |                            |
>   |  Unpack Phase:         |<-result| mutex_unlock              |
>   |    Write back          |        |  kvm_unlock_all_vcpus      |
>   |    Post-process:       |        | mutex_unlock(&kvm->lock)  |
>   |      unshuffle,split   |        |  copy_to_user              |
>   |                        |        |                            |
>   +------------------------+        +----------------------------+
