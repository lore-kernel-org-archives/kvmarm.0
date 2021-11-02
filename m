Return-Path: <SRS0=ULe9=PV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 303E2C433EF
	for <kvmarm@archiver.kernel.org>; Tue,  2 Nov 2021 23:45:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A033161050
	for <kvmarm@archiver.kernel.org>; Tue,  2 Nov 2021 23:45:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A033161050
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BDE64B106;
	Tue,  2 Nov 2021 19:45:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bL9gB1L1wqQP; Tue,  2 Nov 2021 19:45:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E05364B10C;
	Tue,  2 Nov 2021 19:45:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 963584B106
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Nov 2021 19:45:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EcQ1j+d3Xj71 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Nov 2021 19:45:21 -0400 (EDT)
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com
 [209.85.214.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D3E234B103
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Nov 2021 19:45:21 -0400 (EDT)
Received: by mail-pl1-f180.google.com with SMTP id s24so1366049plp.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 02 Nov 2021 16:45:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=TbHl79bjoUcSiR9SnJVy6ouCrATgdlDi/wN/XgELEx4=;
 b=PwnN4mjzJ0eMzfzoDNwhM0mjasM/NqNhmUSvBc6At6n5Ana9rWZCulZeayTiO4gqkD
 /GOk3kB9FyQfKQ5ca65+WsTG4XUaMOXfPc4vGcSPBU16pFrsYxqOjwzH9tWF9yMOoZsm
 dj5ruYYLlzNwbIR1oBM0aOKxeDt4CuerJLbjnye3ZeRdq1kHXfuyiQ+28xY33V/6qIth
 HVL54f2YvYqKAxHkvZ4GLpduqO1bpZp3ATDfFsefaTta0HvuuSkAHBOucsEJyGMvASX0
 qeOzynmvW4Z8KpqSKImhL8tTMHt9kS1r7hiVZQXcQ22Pf123JiJlyy1B2+vP/tUOorc3
 y1+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=TbHl79bjoUcSiR9SnJVy6ouCrATgdlDi/wN/XgELEx4=;
 b=EqRB9mCCVWUtxyDiCEfCl/q0skg2w0Bmt0aA7ezt7sD1R3IaWBcAkceiL/igsCeqbT
 GW7Edx9EqN06fr3baTKSzhWKf+/V1OcAVFKW+hHsfQZyAckIjeulBSo4Oln0GrR4KE2A
 XgYeFmNOXH/AFvb7Sb8hng0w2Vu6dememO84X9xVuPz6zRGWSTPv9t+KlryeOf0EJEb5
 c+LP2ON+4OBUcsHJ/pkZd8aHhUFtiJDJ+LS/qyDNEe9OphvlrEubjX8wN1lvhSgHu1Yl
 mpcSpDQwUVXOt3q9mtzZc77edPlbMQ36/v25gm9/MKhksgoZ/m2VCLxKl1WP5c011Bkx
 SaLg==
X-Gm-Message-State: AOAM530i1xayiFv4aChBdFlm7GTo32/h8nYPKwjQMw7w0jtCe5ouwSiQ
 rGp/MR9j5j0lMMsHM1OgVYr5UQ==
X-Google-Smtp-Source: ABdhPJxUZ80S6/9PLYa/p6dHPJj7Mf5gIE0GticJUAAj8WL38FTeEEtUZ8DpZjsWWalVSYZ57e/WFw==
X-Received: by 2002:a17:902:6b0c:b0:13f:aaf4:3db4 with SMTP id
 o12-20020a1709026b0c00b0013faaf43db4mr34567569plk.46.1635896720790; 
 Tue, 02 Nov 2021 16:45:20 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150])
 by smtp.gmail.com with ESMTPSA id m3sm246198pfk.190.2021.11.02.16.45.19
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 02 Nov 2021 16:45:20 -0700 (PDT)
Date: Tue, 2 Nov 2021 16:45:14 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v2 4/6] KVM: arm64: Emulate the OS Lock
Message-ID: <YYHNLt1rlwuXkk7e@google.com>
References: <20211102094651.2071532-1-oupton@google.com>
 <20211102094651.2071532-5-oupton@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20211102094651.2071532-5-oupton@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, kvmarm@lists.cs.columbia.edu,
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

On Tue, Nov 02, 2021 at 09:46:49AM +0000, Oliver Upton wrote:
> The OS lock blocks all debug exceptions at every EL. To date, KVM has
> not implemented the OS lock for its guests, despite the fact that it is
> mandatory per the architecture. Simple context switching between the
> guest and host is not appropriate, as its effects are not constrained to
> the guest context.
> 
> Emulate the OS Lock by clearing MDE and SS in MDSCR_EL1, thereby
> blocking all but software breakpoint instructions. To handle breakpoint
> instructions, trap debug exceptions to EL2 and skip the instruction.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h |  4 ++++
>  arch/arm64/kvm/debug.c            | 20 +++++++++++++++-----
>  arch/arm64/kvm/handle_exit.c      |  8 ++++++++
>  arch/arm64/kvm/sys_regs.c         |  6 +++---
>  4 files changed, 30 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index c98f65c4a1f7..f13b8b79b06d 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -724,6 +724,10 @@ void kvm_arm_vcpu_init_debug(struct kvm_vcpu *vcpu);
>  void kvm_arm_setup_debug(struct kvm_vcpu *vcpu);
>  void kvm_arm_clear_debug(struct kvm_vcpu *vcpu);
>  void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu);
> +
> +#define kvm_vcpu_os_lock_enabled(vcpu)		\
> +	(__vcpu_sys_reg(vcpu, OSLSR_EL1) & SYS_OSLSR_OSLK)
> +
>  int kvm_arm_vcpu_arch_set_attr(struct kvm_vcpu *vcpu,
>  			       struct kvm_device_attr *attr);
>  int kvm_arm_vcpu_arch_get_attr(struct kvm_vcpu *vcpu,
> diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
> index db9361338b2a..5690a9c99c89 100644
> --- a/arch/arm64/kvm/debug.c
> +++ b/arch/arm64/kvm/debug.c
> @@ -95,8 +95,11 @@ static void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu)
>  				MDCR_EL2_TDRA |
>  				MDCR_EL2_TDOSA);
>  
> -	/* Is the VM being debugged by userspace? */
> -	if (vcpu->guest_debug)
> +	/*
> +	 * Check if the VM is being debugged by userspace or the guest has
> +	 * enabled the OS lock.
> +	 */
> +	if (vcpu->guest_debug || kvm_vcpu_os_lock_enabled(vcpu))
>  		/* Route all software debug exceptions to EL2 */
>  		vcpu->arch.mdcr_el2 |= MDCR_EL2_TDE;
>  
> @@ -160,8 +163,11 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
>  
>  	kvm_arm_setup_mdcr_el2(vcpu);
>  
> -	/* Is Guest debugging in effect? */
> -	if (vcpu->guest_debug) {
> +	/*
> +	 * Check if the guest is being debugged or if the guest has enabled the
> +	 * OS lock.
> +	 */
> +	if (vcpu->guest_debug || kvm_vcpu_os_lock_enabled(vcpu)) {
>  		/* Save guest debug state */
>  		save_guest_debug_regs(vcpu);
>  
> @@ -223,6 +229,10 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
>  			trace_kvm_arm_set_regset("WAPTS", get_num_wrps(),
>  						&vcpu->arch.debug_ptr->dbg_wcr[0],
>  						&vcpu->arch.debug_ptr->dbg_wvr[0]);
> +		} else if (kvm_vcpu_os_lock_enabled(vcpu)) {
> +			mdscr = vcpu_read_sys_reg(vcpu, MDSCR_EL1);
> +			mdscr &= ~DBG_MDSCR_MDE;
> +			vcpu_write_sys_reg(vcpu, mdscr, MDSCR_EL1);

I think this is missing the case where the guest is being debugged by
userspace _and_ from inside (the guest) at the same time. In this
situation, the vmm gets a KVM_EXIT_DEBUG and if it doesn't know what to
do with it, it injects the exception into the guest (1). With this "else
if", the guest would still get the debug exception when the os lock is
enabled.

(1) kvm_arm_handle_debug() is the one doing this in QEMU source code.

>  		}
>  	}
>  
> @@ -244,7 +254,7 @@ void kvm_arm_clear_debug(struct kvm_vcpu *vcpu)
>  {
>  	trace_kvm_arm_clear_debug(vcpu->guest_debug);
>  
> -	if (vcpu->guest_debug) {
> +	if (vcpu->guest_debug || kvm_vcpu_os_lock_enabled(vcpu)) {
>  		restore_guest_debug_regs(vcpu);
>  
>  		/*
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index 275a27368a04..a7136888434d 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -119,6 +119,14 @@ static int kvm_handle_guest_debug(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_run *run = vcpu->run;
>  	u32 esr = kvm_vcpu_get_esr(vcpu);
> +	u8 esr_ec = ESR_ELx_EC(esr);
> +
> +	if (!vcpu->guest_debug) {
> +		WARN_ONCE(esr_ec != ESR_ELx_EC_BRK64 || esr_ec != ESR_ELx_EC_BKPT32,
> +			  "Unexpected debug exception\n");
> +		kvm_incr_pc(vcpu);
> +		return 1;
> +	}
>  
>  	run->exit_reason = KVM_EXIT_DEBUG;
>  	run->debug.arch.hsr = esr;
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index acd8aa2e5a44..d336e4c66870 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1446,9 +1446,9 @@ static unsigned int mte_visibility(const struct kvm_vcpu *vcpu,
>   * Debug handling: We do trap most, if not all debug related system
>   * registers. The implementation is good enough to ensure that a guest
>   * can use these with minimal performance degradation. The drawback is
> - * that we don't implement any of the external debug, none of the
> - * OSlock protocol. This should be revisited if we ever encounter a
> - * more demanding guest...
> + * that we don't implement any of the external debug architecture.
> + * This should be revisited if we ever encounter a more demanding
> + * guest...
>   */
>  static const struct sys_reg_desc sys_reg_descs[] = {
>  	{ SYS_DESC(SYS_DC_ISW), access_dcsw },
> -- 
> 2.33.1.1089.g2158813163f-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
