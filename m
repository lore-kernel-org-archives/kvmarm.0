Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69A211F959
	for <kvmarm@lists.linux.dev>; Wed, 12 Jul 2023 12:09:54 +0000 (UTC)
Received: from kwepemm600007.china.huawei.com (unknown [172.30.72.56])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4R1GgW2LBsztRM0;
	Wed, 12 Jul 2023 20:06:47 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 12 Jul 2023 20:09:45 +0800
Subject: Re: [PATCH] KVM: arm64: vgic-v4: Consistently request doorbell irq
 for blocking vCPU
To: Oliver Upton <oliver.upton@linux.dev>
CC: Marc Zyngier <maz@kernel.org>, <kvmarm@lists.linux.dev>, James Morse
	<james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
	<stable@vger.kernel.org>, Xiang Chen <chenxiang66@hisilicon.com>
References: <20230710175553.1477762-1-oliver.upton@linux.dev>
 <86jzv6x66q.wl-maz@kernel.org> <ZK0EPhvLzhaFepGk@linux.dev>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <14acf0fd-e5eb-8a14-986a-b8fe4a44cec9@huawei.com>
Date: Wed, 12 Jul 2023 20:09:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <ZK0EPhvLzhaFepGk@linux.dev>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.179]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600007.china.huawei.com (7.193.23.208)
X-CFilter-Loop: Reflected

On 2023/7/11 15:26, Oliver Upton wrote:
> On Tue, Jul 11, 2023 at 08:23:25AM +0100, Marc Zyngier wrote:
>> On Mon, 10 Jul 2023 18:55:53 +0100,
>> Oliver Upton <oliver.upton@linux.dev> wrote:
>>>
>>> Xiang reports that VMs occasionally fail to boot on GICv4.1 systems when
>>> running a preemptible kernel, as it is possible that a vCPU is blocked
>>> without requesting a doorbell interrupt.
>>>
>>> The issue is that any preemption that occurs between vgic_v4_put() and
>>> schedule() on the block path will mark the vPE as nonresident and *not*
>>> request a doorbell irq.
>>
>> It'd be worth spelling out. You need to go via *three* schedule()
>> calls: one to be preempted (with DB set), one to be made resident
>> again, and then the final one in kvm_vcpu_halt(), clearing the DB on
>> vcpu_put() due to the bug.
> 
> Yeah, a bit lazy in the wording. What I had meant to imply was
> preemption happening after the doorbell is set up and before the thread
> has an opportunity to explicitly schedule out. Perhaps I should just say
> that.
> 
>>>
>>> Fix it by consistently requesting a doorbell irq in the vcpu put path if
>>> the vCPU is blocking.

Yup. Agreed!

>>> While this technically means we could drop the
>>> early doorbell irq request in kvm_vcpu_wfi(), deliberately leave it
>>> intact such that vCPU halt polling can properly detect the wakeup
>>> condition before actually scheduling out a vCPU.

Yeah, just like what we did in commit 07ab0f8d9a12 ("KVM: Call
kvm_arch_vcpu_blocking early into the blocking sequence").

My only concern is that if the preemption happens before halt polling,
we would enter the polling loop with VPE already resident on the RD and
can't recognize any firing GICv4.x virtual interrupts (targeting this
VPE) in polling. [1]

Given that making VPE resident on the vcpu block path (i.e., in
kvm_vcpu_halt()) makes little sense (right?) and leads to this sort of
problem, a crude idea is that we can probably keep track of the
"nested" vgic_v4_{put,load} calls (instead of a single vpe->resident
flag) and keep VPE *not resident* on the whole block path (like what we
had before commit 8e01d9a396e6). And we then rely on
kvm_vcpu_wfi/vgic_v4_load to actually schedule the VPE on...

The "need doorbell" rule would be simple as before: we do request DB
only if there is a WFI trap (by kvm_vcpu_wfi/vgic_v4_load(vcpu, true)),
and don't need it for any other cases.

Nevertheless [1] is just a matter of performance and shouldn't get in
the way of we fixing the initial bug. ;-)

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>

Thanks,
Zenghui
