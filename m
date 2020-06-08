Return-Path: <SRS0=JvcX=7V=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C681C433E0
	for <kvmarm@archiver.kernel.org>; Mon,  8 Jun 2020 16:29:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1E3A42053B
	for <kvmarm@archiver.kernel.org>; Mon,  8 Jun 2020 16:29:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1E3A42053B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A4DD4B105;
	Mon,  8 Jun 2020 12:29:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oOfRNgUBD-jR; Mon,  8 Jun 2020 12:29:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 21E684B179;
	Mon,  8 Jun 2020 12:29:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 390814B173
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Jun 2020 12:29:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SwT4jilGUesg for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Jun 2020 12:29:32 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AAF464B085
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Jun 2020 12:29:32 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 197121FB;
 Mon,  8 Jun 2020 09:29:32 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.6.198])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6C2273F73D;
 Mon,  8 Jun 2020 09:29:30 -0700 (PDT)
Date: Mon, 8 Jun 2020 17:29:22 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2] KVM: arm64: Remove host_cpu_context member from vcpu
 structure
Message-ID: <20200608162922.GA12957@C02TD0UTHF1T.local>
References: <20200608085657.1405730-1-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200608085657.1405730-1-maz@kernel.org>
Cc: kvm@vger.kernel.org, kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Mon, Jun 08, 2020 at 09:56:57AM +0100, Marc Zyngier wrote:
> For very long, we have kept this pointer back to the per-cpu
> host state, despite having working per-cpu accessors at EL2
> for some time now.
> 
> Recent investigations have shown that this pointer is easy
> to abuse in preemptible context, which is a sure sign that
> it would better be gone. Not to mention that a per-cpu
> pointer is faster to access at all times.
> 
> Reported-by: Andrew Scull <ascull@google.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

From a quick scan, this looks sane to me, so FWIW:

Acked-by: Mark Rutland <mark.rutland@arm.com>

Mark.

> ---
> 
> Notes:
>     v2: Stick to this_cpu_ptr() in pmu.c, as this only used on the
>         kernel side and not the hypervisor.
> 
>  arch/arm64/include/asm/kvm_host.h | 3 ---
>  arch/arm64/kvm/arm.c              | 3 ---
>  arch/arm64/kvm/hyp/debug-sr.c     | 4 ++--
>  arch/arm64/kvm/hyp/switch.c       | 6 +++---
>  arch/arm64/kvm/hyp/sysreg-sr.c    | 6 ++++--
>  arch/arm64/kvm/pmu.c              | 8 ++------
>  6 files changed, 11 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 59029e90b557..ada1faa92211 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -284,9 +284,6 @@ struct kvm_vcpu_arch {
>  	struct kvm_guest_debug_arch vcpu_debug_state;
>  	struct kvm_guest_debug_arch external_debug_state;
>  
> -	/* Pointer to host CPU context */
> -	struct kvm_cpu_context *host_cpu_context;
> -
>  	struct thread_info *host_thread_info;	/* hyp VA */
>  	struct user_fpsimd_state *host_fpsimd_state;	/* hyp VA */
>  
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 14b747266607..6ddaa23ef346 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -340,10 +340,8 @@ void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
>  void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  {
>  	int *last_ran;
> -	kvm_host_data_t *cpu_data;
>  
>  	last_ran = this_cpu_ptr(vcpu->kvm->arch.last_vcpu_ran);
> -	cpu_data = this_cpu_ptr(&kvm_host_data);
>  
>  	/*
>  	 * We might get preempted before the vCPU actually runs, but
> @@ -355,7 +353,6 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  	}
>  
>  	vcpu->cpu = cpu;
> -	vcpu->arch.host_cpu_context = &cpu_data->host_ctxt;
>  
>  	kvm_vgic_load(vcpu);
>  	kvm_timer_vcpu_load(vcpu);
> diff --git a/arch/arm64/kvm/hyp/debug-sr.c b/arch/arm64/kvm/hyp/debug-sr.c
> index 0fc9872a1467..e95af204fec7 100644
> --- a/arch/arm64/kvm/hyp/debug-sr.c
> +++ b/arch/arm64/kvm/hyp/debug-sr.c
> @@ -185,7 +185,7 @@ void __hyp_text __debug_switch_to_guest(struct kvm_vcpu *vcpu)
>  	if (!(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY))
>  		return;
>  
> -	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
> +	host_ctxt = &__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
>  	guest_ctxt = &vcpu->arch.ctxt;
>  	host_dbg = &vcpu->arch.host_debug_state.regs;
>  	guest_dbg = kern_hyp_va(vcpu->arch.debug_ptr);
> @@ -207,7 +207,7 @@ void __hyp_text __debug_switch_to_host(struct kvm_vcpu *vcpu)
>  	if (!(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY))
>  		return;
>  
> -	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
> +	host_ctxt = &__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
>  	guest_ctxt = &vcpu->arch.ctxt;
>  	host_dbg = &vcpu->arch.host_debug_state.regs;
>  	guest_dbg = kern_hyp_va(vcpu->arch.debug_ptr);
> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> index fc09c3dfa466..fc671426c14b 100644
> --- a/arch/arm64/kvm/hyp/switch.c
> +++ b/arch/arm64/kvm/hyp/switch.c
> @@ -544,7 +544,7 @@ static bool __hyp_text __hyp_handle_ptrauth(struct kvm_vcpu *vcpu)
>  		return false;
>  	}
>  
> -	ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
> +	ctxt = &__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
>  	__ptrauth_save_key(ctxt->sys_regs, APIA);
>  	__ptrauth_save_key(ctxt->sys_regs, APIB);
>  	__ptrauth_save_key(ctxt->sys_regs, APDA);
> @@ -715,7 +715,7 @@ static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
>  	struct kvm_cpu_context *guest_ctxt;
>  	u64 exit_code;
>  
> -	host_ctxt = vcpu->arch.host_cpu_context;
> +	host_ctxt = &__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
>  	host_ctxt->__hyp_running_vcpu = vcpu;
>  	guest_ctxt = &vcpu->arch.ctxt;
>  
> @@ -820,7 +820,7 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
>  
>  	vcpu = kern_hyp_va(vcpu);
>  
> -	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
> +	host_ctxt = &__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
>  	host_ctxt->__hyp_running_vcpu = vcpu;
>  	guest_ctxt = &vcpu->arch.ctxt;
>  
> diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
> index 6d2df9fe0b5d..143d7b7358f2 100644
> --- a/arch/arm64/kvm/hyp/sysreg-sr.c
> +++ b/arch/arm64/kvm/hyp/sysreg-sr.c
> @@ -265,12 +265,13 @@ void __hyp_text __sysreg32_restore_state(struct kvm_vcpu *vcpu)
>   */
>  void kvm_vcpu_load_sysregs(struct kvm_vcpu *vcpu)
>  {
> -	struct kvm_cpu_context *host_ctxt = vcpu->arch.host_cpu_context;
>  	struct kvm_cpu_context *guest_ctxt = &vcpu->arch.ctxt;
> +	struct kvm_cpu_context *host_ctxt;
>  
>  	if (!has_vhe())
>  		return;
>  
> +	host_ctxt = &__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
>  	__sysreg_save_user_state(host_ctxt);
>  
>  	/*
> @@ -301,12 +302,13 @@ void kvm_vcpu_load_sysregs(struct kvm_vcpu *vcpu)
>   */
>  void kvm_vcpu_put_sysregs(struct kvm_vcpu *vcpu)
>  {
> -	struct kvm_cpu_context *host_ctxt = vcpu->arch.host_cpu_context;
>  	struct kvm_cpu_context *guest_ctxt = &vcpu->arch.ctxt;
> +	struct kvm_cpu_context *host_ctxt;
>  
>  	if (!has_vhe())
>  		return;
>  
> +	host_ctxt = &__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
>  	deactivate_traps_vhe_put();
>  
>  	__sysreg_save_el1_state(guest_ctxt);
> diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
> index e71d00bb5271..b5ae3a5d509e 100644
> --- a/arch/arm64/kvm/pmu.c
> +++ b/arch/arm64/kvm/pmu.c
> @@ -163,15 +163,13 @@ static void kvm_vcpu_pmu_disable_el0(unsigned long events)
>   */
>  void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu)
>  {
> -	struct kvm_cpu_context *host_ctxt;
>  	struct kvm_host_data *host;
>  	u32 events_guest, events_host;
>  
>  	if (!has_vhe())
>  		return;
>  
> -	host_ctxt = vcpu->arch.host_cpu_context;
> -	host = container_of(host_ctxt, struct kvm_host_data, host_ctxt);
> +	host = this_cpu_ptr(&kvm_host_data);
>  	events_guest = host->pmu_events.events_guest;
>  	events_host = host->pmu_events.events_host;
>  
> @@ -184,15 +182,13 @@ void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu)
>   */
>  void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu)
>  {
> -	struct kvm_cpu_context *host_ctxt;
>  	struct kvm_host_data *host;
>  	u32 events_guest, events_host;
>  
>  	if (!has_vhe())
>  		return;
>  
> -	host_ctxt = vcpu->arch.host_cpu_context;
> -	host = container_of(host_ctxt, struct kvm_host_data, host_ctxt);
> +	host = this_cpu_ptr(&kvm_host_data);
>  	events_guest = host->pmu_events.events_guest;
>  	events_host = host->pmu_events.events_host;
>  
> -- 
> 2.26.2
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
