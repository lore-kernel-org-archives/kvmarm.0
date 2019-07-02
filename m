Return-Path: <SRS0=KAXL=U7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19A5DC06510
	for <kvmarm@archiver.kernel.org>; Tue,  2 Jul 2019 12:00:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 959F121479
	for <kvmarm@archiver.kernel.org>; Tue,  2 Jul 2019 12:00:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 959F121479
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C4A6A4A4EB;
	Tue,  2 Jul 2019 08:00:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id spcHlQoRYPNP; Tue,  2 Jul 2019 08:00:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 860014A479;
	Tue,  2 Jul 2019 08:00:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 28DCE4A479
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Jul 2019 08:00:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uibr+hmUTeP8 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Jul 2019 08:00:38 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E7E74A319
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Jul 2019 08:00:38 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8726A344;
 Tue,  2 Jul 2019 05:00:37 -0700 (PDT)
Received: from [10.1.31.185] (unknown [10.1.31.185])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 48EDB3F246;
 Tue,  2 Jul 2019 05:00:36 -0700 (PDT)
Subject: Re: [PATCH 12/59] KVM: arm64: nv: Handle trapped ERET from virtual EL2
To: Marc Zyngier <marc.zyngier@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
References: <20190621093843.220980-1-marc.zyngier@arm.com>
 <20190621093843.220980-13-marc.zyngier@arm.com>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <314172b1-f65c-17b8-10ec-1b2ff58b9bc2@arm.com>
Date: Tue, 2 Jul 2019 13:00:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190621093843.220980-13-marc.zyngier@arm.com>
Content-Language: en-US
Cc: Andre Przywara <andre.przywara@arm.com>, Dave Martin <Dave.Martin@arm.com>
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


On 6/21/19 10:37 AM, Marc Zyngier wrote:
> From: Christoffer Dall <christoffer.dall@arm.com>
>
> When a guest hypervisor running virtual EL2 in EL1 executes an ERET
> instruction, we will have set HCR_EL2.NV which traps ERET to EL2, so
> that we can emulate the exception return in software.
>
> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/include/asm/esr.h     | 3 ++-
>  arch/arm64/include/asm/kvm_arm.h | 2 +-
>  arch/arm64/kvm/handle_exit.c     | 8 ++++++++
>  3 files changed, 11 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
> index 0e27fe91d5ea..f85aa269082c 100644
> --- a/arch/arm64/include/asm/esr.h
> +++ b/arch/arm64/include/asm/esr.h
> @@ -45,7 +45,8 @@
>  #define ESR_ELx_EC_SMC64	(0x17)	/* EL2 and above */
>  #define ESR_ELx_EC_SYS64	(0x18)
>  #define ESR_ELx_EC_SVE		(0x19)
> -/* Unallocated EC: 0x1A - 0x1E */
> +#define ESR_ELx_EC_ERET		(0x1A)  /* EL2 only */

From ARM DDI 0487D.b, about HCR_EL2.NV (page D12-2889):

"The priority of this trap is higher than the priority of the HCR_EL2.API trap.
If both of these bits are set so that EL1 execution of an ERETAA or ERETAB
instruction is trapped to EL2, then the syndrome reported is 0x1A."

I'm not familiar with the pointer authentication code, but it looks like the
HCR_EL2.API bit will trap if userspace sets the pointer authentication vcpu
feature, and I don't see any handling of the ERETAA or ERETAB instructions in
kvm_emulate_nested_eret. Is that pending in the next iteration of the series? Or
are the two features incompatible?

> +/* Unallocated EC: 0x1B - 0x1E */
>  #define ESR_ELx_EC_IMP_DEF	(0x1f)	/* EL3 only */
>  #define ESR_ELx_EC_IABT_LOW	(0x20)
>  #define ESR_ELx_EC_IABT_CUR	(0x21)
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> index 9d70a5362fbb..b2e363ac624d 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -333,7 +333,7 @@
>  	ECN(SP_ALIGN), ECN(FP_EXC32), ECN(FP_EXC64), ECN(SERROR), \
>  	ECN(BREAKPT_LOW), ECN(BREAKPT_CUR), ECN(SOFTSTP_LOW), \
>  	ECN(SOFTSTP_CUR), ECN(WATCHPT_LOW), ECN(WATCHPT_CUR), \
> -	ECN(BKPT32), ECN(VECTOR32), ECN(BRK64)
> +	ECN(BKPT32), ECN(VECTOR32), ECN(BRK64), ECN(ERET)
>  
>  #define CPACR_EL1_FPEN		(3 << 20)
>  #define CPACR_EL1_TTA		(1 << 28)
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index 6c0ac52b34cc..2517711f034f 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -177,6 +177,13 @@ static int handle_sve(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  {
>  	/* Until SVE is supported for guests: */
>  	kvm_inject_undefined(vcpu);
> +
> +	return 1;
> +}
> +
> +static int kvm_handle_eret(struct kvm_vcpu *vcpu, struct kvm_run *run)
> +{
> +	kvm_emulate_nested_eret(vcpu);
>  	return 1;
>  }
>  
> @@ -231,6 +238,7 @@ static exit_handle_fn arm_exit_handlers[] = {
>  	[ESR_ELx_EC_SMC64]	= handle_smc,
>  	[ESR_ELx_EC_SYS64]	= kvm_handle_sys_reg,
>  	[ESR_ELx_EC_SVE]	= handle_sve,
> +	[ESR_ELx_EC_ERET]	= kvm_handle_eret,
>  	[ESR_ELx_EC_IABT_LOW]	= kvm_handle_guest_abort,
>  	[ESR_ELx_EC_DABT_LOW]	= kvm_handle_guest_abort,
>  	[ESR_ELx_EC_SOFTSTP_LOW]= kvm_handle_guest_debug,
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
