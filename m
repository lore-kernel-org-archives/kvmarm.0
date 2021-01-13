Return-Path: <SRS0=/ONs=GQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A555C433E0
	for <kvmarm@archiver.kernel.org>; Wed, 13 Jan 2021 17:18:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7206A23441
	for <kvmarm@archiver.kernel.org>; Wed, 13 Jan 2021 17:18:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7206A23441
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F33F64B1C5;
	Wed, 13 Jan 2021 12:18:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xvjBoDkeFwJm; Wed, 13 Jan 2021 12:18:33 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D6D114B1B4;
	Wed, 13 Jan 2021 12:18:32 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E77E64B1C9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Jan 2021 12:18:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0R4x1kH1aL7A for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Jan 2021 12:18:31 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0833D4B1C0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Jan 2021 12:18:31 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1610558310;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=RtqK698Gz2UPmkSrQZ+1pqM9fJn9xrCeQ0Ydv7oehh8=;
 b=MLr4yLzYn4PgxVXssb1JMZ4HDk5azJpVvlu5qvQAAJzUiILPnrgySN0nnkiVL+fT0MsrKp
 NFxhVbYZjTC7kL3zzrU4mB0np2ZUC26QYfynYYBM49c3K8c+XdBOwHuEw0pgB1Q+9RQdcG
 VlZD7RGxwEzTL9vD/TddYUcbPF12gRg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-551-wnXSPicHN36julsnJPTxOA-1; Wed, 13 Jan 2021 12:18:26 -0500
X-MC-Unique: wnXSPicHN36julsnJPTxOA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3243F1081B2F;
 Wed, 13 Jan 2021 17:18:25 +0000 (UTC)
Received: from [10.36.114.165] (ovpn-114-165.ams2.redhat.com [10.36.114.165])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7812660BF1;
 Wed, 13 Jan 2021 17:18:22 +0000 (UTC)
Subject: Re: [PATCH 2/9] KVM: arm64: Fix KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION
 read
To: Alexandru Elisei <alexandru.elisei@arm.com>, eric.auger.pro@gmail.com,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, maz@kernel.org, drjones@redhat.com
References: <20201212185010.26579-1-eric.auger@redhat.com>
 <20201212185010.26579-3-eric.auger@redhat.com>
 <888cf519-8c0e-f781-98a1-86594bdfacb1@arm.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <ccc874c3-75a9-a2b8-1e9d-b762c0f8d6ad@redhat.com>
Date: Wed, 13 Jan 2021 18:18:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <888cf519-8c0e-f781-98a1-86594bdfacb1@arm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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

On 1/6/21 6:12 PM, Alexandru Elisei wrote:
> Hi Eric,
> 
> The patch looks correct to me. kvm_vgic_addr() masks out all the bits except index
> from addr, so we don't need to do it in vgic_get_common_attr():
> 
> Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
> 
> One nitpick below.
> 
> On 12/12/20 6:50 PM, Eric Auger wrote:
>> The doc says:
>> "The characteristics of a specific redistributor region can
>>  be read by presetting the index field in the attr data.
>>  Only valid for KVM_DEV_TYPE_ARM_VGIC_V3"
>>
>> Unfortunately the existing code fails to read the input attr data
>> and thus the index always is 0.
> 
> addr is allocated on the stack, I don't think it will always be 0.
I removed this statement in the commit message. Thanks!

Eric
> 
> Thanks,
> Alex
>>
>> Fixes: 04c110932225 ("KVM: arm/arm64: Implement KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION")
>> Cc: stable@vger.kernel.org#v4.17+
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> ---
>>  arch/arm64/kvm/vgic/vgic-kvm-device.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
>> index 44419679f91a..2f66cf247282 100644
>> --- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
>> +++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
>> @@ -226,6 +226,9 @@ static int vgic_get_common_attr(struct kvm_device *dev,
>>  		u64 addr;
>>  		unsigned long type = (unsigned long)attr->attr;
>>  
>> +		if (copy_from_user(&addr, uaddr, sizeof(addr)))
>> +			return -EFAULT;
>> +
>>  		r = kvm_vgic_addr(dev->kvm, type, &addr, false);
>>  		if (r)
>>  			return (r == -ENODEV) ? -ENXIO : r;
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
