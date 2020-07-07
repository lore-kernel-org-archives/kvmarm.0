Return-Path: <SRS0=EuCB=AS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C5ECC433E0
	for <kvmarm@archiver.kernel.org>; Tue,  7 Jul 2020 13:18:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9ED5F2075B
	for <kvmarm@archiver.kernel.org>; Tue,  7 Jul 2020 13:18:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9ED5F2075B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 111904B0C4;
	Tue,  7 Jul 2020 09:18:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mG8FVbM9z4tN; Tue,  7 Jul 2020 09:18:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D19244B0C5;
	Tue,  7 Jul 2020 09:18:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 42F374B0C4
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jul 2020 09:18:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pwH1F54aVf3d for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Jul 2020 09:18:49 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EF0484B09E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jul 2020 09:18:48 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7C59AC0A;
 Tue,  7 Jul 2020 06:18:48 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 513D73F71E;
 Tue,  7 Jul 2020 06:18:46 -0700 (PDT)
Subject: Re: [PATCH v3 10/17] KVM: arm64: debug: Drop useless vpcu parameter
To: Marc Zyngier <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
References: <20200706125425.1671020-1-maz@kernel.org>
 <20200706125425.1671020-11-maz@kernel.org>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <9dc5698d-2782-c26e-156b-3d082fcfecf9@arm.com>
Date: Tue, 7 Jul 2020 14:19:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200706125425.1671020-11-maz@kernel.org>
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

Hi Marc,

On 7/6/20 1:54 PM, Marc Zyngier wrote:
> As part of the ongoing spring cleanup, remove the now useless
> vcpu parameter that is passed around (host and guest contexts
> give us everything we need).
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/include/hyp/debug-sr.h | 18 ++++++++----------
>  1 file changed, 8 insertions(+), 10 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/include/hyp/debug-sr.h b/arch/arm64/kvm/hyp/include/hyp/debug-sr.h
> index 5499d6c1fd9f..0297dc63988c 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/debug-sr.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/debug-sr.h
> @@ -88,9 +88,8 @@
>  	default:	write_debug(ptr[0], reg, 0);			\
>  	}
>  
> -static inline void __debug_save_state(struct kvm_vcpu *vcpu,
> -				      struct kvm_guest_debug_arch *dbg,
> -				      struct kvm_cpu_context *ctxt)
> +static void __debug_save_state(struct kvm_guest_debug_arch *dbg,
> +			       struct kvm_cpu_context *ctxt)
>  {
>  	u64 aa64dfr0;
>  	int brps, wrps;
> @@ -107,9 +106,8 @@ static inline void __debug_save_state(struct kvm_vcpu *vcpu,
>  	ctxt_sys_reg(ctxt, MDCCINT_EL1) = read_sysreg(mdccint_el1);
>  }
>  
> -static inline void __debug_restore_state(struct kvm_vcpu *vcpu,
> -					 struct kvm_guest_debug_arch *dbg,
> -					 struct kvm_cpu_context *ctxt)
> +static void __debug_restore_state(struct kvm_guest_debug_arch *dbg,
> +				  struct kvm_cpu_context *ctxt)
>  {
>  	u64 aa64dfr0;
>  	int brps, wrps;
> @@ -142,8 +140,8 @@ static inline void __debug_switch_to_guest_common(struct kvm_vcpu *vcpu)
>  	host_dbg = &vcpu->arch.host_debug_state.regs;
>  	guest_dbg = kern_hyp_va(vcpu->arch.debug_ptr);
>  
> -	__debug_save_state(vcpu, host_dbg, host_ctxt);
> -	__debug_restore_state(vcpu, guest_dbg, guest_ctxt);
> +	__debug_save_state(host_dbg, host_ctxt);
> +	__debug_restore_state(guest_dbg, guest_ctxt);
>  }
>  
>  static inline void __debug_switch_to_host_common(struct kvm_vcpu *vcpu)
> @@ -161,8 +159,8 @@ static inline void __debug_switch_to_host_common(struct kvm_vcpu *vcpu)
>  	host_dbg = &vcpu->arch.host_debug_state.regs;
>  	guest_dbg = kern_hyp_va(vcpu->arch.debug_ptr);
>  
> -	__debug_save_state(vcpu, guest_dbg, guest_ctxt);
> -	__debug_restore_state(vcpu, host_dbg, host_ctxt);
> +	__debug_save_state(guest_dbg, guest_ctxt);
> +	__debug_restore_state(host_dbg, host_ctxt);
>  
>  	vcpu->arch.flags &= ~KVM_ARM64_DEBUG_DIRTY;
>  }

Looks fine to me. I also had a look at the other files where we started using the
__vcpu_sys_reg/ctxt_sys_reg accessors, and I didn't find any functions where we
could eliminate the vcpu parameter, like we did here:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
