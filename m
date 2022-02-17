Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DEE9C433FE
	for <kvmarm@archiver.kernel.org>; Thu, 17 Feb 2022 13:41:02 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 63D5E49EF2;
	Thu, 17 Feb 2022 08:41:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7-J5Gp6FAvaz; Thu, 17 Feb 2022 08:41:00 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BE442408BA;
	Thu, 17 Feb 2022 08:41:00 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 28333407ED
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Feb 2022 08:40:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id X5e36PiasrSt for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Feb 2022 08:40:57 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6E99A40597
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Feb 2022 08:40:57 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 2FB65B8212B;
 Thu, 17 Feb 2022 13:40:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4782C340E9;
 Thu, 17 Feb 2022 13:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1645105255;
 bh=Ss67S13WIbOTQNO32Um4TEuBFG3UFPz44UqCkkF0YeY=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=tNXUrNV6GCVRn8Exm/tkHGSQNU2vydVaAUyZUS4vmCWuVjZSKfQgFNoktfJ0yncsC
 wNjmdHax6vkMTfzCSQiVAXfhQN4hFOJ+ddKZwLCBKqtnqug/N1GNd/7UDPTkrqjDOP
 1NJ+wpj+kiIan6fWo+4irQpE2/THtRLB3VQ3d40wNA+EETfw+1pCg9/q2tSMF/v2fX
 omlbfcmxXlVFxvI5cfyhiPFGlOJIfjufhhlVsZ+vwbV+4+jcrr7ch2xSmBthbPx6Cr
 0Qe7O57eRV9tqgTfcxmZoLId0d+ZYasoidhx6mwm6+DcPcg6kgu+tcwqVKSN+iNIaL
 uZ+CYoBONIcUA==
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nKh1h-008a8W-Hp; Thu, 17 Feb 2022 13:40:53 +0000
MIME-Version: 1.0
Date: Thu, 17 Feb 2022 13:40:53 +0000
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oupton@google.com>
Subject: Re: [PATCH] KVM: arm64: Don't miss pending interrupts for suspended
 vCPU
In-Reply-To: <20220217101242.3013716-1-oupton@google.com>
References: <20220217101242.3013716-1-oupton@google.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <aa6851d90aeb0dfade28527687253219@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: oupton@google.com, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, james.morse@arm.com, alexandru.elisei@arm.com,
 suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org,
 pshier@google.com, ricarkol@google.com, reijiw@google.com, pbonzini@redhat.com,
 seanjc@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, Peter Shier <pshier@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2022-02-17 10:12, Oliver Upton wrote:
> In order to properly emulate the WFI instruction, KVM reads back
> ICH_VMCR_EL2 and enables doorbells for GICv4. These preparations are
> necessary in order to recognize pending interrupts in
> kvm_arch_vcpu_runnable() and return to the guest. Until recently, this
> work was done by kvm_arch_vcpu_{blocking,unblocking}(). Since commit
> 6109c5a6ab7f ("KVM: arm64: Move vGIC v4 handling for WFI out arch
> callback hook"), these callbacks were gutted and superseded by
> kvm_vcpu_wfi().
> 
> It is important to note that KVM implements PSCI CPU_SUSPEND calls as
> a WFI within the guest. However, the implementation calls directly into
> kvm_vcpu_halt(), which skips the needed work done in kvm_vcpu_wfi()
> to detect pending interrupts. Fix the issue by calling the WFI helper.
> 
> Fixes: 6109c5a6ab7f ("KVM: arm64: Move vGIC v4 handling for WFI out
> arch callback hook")
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/arm64/kvm/psci.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
> index 3eae32876897..2ce60fecd861 100644
> --- a/arch/arm64/kvm/psci.c
> +++ b/arch/arm64/kvm/psci.c
> @@ -46,8 +46,7 @@ static unsigned long kvm_psci_vcpu_suspend(struct
> kvm_vcpu *vcpu)
>  	 * specification (ARM DEN 0022A). This means all suspend states
>  	 * for KVM will preserve the register state.
>  	 */
> -	kvm_vcpu_halt(vcpu);
> -	kvm_clear_request(KVM_REQ_UNHALT, vcpu);
> +	kvm_vcpu_wfi(vcpu);
> 
>  	return PSCI_RET_SUCCESS;
>  }

Thanks for picking this up, I kept forgetting about fixing it.
I'll merge it once I'm back home.

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
