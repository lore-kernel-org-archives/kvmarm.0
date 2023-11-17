Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC9B2FBEE
	for <kvmarm@lists.linux.dev>; Fri, 17 Nov 2023 10:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from kwepemm000007.china.huawei.com (unknown [172.30.72.54])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4SWsc43wF2z1P8S2;
	Fri, 17 Nov 2023 17:51:16 +0800 (CST)
Received: from [10.174.185.210] (10.174.185.210) by
 kwepemm000007.china.huawei.com (7.193.23.189) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Fri, 17 Nov 2023 17:54:37 +0800
Subject: Re: [PATCH] KVM: arm/arm64: GICv4: Do not perform an map to a mapped
 vLPI
To: Marc Zyngier <maz@kernel.org>
CC: Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>, <eric.auger@redhat.com>,
	<linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<wanghaibin.wang@huawei.com>, <jiangkunkun@huawei.com>
References: <20231116125215.1812-1-jiangkunkun@huawei.com>
 <864jhl23hp.wl-maz@kernel.org>
From: Kunkun Jiang <jiangkunkun@huawei.com>
Message-ID: <967d81f7-74ae-da34-33b1-00e0b5cd1f22@huawei.com>
Date: Fri, 17 Nov 2023 17:54:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <864jhl23hp.wl-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.174.185.210]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm000007.china.huawei.com (7.193.23.189)
X-CFilter-Loop: Reflected

Hi Marc，

On 2023/11/16 22:10, Marc Zyngier wrote:
> On Thu, 16 Nov 2023 12:52:15 +0000,
> Kunkun Jiang <jiangkunkun@huawei.com> wrote:
>> Before performing an unmap, let's check whether the vLPI has been
s/unmap/map
>> mapped. This corresponds to checking whether a vLPI is valid before
>> unmap it.
>>
>> Signed-off-by: Kunkun Jiang <jiangkunkun@huawei.com>
>> ---
>>   arch/arm64/kvm/vgic/vgic-v4.c | 5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
>> index 339a55194b2c..824f4baf50ee 100644
>> --- a/arch/arm64/kvm/vgic/vgic-v4.c
>> +++ b/arch/arm64/kvm/vgic/vgic-v4.c
>> @@ -436,6 +436,11 @@ int kvm_vgic_v4_set_forwarding(struct kvm *kvm, int virq,
>>   	if (ret)
>>   		goto out;
>>   
>> +	if (irq->hw) {
>> +		ret = -EBUSY;
>> +		goto out;
>> +	}
>> +
> So this code affects the mapping side, not the unmapping. Even more
> confusingly, the subject of the patch doesn't match the commit
> message.
>
> Furthermore, I'm not sure we want to return an error here. Userspace
> has no knowledge of GICv4, and there are numerous other cases where we
> don't return any error. This is certainly a userspace visible change.
Yes, Userspace has no knowledge of GICv4. In the current implementation,
this error will not be presented to userspace. Only a log will be printed
in kvm_irqfd_assign().
 > #ifdef CONFIG_HAVE_KVM_IRQ_BYPASS
 >         if (kvm_arch_has_irq_bypass()) {
 >                 irqfd->consumer.token = (void *)irqfd->eventfd;
 >                 irqfd->consumer.add_producer = 
kvm_arch_irq_bypass_add_producer;
 >                 irqfd->consumer.del_producer = 
kvm_arch_irq_bypass_del_producer;
 >                 irqfd->consumer.stop = kvm_arch_irq_bypass_stop;
 >                 irqfd->consumer.start = kvm_arch_irq_bypass_start;
 >                 ret = irq_bypass_register_consumer(&irqfd->consumer);
 >                 if (ret)
 >                         pr_info("irq bypass consumer (token %p) 
registration fails: %d\n",
 >                                 irqfd->consumer.token, ret);
 >         }
 > #endif

If you think it is better not to return an error, I will modify it in
the next version.

Looking forwarding to your reply.

Thanks,
Kunkun Jiang

