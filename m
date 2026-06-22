Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B0FB368D73
	for <kvmarm@lists.linux.dev>; Mon, 22 Jun 2026 10:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782123291; cv=pass; b=BC8b5FLQRq9HLpBHqp32IKPkrhYT1gtGP2cjinD41JCNeBPNXAUeXbaXrF09eUfaOQ5/9ZpnYn5CPo6gFqwMUj+CLI+1P6IgEbsf9DHnCXP4emuzw7YMCo1EGnsmOGS60Q9dWmFM5WZIAfsYT8IU+DJy7Ueges+LdTwXtQ/Yc+0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782123291; c=relaxed/simple;
	bh=3yB5LuKJvgiONenw4nzh7uWSxiBTMWM7dIiC9P1HMPA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HCNubJfrL/TzY6CKSPvKvhjycpqF6xVsadzqWyoFedX1NRhxi5oU4iAKqWu4xgSTo/zsaUPSR6C6Q9F5tAvfodworKpke3ID+7IpFK1oZdPO+1Uf6mZQN41KhTaJcVuNLG49eOvW/Y6G3ibSNpXIm9SKKOyoh/C1Fxxgw1pr3QQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OyjlK28m; arc=pass smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OyjlK28m"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-51765531803so625391cf.0
        for <kvmarm@lists.linux.dev>; Mon, 22 Jun 2026 03:14:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782123289; cv=none;
        d=google.com; s=arc-20260327;
        b=IDddPJHSwaxpqhmegEaNHHf261VWIRCD60X1koWG2oidRvA6WQL6e1CNy3OfZ3l4gy
         ihdzRh+v7cmC79G+7s0UgINzKP1nuWcc36HJWNJR2rqO/oWkH38N8DTbnctMTh6cnSPs
         VRrLCgB1NNck8M5Mh9kKWED4MEhxN6+z64vcOpAHBz57YEQ/pNFlbUspJGDAGySIAcwI
         3VNM6haiy+oKieY/4KvMZH3uG9Xi2tZ1qEunocX/VJXeGekoRespkjCCffiANGnEoIgN
         JpHNMjREtYrxRr8bZ0/EXQ8lTN18DOgLalT3zzlfWFvTXFI2c2VtNaZs1zVjSSpZvbST
         1/fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=4c6b6JJaSBLlb1nvUx6oYOg7Wq9Q5dUNaZHbrnZFblw=;
        fh=EiB8i65bDqg/aYubVTsJQrWiN4qQ2W3CE0PeU1Ji494=;
        b=NC8c1d5iudbz9ahpja5Lzz5P97RZG1BVIDjWhnE3OKUrEKCPylQVNZ/dbjr1yj9M0p
         cf7lc8lR+cjKYNYYFfKSJPpzMyuPpFs5Ry2IocOvtertY9aHLN0IfV9rz7Sx1E7fZCLo
         X7zav+KXV6cJ34idBu8lW0vNRfAmsN96eeie6Bf+yqsqMqU4VMBsxGcjIQrC2TQtwMs2
         6iH5jL1Wy6sDP+DwslE9Tx1f+a37Itf5fouZ1yfsBDMIDvT8l8AvnuK3SweSpjMhcp1Z
         rj6PwP9V5/vd56KrZ7jRMKWSUxPo6uQjanyXACku2WHnEjO7QQUM17c6PC7JA5Uiqwj5
         PSbA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782123289; x=1782728089; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4c6b6JJaSBLlb1nvUx6oYOg7Wq9Q5dUNaZHbrnZFblw=;
        b=OyjlK28mZYLoqmmsNWdQcWshfXI1qod4p1fXb4tlfQTpv3yO/4tTQizyWdiXIrehM3
         b0M6U66VgSHCo3rhMsXSpv273pJ2noFrk7aiY6yssqvOxk2MOciG/V6pgKT/6jkA3DQx
         i6RogQabP29gXmZi0SYspv7mhV11JYmT8NFiMjQMwqXQ/BEmPae/8ZQScxEbyov2BDWT
         c7WANzfPa/GDbA+V3LLJkjG5tBSm0l/uFKVfDIrUwVlDoQepiuXdzH+mgEnNDA54b72s
         f91LkUCMmHdnk8DN8jedBfWwnJz0LLM5Tpx8YJCqm7wRWedyL8C2fok4NWeBozdT6qLn
         cwvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782123289; x=1782728089;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=4c6b6JJaSBLlb1nvUx6oYOg7Wq9Q5dUNaZHbrnZFblw=;
        b=s5cc96m1S1CD3He+lu+IesmHo6ZVSZd5ui3kIC/M4KB8jHpvM8DLhFjor8zm2Fatp1
         q6WJUziVgLrpc8Ny/ugKwTTw95zFAdIzwXqYtPJT4h/oPr//qgQYVXoWT7bBbVeFlKmG
         31jp6Ar3KuZdNPhgYqhurFxbPICW+HCO0KWEtskTLSx6Dqabnu787g4EWz7CkSaZCFbF
         O1o08vRbyHEFJ2BMq6wfSp9Vy6eh3c5FFT4dU5gy9freXM1xce7bbTLBnM9WadCOQXjM
         hJP7onv8SSkgHneR25zdyLEVtre5G5/6g2Bd2+wi+qtgGIIy2tWSLKsILEJIJ0kJ8vRP
         NVpw==
X-Forwarded-Encrypted: i=1; AFNElJ/JaaTxCQ2pa6C6he7W2XzWwyqcp3INairuPfwsOmsDpTu00fI2Miej4vF3sXdKseb6oHIcAFQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YzOhYb7/mLDILh99UCpskYc8uZyCii8KFiWBUaWlxmfRcXhoymF
	S7keXKGKAz8o4w2PqGBjAqgsX1l/MC3p39XmakgdQC1aeZXKuCQFaNePHXn7Pk9rMeGR5EkPUuF
	QpK2ba92a4BhDFF1VGhXBnPlfCY5JeymkePDaYkop
X-Gm-Gg: AfdE7cmH6t8eB7cTvU52K2cp4a3oRthBjZ7u3y+8dhHxSpTb+qcqC5PSzi4EVikPiWN
	6AZC8ixc6MUDeitgrZA8l0+C9Y4XqrDExu4zmK3fxxbBMeeQuLJfBAzF7FLwcx0HKgyhpP4yJ+B
	vz0Jp6sKVBc+sSJ+68jxmX7iVGs0eeEEQSjZjNhG7YdofutSFYPubbGJ/5gbkZGOuefYgeoHeEp
	nb9fwUhC0lXRLhbUom6Az7T1nlNJ0i/oK3rmjdlU6Plo8TR/+56R8Lei7xKyV1UmucNFZAMipkW
	P89bPqhu
X-Received: by 2002:a05:622a:2b08:b0:517:99ea:ab7a with SMTP id
 d75a77b69052e-519e4ab67d5mr23266481cf.26.1782123288572; Mon, 22 Jun 2026
 03:14:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260619070719.812227-1-tabba@google.com> <20260619070719.812227-9-tabba@google.com>
 <ajVAV5ct0xdLn1KX@google.com> <CA+EHjTz13obYHAZYCW+zpH1RB953FseP9koXydeoLqmn6UONHQ@mail.gmail.com>
 <ajj3KzUrZZ1-2UQZ@google.com>
In-Reply-To: <ajj3KzUrZZ1-2UQZ@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 22 Jun 2026 11:14:11 +0100
X-Gm-Features: AVVi8CdpMK8FMnv9bhBXfcc28TenXa4-d-BsEgeEJUz6o79oKv2h1yruz0fVKMA
Message-ID: <CA+EHjTwB8OGpK1sJwNXktqDXYhweujUTKfdOdRggsKYF5srk5A@mail.gmail.com>
Subject: Re: [PATCH v2 8/8] KVM: arm64: Implement lazy vCPU state sync for
 non-protected guests
To: Vincent Donnefort <vdonnefort@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Quentin Perret <qperret@google.com>, Sebastian Ene <sebastianene@google.com>, 
	Hyunwoo Kim <imv4bel@gmail.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 22 Jun 2026 at 09:49, Vincent Donnefort <vdonnefort@google.com> wrote:
>
> [...]
>
> > > > diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> > > > index 54aedf93c78b..8963621bcdd1 100644
> > > > --- a/arch/arm64/kvm/handle_exit.c
> > > > +++ b/arch/arm64/kvm/handle_exit.c
> > > > @@ -422,6 +422,20 @@ static int handle_trap_exceptions(struct kvm_vcpu *vcpu)
> > > >  {
> > > >       int handled;
> > > >
> > > > +     /*
> > > > +      * If we run a non-protected VM when protection is enabled
> > > > +      * system-wide, resync the state from the hypervisor and mark
> > > > +      * it as dirty on the host side if it wasn't dirty already
> > > > +      * (which could happen if preemption has taken place).
> > > > +      */
> > > > +     if (is_protected_kvm_enabled() && !kvm_vm_is_protected(vcpu->kvm)) {
> > > > +             guard(preempt)();
> > > > +             if (!(vcpu_get_flag(vcpu, PKVM_HOST_STATE_DIRTY))) {
> > > > +                     kvm_call_hyp_nvhe(__pkvm_vcpu_sync_state);
> > > > +                     vcpu_set_flag(vcpu, PKVM_HOST_STATE_DIRTY);
> > > > +             }
> > > > +     }
> > > > +
> > >
> > > Could we remove this update here and let handle_exit_early() do the sync
> > > regardless of the SError injection? One of the main point of handle_exit_early()
> > > is to do things under !prempt().
> >
> > Agreed on the move: handle_exit_early() is already preempt-off, so the
> > guard() goes away. Not on every exit though. handle_exit_early() runs
> > on every exit, and sync_hyp_vcpu() only copies PC/PSTATE/fault back
> > for a non-protected guest; the GPRs and sysregs cross solely via
> > __pkvm_vcpu_sync_state. Syncing unconditionally would pull the full
> > context back on plain IRQ exits, which is the copy this patch avoids.
> > So I will gate it on trap-or-SError and drop the
> > handle_trap_exceptions() block.
> >
> > >
> > >
> > > >       /*
> > > >        * See ARM ARM B1.14.1: "Hyp traps on instructions
> > > >        * that fail their condition code check"
> > > > @@ -489,6 +503,22 @@ int handle_exit(struct kvm_vcpu *vcpu, int exception_index)
> > > >  /* For exit types that need handling before we can be preempted */
> > > >  void handle_exit_early(struct kvm_vcpu *vcpu, int exception_index)
> > > >  {
> > > > +     bool inject_serror = ARM_SERROR_PENDING(exception_index) ||
> > > > +             ARM_EXCEPTION_CODE(exception_index) == ARM_EXCEPTION_EL1_SERROR;
> > > > +
> > > > +     /*
> > > > +      * An SError injected below writes the host ctxt; for a non-protected
> > > > +      * guest, sync from the hyp vCPU and keep it dirty so it isn't dropped.
> > > > +      */
> > > > +     if (is_protected_kvm_enabled()) {
> > >
> > > Should we test !kvm_vm_is_protected(vcpu->kvm) here, as the
> > > PKVM_HOST_STATE_DIRTY is only updated for p-guests everywhere else?
> >
> > Yes. The flag is only ever set for non-protected guests, so clearing it
> > for a protected one is a no-op, but gating it matches the invariant.
> >
> > Both fold into one block in handle_exit_early():
> >
> >       if (is_protected_kvm_enabled() && !kvm_vm_is_protected(vcpu->kvm)) {
> >               if (inject_serror ||
> >                   ARM_EXCEPTION_CODE(exception_index) == ARM_EXCEPTION_TRAP) {
> >                       kvm_call_hyp_nvhe(__pkvm_vcpu_sync_state);
> >                       vcpu_set_flag(vcpu, PKVM_HOST_STATE_DIRTY);
> >               } else {
> >                       vcpu_clear_flag(vcpu, PKVM_HOST_STATE_DIRTY);
> >               }
> >       }
> >
> > I will fold this into the next respin.
>
> Ah yes of course, I was hoping we could just have a switch here, just like
> handle_exit() does, but that's not possible because of ARM_SERROR_PENDING().
>
> Perhaps it would look cleaner if done in a separate function
> handle_exit_pkvm_state()?

Agreed, that reads better. Pulling it into handle_exit_pkvm_state()
also gets inject_serror out of handle_exit_early(), which only used it
for this. Done for the next respin.

Cheers,
/fuad

>
>
> >
> > Thanks for the reviews!
> > /fuad
> >
> > >
> > > > +             vcpu_clear_flag(vcpu, PKVM_HOST_STATE_DIRTY);
> > > > +
> > > > +             if (inject_serror && !kvm_vm_is_protected(vcpu->kvm)) {
> > > > +                     kvm_call_hyp_nvhe(__pkvm_vcpu_sync_state);
> > > > +                     vcpu_set_flag(vcpu, PKVM_HOST_STATE_DIRTY);
> > > > +             }
> > > > +     }
> > > > +
> > > >       if (ARM_SERROR_PENDING(exception_index)) {
> > > >               if (this_cpu_has_cap(ARM64_HAS_RAS_EXTN)) {
> > > >                       u64 disr = kvm_vcpu_get_disr(vcpu);
> > >
> > > [...]
