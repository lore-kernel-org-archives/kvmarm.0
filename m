Return-Path: <SRS0=LqQy=H4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 064E7C433DB
	for <kvmarm@archiver.kernel.org>; Fri, 26 Feb 2021 18:35:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 648A064F2B
	for <kvmarm@archiver.kernel.org>; Fri, 26 Feb 2021 18:35:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 648A064F2B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DD1814B299;
	Fri, 26 Feb 2021 13:35:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rC3gpzzHvArj; Fri, 26 Feb 2021 13:35:48 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DBFF4B25B;
	Fri, 26 Feb 2021 13:35:48 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 697384B24E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Feb 2021 13:35:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id i9qRcYc3uZiq for <kvmarm@lists.cs.columbia.edu>;
 Fri, 26 Feb 2021 13:35:45 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7CA1A4B24D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Feb 2021 13:35:45 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 5692A601FC;
 Fri, 26 Feb 2021 18:35:44 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1lFhxm-00G5ts-9K; Fri, 26 Feb 2021 18:35:42 +0000
MIME-Version: 1.0
Date: Fri, 26 Feb 2021 18:35:42 +0000
From: Marc Zyngier <maz@kernel.org>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Avoid corrupting vCPU context register in
 guest exit
In-Reply-To: <20210226181211.14542-1-will@kernel.org>
References: <20210226181211.14542-1-will@kernel.org>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <f6b11e03ac9f0a4830e0a8f56a91450f@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: will@kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 ascull@google.com, stable@vger.kernel.org, qperret@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: stable@vger.kernel.org, kernel-team@android.com,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2021-02-26 18:12, Will Deacon wrote:
> Commit 7db21530479f ("KVM: arm64: Restore hyp when panicking in guest
> context") tracks the currently running vCPU, clearing the pointer to
> NULL on exit from a guest.
> 
> Unfortunately, the use of 'set_loaded_vcpu' clobbers x1 to point at the
> kvm_hyp_ctxt instead of the vCPU context, causing the subsequent RAS
> code to go off into the weeds when it saves the DISR assuming that the
> CPU context is embedded in a struct vCPU.
> 
> Leave x1 alone and use x3 as a temporary register instead when clearing
> the vCPU on the guest exit path.
> 
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Andrew Scull <ascull@google.com>
> Cc: <stable@vger.kernel.org>
> Fixes: 7db21530479f ("KVM: arm64: Restore hyp when panicking in guest 
> context")
> Suggested-by: Quentin Perret <qperret@google.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
> 
> This was pretty awful to debug!
> 
>  arch/arm64/kvm/hyp/entry.S | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
> index b0afad7a99c6..0c66a1d408fd 100644
> --- a/arch/arm64/kvm/hyp/entry.S
> +++ b/arch/arm64/kvm/hyp/entry.S
> @@ -146,7 +146,7 @@ SYM_INNER_LABEL(__guest_exit, SYM_L_GLOBAL)
>  	// Now restore the hyp regs
>  	restore_callee_saved_regs x2
> 
> -	set_loaded_vcpu xzr, x1, x2
> +	set_loaded_vcpu xzr, x2, x3
> 
>  alternative_if ARM64_HAS_RAS_EXTN
>  	// If we have the RAS extensions we can consume a pending error

Grmbl... How comes we have never seen that for the past 5 months,
including on CPUs that implement RAS?

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
