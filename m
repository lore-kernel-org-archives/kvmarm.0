Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0F66C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jun 2022 13:14:08 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 12FDA4B2B8;
	Wed, 15 Jun 2022 09:14:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gWeL-nAz75DL; Wed, 15 Jun 2022 09:14:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B05174B2C2;
	Wed, 15 Jun 2022 09:14:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B723E4B2B8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jun 2022 09:14:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id f8P7RdZPkslb for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Jun 2022 09:14:03 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 41DBD4B28C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jun 2022 09:14:03 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 86FF5139F;
 Wed, 15 Jun 2022 06:14:02 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 52E343F66F;
 Wed, 15 Jun 2022 06:14:00 -0700 (PDT)
Date: Wed, 15 Jun 2022 14:14:19 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 11/19] KVM: arm64: Move vcpu ON_UNSUPPORTED_CPU flag
 to the state flag set
Message-ID: <YqnbEJ0hgSKyXtxO@monolith.localdoman>
References: <20220610092838.1205755-1-maz@kernel.org>
 <20220610092838.1205755-12-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220610092838.1205755-12-maz@kernel.org>
Cc: kvm@vger.kernel.org, kernel-team@android.com,
 Mark Brown <broonie@kernel.org>, Will Deacon <will@kernel.org>,
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

Hi,

On Fri, Jun 10, 2022 at 10:28:30AM +0100, Marc Zyngier wrote:
> The ON_UNSUPPORTED_CPU flag is only there to track the sad fact
> that we have ended-up on a CPU where we cannot really run.
> 
> Since this is only for the host kernel's use, move it to the state
> set.
> 
> Reviewed-by: Fuad Tabba <tabba@google.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 4f147bdc5ce9..0c22514cb7c7 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -519,6 +519,8 @@ struct kvm_vcpu_arch {
>  #define HOST_SVE_ENABLED	__vcpu_single_flag(sflags, BIT(0))
>  /* SME enabled for EL0 */
>  #define HOST_SME_ENABLED	__vcpu_single_flag(sflags, BIT(1))
> +/* Physical CPU not in supported_cpus */
> +#define ON_UNSUPPORTED_CPU	__vcpu_single_flag(sflags, BIT(2))

I'm a bit confused here. The ON_UNSUPPORTED_CPU flag ends up in sflags. The
comment for sflags says:

+	/* State flags for kernel bookkeeping, unused by the hypervisor code */
+	u64 sflags;

The ON_UNSUPPORT_CPU flag is used exclusively by KVM (it's only used by the
file arch/arm64/kvm/arm.c), so why is it part of a set of flags which are
supposed to be unused by the hypervisor code?

Thanks,
Alex

>  
>  /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
>  #define vcpu_sve_pffr(vcpu) (kern_hyp_va((vcpu)->arch.sve_state) +	\
> @@ -541,7 +543,6 @@ struct kvm_vcpu_arch {
>  })
>  
>  /* vcpu_arch flags field values: */
> -#define KVM_ARM64_ON_UNSUPPORTED_CPU	(1 << 15) /* Physical CPU not in supported_cpus */
>  #define KVM_ARM64_WFIT			(1 << 17) /* WFIT instruction trapped */
>  #define KVM_GUESTDBG_VALID_MASK (KVM_GUESTDBG_ENABLE | \
>  				 KVM_GUESTDBG_USE_SW_BP | \
> @@ -561,13 +562,13 @@ struct kvm_vcpu_arch {
>  #endif
>  
>  #define vcpu_on_unsupported_cpu(vcpu)					\
> -	((vcpu)->arch.flags & KVM_ARM64_ON_UNSUPPORTED_CPU)
> +	vcpu_get_flag(vcpu, ON_UNSUPPORTED_CPU)
>  
>  #define vcpu_set_on_unsupported_cpu(vcpu)				\
> -	((vcpu)->arch.flags |= KVM_ARM64_ON_UNSUPPORTED_CPU)
> +	vcpu_set_flag(vcpu, ON_UNSUPPORTED_CPU)
>  
>  #define vcpu_clear_on_unsupported_cpu(vcpu)				\
> -	((vcpu)->arch.flags &= ~KVM_ARM64_ON_UNSUPPORTED_CPU)
> +	vcpu_clear_flag(vcpu, ON_UNSUPPORTED_CPU)
>  
>  #define vcpu_gp_regs(v)		(&(v)->arch.ctxt.regs)
>  
> -- 
> 2.34.1
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
