Return-Path: <SRS0=qFti=EC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 531A2C4363A
	for <kvmarm@archiver.kernel.org>; Tue, 27 Oct 2020 17:41:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8E3622068D
	for <kvmarm@archiver.kernel.org>; Tue, 27 Oct 2020 17:41:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8E3622068D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AAD944B4A1;
	Tue, 27 Oct 2020 13:41:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MFnZsQ9WXrXN; Tue, 27 Oct 2020 13:41:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 688184B4A6;
	Tue, 27 Oct 2020 13:41:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D30A4B446
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Oct 2020 13:41:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9tN8aweTzQ9r for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Oct 2020 13:41:21 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E84E44B25B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Oct 2020 13:41:20 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 78F08139F;
 Tue, 27 Oct 2020 10:41:20 -0700 (PDT)
Received: from [172.16.1.113] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BE14A3F719;
 Tue, 27 Oct 2020 10:41:18 -0700 (PDT)
Subject: Re: [PATCH 07/11] KVM: arm64: Inject AArch64 exceptions from HYP
To: Marc Zyngier <maz@kernel.org>
References: <20201026133450.73304-1-maz@kernel.org>
 <20201026133450.73304-8-maz@kernel.org>
From: James Morse <james.morse@arm.com>
Message-ID: <cf4dc11c-fb9f-ee01-a93a-c1c0a721aa19@arm.com>
Date: Tue, 27 Oct 2020 17:41:16 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201026133450.73304-8-maz@kernel.org>
Content-Language: en-GB
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 kernel-team@android.com, Will Deacon <will@kernel.org>,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Marc,

On 26/10/2020 13:34, Marc Zyngier wrote:
> Move the AArch64 exception injection code from EL1 to HYP, leaving
> only the ESR_EL1 updates to EL1. In order to come with the differences

(cope with the differences?)


> between VHE and nVHE, two set of system register accessors are provided.
> 
> SPSR, ELR, PC and PSTATE are now completely handled in the hypervisor.


> diff --git a/arch/arm64/kvm/hyp/exception.c b/arch/arm64/kvm/hyp/exception.c
> index 6533a9270850..cd6e643639e8 100644
> --- a/arch/arm64/kvm/hyp/exception.c
> +++ b/arch/arm64/kvm/hyp/exception.c
> @@ -11,7 +11,167 @@
>   */
>  
>  #include <hyp/adjust_pc.h>
> +#include <linux/kvm_host.h>
> +#include <asm/kvm_emulate.h>
> +
> +#if defined (__KVM_NVHE_HYPERVISOR__)
> +/*
> + * System registers are never loaded on the CPU until we actually
> + * restore them.
> + */
> +static inline u64 __vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
> +{
> +	return __vcpu_sys_reg(vcpu, reg);
> +}
> +
> +static inline void __vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
> +{
> +	 __vcpu_sys_reg(vcpu, reg) = val;
> +}
> +
> +static void __vcpu_write_spsr(struct kvm_vcpu *vcpu, u64 val)
> +{
> +	write_sysreg_el1(val, SYS_SPSR);
> +}
> +#elif defined (__KVM_VHE_HYPERVISOR__)
> +/* On VHE, all the registers are already loaded on the CPU */
> +static inline u64 __vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
> +{
> +	u64 val;

> +	if (__vcpu_read_sys_reg_from_cpu(reg, &val))
> +		return val;

As has_vhe()'s behaviour changes based on these KVM preprocessor symbols, would:
|	if (has_vhe() && __vcpu_read_sys_reg_from_cpu(reg, &val))
|		return val;

let you do both of these with only one copy of the function?


> +	return __vcpu_sys_reg(vcpu, reg);
> +}
> +
> +static inline void __vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
> +{
> +	if (__vcpu_write_sys_reg_to_cpu(val, reg))
> +		return;
> +
> +	 __vcpu_sys_reg(vcpu, reg) = val;
> +}


> +static void __vcpu_write_spsr(struct kvm_vcpu *vcpu, u64 val)
> +{
> +	write_sysreg_el1(val, SYS_SPSR);
> +}

This one doesn't look like it needs duplicating.


> +#else
> +#error Hypervisor code only!
> +#endif


Thanks,

James
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
