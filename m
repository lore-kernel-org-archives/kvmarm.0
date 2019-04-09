Return-Path: <SRS0=N2lg=SL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBA3EC10F0E
	for <kvmarm@archiver.kernel.org>; Tue,  9 Apr 2019 17:52:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1E62B2077C
	for <kvmarm@archiver.kernel.org>; Tue,  9 Apr 2019 17:52:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1E62B2077C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6DA164A389;
	Tue,  9 Apr 2019 13:52:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CmFntiHaCULv; Tue,  9 Apr 2019 13:52:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C6184A452;
	Tue,  9 Apr 2019 13:52:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C7B7B4A452
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Apr 2019 13:52:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dIcVVWubQfxp for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Apr 2019 13:52:32 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 425214A389
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Apr 2019 13:52:32 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 843FE15BE;
 Tue,  9 Apr 2019 10:52:31 -0700 (PDT)
Received: from fuggles.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.72.51.249])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A4BB23F59C;
 Tue,  9 Apr 2019 10:52:29 -0700 (PDT)
Date: Tue, 9 Apr 2019 18:52:27 +0100
From: Will Deacon <will.deacon@arm.com>
To: Andrew Murray <andrew.murray@arm.com>
Subject: Re: [PATCH v12 6/8] arm64: KVM: Enable VHE support for :G/:H perf
 event modifiers
Message-ID: <20190409175227.GD9255@fuggles.cambridge.arm.com>
References: <20190328103731.27264-1-andrew.murray@arm.com>
 <20190328103731.27264-7-andrew.murray@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190328103731.27264-7-andrew.murray@arm.com>
User-Agent: Mutt/1.11.1+86 (6f28e57d73f2) ()
Cc: Marc Zyngier <marc.zyngier@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190409175227.27CKKNrCl2yDv7sdFP75lHvD4M_WGm6u2Tm9KTosVo4@z>

On Thu, Mar 28, 2019 at 10:37:29AM +0000, Andrew Murray wrote:
> With VHE different exception levels are used between the host (EL2) and
> guest (EL1) with a shared exception level for userpace (EL0). We can take
> advantage of this and use the PMU's exception level filtering to avoid
> enabling/disabling counters in the world-switch code. Instead we just
> modify the counter type to include or exclude EL0 at vcpu_{load,put} time.
> 
> We also ensure that trapped PMU system register writes do not re-enable
> EL0 when reconfiguring the backing perf events.
> 
> This approach completely avoids blackout windows seen with !VHE.
> 
> Suggested-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> ---
>  arch/arm/include/asm/kvm_host.h   |  3 ++
>  arch/arm64/include/asm/kvm_host.h |  5 +-
>  arch/arm64/kernel/perf_event.c    |  6 ++-
>  arch/arm64/kvm/pmu.c              | 87 ++++++++++++++++++++++++++++++-
>  arch/arm64/kvm/sys_regs.c         |  3 ++
>  virt/kvm/arm/arm.c                |  2 +
>  6 files changed, 102 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> index 427c28be6452..481411295b3b 100644
> --- a/arch/arm/include/asm/kvm_host.h
> +++ b/arch/arm/include/asm/kvm_host.h
> @@ -365,6 +365,9 @@ static inline void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu) {}
>  
> +static inline void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu) {}
> +static inline void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu) {}
> +
>  static inline void kvm_arm_vhe_guest_enter(void) {}
>  static inline void kvm_arm_vhe_guest_exit(void) {}
>  
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index a3bfb75f0be9..4f290dad3a48 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -528,7 +528,7 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu);
>  
>  static inline bool kvm_pmu_counter_deferred(struct perf_event_attr *attr)
>  {
> -	return attr->exclude_host;
> +	return (!has_vhe() && attr->exclude_host);
>  }
>  
>  #ifdef CONFIG_KVM /* Avoid conflicts with core headers if CONFIG_KVM=n */
> @@ -542,6 +542,9 @@ void kvm_clr_pmu_events(u32 clr);
>  
>  void __pmu_switch_to_host(struct kvm_cpu_context *host_ctxt);
>  bool __pmu_switch_to_guest(struct kvm_cpu_context *host_ctxt);
> +
> +void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu);
> +void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
>  #else
>  static inline void kvm_set_pmu_events(u32 set, struct perf_event_attr *attr) {}
>  static inline void kvm_clr_pmu_events(u32 clr) {}
> diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
> index 6bb28aaf5aea..314b1adedf06 100644
> --- a/arch/arm64/kernel/perf_event.c
> +++ b/arch/arm64/kernel/perf_event.c
> @@ -847,8 +847,12 @@ static int armv8pmu_set_event_filter(struct hw_perf_event *event,
>  	 * with other architectures (x86 and Power).
>  	 */
>  	if (is_kernel_in_hyp_mode()) {
> -		if (!attr->exclude_kernel)
> +		if (!attr->exclude_kernel && !attr->exclude_host)
>  			config_base |= ARMV8_PMU_INCLUDE_EL2;
> +		if (attr->exclude_guest)
> +			config_base |= ARMV8_PMU_EXCLUDE_EL1;
> +		if (attr->exclude_host)
> +			config_base |= ARMV8_PMU_EXCLUDE_EL0;
>  	} else {
>  		if (!attr->exclude_hv && !attr->exclude_host)
>  			config_base |= ARMV8_PMU_INCLUDE_EL2;

I still don't really like these semantics, but it's consistent and
you're documenting it so:

Acked-by: Will Deacon <will.deacon@arm.com>

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
