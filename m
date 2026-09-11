Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C64C4416124
	for <kvmarm@lists.linux.dev>; Fri, 11 Sep 2026 13:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789133025; cv=none; b=B7NKV8IQSYYeariIiot+wC5cN17i3vdQCMf0+GViO2qidF/tjSyzh56JOkmJOVwsYZPA9QEAPXfDHrjmaUdZmu8ybijR27n9Yj8sSvqHBe3XQqV17BXpYQoktn2JlgKuhfEGrb72EegZpjIOfN+qLgGesRGAK148oKsJdcf8bPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789133025; c=relaxed/simple;
	bh=5jxEc7P7PC4dHCPzJ6RVgUlF5WVZ1+Frf7XpPEE7Uss=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e+1YINnbFc6noCffIwrCrMRfAeOtcm/udtk6z39R+wwm3DcxxmQ039cby281AAxunUCZL0aaXY7q9Ehc65Urfr97YaQvAb9op9cyYsT/uaxonWOHVaYZ09+raUszmQorVNGwHJ7e/Ut6IyToqNrxDEgykfX1iHVBXjKoEYyl14M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=aUK2+z78; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="aUK2+z78"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 89A871655;
	Fri, 11 Sep 2026 06:23:39 -0700 (PDT)
Received: from e143914.arm.com (unknown [10.2.213.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 951E03F59E;
	Fri, 11 Sep 2026 06:23:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789133023; bh=5jxEc7P7PC4dHCPzJ6RVgUlF5WVZ1+Frf7XpPEE7Uss=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aUK2+z786llsnU/kTLIbihWkD1/Gd4Xxkrzqo0XIot6f3u2uhvYWeaxRfrILm7tax
	 96Z8rNDIB3bTA/dBNOpIEKboiDHYUEeFI6eloJdWct3UR3KG7QMR1aJrxQpdlk1iZ1
	 OeKt5gC+WSRoKUmnmLObdVIbuhbJtL+x7zSXYdQ4=
Date: Fri, 11 Sep 2026 14:23:39 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Quentin Perret <qperret@google.com>, Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v2 10/17] KVM: arm64: Prevent host PC adjustments for
 protected vCPUs
Message-ID: <aqQA26sBLaOxt5zF@e143914.arm.com>
References: <20260907070002.3333525-1-fuad.tabba@linux.dev>
 <20260907070002.3333525-11-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907070002.3333525-11-fuad.tabba@linux.dev>

Hello!

On Mon, Sep 07, 2026 at 07:59:55AM +0100, Fuad Tabba wrote:
> __kvm_adjust_pc() lets the host advance a vCPU's PC or inject an
> exception, which for a protected vCPU would let the host redirect
> guest execution. Drop the request there: the entry handlers apply the
> host's PC_UPDATE_REQ on re-entry, where EL2 allows it.

I wrote a comment about how "doesn't this lose the PC update status
because for a loaded-protected vCPU we do nothing and the entry handlers
are in a later commit", but I realised it was wrong because:

  a) the handle_vm_entry_generic() handler copies PC_UPDATE_REQ from
     host_vcpu to hpy->vcpu
  b) adjust_pc() is called in __kvm_vcpu_run() so applies the update

> 
> For a non-protected vCPU, adjusting the hyp vCPU while
> PKVM_HOST_STATE_DIRTY is set loses the update at the next flush and
> the guest re-executes an emulated MMIO access, so the flag selects
> which copy to adjust. Adjusting the hyp vCPU copies PC_UPDATE_REQ in
> and back out again. Without the copy back, INCREMENT_PC outlives the
> adjustment and the next KVM_SET_VCPU_EVENTS trips
> WARN_ON(INCREMENT_PC) in kvm_pend_exception().

Maybe a slight rewording:

  For a non-protected vCPU, use PKVM_HOST_STATE_DIRTY to determine
  whether to update the host vCPU or hyp vCPU.
  If the host vCPU is the authoritative vCPU, the PC can be adjusted
  directly.
  If the hyp vCPU is the authoritative vCPU, copy PC_UPDATE_REQ from the
  host vCPU, adjust the PC and copy the flags back to the host vCPU.
  Without the copy back, INCREMENT_PC outlives the adjustment and the
  next KVM_SET_VCPU_EVENTS trips WARN_ON(INCREMENT_PC) in
  kvm_pend_exception().

> 
> Unloaded, the host copy is host-writable, so pin it and its VM before
> adjusting. Only commit_pending_events(), under KVM_SET_VCPU_EVENTS,
> reaches EL2 with no hyp vCPU loaded. KVM_RUN's call always has one.
> enter_exception64() reads the VM's MTE flag and a host copy's
> vcpu->kvm is host-written, so __kvm_adjust_pc_vm() takes the VM as a
> parameter: the pinned host struct kvm when unloaded, the hyp VM
> otherwise.

Rewording:

  A hyp vCPU is not loaded when __kvm_adjust_pc() is called from
  commit_pending_events(), through KVM_SET_VCPU_EVENTS. In that case, pin
  the host vCPU and its VM before updating the host copy. The KVM_RUN call
  always has a hyp vCPU loaded.

  enter_exception64() reads the VM's MTE flag. Since host_vcpu->kvm is
  host-controlled, add __kvm_adjust_pc_vm() and pass it the already
  pinned host VM for an unloaded vCPU, or the trusted hyp VM for a
  loaded vCPU.


Feel free to not take the rewording, but it helped me understand a bit,
and felt clearer.

> 
> Suggested-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> ---
>  arch/arm64/include/asm/kvm_asm.h   |  1 +
>  arch/arm64/kvm/hyp/exception.c     | 27 ++++++++++-------
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c | 47 +++++++++++++++++++++++++++++-
>  3 files changed, 63 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> index e5b92ac09e69e..d149afee7b4bd 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -280,6 +280,7 @@ extern int __kvm_at_s12(struct kvm_vcpu *vcpu, u32 op, u64 vaddr);
>  extern int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
>  
>  extern void __kvm_adjust_pc(struct kvm_vcpu *vcpu);
> +extern void __kvm_adjust_pc_vm(struct kvm_vcpu *vcpu, struct kvm *kvm);
>  
>  extern bool __vgic_v3_get_gic_config(void);
>  extern void __vgic_v3_init_lrs(void);
> diff --git a/arch/arm64/kvm/hyp/exception.c b/arch/arm64/kvm/hyp/exception.c
> index 754e2dc1df54a..bf9d8efce9984 100644
> --- a/arch/arm64/kvm/hyp/exception.c
> +++ b/arch/arm64/kvm/hyp/exception.c
> @@ -66,8 +66,8 @@ static void __vcpu_write_spsr_und(struct kvm_vcpu *vcpu, u64 val)
>   * Here we manipulate the fields in order of the AArch64 SPSR_ELx layout, from
>   * MSB to LSB.
>   */
> -static void enter_exception64(struct kvm_vcpu *vcpu, unsigned long target_mode,
> -			      enum exception_type type)
> +static void enter_exception64(struct kvm_vcpu *vcpu, struct kvm *kvm,
> +			      unsigned long target_mode, enum exception_type type)
>  {
>  	unsigned long sctlr, vbar, old, new, mode;
>  	u64 exc_offset;
> @@ -109,7 +109,7 @@ static void enter_exception64(struct kvm_vcpu *vcpu, unsigned long target_mode,
>  	new |= (old & PSR_C_BIT);
>  	new |= (old & PSR_V_BIT);
>  
> -	if (kvm_has_mte(kern_hyp_va(vcpu->kvm)))
> +	if (kvm_has_mte(kvm))
>  		new |= PSR_TCO_BIT;
>  
>  	new |= (old & PSR_DIT_BIT);
> @@ -294,7 +294,7 @@ static void enter_exception32(struct kvm_vcpu *vcpu, u32 mode, u32 vect_offset)
>  	*vcpu_pc(vcpu) = vect_offset;
>  }
>  
> -static void kvm_inject_exception(struct kvm_vcpu *vcpu)
> +static void kvm_inject_exception(struct kvm_vcpu *vcpu, struct kvm *kvm)
>  {
>  	if (vcpu_el1_is_32bit(vcpu)) {
>  		switch (vcpu_get_flag(vcpu, EXCEPT_MASK)) {
> @@ -314,23 +314,23 @@ static void kvm_inject_exception(struct kvm_vcpu *vcpu)
>  	} else {
>  		switch (vcpu_get_flag(vcpu, EXCEPT_MASK)) {
>  		case unpack_vcpu_flag(EXCEPT_AA64_EL1_SYNC):
> -			enter_exception64(vcpu, PSR_MODE_EL1h, except_type_sync);
> +			enter_exception64(vcpu, kvm, PSR_MODE_EL1h, except_type_sync);
>  			break;
>  
>  		case unpack_vcpu_flag(EXCEPT_AA64_EL1_SERR):
> -			enter_exception64(vcpu, PSR_MODE_EL1h, except_type_serror);
> +			enter_exception64(vcpu, kvm, PSR_MODE_EL1h, except_type_serror);
>  			break;
>  
>  		case unpack_vcpu_flag(EXCEPT_AA64_EL2_SYNC):
> -			enter_exception64(vcpu, PSR_MODE_EL2h, except_type_sync);
> +			enter_exception64(vcpu, kvm, PSR_MODE_EL2h, except_type_sync);
>  			break;
>  
>  		case unpack_vcpu_flag(EXCEPT_AA64_EL2_IRQ):
> -			enter_exception64(vcpu, PSR_MODE_EL2h, except_type_irq);
> +			enter_exception64(vcpu, kvm, PSR_MODE_EL2h, except_type_irq);
>  			break;
>  
>  		case unpack_vcpu_flag(EXCEPT_AA64_EL2_SERR):
> -			enter_exception64(vcpu, PSR_MODE_EL2h, except_type_serror);
> +			enter_exception64(vcpu, kvm, PSR_MODE_EL2h, except_type_serror);
>  			break;
>  
>  		default:
> @@ -348,10 +348,10 @@ static void kvm_inject_exception(struct kvm_vcpu *vcpu)
>   * Adjust the guest PC (and potentially exception state) depending on
>   * flags provided by the emulation code.
>   */
> -void __kvm_adjust_pc(struct kvm_vcpu *vcpu)
> +void __kvm_adjust_pc_vm(struct kvm_vcpu *vcpu, struct kvm *kvm)
>  {
>  	if (vcpu_get_flag(vcpu, PENDING_EXCEPTION)) {
> -		kvm_inject_exception(vcpu);
> +		kvm_inject_exception(vcpu, kvm);
>  		vcpu_clear_flag(vcpu, PENDING_EXCEPTION);
>  		vcpu_clear_flag(vcpu, EXCEPT_MASK);
>  	} else if (vcpu_get_flag(vcpu, INCREMENT_PC)) {
> @@ -359,3 +359,8 @@ void __kvm_adjust_pc(struct kvm_vcpu *vcpu)
>  		vcpu_clear_flag(vcpu, INCREMENT_PC);
>  	}
>  }
> +
> +void __kvm_adjust_pc(struct kvm_vcpu *vcpu)
> +{
> +	__kvm_adjust_pc_vm(vcpu, kern_hyp_va(vcpu->kvm));
> +}
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> index 051c2d95e3b7d..1a3f23e90e563 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -640,11 +640,56 @@ static void handle___pkvm_host_mkyoung_guest(struct kvm_cpu_context *host_ctxt)
>  	cpu_reg(host_ctxt, 1) =  ret;
>  }
>  
> +static void adjust_pc_loaded(struct pkvm_hyp_vcpu *hyp_vcpu,
> +			     struct kvm_vcpu *host_vcpu)
> +{
> +	/*
> +	 * PKVM_HOST_STATE_DIRTY names the authoritative copy: the host's
> +	 * when set, the hyp vCPU's otherwise. Adjust that one.
> +	 */
> +	if (vcpu_get_flag(host_vcpu, PKVM_HOST_STATE_DIRTY)) {
> +		__kvm_adjust_pc_vm(host_vcpu, hyp_vcpu->vcpu.kvm);

Not sure here why we use hyp_vcpu->vcpu.kvm over host_vcpu->kvm, in
non-protected pKVM do we still not trust it?

> +		return;
> +	}
> +
> +	/* Reflect the consumed request back, otherwise it stays pending. */
> +	vcpu_copy_flag(&hyp_vcpu->vcpu, host_vcpu, PC_UPDATE_REQ);
> +	__kvm_adjust_pc(&hyp_vcpu->vcpu);
> +	vcpu_copy_flag(host_vcpu, &hyp_vcpu->vcpu, PC_UPDATE_REQ);
> +}
> +
> +static void adjust_pc_unloaded(struct kvm_vcpu *host_vcpu)
> +{
> +	struct kvm *host_kvm;
> +
> +	if (!is_protected_kvm_enabled()) {
> +		__kvm_adjust_pc(host_vcpu);
> +		return;
> +	}
> +
> +	/* The host copy is authoritative, used only while pinned. */
> +	if (hyp_pin_shared_mem(host_vcpu, host_vcpu + 1))
> +		return;
> +
> +	host_kvm = kern_hyp_va(READ_ONCE(host_vcpu->kvm));
> +	if (!hyp_pin_shared_mem(host_kvm, host_kvm + 1)) {
> +		__kvm_adjust_pc_vm(host_vcpu, host_kvm);
> +		hyp_unpin_shared_mem(host_kvm, host_kvm + 1);
> +	}
> +	hyp_unpin_shared_mem(host_vcpu, host_vcpu + 1);
> +}
> +
>  static void handle___kvm_adjust_pc(struct kvm_cpu_context *host_ctxt)
>  {
>  	DECLARE_REG(struct kvm_vcpu *, vcpu, host_ctxt, 1);
> +	struct pkvm_hyp_vcpu *hyp_vcpu;
> +	struct kvm_vcpu *host_vcpu;
>  
> -	__kvm_adjust_pc(kern_hyp_va(vcpu));
> +	host_vcpu = __get_host_hyp_vcpus(vcpu, &hyp_vcpu);
> +	if (!hyp_vcpu)
> +		adjust_pc_unloaded(kern_hyp_va(vcpu));
> +	else if (!pkvm_hyp_vcpu_is_protected(hyp_vcpu))
> +		adjust_pc_loaded(hyp_vcpu, host_vcpu);

Possibly a comment at the end as the "else" clause.

  /* Loaded protected vCPU: do nothing. */

(replace with "do nothing" with "handled by entry handlers" or anything
else that you think makes sense!)

>  }
>  
>  static void handle___kvm_flush_vm_context(struct kvm_cpu_context *host_ctxt)

Overall looks good to me.

Acked-by: Joey Gouly <joey.gouly@arm.com>

Thanks,
Joey
