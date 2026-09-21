Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F4DF3BCD19
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 16:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790007525; cv=none; b=R0BQXdazgd8M/L84yh6oiK3Sh6uykS1WG+GyFct19D3IkFHYV7zZBwIy4ZwnOEI8v+JouHZO9WzcIL4Qwa6r79OE7InOaw3Y0CQTE2kGe5nAqZs0sPyK1wUItzmtLRw/GfmldKdkKrP3X+g5dyhk3lzFy7B5HkdXmUtMyMQ6MaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790007525; c=relaxed/simple;
	bh=1asISL2/ZGDCBD+sHMZzlwad+IPLP82ADapuwv+Ffug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=YyVynMZaggn91VGdJfSfnk3xU1hutvt+uwDXh7OaZDfP1z/Tw+LQvFTeStwItUi57v+GKLxLbYcPpiJqnWNoe9KTjGsP45a+iY4E+Is1OM4bP6mZ5u8ubx/ST11q8V5xHxld2rVyjEHVGhR9AKLwbH+JvSCmNbnzw/OyzQ7yrRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=VaIS4Adm; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="VaIS4Adm"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 58328176C;
	Mon, 21 Sep 2026 09:18:39 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6FAFA3F86C;
	Mon, 21 Sep 2026 09:18:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790007522; bh=1asISL2/ZGDCBD+sHMZzlwad+IPLP82ADapuwv+Ffug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VaIS4AdmXt6cjtE+9hzK9x5AMr4mgcUEVfiCX8Mv1FVNIebcMvKki97KGtln1oZmt
	 CwehMtpiy+4cv/TutqsVoBNZzMCCQ+t7eoSaO8+jyepPcUEnmajPY0h/9OxuTMiF7a
	 uGsUP1dtEXZcX3t1jdb5NyK7QMfzDR5H9oFXTurQ=
From: Leonardo Bras <leo.bras@arm.com>
To: Oliver Upton <oupton@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>
Subject: Re: [PATCH 03/22] KVM: arm64: nv: Get rid of kvm_s2_trans*() accessors
Date: Mon, 21 Sep 2026 17:18:20 +0100
Message-ID: <arFYzJAVAcN7FGzK@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260623184201.1518871-4-oupton@kernel.org>
References: <20260623184201.1518871-1-oupton@kernel.org> <20260623184201.1518871-4-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Jun 23, 2026 at 11:41:42AM -0700, Oliver Upton wrote:
> Access the aptly named fields in kvm_s2_trans directly rather than
> indirecting through useless getters.
> 
> Signed-off-by: Oliver Upton <oupton@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_nested.h | 35 -----------------------------
>  arch/arm64/kvm/at.c                 |  6 ++---
>  arch/arm64/kvm/mmu.c                | 20 ++++++++---------
>  arch/arm64/kvm/nested.c             |  4 ++--
>  4 files changed, 15 insertions(+), 50 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
> index aa27f12cf2d4..3b36ed7c7608 100644
> --- a/arch/arm64/include/asm/kvm_nested.h
> +++ b/arch/arm64/include/asm/kvm_nested.h
> @@ -98,47 +98,12 @@ struct kvm_s2_trans {
>  	bool		ux;
>  };
>  
> -static inline phys_addr_t kvm_s2_trans_output(struct kvm_s2_trans *trans)
> -{
> -	return trans->output;
> -}
> -
> -static inline unsigned long kvm_s2_trans_size(struct kvm_s2_trans *trans)
> -{
> -	return trans->block_size;
> -}
> -
> -static inline u32 kvm_s2_trans_esr(struct kvm_s2_trans *trans)
> -{
> -	return trans->esr;
> -}
> -
> -static inline bool kvm_s2_trans_readable(struct kvm_s2_trans *trans)
> -{
> -	return trans->readable;
> -}
> -
> -static inline bool kvm_s2_trans_writable(struct kvm_s2_trans *trans)
> -{
> -	return trans->writable;
> -}
> -
>  static inline bool kvm_has_xnx(struct kvm *kvm)
>  {
>  	return cpus_have_final_cap(ARM64_HAS_XNX) &&
>  		kvm_has_feat(kvm, ID_AA64MMFR1_EL1, XNX, IMP);
>  }
>  
> -static inline bool kvm_s2_trans_exec_el0(struct kvm *kvm, struct kvm_s2_trans *trans)
> -{
> -	return trans->ux;
> -}
> -
> -static inline bool kvm_s2_trans_exec_el1(struct kvm *kvm, struct kvm_s2_trans *trans)
> -{
> -	return trans->px;
> -}
> -
>  extern int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
>  			      struct kvm_s2_trans *result);
>  extern int kvm_s2_handle_perm_fault(struct kvm_vcpu *vcpu,
> diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
> index 8263c648207b..86b499e7a9a0 100644
> --- a/arch/arm64/kvm/at.c
> +++ b/arch/arm64/kvm/at.c
> @@ -494,14 +494,14 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
>  				return ret;
>  			}
>  
> -			if (!kvm_s2_trans_readable(&s2_trans)) {
> +			if (!s2_trans.readable) {
>  				fail_s1_walk(wr, ESR_ELx_FSC_PERM_L(level),
>  					     true);
>  
>  				return -EPERM;
>  			}
>  
> -			ipa = kvm_s2_trans_output(&s2_trans);
> +			ipa = s2_trans.output;
>  		}
>  
>  		if (wi->filter) {
> @@ -582,7 +582,7 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
>  		new_desc |= PTE_AF;
>  
>  	if (new_desc != desc) {
> -		if (wi->s2 && !kvm_s2_trans_writable(&s2_trans)) {
> +		if (wi->s2 && !s2_trans.writable) {
>  			fail_s1_walk(wr, ESR_ELx_FSC_PERM_L(level), true);
>  			return -EPERM;
>  		}
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 8811ad60cf72..07bd1e3ae9fb 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1572,9 +1572,9 @@ static int topup_mmu_memcache(struct kvm_vcpu *vcpu, void *memcache)
>  static enum kvm_pgtable_prot adjust_nested_fault_perms(struct kvm_s2_trans *nested,
>  						       enum kvm_pgtable_prot prot)
>  {
> -	if (!kvm_s2_trans_writable(nested))
> +	if (!nested->writable)
>  		prot &= ~KVM_PGTABLE_PROT_W;
> -	if (!kvm_s2_trans_readable(nested))
> +	if (!nested->readable)
>  		prot &= ~KVM_PGTABLE_PROT_R;
>  
>  	return prot | kvm_encode_nested_level(nested);
> @@ -1584,9 +1584,9 @@ static enum kvm_pgtable_prot adjust_nested_exec_perms(struct kvm *kvm,
>  						      struct kvm_s2_trans *nested,
>  						      enum kvm_pgtable_prot prot)
>  {
> -	if (!kvm_s2_trans_exec_el0(kvm, nested))
> +	if (!nested->ux)
>  		prot &= ~KVM_PGTABLE_PROT_UX;
> -	if (!kvm_s2_trans_exec_el1(kvm, nested))
> +	if (!nested->px)
>  		prot &= ~KVM_PGTABLE_PROT_PX;
>  
>  	return prot;
> @@ -1623,7 +1623,7 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
>  	}
>  
>  	if (s2fd->nested)
> -		gfn = kvm_s2_trans_output(s2fd->nested) >> PAGE_SHIFT;
> +		gfn = s2fd->nested->output >> PAGE_SHIFT;
>  	else
>  		gfn = s2fd->fault_ipa >> PAGE_SHIFT;
>  
> @@ -1817,7 +1817,7 @@ static short kvm_s2_resolve_vma_size(const struct kvm_s2_fault_desc *s2fd,
>  		 * can only create a block mapping if the guest stage 2 page
>  		 * table uses at least as big a mapping.
>  		 */
> -		max_map_size = min(kvm_s2_trans_size(s2fd->nested), max_map_size);
> +		max_map_size = min(s2fd->nested->block_size, max_map_size);
>  
>  		/*
>  		 * Be careful that if the mapping size falls between
> @@ -1891,7 +1891,7 @@ static gfn_t get_canonical_gfn(const struct kvm_s2_fault_desc *s2fd,
>  	if (!s2fd->nested)
>  		return s2vi->gfn;
>  
> -	ipa = kvm_s2_trans_output(s2fd->nested);
> +	ipa = s2fd->nested->output;
>  	return ALIGN_DOWN(ipa, s2vi->vma_pagesize) >> PAGE_SHIFT;
>  }
>  
> @@ -2322,19 +2322,19 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>  		}
>  
>  		if (ret) {
> -			esr = kvm_s2_trans_esr(&nested_trans);
> +			esr = nested_trans.esr;
>  			kvm_inject_s2_fault(vcpu, esr);
>  			goto out_unlock;
>  		}
>  
>  		ret = kvm_s2_handle_perm_fault(vcpu, &nested_trans);
>  		if (ret) {
> -			esr = kvm_s2_trans_esr(&nested_trans);
> +			esr = nested_trans.esr;
>  			kvm_inject_s2_fault(vcpu, esr);
>  			goto out_unlock;
>  		}
>  
> -		ipa = kvm_s2_trans_output(&nested_trans);
> +		ipa = nested_trans.output;
>  		nested = &nested_trans;
>  	}
>  
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index c9300703bd0d..b247bc1d83fa 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -954,9 +954,9 @@ int kvm_s2_handle_perm_fault(struct kvm_vcpu *vcpu, struct kvm_s2_trans *trans)
>  
>  	if (kvm_vcpu_trap_is_iabt(vcpu)) {
>  		if (vcpu_mode_priv(vcpu))
> -			forward_fault = !kvm_s2_trans_exec_el1(vcpu->kvm, trans);
> +			forward_fault = !trans->px;
>  		else
> -			forward_fault = !kvm_s2_trans_exec_el0(vcpu->kvm, trans);
> +			forward_fault = !trans->ux;
>  	} else {
>  		bool write_fault = kvm_is_write_fault(vcpu);
>  
> -- 
> 2.47.3
> 

Pretty straightforward, couldn't see any issue.

FWIW:
Reviewed-by: Leonardo Bras <leo.bras@arm.com>

Thanks!
Leo

