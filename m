Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F117735201B
	for <kvmarm@lists.linux.dev>; Mon, 22 Jun 2026 08:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782118196; cv=none; b=uac+tnndtjEDetrujVAdpFIxXnxucnAMQdPD9DSc7qbiuVyKhQcXVOVEIhnYZLmVMOiWQS1hhWHDgHh8OYIIq6vchc3AjSec+BMqsLhm8HzD0HO3TwZWotr33IK4Nwcv+TjSXFeQDJF2ma4ShuP+s9kqkea/9Z0OJez2SQjy4o8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782118196; c=relaxed/simple;
	bh=v6b9tIPottpOhVi5BOdy+hR4NQy2BK0lyl88HmGRHug=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TQQU0JplPP39iEEm3kJrf+kiay7nxVGC4TkkVXuRM3beJng9DuGcCug9r8+jYKJK1MyseQuEEiIuZkemWR08ZNe1zl3HfFb4FGePMvLfKCcB7sIk15kJnp3irS4ftIgvD2DvsDluujynbQwFBnuS5Kr4DdC9qq8dKd4OBFi6XwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tW5+XRjr; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tW5+XRjr"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-490cf322ed0so31457615e9.1
        for <kvmarm@lists.linux.dev>; Mon, 22 Jun 2026 01:49:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782118193; x=1782722993; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=G4aLRA0sObdyQwkUt9lWTZbbvG2GGrfM8jRkE/wqXXI=;
        b=tW5+XRjrKt+ZomRbWKvCSdbpEpf6UvYUxbWHiMyAE9eZWL75fi7JZd7z/nt0l20Yzj
         VQWS0jVlcehPMayGj9ZU07SWUhKVWZP63N+JXEeN34NBWRS2BcCI2sTfmVBWgrbG4MwH
         JBrqB6k6FnY2IRlcpLQyvYxG8MYN+FsGGJMY72rnKxvGF0p1S8/TEg5DDgAoSK1FilGM
         CH6+voztTAJYh4uw6wSVFffO/uvZYnFeYtt2vZUDQNv+5cktd31sqECKL5p8D9qk2of7
         pukFfCBGbzeupepi61m+Ney0pesRTo+SWkoUJ7x1nR7loXl4zLzaKxTTxfC2DocFmSE4
         lKRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782118193; x=1782722993;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G4aLRA0sObdyQwkUt9lWTZbbvG2GGrfM8jRkE/wqXXI=;
        b=kZg5RqvYc+jZpXUYZsBXq8wxZZ6UEtgN2tu86UvVX+Su1wvDJaF8ImT8/i5IUxKIsA
         G1Ha60RehBcyKjRXE1m+xpKDjR8iFnjnPHtZr/9ZveMIVPQTpqmHgf/SWQpitN42QrKN
         nznDhCpEXlMufX4BYvVniHxsgHwM2TkCNyK2W4UXTCP9prZmRIpOIgUZdp+D5kSuQBCy
         oth8Dm6kK4tcFsOanYupp3bWP5JP4msRS882Lea364ZtQr87O/751ydzxxwfiMIFAA+j
         TgSg0L24xfQw8Kb/t0xXGGMyc9qroE0/RCw9A5LER6v5Kdglh1C4xPyT1kLvJG0J+QuB
         xYlA==
X-Forwarded-Encrypted: i=1; AFNElJ/7oDBQ8R2oOA33Bkx2uMmSMdmgpVnWoNvmGYkeH9tWjVhQ+T435LbEY2FZtp3Scpd1VGgO5Io=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw/8SsNEYMmCqwQ0qQwj14MsupNQsCHkeFKlx3HUYl9w/zOXtao
	+4/gnufCt1cuK9FPZhycST1tePsk5WpFCYLP1C/AX4tOhxdAq4dse8h9Vcdk/Sz3Ow==
X-Gm-Gg: AfdE7clywwvWK2acV3sydJBWWye7gGYLAFa6tF38FTRRrl9sk9nUyClp/FoPW07Yl96
	03ib9sOC+jb1y0RO6la/L1ub8ugbLoksEK7iDfWVSk4XnP/ZlpCv+tMIOnbvn0/oKZ976lWqQDn
	06tn5uZt2tdXQd450oZrGEE3PjJf7gfgG+bnue0ma8bIiafHxKr2PmI5nvsEwhr4Ykj3/1x+k8z
	DBenL8BiEO8N5yH4KwveB08iZDGj/exjey+0Ac1kHLbmrBbThN1jFfWn35S7jv4IZlR2wk4hKMF
	z4xmEwaKXVj/7vtsCX8QXe/YrVOgYqkf0w++uNSuEbzcG2PmyKpNhU3AjlkCymzOWYRSifktpfl
	OkelsIw0j0cRzmCY2nxDbkFkOvISnn+Ik33+6T/coGOqP+trsUs6G8Pb3+PLXwwbPVpuZHCMgYM
	nIl3eZTYzX0WzX7wVNbT/rTkPtwG72WPQ/1ezqgXRjPrSaGM9LRN3p6MDm
X-Received: by 2002:a05:600c:19c8:b0:492:4cc7:de73 with SMTP id 5b1f17b1804b1-4924cc7df3dmr124550365e9.31.1782118192788;
        Mon, 22 Jun 2026 01:49:52 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-492492338dasm195354755e9.1.2026.06.22.01.49.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2026 01:49:51 -0700 (PDT)
Date: Mon, 22 Jun 2026 09:49:47 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Quentin Perret <qperret@google.com>,
	Sebastian Ene <sebastianene@google.com>,
	Hyunwoo Kim <imv4bel@gmail.com>
Subject: Re: [PATCH v2 8/8] KVM: arm64: Implement lazy vCPU state sync for
 non-protected guests
Message-ID: <ajj3KzUrZZ1-2UQZ@google.com>
References: <20260619070719.812227-1-tabba@google.com>
 <20260619070719.812227-9-tabba@google.com>
 <ajVAV5ct0xdLn1KX@google.com>
 <CA+EHjTz13obYHAZYCW+zpH1RB953FseP9koXydeoLqmn6UONHQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTz13obYHAZYCW+zpH1RB953FseP9koXydeoLqmn6UONHQ@mail.gmail.com>

[...]

> > > diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> > > index 54aedf93c78b..8963621bcdd1 100644
> > > --- a/arch/arm64/kvm/handle_exit.c
> > > +++ b/arch/arm64/kvm/handle_exit.c
> > > @@ -422,6 +422,20 @@ static int handle_trap_exceptions(struct kvm_vcpu *vcpu)
> > >  {
> > >       int handled;
> > >
> > > +     /*
> > > +      * If we run a non-protected VM when protection is enabled
> > > +      * system-wide, resync the state from the hypervisor and mark
> > > +      * it as dirty on the host side if it wasn't dirty already
> > > +      * (which could happen if preemption has taken place).
> > > +      */
> > > +     if (is_protected_kvm_enabled() && !kvm_vm_is_protected(vcpu->kvm)) {
> > > +             guard(preempt)();
> > > +             if (!(vcpu_get_flag(vcpu, PKVM_HOST_STATE_DIRTY))) {
> > > +                     kvm_call_hyp_nvhe(__pkvm_vcpu_sync_state);
> > > +                     vcpu_set_flag(vcpu, PKVM_HOST_STATE_DIRTY);
> > > +             }
> > > +     }
> > > +
> >
> > Could we remove this update here and let handle_exit_early() do the sync
> > regardless of the SError injection? One of the main point of handle_exit_early()
> > is to do things under !prempt().
> 
> Agreed on the move: handle_exit_early() is already preempt-off, so the
> guard() goes away. Not on every exit though. handle_exit_early() runs
> on every exit, and sync_hyp_vcpu() only copies PC/PSTATE/fault back
> for a non-protected guest; the GPRs and sysregs cross solely via
> __pkvm_vcpu_sync_state. Syncing unconditionally would pull the full
> context back on plain IRQ exits, which is the copy this patch avoids.
> So I will gate it on trap-or-SError and drop the
> handle_trap_exceptions() block.
> 
> >
> >
> > >       /*
> > >        * See ARM ARM B1.14.1: "Hyp traps on instructions
> > >        * that fail their condition code check"
> > > @@ -489,6 +503,22 @@ int handle_exit(struct kvm_vcpu *vcpu, int exception_index)
> > >  /* For exit types that need handling before we can be preempted */
> > >  void handle_exit_early(struct kvm_vcpu *vcpu, int exception_index)
> > >  {
> > > +     bool inject_serror = ARM_SERROR_PENDING(exception_index) ||
> > > +             ARM_EXCEPTION_CODE(exception_index) == ARM_EXCEPTION_EL1_SERROR;
> > > +
> > > +     /*
> > > +      * An SError injected below writes the host ctxt; for a non-protected
> > > +      * guest, sync from the hyp vCPU and keep it dirty so it isn't dropped.
> > > +      */
> > > +     if (is_protected_kvm_enabled()) {
> >
> > Should we test !kvm_vm_is_protected(vcpu->kvm) here, as the
> > PKVM_HOST_STATE_DIRTY is only updated for p-guests everywhere else?
> 
> Yes. The flag is only ever set for non-protected guests, so clearing it
> for a protected one is a no-op, but gating it matches the invariant.
> 
> Both fold into one block in handle_exit_early():
> 
>       if (is_protected_kvm_enabled() && !kvm_vm_is_protected(vcpu->kvm)) {
>               if (inject_serror ||
>                   ARM_EXCEPTION_CODE(exception_index) == ARM_EXCEPTION_TRAP) {
>                       kvm_call_hyp_nvhe(__pkvm_vcpu_sync_state);
>                       vcpu_set_flag(vcpu, PKVM_HOST_STATE_DIRTY);
>               } else {
>                       vcpu_clear_flag(vcpu, PKVM_HOST_STATE_DIRTY);
>               }
>       }
> 
> I will fold this into the next respin.

Ah yes of course, I was hoping we could just have a switch here, just like
handle_exit() does, but that's not possible because of ARM_SERROR_PENDING().

Perhaps it would look cleaner if done in a separate function
handle_exit_pkvm_state()?


> 
> Thanks for the reviews!
> /fuad
> 
> >
> > > +             vcpu_clear_flag(vcpu, PKVM_HOST_STATE_DIRTY);
> > > +
> > > +             if (inject_serror && !kvm_vm_is_protected(vcpu->kvm)) {
> > > +                     kvm_call_hyp_nvhe(__pkvm_vcpu_sync_state);
> > > +                     vcpu_set_flag(vcpu, PKVM_HOST_STATE_DIRTY);
> > > +             }
> > > +     }
> > > +
> > >       if (ARM_SERROR_PENDING(exception_index)) {
> > >               if (this_cpu_has_cap(ARM64_HAS_RAS_EXTN)) {
> > >                       u64 disr = kvm_vcpu_get_disr(vcpu);
> >
> > [...]
