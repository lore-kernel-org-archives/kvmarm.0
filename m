Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 330351F954
	for <kvmarm@lists.linux.dev>; Mon, 22 Jul 2024 15:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721661803; cv=none; b=MT4CSK9dV8tRtNx0ynY0uQweGnFWl7cYjHsimY7knXnzIjfYhI+yhUtfJ73vyiJ4eSwmfO0wwP2/XCLCy/hflkhjwk2+8WFyc11QHyTE6EUyN18xlwaT4EZlwQN9ivsb0jjBjGRl64C7lT8oPL8WTUxpzatjxeT3h7apmoTkvQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721661803; c=relaxed/simple;
	bh=PI/hDamnrGghtva7pPimLdPYhVHqP9gxIUe0D0tidQo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=e45ULGH26sns3bqjZckT/UgT5/hR8c7bJc2mDRrXn/008WkeRj1AsZSRFqXdP2qzDFoLdBXrVlFtOAInhclc4/OO6oWOuUL+ar9IjoTRcWR5F6Kg5ZK+6I8c7Q2+wJyCdtTjqDbqLU4W86Ko39pxIUHbRC4YAvAR/AXcGCoQW3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0rw5nY/6; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0rw5nY/6"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3686b285969so1932145f8f.0
        for <kvmarm@lists.linux.dev>; Mon, 22 Jul 2024 08:23:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721661800; x=1722266600; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=EXPHJGidSnujefQDTvxoJc3NFdvhsw8IMZ9onXe+MGg=;
        b=0rw5nY/6TZ62oD4CAmRQ96W7hcInotJ6wQzdqFgzxSGdZsfn122MGFoNfgt9bUkUmB
         QgE9aONbemoOnmQNiff6wXGN7UP1WnSw3TTQWKIXHf8ait8NsVE80rXb6jqIqcW22iyg
         Vo7U/yIx264zT9g7NPKJN5Sf3g56E438LXPTcknPX1/UgYQhOLHZxpFrFWQwv5iGU9nt
         WVvL7FPWf/h0kT5qasEiBWrepTzV68FVeqFHD/WxdW+ghfdl+LD5XLHRapyXp3hMaAg6
         muNy2AIgUsoDgdZBew/f+TrNg6M5lJRhPzP7pNKwpvzpyyKA4j3Qnd+vFJpe82KMrqAY
         xGbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721661800; x=1722266600;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EXPHJGidSnujefQDTvxoJc3NFdvhsw8IMZ9onXe+MGg=;
        b=tUZfdkf1HovGgoVEH+OwzllipBHiMDF/auipP0j7mx8slyXVX0FInJe6VaDVIgSti+
         yx1mEEn9Offo5oOMBHGsiLqBFrhKs43A8QuIHrbaEeWWP7FAfbN8RxodbyfRZ6Ce35p/
         sAIwso3Xg3LmJlfU4mqPRue38uja4jQjPLGrquVgBWn+w/UTJ1uOnF7jQHdEjfFtiELv
         4pjTrQO0bh7fsESZNjWudLUP5PoKrS5dtfHoLeDTqd1dkQbIfDH34NQX8Sw9qKB/STc2
         5SwTkETHP+hrgoke9NDO8gaNkBx1466QfKO8y2CyV4DGCMnlIm28nCRF4BC62Euyfp1k
         19dw==
X-Gm-Message-State: AOJu0Yyl42Accfr882Pc7KdR6M25vBOVoXNrkvamN982gl6WWnasPL6C
	KfvntHyRUM4PRlqy3wwKCC4NtQNSt8oqQXh/4/O1q2JwzSj+mxtm4+bayV8zBuHD1xsBxVtkdxw
	2/HtREhxEN/WY/tXSGVhd2puehaga7oyE+E9r
X-Google-Smtp-Source: AGHT+IGGpmRh+TlBmozuQCza4t8G0WAluuthA5scuV+swJhYNufFUUOX0VR4vcckd9M0voOa8FU+qqp4HZU8OInG16Q=
X-Received: by 2002:adf:b31d:0:b0:367:8a72:b8b4 with SMTP id
 ffacd0b85a97d-369bae46a5fmr4062042f8f.33.1721661800276; Mon, 22 Jul 2024
 08:23:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240722123740.674846-1-tabba@google.com> <875xsx5urh.wl-maz@kernel.org>
In-Reply-To: <875xsx5urh.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 22 Jul 2024 16:22:43 +0100
Message-ID: <CA+EHjTxBdx5PKExMLf96_RvpU5QFeW2mFD-87M-H1xff_4gs5g@mail.gmail.com>
Subject: Re: [PATCH v1] KVM: arm64: Tidying up PAuth code in KVM
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, 
	yuzenghui@huawei.com, joey.gouly@arm.com, smostafa@google.com, 
	will@kernel.org, catalin.marinas@arm.com
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Mon, 22 Jul 2024 at 16:09, Marc Zyngier <maz@kernel.org> wrote:
>
> Hi Fuad,
>
> On Mon, 22 Jul 2024 13:37:40 +0100,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > Tidy up some of the PAuth trapping code to clear up some comments
> > and avoid clang/checkpatch warnings. Also, do not bother setting
> > the PAuth HCR_EL2 bits for protected VMs in pKVM, since that is
> > handled by the hypervisor.
> >
> > Fixes: 814ad8f96e92 ("KVM: arm64: Drop trapping of PAuth instructions/keys")
>
> nit: AFAICT, this doesn't really fix anything. It has no material
> impact on the guest or the hypervisor.

Got it.

> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_ptrauth.h    | 2 +-
> >  arch/arm64/kvm/arm.c                    | 7 ++++---
> >  arch/arm64/kvm/hyp/include/hyp/switch.h | 1 -
> >  arch/arm64/kvm/hyp/nvhe/switch.c        | 5 ++---
> >  4 files changed, 7 insertions(+), 8 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_ptrauth.h b/arch/arm64/include/asm/kvm_ptrauth.h
> > index d81bac256abc..6199c9f7ec6e 100644
> > --- a/arch/arm64/include/asm/kvm_ptrauth.h
> > +++ b/arch/arm64/include/asm/kvm_ptrauth.h
> > @@ -104,7 +104,7 @@ alternative_else_nop_endif
> >
> >  #define __ptrauth_save_key(ctxt, key)                                        \
> >       do {                                                            \
> > -             u64 __val;                                              \
> > +             u64 __val;                                              \
> >               __val = read_sysreg_s(SYS_ ## key ## KEYLO_EL1);        \
> >               ctxt_sys_reg(ctxt, key ## KEYLO_EL1) = __val;           \
> >               __val = read_sysreg_s(SYS_ ## key ## KEYHI_EL1);        \
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 59716789fe0f..6516348024ba 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -510,10 +510,10 @@ void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
> >
> >  static void vcpu_set_pauth_traps(struct kvm_vcpu *vcpu)
> >  {
> > -     if (vcpu_has_ptrauth(vcpu)) {
> > +     if (vcpu_has_ptrauth(vcpu) && !vcpu_is_protected(vcpu)) {
>
> I think this isn't quite correct.
>
> Non-protected VMs in protected mode are still subjected to pKVM's own
> handling of the HCR_EL2 configuration, and the whole thing should be
> skipped altogether in that case, irrespective of the pauth status of
> the vcpu.
>
> What pKVM should evaluate is that status and decide for itself whether
> it must enable it or not. You can then hoist the check for protected
> mode early and skip the whole function unconditionally, irrespective
> of the protected status of the vcpu.

What pKVM does right now is use the host value of hcr_el2 as a base,
and ensure that the HCR_GUEST_FLAGS are also set. That said, it
doesn't do that for MDCR_EL2 nor for CPTR_EL2. Thinking about it, I
think it makes more sense for HCR_EL2 in pKVM to be initialized
completely at EL2, and hoist the check, like you're suggesting.

I'll fix that (in this patch and in pKVM), and resend.

Thanks!
/fuad

> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
