Return-Path: <SRS0=H2W4=6I=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B84C6C55186
	for <kvmarm@archiver.kernel.org>; Fri, 24 Apr 2020 04:08:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4801F2075A
	for <kvmarm@archiver.kernel.org>; Fri, 24 Apr 2020 04:08:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4801F2075A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D8F1C4B0E7;
	Fri, 24 Apr 2020 00:08:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dfO0DhYnsQcG; Fri, 24 Apr 2020 00:08:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A0ED04B1F7;
	Fri, 24 Apr 2020 00:08:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B8B64B13B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Apr 2020 00:08:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7R-lXmOYBXHS for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Apr 2020 00:08:06 -0400 (EDT)
Received: from huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A08DB4B0E7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Apr 2020 00:08:06 -0400 (EDT)
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id 7E6B1DEC27DDEED61367;
 Fri, 24 Apr 2020 12:08:03 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.487.0; Fri, 24 Apr 2020
 12:07:52 +0800
Subject: Re: [PATCH 18/26] KVM: arm64: Don't use empty structures as CPU reset
 state
To: Marc Zyngier <maz@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>
References: <20200422120050.3693593-1-maz@kernel.org>
 <20200422120050.3693593-19-maz@kernel.org>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <77963c60-bcc4-0c9e-fd35-d696827ea55c@huawei.com>
Date: Fri, 24 Apr 2020 12:07:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200422120050.3693593-19-maz@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Cc: Andre Przywara <andre.przywara@arm.com>,
 George Cherian <gcherian@marvell.com>,
 "Zengtao \(B\)" <prime.zeng@hisilicon.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Dave Martin <Dave.Martin@arm.com>
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

Hi Marc,

On 2020/4/22 20:00, Marc Zyngier wrote:
> Keeping empty structure as the vcpu state initializer is slightly
> wasteful: we only want to set pstate, and zero everything else.
> Just do that.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>   arch/arm64/kvm/reset.c | 20 +++++++++-----------
>   1 file changed, 9 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index 241db35a7ef4f..895d7d9ad1866 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -37,15 +37,11 @@ static u32 kvm_ipa_limit;
>   /*
>    * ARMv8 Reset Values
>    */
> -static const struct kvm_regs default_regs_reset = {
> -	.regs.pstate = (PSR_MODE_EL1h | PSR_A_BIT | PSR_I_BIT |
> -			PSR_F_BIT | PSR_D_BIT),
> -};
> +#define VCPU_RESET_PSTATE_EL1	(PSR_MODE_EL1h | PSR_A_BIT | PSR_I_BIT | \
> +				 PSR_F_BIT | PSR_D_BIT)
>   
> -static const struct kvm_regs default_regs_reset32 = {
> -	.regs.pstate = (PSR_AA32_MODE_SVC | PSR_AA32_A_BIT |
> -			PSR_AA32_I_BIT | PSR_AA32_F_BIT),
> -};
> +#define VCPU_RESET_PSTATE_SVC	(PSR_AA32_MODE_SVC | PSR_AA32_A_BIT | \
> +				 PSR_AA32_I_BIT | PSR_AA32_F_BIT)
>   
>   static bool cpu_has_32bit_el1(void)
>   {
> @@ -261,6 +257,7 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>   	const struct kvm_regs *cpu_reset;
>   	int ret = -EINVAL;
>   	bool loaded;
> +	u32 pstate;
>   
>   	/* Reset PMU outside of the non-preemptible section */
>   	kvm_pmu_vcpu_reset(vcpu);
> @@ -291,16 +288,17 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>   		if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features)) {
>   			if (!cpu_has_32bit_el1())
>   				goto out;
> -			cpu_reset = &default_regs_reset32;
> +			pstate = VCPU_RESET_PSTATE_SVC;
>   		} else {
> -			cpu_reset = &default_regs_reset;
> +			pstate = VCPU_RESET_PSTATE_EL1;
>   		}
>   
>   		break;
>   	}
>   
>   	/* Reset core registers */
> -	memcpy(vcpu_gp_regs(vcpu), cpu_reset, sizeof(*cpu_reset));
> +	memset(vcpu_gp_regs(vcpu), 0, sizeof(*cpu_reset));

Be careful that we can *not* use 'sizeof(*cpu_reset)' here anymore.  As
you're going to refactor the layout of the core registers whilst keeping
the kvm_regs API unchanged.  Resetting the whole kvm_regs will go
corrupting some affected registers and make them temporarily invalid.
The bad thing will show up after you start moving ELR_EL1 around,
specifically in patch #20...

And the first victim is ... MPIDR_EL1 (the first one in sys_regs array).
Now you know how this was spotted ;-)  I think this should be the root
cause of what Zengtao had previously reported [*].

If these registers are all expected to be reset to architecturally
UNKNOWN values, I think we can just drop this memset(), though haven't
check with the ARM ARM carefully.


Thanks,
Zenghui


[*] 
https://lore.kernel.org/kvmarm/f55386a9-8eaa-944f-453d-9c3c4abee5fb@arm.com/T/#mc6c7268755f5cdaff7a23c34e6e16ea36bcfbe22

> +	vcpu_gp_regs(vcpu)->regs.pstate = pstate;
>   
>   	/* Reset system registers */
>   	kvm_reset_sys_regs(vcpu);
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
