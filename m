Return-Path: <SRS0=5+eb=MG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1905BC11F68
	for <kvmarm@archiver.kernel.org>; Wed, 14 Jul 2021 16:17:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8940761378
	for <kvmarm@archiver.kernel.org>; Wed, 14 Jul 2021 16:17:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8940761378
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 086A64B080;
	Wed, 14 Jul 2021 12:17:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jZRZgJpGm4rg; Wed, 14 Jul 2021 12:17:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D2AFB4B082;
	Wed, 14 Jul 2021 12:17:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 37DBF4B080
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Jul 2021 12:17:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Kcw-qDeTfzi9 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 14 Jul 2021 12:17:03 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CFDDA4AEDC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Jul 2021 12:17:03 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 306AED6E;
 Wed, 14 Jul 2021 09:17:03 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B0B273F7D8;
 Wed, 14 Jul 2021 09:17:01 -0700 (PDT)
Subject: Re: [PATCH 3/3] KVM: arm64: Disabling disabled PMU counters wastes a
 lot of time
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
References: <20210713135900.1473057-1-maz@kernel.org>
 <20210713135900.1473057-4-maz@kernel.org>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <d4f16a13-1324-ce69-ce62-d68f922a7338@arm.com>
Date: Wed, 14 Jul 2021 17:18:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210713135900.1473057-4-maz@kernel.org>
Content-Language: en-US
Cc: kernel-team@android.com, Robin Murphy <robin.murphy@arm.com>
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

On 7/13/21 2:59 PM, Marc Zyngier wrote:
> From: Alexandre Chartre <alexandre.chartre@oracle.com>
>
> In a KVM guest on arm64, performance counters interrupts have an
> unnecessary overhead which slows down execution when using the "perf
> record" command and limits the "perf record" sampling period.
>
> The problem is that when a guest VM disables counters by clearing the
> PMCR_EL0.E bit (bit 0), KVM will disable all counters defined in
> PMCR_EL0 even if they are not enabled in PMCNTENSET_EL0.
>
> KVM disables a counter by calling into the perf framework, in particular
> by calling perf_event_create_kernel_counter() which is a time consuming
> operation. So, for example, with a Neoverse N1 CPU core which has 6 event
> counters and one cycle counter, KVM will always disable all 7 counters
> even if only one is enabled.
>
> This typically happens when using the "perf record" command in a guest
> VM: perf will disable all event counters with PMCNTENTSET_EL0 and only
> uses the cycle counter. And when using the "perf record" -F option with
> a high profiling frequency, the overhead of KVM disabling all counters
> instead of one on every counter interrupt becomes very noticeable.
>
> The problem is fixed by having KVM disable only counters which are
> enabled in PMCNTENSET_EL0. If a counter is not enabled in PMCNTENSET_EL0
> then KVM will not enable it when setting PMCR_EL0.E and it will remain
> disabled as long as it is not enabled in PMCNTENSET_EL0. So there is
> effectively no need to disable a counter when clearing PMCR_EL0.E if it
> is not enabled PMCNTENSET_EL0.
>
> Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
> [maz: moved 'mask' close to the actual user, simplifying the patch]
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Link: https://lore.kernel.org/r/20210712170345.660272-1-alexandre.chartre@oracle.com
> ---
>  arch/arm64/kvm/pmu-emul.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index fae4e95b586c..dc65b58dc68f 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -563,20 +563,21 @@ void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val)
>   */
>  void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
>  {
> -	unsigned long mask = kvm_pmu_valid_counter_mask(vcpu);
>  	int i;
>  
>  	if (val & ARMV8_PMU_PMCR_E) {
>  		kvm_pmu_enable_counter_mask(vcpu,
>  		       __vcpu_sys_reg(vcpu, PMCNTENSET_EL0));
>  	} else {
> -		kvm_pmu_disable_counter_mask(vcpu, mask);
> +		kvm_pmu_disable_counter_mask(vcpu,
> +		       __vcpu_sys_reg(vcpu, PMCNTENSET_EL0));
>  	}
>  
>  	if (val & ARMV8_PMU_PMCR_C)
>  		kvm_pmu_set_counter_value(vcpu, ARMV8_PMU_CYCLE_IDX, 0);
>  
>  	if (val & ARMV8_PMU_PMCR_P) {
> +		unsigned long mask = kvm_pmu_valid_counter_mask(vcpu);
>  		mask &= ~BIT(ARMV8_PMU_CYCLE_IDX);
>  		for_each_set_bit(i, &mask, 32)
>  			kvm_pmu_set_counter_value(vcpu, i, 0);

Looks reasonable to me, and it fixes the issue described in the commit:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,

Alex

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
