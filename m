Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E63E46D570;
	Thu, 24 Sep 2026 10:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790245303; cv=none; b=QbWSI3qv5vscNW9qpl3s8zWwMZX0vwUXADOtp6zMnqmGpl93ehlklPat3ECRCxp8zdoCPNDKsNZtmtH61T3ftTWTxIIY2frZ6Us0dw6efmViEIWw2xlVs87GUQ07LurCbekbqN61Jp4qV7G4oBdFO2jANVFtPgnOnor7uW4LbV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790245303; c=relaxed/simple;
	bh=8JtrStaYuRSBRMvWNSYCvXES213ZcR4nN845YnL9zj8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t2XkLN2slMNtwk51K8aMtjIErHXDHvMciLoRXgNRAd0wFLVjct7MR24qa0GXrYBOVrrcUhr4hBLtQFVaIglpw0ujF3iYCuvFOHF1Gv2FGMcy6Zq3jWLHASTV/0UpV+JwmRmET0iDjq6Dw3XSaybYqawoMR+A3yp8fOSI75qaR4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kGkEvjDM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kGkEvjDM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABC031F000FF;
	Thu, 24 Sep 2026 10:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790245301;
	bh=5MDTtMD6afFelOIcTq7k9liLCAKGpA6j8Nmw+cyJu0M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kGkEvjDMzPW27fY1HkTF00AU0znEB3Gyp4m8m1hR0k/f4qggxQBCJqGjd9CWbDz/F
	 M0y1SvvOPq4yUHmQnBmmk/zHxiLKwk8bdniJxMDAnQJFD8JL9IVLgs9YYgUShjftxL
	 fzq+AeTbP2NSP3MZZq+t9YGKbLx/9ZuXmk5RaS0mwSXMtIIM3x0SteKmlYbDrmjY4B
	 ADZqFJzdo0iA59Rx1p+Es3npbjhiln69opfVKWdl3hvHfMESY2u3HJkULAOWvkU8oN
	 vnT+Lufabt0xGR7NQLdJzbSwMPZnkXiyyBzXEEI6Q5Xn9aqsN4skFT2L7WWqVnF/YT
	 PKvtLJsgSOvLw==
Date: Thu, 24 Sep 2026 11:21:35 +0100
From: Will Deacon <will@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	James Morse <james.morse@arm.com>, Ben Horgan <ben.horgan@arm.com>,
	Xi Ruoyao <xry111@xry111.site>, Mark Rutland <mark.rutland@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>, Gavin Shan <gshan@redhat.com>,
	Yuan Yao <yaoyuan@linux.alibaba.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] KVM: arm64: Trap guest MPAM accesses whenever MPAM is
 implemented
Message-ID: <arT5r6Tqg9PnSYLz@willie-the-truck>
References: <20260911104715.307500-1-fuad.tabba@linux.dev>
 <868q5579ol.wl-maz@kernel.org>
 <CA+EHjTw0U0d91Cv4NYEJvUuT=JabwZeeYwpZ2P1xyVeOVX46Ew@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTw0U0d91Cv4NYEJvUuT=JabwZeeYwpZ2P1xyVeOVX46Ew@mail.gmail.com>

On Tue, Sep 15, 2026 at 07:51:00PM +0100, Fuad Tabba wrote:
> On Sun, 13 Sept 2026 at 11:00, Marc Zyngier <maz@kernel.org> wrote:
> [...]
> > > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> [...]
> > >  static void cpu_hyp_init_context(void)
> > >  {
> > > + u64 pfr0 = __read_sysreg_by_encoding(SYS_ID_AA64PFR0_EL1);
> > > + u64 pfr1 = __read_sysreg_by_encoding(SYS_ID_AA64PFR1_EL1);
> > > +
> >
> > Why not directly read_sysreg(id_aa64pfr0_el1) and co?
> > __read_sysreg_by_encoding() is useful when the encoding comes from a
> > variable, but it looks odd in the case of a literal sysreg.
> 
> It applies the arm64.nompam override, which is what
> finalise_el2_state() tests. With the override set, EL2 setup leaves
> the MPAM traps alone, and a raw read_sysreg() would still see MPAM in
> the ID registers, so KVM would write MPAM2_EL2 on exactly the firmware
> the option exists for. I'll add a comment.
> 
> [...]
> > > diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> [...]
> > > @@ -298,14 +298,17 @@ static inline void  __activate_traps_mpam(struct kvm_vcpu *vcpu)
> [...]
> > >   /* trap guest access to MPAMIDR_EL1 */
> > > - if (system_supports_mpam_hcr()) {
> > > + if (read_sysreg_s(SYS_MPAMIDR_EL1) & MPAMIDR_EL1_HAS_HCR) {
> >
> > This is going to suck under NV. The host hypervisor is of course going
> > to set MPAMHCR_EL2.TRAP_MPAMIDR_EL1, and we're in for a recursive trap
> > on the hottest possible path in KVM. Which is silly as the actual
> > write to MPAMHCR_EL2 is free (it lands in NVMem[]).
> >
> > This really should be replaced by a flag called HAS_MPAM_HCR, just
> > like you have HAS_MPAM.
> 
> I'll probe MPAMIDR_EL1.HAS_HCR once in cpu_hyp_init_context(), next to
> HAS_MPAM, and test the flag in both trap functions instead.
> 
> I'll hold off on v4 until Will has had a chance to comment as well.

I'm planning to generalise the logic you added recently in
gmid_el1_accessible() so that __cpuinfo_store_cpu() stores the values
in 'struct cpuinfo_arm64' with the overrides already applied. I don't
think that directly impacts this patch, but it should make the general
shape of things easier to reason about. I also need it for the parallel
hotplug work.

If you fancy helping with that, please let me know.

Will
