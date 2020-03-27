Return-Path: <SRS0=88wp=5M=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9893C43331
	for <kvmarm@archiver.kernel.org>; Fri, 27 Mar 2020 16:12:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3758E20716
	for <kvmarm@archiver.kernel.org>; Fri, 27 Mar 2020 16:12:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3758E20716
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 97EA14A534;
	Fri, 27 Mar 2020 12:12:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id C8VETOidi2pb; Fri, 27 Mar 2020 12:12:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 527944A522;
	Fri, 27 Mar 2020 12:12:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 645824A4FC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Mar 2020 12:12:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iIEdSbZMa-tc for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Mar 2020 12:12:00 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 348A14A4E5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Mar 2020 12:12:00 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B42E31FB;
 Fri, 27 Mar 2020 09:11:59 -0700 (PDT)
Received: from [172.16.1.108] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 42F6A3F71F;
 Fri, 27 Mar 2020 09:11:57 -0700 (PDT)
Subject: Re: [RFC PATCH] arm64: unify WORKAROUND_SPECULATIVE_AT_{NVHE,VHE}
To: Andrew Scull <ascull@google.com>
References: <20200327143941.195626-1-ascull@google.com>
From: James Morse <james.morse@arm.com>
Openpgp: preference=signencrypt
Message-ID: <a8cc7a17-cb84-3e52-15f4-87b27a01876b@arm.com>
Date: Fri, 27 Mar 2020 16:11:56 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200327143941.195626-1-ascull@google.com>
Content-Language: en-US
Cc: qwandor@google.com, Marc Zyngier <maz@kernel.org>,
 Steven Price <steven.price@arm.com>, Will Deacon <will@kernel.org>,
 wedsonaf@google.com, linux-arm-kernel@lists.infradead.org, dbrazdil@google.com,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu, tabba@google.com
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

Hi Andrew,

On 3/27/20 2:39 PM, Andrew Scull wrote:
> Errata 1165522, 1319367 and 1530923 each allow TLB entries to be
> allocated as a result of a speculative AT instruction. In order to
> avoid mandating VHE on certain affected CPUs, apply the workaround to
> both the nVHE and the VHE case for all affected CPUs.

You're booting a VHE capable system without VHE, and need KVM?
Do tell!

Would enabling the nVHE workaround on a VHE capable part solve your problem?
Merging the errata has some side effects...


> ---
> I'm not able to test the workarounds properly for the affected CPUs but
> have built and booted under qemu configs with and without VHE as well as
> the workaround being enabled and disabled.
> 
> As there exist work arounds for nVHE and VHE, it doesn't appear to be a
> technical limitation that meant VHE was being mandated. Please correct
> me if this understanding is inaccurate. Thanks!

The affected VHE parts came first. Then came those that didn't have VHE at all.


> diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
> index 7672a978926c..2c1436fc0830 100644
> --- a/arch/arm64/kvm/hyp/sysreg-sr.c
> +++ b/arch/arm64/kvm/hyp/sysreg-sr.c
> @@ -118,7 +118,7 @@ static void __hyp_text __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
>  	write_sysreg(ctxt->sys_regs[MPIDR_EL1],		vmpidr_el2);
>  	write_sysreg(ctxt->sys_regs[CSSELR_EL1],	csselr_el1);
>  
> -	if (!cpus_have_const_cap(ARM64_WORKAROUND_SPECULATIVE_AT_NVHE)) {
> +	if (!cpus_have_const_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
>  		write_sysreg_el1(ctxt->sys_regs[SCTLR_EL1],	SYS_SCTLR);
>  		write_sysreg_el1(ctxt->sys_regs[TCR_EL1],	SYS_TCR);
>  	} else	if (!ctxt->__hyp_running_vcpu) {

The comment just below here:
|		/*
|		 * Must only be done for guest registers, hence the context
|		 * test. We're coming from the host, so SCTLR.M is already
|		 * set. Pairs with __activate_traps_nvhe().
|		 */

The VHE parts aren't going to run __activate_traps_nvhe(), so you skip restoring
the guest's SCTLR_EL1 and TCR_EL1...


Thanks,

James
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
