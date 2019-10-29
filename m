Return-Path: <SRS0=yVTD=YW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D820CCA9EAE
	for <kvmarm@archiver.kernel.org>; Tue, 29 Oct 2019 12:30:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 91601214B2
	for <kvmarm@archiver.kernel.org>; Tue, 29 Oct 2019 12:30:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 91601214B2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F09334A957;
	Tue, 29 Oct 2019 08:30:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XaRJY98KUdYB; Tue, 29 Oct 2019 08:30:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EEFB24A59D;
	Tue, 29 Oct 2019 08:30:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A4D804A586
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Oct 2019 08:30:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Rz33edNt0aX8 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Oct 2019 08:30:45 -0400 (EDT)
Received: from huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 725004A557
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Oct 2019 08:30:45 -0400 (EDT)
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id 836A69BEE590D4A6CFA9;
 Tue, 29 Oct 2019 20:30:41 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.439.0; Tue, 29 Oct 2019
 20:30:32 +0800
Subject: Re: [PATCH 3/3] KVM: arm/arm64: vgic: Don't rely on the wrong pending
 table
To: Auger Eric <eric.auger@redhat.com>, <maz@kernel.org>,
 <james.morse@arm.com>, <julien.thierry.kdev@gmail.com>,
 <suzuki.poulose@arm.com>
References: <20191029071919.177-1-yuzenghui@huawei.com>
 <20191029071919.177-4-yuzenghui@huawei.com>
 <5e4d1a2f-7107-efe3-9dde-626662e31ac5@redhat.com>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <825b87df-618f-7f2d-0fe9-4cec240c88bf@huawei.com>
Date: Tue, 29 Oct 2019 20:30:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <5e4d1a2f-7107-efe3-9dde-626662e31ac5@redhat.com>
Content-Language: en-US
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2019/10/29 20:17, Auger Eric wrote:
> Hi Zenghui, Marc,
> 
> On 10/29/19 8:19 AM, Zenghui Yu wrote:
>> It's possible that two LPIs locate in the same "byte_offset" but target
>> two different vcpus, where their pending status are indicated by two
>> different pending tables.  In such a scenario, using last_byte_offset
>> optimization will lead KVM relying on the wrong pending table entry.
>> Let us use last_ptr instead, which can be treated as a byte index into
>> a pending table and also, can be vcpu specific.
>>
>> Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
>> ---
>>
>> If this patch has done the right thing, we can even add the:
>>
>> Fixes: 280771252c1b ("KVM: arm64: vgic-v3: KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES")
>>
>> But to be honest, I'm not clear about what has this patch actually fixed.
>> Pending tables should contain all zeros before we flush vgic_irq's pending
>> status into guest's RAM (thinking that guest should never write anything
>> into it). So the pending table entry we've read from the guest memory
>> seems always be zero. And we will always do the right thing even if we
>> rely on the wrong pending table entry.
>>
>> I think I must have some misunderstanding here... Please fix me.
>>
>>   virt/kvm/arm/vgic/vgic-v3.c | 6 +++---
>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
>> index 5ef93e5041e1..7cd2e2f81513 100644
>> --- a/virt/kvm/arm/vgic/vgic-v3.c
>> +++ b/virt/kvm/arm/vgic/vgic-v3.c
>> @@ -363,8 +363,8 @@ int vgic_v3_lpi_sync_pending_status(struct kvm *kvm, struct vgic_irq *irq)
>>   int vgic_v3_save_pending_tables(struct kvm *kvm)
>>   {
>>   	struct vgic_dist *dist = &kvm->arch.vgic;
>> -	int last_byte_offset = -1;
>>   	struct vgic_irq *irq;
>> +	gpa_t last_ptr = -1;
>>   	int ret;
>>   	u8 val;
>>   
>> @@ -384,11 +384,11 @@ int vgic_v3_save_pending_tables(struct kvm *kvm)
>>   		bit_nr = irq->intid % BITS_PER_BYTE;
>>   		ptr = pendbase + byte_offset;
>>   
>> -		if (byte_offset != last_byte_offset) {
>> +		if (ptr != last_ptr) {
>>   			ret = kvm_read_guest_lock(kvm, ptr, &val, 1);
>>   			if (ret)
>>   				return ret;
>> -			last_byte_offset = byte_offset;
>> +			last_ptr = ptr;
>>   		}
>>   
>>   		stored = val & (1U << bit_nr);
>>
> Acked-by: Eric Auger <eric.auger@redhat.com>

Thanks Eric,


Zenghui

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
