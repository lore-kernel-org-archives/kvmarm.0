Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792823066;
	b=JXkWb2uInOUmw+a7QRcqluOI66TfLuAjlGql0QbV948f52/Lpf1dK1RvwUA1M3izZ0xF
	 9IhGE/pIU5AuLgwzdo7F47NH9ujK0LOjSevXVoOWA4KFlkdbrmJOj725luGDeevki4htR
	 pyNM0jfYRDf1ksiVjyL+RJlfmIlvygCiaJJEv7XwPC9Bo5/Hg07EDsKnpJtTsnOwdjZfw
	 zFt+FJJklpiD/y053utw9m2bGJ4fbDvXRk+cjQ6JEwvumXjVBmR3KS+AK1qynfJh2B4zH
	 HFmvOpHAE4wsXO0Z2JdC/idTXSC0qLSBFoeaTXZQT0vdrQzgJoOP6MSqk5MGQzExHjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792823066;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=rD0Dk82caeis6DFmJoJytphHVMK7ucfmFXYpBFrDjC8=;
	b=Q3KoZGdHkpEzbbqR4qfACk9Xs1f8lRMx/6E7+vuofn7zPMshxJ1jrMeyW2RU3GNIyb+b
	 +iV+5nOXbbiZPGk6ShXsImOXaFAP3Yl7Qxe2zBSMZ3bpikocQViHX84qu2VEE1nOw2Zun
	 DCrZbRoxLvPNz1DybreVasIdb+KIHMXjSs0reYAHiBOz8xfPTXxvDkkBmtEQyclugAszo
	 xdDj5qAhS6ITtFe32+OV4mGXhSAJccCjVVYOF8rTQmQ5usKxnCIM6o6BCT+GLGgKGcZD2
	 v5mIEZm/ZZx4VOQ6keO5IfYZxlG3CUUcXsBP6mDBTY0i5v9lIg/aT3AbmaH3LEIopyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=c4mKMkUv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 497AF606A31A;
	Sat, 24 Oct 2026 06:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=c4mKMkUv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C768B1F01825;
	Sat, 24 Oct 2026 06:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792823065;
	bh=rD0Dk82caeis6DFmJoJytphHVMK7ucfmFXYpBFrDjC8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=c4mKMkUvGcf/gF9xr43dWTVDZSUoEtfU7QswHU89/TQlDALjOcmHEpOIoRrXH/Nvm
	 s0ba4l2PiNzgg+Vy9MGALhbF1GhTVHD76qJgUSBeghfQvpweNvZ9BVsXger2Dp4Vea
	 ovPGq2ZDegarmk4GWtmD/0Itph4goRO+IljqJCSJzSmzLjlUTeZeifFVAZSycs4zQT
	 Fn5S23UtpqQ0GqHzm+ctolams8sRpOhPLI1ufip15RgrDnN1uV81/UipPtqdxN5AAp
	 R3yBXYo6ZMpopyxP4WSE7lCxUBIQy574RnnevQUTVOqzwMMXykMGAhpZKwAF/kNVyO
	 ixytUshPVf8UA==
Date: Fri, 23 Oct 2026 23:24:24 -0700
From: Oliver Upton <oupton@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 22/28] KVM: arm64: Set Access flag on table
 descriptors at stage-1
Message-ID: <atxPGA1ZQEdnV5Dj@kernel.org>
References: <20261023205610.1044532-1-oupton@kernel.org>
 <20261023205610.1044532-23-oupton@kernel.org>
 <sashiko-outbox-183250@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <sashiko-outbox-183250@kernel.org>

On Fri, Oct 23, 2026 at 09:22:33PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] KVM: arm64: missing kvm_has_tcr2() check in effective_tcr2()
> --
> 
> commit bcde4120f508adf06668822f4f97b91e98f978ff
> Author: Oliver Upton <oupton@kernel.org>
> 
> KVM: arm64: Set Access flag on table descriptors at stage-1
> 
> This commit implements FEAT_HAFT stage-1 access flag updates on table
> descriptors during software page table walks.
> 
> > diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
> > index 2ce34af3b9f20..8f1be3af64e88 100644
> > --- a/arch/arm64/kvm/at.c
> > +++ b/arch/arm64/kvm/at.c
> > @@ -414,6 +414,8 @@ static int setup_s1_walk(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
> >  	wi->hd &= (wi->regime == TR_EL2 ?
> >  		  FIELD_GET(TCR_EL2_HD, tcr) :
> >  		  FIELD_GET(TCR_HD, tcr));
> > +	wi->haft  = kvm_has_feat(vcpu->kvm, ID_AA64MMFR1_EL1, HAFDBS, HAFT) && wi->ha &&
> > +		    FIELD_GET(TCR2_EL1_HAFT, effective_tcr2(vcpu, wi->regime));
> 
> [Severity: Medium]
> Can this read a stale physical SYS_TCR2_EL12 register value if userspace
> disables FEAT_TCR2 (ID_AA64MMFR3_EL1.TCRX = 0) while leaving
> ID_AA64MMFR1_EL1.HAFDBS set to HAFT?
> 
> ID_AA64MMFR1_EL1 and ID_AA64MMFR3_EL1 are independently writable from
> userspace via KVM_SET_ONE_REG and are not cross-sanitized in
> kvm_vm_finalize_sys_regs(). When kvm_has_tcr2(vcpu->kvm) is false,
> ctxt_has_tcrx() returns false in arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h:

Hrm, having effective_tcr2() return 0 in the case that FEAT_TCRX isn't
implemented seems to be the best way out here.

Unlike the enforcement we need to do for context save/restore
dependencies, KVM emulation assumes that system registers take an
effective value that's consistent with the feature being NI.

Thanks,
Oliver

> static inline bool ctxt_has_tcrx(struct kvm_cpu_context *ctxt)
> {
> 	struct kvm_vcpu *vcpu;
> 
> 	if (!cpus_have_final_cap(ARM64_HAS_TCR2))
> 		return false;
> 
> 	vcpu = ctxt_to_vcpu(ctxt);
> 	return kvm_has_tcr2(kern_hyp_va(vcpu->kvm));
> }
> 
> As a result, __sysreg_restore_el1_state() and __sysreg_restore_vel2_state()
> do not context-switch the physical SYS_TCR2_EL12 register when loading the
> vCPU.
> 
> However, effective_tcr2() in arch/arm64/kvm/at.c does not check
> kvm_has_tcr2(vcpu->kvm):
> 
> static u64 effective_tcr2(struct kvm_vcpu *vcpu, enum trans_regime regime)
> {
> 	if (regime == TR_EL10) {
> 		if (vcpu_has_nv(vcpu) &&
> 		    !(__vcpu_sys_reg(vcpu, HCRX_EL2) & HCRX_EL2_TCR2En))
> 			return 0;
> 
> 		return vcpu_read_sys_reg(vcpu, TCR2_EL1);
> 	}
> 
> 	return vcpu_read_sys_reg(vcpu, TCR2_EL2);
> }
> 
> When setup_s1_walk() runs while SYSREGS_ON_CPU is set (for example, in
> TR_EL2/TR_EL20 via handle_at_s1e2() -> __kvm_at_s1e2() -> handle_at_slow() ->
> setup_s1_walk() or kvm_s2_handle_perm_fault() -> __kvm_translate_va() ->
> setup_s1_walk(), or for a non-NV guest in TR_EL10 via kvm_inject_sea() ->
> inject_abt64() -> __kvm_find_s1_desc_level() -> setup_s1_walk()),
> vcpu_read_sys_reg() resolves to read_sr_from_cpu() in
> arch/arm64/kvm/sys_regs.c:
> 
> 	case TCR2_EL1:		val = read_sysreg_s(SYS_TCR2_EL12);	break;
> 
> This reads whatever SYS_TCR2_EL12 value was left on the physical CPU by a
> previous vCPU, which could set wi->haft and cause walk_s1() ->
> handle_desc_update() to set PTE_AF on guest stage-1 table descriptors.
> 
> Should effective_tcr2() check kvm_has_tcr2(vcpu->kvm) first (similar to
> __kvm_at_s1e01_fast() and __effective_sctlr2_bit()), or should setup_s1_walk()
> gate wi->haft on kvm_has_tcr2(vcpu->kvm)?
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261023205610.1044532-1-oupton@kernel.org?part=22
