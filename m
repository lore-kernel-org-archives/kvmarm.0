Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905AF1F03DE;
	Wed, 24 Jun 2026 21:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782336128; cv=none; b=WPsJaIw6efJfAzXpeihAtLcpXh0513x8zAF+RY2+0Od8kFiwgnvyocoLM+XH9wLR31/63vF0sR++aljy3p0MBt0ofUNPToMRxhBr5SbRki1d3wAFzOpuonXfrvj7OLcRP7vmJ9M6lEWECVbiD9h7xRzcKF30J47ZeLhqCc4jvvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782336128; c=relaxed/simple;
	bh=Qmwc5gv51dRHM+VDXxrnHsD2BieEbpPWfqIFgSieJug=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sissrEmgqIS6N3C36utkNA//JXINtJ00hEn4zzixvTa59eEl8npTovrV9kgqFrruyoJPtG1wwGbROl80aJBrSUFyMUvU5/TvFeQ5rQLjSzNPpU3LX1msLwujHlWaUNdO9dJOBa3LKOLAoFWl3T5pEH9EaFn0WeQZnOpYJt8lFNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ilxTVg0/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ilxTVg0/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 346481F000E9;
	Wed, 24 Jun 2026 21:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782336127;
	bh=qHn85mFbXT3jrShdWQ4xG1gA+rAj4XQZoF0cMI3Wlds=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ilxTVg0/mKu/VPZq1wdy9bmvnyTUvXoDZEJS7bnrKahMpX7/zT38VHFIXOT8NXlxh
	 DXdO/Z5+xrJsMryyUrX0krp+ENhiyBIhWZ5oqXkjNeNqM1db96jhQuf3aAhYq3+OCz
	 1lJeRlP2amtPnBCNr7o2coYJ3s/GAMWO65fdDF2wxEGNz9AlcZTiA5uJZCYaT+nSON
	 V5QLvt8N32NAcqJhbflo8PnzcSCRrNw5Imh9THULmMFG/YKTWHy/zB5zrrqSvZk7Sa
	 gBbJD5TvTVpQEqsfsZkM7/7hBcFEAYHphF+vvcSz4HrsvZWphuO9H2kEXlHd2fuKLT
	 Po4gYyoXdQRpQ==
Date: Wed, 24 Jun 2026 14:22:06 -0700
From: Oliver Upton <oupton@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 2/2] KVM: arm64: nv: Treat S1PTW permission faults
 specially
Message-ID: <ajxKfk5elMbcNuSb@kernel.org>
References: <20260624202446.1698535-1-oupton@kernel.org>
 <20260624202446.1698535-3-oupton@kernel.org>
 <20260624203516.E76241F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260624203516.E76241F000E9@smtp.kernel.org>

On Wed, Jun 24, 2026 at 08:35:16PM +0000, sashiko-bot@kernel.org wrote:
> > +	/*
> > +	 * S1PTW permission faults do not provide sufficient syndrome information
> > +	 * to determine if the fault was for read or write permissions. Perform a
> > +	 * read permission check and an optional write permission check, relying
> > +	 * on the fact that:
> > +	 *
> > +	 *  - The table walker at minimum requires read permission
> > +	 *
> > +	 *  - The L1 hypervisor also needs to deal with the architecture and
> > +	 *    cannot directly infer the failing permission from the fault context
> > +	 */
> > +	if (kvm_vcpu_abt_iss1tw(vcpu)) {
> > +		forward_fault = !trans->readable;
> > +		if (write_fault)
> > +			forward_fault |= !trans->writable;
> > +	} else if (kvm_vcpu_trap_is_iabt(vcpu)) {
> >  		if (vcpu_mode_priv(vcpu))
> >  			forward_fault = !kvm_s2_trans_exec_el1(vcpu->kvm, trans);
> >  		else
> >  			forward_fault = !kvm_s2_trans_exec_el0(vcpu->kvm, trans);
> 
> [Severity: High]
> This is a pre-existing issue, but does this logic miss a read-permission
> dependency check for normal instruction aborts?
> 
> If an L1 hypervisor maps a page for L2 with Stage-2 PTE AP=00 (no read/write)
> and XN=0 (executable), and L2 attempts to fetch an instruction, the hardware
> generates a Stage-2 Instruction Abort (Permission Fault) because execution
> requires read permission.

This does not match my understanding of stage-2 permissions. S2AP
controls data permissions, whereas the XN field controls instruction
fetches. The pseudocode also supports this view, where execute
permissions are computed separately from S2AP:

AArch64.S2DirectBasePermissions()
"""
    S2AccessControls s2perms;
    bit w;
    constant bit r = permissions.s2ap<0>;
    if permissions.s2ap<1> == '1' then
        w = '1';
    // Descriptors marked with DBM set have the effective value of S2AP[1] set.
    // This implies no Permission faults caused by lack of write permissions are
    // reported, and the Dirty bit can be set.
    elsif permissions.dbm == '1' && walkparams.hd == '1' then
        // An update occurs here, conditional to being able to append to HDBSS
        if walkparams.hdbss == '1' then
            w = if CanAppendToHDBSS() then '1' else '0';
        else
            w = '1';
    else
        w = '0';

    bit px, ux;
    case (permissions.s2xn:permissions.s2xnx) of
        when '00' (px,ux) = ('1','1');
        when '01' (px,ux) = ('0','1');
        when '10' (px,ux) = ('0','0');
        when '11' (px,ux) = ('1','0');

    x = if accdesc.el == EL0 then ux else px;
    s2perms.r = r;
    s2perms.w = w;
    s2perms.x = x;
    s2perms.r_rcw = r;
    s2perms.w_rcw = w;
    s2perms.r_mmu = r;
    s2perms.w_mmu = w;
    s2perms.toplevel0 = '0';
    s2perms.toplevel1 = '0';
    s2perms.overlay = FALSE;

    return s2perms;
"""

AArch64.S2CheckPermissions()
"""
    elsif accdesc.acctype == AccessType_IFETCH then
        if s2perms.overlay && s2perms.ox == '0' then
            fault.statuscode = Fault_Permission;
            fault.overlay    = TRUE;
        elsif (memtype == MemType_Device &&
                ConstrainUnpredictable(Unpredictable_INSTRDEVICE) == Constraint_FAULT) then
            fault.statuscode = Fault_Permission;

        // Prevent execution from Non-secure space by Realm state
        elsif accdesc.ss == SS_Realm && walkstate.baseaddress.paspace != PAS_Realm then
            fault.statuscode = Fault_Permission;
        elsif s2perms.x == '0' then
            fault.statuscode = Fault_Permission;
"""

Thanks,
Oliver
