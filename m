Return-Path: <SRS0=fBez=57=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6988C2BA19
	for <kvmarm@archiver.kernel.org>; Wed, 15 Apr 2020 13:27:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 78C962076D
	for <kvmarm@archiver.kernel.org>; Wed, 15 Apr 2020 13:27:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="yOPu9FhT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 78C962076D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2300C4B14D;
	Wed, 15 Apr 2020 09:27:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id W4z7Q+eFWIMb; Wed, 15 Apr 2020 09:27:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 06E894B14F;
	Wed, 15 Apr 2020 09:27:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 968704B14A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Apr 2020 09:27:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hedDKa5IvW-M for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Apr 2020 09:27:24 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 53BD94B110
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Apr 2020 09:27:24 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 4123120575;
 Wed, 15 Apr 2020 13:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1586957243;
 bh=nu0zhwK3O3WL827GPYiUQRD9DU9/FqJbgDVCwstEBdU=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=yOPu9FhTgupWBGSfd2gsYbyj9oQOwVK/uGMgIR/2NuiD7gmneRJUM5ZEkmRkpYzQX
 58Bc1zMC1IBIwLacgGc2H2bX4DsrLS1m7y1j7Fljz5gjn888++E7BJdpqvqicjkQBL
 cCJaqrwtTO5b1pzjPB5atE1SomNqDS1y4f9E/X20=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jOi4X-003Xfd-JJ; Wed, 15 Apr 2020 14:27:21 +0100
MIME-Version: 1.0
Date: Wed, 15 Apr 2020 14:27:21 +0100
From: Marc Zyngier <maz@kernel.org>
To: Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 1/3] KVM: arm: vgic: Synchronize the whole guest on
 GIC{D,R}_I{S,C}ACTIVER read
In-Reply-To: <190b57e6-0ac5-63bb-57d8-5bab2aea0b2c@huawei.com>
References: <20200414103517.2824071-1-maz@kernel.org>
 <20200414103517.2824071-2-maz@kernel.org>
 <190b57e6-0ac5-63bb-57d8-5bab2aea0b2c@huawei.com>
Message-ID: <de0b9e06fe77238f18ffd8f1bf2f870e@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, eric.auger@redhat.com,
 Andre.Przywara@arm.com, julien@xen.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Julien Grall <julien@xen.org>, kvm@vger.kernel.org,
 Andre Przywara <Andre.Przywara@arm.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Hi Zenghui,

On 2020-04-15 14:15, Zenghui Yu wrote:
> Hi Marc,
> 
> On 2020/4/14 18:35, Marc Zyngier wrote:
>> When a guest tries to read the active state of its interrupts,
>> we currently just return whatever state we have in memory. This
>> means that if such an interrupt lives in a List Register on another
>> CPU, we fail to obsertve the latest active state for this interrupt.
>> 
>> In order to remedy this, stop all the other vcpus so that they exit
>> and we can observe the most recent value for the state.
>> 
>> Reported-by: Julien Grall <julien@xen.org>
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
>>   virt/kvm/arm/vgic/vgic-mmio-v2.c |   4 +-
>>   virt/kvm/arm/vgic/vgic-mmio-v3.c |   4 +-
>>   virt/kvm/arm/vgic/vgic-mmio.c    | 100 
>> ++++++++++++++++++++-----------
>>   virt/kvm/arm/vgic/vgic-mmio.h    |   3 +
>>   4 files changed, 71 insertions(+), 40 deletions(-)
>> 
>> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c 
>> b/virt/kvm/arm/vgic/vgic-mmio-v2.c
>> index 5945f062d749..d63881f60e1a 100644
>> --- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
>> +++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
>> @@ -422,11 +422,11 @@ static const struct vgic_register_region 
>> vgic_v2_dist_registers[] = {
>>   		VGIC_ACCESS_32bit),
>>   	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ACTIVE_SET,
>>   		vgic_mmio_read_active, vgic_mmio_write_sactive,
>> -		NULL, vgic_mmio_uaccess_write_sactive, 1,
>> +		vgic_uaccess_read_active, vgic_mmio_uaccess_write_sactive, 1,
>>   		VGIC_ACCESS_32bit),
>>   	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ACTIVE_CLEAR,
>>   		vgic_mmio_read_active, vgic_mmio_write_cactive,
>> -		NULL, vgic_mmio_uaccess_write_cactive, 1,
>> +		vgic_uaccess_read_active, vgic_mmio_uaccess_write_cactive, 1,
>>   		VGIC_ACCESS_32bit),
>>   	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_PRI,
>>   		vgic_mmio_read_priority, vgic_mmio_write_priority, NULL, NULL,
>> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c 
>> b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> index e72dcc454247..77c8ba1a2535 100644
>> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> @@ -553,11 +553,11 @@ static const struct vgic_register_region 
>> vgic_v3_dist_registers[] = {
>>   		VGIC_ACCESS_32bit),
>>   	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ISACTIVER,
>>   		vgic_mmio_read_active, vgic_mmio_write_sactive,
>> -		NULL, vgic_mmio_uaccess_write_sactive, 1,
>> +		vgic_uaccess_read_active, vgic_mmio_uaccess_write_sactive, 1,
>>   		VGIC_ACCESS_32bit),
>>   	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ICACTIVER,
>>   		vgic_mmio_read_active, vgic_mmio_write_cactive,
>> -		NULL, vgic_mmio_uaccess_write_cactive,
>> +		vgic_uaccess_read_active, vgic_mmio_uaccess_write_cactive,
>>   		1, VGIC_ACCESS_32bit),
>>   	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_IPRIORITYR,
>>   		vgic_mmio_read_priority, vgic_mmio_write_priority, NULL, NULL,
> 
> Shouldn't we also set this uaccess_read cb for GICR_I{S,C}ACTIVER0?

Duh. Yes, of course...

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
