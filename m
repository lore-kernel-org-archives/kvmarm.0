Return-Path: <SRS0=/ONs=GQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 481B6C433DB
	for <kvmarm@archiver.kernel.org>; Wed, 13 Jan 2021 17:18:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A64B323441
	for <kvmarm@archiver.kernel.org>; Wed, 13 Jan 2021 17:18:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A64B323441
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C7EE44B173;
	Wed, 13 Jan 2021 12:18:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9ftnkcm5o1Cw; Wed, 13 Jan 2021 12:18:29 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B1634B1AA;
	Wed, 13 Jan 2021 12:18:29 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C21A4B1AD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Jan 2021 12:18:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 74TdDdnqodOy for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Jan 2021 12:18:27 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C7C34B122
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Jan 2021 12:18:27 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1610558307;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Qu3CWqmF7QYC04FWUAReLMtCaEfpUHx+J6CcWfR9p7c=;
 b=EpqADGEHM2CzW6KIqxyFuNap6lYaQcROHVR2s0qUobupu1p24E40SYJb36C5E/tYRHliQ/
 24RO3Gto94Kd4IOqpKiCvOVtFPrKZeOqTWj011FuuJm7tl+g5278UekyfnaJw+G8Jqca4+
 JOsfFhiks7djKYVO137teVbcNfkz+c4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-433-9xTE6IfGPKypiJQR8c6JDw-1; Wed, 13 Jan 2021 12:18:24 -0500
X-MC-Unique: 9xTE6IfGPKypiJQR8c6JDw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0723A425C8;
 Wed, 13 Jan 2021 17:18:23 +0000 (UTC)
Received: from [10.36.114.165] (ovpn-114-165.ams2.redhat.com [10.36.114.165])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id ED1045D9DD;
 Wed, 13 Jan 2021 17:18:20 +0000 (UTC)
Subject: Re: [PATCH 7/9] KVM: arm64: Simplify argument passing to
 vgic_uaccess_[read|write]
To: Alexandru Elisei <alexandru.elisei@arm.com>, eric.auger.pro@gmail.com,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, maz@kernel.org, drjones@redhat.com
References: <20201212185010.26579-1-eric.auger@redhat.com>
 <20201212185010.26579-8-eric.auger@redhat.com>
 <ee2ec95e-4262-a364-b037-c43f3d396760@arm.com>
 <e7af1e23-7b08-99d6-d78c-812d442b32ce@arm.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <266b0ffc-c1a5-4939-975c-aea6a9248a2f@redhat.com>
Date: Wed, 13 Jan 2021 18:18:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <e7af1e23-7b08-99d6-d78c-812d442b32ce@arm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Cc: pbonzini@redhat.com, shuah@kernel.org
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
On 1/12/21 5:16 PM, Alexandru Elisei wrote:
> Hi Eric,
> 
> On 1/12/21 4:04 PM, Alexandru Elisei wrote:
>> Hi Eric,
>>
>> On 12/12/20 6:50 PM, Eric Auger wrote:
>>> Instead of converting the vgic_io_device handle to a kvm_io_device
>>> handled and then do the oppositive, pass a vgic_io_device pointer all
>>> along the call chain.
>> To me, it looks like the commit message describes what the patch does instead of
>> why it does it.
>>
>> What are "vgic_io_device handle" and "kvm_io_device handled"?
Yes unfortunate typo, sorry.
> 
> Sorry, I think I got it now. You were referring to the argument types struct
> vgic_io_device and struct kvm_io_device. The patch looks like a very good cleanup.
> 
> How changing to commit message to sound something like this (feel free to
> ignore/change it if you think of something else):
> 
> vgic_uaccess() takes a struct vgic_io_device argument, converts it to a struct
> kvm_io_device and passes it to the read/write accessor functions, which convert it
> back to a struct vgic_io_device. Avoid the indirection by passing the struct
> vgic_io_device argument directly to vgic_uaccess_{read,write).
I reworded the commit message as you suggested.

Thanks

Eric
> 
> Thanks,
> Alex
>>
>> Thanks,
>> Alex
>>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>> ---
>>>  arch/arm64/kvm/vgic/vgic-mmio.c | 10 ++++------
>>>  1 file changed, 4 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/arch/arm64/kvm/vgic/vgic-mmio.c b/arch/arm64/kvm/vgic/vgic-mmio.c
>>> index b2d73fc0d1ef..48c6067fc5ec 100644
>>> --- a/arch/arm64/kvm/vgic/vgic-mmio.c
>>> +++ b/arch/arm64/kvm/vgic/vgic-mmio.c
>>> @@ -938,10 +938,9 @@ vgic_get_mmio_region(struct kvm_vcpu *vcpu, struct vgic_io_device *iodev,
>>>  	return region;
>>>  }
>>>  
>>> -static int vgic_uaccess_read(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
>>> +static int vgic_uaccess_read(struct kvm_vcpu *vcpu, struct vgic_io_device *iodev,
>>>  			     gpa_t addr, u32 *val)
>>>  {
>>> -	struct vgic_io_device *iodev = kvm_to_vgic_iodev(dev);
>>>  	const struct vgic_register_region *region;
>>>  	struct kvm_vcpu *r_vcpu;
>>>  
>>> @@ -960,10 +959,9 @@ static int vgic_uaccess_read(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
>>>  	return 0;
>>>  }
>>>  
>>> -static int vgic_uaccess_write(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
>>> +static int vgic_uaccess_write(struct kvm_vcpu *vcpu, struct vgic_io_device *iodev,
>>>  			      gpa_t addr, const u32 *val)
>>>  {
>>> -	struct vgic_io_device *iodev = kvm_to_vgic_iodev(dev);
>>>  	const struct vgic_register_region *region;
>>>  	struct kvm_vcpu *r_vcpu;
>>>  
>>> @@ -986,9 +984,9 @@ int vgic_uaccess(struct kvm_vcpu *vcpu, struct vgic_io_device *dev,
>>>  		 bool is_write, int offset, u32 *val)
>>>  {
>>>  	if (is_write)
>>> -		return vgic_uaccess_write(vcpu, &dev->dev, offset, val);
>>> +		return vgic_uaccess_write(vcpu, dev, offset, val);
>>>  	else
>>> -		return vgic_uaccess_read(vcpu, &dev->dev, offset, val);
>>> +		return vgic_uaccess_read(vcpu, dev, offset, val);
>>>  }
>>>  
>>>  static int dispatch_mmio_read(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
>> _______________________________________________
>> kvmarm mailing list
>> kvmarm@lists.cs.columbia.edu
>> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
