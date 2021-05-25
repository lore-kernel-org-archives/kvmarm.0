Return-Path: <SRS0=drPj=KU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 282FCC47084
	for <kvmarm@archiver.kernel.org>; Tue, 25 May 2021 09:21:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8E91D61437
	for <kvmarm@archiver.kernel.org>; Tue, 25 May 2021 09:21:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8E91D61437
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0397749F8F;
	Tue, 25 May 2021 05:21:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kTVvF9yPFyP8; Tue, 25 May 2021 05:21:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C62194B082;
	Tue, 25 May 2021 05:21:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B3DC4AC78
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 May 2021 05:21:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ATA5zYmOMnqU for <kvmarm@lists.cs.columbia.edu>;
 Tue, 25 May 2021 05:21:05 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 28ECB49F8F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 May 2021 05:21:05 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 592C56D;
 Tue, 25 May 2021 02:21:04 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.37.142])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2F3913F73D;
 Tue, 25 May 2021 02:21:01 -0700 (PDT)
Date: Tue, 25 May 2021 10:20:54 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2] KVM: arm64: Prevent mixed-width VM creation
Message-ID: <20210525092054.GA31646@C02TD0UTHF1T.local>
References: <20210524170752.1549797-1-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210524170752.1549797-1-maz@kernel.org>
Cc: kernel-team@android.com, stable@vger.kernel.org,
 Steven Price <steven.price@arm.com>, kvmarm@lists.cs.columbia.edu,
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

On Mon, May 24, 2021 at 06:07:52PM +0100, Marc Zyngier wrote:
> It looks like we have tolerated creating mixed-width VMs since...
> forever. However, that was never the intention, and we'd rather
> not have to support that pointless complexity.
> 
> Forbid such a setup by making sure all the vcpus have the same
> register width.
> 
> Reported-by: Steven Price <steven.price@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Cc: stable@vger.kernel.org

Looks good to me!

Acked-by: Mark Rutland <mark.rutland@arm.com>

Mark.

> ---
> 
> Notes:
>     v2: Fix missing check against ARM64_HAS_32BIT_EL1 (Mark)
> 
>  arch/arm64/include/asm/kvm_emulate.h |  5 +++++
>  arch/arm64/kvm/reset.c               | 28 ++++++++++++++++++++++++----
>  2 files changed, 29 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index f612c090f2e4..01b9857757f2 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -463,4 +463,9 @@ static __always_inline void kvm_incr_pc(struct kvm_vcpu *vcpu)
>  	vcpu->arch.flags |= KVM_ARM64_INCREMENT_PC;
>  }
>  
> +static inline bool vcpu_has_feature(struct kvm_vcpu *vcpu, int feature)
> +{
> +	return test_bit(feature, vcpu->arch.features);
> +}
> +
>  #endif /* __ARM64_KVM_EMULATE_H__ */
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index 956cdc240148..d37ebee085cf 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -166,6 +166,25 @@ static int kvm_vcpu_enable_ptrauth(struct kvm_vcpu *vcpu)
>  	return 0;
>  }
>  
> +static bool vcpu_allowed_register_width(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_vcpu *tmp;
> +	bool is32bit;
> +	int i;
> +
> +	is32bit = vcpu_has_feature(vcpu, KVM_ARM_VCPU_EL1_32BIT);
> +	if (!cpus_have_const_cap(ARM64_HAS_32BIT_EL1) && is32bit)
> +		return false;
> +
> +	/* Check that the vcpus are either all 32bit or all 64bit */
> +	kvm_for_each_vcpu(i, tmp, vcpu->kvm) {
> +		if (vcpu_has_feature(tmp, KVM_ARM_VCPU_EL1_32BIT) != is32bit)
> +			return false;
> +	}
> +
> +	return true;
> +}
> +
>  /**
>   * kvm_reset_vcpu - sets core registers and sys_regs to reset value
>   * @vcpu: The VCPU pointer
> @@ -217,13 +236,14 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>  		}
>  	}
>  
> +	if (!vcpu_allowed_register_width(vcpu)) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
>  	switch (vcpu->arch.target) {
>  	default:
>  		if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features)) {
> -			if (!cpus_have_const_cap(ARM64_HAS_32BIT_EL1)) {
> -				ret = -EINVAL;
> -				goto out;
> -			}
>  			pstate = VCPU_RESET_PSTATE_SVC;
>  		} else {
>  			pstate = VCPU_RESET_PSTATE_EL1;
> -- 
> 2.30.2
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
