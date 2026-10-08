Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCBC44746BB
	for <kvmarm@lists.linux.dev>; Thu,  8 Oct 2026 08:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791448379; cv=none; b=apKAMnED1Us+2we/GmBQTsWw5dYiQAUl20VhzlfWoPHSeIa1nMu8boqmolFPNljS2NbPJQ1raacHL+7p1DEWf8Cg+KpbTwAU7zS3PFxVblqesEZZWdZUm7JVfqNRNtGdL88vDPlCiqKbq8uuCFO1aDd8iBIfGP3t1Gv1j5MlKm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791448379; c=relaxed/simple;
	bh=8oDcxO6R0pIWzs3iz56qAEG2SacddL4pqmEab/tfmOw=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Qtc+6JH/bPcqa01OjgLodMcnIZ+C+3HjrWAul/LHmhuKqXzBfwl1QWVefqN/dn5MQZ4xBRM84Sp/R9//jO5kiYPiA0vKwsUMx4W51cGsx3JvZjywYy06BlMjJs2GNZ4wJAXB6ypmJY65KVBgJktCiLxYaU2x7q39IKy6EHUdIa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=6wBubGHC; arc=none smtp.client-ip=113.46.200.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="6wBubGHC"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=JBqNPMfAHd4kXYVw0IlxjFhPFtYWD0YbSv7I3OmUVeE=;
	b=6wBubGHCcQwyJdjCK4XXhFfiW6bCiv1EvWbTOVKqYilIF9NpyPazN/1+lQA3dKgOAz5we/Xyg
	+UZguQ6PAi+fvBJ3LSetlii2DGjCbpSFbJCKPF05sZV1AugF3CUxi9WznP9644mmcUblnrKVfsV
	E8YAutmEp6HiwTi5DKBAVYo=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4j0jc745ltzmV8H;
	Thu,  8 Oct 2026 16:20:39 +0800 (CST)
Received: from dggpemr200003.china.huawei.com (unknown [7.185.36.25])
	by mail.maildlp.com (Postfix) with ESMTPS id 5EE1E40578;
	Thu,  8 Oct 2026 16:32:53 +0800 (CST)
Received: from [10.174.185.234] (10.174.185.234) by
 dggpemr200003.china.huawei.com (7.185.36.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 8 Oct 2026 16:32:52 +0800
Message-ID: <77a9ab65-2997-47f8-8e99-04c4467df7b8@huawei.com>
Date: Thu, 8 Oct 2026 16:32:51 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] Batch register access for live migration optimization
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
From: Yize Wang <wangyize7@huawei.com>
In-Reply-To: <86ece63kes.wl-maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemr200003.china.huawei.com (7.185.36.25)


在 2026/10/3 22:53, Marc Zyngier 写道:
> On Sun, 20 Sep 2026 10:15:25 +0100,
> Yize Wang <wangyize7@huawei.com> wrote:
>> 在 2026/9/18 20:08, Marc Zyngier 写道:
>>> On Fri, 18 Sep 2026 09:18:13 +0100,
>>> Yize Wang<wangyize7@huawei.com> wrote:
>>>> This series adds batch register access support to KVM/arm64 to reduce
>>>> syscall overhead during VM live migration.
>>>>
>>>> Currently, QEMU issues one ioctl per register when saving/restoring VGIC
>>>> state. On large VM configurations this means tens of thousands of syscalls,
>>>> where lock acquisition and context switch overhead dominates migration
>>>> downtime. Thus, we provide a batch register method to allow userspace
>>>> read/write multiple distributor and redistributor registers in a single call.
>>>> In this way, we can significantly reduce syscalls and migration downtime.
>>>>
>>>> Test the VM migration time under pressure conditions.
>>>> The VM specifications for migration are as follows:
>>>> - VM use 4-K page;
>>>> - the number of VCPU is 160;
>>>> - the total memory is 320Gigabit;
>>>> - use 'Redis SET-benchmark' to pressurize VM;
>>>>
>>>> Performance results (3-run average, ms):
>>>>       | Metric              | Without patch | With patch | Improvement |
>>>>       |---------------------|---------------|------------|-------------|
>>>>       | Migration downtime  |        536    |     321    |     40%     |
>>>>       | Source (total)      |        344    |     230    |     33%     |
>>>>       |   - VGIC put        |        158    |      40    |     75%     |
>>>>       |   - VGIC get        |        120    |      19    |     84%     |
>>>>       | Destination (total) |        192    |      91    |     53%     |
>>>>       |   - VGIC put        |        132    |      27    |     80%     |
>>>>
>>>> Yize Wang (2):
>>>>     KVM: arm64: Add batch group constant and data structure to UAPI header
>>>>     KVM: arm64: Add VGIC v3 batch register access implementation
>>> Questions:
>>>
>>> - Why only the MMIO registers?
>>>
>>> - Why not the sysregs?
>>>
>>> - Why only the GIC?
>>>
>>> - Why not all of the state?
>>>
>>> - Where is the corresponding userspace code?
>>>
>>> More importantly, since this is about batching system calls:
>>>
>>> - Why can't this be done with io_uring instead?
>>>
>>> 	M.
>>
>> Hi, Marc! Thank you for the review.
>>
>>    These patches focus on optimizing GICv3 register access during live
>> migration. We found that there are a large number of locks (kvm->lock,
>> vcpus, config_lock) in the GIC, these lock operations wil cost large
>> time waste. The batches of sysreg for vcpu optimization will come in
>> follow as a separate series. And let me address these questions one by
>> one.
> All these locks should be non-blocking by the time you save anything
> related to the GIC, because:
>
> - none of the vcpu can be running
>
> - this must be a single threaded operation
>
> So if you are seeing anything contended, this is either the sign of a
> bad KVM bug, or an indication that you are violating the above
> requirements.
>
> 	M.


Hi, Marc! Thanks for your review.

You are right that when saving the GIC state during live migration 
process, all vCPUs are not running and it is a single threaded 
operation. Our patches process the packaged register states from the 
userspace under the same lock. These operations only aim to reduce the 
lock opreation downtime and do not involve lock contention.

In addition, these patches focus on reducing the syscalls of ioctl. Now, 
every register requires an ioctl, resulting in (num_cpu * 
registers_per_cpu) system calls. This will cost lots of time during the 
large-scale VM migration. Our patches batch registers by category in 
qemu and then send them to kernel in batches. This operations 
significantly reduce the number of ioctl syscalls and save a great 
amount of downtime.

The comparison is as follow:

BEFORE:

QEMU (Userspace)Kernel (Kernelspace)

+--------------------------++------------------------------+

||||

|kvm_arm_gicv3_get()||vgic_v3_attr_regs_access()|

||||

|for ncpu in num_cpu:|||

|+--------------+|||

|| GICR_CTLR|----|--- ioctl ------> |mutex_lock(&kvm->lock)|

|+--------------+ <--|--- val --------- |kvm_trylock_all_vcpus()|

|+--------------+||mutex_lock(&config_lock)|

|| GICR_STATUSR |----|--- ioctl ------> ||

|+--------------+ <--|--- val --------- |read/write single register|

|+--------------+|||

|| GICR_WAKER|----|--- ioctl ------> |mutex_unlock(&config_lock)|

|+--------------+ <--|--- val --------- |kvm_unlock_all_vcpus()|

|...||mutex_unlock(&kvm->lock)|

|+--------------+|||

|| ICC_SRE_EL1|----|--- ioctl ------> |(repeat lock -> read -> unlock

|+--------------+ <--|--- val --------- |for each register)|

|...|||

||||

+--------------------------++------------------------------+


AFTER:

QEMU (Userspace)Kernel (Kernelspace)

+----------------------------++--------------------------------+

||||

|kvm_arm_gicv3_get()||vgic_v3_batch_access()|

|||        |

|+- Collect Phase ----+|||

||| |||

|| batch_add(GICR_CTLR)| |||

|| batch_add(GICR_STATUSR) |||

|| batch_add(GICR_WAKER)||||

|| batch_add(GICR_IGROUPR0)| ||

|| ...||||

|| batch_add(ICC_SRE_EL1)  |||

|| ...||||

|+---------------------+ |||

||1 ioctl|copy_from_user(entries)|

|+- Commit Phase -----+|||

||| --- ioctl(BATCH)---> |mutex_lock(&kvm->lock)|

||batch_commit()| ||kvm_trylock_all_vcpus()|

|||||mutex_lock(&config_lock)|

||||||

|+---------------------+ ||+-- Process Each Entry --+|

||||||

|+- Unpack Phase -----+|||entry[0]: read GICR_CTLR|  |

||| <---batch result ---||entry[1]: read GICR_STATUSR|

||Write back to QEMU | | ||entry[2]: read GICR_WAKER| |

||state||||...||

||(post-process:| | ||entry[N]: read ICC_SRE | |

||unshuffle, split| | ||| |

||bytes, etc.)| |||* FLAG_LOCKED: skip||

||| | ||locking (already held)|  |

|+---------------------+ ||+-------------------------+ |

|||  |

+----------------------------++--------------------------------+



