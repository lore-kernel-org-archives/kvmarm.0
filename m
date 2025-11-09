Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BFCB2472B6
	for <kvmarm@lists.linux.dev>; Sun,  9 Nov 2025 19:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762717922; cv=none; b=T3ly1EH/RxQVQUcA46tGFjwMu6YJNh0svze4ACdQbjODi1REc5CrDnebGWtL+M7GZVS8TjvwSffmSW8lsQxFyURsILIjA2/5ph80950y0afKWLjmA+epJ3QhoujcYt2lSizpupSQ5iWO/BUVmwdeC7SnSxsXr+ca/TT83s6VaFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762717922; c=relaxed/simple;
	bh=DDx0oH9J4jWLSXqVXQ5wGabQMfZYPV02UwM1pJ7iZLA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QKFRDAr731AVzbk6JSrI4XZT+U/sYfNlrGSNj6vWYESSFF0rqvfqfqEIHVjVldQIjTQ3XEy5fgw4Oiki7k+dW8jfyLHv/tXEl2F7f+ms/4iuNhRmhzBO8p8jmnp+YFRtBkQgr55LPBbMfGVy3QuBscmsWjskkQykW+aiL26EFgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=E5sp3mQn; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="E5sp3mQn"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4edb8d6e98aso75711cf.0
        for <kvmarm@lists.linux.dev>; Sun, 09 Nov 2025 11:52:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762717919; x=1763322719; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OTz2w5HL5Ejr50u7/poHpClQJimjVd3Gl5xrFoUqsig=;
        b=E5sp3mQntlrRL5KdXpQJHaFaslPqYgow+Wn3qPUABQ6Z818oY1DZBGMHrmvHvri53G
         c9p1gLTWAWSmoclARWz23UUQSdN0mXcl1igVLUEXSIxQaD06ZIwjFgmvczuhWC6Ef2JD
         0fegqWt+tYufXm7kb1023I3mx8YgmldKJfiDmPb5/z22MoT4zPg+en2/SG+jN5yxJX+p
         gKRIFe6i6h3pwKT4BkNvc4qXZobOxO6bKwcQ7xSiyyKx/rnE/gAaoxlVjQmCcaOyKT+e
         ELNPyB3BSDIIxBW5ljQHbaw9GxbrAW7TcYW9VqoQSXK6fYxIVgEPeDz9wDMNQ/6wsuEs
         EerQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762717919; x=1763322719;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OTz2w5HL5Ejr50u7/poHpClQJimjVd3Gl5xrFoUqsig=;
        b=lNlrD8IE2PJGHViKrMLRiEyls6wDsXxTlzzm6Nwm2WZJZPqln1vpVCaTSJjrTJQ7+c
         VptaE+cmoHWi0x6BSdl6Xwc+f1Suab62GUqGuJJYFfiRMoLAy2ADB+scslzfPnWgpwq2
         3XRqugAC5i5zaDrKVgZ6WlaHHjFa905fzEkufw1hEPLkaRD8lNZa5yteOsb7c13qDEYc
         M8k2qB3h1sQp6VMOxppAgL05VHcG985DvjtjIOXiCLL8XXAPdViOX03wh/DKQzsvN4Ty
         eBcA2cgK7mRUVF+40o0x24W2uU4wjtAIIcrC8xti4lNFBZjqC5zFQuxZtbYG7ozpNfV/
         LOUw==
X-Gm-Message-State: AOJu0Yws/HFe0BadfSS/2uciiLDuS0ImJaLpgw//dCXjKrACQkdZfstI
	3Df6uof06gZGSxpzjrIaIE2OLQ4YOB8pQlddvWlrQ7GLS803ZmeLxuH39RbdzNJIvrrGeQXqbpO
	8hK9Xj4HjNYgZlgjxR8JFoIPbl+dUFS+/c9SodSBE
X-Gm-Gg: ASbGnctvCdkWM65SVRTRKh+8yRQwpGcQVwvBvhNgjnjcdMs7oAvs5J+r5ev1k5ue0VQ
	0UtpeeEdrlbzLxTgIClfMP3efvsDrfiZcIMgAqu3BxCUxzgJ2yQG5vk+WyrPoDEGQ4lbaNIaALI
	jA46N8VdGS6NtIkYHJgexmIvlPkS5jFQCNM2xlzRvYSyFQ436ALntNj9XmE1e8P17CCmSmORZFr
	2vI+ykwpU+Lm+5+yDubyPbPJQpvlnt+mDyIYPjHtYbbn4kpPEf1SwUfgcA6DE6hG1L+0xK7Zkv2
	IoICaQ==
X-Google-Smtp-Source: AGHT+IEzuUR9i/DsGuyvuYeaAupJUFtq6EGjLuIkFDKVIxNAXIx7mqn/rwfeGhZP3dXd1KCbe5d7NKDzoF5DRNUbwMM=
X-Received: by 2002:a05:622a:647:b0:4b7:9a9e:833f with SMTP id
 d75a77b69052e-4eda64cfc84mr8262011cf.7.1762717919109; Sun, 09 Nov 2025
 11:51:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251106144418.2847443-1-tabba@google.com> <20251106144418.2847443-5-tabba@google.com>
 <aQ5-9PsBl3z9UxOS@kernel.org>
In-Reply-To: <aQ5-9PsBl3z9UxOS@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Sun, 9 Nov 2025 19:51:21 +0000
X-Gm-Features: AWmQ_bk3SE5yKaL2J_2lYDxkTSfrEls5EHxjDwqy6OBdwXsyt8zhDrGNvTnT7Qc
Message-ID: <CA+EHjTyoi+fnw5o3F+J-qKFygKoXz6SKmBG5bS-d5mA0=ysYKg@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] KVM: arm64: Prevent host from managing timer
 offsets for protected VMs
To: Oliver Upton <oupton@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	vladimir.murzin@arm.com
Content-Type: text/plain; charset="UTF-8"

Hi Oliver,

On Fri, 7 Nov 2025 at 23:21, Oliver Upton <oupton@kernel.org> wrote:
>
> On Thu, Nov 06, 2025 at 02:44:16PM +0000, Fuad Tabba wrote:
> > For protected VMs, the guest's timer offset state is private and must
> > not be controlled by the host. Protected VMs must always run with a
> > virtual counter offset of 0.
> >
> > The existing timer logic allowed the host to set and manage the timer
> > counter offsets (voffset and poffset) for protected VMs.
> >
> > This patch disables all host-side management of timer offsets for
> > protected VMs by adding checks in the relevant code paths.
>
> "This patch ..." is generally discouraged in changelogs, just state what
> you're doing in an imperative tone.

Ack.

> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/kvm/arch_timer.c | 18 +++++++++++++-----
> >  arch/arm64/kvm/sys_regs.c   |  6 ++++--
> >  2 files changed, 17 insertions(+), 7 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> > index 3f675875abea..69f5631ebf84 100644
> > --- a/arch/arm64/kvm/arch_timer.c
> > +++ b/arch/arm64/kvm/arch_timer.c
> > @@ -1056,10 +1056,14 @@ static void timer_context_init(struct kvm_vcpu *vcpu, int timerid)
> >
> >       ctxt->timer_id = timerid;
> >
> > -     if (timerid == TIMER_VTIMER)
> > -             ctxt->offset.vm_offset = &kvm->arch.timer_data.voffset;
> > -     else
> > -             ctxt->offset.vm_offset = &kvm->arch.timer_data.poffset;
> > +     if (!kvm_vm_is_protected(vcpu->kvm)) {
> > +             if (timerid == TIMER_VTIMER)
> > +                     ctxt->offset.vm_offset = &kvm->arch.timer_data.voffset;
> > +             else
> > +                     ctxt->offset.vm_offset = &kvm->arch.timer_data.poffset;
> > +     } else {
> > +             ctxt->offset.vm_offset = NULL;
> > +     }
> >
> >       hrtimer_setup(&ctxt->hrtimer, kvm_hrtimer_expire, CLOCK_MONOTONIC, HRTIMER_MODE_ABS_HARD);
> >
> > @@ -1083,7 +1087,8 @@ void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
> >               timer_context_init(vcpu, i);
> >
> >       /* Synchronize offsets across timers of a VM if not already provided */
> > -     if (!test_bit(KVM_ARCH_FLAG_VM_COUNTER_OFFSET, &vcpu->kvm->arch.flags)) {
> > +     if (!vcpu_is_protected(vcpu) &&
> > +         !test_bit(KVM_ARCH_FLAG_VM_COUNTER_OFFSET, &vcpu->kvm->arch.flags)) {
> >               timer_set_offset(vcpu_vtimer(vcpu), kvm_phys_timer_read());
> >               timer_set_offset(vcpu_ptimer(vcpu), 0);
> >       }
> > @@ -1687,6 +1692,9 @@ int kvm_vm_ioctl_set_counter_offset(struct kvm *kvm,
> >       if (offset->reserved)
> >               return -EINVAL;
> >
> > +     if (kvm_vm_is_protected(kvm))
> > +             return -EBUSY;
> > +
>
> This should be -EINVAL as pVMs do not even advertise the capability.
>
> Since we already have a generic helper for filtering KVM_CAPs, I'd
> prefer that we have a similar thing for enforcing ioctl limitations too.
>
> For example, you could maintain the ioctl => KVM_CAP mapping in a table
> and use kvm_pvm_ext_allowed() as the source of truth.

Yes, it makes more sense to consolidate these checks. Will do this
when I respin.

> >       mutex_lock(&kvm->lock);
> >
> >       if (!kvm_trylock_all_vcpus(kvm)) {
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index e67eb39ddc11..3329a8f03436 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -1606,11 +1606,13 @@ static int arch_timer_set_user(struct kvm_vcpu *vcpu,
> >               val &= ~ARCH_TIMER_CTRL_IT_STAT;
> >               break;
> >       case SYS_CNTVCT_EL0:
> > -             if (!test_bit(KVM_ARCH_FLAG_VM_COUNTER_OFFSET, &vcpu->kvm->arch.flags))
> > +             if (!vcpu_is_protected(vcpu) &&
> > +                 !test_bit(KVM_ARCH_FLAG_VM_COUNTER_OFFSET, &vcpu->kvm->arch.flags))
> >                       timer_set_offset(vcpu_vtimer(vcpu), kvm_phys_timer_read() - val);
> >               return 0;
> >       case SYS_CNTPCT_EL0:
> > -             if (!test_bit(KVM_ARCH_FLAG_VM_COUNTER_OFFSET, &vcpu->kvm->arch.flags))
> > +             if (!vcpu_is_protected(vcpu) &&
> > +                 !test_bit(KVM_ARCH_FLAG_VM_COUNTER_OFFSET, &vcpu->kvm->arch.flags))
> >                       timer_set_offset(vcpu_ptimer(vcpu), kvm_phys_timer_read() - val);
>
> Isn't there a general expectation that userspace not have access to the
> vCPU state of a pVM? That should be the mechanism of enforcement instead
> of special-casing these registers.

I thought I had a good reason for these checks, but now I cannot
remember what it was, nor can I see that there is a good reason, since
like you said, they are not accessible.

I'll remove them,

Cheers,
/fuad

> Thanks,
> Oliver
