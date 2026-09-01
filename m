Received: from mta0.migadu.com (out-176.mta0.migadu.com [91.218.175.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B2FC47989E
	for <kvmarm@lists.linux.dev>; Tue,  1 Sep 2026 10:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788258193; cv=none; b=ZN8Yy5nMcW+XofcFaAZ8eJ2fijvo9gLSWFr0Zmu32VqkXYxEnqodprwsI2BC9pLyW3sAi0Qc6wzyBI6bWL8WHsfJiNVfk9L8zbEe2SHjXNhuwdDLkPga6T/SUIpBCurjkWNG9TfyMk4AerAcuW2rrouVOWZJcgcK93Rr1xT6/vA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788258193; c=relaxed/simple;
	bh=yEWR7zpHIkwTSrFo/T77fkUS19P8BkH0CbbF+bcKF7g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=A/LJq2cSeHlOfXb0X41MGp+b1jth9Al+xf7hxdulKT1bU1AqnhTZs8DVnIkHx4iwb7H+fmz9cKnZfGcCHEWOTIx+3eOHz29Vcg/EfvQitV8CeFNwvPHUjoRcVbEfeKLNU/K6lldO5x5Hl5sUhOj7oMA80Xzun6FFayunlm5VjOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ozxFHBuJ; arc=none smtp.client-ip=91.218.175.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ozxFHBuJ"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=yEWR7zpHIkwTSrFo/T77fkUS19P8BkH0CbbF+bcKF7g=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788258189; v=1; x=1788862989;
 b=ozxFHBuJ3ZUM9mLRw7m0i1BSrbcGoKHGthxRXCnFnSphyXQx3aKHvS3BRZgstRj2L6/A3BD1
 iwtz9eEcW2aP3gskRyqTEPWTZzAvI19G6dJJ8B1BnOraNSWE6xx4MLEMOWTu9tOKjIQzMXeViMs
 WHNc0cygpXfnIvDAWPXo191s=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 4cd1f7f032af0683;
	Tue, 01 Sep 2026 10:23:09 +0000
X-Mizu-Trace-ID: 4cd1f7f032af0683
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5b2a73da7e1so6584e87.0
        for <kvmarm@lists.linux.dev>; Tue, 01 Sep 2026 03:23:05 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBz35Pd+2Ft23uu/0KsF/IUgc9PHWOxpRROQ9ihsj6IiFsDtrQ2rvgBIR1cNc9yktqcX16r+vQI=@lists.linux.dev
X-Gm-Message-State: AFuF++mYyYiFn7SOShleHTAAh6LdAM37rhjLazBiR+hXnPzVxVzvnUlh
	fnSdeVL0M17czDuGh6pz+knhd0X77wmYoMwuf+Y8M+5QtcC5Q7hKleMgOvR41CSVOMzJ1eNmqLE
	gbIlegn9auIkn9pSAOcoOrEhbWl5NxVndjsMcfiKF
X-Received: by 2002:ac2:51cd:0:b0:5b1:ca0b:25d2 with SMTP id
 2adb3069b0e04-5b5ff233baemr134084e87.4.1788258184296; Tue, 01 Sep 2026
 03:23:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260831163421.272420-1-fuad.tabba@linux.dev> <20260831163421.272420-6-fuad.tabba@linux.dev>
 <20260831195900.512F71F000E9@smtp.kernel.org>
In-Reply-To: <20260831195900.512F71F000E9@smtp.kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 1 Sep 2026 11:22:28 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzryWTXQCLxgdkJqdguVEjsKPHMypbykGnChWDP0Td5Rg@mail.gmail.com>
X-Gm-Features: AcwNN1VXWFCoOI5YyiZut7i1K2AXPItxU21w_bnsnnaLyg2YRqfG9XpMu3GC4vQ
Message-ID: <CA+EHjTzryWTXQCLxgdkJqdguVEjsKPHMypbykGnChWDP0Td5Rg@mail.gmail.com>
Subject: Re: [PATCH 05/17] KVM: arm64: Skip fixed-feature state flush for
 protected vCPUs
To: sashiko-reviews@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev, 
	Oliver Upton <oupton@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Not this one Sashiko.,..

On Mon, 31 Aug 2026 at 20:59, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
> - [Medium] Under-inclusion in the per-entry `HCR_EL2` allowlist for prote=
cted guests, dropping dynamic WFx trapping policy updates.
> --
>
> commit 2c210642954dbb2df4858e3ad74ba54ba96b05d7
> Author: Fuad Tabba <fuad.tabba@linux.dev>
>
> KVM: arm64: Skip fixed-feature state flush for protected vCPUs
>
> This commit optimizes the per-entry synchronization for protected vCPUs b=
y
> moving the copy of fixed-feature state (like mdcr_el2, TWI/TWE, and debug
> state) to the non-protected branch and the per-vCPU load path.
>
> > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> [ ... ]
> > @@ -241,7 +240,14 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *h=
yp_vcpu)
> >       if (!pkvm_hyp_vcpu_is_protected(hyp_vcpu)) {
> >               if (vcpu_get_flag(host_vcpu, PKVM_HOST_STATE_DIRTY))
> >                       flush_hyp_vcpu_state(hyp_vcpu);
> > +
> > +             hyp_vcpu->vcpu.arch.hcr_el2 &=3D ~(HCR_TWI | HCR_TWE);
> > +             hyp_vcpu->vcpu.arch.hcr_el2 |=3D READ_ONCE(host_vcpu->arc=
h.hcr_el2) &
> > +                                                      (HCR_TWI | HCR_T=
WE);
>
> [Severity: Medium]
> Does restricting the per-entry synchronization of HCR_TWI and HCR_TWE to =
only
> non-protected guests break dynamic scheduling behavior?
>
> These bits act as host-owned runtime signals. If the host dynamically upd=
ates
> vcpu->arch.hcr_el2 (for example, via kvm_vcpu_on_spin() to yield on
> spinlocks) and re-enters the guest, the updated WFI/WFE trapping policy
> won't be synced on entry for protected guests because it is now skipped h=
ere.

kvm_arch_vcpu_load() is the only writer of those two bits, and it
calls __pkvm_vcpu_load() with hcr_el2 a few lines later. There is no
update in between to drop.

/fuad


/fuad

>
> [ ... ]
> > @@ -249,17 +255,13 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *=
hyp_vcpu)
> >       /* __hyp_running_vcpu must be NULL in a guest context. */
> >       hyp_vcpu->vcpu.arch.ctxt.__hyp_running_vcpu =3D NULL;
> >
> > -     hyp_vcpu->vcpu.arch.mdcr_el2    =3D host_vcpu->arch.mdcr_el2;
> >       /*
> > -      * HCR_EL2.VSE is host-owned (a pending virtual SError to inject)=
, not a
> > -      * trap-control bit, so it must flow to the hyp vCPU alongside TW=
I/TWE
> > -      * for the vSError to be delivered. sync_hyp_vcpu() reflects it b=
ack.
> > +      * A host-injected vSError is masked by the guest's own PSTATE.A,=
 so it
> > +      * applies to protected guests too.
> >        */
> > -     hyp_vcpu->vcpu.arch.hcr_el2 &=3D ~(HCR_TWI | HCR_TWE | HCR_VSE);
> > -     hyp_vcpu->vcpu.arch.hcr_el2 |=3D READ_ONCE(host_vcpu->arch.hcr_el=
2) &
> > -                                              (HCR_TWI | HCR_TWE | HCR=
_VSE);
> > -
> > -     hyp_vcpu->vcpu.arch.vsesr_el2   =3D host_vcpu->arch.vsesr_el2;
> > +     hyp_vcpu->vcpu.arch.hcr_el2 &=3D ~HCR_VSE;
> > +     hyp_vcpu->vcpu.arch.hcr_el2 |=3D READ_ONCE(host_vcpu->arch.hcr_el=
2) & HCR_VSE;
>
> [Severity: Medium]
> Because HCR_TWI and HCR_TWE were removed from this unconditional allowlis=
t in
> flush_hyp_vcpu(), are we under-including these required bits for protecte=
d
> guests on re-entry?
>
> [ ... ]
> > @@ -329,6 +332,12 @@ static void handle___pkvm_vcpu_load(struct kvm_cpu=
_context *host_ctxt)
> >               /* Propagate WFx trapping flags */
> >               hyp_vcpu->vcpu.arch.hcr_el2 &=3D ~(HCR_TWE | HCR_TWI);
> >               hyp_vcpu->vcpu.arch.hcr_el2 |=3D hcr_el2 & (HCR_TWE | HCR=
_TWI);
>
> [Severity: Medium]
> While this code satisfies the WFx trapping configuration in
> handle___pkvm_vcpu_load(), doesn't moving it exclusively to the per-load
> path mean that any subsequent per-entry policy updates made by the host
> will be silently dropped for protected VMs?
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260831163421.27=
2420-1-fuad.tabba@linux.dev?part=3D5
