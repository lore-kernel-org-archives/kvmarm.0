Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD163C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 17 Feb 2022 16:29:00 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E89F49F4E;
	Thu, 17 Feb 2022 11:29:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 45vMCPKQIhEb; Thu, 17 Feb 2022 11:28:58 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F8FD49F33;
	Thu, 17 Feb 2022 11:28:58 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 69CF549F2F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Feb 2022 11:28:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 17n2KpEkhOcg for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Feb 2022 11:28:55 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B1AEE49E46
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Feb 2022 11:28:55 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DCB3D113E;
 Thu, 17 Feb 2022 08:28:54 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 896CA3F718;
 Thu, 17 Feb 2022 08:28:51 -0800 (PST)
Date: Thu, 17 Feb 2022 16:29:06 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v6 37/64] KVM: arm64: nv: Restrict S2 RD/WR permissions
 to match the guest's
Message-ID: <Yg530gxERUq0M3ZO@monolith.localdoman>
References: <20220128121912.509006-1-maz@kernel.org>
 <20220128121912.509006-38-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220128121912.509006-38-maz@kernel.org>
Cc: kernel-team@android.com, kvm@vger.kernel.org,
 Andre Przywara <andre.przywara@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>,
 Chase Conklin <chase.conklin@arm.com>, kvmarm@lists.cs.columbia.edu,
 mihai.carabas@oracle.com,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 "Russell King \(Oracle\)" <linux@armlinux.org.uk>,
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

Hi,

On Fri, Jan 28, 2022 at 12:18:45PM +0000, Marc Zyngier wrote:
> When mapping a page in a shadow stage-2, special care must be
> taken not to be more permissive than the guest is (writable or
> readable page when the guest hasn't set that permission).
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_nested.h | 15 +++++++++++++++
>  arch/arm64/kvm/mmu.c                | 14 +++++++++++++-
>  arch/arm64/kvm/nested.c             |  2 +-
>  3 files changed, 29 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
> index 4fad4d3848ce..f4b846d09d86 100644
> --- a/arch/arm64/include/asm/kvm_nested.h
> +++ b/arch/arm64/include/asm/kvm_nested.h
> @@ -97,6 +97,21 @@ static inline u32 kvm_s2_trans_esr(struct kvm_s2_trans *trans)
>  	return trans->esr;
>  }
>  
> +static inline bool kvm_s2_trans_readable(struct kvm_s2_trans *trans)
> +{
> +	return trans->readable;
> +}
> +
> +static inline bool kvm_s2_trans_writable(struct kvm_s2_trans *trans)
> +{
> +	return trans->writable;
> +}
> +
> +static inline bool kvm_s2_trans_executable(struct kvm_s2_trans *trans)
> +{
> +	return !(trans->upper_attr & BIT(54));
> +}
> +
>  extern int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
>  			      struct kvm_s2_trans *result);
>  
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 36f7ecb4f81b..7c56e1522d3c 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1247,6 +1247,17 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	if (exec_fault && device)
>  		return -ENOEXEC;
>  
> +	/*
> +	 * Potentially reduce shadow S2 permissions to match the guest's own
> +	 * S2. For exec faults, we'd only reach this point if the guest
> +	 * actually allowed it (see kvm_s2_handle_perm_fault).
> +	 */
> +	if (kvm_is_shadow_s2_fault(vcpu)) {
> +		writable &= kvm_s2_trans_writable(nested);

I was a bit confused about writable being true when write_fault is false. After
some digging, it turns out that hva_to_pfn() oportunistically makes writable
true, even for read faults.

> +		if (!kvm_s2_trans_readable(nested))
> +			prot &= ~KVM_PGTABLE_PROT_R;

The local variable "prot" is initialized to KVM_PGTABLE_PROT_R, so this check
makes sense.

> +	}
> +
>  	spin_lock(&kvm->mmu_lock);
>  	pgt = vcpu->arch.hw_mmu->pgt;
>  	if (mmu_notifier_retry(kvm, mmu_seq))
> @@ -1285,7 +1296,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  
>  	if (device)
>  		prot |= KVM_PGTABLE_PROT_DEVICE;
> -	else if (cpus_have_const_cap(ARM64_HAS_CACHE_DIC))
> +	else if (cpus_have_const_cap(ARM64_HAS_CACHE_DIC) &&
> +		 kvm_s2_trans_executable(nested))
>  		prot |= KVM_PGTABLE_PROT_X;
>  
>  	/*
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 0a9708f776fc..a74ffb1d2064 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -481,7 +481,7 @@ int kvm_s2_handle_perm_fault(struct kvm_vcpu *vcpu, struct kvm_s2_trans *trans)
>  		return 0;
>  
>  	if (kvm_vcpu_trap_is_iabt(vcpu)) {
> -		forward_fault = (trans->upper_attr & BIT(54));
> +		forward_fault = !kvm_s2_trans_executable(trans);
>  	} else {
>  		bool write_fault = kvm_is_write_fault(vcpu);

The patch looks good to me:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
