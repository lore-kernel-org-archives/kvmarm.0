Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C2403E5578;
	Wed, 24 Jun 2026 21:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782334846; cv=none; b=cyjef3b3is6pGNiwwlMCW2pnvfZJTJdgxkv9UgRr+8nMdtLhd7LXe4YZj2o+NVDEgHtNARZfdUEvJrnwzYjgWd3xfvuCr6VMxFJ7vBwL1K3xJHGek5gqFBLHv9eFYZ5djAGCGROh1aSnb0DBAxXvRkcKLf/PCKZpZIq9TNSBtWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782334846; c=relaxed/simple;
	bh=i406byhSaQV0V7DZutKrEC4gHcx1ajLRGHczan5z1nU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T6i0CKGkrE4cK5mbUHnxcSDGi+bJ74+HAdMZ0CEKyFxyIrpiHT9DKQB90MkOoJreL6VqHUQT5pwDnKwP3h5Cauuj8tMOQhA61ihU+oqeMFfYHufgsuXMoO5EonPOXSAx0zGyLChaMVixuxSfYxytJAe1pmL0zLTt4UvASMOZIcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JcZPWqQU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JcZPWqQU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A39A1F000E9;
	Wed, 24 Jun 2026 21:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782334845;
	bh=cWN8hhpXmxnLAQ5ay7HLCp1IVEH4k3sOxPQpSwRpQ+8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JcZPWqQUXncyAr9AybO2yr3+w3eBQ6AOGLF9r1q+/YW6szLEpmvIPPbBhPFVbg2e4
	 cy1JRhiYM3n0PXrt38xThNJBg0cJTK93oEZvbO6BMji8Mak+HAdA4/egLppE7O+Opo
	 9pKPp/C0CM75ixin8kc9F9E3ogW/yvh1XSNIhkKFKa1CaHt1bFnp622ub3OF/yR8vT
	 O2gjPrXGYaGlaIPg0jbHW6I7YnOJ7HSk+zeatl8eKk85OcdMVuA2CZQVlqGYSMdCMv
	 M9fLaKxSEpSYgfDDUpIWFoirw3d7tR9uA5ObIo8j3Pfb6IRrztUbj8WDr8L2YJhadW
	 lvlXHE2UjYOZw==
Date: Wed, 24 Jun 2026 14:00:43 -0700
From: Oliver Upton <oupton@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev
Subject: Re: [PATCH v2 1/2] KVM: arm64: Only consider S1PTW a write fault if
 HA is set
Message-ID: <ajxFe5N2CXySmLbU@kernel.org>
References: <20260624202446.1698535-1-oupton@kernel.org>
 <20260624202446.1698535-2-oupton@kernel.org>
 <20260624204025.519861F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260624204025.519861F000E9@smtp.kernel.org>

On Wed, Jun 24, 2026 at 08:40:24PM +0000, sashiko-bot@kernel.org wrote:
> > +	/*
> > +	 * The architecture sucks; assume that the S1PTW fetched for write if
> > +	 * HA is enabled at stage-1. Note that hardware updates to dirty state
> > +	 * and table AF are predicated on HA=1 (DDI0487 M.a D24.2.194; R_SNVTX).
> > +	 */
> > +	if (kvm_vcpu_abt_iss1tw(vcpu))
> > +		return effective_tcr_ha(vcpu);
> 
> [Severity: High]
> Does unconditionally treating S1PTW faults as writes when HA is enabled break
> guests that use pre-populated page tables in read-only memslots?
> 
> If a guest populates its page tables with the Access Flag already set, places
> them in an RO memslot, and enables HA in its TCR, the hardware only needs read
> access during a walk. However, if a translation fault occurs,
> kvm_is_write_fault() will unconditionally evaluate to true because of
> effective_tcr_ha().
> 
> This will cause kvm_handle_guest_abort() to see a write fault on an RO memslot
> and inject a spurious Synchronous External Abort (SEA) into the guest, even
> though the hardware only needed to read the page table. Could we retain the
> conditional check for permission faults to avoid this?

Gah, I tested with QEMU+EDK2 for this exact purpose but did so on an
implementation without HAFDBS.

> > +static enum trans_regime vcpu_trans_regime(struct kvm_vcpu *vcpu)
> > +{
> > +	if (!is_hyp_ctxt(vcpu))
> > +		return TR_EL10;
> > +
> > +	return vcpu_el2_e2h_is_set(vcpu) ? TR_EL20 : TR_EL2;
> > +}
> 
> [Severity: High]
> Does vcpu_trans_regime() correctly handle unprivileged memory accesses 
> like LDTR/STTR executed from EL2?
> 
> By returning TR_EL2 based strictly on the vCPU's execution context, KVM
> disregards that unprivileged instructions at EL2 use the EL1 and 0 translation
> regime (TCR_EL1) when HCR_EL2.E2H is 0 or TGE is 0.
> 
> Since KVM cannot distinguish an LDTR fault from an LDR fault via the ESR
> syndrome, it will read TCR_EL2.HA in __effective_tcr_ha() instead of
> TCR_EL1.HA. If TCR_EL1.HA is 1 but TCR_EL2.HA is 0, KVM incorrectly evaluates
> HA as disabled.
> 
> This causes KVM to treat a legitimate S1PTW permission fault (generated to
> update the Access Flag) as a read fault, refusing to grant write permissions.
> The hardware will then fault again on retry, creating an infinite stage-2 fault
> loop that hangs the guest vCPU.

This is wrong, the LDTR instruction does not use an out-of-context
translation regime.

If HCR_EL2.{E2H,TGE} != {1,1}, LDTR silently upgrades to a privileged
access.

"""
func AArch64_IsUnprivAccessPriv() => boolean
begin
    var privileged : boolean;

    case PSTATE.EL of
        when EL0 =>
            privileged = FALSE;
        when EL1 => privileged = EffectiveHCR_EL2_NVx()[1:0] == '11';
        when EL2 => privileged = !ELIsInHost(EL0);
        when EL3 =>
            privileged = TRUE;
    end;

    if IsFeatureImplemented(FEAT_UAO) && PSTATE.UAO == '1' then
        privileged = PSTATE.EL != EL0;
    end;

    return privileged;
end;
"""
