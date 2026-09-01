Received: from mta0.migadu.com (out-237.mta0.migadu.com [91.218.175.237])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDB5B3CF200
	for <kvmarm@lists.linux.dev>; Tue,  1 Sep 2026 10:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.237
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788258246; cv=none; b=b9pF9QTaIpubuyyc0yfrWduaTKL8VOUfOwFNz4dLXMMghHebvzbOs40qwioIB/Z8PPEdKzm3M0PBDbsCHPIEKWOdvZ14J2JKD9+Z9aJnUF2fnGe4nr3JTxNXKnTATAwPK/uCQWVxrsnfclxLWPtokTvDor2nanNFOlFjkfZFYiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788258246; c=relaxed/simple;
	bh=1ZRlXJ6pTNiciXCv3e0Qf4lZEbdGciYfHGrczdl+PeU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KWeBiD+f15MG9LQ6ztdqVbOryz9wu3OCxrScQfZop1s3RfdOkd81LZxBBhT0VTLye0x68O+FxxPA8ov/saFjGGlE57aexEh3JrxB3m7bLG3s2cF8Hk6JhtmNFhYEzUwqb9wf+sbJTaIJRCNMOWBF7c5Z0tj41jrhaZ5OMtp7gZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=k8XYEFtV; arc=none smtp.client-ip=91.218.175.237
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="k8XYEFtV"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=1ZRlXJ6pTNiciXCv3e0Qf4lZEbdGciYfHGrczdl+PeU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788258242; v=1; x=1788863042;
 b=k8XYEFtV6woAnpqgFQYMs55na3ipWhg181qDIPqm/1q6scjnNF5RgQk6+hBhvTjvddcinZUI
 +lpK7UpRA12LNUDSjscfdoTfxXfYA+dsWSltAG0s/uuQX22kYRFa+6yPwFjlojrKliARMHqHGVn
 yng535oRQs3+1K0zDAyl6B6Y=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 586f08153832ff25;
	Tue, 01 Sep 2026 10:24:02 +0000
X-Mizu-Trace-ID: 586f08153832ff25
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5b2a73da7e1so6588e87.0
        for <kvmarm@lists.linux.dev>; Tue, 01 Sep 2026 03:23:58 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBys5PfuGDQ6Bmbhg7GJOxbe+5lXQ9RDNIiTNR2gnuvRZWwinjqBmPJQxgz79meUh9w9Wca4hkw=@lists.linux.dev
X-Gm-Message-State: AFuF++lbpctkxtipC8CeUUDzT3YxCt0Hl5x5iOBU/eBjb9t1oTA5KV72
	AfSDbk5IiOcSvvJX/ImnYg4PzHXOEZGNI2YupjLM1QU8HRbt7EyYvDRbr/sRbkTs7QANb17LtQN
	QQCHxd0VaLNlnBG/EE5aTaIYB0Pts6QLPeqKlsaM2
X-Received: by 2002:a05:6512:3e0c:b0:5b2:a5e9:3aba with SMTP id
 2adb3069b0e04-5b5ff28cff6mr138197e87.6.1788258237767; Tue, 01 Sep 2026
 03:23:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260831163421.272420-1-fuad.tabba@linux.dev> <20260831163421.272420-10-fuad.tabba@linux.dev>
 <20260831211457.1AE451F00A3D@smtp.kernel.org>
In-Reply-To: <20260831211457.1AE451F00A3D@smtp.kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 1 Sep 2026 11:23:21 +0100
X-Gmail-Original-Message-ID: <CA+EHjTyXKua0jbC-9AF4L19ikXopa5ELWPoQV18QojZy_e6F7Q@mail.gmail.com>
X-Gm-Features: AcwNN1WdTRzgNeFRxi44rzIw9xhKWI3fVZkc5lV-ZnSwni6V793tuOdVH21m308
Message-ID: <CA+EHjTyXKua0jbC-9AF4L19ikXopa5ELWPoQV18QojZy_e6F7Q@mail.gmail.com>
Subject: Re: [PATCH 09/17] KVM: arm64: Handle PSCI calls for protected VMs at EL2
To: sashiko-reviews@lists.linux.dev
Cc: Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Nor this one...

On Mon, 31 Aug 2026 at 22:15, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
> - [High] Malicious host can hijack guest execution flow via CPU_ON TOCTOU=
 race caused by stale reset_state.reset flag.
> --
>
> commit f4181bbdd19d9d3775a4f479d2c7c70dc5c753b8
> Author: Fuad Tabba <fuad.tabba@linux.dev>
>
> KVM: arm64: Handle PSCI calls for protected VMs at EL2
>
> This patch implements PSCI 1.1 for protected VMs in EL2, handling power s=
tate
> transitions (CPU_ON, CPU_OFF, AFFINITY_INFO) within the hypervisor, while
> keeping non-protected VMs unchanged. It defines protected vCPU power stat=
es
> and synchronizes racing transitions via cmpxchg and release/acquire barri=
ers.
>
> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nv=
he/hyp-main.c
> > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> [ ... ]
> > @@ -37,27 +40,103 @@ typedef void (*hyp_entry_exit_handler_fn)(struct p=
kvm_hyp_vcpu *);
> >
> >  static void __maybe_unused handle_pvm_entry_hvc64(struct pkvm_hyp_vcpu=
 *hyp_vcpu)
> >  {
> [ ... ]
> > +                     prev =3D cmpxchg_relaxed(&target_vcpu->power_stat=
e,
> > +                                            PSCI_0_2_AFFINITY_LEVEL_ON=
_PENDING,
> > +                                            PSCI_0_2_AFFINITY_LEVEL_OF=
F);
> > +                     switch (prev) {
> > +                     case PSCI_0_2_AFFINITY_LEVEL_ON_PENDING:
> > +                             /*
> > +                              * Leave reset_state.reset set: clearing =
it
> > +                              * races a concurrent CPU_ON's re-publish=
 and
> > +                              * wedges the target at ON_PENDING. The s=
tale
> > +                              * pc/r0/be are the guest's own.
> > +                              */
> > +                             ret =3D PSCI_RET_INTERNAL_FAILURE;
> > +                             break;
>
> [Severity: High]
> Does this rollback logic allow a malicious host to hijack guest execution=
 flow
> by exploiting a TOCTOU race?
>
> If guest vCPU A calls CPU_ON for target T with PC1, the hypervisor sets
> power_state =3D ON_PENDING. If the host then rejects the call, this rollb=
ack
> logic resets power_state to OFF but intentionally leaves reset_state.rese=
t =3D
> true and pc =3D PC1.
>
> If guest vCPU B then calls CPU_ON for target T with PC2, pvm_psci_vcpu_on=
()
> sets power_state =3D ON_PENDING. Before the hypervisor writes PC2, a mali=
cious
> host could concurrently issue KVM_RUN for target T on another CPU.
>
> Because the stale reset flag is still true from the previous failure, tar=
get T
> will immediately boot using the stale PC1 instead of PC2, redirecting the
> guest control flow.
>
> Should this rollback clear the reset state, or is there another way to pr=
event
> the host from forcing a boot with a stale PC?

The stale pc/r0/be are from an earlier CPU_ON the guest itself issued,
so the host can only pick between addresses the guest wrote. Clearing
the flag races a concurrent CPU_ON's re-publish and wedges the target
at ON_PENDING, which is why it stays set.

/fuad


/fuad

>
> [ ... ]
> > diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/p=
kvm.c
> > --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> [ ... ]
> > +int pkvm_reset_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
> > +{
> > +     struct vcpu_reset_state *reset_state =3D &hyp_vcpu->vcpu.arch.res=
et_state;
> > +     int prev;
> > +
> > +     /*
> > +      * Pairs with smp_store_release(&reset_state->reset, true) in
> > +      * pvm_psci_vcpu_on(). The acquire must precede the cmpxchg: reve=
rsed, a
> > +      * winning cmpxchg with a false acquire would leave power_state =
=3D=3D ON
> > +      * with the reset skipped.
> > +      */
> > +     if (!smp_load_acquire(&reset_state->reset))
> > +             return -ECANCELED;
>
> [Severity: High]
> Can the host force pkvm_reset_vcpu() to succeed prematurely here?
>
> Since the rollback in handle_pvm_entry_hvc64() leaves reset_state.reset
> set to true, if a new CPU_ON sets power_state to ON_PENDING, a host-contr=
olled
> KVM_RUN can enter this function and pass this smp_load_acquire() check be=
fore
> the new PC is actually written by pvm_psci_vcpu_on().
>
> [ ... ]
> > +static bool pvm_psci_vcpu_on(struct pkvm_hyp_vcpu *hyp_vcpu)
> > +{
> [ ... ]
> > +     /*
> > +      * vCPUs race to power on the same target. Relaxed: reset_state
> > +      * is published by the release on reset_state.reset below.
> > +      */
> > +     power_state =3D cmpxchg_relaxed(&target->power_state,
> > +                                   PSCI_0_2_AFFINITY_LEVEL_OFF,
> > +                                   PSCI_0_2_AFFINITY_LEVEL_ON_PENDING)=
;
>
> [Severity: High]
> Does setting power_state to ON_PENDING here open a TOCTOU window?
>
> If the target already has a stale reset_state.reset =3D=3D true from a pr=
eviously
> failed CPU_ON attempt, making the target ON_PENDING here allows the host =
to
> schedule the target and boot it before the new PC/r0/be states are update=
d
> below.
>
> > +     switch (power_state) {
> [ ... ]
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260831163421.27=
2420-1-fuad.tabba@linux.dev?part=3D9
