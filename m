Return-Path: <SRS0=/u//=IQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82237C433DB
	for <kvmarm@archiver.kernel.org>; Thu, 18 Mar 2021 14:11:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E974464F53
	for <kvmarm@archiver.kernel.org>; Thu, 18 Mar 2021 14:11:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E974464F53
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 67FB14B743;
	Thu, 18 Mar 2021 10:11:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GUMgZWngccwl; Thu, 18 Mar 2021 10:11:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C3EF4B746;
	Thu, 18 Mar 2021 10:11:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A72E54B731
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Mar 2021 10:11:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TQdjHZ0sNbEp for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Mar 2021 10:11:52 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ABEA04B6C8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Mar 2021 10:11:52 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C3E864E20;
 Thu, 18 Mar 2021 14:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1616076710;
 bh=4YnHl7gwi81S3iAatlqSlG18VzXM0SPmU2vgnSIIf3c=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=fh2gNeYjcMWWFPwQqw4SYwLfgxcV0fBUXg8sg3atSau6iSq6CVtcHPp52yB1lkqpm
 fj5jpdHAg5baOPGc3/Y9DzFKhMlVybiwVQecYwnIfgT10tJs1Bq0ro3ApT9UkWaiVC
 LMrmjLc39vwweMHb5cKh/qY7qePKmlEaptG5/BJ29L8pjO6t/Rc9vbEaDvC5sOgOhX
 lQKyJIm+8TbX8Ct5ntM2eHCYuT19ovuZsbv18x9Q+WzVZKaGp3V6a1dccAoj5NWuFi
 u9Qn7ODTHk4zaWrQVYT7B2O7N/doi1FfnRpBf+asYvE+SZb7Nhl3BEcV1KyxHUGMH2
 8hrCsRPyiZBNQ==
Date: Thu, 18 Mar 2021 14:11:44 +0000
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 09/11] KVM: arm64: Trap host SVE accesses when the
 FPSIMD state is dirty
Message-ID: <20210318141144.GE7055@willie-the-truck>
References: <20210318122532.505263-1-maz@kernel.org>
 <20210318122532.505263-10-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210318122532.505263-10-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 kvmarm@lists.cs.columbia.edu, broonie@kernel.org, kernel-team@android.com,
 dave.martin@arm.com, linux-arm-kernel@lists.infradead.org, daniel.kiss@arm.com
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

On Thu, Mar 18, 2021 at 12:25:30PM +0000, Marc Zyngier wrote:
> ZCR_EL2 controls the upper bound for ZCR_EL1, and is set to
> a potentially lower limit when the guest uses SVE. In order
> to restore the SVE state on the EL1 host, we must first
> reset ZCR_EL2 to its original value.
> 
> To make it as lazy as possible on the EL1 host side, set
> the SVE trapping in place when returning exiting from

"returning exiting"?

> diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
> index f3d0e9eca56c..60adc7ff4caa 100644
> --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> @@ -68,7 +68,7 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
>  static void __deactivate_traps(struct kvm_vcpu *vcpu)
>  {
>  	extern char __kvm_hyp_host_vector[];
> -	u64 mdcr_el2;
> +	u64 mdcr_el2, cptr;
>  
>  	___deactivate_traps(vcpu);
>  
> @@ -101,7 +101,12 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
>  		write_sysreg(HCR_HOST_NVHE_PROTECTED_FLAGS, hcr_el2);
>  	else
>  		write_sysreg(HCR_HOST_NVHE_FLAGS, hcr_el2);
> -	write_sysreg(CPTR_EL2_DEFAULT, cptr_el2);
> +
> +	cptr = CPTR_EL2_DEFAULT;
> +	if (vcpu_has_sve(vcpu) && (vcpu->arch.flags & KVM_ARM64_FP_ENABLED))
> +		cptr |= CPTR_EL2_TZ;

Acked-by: Will Deacon <will@kernel.org>

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
