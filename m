Return-Path: <SRS0=Wnhb=5E=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01872C4332B
	for <kvmarm@archiver.kernel.org>; Thu, 19 Mar 2020 19:52:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7FA7F2072D
	for <kvmarm@archiver.kernel.org>; Thu, 19 Mar 2020 19:52:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="qkSTKb4u"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7FA7F2072D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E96DA4B0A0;
	Thu, 19 Mar 2020 15:52:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Tvr9y1lXYxES; Thu, 19 Mar 2020 15:52:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D10F64B091;
	Thu, 19 Mar 2020 15:52:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D77B4B08E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Mar 2020 15:52:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4EguR7z1aI9d for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Mar 2020 15:52:45 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 419594A4E5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Mar 2020 15:52:45 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 19B8A206D7;
 Thu, 19 Mar 2020 19:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1584647564;
 bh=UMFRuMeWN29pb4882uOYxANHVABCplgj+koAb1z+2dE=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=qkSTKb4utIarMQd8CDJcC0r66jjv4E6Grgajl0GaZ2NsWZFpgnSsxvNw5d1trhyVf
 m/hfAowH8zpNjr3UjCBAXtljDdoHJ8gci0Db/rlJFpoF62Ej37wABUnI3eg2J6bWh9
 n0uwur1NEU7m4GqQdTUpOURPTJro6MWBSuqnHrzk=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jF1Dd-00E46F-Ts; Thu, 19 Mar 2020 19:52:42 +0000
MIME-Version: 1.0
Date: Thu, 19 Mar 2020 19:52:41 +0000
From: Marc Zyngier <maz@kernel.org>
To: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v5 19/23] KVM: arm64: GICv4.1: Allow SGIs to switch
 between HW and SW interrupts
In-Reply-To: <8a6cf87a-7eee-5502-3b54-093ea0ab5e2d@redhat.com>
References: <20200304203330.4967-1-maz@kernel.org>
 <20200304203330.4967-20-maz@kernel.org>
 <8a6cf87a-7eee-5502-3b54-093ea0ab5e2d@redhat.com>
Message-ID: <877ba4711c6b9456314ea580b9c4718c@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: eric.auger@redhat.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, lorenzo.pieralisi@arm.com, jason@lakedaemon.net,
 rrichter@marvell.com, tglx@linutronix.de, yuzenghui@huawei.com,
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

Hi Eric,

On 2020-03-19 16:16, Auger Eric wrote:
> Hi Marc,
> 
> On 3/4/20 9:33 PM, Marc Zyngier wrote:
>> In order to let a guest buy in the new, active-less SGIs, we
>> need to be able to switch between the two modes.
>> 
>> Handle this by stopping all guest activity, transfer the state
>> from one mode to the other, and resume the guest. Nothing calls
>> this code so far, but a later patch will plug it into the MMIO
>> emulation.
>> 
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
>>  include/kvm/arm_vgic.h      |  3 ++
>>  virt/kvm/arm/vgic/vgic-v4.c | 94 
>> +++++++++++++++++++++++++++++++++++++
>>  virt/kvm/arm/vgic/vgic.h    |  1 +
>>  3 files changed, 98 insertions(+)
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
>> diff --git a/virt/kvm/arm/vgic/vgic-v4.c b/virt/kvm/arm/vgic/vgic-v4.c
>> index c2fcde104ea2..a65dc1c85363 100644
>> --- a/virt/kvm/arm/vgic/vgic-v4.c
>> +++ b/virt/kvm/arm/vgic/vgic-v4.c
>> @@ -97,6 +97,100 @@ static irqreturn_t vgic_v4_doorbell_handler(int 
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
> Is is safe without holding the irq->irq_lock?

The assumption here is that we're coming vgic_v4_configure_vsgis(), 
which starts
by stopping the whole guest. My guess is that it should be safe enough, 
but
maybe you are thinking of something else?

Thanks,

          M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
