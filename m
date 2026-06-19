Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E76E3C0630
	for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 16:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781887333; cv=pass; b=PWYnJgdG0WjY+9twqv7trqPCMjRc5kDe573RcSueLlKVoGiVvu6Pha0lBzfYdTbpI2SuS0VigqcvOP1VqOyu2OzY3HIaRLet1xasCKNtstCpcI3BiWFxRH68UMgx3FY+IkJp4vNRFtk0titdkAF2S1GkfMdtBRlLLEdHbkc7O3M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781887333; c=relaxed/simple;
	bh=IBe5K4iK5H0tQRScCC/J2+7c4L8uaJK/mw2FCOVyCYM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=imek/eSMTyiDFShdMAZJzMW9jPpSEhfdnts2k6C1uGWXU9+YU9DmbN16Ke/lLsAb5wp/gUd0PRCW+t7muBN0E9yakjsv9QuyQnofzowol+wJ3NPW9P7Zsz0AbR3ambBAxTYdQE1aZtbA/U6cZRXIVaIr2OWZ9FjrSZKXLPcgOFA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AwoDGBAY; arc=pass smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AwoDGBAY"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-5177d1ff061so230061cf.1
        for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 09:42:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781887331; cv=none;
        d=google.com; s=arc-20260327;
        b=HYaDf0xIE+sWEj5VFFiYBzS/Qbe4MkXToWg0xCZ2OQpX0T24SSsX18PE/I34nlYbfm
         cPz5BlB/Q02f0u6YHv67p56LZRF5haKPcxXhlHMXZ42X9KC6tkArkpQdrRuaSuPKVU9s
         fT9RdWNpyMUaKCDyaUaT0R5g1lIYGZIH7GxaBhM2GO5KE25LwOc/l/RZ1bJkq0eB14Pc
         lUziy5C4hrZ/nXd05vV/1KpU6mAzyHZHf+jfGft3mG+TE7IYrXQgl3NV8/6CRcq8ZLQD
         LB4xwhTZ6MFxrlbz9uG0ky0Cu2TSG0ofkvOvpFdgQk6RSN8n0XIweDFK2ziCHT4E1AQU
         VLvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=W9jXSUCXwLqMfz03x3rWaIwLOnreZZae42JwqWFDgZo=;
        fh=SeMYglspTK4T2mrAUlRZUtYqORni63n/Av3A463IAZ8=;
        b=eAjoOZsud7yc+wcVmRK90OutVIvLPJEF0YK2ZJCDNRJKetFYY8KXptFZlerQE5O352
         X3fzVTpcMdJQr0bCrSG1UvvT/hlasKBvPBr9EFmR/qjJSsf/PJ1dXIRo8hkZ+zGkcfhi
         7Lp+Rd66Hm/c7zeYMq3te1FMJejRc08K+GQcMjePVuvXhBzA1+SWql6kNi/s0eqI2Vfa
         ScBP16b2SjYaoAWWSm/7Uo5Mi4vx5fnqKL9Sbsf/JkuniHf265Nrab8O1iohi6Z3HUZE
         OAyQM1mM6+phssU5+1j4OUxqAKblGfgfX5p+plODeVGL0zNb1pM2Kb/IwMkZHx9xLVHa
         mi9g==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781887331; x=1782492131; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=W9jXSUCXwLqMfz03x3rWaIwLOnreZZae42JwqWFDgZo=;
        b=AwoDGBAY8x+WXYRYFR1swRWmnwJ7TSY4TzBOrc0n0bEpKcQdqvEwYZzEc0oQFlTfbF
         GW3HUhhOtHLcuyV/lG1OOTyIFBKpyuC5/f7OsAuYvZWVg7EaykEJyoLs6GWDsnABC4eQ
         709xf/McGLCTvXvrbywFxeahwRMwKTgy8S5yF9W//YbO0q7ib7lONtkfKK3Klk/PQJQT
         BuuHG5g+Ap8hRr3KQMXgaCNyIM1Ql6DCIqeU7DKbO7/j+d8nWTIve213JUZBI3ClNiLh
         HAViIxPxpkEyy/eELLZxPcZlsPRVE7yelq2gjfy2WIL1MjZT9AjzbhVTwOrdyTTfBNTM
         dyMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781887331; x=1782492131;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=W9jXSUCXwLqMfz03x3rWaIwLOnreZZae42JwqWFDgZo=;
        b=fteA1kpESa7qYyO7QUmBe6goWEWtDAM/Vh18CN5/AiCb8bl97GRphXEy8PFnuPZdFP
         Rc+UPJwPArZawPadTWSagwoJmWQe4H/EG8J3LpSLgqGDqyO4KpJLyC9y2zbSYnDGEcYh
         1XrzUaZtYvf7V8XyOuNRbKlLPRrLc38CNIauoFQQJYJHecnazDiyHGUqrvt7AOwFR0fa
         /JCABoe5/co/Dl4jeKFvYbwG2ly3Uhw4Kf5X5SJ3UjdntxLW5tqqWmYzym5MU1RceSqw
         R9cAsBuJRIBwkVrEaX/5rPA9n9TD46MJNtGL0iMFeh1zd9w1p52J+1CBCD+v/0/3U4jO
         5sbQ==
X-Forwarded-Encrypted: i=1; AFNElJ9ffjeq02lgTJSDo1+rCKBwee5frAbGwxkUPs4iPthBoLFv0kp8eFeINq/yX+l18YpUXzZ/6vA=@lists.linux.dev
X-Gm-Message-State: AOJu0YzcJi0iGq1rAkYNE2ejxmsb+QjzkhhyTI45Gfj5WZlZxRbArcop
	XxOrcSt4sGmXwegqrT46Ud70qeBrF1H5W9hCHL9KfFvbC9fk7Jnaxo6s+9XfUPxQFfBZ+GAyKYi
	466TDOauU7321u0cKqO6+q6MeKPHZ3pUTtno0RIvX
X-Gm-Gg: AfdE7cnfsiGZ7jIRY09f+wVuCoA0p7gJ8DaqFRrg1mP9LM6sybNM94fBXUUkurZzp99
	lEFtRinqlJ2MeXqd63cQvhZfI6AtM4DpcSba7J/JOItscBa8AiUySQtvwQpJ9IYRtceasW876m5
	HStYNeoNk/88pj8EGQa3Sl/U6KIs4UJ2tyoD030TiNz1shJE05th1fvRGFnC6NzN0XViHnFKfYg
	G0DLqI0Z9nFlvn+uoSHArRkM5+ju50Vekq2SUJNaEQR6dgc0kP/x1Qa9Flu2TJjni4gcWwMLA==
X-Received: by 2002:a05:622a:2489:b0:519:56a8:2693 with SMTP id
 d75a77b69052e-519e4a7350amr9673821cf.24.1781887330415; Fri, 19 Jun 2026
 09:42:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260619070719.812227-1-tabba@google.com> <20260619070719.812227-9-tabba@google.com>
 <ajVAV5ct0xdLn1KX@google.com>
In-Reply-To: <ajVAV5ct0xdLn1KX@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 19 Jun 2026 17:41:00 +0100
X-Gm-Features: AVVi8CeugYeoJkxJ2s1vDW8ayydzdG5A6SaipfjAzjFSd_ia6mU672oeVjPkVZw
Message-ID: <CA+EHjTz13obYHAZYCW+zpH1RB953FseP9koXydeoLqmn6UONHQ@mail.gmail.com>
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

On Fri, 19 Jun 2026 at 14:13, Vincent Donnefort <vdonnefort@google.com> wrote:
>
> On Fri, Jun 19, 2026 at 08:07:19AM +0100, Fuad Tabba wrote:
> > pKVM copies a non-protected guest's register context between the host
> > and the hypervisor on every world switch, even when the host never
> > inspects it. Defer the copy: on entry, flush the host context into the
> > hyp vCPU only when the host marked it dirty (PKVM_HOST_STATE_DIRTY); on
> > exit, leave it in the hyp vCPU and copy it back only when the host needs
> > it, via a __pkvm_vcpu_sync_state hypercall on trap handling or at vcpu
> > put. A protected guest's context is copied as before, since lazy sync
> > only helps where the host is trusted to see the guest's registers.
> >
> > PC and PSTATE are the exception: they are copied back on every exit so
> > the kvm_exit tracepoint reports the guest's real exit PC, and the run
> > loop's vcpu_mode_is_bad_32bit() and SError-masking checks evaluate the
> > guest's current PSTATE rather than the value left by the previous sync.
> >
> > handle_exit_early() can also inject an SError, which writes the guest
> > context (ESR_EL1) outside the trap-handling path. For a non-protected
> > guest it therefore syncs the context from the hyp vCPU and marks it
> > dirty, as handle_trap_exceptions() does, so the injection reaches the
> > hyp vCPU on re-entry rather than being dropped.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_asm.h   |  1 +
> >  arch/arm64/include/asm/kvm_host.h  |  2 +
> >  arch/arm64/kvm/arm.c               |  7 +++
> >  arch/arm64/kvm/handle_exit.c       | 30 +++++++++++
> >  arch/arm64/kvm/hyp/nvhe/hyp-main.c | 86 ++++++++++++++++++++++++++++--
> >  5 files changed, 121 insertions(+), 5 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> > index 043495f7fc78..6e1135b3ded4 100644
> > --- a/arch/arm64/include/asm/kvm_asm.h
> > +++ b/arch/arm64/include/asm/kvm_asm.h
> > @@ -113,6 +113,7 @@ enum __kvm_host_smccc_func {
> >       __KVM_HOST_SMCCC_FUNC___pkvm_finalize_teardown_vm,
> >       __KVM_HOST_SMCCC_FUNC___pkvm_vcpu_load,
> >       __KVM_HOST_SMCCC_FUNC___pkvm_vcpu_put,
> > +     __KVM_HOST_SMCCC_FUNC___pkvm_vcpu_sync_state,
> >       __KVM_HOST_SMCCC_FUNC___pkvm_tlb_flush_vmid,
> >
> >       MARKER(__KVM_HOST_SMCCC_FUNC_MAX)
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 2faa60df847d..caa39ee5125f 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -1068,6 +1068,8 @@ struct kvm_vcpu_arch {
> >  #define INCREMENT_PC         __vcpu_single_flag(iflags, BIT(1))
> >  /* Target EL/MODE (not a single flag, but let's abuse the macro) */
> >  #define EXCEPT_MASK          __vcpu_single_flag(iflags, GENMASK(3, 1))
> > +/* Host-set: the hyp flushes the non-protected vCPU state in on entry */
> > +#define PKVM_HOST_STATE_DIRTY        __vcpu_single_flag(iflags, BIT(4))
> >
> >  /* Helpers to encode exceptions with minimum fuss */
> >  #define __EXCEPT_MASK_VAL    unpack_vcpu_flag(EXCEPT_MASK)
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 3732ee9eb0d4..4e89558d8027 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -733,6 +733,10 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
> >       if (is_protected_kvm_enabled()) {
> >               kvm_call_hyp(__vgic_v3_save_aprs, &vcpu->arch.vgic_cpu.vgic_v3);
> >               kvm_call_hyp_nvhe(__pkvm_vcpu_put);
> > +
> > +             /* __pkvm_vcpu_put implies a sync of the state */
> > +             if (!kvm_vm_is_protected(vcpu->kvm))
> > +                     vcpu_set_flag(vcpu, PKVM_HOST_STATE_DIRTY);
> >       }
> >
> >       kvm_vcpu_put_debug(vcpu);
> > @@ -964,6 +968,9 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
> >               return ret;
> >
> >       if (is_protected_kvm_enabled()) {
> > +             /* Start with the vcpu in a dirty state */
> > +             if (!kvm_vm_is_protected(vcpu->kvm))
> > +                     vcpu_set_flag(vcpu, PKVM_HOST_STATE_DIRTY);
> >               ret = pkvm_create_hyp_vm(kvm);
> >               if (ret)
> >                       return ret;
> > diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> > index 54aedf93c78b..8963621bcdd1 100644
> > --- a/arch/arm64/kvm/handle_exit.c
> > +++ b/arch/arm64/kvm/handle_exit.c
> > @@ -422,6 +422,20 @@ static int handle_trap_exceptions(struct kvm_vcpu *vcpu)
> >  {
> >       int handled;
> >
> > +     /*
> > +      * If we run a non-protected VM when protection is enabled
> > +      * system-wide, resync the state from the hypervisor and mark
> > +      * it as dirty on the host side if it wasn't dirty already
> > +      * (which could happen if preemption has taken place).
> > +      */
> > +     if (is_protected_kvm_enabled() && !kvm_vm_is_protected(vcpu->kvm)) {
> > +             guard(preempt)();
> > +             if (!(vcpu_get_flag(vcpu, PKVM_HOST_STATE_DIRTY))) {
> > +                     kvm_call_hyp_nvhe(__pkvm_vcpu_sync_state);
> > +                     vcpu_set_flag(vcpu, PKVM_HOST_STATE_DIRTY);
> > +             }
> > +     }
> > +
>
> Could we remove this update here and let handle_exit_early() do the sync
> regardless of the SError injection? One of the main point of handle_exit_early()
> is to do things under !prempt().

Agreed on the move: handle_exit_early() is already preempt-off, so the
guard() goes away. Not on every exit though. handle_exit_early() runs
on every exit, and sync_hyp_vcpu() only copies PC/PSTATE/fault back
for a non-protected guest; the GPRs and sysregs cross solely via
__pkvm_vcpu_sync_state. Syncing unconditionally would pull the full
context back on plain IRQ exits, which is the copy this patch avoids.
So I will gate it on trap-or-SError and drop the
handle_trap_exceptions() block.

>
>
> >       /*
> >        * See ARM ARM B1.14.1: "Hyp traps on instructions
> >        * that fail their condition code check"
> > @@ -489,6 +503,22 @@ int handle_exit(struct kvm_vcpu *vcpu, int exception_index)
> >  /* For exit types that need handling before we can be preempted */
> >  void handle_exit_early(struct kvm_vcpu *vcpu, int exception_index)
> >  {
> > +     bool inject_serror = ARM_SERROR_PENDING(exception_index) ||
> > +             ARM_EXCEPTION_CODE(exception_index) == ARM_EXCEPTION_EL1_SERROR;
> > +
> > +     /*
> > +      * An SError injected below writes the host ctxt; for a non-protected
> > +      * guest, sync from the hyp vCPU and keep it dirty so it isn't dropped.
> > +      */
> > +     if (is_protected_kvm_enabled()) {
>
> Should we test !kvm_vm_is_protected(vcpu->kvm) here, as the
> PKVM_HOST_STATE_DIRTY is only updated for p-guests everywhere else?

Yes. The flag is only ever set for non-protected guests, so clearing it
for a protected one is a no-op, but gating it matches the invariant.

Both fold into one block in handle_exit_early():

      if (is_protected_kvm_enabled() && !kvm_vm_is_protected(vcpu->kvm)) {
              if (inject_serror ||
                  ARM_EXCEPTION_CODE(exception_index) == ARM_EXCEPTION_TRAP) {
                      kvm_call_hyp_nvhe(__pkvm_vcpu_sync_state);
                      vcpu_set_flag(vcpu, PKVM_HOST_STATE_DIRTY);
              } else {
                      vcpu_clear_flag(vcpu, PKVM_HOST_STATE_DIRTY);
              }
      }

I will fold this into the next respin.

Thanks for the reviews!
/fuad

>
> > +             vcpu_clear_flag(vcpu, PKVM_HOST_STATE_DIRTY);
> > +
> > +             if (inject_serror && !kvm_vm_is_protected(vcpu->kvm)) {
> > +                     kvm_call_hyp_nvhe(__pkvm_vcpu_sync_state);
> > +                     vcpu_set_flag(vcpu, PKVM_HOST_STATE_DIRTY);
> > +             }
> > +     }
> > +
> >       if (ARM_SERROR_PENDING(exception_index)) {
> >               if (this_cpu_has_cap(ARM64_HAS_RAS_EXTN)) {
> >                       u64 disr = kvm_vcpu_get_disr(vcpu);
>
> [...]
