Return-Path: <SRS0=phmX=MT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12683C4338F
	for <kvmarm@archiver.kernel.org>; Tue, 27 Jul 2021 18:11:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B798560F59
	for <kvmarm@archiver.kernel.org>; Tue, 27 Jul 2021 18:11:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B798560F59
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5AD9A4A524;
	Tue, 27 Jul 2021 14:11:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Js5sS1vY0-Tf; Tue, 27 Jul 2021 14:11:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 523794A531;
	Tue, 27 Jul 2021 14:11:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D45D14AEDC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Jul 2021 14:11:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ay-KBcyyHfXp for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Jul 2021 14:11:26 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DBAFE4A524
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Jul 2021 14:11:26 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 01DAC60238;
 Tue, 27 Jul 2021 18:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1627409486;
 bh=0Jhkgmh6Ersm+31Lg4gnjVYrCD7edJaSvbSGVWBYdT4=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=aEo+ZjkFl3s1oc/YPiigC8mZLpoTBobYxMg7UMrG5iZwmmZ5CUVeiYXiDwiderPT8
 3JZVL7uOJSbxd9ws0mVcCkV3pQprki0dluggC5mgJtgLBl2Gknzl/vOF60otnzx+yk
 1lqJ8f3bStaeaueb2NFv8oYwwqUmHS0fm+0w5lnCPRSM4fUQh9nDqR25XOzOFgb4YO
 gP975XKAkYFibjNx5fQUL5qG8dTFZEDN0cB+rGT/5Nesv2P2d8R3f0GYSI2PHU7oOw
 mAIBJWyrbth71xGb9Gg3BtEkv8kCrqDr8M8OE2KkazLDrB0RLy6OTfQvCBOVcYZg1R
 kUi+UtM2Y9SNQ==
Date: Tue, 27 Jul 2021 19:11:21 +0100
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 05/16] KVM: arm64: Plumb MMIO checking into the fault
 handling
Message-ID: <20210727181120.GD19173@willie-the-truck>
References: <20210715163159.1480168-1-maz@kernel.org>
 <20210715163159.1480168-6-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210715163159.1480168-6-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: kvm@vger.kernel.org, kernel-team@android.com,
 Srivatsa Vaddagiri <vatsa@codeaurora.org>, linux-kernel@vger.kernel.org,
 Shanker R Donthineni <sdonthineni@nvidia.com>, kvmarm@lists.cs.columbia.edu,
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

On Thu, Jul 15, 2021 at 05:31:48PM +0100, Marc Zyngier wrote:
> Plumb the MMIO checking code into the MMIO fault handling code.
> Nothing allows a region to be registered yet, so there should be
> no funtional change either.

Typo: functional

> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/mmio.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/arch/arm64/kvm/mmio.c b/arch/arm64/kvm/mmio.c
> index 3dd38a151d2a..fd5747279d27 100644
> --- a/arch/arm64/kvm/mmio.c
> +++ b/arch/arm64/kvm/mmio.c
> @@ -6,6 +6,7 @@
>  
>  #include <linux/kvm_host.h>
>  #include <asm/kvm_emulate.h>
> +#include <asm/kvm_mmu.h>
>  #include <trace/events/kvm.h>
>  
>  #include "trace.h"
> @@ -130,6 +131,10 @@ int io_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
>  	int len;
>  	u8 data_buf[8];
>  
> +	/* Check failed? Return to the guest for debriefing... */
> +	if (!kvm_check_ioguard_page(vcpu, fault_ipa))
> +		return 1;
> +
>  	/*
>  	 * No valid syndrome? Ask userspace for help if it has
>  	 * volunteered to do so, and bail out otherwise.
> @@ -156,6 +161,11 @@ int io_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
>  	len = kvm_vcpu_dabt_get_as(vcpu);
>  	rt = kvm_vcpu_dabt_get_rd(vcpu);
>  
> +	/* If we cross a page boundary, check that too... */
> +	if (((fault_ipa + len - 1) & PAGE_MASK) != (fault_ipa & PAGE_MASK) &&
> +	    !kvm_check_ioguard_page(vcpu, fault_ipa + len - 1))
> +		return 1;
> +

I find this a little odd as the checks straddle the invalid syndrome check,
meaning that the relative priorities of KVM_ARCH_FLAG_MMIO_GUARD and
KVM_ARCH_FLAG_RETURN_NISV_IO_ABORT_TO_USER are unclear.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
