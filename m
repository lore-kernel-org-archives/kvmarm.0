Return-Path: <SRS0=JLBt=LF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31839C48BE0
	for <kvmarm@archiver.kernel.org>; Fri, 11 Jun 2021 16:58:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A4069613C3
	for <kvmarm@archiver.kernel.org>; Fri, 11 Jun 2021 16:58:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A4069613C3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 20ED34B0CE;
	Fri, 11 Jun 2021 12:58:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZNuXyIRJzfbw; Fri, 11 Jun 2021 12:58:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A1674B0CD;
	Fri, 11 Jun 2021 12:58:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 85DE44B0C5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Jun 2021 12:58:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lp5m6v0XPtul for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Jun 2021 12:58:32 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5AAE84B0BA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Jun 2021 12:58:32 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F31CFD6E;
 Fri, 11 Jun 2021 09:58:31 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 81E6B3F719;
 Fri, 11 Jun 2021 09:58:30 -0700 (PDT)
Subject: Re: [PATCH v4 3/9] KVM: arm64: vgic: Be tolerant to the lack of
 maintenance interrupt masking
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
References: <20210601104005.81332-1-maz@kernel.org>
 <20210601104005.81332-4-maz@kernel.org>
 <a02e67c6-fceb-ed6a-fc73-8649d8d18dd8@arm.com>
Message-ID: <b0b941ae-cd22-4454-a987-04baf5473c5e@arm.com>
Date: Fri, 11 Jun 2021 17:59:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <a02e67c6-fceb-ed6a-fc73-8649d8d18dd8@arm.com>
Content-Language: en-US
Cc: Hector Martin <marcan@marcan.st>, kernel-team@android.com
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

Hi Marc,

On 6/11/21 5:38 PM, Alexandru Elisei wrote:
> Hi Marc,
>
> On 6/1/21 11:39 AM, Marc Zyngier wrote:
>> As it turns out, not all the interrupt controllers are able to
>> expose a vGIC maintenance interrupt that can be independently
>> enabled/disabled.
>>
>> And to be fair, it doesn't really matter as all we require is
>> for the interrupt to kick us out of guest mode out way or another.
>>
>> To that effect, add gic_kvm_info.no_maint_irq_mask for an interrupt
>> controller to advertise the lack of masking.
>>
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
>>  arch/arm64/kvm/vgic/vgic-init.c       | 8 +++++++-
>>  include/linux/irqchip/arm-vgic-info.h | 2 ++
>>  2 files changed, 9 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
>> index 2fdb65529594..6752d084934d 100644
>> --- a/arch/arm64/kvm/vgic/vgic-init.c
>> +++ b/arch/arm64/kvm/vgic/vgic-init.c
>> @@ -519,12 +519,15 @@ void kvm_vgic_init_cpu_hardware(void)
>>   */
>>  int kvm_vgic_hyp_init(void)
>>  {
>> +	bool has_mask;
>>  	int ret;
>>  
>>  	if (!gic_kvm_info)
>>  		return -ENODEV;
>>  
>> -	if (!gic_kvm_info->maint_irq) {
>> +	has_mask = !gic_kvm_info->no_maint_irq_mask;
> This double negative is pretty awkward, I suppose this was done to avoid changes
> to the gic drivers, because the default value is 0 (false). Just an idea, maybe
> renaming it to maint_irq_unmaskable would be more readable?

Actually, after another look, the current name stopped looking awkward to me.

Thanks,

Alex

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
