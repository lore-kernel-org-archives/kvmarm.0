Received: from mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25D3D4EA395
	for <kvmarm@lists.linux.dev>; Thu,  3 Sep 2026 16:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788452577; cv=none; b=s6xlHZFMaWtmEd7iDzoNSBBJ5eyzIQ0JA+IC9rN0vwOkvHg8xLZxsNbppQCL+QIZx8ehli6V2CKSaVlmg/uzS//mI7tI/9aHOlAjoCC7+1OXxwIF3WmoFFkIk0yl30PbM9X+Bd2Zko4GqWMD7pxi+6a1AjPsxCMECyRdiYNacLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788452577; c=relaxed/simple;
	bh=yAWEaoHlzAByy1p/MfIorhvFlDICqbscs9jfE/luEfA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lXpzgASEJ+2jMVy1zM6zzs1htncL4bJ67q4EI4K2O0yVU1/I9R81CxwLQ8tcFqm2TFv2jG4zCNDuPlaTPnzeAiSMLTEQeclM/gMnZ8XTBXQCrW4Lxb8Q7TgiKCvFTYbNSa0MsLb1eT/B8lXdOXzEHC2HvErQyocMOmsgNqO3CPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rRGgA5KB; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rRGgA5KB"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=yAWEaoHlzAByy1p/MfIorhvFlDICqbscs9jfE/luEfA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788452573; v=1; x=1789057373;
 b=rRGgA5KBAg3ZnNIWZV/nrD3MMEWdA9a3ZNkauln9vDtD18x2m2XI7gjDl/gXSrgjNn368Xqy
 MPE39f8vE0MDD0ozALDXHfnonpisyV7R5iWSmEOMqu/S9/yel5FY1bF9AEkscDUHR1fehEUBdO9
 lPBLvcJ78wKPfJZ5xZ2qSLGA=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id b0bade19b9abcf3d;
	Thu, 03 Sep 2026 16:22:53 +0000
X-Mizu-Trace-ID: b0bade19b9abcf3d
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b4a0b384b7so7870e87.0
        for <kvmarm@lists.linux.dev>; Thu, 03 Sep 2026 09:22:48 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBy5SGjhfA4hgGBq4sdio7Dai6f/8ixnJ4mSh62VjlgtohvIDdQO7/207Fw3+DzF0x9+53wFyrE=@lists.linux.dev
X-Gm-Message-State: AFuF++mP8tcCu+lrHIGBpVS4hilArmHd6XCC6KnhDhdOaN1xMxh4nvWD
	s45wjd3C83UmjqDvxvOxU5lxVbUA2yMv60LsG1CiCVBcBzBQE/gikH/+QMLEJGAYPZAyoCWtwGs
	taJXYYmtxgClwsrLZRNgKEE3/7KWlBE6TC7Me0nPN
X-Received: by 2002:ac2:4c51:0:b0:5b4:9dba:7403 with SMTP id
 2adb3069b0e04-5b60f977efamr153962e87.13.1788452567982; Thu, 03 Sep 2026
 09:22:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260831163421.272420-1-fuad.tabba@linux.dev> <20260831163421.272420-6-fuad.tabba@linux.dev>
 <apg7KNpamnpYi-kl@google.com> <aphAO_nmoTzI6Yvf@google.com>
In-Reply-To: <aphAO_nmoTzI6Yvf@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Thu, 3 Sep 2026 17:22:11 +0100
X-Gmail-Original-Message-ID: <CA+EHjTyQciNWyaMr3rogsz53D_JJQGUXtv5jBJtSd4pajfv+8g@mail.gmail.com>
X-Gm-Features: AcwNN1XA72CBM17Z_CeCSMDbmKPDC8n6403MdwU3XpedWw0uwZihTsZDnm-yw0s
Message-ID: <CA+EHjTyQciNWyaMr3rogsz53D_JJQGUXtv5jBJtSd4pajfv+8g@mail.gmail.com>
Subject: Re: [PATCH 05/17] KVM: arm64: Skip fixed-feature state flush for
 protected vCPUs
To: Vincent Donnefort <vdonnefort@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Quentin Perret <qperret@google.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 2 Sept 2026 at 16:26, Vincent Donnefort <vdonnefort@google.com> wrote:
>
> On Wed, Sep 02, 2026 at 04:05:12PM +0100, Vincent Donnefort wrote:
> > On Mon, Aug 31, 2026 at 05:34:09PM +0100, Fuad Tabba wrote:
> > > flush_hyp_vcpu() copies the host's mdcr_el2, TWI/TWE and debug state
> > > into the hyp vCPU on every entry, so for a protected vCPU the host's
> > > trap configuration overrides the one pkvm_vcpu_init_traps() computed
> > > at EL2. Move those copies into the non-protected branch, and sync the
> > > debug state back for non-protected vCPUs only: a protected guest's
> > > debug registers are hypervisor-owned, and it takes the host's TWI/TWE
> > > at vCPU load. MDCR_EL2.TDA traps only the guest's own accesses; it
> > > does not stop the world switch from loading host-supplied breakpoints
> > > and MDSCR_EL1.
> > >
> > > EL2's mdcr_el2 starts from 0, and HPMN == 0 is reserved without
> > > FEAT_HPMN0. Set HPMN to the CPU's event counter count at vCPU load,
> > > the value the host's copy carried; a protected guest's PMU accesses
> > > trap regardless.
> > >
> > > Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> > > ---
> > >  arch/arm64/kvm/hyp/nvhe/hyp-main.c | 31 +++++++++++++++++++-----------
> > >  arch/arm64/kvm/hyp/nvhe/pkvm.c     |  2 +-
> > >  2 files changed, 21 insertions(+), 12 deletions(-)
> > >
> > > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > > index ca7122b0bccdd..14e847b122abf 100644
> > > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > > @@ -231,7 +231,6 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
> > >     u8 esr_ec;
> > >
> > >     fpsimd_sve_flush();
> > > -   flush_debug_state(hyp_vcpu);
> > >
> > >     /*
> > >      * If we deal with a non-protected guest and the state is potentially
> > > @@ -241,7 +240,14 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
> > >     if (!pkvm_hyp_vcpu_is_protected(hyp_vcpu)) {
> > >             if (vcpu_get_flag(host_vcpu, PKVM_HOST_STATE_DIRTY))
> > >                     flush_hyp_vcpu_state(hyp_vcpu);
> > > +
> > > +           hyp_vcpu->vcpu.arch.hcr_el2 &= ~(HCR_TWI | HCR_TWE);
> > > +           hyp_vcpu->vcpu.arch.hcr_el2 |= READ_ONCE(host_vcpu->arch.hcr_el2) &
> > > +                                                    (HCR_TWI | HCR_TWE);
> > > +
> > > +           hyp_vcpu->vcpu.arch.mdcr_el2 = host_vcpu->arch.mdcr_el2;
> > >             hyp_vcpu->vcpu.arch.iflags = host_vcpu->arch.iflags;
> > > +           flush_debug_state(hyp_vcpu);
> > >     } else {
> > >             hyp_vcpu->vcpu.arch.ctxt = host_vcpu->arch.ctxt;
> > >     }
> > > @@ -249,17 +255,13 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
> > >     /* __hyp_running_vcpu must be NULL in a guest context. */
> > >     hyp_vcpu->vcpu.arch.ctxt.__hyp_running_vcpu = NULL;
> > >
> > > -   hyp_vcpu->vcpu.arch.mdcr_el2    = host_vcpu->arch.mdcr_el2;
> > >     /*
> > > -    * HCR_EL2.VSE is host-owned (a pending virtual SError to inject), not a
> > > -    * trap-control bit, so it must flow to the hyp vCPU alongside TWI/TWE
> > > -    * for the vSError to be delivered. sync_hyp_vcpu() reflects it back.
> > > +    * A host-injected vSError is masked by the guest's own PSTATE.A, so it
> > > +    * applies to protected guests too.
> > >      */
> > > -   hyp_vcpu->vcpu.arch.hcr_el2 &= ~(HCR_TWI | HCR_TWE | HCR_VSE);
> > > -   hyp_vcpu->vcpu.arch.hcr_el2 |= READ_ONCE(host_vcpu->arch.hcr_el2) &
> > > -                                            (HCR_TWI | HCR_TWE | HCR_VSE);
> > > -
> > > -   hyp_vcpu->vcpu.arch.vsesr_el2   = host_vcpu->arch.vsesr_el2;
> > > +   hyp_vcpu->vcpu.arch.hcr_el2 &= ~HCR_VSE;
> > > +   hyp_vcpu->vcpu.arch.hcr_el2 |= READ_ONCE(host_vcpu->arch.hcr_el2) & HCR_VSE;
> > > +   hyp_vcpu->vcpu.arch.vsesr_el2 = host_vcpu->arch.vsesr_el2;
> > >
> > >     flush_hyp_vgic_state(hyp_vcpu);
> > >
> > > @@ -288,7 +290,8 @@ static void sync_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu, u32 exit_reason)
> > >     struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
> > >
> > >     fpsimd_sve_sync(&hyp_vcpu->vcpu);
> > > -   sync_debug_state(hyp_vcpu);
> > > +   if (!pkvm_hyp_vcpu_is_protected(hyp_vcpu))
> > > +           sync_debug_state(hyp_vcpu);
> >
> > nit: We can't use the else arm below?
>
> or actually could we move the check into sync_debug_state() just like
> sync_hyp_timer_state() does?

Will do, and there's another case of this in the series that gets fixed with it.


/fuad

>
> >
> > >
> > >     if (pkvm_hyp_vcpu_is_protected(hyp_vcpu)) {
> > >             host_vcpu->arch.ctxt = hyp_vcpu->vcpu.arch.ctxt;
> > > @@ -329,6 +332,12 @@ static void handle___pkvm_vcpu_load(struct kvm_cpu_context *host_ctxt)
> > >             /* Propagate WFx trapping flags */
> > >             hyp_vcpu->vcpu.arch.hcr_el2 &= ~(HCR_TWE | HCR_TWI);
> > >             hyp_vcpu->vcpu.arch.hcr_el2 |= hcr_el2 & (HCR_TWE | HCR_TWI);
> > > +
> > > +           /* HPMN == 0 is reserved without FEAT_HPMN0. */
> > > +           if (system_supports_pmuv3())
> > > +                   u64p_replace_bits(&hyp_vcpu->vcpu.arch.mdcr_el2,
> > > +                                     FIELD_GET(ARMV8_PMU_PMCR_N, read_sysreg(pmcr_el0)),
> > > +                                     MDCR_EL2_HPMN);
> > >     } else {
> > >             memcpy(&hyp_vcpu->vcpu.arch.fgt, hyp_vcpu->host_vcpu->arch.fgt,
> > >                    sizeof(hyp_vcpu->vcpu.arch.fgt));
> > > diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > > index 459bd9eb7e4bc..e85f13233da08 100644
> > > --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > > +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > > @@ -102,7 +102,7 @@ static void pvm_init_traps_mdcr(struct kvm_vcpu *vcpu)
> > >
> > >     if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMUVer, IMP)) {
> > >             val |= MDCR_EL2_TPM | MDCR_EL2_TPMCR;
> > > -           val &= ~(MDCR_EL2_HPME | MDCR_EL2_MTPME | MDCR_EL2_HPMN_MASK);
> > > +           val &= ~(MDCR_EL2_HPME | MDCR_EL2_MTPME);
> > >     }
> > >
> > >     if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, DebugVer, IMP))
> > > --
> > > 2.39.5
> > >
>
> --
> Vincent
