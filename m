Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 800704921BB
	for <kvmarm@lists.linux.dev>; Tue,  3 Mar 2026 15:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772552723; cv=none; b=gXI+gRq3raPxfgXZ0rtbRmaN9Gw+LRe1gu/OU4C9F3IB6iUrvMxle3Fc5a6QNhZ04ATQIupm62v8wioQ1mBZOhsj4E+/ucmE97I/LpB4zW1k2sJSMNRT6Smc2BOyNLwxyhwZKmjKgh5Kq1rbT+QiTppRd2CditB2JXLEwlpYiXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772552723; c=relaxed/simple;
	bh=NUOXljTmyEDWmFoNWuqeCGEceTr+9T1FfZUnN2JoicQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iOZGd5wG9Xv3XaVMJwkSXsr/OdHTLug+Tocoo5aA44djgsqxXcjahdqXhLe+uOJDOcn6F4ZsjE/ljU286egBmWABF8TcTR5+ROqob6LEDPOssqNKrLFqp4GOKK/YBtYceajDXCB3d8IPu6WMpYw/9dnKxvGCFvNiQqlHvF07XZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=inPxIq+4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="inPxIq+4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D603C116C6;
	Tue,  3 Mar 2026 15:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772552723;
	bh=NUOXljTmyEDWmFoNWuqeCGEceTr+9T1FfZUnN2JoicQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=inPxIq+4LXTnLQcAVhY1kUwBow604IPD6/gzLaYafeWUMzEc+5rjaTvs7wwxzw/K/
	 sWeyKo8hHuXaE0K05ZHO1PBj7S8eFKNnpX3t9ttA/HqDFu0GqHdSNoaT+Q7r8MzWbU
	 MKAyyVPoIPSBR9NOhs+iBqIbZDH3ir95p2/Fb/KezvNYWWjUMOXtyjNwBAQdW0kxdi
	 pXvnbxWoK6pWg9KigG7uHSDom3kJvrDHf68hVVbcaNizQ89jq9wk9j2ln3bAxBql8x
	 SKRTj0LfQNMSpZvWv3+qeY+TLtRgs+gzkkA0yNwBUpWPx5+4PdAIyB/aLdRfvIY9qP
	 7ButtyUJ4xZoA==
Date: Tue, 3 Mar 2026 15:45:16 +0000
From: Will Deacon <will@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
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
Message-ID: <aacCDMhYJLMWVaIQ@willie-the-truck>
References: <20260119124629.2563-1-will@kernel.org>
 <20260119124629.2563-8-will@kernel.org>
 <aYtGWwcVrDQeGCma@raptor>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYtGWwcVrDQeGCma@raptor>

Hi Alex,

Thanks for having a look.

On Tue, Feb 10, 2026 at 02:53:15PM +0000, Alexandru Elisei wrote:
> On Mon, Jan 19, 2026 at 12:46:00PM +0000, Will Deacon wrote:
> > When pKVM is not enabled, the host shouldn't issue pKVM-specific
> > hypercalls and so there's no point checking for this in the pKVM
> > hypercall handlers.
> > 
> > Remove the redundant is_protected_kvm_enabled() checks from each
> > hypercall and instead rejig the hypercall table so that the
> > pKVM-specific hypercalls are unreachable when pKVM is not being used.
> > 
> > Reviewed-by: Quentin Perret <qperret@google.com>
> > Signed-off-by: Will Deacon <will@kernel.org>
> > ---
> >  arch/arm64/include/asm/kvm_asm.h   | 20 ++++++----
> >  arch/arm64/kvm/hyp/nvhe/hyp-main.c | 63 ++++++++++--------------------
> >  2 files changed, 32 insertions(+), 51 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> > index a1ad12c72ebf..2076005e9253 100644
> > --- a/arch/arm64/include/asm/kvm_asm.h
> > +++ b/arch/arm64/include/asm/kvm_asm.h
> > @@ -60,16 +60,9 @@ enum __kvm_host_smccc_func {
> >  	__KVM_HOST_SMCCC_FUNC___vgic_v3_init_lrs,
> >  	__KVM_HOST_SMCCC_FUNC___vgic_v3_get_gic_config,
> >  	__KVM_HOST_SMCCC_FUNC___pkvm_prot_finalize,
> > +	__KVM_HOST_SMCCC_FUNC_MIN_PKVM = __KVM_HOST_SMCCC_FUNC___pkvm_prot_finalize,
> >  
> >  	/* Hypercalls available after pKVM finalisation */
> 
> This comment should be removed, I think the functions that follow, up to
> and including __KVM_HOST_SMCCC_FUNC_MAX_NO_PKVM, are also available with
> kvm-arm.mode=nvhe.
>
> If you agree that the comment should be removed, maybe a different name for
> the define above would be more appropriate, one that does not imply pkvm?

I'd rather keep the comment, as it delimits the blocks of hypercalls and
is informative for the case when pKVM is enabled.

I suppose we could reword it like:


diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index c4246c34509a..6c79f7504d80 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -51,7 +51,7 @@
 #include <linux/mm.h>
 
 enum __kvm_host_smccc_func {
-       /* Hypercalls available only prior to pKVM finalisation */
+       /* Hypercalls that are unavailable once pKVM has finalised. */
        /* __KVM_HOST_SMCCC_FUNC___kvm_hyp_init */
        __KVM_HOST_SMCCC_FUNC___pkvm_init = __KVM_HOST_SMCCC_FUNC___kvm_hyp_init + 1,
        __KVM_HOST_SMCCC_FUNC___pkvm_create_private_mapping,
@@ -62,7 +62,7 @@ enum __kvm_host_smccc_func {
        __KVM_HOST_SMCCC_FUNC___pkvm_prot_finalize,
        __KVM_HOST_SMCCC_FUNC_MIN_PKVM = __KVM_HOST_SMCCC_FUNC___pkvm_prot_finalize,
 
-       /* Hypercalls available after pKVM finalisation */
+       /* Hypercalls that are always available and common to [nh]VHE/pKVM. */
        __KVM_HOST_SMCCC_FUNC___kvm_adjust_pc,
        __KVM_HOST_SMCCC_FUNC___kvm_vcpu_run,
        __KVM_HOST_SMCCC_FUNC___kvm_flush_vm_context,
@@ -76,7 +76,7 @@ enum __kvm_host_smccc_func {
        __KVM_HOST_SMCCC_FUNC___vgic_v3_restore_vmcr_aprs,
        __KVM_HOST_SMCCC_FUNC_MAX_NO_PKVM = __KVM_HOST_SMCCC_FUNC___vgic_v3_restore_vmcr_aprs,
 
-       /* Hypercalls available only when pKVM has finalised */
+       /* Hypercalls that are available only when pKVM has finalised. */
        __KVM_HOST_SMCCC_FUNC___pkvm_host_share_hyp,
        __KVM_HOST_SMCCC_FUNC___pkvm_host_unshare_hyp,
        __KVM_HOST_SMCCC_FUNC___pkvm_host_donate_guest,


WDYT?

> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > index a7c689152f68..eb5cfe32b2c9 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > @@ -169,9 +169,6 @@ static void handle___pkvm_vcpu_load(struct kvm_cpu_context *host_ctxt)
> >  	DECLARE_REG(u64, hcr_el2, host_ctxt, 3);
> >  	struct pkvm_hyp_vcpu *hyp_vcpu;
> >  
> > -	if (!is_protected_kvm_enabled())
> > -		return;
> > -
> >  	hyp_vcpu = pkvm_load_hyp_vcpu(handle, vcpu_idx);
> >  	if (!hyp_vcpu)
> >  		return;
> 
> I've always wondered about this. For some hypercalls, all the handler does is
> marshal the arguments for the actual function (for example,
> handle___kvm_adjust_pc() -> __kvm_adjust_pc()), but for others, like this one,
> the handler also has extra checks before calling the actual function.  Would you
> mind explaining what the rationale is?

Basically, any hypercall available post-pKVM finalisation needs to check
all pointer arguments that it takes. It's best to do this in the early
handler so that the backend code can just operate on a safe pointer
(either because the underlying memory has been pinned or because it's
been repainted to point at a hypervisor-managed data structure). That
also allows us to share a bunch of code (e.g. __kvm_vcpu_run()) with
nVHE.

The reason handle___kvm_adjust_pc() doesn't do this is simply because
this series focusses purely on the guest memory side of things; once
we've got that, then we can work on hardening the vCPU/VM structures and
these hypercalls will get tightened up by that work. In fact, that
specific hypercall will do _nothing_ for a protected VM!

Will
