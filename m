Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 312722F8EB8
	for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 07:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781855725; cv=pass; b=WuLWBVr24viwJZei+5OozUjFqo2ZSdny+lD+s/k9r9WZIiou5r8xcWtNSHoYzc6kBent6ivbiJZwBatlQvLMyvOKlVt65hl0xNia628L4D77mbNnbla0SKXeM9Xo/8lgeU/Tkj3kbzWaWe5bmRaXgUIPV6MsGGLV/9+0VyazCSs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781855725; c=relaxed/simple;
	bh=zw+YX+HndypObcctYQspJPvJWIECKscJJbFi0hvVZm0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JtLEL6lfyp//Bw3dINtXP/5zViBIcZHkkW9wSwvrmuDyOyQsTUWQFMbys9u2uC/l35zDA54B6A7Y+wOnLs1rGBnlqyWl4+8ynNp1syeesA9w7QRVn7LwwWMJp8112kUDdAcyX9KpZHO3mBTMLTabw8FduAWq38lQFpO9OqDeVDg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=J6EeAY/w; arc=pass smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="J6EeAY/w"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-51765531803so190371cf.0
        for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 00:55:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781855723; cv=none;
        d=google.com; s=arc-20260327;
        b=dYHGyzPWji+lHCBkq76EiXlpnampDduFw/eW3lNuC32dMGE/6yhRcGGmtZTx2oIDQe
         nvZlfwasT8EbtGRyUai6Lzx18hGiqLqTepr+XTaah88/3P5ZH+7RfNFWuIjGEvNnK02B
         J4B0vKKMQxt8Q6hJwrVRKbHMjcDHm7gvWjjWCdCuJ89zLqZYVqcKlT4JiBvfHwJfZBfF
         qlHbxsnDth0bo+DC8iTa3Oxpan1z6OhdhWU+xBQkyDI6K3cZHLbZo6iZzt/ZAEmFJ93Q
         lVLSi7npF3fcAxq2HA/qNTipnvPOfNlQt8yHVE+jmVzxQUltGrGKaRymfghlWLVAbJ1u
         0UaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Hn0hdCkRxc2qT0F7X8GCIxe/SM8Yd4JR9cMFa/aCR4M=;
        fh=HhTV4G5+xnJ3thQDc6cpcOYMN3AitX7qB0zPfKB89LY=;
        b=FsXluUKh5aSuQ4kUxQa+qdCkvGRePDUHCjhvT0aq5I+WWYfBSeMshyRqBkTsrfsONf
         1mlqEKGq/A8xahLd3G3tw6nGN6R5xwef3LSIw6OhW/ozvf/6wGQaKtXiaTkUIsex/6ab
         zwYqOlvXcBRelQ+3gxt85AMvVxDDm6SnBguhFeZImazfLbeSzJITwlzOYNGKmyDOJNId
         +4cchWN4pMYTJd9WslobwEmkLYsoaCGdq0ZZC7GHEuLKh8jhbGa2cvB6UM9IOIk7t5LA
         BsZHaeOhMftGYVNttUFqnI6SHsMuZ2WqJSnN64GWlIJQzF0UAqK1uMg7T+2ASJBk4SaQ
         wzRw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781855723; x=1782460523; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Hn0hdCkRxc2qT0F7X8GCIxe/SM8Yd4JR9cMFa/aCR4M=;
        b=J6EeAY/wM4o3wqEvaf/OKekM6dT4JVwLvDIoCyOj0oPbhhTqcDJ/VR/1QhbUKVV8U3
         OtxfIPC3NAEvm3No0O340YgRpI53C1xxTbdd8aXGWb5TGlX7Mc5xH+uXOZopCHqNfv5k
         GQwEFAQOUauoCLI8bxCqCET5YgdxDOmHCa0n/maHz84foO3DQykPdpw0WuwuzD8RSXpL
         CQoBfXGC7+zGBdzF0N6H8/tg1PIMW743bwcWniW0cVdmzvfuHYMI/9MBQBoEfEaitrQ5
         qsHkJBsJ7Na9pNxuD9ATZT85WIoPPT+l3xUpUzEeGzxQesBnS+YysJsMt1xVr46SuSoN
         l3/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781855723; x=1782460523;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Hn0hdCkRxc2qT0F7X8GCIxe/SM8Yd4JR9cMFa/aCR4M=;
        b=k67DImOGt4ZK+LbdWtlFNNDMB10CETeKSn+USuxqC2pOitNEbc1KeR/3zhVUEWHXTK
         KA55BIxB8lz+hDE9gypeP8Z06GC8kYH4QA+ZNXLdnETgA1nx7XUZHYRGwTqT1+VgHFsg
         YMgEKMFxr2xu9g6k0w+ujYs/SJxVKy83xDOE326NGfocdbhfiroxfBlTuihsSP/8sXpA
         l/FpjBdI2RItJfHgjN1eAYVm8ZgeY/X9Uua37MFey6BctQeGHVXxfB+CSHVY287qpXoI
         yF7InvflDLB/+FbrwjmRySpS16AF5pmsYHNei9hFEolZ8mDr7BVytHkkIYuFmYAvrlBH
         ZLDg==
X-Gm-Message-State: AOJu0Yy+j3QgwpKbglG8iXnXSqzBUzgh1LY7nqveTDXYAOWAbPbYzVff
	viAVT5+pnsESqWxJBU7ZP5X1JgguPi5TjonLbOBQrV5fFeFN5zaAFYj3fxs+eGf+kM2XVjwSDID
	WmDneg6t2ykbMB4IGk95HlaXcetxg0iRhflFg2VAL
X-Gm-Gg: AfdE7cmIbA1gdKi/xNnW1IXJK3wVZrkEA2oK/6EmeaAjB/keMuYOVpecPyk+h9YsVXT
	SE76CQQW7cNFRQaXMM+C741VNTlvSXxatiJHriVLFRCoJ3/iIr+opulKRu42eACXcFePguaduQE
	GbYKDQgsgKgZ0rDCCnwvrBlBT+YMV2wbHAmLnrSThghcTe5bA/JkGWQvo0qFzeUZ3e8Afwnau7l
	New5OqFcqYbyIQvDuHM8XkEfj2FQSgoRlXy9YXvKmpvXhq5NIYqO69o/ZZmuqrPd29GMEefFQ==
X-Received: by 2002:a05:622a:2b08:b0:517:99ea:ab7a with SMTP id
 d75a77b69052e-519e4ab67d5mr6391661cf.26.1781855722453; Fri, 19 Jun 2026
 00:55:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260619070719.812227-1-tabba@google.com> <20260619070719.812227-9-tabba@google.com>
 <20260619072826.A4AB91F00A3D@smtp.kernel.org>
In-Reply-To: <20260619072826.A4AB91F00A3D@smtp.kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 19 Jun 2026 08:54:45 +0100
X-Gm-Features: AVVi8CdH4KwLcyKMNu0ixYIxChbMsbvn4-3xRBbD02T0RbBs2gqfSqVZV8EKhug
Message-ID: <CA+EHjTyEikgroi9a9vhtv-pixBj_21RC=4d4EnsfxFk10WCnwA@mail.gmail.com>
Subject: Re: [PATCH v2 8/8] KVM: arm64: Implement lazy vCPU state sync for
 non-protected guests
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>, 
	Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 19 Jun 2026 at 08:28, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 2 potential issu=
e(s) to consider:
> - [High] Dropped register updates for non-protected guests due to missing=
 PKVM_HOST_STATE_DIRTY flag.
> - [High] Missing HCR_EL2 sync on guest exit causes an infinite loop of vi=
rtual SError injections.

VSE is explicitly synced back, not dropped. The stale-SW-copy concern
is pre-existing upstream nVHE (no HCR_EL2 readback from HW); the old
full copy synced the same stale value. PENDING_EXCEPTION rides iflags,
copied unconditionally (not DIRTY-gated). EL2 re-derives the exception
via enter_exception64. KVM_REQ_VCPU_RESET targets the OFF->ON vCPU,
not the running one.

/fuad

> --
>
> commit b6999f3ffe5ca70d542b029d1a2d4a9e5e9d8276
> Author: Fuad Tabba <tabba@google.com>
>
> KVM: arm64: Implement lazy vCPU state sync for non-protected guests
>
> This commit defers copying a non-protected guest's register context betwe=
en
> the host and hypervisor. It introduces a PKVM_HOST_STATE_DIRTY flag to on=
ly
> sync the state when modified by the host.
>
> > diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.=
c
> > --- a/arch/arm64/kvm/handle_exit.c
> > +++ b/arch/arm64/kvm/handle_exit.c
> [ ... ]
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
> Does unconditionally clearing this flag on every exit drop register updat=
es
> for non-trap exits?
>
> For non-trap exits like ARM_EXCEPTION_IRQ or ARM_EXCEPTION_IL,
> handle_trap_exceptions() will not be called to set the flag again.
>
> If an asynchronous request like KVM_REQ_VCPU_RESET (triggered by PSCI CPU=
_ON)
> modifies the host vcpu->arch.ctxt in the kvm_arch_vcpu_ioctl_run() loop, =
or
> if an undefined exception is injected via handle_exit(), flush_hyp_vcpu()
> will skip copying these updates because the dirty flag is clear.
>
> Could this cause the guest to resume execution from its old pc with stale
> state?
>
> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nv=
he/hyp-main.c
> > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> [ ... ]
> > @@ -203,9 +255,13 @@ static void sync_hyp_vcpu(struct pkvm_hyp_vcpu *hy=
p_vcpu)
> >       fpsimd_sve_sync(&hyp_vcpu->vcpu);
> >       sync_debug_state(hyp_vcpu);
> >
> > -     host_vcpu->arch.ctxt            =3D hyp_vcpu->vcpu.arch.ctxt;
> > -
> > -     host_vcpu->arch.hcr_el2         =3D hyp_vcpu->vcpu.arch.hcr_el2;
>
> [Severity: High]
> Does removing the hcr_el2 sync cause an infinite loop of virtual SError
> injections?
>
> To inject a virtual SError, the host sets HCR_VSE in host_vcpu->arch.hcr_=
el2.
> When the guest takes the SError, the hardware clears the VSE bit, which i=
s
> captured in hyp_vcpu->vcpu.arch.hcr_el2 on exit.
>
> Since this patch removes the copy-back of hcr_el2 to the host for both
> protected and non-protected guests, the host's HCR_VSE bit remains set
> permanently.
>
> Will this cause flush_hyp_vcpu() to endlessly re-inject the SError on eve=
ry
> subsequent entry?
>
> > +     if (pkvm_hyp_vcpu_is_protected(hyp_vcpu)) {
> > +             host_vcpu->arch.ctxt =3D hyp_vcpu->vcpu.arch.ctxt;
> > +     } else {
> > +             /* Keep PC (tracepoint) and PSTATE (vcpu_mode_is_bad_32bi=
t) current. */
> > +             host_vcpu->arch.ctxt.regs.pc =3D hyp_vcpu->vcpu.arch.ctxt=
.regs.pc;
> > +             host_vcpu->arch.ctxt.regs.pstate =3D hyp_vcpu->vcpu.arch.=
ctxt.regs.pstate;
> > +     }
> >
> >       host_vcpu->arch.fault           =3D hyp_vcpu->vcpu.arch.fault;
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260619070719.81=
2227-1-tabba@google.com?part=3D8
