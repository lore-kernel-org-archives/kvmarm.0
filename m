Return-Path: <SRS0=Wnhb=5E=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDC66C4332B
	for <kvmarm@archiver.kernel.org>; Thu, 19 Mar 2020 10:57:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5A6F020753
	for <kvmarm@archiver.kernel.org>; Thu, 19 Mar 2020 10:57:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="LOf17CNu"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5A6F020753
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 118184A500;
	Thu, 19 Mar 2020 06:57:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id w-9JZP8A6axn; Thu, 19 Mar 2020 06:57:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ABA0D4A578;
	Thu, 19 Mar 2020 06:57:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F4C94A4CD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Mar 2020 06:57:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ALYsVnHKd+IH for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Mar 2020 06:57:34 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4583A4A4A3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Mar 2020 06:57:34 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 223D020752;
 Thu, 19 Mar 2020 10:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1584615453;
 bh=uHx+Br1aMgWnaInx45PzVj4K7vit7la5TgFfqUwGJvA=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=LOf17CNugvPH2Y2uD9Tv74rrJWdl7xOpeMe/roOkwkNQdPLN1/2JREqsMj8iVjP2+
 5pSBYtrmJMarW0a6lyyXniuNlZcLfCB11qjEGpG2KA0NVKkCZaNPMw86Eo7Q+AacOT
 9+QuW7mDJe+HZ14RMb2B07KSMZX6oXoQVEOpnHh0=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jEsrj-00Duvj-FZ; Thu, 19 Mar 2020 10:57:31 +0000
MIME-Version: 1.0
Date: Thu, 19 Mar 2020 10:57:31 +0000
From: Marc Zyngier <maz@kernel.org>
To: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v5 15/23] irqchip/gic-v4.1: Add VSGI property setup
In-Reply-To: <edfc4aa0-3e96-4fb2-731e-76a284c8ce17@redhat.com>
References: <20200304203330.4967-1-maz@kernel.org>
 <20200304203330.4967-16-maz@kernel.org>
 <edfc4aa0-3e96-4fb2-731e-76a284c8ce17@redhat.com>
Message-ID: <fc6ae25a16ec8ad27e8853f137cc82a1@kernel.org>
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

On 2020-03-17 10:30, Auger Eric wrote:
> Hi Marc,
> 
> On 3/4/20 9:33 PM, Marc Zyngier wrote:
>> Add the SGI configuration entry point for KVM to use.
>> 
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
>>  drivers/irqchip/irq-gic-v3-its.c   |  2 +-
>>  drivers/irqchip/irq-gic-v4.c       | 13 +++++++++++++
>>  include/linux/irqchip/arm-gic-v4.h |  3 ++-
>>  3 files changed, 16 insertions(+), 2 deletions(-)
>> 
>> diff --git a/drivers/irqchip/irq-gic-v3-its.c 
>> b/drivers/irqchip/irq-gic-v3-its.c
>> index effb0e0b0c9d..b65fba67bd85 100644
>> --- a/drivers/irqchip/irq-gic-v3-its.c
>> +++ b/drivers/irqchip/irq-gic-v3-its.c
>> @@ -4039,7 +4039,7 @@ static int its_sgi_set_vcpu_affinity(struct 
>> irq_data *d, void *vcpu_info)
>>  	struct its_cmd_info *info = vcpu_info;
>> 
>>  	switch (info->cmd_type) {
>> -	case PROP_UPDATE_SGI:
>> +	case PROP_UPDATE_VSGI:
> This change rather belongs to
> [PATCH v5 12/23] irqchip/gic-v4.1: Plumb set_vcpu_affinity SGI 
> callbacks

Absolutely. I messed up a rebase, obviously.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
