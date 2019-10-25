Return-Path: <SRS0=vP85=YS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 346E2CA9EA0
	for <kvmarm@archiver.kernel.org>; Fri, 25 Oct 2019 14:41:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AF6A62053B
	for <kvmarm@archiver.kernel.org>; Fri, 25 Oct 2019 14:41:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AF6A62053B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 06F714A541;
	Fri, 25 Oct 2019 10:41:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id l0Pm5E92qtEJ; Fri, 25 Oct 2019 10:41:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E098C4A5A3;
	Fri, 25 Oct 2019 10:41:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D772A4A51F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Oct 2019 10:41:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Itg+HMlASgPO for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 Oct 2019 10:41:06 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CC3B54A51C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Oct 2019 10:41:06 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 62CE328;
 Fri, 25 Oct 2019 07:41:06 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4226D3F71A;
 Fri, 25 Oct 2019 07:41:05 -0700 (PDT)
Date: Fri, 25 Oct 2019 15:41:03 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH] KVM: arm64: Don't set HCR_EL2.TVM when S2FWB is supported
Message-ID: <20191025144102.GF40270@lakrids.cambridge.arm.com>
References: <20191025135144.8805-1-christoffer.dall@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20191025135144.8805-1-christoffer.dall@arm.com>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

[correcitng Marc's address]

On Fri, Oct 25, 2019 at 03:51:44PM +0200, Christoffer Dall wrote:
> On CPUs that support S2FWB (Armv8.4+), KVM configures the stage 2 page
> tables to override the memory attributes of memory accesses, regardless
> of the stage 1 page table configurations, and also when the stage 1 MMU
> is turned off.  This results in all memory accesses to RAM being
> cacheable, including during early boot of the guest.
> 
> On CPUs without this feature, memory accesses were non-cacheable during
> boot until the guest turned on the stage 1 MMU, and we had to detect
> when the guest turned on the MMU, such that we could invalidate all cache
> entries and ensure a consistent view of memory with the MMU turned on.
> When the guest turned on the caches, we would call stage2_flush_vm()
> from kvm_toggle_cache().
> 
> However, stage2_flush_vm() walks all the stage 2 tables, and calls
> __kvm_flush-dcache_pte, which on a system with S2FWD does ... absolutely
> nothing.
> 
> We can avoid that whole song and dance, and simply not set TVM when
> creating a VM on a systme that has S2FWB.

Typo: s/systme/system/
 
> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
> I was only able to test this on the model with cache modeling enabled,
> but even removing TVM from HCR_EL2 without having FWB also worked with
> that setup, so the testing of this has been light.  It seems like it
> should obviously work, but it would be good if someone with access to
> appropriate hardware could give this a spin.

I'm afraid I don't have such hardware to test on, but this does make
sense to me based on my understanding of the behaviour of FWB.

>  arch/arm64/include/asm/kvm_emulate.h | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index d69c1efc63e7..41820c3e70b8 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -53,8 +53,10 @@ static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
>  		/* trap error record accesses */
>  		vcpu->arch.hcr_el2 |= HCR_TERR;
>  	}
> -	if (cpus_have_const_cap(ARM64_HAS_STAGE2_FWB))
> +	if (cpus_have_const_cap(ARM64_HAS_STAGE2_FWB)) {
> +		vcpu->arch.hcr_el2 &= ~HCR_TVM;
>  		vcpu->arch.hcr_el2 |= HCR_FWB;
> +	}

Given we also later nuke this fit for !FWB, maybe we want to take it out
of HCR_GUEST_FLAGS and have:

	if (cpus_have_const_cap(ARM64_HAS_STAGE2_FWB))
		vcpu->arch.hcr_el2 |= HCR_FWB;
	else
		vcpu->arch.hcr_el2 |= HCR_TVM;

Either way:

Reviewed-by: Mark Rutlamd <mark.rutland@arm.com>

Thanks,
Mark.

>  
>  	if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features))
>  		vcpu->arch.hcr_el2 &= ~HCR_RW;
> -- 
> 2.18.0
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
