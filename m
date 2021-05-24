Return-Path: <SRS0=3L6A=KT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0731DC04FF3
	for <kvmarm@archiver.kernel.org>; Mon, 24 May 2021 17:48:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6DD9161403
	for <kvmarm@archiver.kernel.org>; Mon, 24 May 2021 17:48:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6DD9161403
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0EA4C4B156;
	Mon, 24 May 2021 13:48:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sHdmeiHWeuRo; Mon, 24 May 2021 13:48:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B1E94B14C;
	Mon, 24 May 2021 13:48:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 52C894B133
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 May 2021 13:48:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VvqNVbCgneX9 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 24 May 2021 13:48:16 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5C3784B127
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 May 2021 13:48:16 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 69481613FC;
 Mon, 24 May 2021 17:48:15 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1llEgX-003Ixg-Iu; Mon, 24 May 2021 18:48:13 +0100
MIME-Version: 1.0
Date: Mon, 24 May 2021 18:48:13 +0100
From: Marc Zyngier <maz@kernel.org>
To: Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v3 7/9] KVM: arm64: timer: Refactor IRQ configuration
In-Reply-To: <9f28e15b-26d0-5d3e-8f0e-8026ece536e0@huawei.com>
References: <20210510134824.1910399-1-maz@kernel.org>
 <20210510134824.1910399-8-maz@kernel.org>
 <9f28e15b-26d0-5d3e-8f0e-8026ece536e0@huawei.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <fe39ba008d6bfad395e1b12b51f75681@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, kernel-team@android.com,
 marcan@marcan.st
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Hector Martin <marcan@marcan.st>, kernel-team@android.com,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
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

On 2021-05-14 13:46, Zenghui Yu wrote:
> On 2021/5/10 21:48, Marc Zyngier wrote:
>> As we are about to add some more things to the timer IRQ
>> configuration, move this code out of the main timer init code
>> into its own set of functions.
>> 
>> No functional changes.
>> 
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
>>  arch/arm64/kvm/arch_timer.c | 61 
>> ++++++++++++++++++++++---------------
>>  1 file changed, 37 insertions(+), 24 deletions(-)
>> 
>> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
>> index e2288b6bf435..7fa4f446456a 100644
>> --- a/arch/arm64/kvm/arch_timer.c
>> +++ b/arch/arm64/kvm/arch_timer.c
>> @@ -973,6 +973,39 @@ static int kvm_timer_dying_cpu(unsigned int cpu)
>>  	return 0;
>>  }
>>  +static void kvm_irq_fixup_flags(unsigned int virq, u32 *flags)
>> +{
>> +	*flags = irq_get_trigger_type(virq);
>> +	if (*flags != IRQF_TRIGGER_HIGH && *flags != IRQF_TRIGGER_LOW) {
>> +		kvm_err("Invalid trigger for timer IRQ%d, assuming level low\n",
>> +			virq);
>> +		*flags = IRQF_TRIGGER_LOW;
>> +	}
>> +}
>> +
>> +static int kvm_irq_init(struct arch_timer_kvm_info *info)
>> +{
>> +	struct irq_domain *domain = NULL;
>> +	struct fwnode_handle *fwnode;
>> +	struct irq_data *data;
> 
> Shouldn't this belong to patch #8?

Yup. Now moved.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
