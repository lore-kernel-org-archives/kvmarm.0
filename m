Received: from mta1.migadu.com (out-214.mta1.migadu.com [95.215.58.214])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8792E233939
	for <kvmarm@lists.linux.dev>; Mon,  7 Sep 2026 09:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.214
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788772491; cv=none; b=YVwSBnqj/9IN7LTrwcbvWs4agAdFH0UQPUAuJaErHiIzwFFbpVOdtj4g+bYsI1Pbsxcx/TjHG5ciGK3f6wygMLCalgGFyYpyNcppvwiAwI04QH6kelsDHuPDimIhWSRzk018M/fIwbs89/qnVGZaU86wpiPMe9P7jcugx068JBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788772491; c=relaxed/simple;
	bh=UBMDHKwS6gQ27xjGXxea0m4EWUdEAVbjtPSgpwtV8ck=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nBuaz/pzKuwkhgAXLG7B2av7zc/POTozaush14rum/2mdzFRGcrjvX2asApvT4SEfJSxMz9zP4t/kDcN4lyzOLWu2wDf73MUvqTTiHBklHVEuA6rGtQ4iCKfvcWvSW3mPLPqsvLVxDVcztL/WYLdU63w9cZzVlWJMYpRclqvByg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=etGFKgOc; arc=none smtp.client-ip=95.215.58.214
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="etGFKgOc"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=UBMDHKwS6gQ27xjGXxea0m4EWUdEAVbjtPSgpwtV8ck=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788772487; v=1; x=1789377287;
 b=etGFKgOcJduZ/DWzbX4keFOTD71uJLiGuvWOADfz+5gcgEM9j9awN7HyvipSPLNqkTaK9REH
 TZsFPjFW94BVoPmvS57i8T4I/eNf3tUj8b02P5ugv2FoCD1tOXSVzIFtyQBFKy3Fy4zrvtEpeyR
 b3nkVK10Y2gk5qJi1rjfyOOc=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id f997fca89d450abe;
	Mon, 07 Sep 2026 09:14:47 +0000
X-Mizu-Trace-ID: f997fca89d450abe
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b4a0b17359so7315e87.0
        for <kvmarm@lists.linux.dev>; Mon, 07 Sep 2026 02:14:43 -0700 (PDT)
X-Gm-Message-State: AFuF++kpijALEt4UI27v+Alhumch4YJksYdgZGbYAfFR6xWdDkTXUkYf
	ezWbbncnkUizxf0ck9dbWLi8DYTvcvSGwIEkDGdtUv3zVysZC9Uwyw9UqJwq59gBk7DPc32kfKh
	19YGpZ02xOxIZRRauxwZGpPQAIsSeYaflrz21C3/t
X-Received: by 2002:a05:6512:10cd:b0:5b1:5e30:ab4d with SMTP id
 2adb3069b0e04-5b74d1f8fc1mr142227e87.5.1788772482328; Mon, 07 Sep 2026
 02:14:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260907070002.3333525-1-fuad.tabba@linux.dev>
 <20260907070002.3333525-9-fuad.tabba@linux.dev> <20260907071643.0B6FF1F00A3A@smtp.kernel.org>
In-Reply-To: <20260907071643.0B6FF1F00A3A@smtp.kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 7 Sep 2026 10:14:06 +0100
X-Gmail-Original-Message-ID: <CA+EHjTxpSimW5+71bPCO6OU2-xNwM04U9MtCM2aO9t1nSB5_uA@mail.gmail.com>
X-Gm-Features: AcwNN1U3hwFZ0ybTdhqxMjlLa92-e7Jm-6H3qZDQcHdN4IQOvw95dYxnsRa8pW0
Message-ID: <CA+EHjTxpSimW5+71bPCO6OU2-xNwM04U9MtCM2aO9t1nSB5_uA@mail.gmail.com>
Subject: Re: [PATCH v2 08/17] KVM: arm64: Handle PSCI calls for protected VMs
 at EL2
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>, 
	Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 7 Sept 2026 at 08:16, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 2 potential issu=
e(s) to consider:
>
> New issues:
> - [High] The error path in `pkvm_reset_vcpu()` leaves `reset_state->reset=
 =3D true`, breaking the synchronization barrier for subsequent `CPU_ON` ca=
lls.

Same as v1's rollback finding [1], so no.

>
> Pre-existing issues:
> - [High] Memory leak of SVE state pages when VM-wide initialization fails=
, due to clearing `KVM_ARM_VCPU_SVE`.

Fix is here [2].

/fuad

[1] https://lore.kernel.org/all/CA+EHjTyXKua0jbC-9AF4L19ikXopa5ELWPoQV18Qoj=
Zy_e6F7Q@mail.gmail.com/
[2] https://lore.kernel.org/all/20260825085948.1674721-1-fuad.tabba@linux.d=
ev/
> --
>
> commit c2e0971411fd802ad76348d4eef69923169c10e5
> Author: Fuad Tabba <fuad.tabba@linux.dev>
>
>     KVM: arm64: Handle PSCI calls for protected VMs at EL2
>
> This commit implements PSCI 1.1 handling at EL2 for protected VMs. It man=
ages
> the vCPU power state transitions between OFF, ON_PENDING, and ON, and
> intercepts PSCI calls like CPU_ON, CPU_OFF, and AFFINITY_INFO. Calls that
> require host intervention, such as scheduling, are safely forwarded.
>
> > diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/p=
kvm.c
> > index 69f13362b7ab0..4ce79e191ff45 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
>
> [ ... ]
>
> > @@ -407,6 +442,9 @@ static void unpin_host_sve_state(struct pkvm_hyp_vc=
pu *hyp_vcpu)
> >               return;
> >
> >       sve_state =3D hyp_vcpu->vcpu.arch.sve_state;
> > +     if (!sve_state)
> > +             return;
> > +
>
> [Severity: High]
> This isn't a bug introduced by this patch, but does the early return in
> unpin_host_sve_state() cause a memory leak of SVE state pages when VM-wid=
e
> initialization fails?
>
> If pkvm_vcpu_init_sve() fails on a secondary vCPU (for example, due to an
> invalid configuration from host userspace), the error path in
> pkvm_vcpu_init_sve() clears the KVM_ARM_VCPU_SVE bit in the VM-wide
> vcpu_features bitmap.
>
> During the subsequent teardown of the VM, unpin_host_vcpus() calls
> unpin_host_sve_state() for all vCPUs. Because the feature bit was cleared=
,
> unpin_host_sve_state() returns early and fails to unpin the SVE state
> memory that was successfully pinned for previously initialized vCPUs. Thi=
s
> allows for a denial of service via resource exhaustion from host userspac=
e.
>
> >       hyp_unpin_shared_mem(sve_state,
> >                            sve_state + vcpu_sve_state_size(&hyp_vcpu->v=
cpu));
> >  }
>
> [ ... ]
>
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
> > +
> > +     prev =3D cmpxchg_relaxed(&hyp_vcpu->power_state,
> > +                            PSCI_0_2_AFFINITY_LEVEL_ON_PENDING,
> > +                            PSCI_0_2_AFFINITY_LEVEL_ON);
> > +     if (prev !=3D PSCI_0_2_AFFINITY_LEVEL_ON_PENDING) {
> > +             /* The only other writer of ON_PENDING is the rollback. *=
/
> > +             WARN_ON(prev !=3D PSCI_0_2_AFFINITY_LEVEL_OFF);
> > +             return -ECANCELED;
>
> [Severity: High]
> Does the -ECANCELED error path in pkvm_reset_vcpu() leave
> reset_state->reset set to true, breaking the synchronization barrier for
> subsequent CPU_ON calls?
>
> If a CPU_ON hypercall is followed by a host rollback (which sets power_st=
ate
> back to OFF but intentionally leaves reset_state.reset =3D true), a
> subsequent CPU_ON from the guest sets power_state to ON_PENDING, writes
> the new pc/r0, and sets reset_state->reset =3D true.
>
> However, because reset_state->reset was already left as true, if the targ=
et
> vCPU executes pkvm_reset_vcpu() concurrently, its
> smp_load_acquire(&reset_state->reset) will immediately succeed. The targe=
t
> vCPU then reads pc and r0 before the CPU_ON call has finished writing the=
m,
> resulting in a data race and the guest booting with corrupted state.
>
> > +     }
> > +
> > +     kvm_reset_vcpu_core(&hyp_vcpu->vcpu);
> > +     kvm_reset_pvm_sys_regs(&hyp_vcpu->vcpu);
> > +
> > +     /* Must be done after resetting sys registers. */
> > +     kvm_reset_vcpu_psci(&hyp_vcpu->vcpu, reset_state);
> > +
> > +     hyp_vcpu->exit_code =3D 0;
> > +     /*
> > +      * power_state =3D=3D ON rules out the other two writers, the sou=
rce
> > +      * cmpxchg(OFF, ON_PENDING) and the rollback cmpxchg(ON_PENDING, =
OFF).
> > +      */
> > +     reset_state->reset =3D false;
> > +     return 0;
> > +}
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907070002.33=
33525-1-fuad.tabba@linux.dev?part=3D8
