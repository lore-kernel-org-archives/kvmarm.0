Return-Path: <SRS0=L5kI=FO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A607C4361B
	for <kvmarm@archiver.kernel.org>; Thu, 10 Dec 2020 10:12:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7E0BD23D98
	for <kvmarm@archiver.kernel.org>; Thu, 10 Dec 2020 10:12:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7E0BD23D98
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AB7CA4B1E2;
	Thu, 10 Dec 2020 05:12:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CFTgLLUvV7UI; Thu, 10 Dec 2020 05:12:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 648924B1D3;
	Thu, 10 Dec 2020 05:12:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EA4184B1D3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Dec 2020 05:12:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WvjA-JRMRRi8 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Dec 2020 05:12:47 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A14844B1C1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Dec 2020 05:12:47 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0215131B;
 Thu, 10 Dec 2020 02:12:47 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 154523F718;
 Thu, 10 Dec 2020 02:12:45 -0800 (PST)
Subject: Re: [PATCH] KVM: arm64: Don't access PMCR_EL0 when no PMU is available
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
References: <20201210083059.1277162-1-maz@kernel.org>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <41fab19e-1e6d-f39b-c0a8-d4a1e54fc9b9@arm.com>
Date: Thu, 10 Dec 2020 10:12:40 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201210083059.1277162-1-maz@kernel.org>
Content-Language: en-US
Cc: kernel-team@android.com
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

On 12/10/20 8:30 AM, Marc Zyngier wrote:
> We reset the guest's view of PMCR_EL0 unconditionally, based on
> the host's view of this register. It is however legal for an
> imnplementation not to provide any PMU, resulting in an UNDEF.
>
> The obvious fix is to skip the reset of this shadow register
> when no PMU is available, sidestepping the issue entirely.
> If no PMU is available, the guest is not able to request
> a virtual PMU anyway, so not doing nothing is the right thing
> to do!
>
> It is unlikely that this bug can hit any HW implementation
> though, as they all provide a PMU. It has been found using nested
> virt with the host KVM not implementing the PMU itself.
>
> Fixes: ab9468340d2bc ("arm64: KVM: Add access handler for PMCR register")
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index bc15246775d0..6c64d010102b 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -923,6 +923,10 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>  {
>  	u64 pmcr, val;
>  
> +	/* No PMU available, PMCR_EL0 may UNDEF... */
> +	if (!kvm_arm_support_pmu_v3())
> +		return;
> +

reset_pmcr() is called from kvm_reset_vcpu()->kvm_reset_sys_regs(). Before calling
kvm_reset_sys_regs(), kvm_reset_vcpu() returns -EINVAL if the VCPU has the PMUv3
feature but the host doesn't have a PMU.

It looks to me like the undef can happen only when the VCPU feature isn't set and
the hardware doesn't have a PMU. How about we change the test to check for
kvm_vcpu_has_pmu() to avoid executing the extra instructions, which are not needed
because the VM won't have a PMU?

On the other hand, kvm_pmu_vcpu_reset() is happy to do the reset even if the VCPU
feature isn't set, the host doesn't support a PMU, and before PMCR_EL0 is
initialized. It's up to you, the kvm_arm_support_pmu_v3() check looks consistent
with how PMU reset is handled.

Thanks,
Alex

>  	pmcr = read_sysreg(pmcr_el0);
>  	/*
>  	 * Writable bits of PMCR_EL0 (ARMV8_PMU_PMCR_MASK) are reset to UNKNOWN
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
