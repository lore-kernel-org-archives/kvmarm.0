Return-Path: <SRS0=zNRV=2K=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2527C2D0C8
	for <kvmarm@archiver.kernel.org>; Fri, 20 Dec 2019 18:07:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 791382068F
	for <kvmarm@archiver.kernel.org>; Fri, 20 Dec 2019 18:07:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 791382068F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C7AFA4ACD6;
	Fri, 20 Dec 2019 13:07:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BfVJrx0dKsiE; Fri, 20 Dec 2019 13:07:04 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D0BF4A95C;
	Fri, 20 Dec 2019 13:07:04 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 23D994A95C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Dec 2019 13:07:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dfqkXxiYmJ6i for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Dec 2019 13:07:01 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C5A034A610
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Dec 2019 13:07:01 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 564091FB;
 Fri, 20 Dec 2019 10:07:01 -0800 (PST)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2154B3F67D;
 Fri, 20 Dec 2019 10:07:00 -0800 (PST)
Date: Fri, 20 Dec 2019 18:06:58 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Andrew Murray <andrew.murray@arm.com>
Subject: Re: [PATCH v2 09/18] arm64: KVM: enable conditional save/restore
 full SPE profiling buffer controls
Message-ID: <20191220180657.GD25258@lakrids.cambridge.arm.com>
References: <20191220143025.33853-1-andrew.murray@arm.com>
 <20191220143025.33853-10-andrew.murray@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20191220143025.33853-10-andrew.murray@arm.com>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>,
 linux-kernel@vger.kernel.org, Sudeep Holla <sudeep.holla@arm.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Fri, Dec 20, 2019 at 02:30:16PM +0000, Andrew Murray wrote:
> From: Sudeep Holla <sudeep.holla@arm.com>
> 
> Now that we can save/restore the full SPE controls, we can enable it
> if SPE is setup and ready to use in KVM. It's supported in KVM only if
> all the CPUs in the system supports SPE.
> 
> However to support heterogenous systems, we need to move the check if
> host supports SPE and do a partial save/restore.

I don't think that it makes sense to support this for heterogeneous
systems, given their SPE capabilities and IMP DEF details will differ.

Is there some way we can limit this to homogeneous systems?

Thanks,
Mark.

> 
> Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
> Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> ---
>  arch/arm64/kvm/hyp/debug-sr.c | 33 ++++++++++++++++-----------------
>  include/kvm/arm_spe.h         |  6 ++++++
>  2 files changed, 22 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/debug-sr.c b/arch/arm64/kvm/hyp/debug-sr.c
> index 12429b212a3a..d8d857067e6d 100644
> --- a/arch/arm64/kvm/hyp/debug-sr.c
> +++ b/arch/arm64/kvm/hyp/debug-sr.c
> @@ -86,18 +86,13 @@
>  	}
>  
>  static void __hyp_text
> -__debug_save_spe_nvhe(struct kvm_cpu_context *ctxt, bool full_ctxt)
> +__debug_save_spe_context(struct kvm_cpu_context *ctxt, bool full_ctxt)
>  {
>  	u64 reg;
>  
>  	/* Clear pmscr in case of early return */
>  	ctxt->sys_regs[PMSCR_EL1] = 0;
>  
> -	/* SPE present on this CPU? */
> -	if (!cpuid_feature_extract_unsigned_field(read_sysreg(id_aa64dfr0_el1),
> -						  ID_AA64DFR0_PMSVER_SHIFT))
> -		return;
> -
>  	/* Yes; is it owned by higher EL? */
>  	reg = read_sysreg_s(SYS_PMBIDR_EL1);
>  	if (reg & BIT(SYS_PMBIDR_EL1_P_SHIFT))
> @@ -142,7 +137,7 @@ __debug_save_spe_nvhe(struct kvm_cpu_context *ctxt, bool full_ctxt)
>  }
>  
>  static void __hyp_text
> -__debug_restore_spe_nvhe(struct kvm_cpu_context *ctxt, bool full_ctxt)
> +__debug_restore_spe_context(struct kvm_cpu_context *ctxt, bool full_ctxt)
>  {
>  	if (!ctxt->sys_regs[PMSCR_EL1])
>  		return;
> @@ -210,11 +205,14 @@ void __hyp_text __debug_restore_guest_context(struct kvm_vcpu *vcpu)
>  	struct kvm_guest_debug_arch *host_dbg;
>  	struct kvm_guest_debug_arch *guest_dbg;
>  
> +	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
> +	guest_ctxt = &vcpu->arch.ctxt;
> +
> +	__debug_restore_spe_context(guest_ctxt, kvm_arm_spe_v1_ready(vcpu));
> +
>  	if (!(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY))
>  		return;
>  
> -	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
> -	guest_ctxt = &vcpu->arch.ctxt;
>  	host_dbg = &vcpu->arch.host_debug_state.regs;
>  	guest_dbg = kern_hyp_va(vcpu->arch.debug_ptr);
>  
> @@ -232,8 +230,7 @@ void __hyp_text __debug_restore_host_context(struct kvm_vcpu *vcpu)
>  	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
>  	guest_ctxt = &vcpu->arch.ctxt;
>  
> -	if (!has_vhe())
> -		__debug_restore_spe_nvhe(host_ctxt, false);
> +	__debug_restore_spe_context(host_ctxt, kvm_arm_spe_v1_ready(vcpu));
>  
>  	if (!(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY))
>  		return;
> @@ -249,19 +246,21 @@ void __hyp_text __debug_restore_host_context(struct kvm_vcpu *vcpu)
>  
>  void __hyp_text __debug_save_host_context(struct kvm_vcpu *vcpu)
>  {
> -	/*
> -	 * Non-VHE: Disable and flush SPE data generation
> -	 * VHE: The vcpu can run, but it can't hide.
> -	 */
>  	struct kvm_cpu_context *host_ctxt;
>  
>  	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
> -	if (!has_vhe())
> -		__debug_save_spe_nvhe(host_ctxt, false);
> +	if (cpuid_feature_extract_unsigned_field(read_sysreg(id_aa64dfr0_el1),
> +						 ID_AA64DFR0_PMSVER_SHIFT))
> +		__debug_save_spe_context(host_ctxt, kvm_arm_spe_v1_ready(vcpu));
>  }
>  
>  void __hyp_text __debug_save_guest_context(struct kvm_vcpu *vcpu)
>  {
> +	bool kvm_spe_ready = kvm_arm_spe_v1_ready(vcpu);
> +
> +	/* SPE present on this vCPU? */
> +	if (kvm_spe_ready)
> +		__debug_save_spe_context(&vcpu->arch.ctxt, kvm_spe_ready);
>  }
>  
>  u32 __hyp_text __kvm_get_mdcr_el2(void)
> diff --git a/include/kvm/arm_spe.h b/include/kvm/arm_spe.h
> index 48d118fdb174..30c40b1bc385 100644
> --- a/include/kvm/arm_spe.h
> +++ b/include/kvm/arm_spe.h
> @@ -16,4 +16,10 @@ struct kvm_spe {
>  	bool irq_level;
>  };
>  
> +#ifdef CONFIG_KVM_ARM_SPE
> +#define kvm_arm_spe_v1_ready(v)		((v)->arch.spe.ready)
> +#else
> +#define kvm_arm_spe_v1_ready(v)		(false)
> +#endif /* CONFIG_KVM_ARM_SPE */
> +
>  #endif /* __ASM_ARM_KVM_SPE_H */
> -- 
> 2.21.0
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
