Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E48ECFA3740
	for <kvmarm@archiver.kernel.org>; Thu, 27 Oct 2022 14:52:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 598AA413E2;
	Thu, 27 Oct 2022 10:52:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eAqjvKOzsRdb; Thu, 27 Oct 2022 10:52:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B46B48A48;
	Thu, 27 Oct 2022 10:52:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F754413E2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Oct 2022 10:52:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VdG9R6eiHwtv for <kvmarm@lists.cs.columbia.edu>;
 Thu, 27 Oct 2022 10:52:34 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F113C40DE6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Oct 2022 10:52:32 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ADC3223A;
 Thu, 27 Oct 2022 07:52:38 -0700 (PDT)
Received: from [10.1.31.29] (e122027.cambridge.arm.com [10.1.31.29])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 433313F7B4;
 Thu, 27 Oct 2022 07:52:30 -0700 (PDT)
Message-ID: <73681d8e-95ab-aa1b-ddd3-5ada79321901@arm.com>
Date: Thu, 27 Oct 2022 15:52:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v1] KVM: arm64: Fix bad dereference on MTE-enabled systems.
To: Ryan Roberts <ryan.roberts@arm.com>, Marc Zyngier <maz@kernel.org>
References: <20221027120945.29679-1-ryan.roberts@arm.com>
Content-Language: en-GB
From: Steven Price <steven.price@arm.com>
In-Reply-To: <20221027120945.29679-1-ryan.roberts@arm.com>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
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

On 27/10/2022 13:09, Ryan Roberts wrote:
> enter_exception64() performs an MTE check, which involves dereferencing
> vcpu->kvm. While vcpu has already been fixed up for hyp va, kvm is still
> a kern va pointer.
> 
> Fix this by first converting kvm to a hyp va pointer. If the system does
> not support MTE, the dereference is avoided in the first place.
> 
> Fixes: ea7fc1bb1cd1 ("KVM: arm64: Introduce MTE VM feature")
> 
> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>

It's worth pointing out this only affects non-VHE mode, which is unusual
on hardware which supports MTE (and therefore VHE). But, of course,
about to get more usual with pKVM.

Reviewed-by: Steven Price <steven.price@arm.com>

> ---
>  arch/arm64/kvm/hyp/exception.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/hyp/exception.c b/arch/arm64/kvm/hyp/exception.c
> index b7557b25ed56..791d3de76771 100644
> --- a/arch/arm64/kvm/hyp/exception.c
> +++ b/arch/arm64/kvm/hyp/exception.c
> @@ -13,6 +13,7 @@
>  #include <hyp/adjust_pc.h>
>  #include <linux/kvm_host.h>
>  #include <asm/kvm_emulate.h>
> +#include <asm/kvm_mmu.h>
> 
>  #if !defined (__KVM_NVHE_HYPERVISOR__) && !defined (__KVM_VHE_HYPERVISOR__)
>  #error Hypervisor code only!
> @@ -115,7 +116,7 @@ static void enter_exception64(struct kvm_vcpu *vcpu, unsigned long target_mode,
>  	new |= (old & PSR_C_BIT);
>  	new |= (old & PSR_V_BIT);
> 
> -	if (kvm_has_mte(vcpu->kvm))
> +	if (kvm_has_mte(kern_hyp_va(vcpu->kvm)))
>  		new |= PSR_TCO_BIT;
> 
>  	new |= (old & PSR_DIT_BIT);
> --
> 2.17.1
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
