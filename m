Return-Path: <SRS0=n2ZT=KJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78ABFC433B4
	for <kvmarm@archiver.kernel.org>; Fri, 14 May 2021 12:46:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D1C166145D
	for <kvmarm@archiver.kernel.org>; Fri, 14 May 2021 12:46:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D1C166145D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 36DCE4B98C;
	Fri, 14 May 2021 08:46:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mZggTM18NIQK; Fri, 14 May 2021 08:46:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1ECF54B978;
	Fri, 14 May 2021 08:46:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A5E5C4B974
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 May 2021 08:46:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7VBbG7sFHVhf for <kvmarm@lists.cs.columbia.edu>;
 Fri, 14 May 2021 08:46:24 -0400 (EDT)
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 00F0A4B90E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 May 2021 08:46:23 -0400 (EDT)
Received: from dggems705-chm.china.huawei.com (unknown [172.30.72.60])
 by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FhSrf1FYnzmWKt;
 Fri, 14 May 2021 20:44:02 +0800 (CST)
Received: from dggema764-chm.china.huawei.com (10.1.198.206) by
 dggems705-chm.china.huawei.com (10.3.19.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Fri, 14 May 2021 20:46:14 +0800
Received: from [10.174.185.179] (10.174.185.179) by
 dggema764-chm.china.huawei.com (10.1.198.206) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 14 May 2021 20:46:13 +0800
Subject: Re: [PATCH v3 7/9] KVM: arm64: timer: Refactor IRQ configuration
To: Marc Zyngier <maz@kernel.org>
References: <20210510134824.1910399-1-maz@kernel.org>
 <20210510134824.1910399-8-maz@kernel.org>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <9f28e15b-26d0-5d3e-8f0e-8026ece536e0@huawei.com>
Date: Fri, 14 May 2021 20:46:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20210510134824.1910399-8-maz@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.174.185.179]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggema764-chm.china.huawei.com (10.1.198.206)
X-CFilter-Loop: Reflected
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

On 2021/5/10 21:48, Marc Zyngier wrote:
> As we are about to add some more things to the timer IRQ
> configuration, move this code out of the main timer init code
> into its own set of functions.
> 
> No functional changes.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/arch_timer.c | 61 ++++++++++++++++++++++---------------
>  1 file changed, 37 insertions(+), 24 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index e2288b6bf435..7fa4f446456a 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c
> @@ -973,6 +973,39 @@ static int kvm_timer_dying_cpu(unsigned int cpu)
>  	return 0;
>  }
>  
> +static void kvm_irq_fixup_flags(unsigned int virq, u32 *flags)
> +{
> +	*flags = irq_get_trigger_type(virq);
> +	if (*flags != IRQF_TRIGGER_HIGH && *flags != IRQF_TRIGGER_LOW) {
> +		kvm_err("Invalid trigger for timer IRQ%d, assuming level low\n",
> +			virq);
> +		*flags = IRQF_TRIGGER_LOW;
> +	}
> +}
> +
> +static int kvm_irq_init(struct arch_timer_kvm_info *info)
> +{
> +	struct irq_domain *domain = NULL;
> +	struct fwnode_handle *fwnode;
> +	struct irq_data *data;

Shouldn't this belong to patch #8?

> +
> +	if (info->virtual_irq <= 0) {
> +		kvm_err("kvm_arch_timer: invalid virtual timer IRQ: %d\n",
> +			info->virtual_irq);
> +		return -ENODEV;
> +	}
> +
> +	host_vtimer_irq = info->virtual_irq;
> +	kvm_irq_fixup_flags(host_vtimer_irq, &host_vtimer_irq_flags);
> +
> +	if (info->physical_irq > 0) {
> +		host_ptimer_irq = info->physical_irq;
> +		kvm_irq_fixup_flags(host_ptimer_irq, &host_ptimer_irq_flags);
> +	}
> +
> +	return 0;
> +}

Otherwise this look like a good refactoring.

Zenghui
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
