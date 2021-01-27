Return-Path: <SRS0=cUgw=G6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 421D4C433DB
	for <kvmarm@archiver.kernel.org>; Wed, 27 Jan 2021 12:12:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 94E5520786
	for <kvmarm@archiver.kernel.org>; Wed, 27 Jan 2021 12:12:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 94E5520786
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D00364B22B;
	Wed, 27 Jan 2021 07:12:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SNXV95NJOoe3; Wed, 27 Jan 2021 07:12:40 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 893154B190;
	Wed, 27 Jan 2021 07:12:40 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 11DEA4B190
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Jan 2021 07:12:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nxXKYmmdbZ1g for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 Jan 2021 07:12:37 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A80804B18A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Jan 2021 07:12:37 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D8AE61FB;
 Wed, 27 Jan 2021 04:12:36 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A5F733F68F;
 Wed, 27 Jan 2021 04:12:35 -0800 (PST)
Subject: Re: [PATCH v2 4/7] KVM: arm64: Refactor filtering of ID registers
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
References: <20210125122638.2947058-1-maz@kernel.org>
 <20210125122638.2947058-5-maz@kernel.org>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <40ec07fc-2f2f-742d-f656-8eefd6cc179d@arm.com>
Date: Wed, 27 Jan 2021 12:12:33 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210125122638.2947058-5-maz@kernel.org>
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

On 1/25/21 12:26 PM, Marc Zyngier wrote:
> Our current ID register filtering is starting to be a mess of if()
> statements, and isn't going to get any saner.
>
> Let's turn it into a switch(), which has a chance of being more
> readable, and introduce a FEATURE() macro that allows easy generation
> of feature masks.
>
> No functionnal change intended.
>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 51 +++++++++++++++++++++------------------
>  1 file changed, 28 insertions(+), 23 deletions(-)
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 2bea0494b81d..dda16d60197b 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -9,6 +9,7 @@
>   *          Christoffer Dall <c.dall@virtualopensystems.com>
>   */
>  
> +#include <linux/bitfield.h>
>  #include <linux/bsearch.h>
>  #include <linux/kvm_host.h>
>  #include <linux/mm.h>
> @@ -1016,6 +1017,8 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
>  	return true;
>  }
>  
> +#define FEATURE(x)	(GENMASK_ULL(x##_SHIFT + 3, x##_SHIFT))
> +
>  /* Read a sanitised cpufeature ID register by sys_reg_desc */
>  static u64 read_id_reg(const struct kvm_vcpu *vcpu,
>  		struct sys_reg_desc const *r, bool raz)
> @@ -1024,36 +1027,38 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
>  			 (u32)r->CRn, (u32)r->CRm, (u32)r->Op2);
>  	u64 val = raz ? 0 : read_sanitised_ftr_reg(id);
>  
> -	if (id == SYS_ID_AA64PFR0_EL1) {
> +	switch (id) {
> +	case SYS_ID_AA64PFR0_EL1:
>  		if (!vcpu_has_sve(vcpu))
> -			val &= ~(0xfUL << ID_AA64PFR0_SVE_SHIFT);
> -		val &= ~(0xfUL << ID_AA64PFR0_AMU_SHIFT);
> -		val &= ~(0xfUL << ID_AA64PFR0_CSV2_SHIFT);
> -		val |= ((u64)vcpu->kvm->arch.pfr0_csv2 << ID_AA64PFR0_CSV2_SHIFT);
> -		val &= ~(0xfUL << ID_AA64PFR0_CSV3_SHIFT);
> -		val |= ((u64)vcpu->kvm->arch.pfr0_csv3 << ID_AA64PFR0_CSV3_SHIFT);
> -	} else if (id == SYS_ID_AA64PFR1_EL1) {
> -		val &= ~(0xfUL << ID_AA64PFR1_MTE_SHIFT);
> -	} else if (id == SYS_ID_AA64ISAR1_EL1 && !vcpu_has_ptrauth(vcpu)) {
> -		val &= ~((0xfUL << ID_AA64ISAR1_APA_SHIFT) |
> -			 (0xfUL << ID_AA64ISAR1_API_SHIFT) |
> -			 (0xfUL << ID_AA64ISAR1_GPA_SHIFT) |
> -			 (0xfUL << ID_AA64ISAR1_GPI_SHIFT));
> -	} else if (id == SYS_ID_AA64DFR0_EL1) {
> -		u64 cap = 0;
> -
> +			val &= ~FEATURE(ID_AA64PFR0_SVE);
> +		val &= ~FEATURE(ID_AA64PFR0_AMU);
> +		val &= ~FEATURE(ID_AA64PFR0_CSV2);
> +		val |= FIELD_PREP(FEATURE(ID_AA64PFR0_CSV2), (u64)vcpu->kvm->arch.pfr0_csv2);
> +		val &= ~FEATURE(ID_AA64PFR0_CSV3);
> +		val |= FIELD_PREP(FEATURE(ID_AA64PFR0_CSV3), (u64)vcpu->kvm->arch.pfr0_csv3);

The patch ends up looking really nice (checked that the previous behaviour is
preserved). It also ends up making the code more robust because we make sure that
we only do bitwise or on the first 4 bits of pfr0_csv2 and pfr0_csv3:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

> +		break;
> +	case SYS_ID_AA64PFR1_EL1:
> +		val &= ~FEATURE(ID_AA64PFR1_MTE);
> +		break;
> +	case SYS_ID_AA64ISAR1_EL1:
> +		if (!vcpu_has_ptrauth(vcpu))
> +			val &= ~(FEATURE(ID_AA64ISAR1_APA) |
> +				 FEATURE(ID_AA64ISAR1_API) |
> +				 FEATURE(ID_AA64ISAR1_GPA) |
> +				 FEATURE(ID_AA64ISAR1_GPI));
> +		break;
> +	case SYS_ID_AA64DFR0_EL1:
>  		/* Limit guests to PMUv3 for ARMv8.1 */
> -		if (kvm_vcpu_has_pmu(vcpu))
> -			cap = ID_AA64DFR0_PMUVER_8_1;
> -
>  		val = cpuid_feature_cap_perfmon_field(val,
> -						ID_AA64DFR0_PMUVER_SHIFT,
> -						cap);
> -	} else if (id == SYS_ID_DFR0_EL1) {
> +						      ID_AA64DFR0_PMUVER_SHIFT,
> +						      kvm_vcpu_has_pmu(vcpu) ? ID_AA64DFR0_PMUVER_8_1 : 0);
> +		break;
> +	case SYS_ID_DFR0_EL1:
>  		/* Limit guests to PMUv3 for ARMv8.1 */
>  		val = cpuid_feature_cap_perfmon_field(val,
>  						      ID_DFR0_PERFMON_SHIFT,
>  						      kvm_vcpu_has_pmu(vcpu) ? ID_DFR0_PERFMON_8_1 : 0);
> +		break;
>  	}
>  
>  	return val;
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
