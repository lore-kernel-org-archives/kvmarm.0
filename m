Return-Path: <SRS0=Wnhb=5E=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52C85C43332
	for <kvmarm@archiver.kernel.org>; Thu, 19 Mar 2020 12:10:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DB5D620722
	for <kvmarm@archiver.kernel.org>; Thu, 19 Mar 2020 12:10:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="VkE/6xNg"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DB5D620722
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 680454B09B;
	Thu, 19 Mar 2020 08:10:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id If5Um1HWrJoy; Thu, 19 Mar 2020 08:10:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4837B4B089;
	Thu, 19 Mar 2020 08:10:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AE0C64B089
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Mar 2020 08:10:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id revYI2+E8CbL for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Mar 2020 08:10:14 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 668524A4CD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Mar 2020 08:10:14 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 2C90F20663;
 Thu, 19 Mar 2020 12:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1584619813;
 bh=6rNervqAIpsCbSWbaL/JCxlPQb2xA9V11QRKwIxvVgM=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=VkE/6xNgNrrioz0QRL3zM5ILQU3OSG57GIjlZZrKDGhV/HVFLdz56qJBc3Y579LxN
 YJiAgzgnKU+1JFICbzzROJb4RBh3sc7b3ZVObwQXYIrmOddLbmPeJRQFc+j3Qnyv5i
 +f6MY4lnf0La6fi+k75jfCDTuaKdSxcKPM8M8/OY=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jEu03-00DvjA-9X; Thu, 19 Mar 2020 12:10:11 +0000
MIME-Version: 1.0
Date: Thu, 19 Mar 2020 12:10:11 +0000
From: Marc Zyngier <maz@kernel.org>
To: Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v5 20/23] KVM: arm64: GICv4.1: Plumb SGI implementation
 selection in the distributor
In-Reply-To: <72832f51-bbde-8502-3e03-189ac20a0143@huawei.com>
References: <20200304203330.4967-1-maz@kernel.org>
 <20200304203330.4967-21-maz@kernel.org>
 <72832f51-bbde-8502-3e03-189ac20a0143@huawei.com>
Message-ID: <4a06fae9c93e10351276d173747d17f4@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, lorenzo.pieralisi@arm.com, jason@lakedaemon.net,
 rrichter@marvell.com, tglx@linutronix.de, eric.auger@redhat.com,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Jason Cooper <jason@lakedaemon.net>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Robert Richter <rrichter@marvell.com>,
 Thomas Gleixner <tglx@linutronix.de>, kvmarm@lists.cs.columbia.edu,
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

On 2020-03-18 06:34, Zenghui Yu wrote:
> Hi Marc,
> 
> On 2020/3/5 4:33, Marc Zyngier wrote:
>> The GICv4.1 architecture gives the hypervisor the option to let
>> the guest choose whether it wants the good old SGIs with an
>> active state, or the new, HW-based ones that do not have one.
>> 
>> For this, plumb the configuration of SGIs into the GICv3 MMIO
>> handling, present the GICD_TYPER2.nASSGIcap to the guest,
>> and handle the GICD_CTLR.nASSGIreq setting.
>> 
>> In order to be able to deal with the restore of a guest, also
>> apply the GICD_CTLR.nASSGIreq setting at first run so that we
>> can move the restored SGIs to the HW if that's what the guest
>> had selected in a previous life.
> 
> I'm okay with the restore path.  But it seems that we still fail to
> save the pending state of vSGI - software pending_latch of HW-based
> vSGIs will not be updated (and always be false) because we directly
> inject them through ITS, so vgic_v3_uaccess_read_pending() can't
> tell the correct pending state to user-space (the correct one should
> be latched in HW).
> 
> It would be good if we can sync the hardware state into pending_latch
> at an appropriate time (just before save), but not sure if we can...

The problem is to find the "appropriate time". It would require to 
define
a point in the save sequence where we transition the state from HW to
SW. I'm not keen on adding more state than we already have.

But what we can do is to just ask the HW to give us the right state
on userspace access, at all times. How about this:

diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c 
b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index 48fd9fc229a2..281fe7216c59 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -305,8 +305,18 @@ static unsigned long 
vgic_v3_uaccess_read_pending(struct kvm_vcpu *vcpu,
  	 */
  	for (i = 0; i < len * 8; i++) {
  		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
+		bool state = irq->pending_latch;

-		if (irq->pending_latch)
+		if (irq->hw && vgic_irq_is_sgi(irq->intid)) {
+			int err;
+
+			err = irq_get_irqchip_state(irq->host_irq,
+						    IRQCHIP_STATE_PENDING,
+						    &state);
+			WARN_ON(err);
+		}
+
+		if (state)
  			value |= (1U << i);

  		vgic_put_irq(vcpu->kvm, irq);

I can add this to "KVM: arm64: GICv4.1: Add direct injection capability 
to SGI registers".

> 
>> 
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
>>   virt/kvm/arm/vgic/vgic-mmio-v3.c | 48 
>> ++++++++++++++++++++++++++++++--
>>   virt/kvm/arm/vgic/vgic-v3.c      |  2 ++
>>   2 files changed, 48 insertions(+), 2 deletions(-)
>> 
>> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c 
>> b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> index de89da76a379..442f3b8c2559 100644
>> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> @@ -3,6 +3,7 @@
>>    * VGICv3 MMIO handling functions
>>    */
>>   +#include <linux/bitfield.h>
>>   #include <linux/irqchip/arm-gic-v3.h>
>>   #include <linux/kvm.h>
>>   #include <linux/kvm_host.h>
>> @@ -70,6 +71,8 @@ static unsigned long vgic_mmio_read_v3_misc(struct 
>> kvm_vcpu *vcpu,
>>   		if (vgic->enabled)
>>   			value |= GICD_CTLR_ENABLE_SS_G1;
>>   		value |= GICD_CTLR_ARE_NS | GICD_CTLR_DS;
>> +		if (kvm_vgic_global_state.has_gicv4_1 && vgic->nassgireq)
> 
> Looking at how we handle the GICD_CTLR.nASSGIreq setting, I think
> "nassgireq==true" already indicates "has_gicv4_1==true".  So this
> can be simplified.

Indeed. I've now dropped the has_gicv4.1 check.

> But I wonder that should we use nassgireq to *only* keep track what
> the guest had written into the GICD_CTLR.nASSGIreq.  If not, we may
> lose the guest-request bit after migration among hosts with different
> has_gicv4_1 settings.

I'm unsure of what you're suggesting here. If userspace tries to set
GICD_CTLR.nASSGIreq on a non-4.1 host, this bit will not latch.
Userspace can check that at restore time. Or we could fail the
userspace write, which is a bit odd (the bit is otherwise RES0).

Could you clarify your proposal?

> The remaining patches all look good to me :-). I will wait for you to
> confirm these two concerns.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
