Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 444571B3B0D
	for <kvmarm@lists.linux.dev>; Wed, 21 Aug 2024 18:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724264628; cv=none; b=CuvzJqbVT9AqFPi6dJ/JUR5AOdkwPUBFC6EJu2+BZFMs71r8QZ7crrFhc3mjTrHoUWqSh1FRDsnBOJU7Xs+VjCBrN6tdJgQkqsANTAcqrsVlzECM8nThPZ8/iEiRysverouQH0Y8VWbPjDKPDYT4XPR5ir8qsyTeG/jljZpLayE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724264628; c=relaxed/simple;
	bh=CrEj/Mm0l0HK3myb0E/qBhnRWruG+WlfNx8WdX2N9Ks=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Y+hJ6DW4JJdn0ris+NOhNBIW+FTquzJoV88RYSzuyoj4ugs+3Kszd62C/pYY4vjm5W9QYvk6mdxq8wKKhdcTYi2R8pUACwqQCOgfHXE+/5DVnNxqTF2p5f45E1SD4Mn+JO1YdIOomfSWeUkppVJ1tLUPNRvNHXNezlGN7naUayY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4WpvpH6w2jzpVXZ;
	Thu, 22 Aug 2024 02:23:03 +0800 (CST)
Received: from kwepemm600007.china.huawei.com (unknown [7.193.23.208])
	by mail.maildlp.com (Postfix) with ESMTPS id 989E518009B;
	Thu, 22 Aug 2024 02:23:43 +0800 (CST)
Received: from [10.174.176.125] (10.174.176.125) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 22 Aug 2024 02:23:42 +0800
Subject: Re: [bug report] GICv4.1: multiple vpus execute vgic_v4_load at the
 same time will greatly increase the time consumption
To: Marc Zyngier <maz@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Oliver Upton
	<oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, Suzuki K Poulose
	<suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, "open list:IRQ
 SUBSYSTEM" <linux-kernel@vger.kernel.org>, "moderated list:ARM SMMU DRIVERS"
	<linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	"wanghaibin.wang@huawei.com" <wanghaibin.wang@huawei.com>,
	<nizhiqiang1@huawei.com>, "tangnianyao@huawei.com" <tangnianyao@huawei.com>,
	<wangzhou1@hisilicon.com>
References: <a7fc58e4-64c2-77fc-c1dc-f5eb78dbbb01@huawei.com>
 <86msl6xhu2.wl-maz@kernel.org>
From: Kunkun Jiang <jiangkunkun@huawei.com>
Message-ID: <f1574274-efd8-eb56-436b-5a1dd7620f2c@huawei.com>
Date: Thu, 22 Aug 2024 02:23:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <86msl6xhu2.wl-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600007.china.huawei.com (7.193.23.208)

Hi Marc,

On 2024/8/21 18:59, Marc Zyngier wrote:
> On Wed, 21 Aug 2024 10:51:27 +0100,
> Kunkun Jiang <jiangkunkun@huawei.com> wrote:
>>
>> Hi all,
>>
>> Recently I discovered a problem about GICv4.1, the scenario is as follows:
>> 1. Enable GICv4.1
>> 2. Create multiple VMs.For example, 50 VMs(4U8G)

s/4U8G/8U16G/, sorry..

> I don't know what 4U8G means. On how many physical CPUs are you
> running 50 VMs? Direct injection of interrupts and over-subscription
> are fundamentally incompatible.

Each VM is configured with 8 vcpus and 16G memory. The number of
physical CPUs is 320.

> 
>> 3. The business running in VMs has a frequent mmio access and need to exit
>>    to qemu for processing.
>> 4. Or modify the kvm code so that wfi must trap to kvm
>> 5. Then the utilization of pcpu where the vcpu is located will be 100%,and
>>    basically all in sys.
> 
> What did you expect? If you trap all the time, your performance will
> suck.  Don't do that.
> 
>> 6. This problem does not exist in GICv3.
> 
> Because GICv3 doesn't have the same constraints.
> 
>>
>> According to analysis, this problem is due to the execution of vgic_v4_load.
>> vcpu_load or kvm_sched_in
>>      kvm_arch_vcpu_load
>>      ...
>>          vgic_v4_load
>>              irq_set_affinity
>>              ...
>>                  irq_do_set_affinity
>>                      raw_spin_lock(&tmp_mask_lock)
>>                      chip->irq_set_affinity
>>                      ...
>>                        its_vpe_set_affinity
>>
>> The tmp_mask_lock is the key. This is a global lock. I don't quite
>> understand
>> why tmp_mask_lock is needed here. I think there are two possible
>> solutions here:
>> 1. Remove this tmp_mask_lock
> 
> Maybe you could have a look at 33de0aa4bae98 (and 11ea68f553e24)? It
> would allow you to understand the nature of the problem.
> 
> This can probably be replaced with a per-CPU cpumask, which would
> avoid the locking, but potentially result in a larger memory usage.

Thanks, I will try it.

>> 2. Modify the gicv4 driver,do not perfrom VMOVP via
>> irq_set_affinity.
> 
> Sure. You could also not use KVM at all if don't care about interrupts
> being delivered to your VM. We do not send a VMOVP just for fun. We
> send it because your vcpu has moved to a different CPU, and the ITS
> needs to know about that.

When a vcpu is moved to a different CPU, of course VMOVP has to be sent.
I mean is it possible to call its_vpe_set_affinity() to send VMOVP by
other means (instead of by calling the irq_set_affinity() API). So we
can bypass this tmp_mask_lock.

> 
> You seem to be misunderstanding the use case for GICv4: a partitioned
> system, without any over-subscription, no vcpu migration between CPUs.
> If that's not your setup, then GICv4 will always be a net loss
> compared to SW injection with GICv3 (additional HW interaction,
> doorbell interrupts).

Thanks for the explanation. The key to the problem is not vcpu migration
between CPUs. The key point is that many vcpus execute vgic_v4_load() at
the same time. Even if it is not migrated to another CPU, there may be a
large number of vcpus executing vgic_v4_load() at the same time. For
example, the service running in VMs has a large number of MMIO accesses
and need to return to userspace for emulation. Due to the competition of
tmp_mask_lock, performance will deteriorate.

When the target CPU is the same CPU as the last run, there seems to be
no need to call irq_set_affinity() in this case. I did a test and it was
indeed able to alleviate the problem described above.

I feel it might be better to remove tmp_mask_lock or call
its_vpe_set_affinity() in another way. So I mentioned these two ideas
above.

Thanks,
Kunkun Jiang
