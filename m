Received: from mta1.migadu.com (out-26.mta1.migadu.com [95.215.58.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C3A40BCB6
	for <kvmarm@lists.linux.dev>; Mon,  7 Sep 2026 09:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.26
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788772704; cv=none; b=j47WkTCk5XoEWL8LOl0sHbWjOsG0tH80XoteXg+Op3YDLGX7qqWwBEjJfMsCzJM+C2bIXyzl1ulTuH7fMybNc1PrWPty1GPUgH2qWF9zkNd6ohUHhjyW9iJ30rW4/IEW2fkwSbAuatHLSdtzj7R15jvyXaJg0vVPsOo0AHBmC6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788772704; c=relaxed/simple;
	bh=NMmnruQcSvMUYtst/pdiGCEhTm1knA3CnbwlW6NUIR4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=vCQzi4X5VGcLN0CEbCK/tlW7tgcb44o+huwhbxEDL8jtuB2iKVisDyUpK0ujRmRwwDQKdQWf4x8cukshuBWyyFQgmV4NzAeAo57j6h1hQNGiAqyaIeCcO+LzFRbj1o7e1CziaxzmFnftTMD5tuCsS8fWIavVL82bPhgGFbr1Q+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gi0WPVwm; arc=none smtp.client-ip=95.215.58.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gi0WPVwm"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=NMmnruQcSvMUYtst/pdiGCEhTm1knA3CnbwlW6NUIR4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788772700; v=1; x=1789377500;
 b=gi0WPVwmsmCimMhShnTuy6awXXYR7YMak4hjB8lMwGaYCAyBcznQ0GLFbDpJdl+TwGi/KUkB
 WKhGUgD7OY4FChu5ivfpkLN4RTWxoQ7yfwLSeUgsuo0X6aGrXYw9bNDtGF9KXzSHLHrTVEotjyX
 /7dUDXmvuAmy0T0yZdQnum+M=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 89b662f0d5399fee;
	Mon, 07 Sep 2026 09:18:20 +0000
X-Mizu-Trace-ID: 89b662f0d5399fee
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b4a0b17358so5420e87.1
        for <kvmarm@lists.linux.dev>; Mon, 07 Sep 2026 02:18:20 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzFHn7U+6QmAyPNs1BlsQcaqn8OrnjTXWk43JPjrRwRrSp4PJ1lN93FRgaVa2mGZUkc1DlwVXM=@lists.linux.dev
X-Gm-Message-State: AFuF++nBHBnD71NPttZGXmYPrgI22c14S3yr1pnPvrpxxOrJsaH/vf1h
	ayODLJj9EVu7eKgc5rSUTY2O6LVewjtzSI6gqGqPfO9BWo//bs/LRDPyjRYpQs976ml5ENBpAT/
	c0+K2AKcpZU5ANYXLT308gTw0V3bfuUnOwQ7pixH2
X-Received: by 2002:a05:6512:61a1:b0:5ae:b726:5f1f with SMTP id
 2adb3069b0e04-5b74d1c3ec3mr131418e87.8.1788772699408; Mon, 07 Sep 2026
 02:18:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260907070002.3333525-1-fuad.tabba@linux.dev>
 <20260907070002.3333525-16-fuad.tabba@linux.dev> <20260907072924.EA5AE1F00A3A@smtp.kernel.org>
In-Reply-To: <20260907072924.EA5AE1F00A3A@smtp.kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 7 Sep 2026 10:17:42 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzhCQ0HnqDp4_4QRTSQy65RTEWRt1R6qztkMFS8TVEPvQ@mail.gmail.com>
X-Gm-Features: AcwNN1XT2kmW6rd0sv52k70Qp3A_rDasEaISxdCdpQZOVJZor45JsdmZKGbvCVg
Message-ID: <CA+EHjTzhCQ0HnqDp4_4QRTSQy65RTEWRt1R6qztkMFS8TVEPvQ@mail.gmail.com>
Subject: Re: [PATCH v2 15/17] KVM: arm64: Reject host power-on of a vCPU that
 EL2 holds powered off
To: sashiko-reviews@lists.linux.dev
Cc: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 7 Sept 2026 at 08:29, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
>
> Pre-existing issues:
> - [High] Race condition between EL2 and Host PSCI handling leads to state=
 desynchronization and guest failure (INTERNAL_FAILURE)

Good one, but not preexisting and not high...

> --
>
> commit 80fb3e3ea2b949c35be53322315a43ff86b0f3ea
> Author: Fuad Tabba <fuad.tabba@linux.dev>
>
> KVM: arm64: Reject host power-on of a vCPU that EL2 holds powered off
>
> A protected vCPU's power state belongs to EL2, which changes it only
> on the guest's own PSCI calls. KVM_SET_MP_STATE(RUNNABLE) on a vCPU
> EL2 holds powered off changes the host's copy alone, and the guest's
> next CPU_ON of that vCPU then fails: mp_state is no longer STOPPED, so
> the host returns ALREADY_ON, which EL2 turns into INTERNAL_FAILURE.
> SUSPENDED has the same effect.
>
> [ ... ]
>
> > diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
> > index e3db84400d1f8..208289a08099f 100644
> > --- a/arch/arm64/kvm/psci.c
> > +++ b/arch/arm64/kvm/psci.c
> > @@ -94,6 +94,9 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu=
 *source_vcpu)
> >        */
> >       smp_wmb();
> >
>
> [Severity: High]
> This is a pre-existing issue, but can a concurrent CPU_OFF and CPU_ON cau=
se
> state desynchronization between EL2 and the host?
>
> In kvm_psci_vcpu_on(), there is an early return path before this hunk:
>
>         spin_lock(&vcpu->arch.mp_state_lock);
>         if (!kvm_arm_vcpu_stopped(vcpu)) {
>                 if (kvm_psci_version(source_vcpu) !=3D KVM_ARM_PSCI_0_1)
>                         ret =3D PSCI_RET_ALREADY_ON;
>                 else
>                         ret =3D PSCI_RET_INVALID_PARAMS;
>
>                 goto out_unlock;
>         }
>
> If vCPU 0 executes CPU_OFF, EL2 transitions it to OFF and exits to the ho=
st.
> Concurrently, if vCPU 1 executes CPU_ON targeting vCPU 0, EL2 transitions=
 it
> to ON_PENDING and exits to the host.
>
> If the host thread for vCPU 1 acquires mp_state_lock before the host thre=
ad
> for vCPU 0, the host sees mp_state as RUNNABLE, rejects the CPU_ON, and
> returns ALREADY_ON. EL2 then turns this into an INTERNAL_FAILURE, which l=
eads
> to the permanent loss of a vCPU.
>
> Taking this early return path also skips the newly introduced
> pkvm_powered_off =3D false update, compromising the accuracy of the track=
ing.
>
> Could this early return condition in kvm_psci_vcpu_on() be updated to pro=
perly
> account for pending EL2 state transitions?

On the base a protected guest's PSCI is handled at the host, where
AFFINITY_INFO and CPU_ON read the same mp_state. At EL2, AFFINITY_INFO
already reports the target OFF, so a guest doing CPU hotplug can issue
its CPU_ON before the target's host thread has handled the CPU_OFF
exit.

The result is one failed CPU_ON, not a lost vCPU or a stale
pkvm_powered_off: the rollback returns EL2 to OFF, the target's thread
then sets STOPPED and the flag, and the next CPU_ON succeeds.

v3 will report AFFINITY_INFO from the host, as the base does, so a
guest that polls it before CPU_ON, as Linux does, can't hit the
window.

/fuad

>
> > +     /* EL2 has committed the protected vCPU to ON_PENDING to get here=
. */
> > +     vcpu->arch.pkvm_powered_off =3D false;
> > +
> >       WRITE_ONCE(vcpu->arch.mp_state.mp_state, KVM_MP_STATE_RUNNABLE);
> >       kvm_vcpu_wake_up(vcpu);
> >
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907070002.33=
33525-1-fuad.tabba@linux.dev?part=3D15
