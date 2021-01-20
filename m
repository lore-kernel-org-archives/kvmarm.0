Return-Path: <SRS0=2DZ8=GX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0C1FC433E0
	for <kvmarm@archiver.kernel.org>; Wed, 20 Jan 2021 16:13:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 27B29233EA
	for <kvmarm@archiver.kernel.org>; Wed, 20 Jan 2021 16:13:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 27B29233EA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 881A84B1AA;
	Wed, 20 Jan 2021 11:13:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id j4ALnqyTXV1w; Wed, 20 Jan 2021 11:13:35 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 437AD4B16D;
	Wed, 20 Jan 2021 11:13:35 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E3A004B145
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jan 2021 11:13:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bq1TVeEtDD2X for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Jan 2021 11:13:32 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 567C94B150
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jan 2021 11:13:32 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F18F6101E;
 Wed, 20 Jan 2021 08:13:31 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6E9873F68F;
 Wed, 20 Jan 2021 08:13:30 -0800 (PST)
Subject: Re: [PATCH 8/9] KVM: arm64: vgic-v3: Expose GICR_TYPER.Last for
 userspace
To: Auger Eric <eric.auger@redhat.com>, eric.auger.pro@gmail.com,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, maz@kernel.org, drjones@redhat.com
References: <20201212185010.26579-1-eric.auger@redhat.com>
 <20201212185010.26579-9-eric.auger@redhat.com>
 <45a364ec-eac6-a04b-9654-e97970186839@arm.com>
 <7078b0a5-fb18-5e65-953a-8a55009aa2be@redhat.com>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <a4ab6472-41d9-1259-9416-54b06eb11626@arm.com>
Date: Wed, 20 Jan 2021 16:13:31 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <7078b0a5-fb18-5e65-953a-8a55009aa2be@redhat.com>
Content-Language: en-US
Cc: shuah@kernel.org, pbonzini@redhat.com
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Eric,

On 1/14/21 10:16 AM, Auger Eric wrote:
> Hi Alexandru,
>
> On 1/12/21 6:02 PM, Alexandru Elisei wrote:
>> Hi Eric,
>>
>> On 12/12/20 6:50 PM, Eric Auger wrote:
>>> Commit 23bde34771f1 ("KVM: arm64: vgic-v3: Drop the
>>> reporting of GICR_TYPER.Last for userspace") temporarily fixed
>>> a bug identified when attempting to access the GICR_TYPER
>>> register before the redistributor region setting but dropped
>>> the support of the LAST bit. This patch restores its
>>> support (if the redistributor region was set) while keeping the
>>> code safe.
>> I suppose the reason for emulating GICR_TYPER.Last is for architecture compliance,
>> right? I think that should be in the commit message.
> OK added this in the commit msg.
>>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>> ---
>>>  arch/arm64/kvm/vgic/vgic-mmio-v3.c | 7 ++++++-
>>>  include/kvm/arm_vgic.h             | 1 +
>>>  2 files changed, 7 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
>>> index 581f0f490000..2f9ef6058f6e 100644
>>> --- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
>>> +++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
>>> @@ -277,6 +277,8 @@ static unsigned long vgic_uaccess_read_v3r_typer(struct kvm_vcpu *vcpu,
>>>  						 gpa_t addr, unsigned int len)
>>>  {
>>>  	unsigned long mpidr = kvm_vcpu_get_mpidr_aff(vcpu);
>>> +	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
>>> +	struct vgic_redist_region *rdreg = vgic_cpu->rdreg;
>>>  	int target_vcpu_id = vcpu->vcpu_id;
>>>  	u64 value;
>>>  
>>> @@ -286,7 +288,9 @@ static unsigned long vgic_uaccess_read_v3r_typer(struct kvm_vcpu *vcpu,
>>>  	if (vgic_has_its(vcpu->kvm))
>>>  		value |= GICR_TYPER_PLPIS;
>>>  
>>> -	/* reporting of the Last bit is not supported for userspace */
>>> +	if (rdreg && (vgic_cpu->rdreg_index == (rdreg->free_index - 1)))
>>> +		value |= GICR_TYPER_LAST;
>>> +
>>>  	return extract_bytes(value, addr & 7, len);
>>>  }
>>>  
>>> @@ -714,6 +718,7 @@ int vgic_register_redist_iodev(struct kvm_vcpu *vcpu)
>>>  		return -EINVAL;
>>>  
>>>  	vgic_cpu->rdreg = rdreg;
>>> +	vgic_cpu->rdreg_index = rdreg->free_index;
>> What happens if the next redistributor region we register has the base address
>> adjacent to this one?
>>
>> I'm really not familiar with the code, but is it not possible to create two
>> Redistributor regions (via
>> KVM_DEV_ARM_VGIC_GRP_ADDR(KVM_VGIC_V3_ADDR_TYPE_REDIST)) where the second
>> Redistributor region start address is immediately after the last Redistributor in
>> the preceding region?
> KVM_VGIC_V3_ADDR_TYPE_REDIST only allows to create a single rdist
> region. Only KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION allows to register
> several of them.
>
> with KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, it is possible to register
> adjacent rdist regions. vgic_v3_rdist_free_slot() previously returned
> the 1st rdist region where enough space remains for inserting the new
> reg. We put the rdist at the free index there.
>
> But maybe I misunderstood your question?

Yes, I think you did a good job at answering my poorly worded question.

This is the case I am concerned about:

1. Userspace sets first redistributor base address to 0x0 via
KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION(count = 1, base = 0x0, flags = 0, index = 0).

2. Userspace sets first redistributor base address to 0x0 + 128K, immediately
following the previous Redistributor.

In that case the two Redistributors will be represented by two separate struct
vgic_redist_region, but they are adjacent to one another and represent one
contiguous memory region.

From what I understand from your patch, GICR_TYPER.Last will be set for both
Redistributors, when it should be set only for the second Redistributor. Does any
of that make sense?

Thanks,
Alex
>
> Thanks
>
> Eric
>> Thanks,
>> Alex
>>>  
>>>  	rd_base = rdreg->base + rdreg->free_index * KVM_VGIC_V3_REDIST_SIZE;
>>>  
>>> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
>>> index a8d8fdcd3723..596c069263a7 100644
>>> --- a/include/kvm/arm_vgic.h
>>> +++ b/include/kvm/arm_vgic.h
>>> @@ -322,6 +322,7 @@ struct vgic_cpu {
>>>  	 */
>>>  	struct vgic_io_device	rd_iodev;
>>>  	struct vgic_redist_region *rdreg;
>>> +	u32 rdreg_index;
>>>  
>>>  	/* Contains the attributes and gpa of the LPI pending tables. */
>>>  	u64 pendbaser;
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
