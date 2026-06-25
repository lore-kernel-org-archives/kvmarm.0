Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56BFA23BD06;
	Thu, 25 Jun 2026 22:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782425886; cv=none; b=lwX95eqA9UcgsgbTJlID8IMEJiOZUcxg5e9nqcmoYcQWAtJc4YjRwzSLsAEb5vZFl2hKhrUDsC5QGHZmTD5qizQRiR3mFn+Pr3zdKNCAVefveDAhARGvxHnX4jTQfhAGPG9IbpOi9wt0zh9DXDDRanCBkWV8+RpFgGuWfGsNRLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782425886; c=relaxed/simple;
	bh=gSgDq/IAyrcTqaxmEu14KFUmpyy+BXho2j90sJypEus=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VEWMj5fU51efYjVv9/uc8As7sIbaf3XNPe0Pmu7jLfxXzfae+TOC2qFrVj3cJ+BWsEHf/iSMgoWmnyTaTz28kB8u+8FkbCuvyuPDxTKlD8cFmN6aRAtf8cre3093gA9nNqHdlv+mfPjaf2kZX77U+JmrUeYHrDOfC5dPFZ04byU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ehGdWy93; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ehGdWy93"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB2B01F000E9;
	Thu, 25 Jun 2026 22:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782425885;
	bh=H81/gh1Mc+Yf+SEPryh/OtrEIShaUoJhRuqfU2WfThE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ehGdWy93MY9/83gkqcLqhzcjxLMBt7q4jVShrw5gmnentYjNTl54BoEkiqOAJeRgv
	 qRHgFP17u/M6GuOdY9v6B2ZxBKUcK8roiGuBUL/sqqjBj+ivZnM0a4Mf+hnXkdqUzy
	 Ah9lNQokSFJhCo9yIxNG6ySr9L4OBOrgwNVny6mKx3ZKU9cUT+j4Gjq4QLC66hLoW7
	 ng8k0zdiYHAKTMo5kykef8prM17OXKj4mrMpm18PcUS6fSN9rfq5QYcUGrJ6bREoC4
	 GnK7lHliHR0scTqgFcjv22WKxI2mBt+bUXa9eRi2rJELjxGs3gcv5zcrFdWKMk1M5o
	 LFM9VoczMALxQ==
Date: Thu, 25 Jun 2026 15:18:03 -0700
From: Oliver Upton <oupton@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: sashiko-reviews@lists.linux.dev, kvmarm@lists.linux.dev
Subject: Re: [PATCH v2 1/2] KVM: arm64: Only consider S1PTW a write fault if
 HA is set
Message-ID: <aj2pG5ZW67coAxHR@kernel.org>
References: <20260624202446.1698535-1-oupton@kernel.org>
 <20260624202446.1698535-2-oupton@kernel.org>
 <20260624204025.519861F000E9@smtp.kernel.org>
 <ajxFe5N2CXySmLbU@kernel.org>
 <86echur5g9.wl-maz@kernel.org>
 <aj2C1na3fc_BlvuC@kernel.org>
 <86cxxeqrjp.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86cxxeqrjp.wl-maz@kernel.org>

On Thu, Jun 25, 2026 at 09:43:54PM +0100, Marc Zyngier wrote:
> On Thu, 25 Jun 2026 20:34:46 +0100, Oliver Upton <oupton@kernel.org> wrote:
> > We still need to account for host-induced permission faults, e.g. dirty
> > tracking or an RO memslot getting mapped into the L2. So I think we
> > still need to evaluate R+W before forwarding to the L1.
> 
> Hmm. I had forgotten about this indeed. Ultimately, we need to keep
> track of why a S2 entry is RO in the L1 IPA space. We can either use
> more SW bits in the PTE (not that many left), or wait until Wei-Lin is
> done with his reverse + direct map tracking structure.

Pretty sure we can avoid the additional state tracking so long as we
ensure the nested S2 permission checks are ordered before anything
happening 'downstream' of the MMU.

Pairing an R+W check in kvm_s2_handle_perm_fault() along with a change
to kvm_is_write_fault() to only consider HA=1 permission faults to be
writes should do the trick. I've got the following blurb locally:

@@ -918,14 +919,39 @@ int kvm_s2_handle_perm_fault(struct kvm_vcpu *vcpu, struct kvm_s2_trans *trans)
 	if (!kvm_vcpu_trap_is_permission_fault(vcpu))
 		return 0;
 
-	if (kvm_vcpu_trap_is_iabt(vcpu)) {
+	/*
+	 * S1PTW permission faults are a pain to deal with, owing to the fact that
+	 * the architecture sucks and there's insufficient syndrome information to
+	 * determine if the access failed for read or write permissions. We can still
+	 * infer it based on the behavior of our pseudo-TLB (i.e. the KVM MMU):
+	 *
+	 *  - S1PTW translation faults are treated as read accesses, meaning that
+	 *    the most relaxed resulting translation is read-only. The L1 hypervisor
+	 *    could prevent read accesses in the nested stage-2. Since all TTW accesses
+	 *    require at least read permission, we can detect this by unconditionally
+	 *    checking read permission in the nested stage-2.
+	 *
+	 *  - After establishing that this vCPU observed a read-only translation, we
+	 *    can infer that the access failed for lacking write permission due to
+	 *    either the nested stage-2 or KVM. Evaluate the write permission of the
+	 *    nested stage-2.
+	 *
+	 *  - Once the nested stage-2 permission checks have passed the permission
+	 *    fault must've been due to something downstream; The rest of KVM's
+	 *    fault handling can safely short-circuit to a write access at this point
+	 *    and potentially treat the access as unsupported at the virtual endpoint
+	 *    (e.g. unsupported atomic access to RO memslot).
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

I will admit, I have an extreme distaste for how subtle this is + the
reliance on implementation detail.

> > Looking ahead to HAFDBS, for this to work we will need to use a liberal
> > interpretation of R_JCXVS at the time of the initial translation fault
> > and always walk with intent for write.
> 
> Yeah, I'm not too precious about that, and we might as well take
> advantage of the architecture.
> 
> > 
> > Basically, there seems to be a subtle difference arising between writes
> > as observed from the nested MMU and writes as observed at the virtual
> > endpoint (memslot). Funny how something as straightforward as the access
> > flag can be so headache inducing :)
> 
> Well, you knew NV was just a sorry hack, didn't you? ;-) It's just
> another case of "SW will sort it out eventually...".

Given the present company on NV, I'm not entirely sure SW will actually sort
itself out :)

Thanks,
Oliver
