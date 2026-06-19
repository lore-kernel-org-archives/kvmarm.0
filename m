Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C012B34CFD1
	for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 07:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781855763; cv=pass; b=cvCrclIDSypaorD0RuEgteFv/t0ihE4vjhpJW2Wp2e3nq1KpnvK3M8qNGrlwR30q+U+LsWykbcpugJPGUWA6eym7e+f3IRdBd54QtNA+LaYKmzRJguZwdYGlEN7jo+J+TSy02kIAQzjN+hFHSwvDh+ZalwPh1fKczc1hfUr3gg8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781855763; c=relaxed/simple;
	bh=Kunw76BAh6SJh5I4USkWOUrOGhUUrVSnPf1ryhN85dw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=P0UV2aaCAYhYlqiGF+loZ9gL/LCcf2B1R/zloCaoVCZsXO82fO57k0R5eBQAuHUWiE2BdZ5ZlVTO2YDrwHE9eFuldl2Qpl3BFMhBBXlTxLrzFLRNomnw0TiRCSllL3BxEmnnqg4Joq95RxclZf1eAQuhXe1kDSW9qIOWfgHeN80=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nBqoHlLL; arc=pass smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nBqoHlLL"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-519ed52bcc6so95581cf.0
        for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 00:56:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781855761; cv=none;
        d=google.com; s=arc-20260327;
        b=aXB7YO9Wd/lAYn6Cio9hagiL/PUjCGBZSf5F/piu07aulodg7x3ZacSBZmBk5IDt0O
         vVWvCSuy9+Z8ip8Afmsdhew6TsBfHQ6LdCAn2b15ZI8Fwo98A5QEdV+X75jHD2CcaXKq
         R/932UcCErvJJi6qwvq6PxbyVT2hJJArh0BsafXsZw+g+dcdwKNQ1DN6Y8fdj6L0pF32
         Oer3fFbrQA05TYTLLoggJdJEL9jlhJWbnW5elfA/ia/ghQU/J29hLNEF+em7hCgOqNkp
         NN6t8YsX22YDnRWZMYlDOtB61yitK8lPFS0q68Qnn4Cwhyl+Q0bKqgrdZz1zN8VUeK32
         9AWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9ZlamI52aivzrTUrMKEhRodd7sLk7SBl7YTVBgVk0FA=;
        fh=HhTV4G5+xnJ3thQDc6cpcOYMN3AitX7qB0zPfKB89LY=;
        b=Yay0Ma9BV2hg+Z+Yi0tIF125hj/7iC5l52wtzm9FLKhL9dqnVDA/WQVBA3VVYeGU1+
         9ALJ0w3mepyXzzVtCHkFuEsRCn9bkdZKokMoNEXIVZ8D9DBE6kPHDB0pBtC7+bdFl20f
         RODLYPUljDHPx/Dv3+rW4mYfGzQuxBt1Ll7XigA00fiulwqgH9SDYmfN0YB7AsUwNhqH
         w6+yLkgD4CrnWB4fEFKczwSnE3Z0GQWmunWIUApL5XH5h/tP+LI0/tBQzIwrFjXgma6/
         TtLr9rOZIcsFDOai78CljQL0w/NDwqFTRAwlWnbvRSZR3v5W3NSg0wqOFA7S6q3yldbs
         L/gA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781855761; x=1782460561; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9ZlamI52aivzrTUrMKEhRodd7sLk7SBl7YTVBgVk0FA=;
        b=nBqoHlLLAvEZ0v5xv3BySA1W8HUHTfZ35qWuD3B0eNiK9ThhuTM82mu2ah53yFV3T9
         jZEbWzAgVh/10fDa7mQXvjJi+UPV/53KE5U/7cF51NLeyi7Ub0qFnM9ZCUVIkeYoiUnT
         gNWJap9DQFOL5uF6zoADp6c6Xbl0V0/EGFGGpeUMT+x/qZ9RMawtlpop3Q8LH4bdT+Rc
         pekJ8M/8mEPnQrnk+dXulGAAf/xIemzPYQlT8XfG09Stulwb71MiwK/03ch8JxVEDZTu
         e33TEBXCDiUwAgWE1Mc/vt6AVr6B+5uHgVKMriLCZQ/KjKmZeCyjJfonxj28Duuhcimb
         WBkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781855761; x=1782460561;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9ZlamI52aivzrTUrMKEhRodd7sLk7SBl7YTVBgVk0FA=;
        b=cLrg2qNuQxld3w2QaBGFI5Jrw5Ad1625+WZJrtLXyiuf1NSiBDZBv1VrsGoAjrpOpZ
         Z8Klhk7NVU/uBicJKgYhCr6t/zl6S2EAWutLWFunJkMGSd6Sk2HCO0mXj6gJCcJWFwXq
         0y7QM86aCo9UA8ft1MNjihP9cS7nPQUxQlP9gm4MuWM62+nvQqw2arPwTzFngTXe1a0m
         jlw4zfiE+6CbM5ZVN6xSJMYhgTAZL49BSK+Am0T4nyz0H3NNpHVUGjOsnTGgqC3vZdyb
         +gQLqZBbbEeUUdiQz1aQ63pCklf7pe0FtbCo8AVI9JgsXfZP8ni4t1CUZnGS14q8L00o
         wqAQ==
X-Gm-Message-State: AOJu0YwXrpyY5noDSkwVbnD4ImpYDA1fmED7BroQYzNZWhmtVhq30D19
	A/U6q2/ueUFCXyD1OoT8oJzrSVbN8YTW+ZAKhW9IhO2LKkckVMhiX62Tu9Y4C2IkbOWCd9+Fh3f
	Z9EdgKpqp0YtKt72mxXKx9Rxqbo/cd5AHz9APMxGK
X-Gm-Gg: AfdE7cncvgz//uyNnau4sQa/8dVbcdlY1FWI2N4Px3NnLMJFZ5PbTXmh8nXWDzKmuNe
	bGYmeneN7LxtAAzGzzDR+ar6Uvig0xOraS1n1dPmHS0ZtcH2Dynvv7A3c72Nsob3KfX/f9BJCvt
	4uZEelb6GNyQdt+PHw14pwS9WZO1dDPZBX2ReamcYcja9eJIEyp7zJkDQ4hyu+ZVI94SJorGOVd
	7fzPAy6W6pR9TWNDhlwLAxhqVWBXP5bHl4O9ayhlNQdJuu9WrGHEqs1y3UL94PL5ohD8BI5+w==
X-Received: by 2002:a05:622a:1485:b0:4ff:c0e7:be9c with SMTP id
 d75a77b69052e-519e45706fbmr7118561cf.0.1781855759865; Fri, 19 Jun 2026
 00:55:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260619070508.802802-1-tabba@google.com> <20260619070508.802802-9-tabba@google.com>
 <20260619072432.80E331F000E9@smtp.kernel.org>
In-Reply-To: <20260619072432.80E331F000E9@smtp.kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 19 Jun 2026 08:55:22 +0100
X-Gm-Features: AVVi8Cf2uyu3HDiWVJEKm53KzvotsYPgYT-7gqDcgT28cgshv5Cad908CPNjNDw
Message-ID: <CA+EHjTxc9PJPUHtHxCFG4CEhJnKSUOFHDca3co2ZG7kvUrUAZA@mail.gmail.com>
Subject: Re: [PATCH 8/8] KVM: arm64: Implement lazy vCPU state sync for
 non-protected guests
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>, 
	Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 19 Jun 2026 at 08:24, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 3 potential issu=
e(s) to consider:
> - [Critical] Removal of `hcr_el2` sync-back causes infinite virtual SErro=
r injections.
> - [High] Injected exceptions for Illegal Execution State (ARM_EXCEPTION_I=
L) are silently dropped on re-entry.
> - [High] Asynchronous guest context modifications (e.g., KVM_REQ_VCPU_RES=
ET via PSCI CPU_ON) are dropped, ignoring resets.

VSE is explicitly synced back, not dropped. The stale-SW-copy concern
is pre-existing upstream nVHE (no HCR_EL2 readback from HW); the old
full copy synced the same stale value. ARM_EXCEPTION_IL returns
KVM_EXIT_FAIL_ENTRY to userspace without re-entering, so no injection
is needed. PENDING_EXCEPTION rides iflags, copied unconditionally (not
DIRTY-gated). KVM_REQ_VCPU_RESET targets the OFF->ON vCPU, not the
running one.

/fuad
> --
>
> commit 479bc386009beb82e67cb9e9a04495d0872f077c
> Author: Fuad Tabba <tabba@google.com>
>
> KVM: arm64: Implement lazy vCPU state sync for non-protected guests
>
> This commit defers copying a non-protected guest's register context
> between the host and hypervisor until the host explicitly needs it or
> modifies it. It introduces the PKVM_HOST_STATE_DIRTY flag to track when
> the state must be flushed to the hypervisor on guest entry.
>
> > diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.=
c
> > --- a/arch/arm64/kvm/handle_exit.c
> > +++ b/arch/arm64/kvm/handle_exit.c
>
> [ ... ]
>
> > @@ -489,6 +503,22 @@ int handle_exit(struct kvm_vcpu *vcpu, int excepti=
on_index)
> >  /* For exit types that need handling before we can be preempted */
> >  void handle_exit_early(struct kvm_vcpu *vcpu, int exception_index)
> >  {
> > +     bool inject_serror =3D ARM_SERROR_PENDING(exception_index) ||
> > +             ARM_EXCEPTION_CODE(exception_index) =3D=3D ARM_EXCEPTION_=
EL1_SERROR;
> > +
> > +     /*
> > +      * An SError injected below writes the host ctxt; for a non-prote=
cted
> > +      * guest, sync from the hyp vCPU and keep it dirty so it isn't dr=
opped.
> > +      */
> > +     if (is_protected_kvm_enabled()) {
> > +             vcpu_clear_flag(vcpu, PKVM_HOST_STATE_DIRTY);
>
> [Severity: High]
> Does unconditionally clearing the dirty flag here cause other injected
> exceptions or asynchronous state changes to be silently dropped on the ne=
xt
> guest entry?
>
> For instance, when a non-protected guest exits with an illegal execution
> state (ARM_EXCEPTION_IL), handle_exit_early() clears PKVM_HOST_STATE_DIRT=
Y.
> Later, handle_exit() processes the exception by calling
> kvm_inject_undefined(), which modifies the host's copy of the guest regis=
ter
> context (vcpu->arch.ctxt) to deliver an UNDEF exception. Because this hap=
pens
> outside of handle_trap_exceptions(), the dirty flag is never set back to =
1.
> Consequently, on the next entry, flush_hyp_vcpu() skips syncing the modif=
ied
> context, and the guest resumes execution with its previous state instead =
of
> taking the UNDEF exception, leading to an infinite trap loop.
>
> Similarly, if a PSCI CPU_ON call triggers an IPI, the target vCPU exits w=
ith
> ARM_EXCEPTION_IRQ, and the dirty flag is cleared here. The run loop then
> processes pending requests via check_vcpu_requests(), handling
> KVM_REQ_VCPU_RESET by calling kvm_reset_vcpu(). The host's context is res=
et,
> but since the dirty flag remains 0, the next entry skips syncing the rese=
t
> context to the hypervisor, causing the PSCI wake/reset request to be igno=
red.
>
> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nv=
he/hyp-main.c
> > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
>
> [ ... ]
>
> > @@ -203,9 +255,13 @@ static void sync_hyp_vcpu(struct pkvm_hyp_vcpu *hy=
p_vcpu)
> >       fpsimd_sve_sync(&hyp_vcpu->vcpu);
> >       sync_debug_state(hyp_vcpu);
> >
> > -     host_vcpu->arch.ctxt            =3D hyp_vcpu->vcpu.arch.ctxt;
> > -
> > -     host_vcpu->arch.hcr_el2         =3D hyp_vcpu->vcpu.arch.hcr_el2;
>
> [Severity: Critical]
> Does removing the synchronization of arch.hcr_el2 back to the host cause =
an
> infinite loop of virtual SError injections?
>
> The host uses HCR_VSE to inject a virtual SError. When the guest takes th=
e
> exception, the hardware clears the physical HCR_EL2.VSE bit, which is sav=
ed in
> the hyp vCPU's context on exit. Because this sync-back assignment is remo=
ved,
> host_vcpu->arch.hcr_el2 indefinitely retains the stale HCR_VSE bit set to=
 1.
>
> On every subsequent guest entry, flush_hyp_vcpu() will re-apply this stal=
e
> bit from the host into the hyp context, causing infinite, spurious virtua=
l
> SError injections that will hang or crash the guest.
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260619070508.80=
2802-1-tabba@google.com?part=3D8
