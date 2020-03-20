Return-Path: <SRS0=NdW8=5F=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3748DC4332B
	for <kvmarm@archiver.kernel.org>; Fri, 20 Mar 2020 10:05:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BE9202076C
	for <kvmarm@archiver.kernel.org>; Fri, 20 Mar 2020 10:05:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="fG3/FshL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BE9202076C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 300EE4A534;
	Fri, 20 Mar 2020 06:05:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9Qv646LkM9Tn; Fri, 20 Mar 2020 06:05:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 113A44AF1F;
	Fri, 20 Mar 2020 06:05:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 54BED4A534
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Mar 2020 06:05:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CeLx4pSsTqJo for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Mar 2020 06:05:24 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1F1884A3BF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Mar 2020 06:05:24 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 0226120739;
 Fri, 20 Mar 2020 10:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1584698723;
 bh=xLCoBe0k1tJ3NSXx1P/PDSVPbSYu5y2TzULMMiyBlTg=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=fG3/FshLRVkUpD6f8kWzo2ZRvJ1Hf8TYHFGIVvQTGCajdFE86lnw5LcRvB+oaiwhz
 LIpRK5YowcZKkauW9vpsoRF0N5qgJXofZdNSufOEynagyl2fv09fg4W9jMxYhRQq8k
 PDi+QMvsd3CnTUcHcBthjBlrGzlCLFculZqkoH7w=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jFEWn-00ECvU-B0; Fri, 20 Mar 2020 10:05:21 +0000
MIME-Version: 1.0
Date: Fri, 20 Mar 2020 10:05:21 +0000
From: Marc Zyngier <maz@kernel.org>
To: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v5 18/23] KVM: arm64: GICv4.1: Add direct injection
 capability to SGI registers
In-Reply-To: <06705d70-0f99-e719-af52-1a5f778562d8@redhat.com>
References: <20200304203330.4967-1-maz@kernel.org>
 <20200304203330.4967-19-maz@kernel.org>
 <06705d70-0f99-e719-af52-1a5f778562d8@redhat.com>
Message-ID: <3f7094ffd77a6615d7179be94dbecc60@kernel.org>
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

On 2020-03-20 08:11, Auger Eric wrote:
> Hi Marc,
> On 3/4/20 9:33 PM, Marc Zyngier wrote:
>> Most of the GICv3 emulation code that deals with SGIs now has to be
>> aware of the v4.1 capabilities in order to benefit from it.
>> 
>> Add such support, keyed on the interrupt having the hw flag set and
>> being a SGI.
>> 
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
>>  virt/kvm/arm/vgic/vgic-mmio-v3.c | 15 +++++-
>>  virt/kvm/arm/vgic/vgic-mmio.c    | 88 
>> ++++++++++++++++++++++++++++++--
>>  2 files changed, 96 insertions(+), 7 deletions(-)
>> 

[...]

>> @@ -113,7 +125,21 @@ void vgic_mmio_write_senable(struct kvm_vcpu 
>> *vcpu,
>>  		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
>> 
>>  		raw_spin_lock_irqsave(&irq->irq_lock, flags);
>> -		if (vgic_irq_is_mapped_level(irq)) {
>> +		if (irq->hw && vgic_irq_is_sgi(irq->intid)) {
>> +			if (!irq->enabled) {
>> +				struct irq_data *data;
>> +
>> +				irq->enabled = true;
>> +				data = &irq_to_desc(irq->host_irq)->irq_data;
>> +				while (irqd_irq_disabled(data))
>> +					enable_irq(irq->host_irq);
> could you explain me why the while() is requested?

Ah, interesting question: disable_irq() (and its variants) can nest. 
This
means that if you have done two disable_irq(), you must do two 
enable_irq()
to get back to the interrupt being enabled.

The locking should ensure that this nesting doesn't happen, but I'm 
paranoid
(see the GICv4.0 doorbell handling). It also makes it easier to reason 
about
the initial state.

[...]

> Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks!

          M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
