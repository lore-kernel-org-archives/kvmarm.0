Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 789CA1A594
	for <kvmarm@lists.linux.dev>; Mon, 20 Nov 2023 13:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from kwepemm000007.china.huawei.com (unknown [172.30.72.57])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4SYp0J1VLRzRj46;
	Mon, 20 Nov 2023 21:15:28 +0800 (CST)
Received: from [10.174.185.210] (10.174.185.210) by
 kwepemm000007.china.huawei.com (7.193.23.189) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 20 Nov 2023 21:19:42 +0800
Subject: Re: [PATCH v2] KVM: arm/arm64: GICv4: Do not perform a map to a
 mapped vLPI
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
CC: James Morse <james.morse@arm.com>, Suzuki K Poulose
	<suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas
	<catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Jean-Philippe
 Brucker <jean-philippe@linaro.org>, <eric.auger@redhat.com>,
	<linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<wanghaibin.wang@huawei.com>
References: <20231119104941.1952-1-jiangkunkun@huawei.com>
 <8a84365107c856e266b206e6e2374ec3@kernel.org>
From: Kunkun Jiang <jiangkunkun@huawei.com>
Message-ID: <f7494f52-250f-8df5-f244-c4ce3d2d2f47@huawei.com>
Date: Mon, 20 Nov 2023 21:19:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <8a84365107c856e266b206e6e2374ec3@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.174.185.210]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm000007.china.huawei.com (7.193.23.189)
X-CFilter-Loop: Reflected

Hi Marc,Oliver,

On 2023/11/20 17:15, Marc Zyngier wrote:
> On 2023-11-19 10:49, Kunkun Jiang wrote:
>> Before performing a map, let's check whether the vLPI has been
>> mapped. This corresponds to checking whether a vLPI is valid
>> before unmap it.
>
> I don't understand this last sentence. Mapping and unmapping
> are two different actions, and we shouldn't conflate them.
>
>>
>> Fixes: 196b136498b3 ("KVM: arm/arm64: GICv4: Wire mapping/unmapping of
>> VLPIs in VFIO irq bypass")
>> Signed-off-by: Kunkun Jiang <jiangkunkun@huawei.com>
>> ---
>>  arch/arm64/kvm/vgic/vgic-v4.c | 5 +++++
>>  1 file changed, 5 insertions(+)
>>
>> diff --git a/arch/arm64/kvm/vgic/vgic-v4.c 
>> b/arch/arm64/kvm/vgic/vgic-v4.c
>> index 339a55194b2c..fb60bbb94460 100644
>> --- a/arch/arm64/kvm/vgic/vgic-v4.c
>> +++ b/arch/arm64/kvm/vgic/vgic-v4.c
>> @@ -436,6 +436,11 @@ int kvm_vgic_v4_set_forwarding(struct kvm *kvm, 
>> int virq,
>>      if (ret)
>>          goto out;
>>
>> +    if (irq->hw) {
>> +        ret = 0;
>
> ret is obviously already 0.
>
>> +        goto out;
>> +    }
>> +
>>      /*
>>       * Emit the mapping request. If it fails, the ITS probably
>>       * isn't v4 compatible, so let's silently bail out. Holding
>
> Furthermore, this really deserves a comment. Something like:
>
> /* Silently exit if the vLPI is already mapped */
>
> With these changes:
>
> Acked-by: Marc Zyngier <maz@kernel.org>
>
> Oliver, can you please apply these changes and queue it as a fix
> for 6.7?
>
Thank you for your careful review. I just sent the v3 and applied
these changes.
https://lore.kernel.org/kvmarm/20231120131210.2039-1-jiangkunkun@huawei.com/

Thanks,
Kunkun Jiang
> Thanks,
>
>         M.
