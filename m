Return-Path: <SRS0=dOSa=5Q=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6173C2D0F3
	for <kvmarm@archiver.kernel.org>; Tue, 31 Mar 2020 09:11:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7385D20772
	for <kvmarm@archiver.kernel.org>; Tue, 31 Mar 2020 09:11:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7385D20772
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C8364B097;
	Tue, 31 Mar 2020 05:11:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nes4PN9CKiH0; Tue, 31 Mar 2020 05:11:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 55B1C4B092;
	Tue, 31 Mar 2020 05:11:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D50A24A531
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Mar 2020 05:11:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SAM6FCiqzXPP for <kvmarm@lists.cs.columbia.edu>;
 Tue, 31 Mar 2020 05:11:52 -0400 (EDT)
Received: from huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3CF734A1FA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Mar 2020 05:11:52 -0400 (EDT)
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id B173E165DEDBC9925135;
 Tue, 31 Mar 2020 17:11:47 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.487.0; Tue, 31 Mar 2020
 17:11:38 +0800
Subject: Re: [PATCH] KVM: arm64: vgic-v3: Clear pending bit in guest memory
 after synchronization
To: Marc Zyngier <maz@kernel.org>
References: <20200331031245.1562-1-yuzenghui@huawei.com>
 <20200331090709.17d2087d@why>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <fe30a834-fdb0-e1ca-5e4a-0c7863236c5f@huawei.com>
Date: Tue, 31 Mar 2020 17:11:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200331090709.17d2087d@why>
Content-Language: en-US
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Cc: andre.przywara@arm.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
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

Hi Marc,

On 2020/3/31 16:07, Marc Zyngier wrote:
> Hi Zenghui,
> 
> On Tue, 31 Mar 2020 11:12:45 +0800
> Zenghui Yu <yuzenghui@huawei.com> wrote:
> 
>> When LPI support is enabled at redistributor level, VGIC will potentially
>> load the correspond LPI penging table and sync it into the pending_latch.
>> To avoid keeping the 'consumed' pending bits lying around in guest memory
>> (though they're not used), let's clear them after synchronization.
>>
>> The similar work had been done in vgic_v3_lpi_sync_pending_status().
>>
>> Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
>> ---
>>   virt/kvm/arm/vgic/vgic-its.c | 23 +++++++++++++++++------
>>   1 file changed, 17 insertions(+), 6 deletions(-)
>>
>> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
>> index d53d34a33e35..905760bfa404 100644
>> --- a/virt/kvm/arm/vgic/vgic-its.c
>> +++ b/virt/kvm/arm/vgic/vgic-its.c
>> @@ -435,6 +435,7 @@ static int its_sync_lpi_pending_table(struct kvm_vcpu *vcpu)
>>   
>>   	for (i = 0; i < nr_irqs; i++) {
>>   		int byte_offset, bit_nr;
>> +		bool status;
>>   
>>   		byte_offset = intids[i] / BITS_PER_BYTE;
>>   		bit_nr = intids[i] % BITS_PER_BYTE;
>> @@ -447,22 +448,32 @@ static int its_sync_lpi_pending_table(struct kvm_vcpu *vcpu)
>>   			ret = kvm_read_guest_lock(vcpu->kvm,
>>   						  pendbase + byte_offset,
>>   						  &pendmask, 1);
>> -			if (ret) {
>> -				kfree(intids);
>> -				return ret;
>> -			}
>> +			if (ret)
>> +				goto out;
>>   			last_byte_offset = byte_offset;
>>   		}
>>   
>> +		status = pendmask & (1 << bit_nr);
>> +
>>   		irq = vgic_get_irq(vcpu->kvm, NULL, intids[i]);
>>   		raw_spin_lock_irqsave(&irq->irq_lock, flags);
>> -		irq->pending_latch = pendmask & (1U << bit_nr);
>> +		irq->pending_latch = status;
>>   		vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
>>   		vgic_put_irq(vcpu->kvm, irq);
>> +
>> +		if (status) {
>> +			/* clear consumed data */
>> +			pendmask &= ~(1 << bit_nr);
>> +			ret = kvm_write_guest_lock(vcpu->kvm,
>> +						   pendbase + byte_offset,
>> +						   &pendmask, 1);
>> +			if (ret)
>> +				goto out;
>> +		}
>>   	}
>>   
>> +out:
>>   	kfree(intids);
>> -
>>   	return ret;
>>   }
>>   
> 
> I've been thinking about this, and I wonder why we don't simply clear
> the whole pending table instead of carefully wiping it one bit at a
> time. My reasoning is that if a LPI isn't mapped, then it cannot be made
> pending the first place.

A writing to GICR_CTLR.EnableLPIs can happen in parallel with MAPTI/INT
command sequence, where the new LPI is mapped to *this* vcpu and made
pending, wrong? I think commit 7d8b44c54e0c had described it in detail.

But thinking that we cache the pending bit in pending_latch (instead of
writing the corresponding bit in guest memory) when a LPI is made
pending, it seems to be safe to clear the whole pending table here.

> 
> And I think there is a similar issue in vgic_v3_lpi_sync_pending_status().
> Why sync something back from the pending table when the LPI wasn't
> mapped yet?

vgic_v3_lpi_sync_pending_status() can be called on the ITE restore path:
vgic_its_restore_ite/vgic_add_lpi/vgic_v3_lpi_sync_pending_status.
We should rely on it to sync the pending bit from guest memory (which
was saved on the source side).

> This seems pretty bizarre, as the GITS_TRANSLATER spec says
> that the write to this register is ignored when:
> 
> "- The EventID is mapped to an Interrupt Translation Table and the
> EventID is within the range specified by MAPD on page 5-107, but the
> EventID is unmapped."
> 
> (with the added bonus in the form of a type: the first instance of
> "EventID" here should obviously be "DeviceID").

;-)


Thanks,
Zenghui

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
