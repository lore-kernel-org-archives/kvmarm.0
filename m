Return-Path: <SRS0=phmX=MT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E6DFC4338F
	for <kvmarm@archiver.kernel.org>; Tue, 27 Jul 2021 18:10:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 043AC60F58
	for <kvmarm@archiver.kernel.org>; Tue, 27 Jul 2021 18:10:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 043AC60F58
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A12B4AEE2;
	Tue, 27 Jul 2021 14:10:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RpRifjyX9CkD; Tue, 27 Jul 2021 14:10:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D57C84A531;
	Tue, 27 Jul 2021 14:10:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 40E254A500
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Jul 2021 14:10:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pEGHBBYrUFMz for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Jul 2021 14:10:34 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 416884A19A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Jul 2021 14:10:34 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A0B060F4F;
 Tue, 27 Jul 2021 18:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1627409433;
 bh=eAQ6Y5NFEbqzK+Qxa6eEtOaPVZxtmmYG8Cp8wn4awk0=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=ZUdLTBGArL4F4dnHexEQOVZW0mHKBsiDWS3JVNmUjI74QPdj4B6Ri+jpbUV/xu6vi
 eR6EWfI50nJjGQ/Ud9qNfpzAu7g5qbFLSRBRr9LLgHzuiDlwmyBpqwt1rksx5FXj+W
 RjKFbP2JQp0zt2oawjyukgEhkFC/vYhsgmCrBT3mOYBm8yz2k/zHY5fu0Lw8eMA6dD
 wF3F28tyugzeNkNeGJ3McDWo3mCY7B/yGl/Vawcltq99rALZWYg5zEeeydatefT0q2
 kA0irLtyHyn9i0FTjNibDfHiuOyP/Jund7o+A26RksFueTTT9tcVaYWmuBPYjuV6j3
 xcNbI/axou1ew==
Date: Tue, 27 Jul 2021 19:10:27 +0100
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 01/16] KVM: arm64: Generalise VM features into a set of
 flags
Message-ID: <20210727181026.GA19173@willie-the-truck>
References: <20210715163159.1480168-1-maz@kernel.org>
 <20210715163159.1480168-2-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210715163159.1480168-2-maz@kernel.org>
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

On Thu, Jul 15, 2021 at 05:31:44PM +0100, Marc Zyngier wrote:
> We currently deal with a set of booleans for VM features,
> while they could be better represented as set of flags
> contained in an unsigned long, similarily to what we are
> doing on the CPU side.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h | 12 +++++++-----
>  arch/arm64/kvm/arm.c              |  5 +++--
>  arch/arm64/kvm/mmio.c             |  3 ++-
>  3 files changed, 12 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 41911585ae0c..4add6c27251f 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -122,7 +122,10 @@ struct kvm_arch {
>  	 * should) opt in to this feature if KVM_CAP_ARM_NISV_TO_USER is
>  	 * supported.
>  	 */
> -	bool return_nisv_io_abort_to_user;
> +#define KVM_ARCH_FLAG_RETURN_NISV_IO_ABORT_TO_USER	0
> +	/* Memory Tagging Extension enabled for the guest */
> +#define KVM_ARCH_FLAG_MTE_ENABLED			1
> +	unsigned long flags;

One downside of packing all these together is that updating 'flags' now
requires an atomic rmw sequence (i.e. set_bit()). Then again, that's
probably for the best anyway given that kvm_vm_ioctl_enable_cap() looks
like it doesn't hold any locks.

>  	/*
>  	 * VM-wide PMU filter, implemented as a bitmap and big enough for
> @@ -133,9 +136,6 @@ struct kvm_arch {
>  
>  	u8 pfr0_csv2;
>  	u8 pfr0_csv3;
> -
> -	/* Memory Tagging Extension enabled for the guest */
> -	bool mte_enabled;
>  };
>  
>  struct kvm_vcpu_fault_info {
> @@ -777,7 +777,9 @@ bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
>  #define kvm_arm_vcpu_sve_finalized(vcpu) \
>  	((vcpu)->arch.flags & KVM_ARM64_VCPU_SVE_FINALIZED)
>  
> -#define kvm_has_mte(kvm) (system_supports_mte() && (kvm)->arch.mte_enabled)
> +#define kvm_has_mte(kvm)					\
> +	(system_supports_mte() &&				\
> +	 test_bit(KVM_ARCH_FLAG_MTE_ENABLED, &(kvm)->arch.flags))

Not an issue with this patch, but I just noticed that the
system_supports_mte() check is redundant here as we only allow the flag to
be set if that's already the case.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
