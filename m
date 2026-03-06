Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1749273803
	for <kvmarm@lists.linux.dev>; Fri,  6 Mar 2026 11:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772796829; cv=none; b=RFh7/lcoy9hLhq2ZXlVvyaQiAi88TMN5bvf/Rwo5ghovK42v4mDkcJV9NYAbmBbDrMavQtBOkusAHZmDcxgTJMchXuP+4R1JgIYty98ZtCp2LH6ALqjRQxik0r7bOcu/ga8/nIlZWZ109hk6XrT2CkjksuFSgKzwHv/T2M/7htE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772796829; c=relaxed/simple;
	bh=eiYUoBSbcC9rb44DiIY4N3jGr/kL4OZfHIT/EE6DpGE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DYNukL/+KuaTI6EpOwS15Pzn7LO9C/ciQvrFjXzIiZbeFSGw1pQZsHPEYdRLq0tUoys9EWhP2keYPCo6rrOT/5enT8DAD2s9DW3zPf6M9sJdwSXwU4XurzEvWP7mhxfCaY5UKUkyUk2WS+DE07UmKLXHe9aEdU8ij/AQVOReeWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8DDF3497;
	Fri,  6 Mar 2026 03:33:40 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A9B2D3F836;
	Fri,  6 Mar 2026 03:33:43 -0800 (PST)
Date: Fri, 6 Mar 2026 11:33:35 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Quentin Perret <qperret@google.com>, Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v2 07/35] KVM: arm64: Remove is_protected_kvm_enabled()
 checks from hypercalls
Message-ID: <aaq7j1RLviU_Oz0W@raptor>
References: <20260119124629.2563-1-will@kernel.org>
 <20260119124629.2563-8-will@kernel.org>
 <aYtGWwcVrDQeGCma@raptor>
 <aacCDMhYJLMWVaIQ@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aacCDMhYJLMWVaIQ@willie-the-truck>

Hi Will,

On Tue, Mar 03, 2026 at 03:45:16PM +0000, Will Deacon wrote:
> Hi Alex,
> 
> Thanks for having a look.
> 
> On Tue, Feb 10, 2026 at 02:53:15PM +0000, Alexandru Elisei wrote:
> > On Mon, Jan 19, 2026 at 12:46:00PM +0000, Will Deacon wrote:
> > > When pKVM is not enabled, the host shouldn't issue pKVM-specific
> > > hypercalls and so there's no point checking for this in the pKVM
> > > hypercall handlers.
> > > 
> > > Remove the redundant is_protected_kvm_enabled() checks from each
> > > hypercall and instead rejig the hypercall table so that the
> > > pKVM-specific hypercalls are unreachable when pKVM is not being used.
> > > 
> > > Reviewed-by: Quentin Perret <qperret@google.com>
> > > Signed-off-by: Will Deacon <will@kernel.org>
> > > ---
> > >  arch/arm64/include/asm/kvm_asm.h   | 20 ++++++----
> > >  arch/arm64/kvm/hyp/nvhe/hyp-main.c | 63 ++++++++++--------------------
> > >  2 files changed, 32 insertions(+), 51 deletions(-)
> > > 
> > > diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> > > index a1ad12c72ebf..2076005e9253 100644
> > > --- a/arch/arm64/include/asm/kvm_asm.h
> > > +++ b/arch/arm64/include/asm/kvm_asm.h
> > > @@ -60,16 +60,9 @@ enum __kvm_host_smccc_func {
> > >  	__KVM_HOST_SMCCC_FUNC___vgic_v3_init_lrs,
> > >  	__KVM_HOST_SMCCC_FUNC___vgic_v3_get_gic_config,
> > >  	__KVM_HOST_SMCCC_FUNC___pkvm_prot_finalize,
> > > +	__KVM_HOST_SMCCC_FUNC_MIN_PKVM = __KVM_HOST_SMCCC_FUNC___pkvm_prot_finalize,
> > >  
> > >  	/* Hypercalls available after pKVM finalisation */
> > 
> > This comment should be removed, I think the functions that follow, up to
> > and including __KVM_HOST_SMCCC_FUNC_MAX_NO_PKVM, are also available with
> > kvm-arm.mode=nvhe.
> >
> > If you agree that the comment should be removed, maybe a different name for
> > the define above would be more appropriate, one that does not imply pkvm?
> 
> I'd rather keep the comment, as it delimits the blocks of hypercalls and
> is informative for the case when pKVM is enabled.
> 
> I suppose we could reword it like:
> 
> 
> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> index c4246c34509a..6c79f7504d80 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -51,7 +51,7 @@
>  #include <linux/mm.h>
>  
>  enum __kvm_host_smccc_func {
> -       /* Hypercalls available only prior to pKVM finalisation */
> +       /* Hypercalls that are unavailable once pKVM has finalised. */
>         /* __KVM_HOST_SMCCC_FUNC___kvm_hyp_init */
>         __KVM_HOST_SMCCC_FUNC___pkvm_init = __KVM_HOST_SMCCC_FUNC___kvm_hyp_init + 1,
>         __KVM_HOST_SMCCC_FUNC___pkvm_create_private_mapping,
> @@ -62,7 +62,7 @@ enum __kvm_host_smccc_func {
>         __KVM_HOST_SMCCC_FUNC___pkvm_prot_finalize,
>         __KVM_HOST_SMCCC_FUNC_MIN_PKVM = __KVM_HOST_SMCCC_FUNC___pkvm_prot_finalize,
>  
> -       /* Hypercalls available after pKVM finalisation */
> +       /* Hypercalls that are always available and common to [nh]VHE/pKVM. */
>         __KVM_HOST_SMCCC_FUNC___kvm_adjust_pc,
>         __KVM_HOST_SMCCC_FUNC___kvm_vcpu_run,
>         __KVM_HOST_SMCCC_FUNC___kvm_flush_vm_context,
> @@ -76,7 +76,7 @@ enum __kvm_host_smccc_func {
>         __KVM_HOST_SMCCC_FUNC___vgic_v3_restore_vmcr_aprs,
>         __KVM_HOST_SMCCC_FUNC_MAX_NO_PKVM = __KVM_HOST_SMCCC_FUNC___vgic_v3_restore_vmcr_aprs,
>  
> -       /* Hypercalls available only when pKVM has finalised */
> +       /* Hypercalls that are available only when pKVM has finalised. */
>         __KVM_HOST_SMCCC_FUNC___pkvm_host_share_hyp,
>         __KVM_HOST_SMCCC_FUNC___pkvm_host_unshare_hyp,
>         __KVM_HOST_SMCCC_FUNC___pkvm_host_donate_guest,
> 
> 
> WDYT?

Looks good to me (but you already figured that out in the updated series).

> 
> > > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > > index a7c689152f68..eb5cfe32b2c9 100644
> > > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > > @@ -169,9 +169,6 @@ static void handle___pkvm_vcpu_load(struct kvm_cpu_context *host_ctxt)
> > >  	DECLARE_REG(u64, hcr_el2, host_ctxt, 3);
> > >  	struct pkvm_hyp_vcpu *hyp_vcpu;
> > >  
> > > -	if (!is_protected_kvm_enabled())
> > > -		return;
> > > -
> > >  	hyp_vcpu = pkvm_load_hyp_vcpu(handle, vcpu_idx);
> > >  	if (!hyp_vcpu)
> > >  		return;
> > 
> > I've always wondered about this. For some hypercalls, all the handler does is
> > marshal the arguments for the actual function (for example,
> > handle___kvm_adjust_pc() -> __kvm_adjust_pc()), but for others, like this one,
> > the handler also has extra checks before calling the actual function.  Would you
> > mind explaining what the rationale is?
> 
> Basically, any hypercall available post-pKVM finalisation needs to check
> all pointer arguments that it takes. It's best to do this in the early
> handler so that the backend code can just operate on a safe pointer
> (either because the underlying memory has been pinned or because it's
> been repainted to point at a hypervisor-managed data structure). That
> also allows us to share a bunch of code (e.g. __kvm_vcpu_run()) with
> nVHE.
> 
> The reason handle___kvm_adjust_pc() doesn't do this is simply because
> this series focusses purely on the guest memory side of things; once
> we've got that, then we can work on hardening the vCPU/VM structures and
> these hypercalls will get tightened up by that work. In fact, that
> specific hypercall will do _nothing_ for a protected VM!


That makes sense, thank you for the explanation.

Alex
