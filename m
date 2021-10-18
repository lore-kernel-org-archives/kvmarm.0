Return-Path: <SRS0=YGC0=PG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8A33C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 18 Oct 2021 17:12:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2520E60FC3
	for <kvmarm@archiver.kernel.org>; Mon, 18 Oct 2021 17:12:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2520E60FC3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 952804B27F;
	Mon, 18 Oct 2021 13:12:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6Cd7jI1dx3cV; Mon, 18 Oct 2021 13:12:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8FA4C4B272;
	Mon, 18 Oct 2021 13:12:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 700FC4B261
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Oct 2021 13:12:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GLpBCjTlOM5I for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Oct 2021 13:12:25 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3873B4B25F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Oct 2021 13:12:25 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 2DC2060F9D;
 Mon, 18 Oct 2021 17:12:24 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mcWBS-0001xi-5Z; Mon, 18 Oct 2021 18:12:22 +0100
MIME-Version: 1.0
Date: Mon, 18 Oct 2021 18:12:22 +0100
From: Marc Zyngier <maz@kernel.org>
To: Quentin Perret <qperret@google.com>
Subject: Re: [PATCH 16/16] KVM: arm64: pkvm: Unshare guest structs during
 teardown
In-Reply-To: <YW1+mQ6Bn2HXwl34@google.com>
References: <20211013155831.943476-1-qperret@google.com>
 <20211013155831.943476-17-qperret@google.com> <87h7dhupfa.wl-maz@kernel.org>
 <YW1NLb9Pn9NyEYZF@google.com> <YW1+mQ6Bn2HXwl34@google.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <3ec8ab06f9950a13818109051835fdb9@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: qperret@google.com, james.morse@arm.com,
 alexandru.elisei@arm.com, suzuki.poulose@arm.com, catalin.marinas@arm.com,
 will@kernel.org, tabba@google.com, dbrazdil@google.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 linux-kernel@vger.kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
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

On 2021-10-18 15:03, Quentin Perret wrote:
> On Monday 18 Oct 2021 at 11:32:13 (+0100), Quentin Perret wrote:
>> Another option is to take a refcount on 'current' from
>> kvm_arch_vcpu_run_map_fp() before sharing thread-specific structs with
>> the hyp and release the refcount of the previous task after unsharing.
>> But that means we'll have to also drop the refcount when the vcpu
>> gets destroyed, as well as explicitly unshare at that point. Shouldn't
>> be too bad I think. Thoughts?
> 
> Something like the below seems to work OK on my setup, including
> SIGKILL'ing the guest and such. How much do you hate it?

It is annoyingly elegant! Small nitpick below.

> 
> diff --git a/arch/arm64/include/asm/kvm_host.h
> b/arch/arm64/include/asm/kvm_host.h
> index f8be56d5342b..50598d704c71 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -322,6 +322,7 @@ struct kvm_vcpu_arch {
> 
>  	struct thread_info *host_thread_info;	/* hyp VA */
>  	struct user_fpsimd_state *host_fpsimd_state;	/* hyp VA */
> +	struct task_struct *parent_task;
> 
>  	struct {
>  		/* {Break,watch}point registers */
> @@ -738,6 +739,7 @@ int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu 
> *vcpu);
>  void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu);
>  void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu);
>  void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu);
> +void kvm_vcpu_unshare_task_fp(struct kvm_vcpu *vcpu);
> 
>  static inline bool kvm_pmu_counter_deferred(struct perf_event_attr 
> *attr)
>  {
> diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
> index 2fe1128d9f3d..27afeebbe1cb 100644
> --- a/arch/arm64/kvm/fpsimd.c
> +++ b/arch/arm64/kvm/fpsimd.c
> @@ -15,6 +15,22 @@
>  #include <asm/kvm_mmu.h>
>  #include <asm/sysreg.h>
> 
> +void kvm_vcpu_unshare_task_fp(struct kvm_vcpu *vcpu)
> +{
> +	struct task_struct *p = vcpu->arch.parent_task;
> +	struct user_fpsimd_state *fpsimd;
> +	struct thread_info *ti;
> +
> +	if (!static_branch_likely(&kvm_protected_mode_initialized) || !p)

Shouldn't this be a check on is_protected_kvm_enabled() instead?
The two should be equivalent outside of the initialisation code...

Otherwise, ship it.

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
