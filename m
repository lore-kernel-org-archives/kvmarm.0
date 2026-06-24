Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CEFC64;
	Wed, 24 Jun 2026 00:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782259673; cv=none; b=N7tyFTE1yrP41Dy3l4PPQQJC75VsrNB5cZqpQdUHDY7wW2LJ/q1yWLYX4dD5zwb4CEEVJSzES0rg3Eo06SOaaYEgqOatPx80sn1hdKjAqKytlcDCNcli0y3c8wtdHdVgNYM8h+yPuR5zwbELmOeHX00beuxSSYwt5TgDbxTh/Tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782259673; c=relaxed/simple;
	bh=9mjMmiKQmeGaS8/yNL0cKpT7dae+/TDYBcA2j7FrGlY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V9d1Jch5FeIkmUOexU9ox1nnr43ffMZ7HJujV8UOnvtx0ElBf+LI2sDltutVlbLpkvDmhJyrcVPr5XSMOS9ftJxessfi42UBgCC1nblytg4agg3rBPSxFQdcJDksmWhciWiuxa61wHmRVdKrGBKD8t67WtoOrf2rc5G0AG4dT98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kGHaH77a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kGHaH77a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B69411F000E9;
	Wed, 24 Jun 2026 00:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782259671;
	bh=yRCy0c6cwItIL6srTskUPwE+lLE8mPxzKKg1lcDaQmo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kGHaH77aIfydxIUKv69iaawDbxvZ47fS+vsJyVgIdgeDCmAcoipScVIq0o3/+QolQ
	 wKcXPDSLwoV8mAECC3gI/73I1d6PorMSp2r3SP6qEh2JzJEG4ZVO8sVGvLR+Qo5vUv
	 j94iPvoIvBFGuujhcn1P9Wn0QtLq0F56t68kc8DTKkX9MNgPRjaxqz0KxwXHkPoutS
	 kLHqqmODVKr/Sva8tzH0z76egEYJ9EMxO+baFGtEtWsIskjyAPTlQzerUkHphSYi7C
	 05WS6IN6UF85dk4lSF0REDURxIidC3o79Ow6RJj+TbvsT0XkinfPCNm6xfq2Stec5/
	 1+GD1ODEObkrA==
Date: Tue, 23 Jun 2026 17:07:50 -0700
From: Oliver Upton <oupton@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: arm64: nv: Check RW permissions for insn abort due
 to S1PTW
Message-ID: <ajsf1v4X5sJk_Dv5@kernel.org>
References: <20260623211310.1529760-1-oupton@kernel.org>
 <20260623213225.A89CF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260623213225.A89CF1F000E9@smtp.kernel.org>

On Tue, Jun 23, 2026 at 09:32:25PM +0000, sashiko-bot@kernel.org wrote:
> > diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> > index 94df26de6990c..713fc44f362d9 100644
> > --- a/arch/arm64/kvm/nested.c
> > +++ b/arch/arm64/kvm/nested.c
> [ ... ]
> > @@ -918,7 +918,7 @@ int kvm_s2_handle_perm_fault(struct kvm_vcpu *vcpu, struct kvm_s2_trans *trans)
> >  	if (!kvm_vcpu_trap_is_permission_fault(vcpu))
> >  		return 0;
> >  
> > -	if (kvm_vcpu_trap_is_iabt(vcpu)) {
> > +	if (kvm_vcpu_trap_is_iabt(vcpu) && !kvm_vcpu_abt_iss1tw(vcpu)) {
> >  		if (vcpu_mode_priv(vcpu))
> >  			forward_fault = !kvm_s2_trans_exec_el1(vcpu->kvm, trans);
> >  		else
> 
> [Severity: High]
> This isn't a bug introduced by this patch, but does this change expose
> instruction aborts to an infinite loop if the L1 guest maps nested stage-2
> memory as Write-Only?
> 
> By falling through to the else block in kvm_s2_handle_perm_fault(), S1PTW
> instruction aborts are now evaluated for read/write permissions.
> 
> However, if the L1 guest mapped the nested stage-2 page table entry as
> Write-Only, the hardware will still fault on the missing read permission
> during the stage-1 translation table walk.
> 
> Looking at kvm_is_write_fault() in arch/arm64/include/asm/kvm_emulate.h:
> 
> static inline bool kvm_is_write_fault(struct kvm_vcpu *vcpu)
> {
>         if (kvm_vcpu_abt_iss1tw(vcpu)) {
>                 ...
>                 return kvm_vcpu_trap_is_permission_fault(vcpu);
>         }
>         ...
> }
> 
> It unconditionally treats all permission faults on an S1PTW as write faults,
> assuming they are Access Flag or Dirty Bit updates.
> 
> Back in the else block of kvm_s2_handle_perm_fault():
> 
>         bool write_fault = kvm_is_write_fault(vcpu);
> 
>         forward_fault = ((write_fault && !trans->writable) ||
>                          (!write_fault && !trans->readable));
> 
> Because write_fault is true, it only evaluates !trans->writable. Since the
> mapping is Write-Only, this check passes and KVM doesn't forward the fault.
> Instead, KVM resumes the guest, which will immediately fault again on the
> read, causing an infinite loop.

Well this isn't exactly malice, just a guest choosing to shoot itself in
the foot. Having said that, it's pretty clear that the assumption around S1PTW
permission faults no longer holds in kvm_is_write_fault().

I think the best we can do is key write faults off of TCR_ELx.HA and
evaluate potentially both permissions for S1PTW. Needs to be split up
into a couple patches:

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 5bf3d7e1d92c..d5c61e0027c8 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -479,21 +479,12 @@ static __always_inline int kvm_vcpu_sys_get_rt(struct kvm_vcpu *vcpu)
 
 static inline bool kvm_is_write_fault(struct kvm_vcpu *vcpu)
 {
-	if (kvm_vcpu_abt_iss1tw(vcpu)) {
-		/*
-		 * Only a permission fault on a S1PTW should be
-		 * considered as a write. Otherwise, page tables baked
-		 * in a read-only memslot will result in an exception
-		 * being delivered in the guest.
-		 *
-		 * The drawback is that we end-up faulting twice if the
-		 * guest is using any of HW AF/DB: a translation fault
-		 * to map the page containing the PT (read only at
-		 * first), then a permission fault to allow the flags
-		 * to be set.
-		 */
-		return kvm_vcpu_trap_is_permission_fault(vcpu);
-	}
+	/*
+	 * The architecture sucks; assume that the S1PTW fetched for write if
+	 * HA is enabled at stage-1.
+	 */
+	if (kvm_vcpu_abt_iss1tw(vcpu))
+		return effective_tcr_ha(vcpu);
 
 	if (kvm_vcpu_trap_is_iabt(vcpu))
 		return false;
diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index cbdaaa2a2903..26f1d72b1b07 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -417,4 +417,36 @@ u16 get_asid_by_regime(struct kvm_vcpu *vcpu, enum trans_regime regime);
 
 int __kvm_at_swap_desc(struct kvm *kvm, gpa_t ipa, u64 old, u64 new);
 
+static inline bool __effective_tcr_ha(struct kvm_vcpu *vcpu, enum trans_regime regime)
+{
+	u64 tcr;
+
+	if (!kvm_has_feat(vcpu->kvm, ID_AA64MMFR1_EL1, HAFDBS, AF))
+		return false;
+
+	switch (regime) {
+	case TR_EL10:
+		return vcpu_read_sys_reg(vcpu, TCR_EL1) & TCR_HA;
+	case TR_EL20:
+		return vcpu_read_sys_reg(vcpu, TCR_EL2) & TCR_HA;
+	case TR_EL2:
+		return vcpu_read_sys_reg(vcpu, TCR_EL2) & TCR_EL2_HA;
+	default:
+		BUG();
+	}
+}
+
+static inline enum trans_regime vcpu_trans_regime(struct kvm_vcpu *vcpu)
+{
+	if (!is_hyp_ctxt(vcpu))
+		return TR_EL10;
+
+	return vcpu_el2_e2h_is_set(vcpu) ? TR_EL20 : TR_EL2;
+}
+
+static inline bool effective_tcr_ha(struct kvm_vcpu *vcpu)
+{
+	return __effective_tcr_ha(vcpu, vcpu_trans_regime(vcpu));
+}
+
 #endif /* __ARM64_KVM_NESTED_H */
diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 8263c648207b..9d6d71ddc326 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -407,12 +407,7 @@ static int setup_s1_walk(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 		goto addrsz;
 
 	wi->baddr &= GENMASK_ULL(wi->max_oa_bits - 1, x);
-
-	wi->ha  = kvm_has_feat(vcpu->kvm, ID_AA64MMFR1_EL1, HAFDBS, AF);
-	wi->ha &= (wi->regime == TR_EL2 ?
-		  FIELD_GET(TCR_EL2_HA, tcr) :
-		  FIELD_GET(TCR_HA, tcr));
-
+	wi->ha = __effective_tcr_ha(vcpu, wi->regime);
 	return 0;
 
 addrsz:
@@ -1723,10 +1718,7 @@ int __kvm_find_s1_desc_level(struct kvm_vcpu *vcpu, u64 va, u64 ipa, int *level)
 	struct s1_walk_result wr = {};
 	int ret;
 
-	if (is_hyp_ctxt(vcpu))
-		wi.regime = vcpu_el2_e2h_is_set(vcpu) ? TR_EL20 : TR_EL2;
-	else
-		wi.regime = TR_EL10;
+	wi.regime = vcpu_trans_regime(vcpu);
 
 	ret = setup_s1_walk(vcpu, &wi, &wr, va);
 	if (ret)
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 94df26de6990..4c9123cb2e1c 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -911,6 +911,7 @@ void kvm_vcpu_put_hw_mmu(struct kvm_vcpu *vcpu)
  */
 int kvm_s2_handle_perm_fault(struct kvm_vcpu *vcpu, struct kvm_s2_trans *trans)
 {
+	bool write_fault = kvm_is_write_fault(vcpu);
 	bool forward_fault = false;
 
 	trans->esr = 0;
@@ -918,14 +919,27 @@ int kvm_s2_handle_perm_fault(struct kvm_vcpu *vcpu, struct kvm_s2_trans *trans)
 	if (!kvm_vcpu_trap_is_permission_fault(vcpu))
 		return 0;
 
-	if (kvm_vcpu_trap_is_iabt(vcpu)) {
+	/*
+	 * S1PTW permission faults do not provide sufficient syndrome information
+	 * to determine if the fault was for read or write permissions. Perform a
+	 * read permission check and an optional write permission check, relying
+	 * on the fact that:
+	 *
+	 *  - The table walker at minimum requires read permission
+	 *
+	 *  - The L1 hypervisor also needs to deal with the architecture and
+	 *    cannot directly infer the failing permission from the fault context
+	 */
+	if (kvm_vcpu_abt_iss1tw(vcpu)) {
+		forward_fault = !trans->readable;
+		if (write_fault)
+			forward_fault |= !trans->writable;
+	} else if (kvm_vcpu_trap_is_iabt(vcpu)) {
 		if (vcpu_mode_priv(vcpu))
 			forward_fault = !kvm_s2_trans_exec_el1(vcpu->kvm, trans);
 		else
 			forward_fault = !kvm_s2_trans_exec_el0(vcpu->kvm, trans);
 	} else {
-		bool write_fault = kvm_is_write_fault(vcpu);
-
 		forward_fault = ((write_fault && !trans->writable) ||
 				 (!write_fault && !trans->readable));
 	}
