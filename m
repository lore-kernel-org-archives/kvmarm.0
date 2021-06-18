Return-Path: <SRS0=A4hI=LM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF539C48BDF
	for <kvmarm@archiver.kernel.org>; Fri, 18 Jun 2021 11:16:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0350061248
	for <kvmarm@archiver.kernel.org>; Fri, 18 Jun 2021 11:16:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0350061248
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 875AE4A5A0;
	Fri, 18 Jun 2021 07:16:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PrWwgqh8S9T6; Fri, 18 Jun 2021 07:16:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 664DC40808;
	Fri, 18 Jun 2021 07:16:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EEE7440808
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jun 2021 07:16:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NByvo0OiBrMF for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Jun 2021 07:16:04 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D9CF9407F1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jun 2021 07:16:04 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4B33413A1;
 Fri, 18 Jun 2021 04:16:04 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A85D63F719;
 Fri, 18 Jun 2021 04:16:03 -0700 (PDT)
Subject: Re: [PATCH] KVM: arm64: Don't zero the cycle count register when
 PMCR_EL0.P is set
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
References: <20210618105139.83795-1-alexandru.elisei@arm.com>
Message-ID: <583c1ece-75f1-bfa6-0166-aca741f43b51@arm.com>
Date: Fri, 18 Jun 2021 12:16:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210618105139.83795-1-alexandru.elisei@arm.com>
Content-Language: en-US
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

Argh, forgot to CC Eric.

On 6/18/21 11:51 AM, Alexandru Elisei wrote:
> According to ARM DDI 0487G.a, page D13-3895, setting the PMCR_EL0.P bit to
> 1 has the following effect:
>
> "Reset all event counters accessible in the current Exception level, not
> including PMCCNTR_EL0, to zero."
>
> Similar behaviour is described for AArch32 on page G8-7022. Make it so.
>
> Fixes: c01d6a18023b ("KVM: arm64: pmu: Only handle supported event counters")
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
> Found by code inspection.
>
> Entertained the idea of restricting the number of bits in
> for_each_set_bit() to 31 since Linux (and the architecture, to some degree)
> treats the cycle count register as the 32nd event counter. Settled on this
> approach because I think it's clearer.
>
>  arch/arm64/kvm/pmu-emul.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index fd167d4f4215..ecc0d19c8cc1 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -578,6 +578,7 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
>  		kvm_pmu_set_counter_value(vcpu, ARMV8_PMU_CYCLE_IDX, 0);
>  
>  	if (val & ARMV8_PMU_PMCR_P) {
> +		mask &= ~BIT(ARMV8_PMU_CYCLE_IDX);
>  		for_each_set_bit(i, &mask, 32)
>  			kvm_pmu_set_counter_value(vcpu, i, 0);
>  	}
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
