Return-Path: <SRS0=FDwM=5C=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 845C1C2BB1D
	for <kvmarm@archiver.kernel.org>; Tue, 17 Mar 2020 13:59:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 140E5205ED
	for <kvmarm@archiver.kernel.org>; Tue, 17 Mar 2020 13:59:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 140E5205ED
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5FB094B08A;
	Tue, 17 Mar 2020 09:59:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MfT+3tPYEM-J; Tue, 17 Mar 2020 09:59:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 239E84A522;
	Tue, 17 Mar 2020 09:59:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ACF7F4A522
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Mar 2020 09:59:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rzgkACouWyO8 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Mar 2020 09:59:42 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E55E4A1B0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Mar 2020 09:59:42 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DAF01FEC;
 Tue, 17 Mar 2020 06:59:41 -0700 (PDT)
Received: from [10.37.12.184] (unknown [10.37.12.184])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8C0E73F534;
 Tue, 17 Mar 2020 06:59:40 -0700 (PDT)
Subject: Re: [PATCH] KVM: arm64: Use the correct timer for accessing CNT
To: KarimAllah Ahmed <karahmed@amazon.de>
References: <1584351546-5018-1-git-send-email-karahmed@amazon.de>
From: James Morse <james.morse@arm.com>
Openpgp: preference=signencrypt
Message-ID: <ac2933bf-452a-f27a-2d8a-8299c3044111@arm.com>
Date: Tue, 17 Mar 2020 13:59:38 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1584351546-5018-1-git-send-email-karahmed@amazon.de>
Content-Language: en-US
Cc: Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
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

Hi KarimAllah,

On 3/16/20 9:39 AM, KarimAllah Ahmed wrote:
> Use the physical timer object when reading the physical timer counter
> instead of using the virtual timer object. This is only visible when
> reading it from user-space as kvm_arm_timer_get_reg() is only executed on
> the get register patch from user-space.

Have you seen this go wrong?

I agree this looks like this was a typo introduced by:
84135d3d1 ("KVM: arm/arm64: consolidate arch timer trap handlers")
-----------------%<-----------------
        case KVM_REG_ARM_PTIMER_CNT:
-               return kvm_phys_timer_read();
+               return kvm_arm_timer_read(vcpu,
+                                         vcpu_vtimer(vcpu), TIMER_REG_CNT);
-----------------%<-----------------

This would be a problem when the guest reads the physical counter
directly, (which doesn't get trapped), and the VMM makes this API call
and gets a number in a totally different ball-park.


Can the VMM actually read these registers with this path?

kvm_arm_get_reg() gets to filter out the coproc registers that aren't in
the sys_reg[], it also uses is_timer_reg() to spot the timer/counter
registers, but is_timer_reg() only matches three of them:
|	case KVM_REG_ARM_TIMER_CTL:
|	case KVM_REG_ARM_TIMER_CNT:
|	case KVM_REG_ARM_TIMER_CVAL:

KVM_REG_ARM_PTIMER_CNT is not one of them.

It looks like when the VMM tries to read this, it fails is_timer_reg(),
and matches in the sys_regs[] and is handled by access_arch_timer(),
which uses kvm_arm_timer_read_sysreg() -> kvm_arm_timer_read(),
bypassing this bug.

... this looks like a bug in dead code ...


Thanks!

James

> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index 0d9438e..93bd59b 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -788,7 +788,7 @@ u64 kvm_arm_timer_get_reg(struct kvm_vcpu *vcpu, u64 regid)
>  					  vcpu_ptimer(vcpu), TIMER_REG_CTL);
>  	case KVM_REG_ARM_PTIMER_CNT:
>  		return kvm_arm_timer_read(vcpu,
> -					  vcpu_vtimer(vcpu), TIMER_REG_CNT);
> +					  vcpu_ptimer(vcpu), TIMER_REG_CNT);
>  	case KVM_REG_ARM_PTIMER_CVAL:
>  		return kvm_arm_timer_read(vcpu,
>  					  vcpu_ptimer(vcpu), TIMER_REG_CVAL);
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
