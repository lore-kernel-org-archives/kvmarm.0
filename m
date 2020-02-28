Return-Path: <SRS0=iQbv=4Q=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA393C3F2CD
	for <kvmarm@archiver.kernel.org>; Fri, 28 Feb 2020 19:00:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 76506246A2
	for <kvmarm@archiver.kernel.org>; Fri, 28 Feb 2020 19:00:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="iueYwt/h"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 76506246A2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1869A4AF56;
	Fri, 28 Feb 2020 14:00:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9I8SXEjxhaec; Fri, 28 Feb 2020 14:00:13 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 171BD4AF74;
	Fri, 28 Feb 2020 14:00:13 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D9E64AF56
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Feb 2020 14:00:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id a6OvEsJfyiPt for <kvmarm@lists.cs.columbia.edu>;
 Fri, 28 Feb 2020 14:00:10 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1BB034AF44
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Feb 2020 14:00:10 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id E1142246A0;
 Fri, 28 Feb 2020 19:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1582916409;
 bh=OTQM0R8+AqmsjTA1+kFoNN/miGIvet4k8Q05SzlET8A=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=iueYwt/hK/Lmh3fyKvxYlMPRoQLn7yUR7zrtRaDyRPCrdvN2e92LDS7pgV7JEillD
 dGUl0j/uLZ+pDUF6cJDmz0mrd6sUsemwKbebeVGOIYmouAemIiCIxwPN658aici6Mh
 ZboVjhnl13qexpaDHxU8aXHwF6i36NBSfDz/m7Oo=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1j7krn-008pfQ-7f; Fri, 28 Feb 2020 19:00:07 +0000
MIME-Version: 1.0
Date: Fri, 28 Feb 2020 19:00:07 +0000
From: Marc Zyngier <maz@kernel.org>
To: Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v4 09/20] irqchip/gic-v4.1: Plumb set_vcpu_affinity SGI
 callbacks
In-Reply-To: <38b42ac1-5a5d-2f10-2cba-b50f37c7a965@huawei.com>
References: <20200214145736.18550-1-maz@kernel.org>
 <20200214145736.18550-10-maz@kernel.org>
 <38b42ac1-5a5d-2f10-2cba-b50f37c7a965@huawei.com>
Message-ID: <df752712387f706077ecfc9f8605183c@kernel.org>
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

On 2020-02-20 03:37, Zenghui Yu wrote:
> Hi Marc,
> 
> On 2020/2/14 22:57, Marc Zyngier wrote:
>> As for VLPIs, there is a number of configuration bits that cannot
> 
> As for vSGIs,

No, I think this is correct, if a bit ambiguous. What I'm trying to say
here is that vSGIs have the same requirements as vLPIs, in the sense
that some of the configuration aspects cannot be expressed in terms of
the irqchip API.

> 
>> be directly communicated through the normal irqchip API, and we
>> have to use our good old friend set_vcpu_affinity.
>> 
>> This is used to configure group and priority for a given vSGI.
>> 
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
> 
> Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
> 
>> ---
>>   drivers/irqchip/irq-gic-v3-its.c   | 18 ++++++++++++++++++
>>   include/linux/irqchip/arm-gic-v4.h |  5 +++++
>>   2 files changed, 23 insertions(+)
>> 
>> diff --git a/drivers/irqchip/irq-gic-v3-its.c 
>> b/drivers/irqchip/irq-gic-v3-its.c
>> index a9753435c4ff..a2e824eae43f 100644
>> --- a/drivers/irqchip/irq-gic-v3-its.c
>> +++ b/drivers/irqchip/irq-gic-v3-its.c
>> @@ -3969,6 +3969,23 @@ static int its_sgi_get_irqchip_state(struct 
>> irq_data *d,
>>   	return 0;
>>   }
>>   +static int its_sgi_set_vcpu_affinity(struct irq_data *d, void 
>> *vcpu_info)
>> +{
>> +	struct its_vpe *vpe = irq_data_get_irq_chip_data(d);
>> +	struct its_cmd_info *info = vcpu_info;
>> +
>> +	switch (info->cmd_type) {
>> +	case PROP_UPDATE_SGI:
>> +		vpe->sgi_config[d->hwirq].priority = info->priority;
>> +		vpe->sgi_config[d->hwirq].group = info->group;
>> +		its_configure_sgi(d, false);
>> +		return 0;
>> +
>> +	default:
>> +		return -EINVAL;
>> +	}
>> +}
>> +
>>   static struct irq_chip its_sgi_irq_chip = {
>>   	.name			= "GICv4.1-sgi",
>>   	.irq_mask		= its_sgi_mask_irq,
>> @@ -3976,6 +3993,7 @@ static struct irq_chip its_sgi_irq_chip = {
>>   	.irq_set_affinity	= its_sgi_set_affinity,
>>   	.irq_set_irqchip_state	= its_sgi_set_irqchip_state,
>>   	.irq_get_irqchip_state	= its_sgi_get_irqchip_state,
>> +	.irq_set_vcpu_affinity	= its_sgi_set_vcpu_affinity,
>>   };
>>     static int its_sgi_irq_domain_alloc(struct irq_domain *domain,
>> diff --git a/include/linux/irqchip/arm-gic-v4.h 
>> b/include/linux/irqchip/arm-gic-v4.h
>> index 30b4855bf766..a1a9d40266f5 100644
>> --- a/include/linux/irqchip/arm-gic-v4.h
>> +++ b/include/linux/irqchip/arm-gic-v4.h
>> @@ -98,6 +98,7 @@ enum its_vcpu_info_cmd_type {
>>   	SCHEDULE_VPE,
>>   	DESCHEDULE_VPE,
>>   	INVALL_VPE,
>> +	PROP_UPDATE_SGI,
> 
> Maybe better to use 'PROP_UPDATE_VSGI'?

That's indeed better.

Thanks,

          M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
