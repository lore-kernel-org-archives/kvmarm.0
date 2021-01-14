Return-Path: <SRS0=BtxD=GR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 383F3C433E0
	for <kvmarm@archiver.kernel.org>; Thu, 14 Jan 2021 10:16:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 76AAF23A50
	for <kvmarm@archiver.kernel.org>; Thu, 14 Jan 2021 10:16:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 76AAF23A50
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9BE894B0B2;
	Thu, 14 Jan 2021 05:16:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6YdBA7WjM2M1; Thu, 14 Jan 2021 05:16:37 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B6464B173;
	Thu, 14 Jan 2021 05:16:37 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2AC4F4B173
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jan 2021 05:16:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MGlFWzgLgJL6 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Jan 2021 05:16:35 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C2C24B16D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jan 2021 05:16:35 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1610619395;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=IaIUvaMv2k9j6w56+5o78W95fqxpiStrTQ2Nmkvuj38=;
 b=RGbjNInH2fJJZFFXJQ095eYSbv7ISpZDfABqWhUIgjzNj2K1Mk1I/dlRV2FOVbd7hkeQP6
 Rkz9TlxF8r3UbNA2XOgXgXumKVEHPJEJdkJixFS8GkxjUOgVpA8ggI4lb9Wkvh71Sfhcx6
 fFJ1MOx+Ozd5WNrJCxhyA1XbYmgnrDE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-156-5iw1vXHqMKWXyi8cUWxbLg-1; Thu, 14 Jan 2021 05:16:33 -0500
X-MC-Unique: 5iw1vXHqMKWXyi8cUWxbLg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
 [10.5.11.23])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EB979107ACFB;
 Thu, 14 Jan 2021 10:16:31 +0000 (UTC)
Received: from [10.36.114.165] (ovpn-114-165.ams2.redhat.com [10.36.114.165])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 05D4019C47;
 Thu, 14 Jan 2021 10:16:28 +0000 (UTC)
Subject: Re: [PATCH 8/9] KVM: arm64: vgic-v3: Expose GICR_TYPER.Last for
 userspace
To: Alexandru Elisei <alexandru.elisei@arm.com>, eric.auger.pro@gmail.com,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, maz@kernel.org, drjones@redhat.com
References: <20201212185010.26579-1-eric.auger@redhat.com>
 <20201212185010.26579-9-eric.auger@redhat.com>
 <45a364ec-eac6-a04b-9654-e97970186839@arm.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <7078b0a5-fb18-5e65-953a-8a55009aa2be@redhat.com>
Date: Thu, 14 Jan 2021 11:16:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <45a364ec-eac6-a04b-9654-e97970186839@arm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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

Hi Alexandru,

On 1/12/21 6:02 PM, Alexandru Elisei wrote:
> Hi Eric,
> 
> On 12/12/20 6:50 PM, Eric Auger wrote:
>> Commit 23bde34771f1 ("KVM: arm64: vgic-v3: Drop the
>> reporting of GICR_TYPER.Last for userspace") temporarily fixed
>> a bug identified when attempting to access the GICR_TYPER
>> register before the redistributor region setting but dropped
>> the support of the LAST bit. This patch restores its
>> support (if the redistributor region was set) while keeping the
>> code safe.
> 
> I suppose the reason for emulating GICR_TYPER.Last is for architecture compliance,
> right? I think that should be in the commit message.
OK added this in the commit msg.
> 
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> ---
>>  arch/arm64/kvm/vgic/vgic-mmio-v3.c | 7 ++++++-
>>  include/kvm/arm_vgic.h             | 1 +
>>  2 files changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
>> index 581f0f490000..2f9ef6058f6e 100644
>> --- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
>> +++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
>> @@ -277,6 +277,8 @@ static unsigned long vgic_uaccess_read_v3r_typer(struct kvm_vcpu *vcpu,
>>  						 gpa_t addr, unsigned int len)
>>  {
>>  	unsigned long mpidr = kvm_vcpu_get_mpidr_aff(vcpu);
>> +	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
>> +	struct vgic_redist_region *rdreg = vgic_cpu->rdreg;
>>  	int target_vcpu_id = vcpu->vcpu_id;
>>  	u64 value;
>>  
>> @@ -286,7 +288,9 @@ static unsigned long vgic_uaccess_read_v3r_typer(struct kvm_vcpu *vcpu,
>>  	if (vgic_has_its(vcpu->kvm))
>>  		value |= GICR_TYPER_PLPIS;
>>  
>> -	/* reporting of the Last bit is not supported for userspace */
>> +	if (rdreg && (vgic_cpu->rdreg_index == (rdreg->free_index - 1)))
>> +		value |= GICR_TYPER_LAST;
>> +
>>  	return extract_bytes(value, addr & 7, len);
>>  }
>>  
>> @@ -714,6 +718,7 @@ int vgic_register_redist_iodev(struct kvm_vcpu *vcpu)
>>  		return -EINVAL;
>>  
>>  	vgic_cpu->rdreg = rdreg;
>> +	vgic_cpu->rdreg_index = rdreg->free_index;
> 
> What happens if the next redistributor region we register has the base address
> adjacent to this one?
> 
> I'm really not familiar with the code, but is it not possible to create two
> Redistributor regions (via
> KVM_DEV_ARM_VGIC_GRP_ADDR(KVM_VGIC_V3_ADDR_TYPE_REDIST)) where the second
> Redistributor region start address is immediately after the last Redistributor in
> the preceding region?
KVM_VGIC_V3_ADDR_TYPE_REDIST only allows to create a single rdist
region. Only KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION allows to register
several of them.

with KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, it is possible to register
adjacent rdist regions. vgic_v3_rdist_free_slot() previously returned
the 1st rdist region where enough space remains for inserting the new
reg. We put the rdist at the free index there.

But maybe I misunderstood your question?

Thanks

Eric
> 
> Thanks,
> Alex
>>  
>>  	rd_base = rdreg->base + rdreg->free_index * KVM_VGIC_V3_REDIST_SIZE;
>>  
>> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
>> index a8d8fdcd3723..596c069263a7 100644
>> --- a/include/kvm/arm_vgic.h
>> +++ b/include/kvm/arm_vgic.h
>> @@ -322,6 +322,7 @@ struct vgic_cpu {
>>  	 */
>>  	struct vgic_io_device	rd_iodev;
>>  	struct vgic_redist_region *rdreg;
>> +	u32 rdreg_index;
>>  
>>  	/* Contains the attributes and gpa of the LPI pending tables. */
>>  	u64 pendbaser;
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
