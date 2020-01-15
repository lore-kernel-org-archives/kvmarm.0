Return-Path: <SRS0=diMM=3E=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4758C33CB1
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jan 2020 13:17:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5E5BA2084D
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jan 2020 13:17:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="P3hHTqIJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5E5BA2084D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D8BA24B137;
	Wed, 15 Jan 2020 08:17:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cRmqRpae9gB2; Wed, 15 Jan 2020 08:17:33 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C5CFC4B141;
	Wed, 15 Jan 2020 08:17:33 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B9F074B137
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jan 2020 08:17:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id a7AfV6azdRny for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Jan 2020 08:17:28 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DCE2A4B090
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jan 2020 08:17:27 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 834FE2084D;
 Wed, 15 Jan 2020 13:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1579094246;
 bh=//qznMGw/pxNvBtv/o96KOZTY0ZVAWOVKTbjHmr/Db0=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=P3hHTqIJ1elb0u7PAj2RTmURQSF5yBhKJH2rJSYUWFly+B5C1JAE+hjfPFKncEQxW
 DSSYZU0kFnfuYffG8kQqiPuk8vr649ADwIAf0CYgEeCQRGr9xMrX1upp20E5u4RE2P
 n7FpV4LopngSFeOfLUjNCGNPIfgSU+FXjcSQCEA0=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1iriY0-00085i-AJ; Wed, 15 Jan 2020 13:17:24 +0000
MIME-Version: 1.0
Date: Wed, 15 Jan 2020 13:17:24 +0000
From: Marc Zyngier <maz@kernel.org>
To: Shaokun Zhang <zhangshaokun@hisilicon.com>
Subject: Re: [PATCH v3 29/32] KVM: arm64: GICv4.1: Allow SGIs to switch
 between HW and SW interrupts
In-Reply-To: <cc5fe20c-7a0c-c266-e78a-2a85963ab20f@hisilicon.com>
References: <20191224111055.11836-1-maz@kernel.org>
 <20191224111055.11836-30-maz@kernel.org>
 <cc5fe20c-7a0c-c266-e78a-2a85963ab20f@hisilicon.com>
Message-ID: <c5d057291e01a1d0b02290504f8ed048@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.8
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: zhangshaokun@hisilicon.com, kvmarm@lists.cs.columbia.edu,
 linux-kernel@vger.kernel.org, eric.auger@redhat.com, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, tglx@linutronix.de,
 jason@lakedaemon.net, lorenzo.pieralisi@arm.com, Andrew.Murray@arm.com,
 yuzenghui@huawei.com, rrichter@marvell.com, tangnianyao@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org,
 Robert Richter <rrichter@marvell.com>, Thomas Gleixner <tglx@linutronix.de>,
 kvmarm@lists.cs.columbia.edu
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

On 2020-01-15 02:49, Shaokun Zhang wrote:
> Hi Marc, [This is from Nianyao]
> 
> On 2019/12/24 19:10, Marc Zyngier wrote:
>> In order to let a guest buy in the new, active-less SGIs, we
>> need to be able to switch between the two modes.
>> 
>> Handle this by stopping all guest activity, transfer the state
>> from one mode to the other, and resume the guest.
>> 
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
>>  include/kvm/arm_vgic.h      |  3 ++
>>  virt/kvm/arm/vgic/vgic-v3.c |  2 +
>>  virt/kvm/arm/vgic/vgic-v4.c | 96 
>> +++++++++++++++++++++++++++++++++++++
>>  virt/kvm/arm/vgic/vgic.h    |  1 +
>>  4 files changed, 102 insertions(+)
>> 
>> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
>> index 63457908c9c4..69f4164d6477 100644
>> --- a/include/kvm/arm_vgic.h
>> +++ b/include/kvm/arm_vgic.h
>> @@ -231,6 +231,9 @@ struct vgic_dist {
>>  	/* distributor enabled */
>>  	bool			enabled;
>> 
>> +	/* Wants SGIs without active state */
>> +	bool			nassgireq;
>> +
>>  	struct vgic_irq		*spis;
>> 
>>  	struct vgic_io_device	dist_iodev;
>> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
>> index c2fdea201747..c79a251c4974 100644
>> --- a/virt/kvm/arm/vgic/vgic-v3.c
>> +++ b/virt/kvm/arm/vgic/vgic-v3.c
>> @@ -540,6 +540,8 @@ int vgic_v3_map_resources(struct kvm *kvm)
>>  		goto out;
>>  	}
>> 
>> +	if (kvm_vgic_global_state.has_gicv4_1)
>> +		vgic_v4_configure_vsgis(kvm);
>>  	dist->ready = true;
>> 
>>  out:
>> diff --git a/virt/kvm/arm/vgic/vgic-v4.c b/virt/kvm/arm/vgic/vgic-v4.c
>> index c2fcde104ea2..063785fd2dc7 100644
>> --- a/virt/kvm/arm/vgic/vgic-v4.c
>> +++ b/virt/kvm/arm/vgic/vgic-v4.c
>> @@ -97,6 +97,102 @@ static irqreturn_t vgic_v4_doorbell_handler(int 
>> irq, void *info)
>>  	return IRQ_HANDLED;
>>  }
>> 
>> +static void vgic_v4_sync_sgi_config(struct its_vpe *vpe, struct 
>> vgic_irq *irq)
>> +{
>> +	vpe->sgi_config[irq->intid].enabled	= irq->enabled;
>> +	vpe->sgi_config[irq->intid].group 	= irq->group;
>> +	vpe->sgi_config[irq->intid].priority	= irq->priority;
>> +}
>> +
>> +static void vgic_v4_enable_vsgis(struct kvm_vcpu *vcpu)
>> +{
>> +	struct its_vpe *vpe = &vcpu->arch.vgic_cpu.vgic_v3.its_vpe;
>> +	int i;
>> +
>> +	/*
>> +	 * With GICv4.1, every virtual SGI can be directly injected. So
>> +	 * let's pretend that they are HW interrupts, tied to a host
>> +	 * IRQ. The SGI code will do its magic.
>> +	 */
>> +	for (i = 0; i < VGIC_NR_SGIS; i++) {
>> +		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, i);
>> +		struct irq_desc *desc;
>> +		int ret;
>> +
>> +		if (irq->hw) {
>> +			vgic_put_irq(vcpu->kvm, irq);
>> +			continue;
>> +		}
>> +
>> +		irq->hw = true;
>> +		irq->host_irq = irq_find_mapping(vpe->sgi_domain, i);
> 
> I think we need to check whether irq_find_mapping returns 0.

Why? its_alloc_vcpu_sgis() performs the allocation of all 16 SGIs
in one go. If that fails, we should error out. Conversely, we're
guaranteed that we have a mapping if it hasn't failed.

> 
>> +		vgic_v4_sync_sgi_config(vpe, irq);
>> +		/*
>> +		 * SGIs are initialised as disabled. Enable them if
>> +		 * required by the rest of the VGIC init code.
>> +		 */
>> +		desc = irq_to_desc(irq->host_irq);
>> +		ret = irq_domain_activate_irq(irq_desc_get_irq_data(desc),
>> +					      false);
> 
> If irq->host_irq is not valid , in irq_domain_activate_irq, it will
> trigger NULL pointer dereference in host kernel.
> I meet a problem here. When hw support GIC4.1, and host kernel is 
> started with
> kvm-arm.vgic_v4_enable=0, starting a virtual machine will trigger NULL 
> pointer
> dereference in host. The following is error info:

[...]

But the problem here is that we're trying to use GICv4.1 even if GICv4
is disabled. I don't think there is a point in trying to sidestep this
locally if we're doing the wrong thing at top-level, which seems to be
the case.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
