Return-Path: <SRS0=EuCB=AS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34231C433DF
	for <kvmarm@archiver.kernel.org>; Tue,  7 Jul 2020 13:04:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BB89920708
	for <kvmarm@archiver.kernel.org>; Tue,  7 Jul 2020 13:04:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BB89920708
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 52A5D4B169;
	Tue,  7 Jul 2020 09:04:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2vUBl-+4mUYs; Tue,  7 Jul 2020 09:04:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 11D764B124;
	Tue,  7 Jul 2020 09:04:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A84A24B124
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jul 2020 09:04:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oCNrwy-wF5ic for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Jul 2020 09:04:41 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 879954B11D
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jul 2020 09:04:41 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 079AAC0A;
 Tue,  7 Jul 2020 06:04:41 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D7D873F71E;
 Tue,  7 Jul 2020 06:04:38 -0700 (PDT)
Subject: Re: [PATCH v3 09/17] KVM: arm64: pauth: Use ctxt_sys_reg() instead of
 raw sys_regs access
To: Marc Zyngier <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
References: <20200706125425.1671020-1-maz@kernel.org>
 <20200706125425.1671020-10-maz@kernel.org>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <9689172f-a6c2-dd5b-6b0d-bbc1700cdb31@arm.com>
Date: Tue, 7 Jul 2020 14:05:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200706125425.1671020-10-maz@kernel.org>
Content-Language: en-US
Cc: kernel-team@android.com, Andre Przywara <andre.przywara@arm.com>,
 Dave Martin <Dave.Martin@arm.com>, George Cherian <gcherian@marvell.com>,
 "Zengtao \(B\)" <prime.zeng@hisilicon.com>, Will Deacon <will@kernel.org>
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

Hi,

On 7/6/20 1:54 PM, Marc Zyngier wrote:
> Now that we have a wrapper for the sysreg accesses, let's use that
> consistently.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 23 +++++++++++++----------
>  1 file changed, 13 insertions(+), 10 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index 7cf14e4f9f77..70367699d69a 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -364,11 +364,14 @@ static inline bool esr_is_ptrauth_trap(u32 esr)
>  	return false;
>  }
>  
> -#define __ptrauth_save_key(regs, key)						\
> -({										\
> -	regs[key ## KEYLO_EL1] = read_sysreg_s(SYS_ ## key ## KEYLO_EL1);	\
> -	regs[key ## KEYHI_EL1] = read_sysreg_s(SYS_ ## key ## KEYHI_EL1);	\
> -})
> +#define __ptrauth_save_key(ctxt, key)					\
> +	do {								\

Nitpick: the indentation for the do instruction doesn't match the indentation for
while(0).

> +	u64 __val;                                                      \
> +	__val = read_sysreg_s(SYS_ ## key ## KEYLO_EL1);                \
> +	ctxt_sys_reg(ctxt, key ## KEYLO_EL1) = __val;                   \
> +	__val = read_sysreg_s(SYS_ ## key ## KEYHI_EL1);                \
> +	ctxt_sys_reg(ctxt, key ## KEYHI_EL1) = __val;                   \
> +} while(0)
>  
>  static inline bool __hyp_handle_ptrauth(struct kvm_vcpu *vcpu)
>  {
> @@ -380,11 +383,11 @@ static inline bool __hyp_handle_ptrauth(struct kvm_vcpu *vcpu)
>  		return false;
>  
>  	ctxt = &__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
> -	__ptrauth_save_key(ctxt->sys_regs, APIA);
> -	__ptrauth_save_key(ctxt->sys_regs, APIB);
> -	__ptrauth_save_key(ctxt->sys_regs, APDA);
> -	__ptrauth_save_key(ctxt->sys_regs, APDB);
> -	__ptrauth_save_key(ctxt->sys_regs, APGA);
> +	__ptrauth_save_key(ctxt, APIA);
> +	__ptrauth_save_key(ctxt, APIB);
> +	__ptrauth_save_key(ctxt, APDA);
> +	__ptrauth_save_key(ctxt, APDB);
> +	__ptrauth_save_key(ctxt, APGA);
>  
>  	vcpu_ptrauth_enable(vcpu);
>  

Looks good to me. I also grep'ed for sys_regs at the top level of the sources and
I didn't find any instances that we could replace with the accessors:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
