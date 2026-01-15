Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 842542EF67A
	for <kvmarm@lists.linux.dev>; Thu, 15 Jan 2026 19:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768504575; cv=pass; b=GaqRX/Qv7tmkU/rjVsCPIu3FI0fHZrwZ7Dm2TOaV7lAD1e6FfO5fUFryTYJrTh6kohrPF01B5anmilVlXvcZcG5rPbRhx95bpGYeaPU/Ad3bYE/vzREjlU+Ku6aRyiUZPwiCLv2z8QA3RucY77j81cGGN/2tox5ZwWOyiDtVow4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768504575; c=relaxed/simple;
	bh=EIiUg/lcvXodH2ijukwV+fvSAoVL6cO07Ek3+X4ex3U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iY2gekfW5dhS3CxbqqXrR53GadFDGW5JXtfTXY25cbwIsd3/qszWehSElCEU/aO8DE/rq86KKZTgwuznQJLF/wwhFwHyTYl/ze5QBU76ZRmVeMZqi12LV2Mp8tUR4s0iPPY9cIIBgINCffFw9u2jUnxdJ+vaIp2FLI/7fHF0vLo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DmiwMFyh; arc=pass smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DmiwMFyh"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-501511aa012so36691cf.0
        for <kvmarm@lists.linux.dev>; Thu, 15 Jan 2026 11:16:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768504570; cv=none;
        d=google.com; s=arc-20240605;
        b=LCt6T1wfjfz9ux7kSXHxvgl94EKMAAuGc2EIv1qAZUOPerQ60RfvI7pxzA7YqGm2tI
         +MSMpTTJSGhryvbld51DDu7HhwX18uouEFVKyHDY7xvG6DP5v8UybrYDoYtmJsWyr5Ut
         rivIRKUoPPto9/Dam3+BMwyBv/fXJnpf/b9FXIERqW6KhZp9Z8qs5vk/z9wRKst6k6kB
         PseSkasu7HYVLlIzgNcViv4JSMnj4KyhckSmO+cLOFuAYxC2aomAZkuyjBB/qP7j2E3i
         VSnqG+UoUrqoZmY3Bc7j9ie5jYMG7lh9ziVwd6OLRezmVb8ygbzYKNmnM3kmJz1/kjQP
         OIaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=789E7XMsSF/vUYGo+sB/vwsS/4LWZ4RWatA6a6kFxhE=;
        fh=vxg7jDbV4KUkB1p2dijbmgxOcCsnV64udQg+GHT6RZo=;
        b=fYOuj7OIelXmw62FuLdIvDp3l7H7Hhom3oGLg2adUgUUJcWboOvpJG+1gr2WjbdLZ6
         BtHL77iZkvRZRpu4ff43lid2wmCnaLGoI2Z4iTifMPgY1tQqkU4VWvCU7SCRvrJldiUC
         plwKjbmxZ3OvHryR7KntiaDXOfeevq2oFI6cYy5GlgRjMOn0KrInjvDkEUO2BdRx8zwh
         KvRvlPoCZKcyKE0U0396oHGQJUNnz9JsZsTwwTSxnwlo/TexUsAHId9FNHl/8LUvWvbP
         qwMx8v1rQoBWIhFODn4Bbg1TxgrrHXdh1lpHhTcZrWCH/dArknwC8wnuikkIKlou8BWd
         64iA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768504570; x=1769109370; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=789E7XMsSF/vUYGo+sB/vwsS/4LWZ4RWatA6a6kFxhE=;
        b=DmiwMFyh+OUoMZ7v4ZyCD7i8rM94Cdpf4FQ/YnAYyfOVVk/wlIWyl503JeGZNSlVlp
         610PL0E5E1FYQnurQjfDdVojqnobBg28afQtNh5cJ2WW69x+sRv0K2CCYBhLpm9PBPP4
         ceaEmY26bQkvOs+B/Ckvzp5iv4JSnucNVnUJylyEiK3USmoees64KUH3gmoUYYlylklX
         UZugGk8MBFapNUC6+6pMrR/4RsCTo+nIGc0HO8UeZ3LyRJIhzzIc68S8adSETfIDzgbW
         KPtWi4/BCuS783HYfk3j7SVNP/MSCdnPvp27AxVIjR1sviBSA6UjxAW8U+X131bCuarX
         1bug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768504570; x=1769109370;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=789E7XMsSF/vUYGo+sB/vwsS/4LWZ4RWatA6a6kFxhE=;
        b=lfA/VLJiItGqVcP9qDZdaoEMTxiD7sei9X1hIHFyhAVRsLUAgEJuvcRnyOMej4ojNz
         87YrVSkoe4NEY7ZPhe8LiLcxMKRMEKj5bVNC9BBYIRVGsbeiy/0IvLRm4HSF3rTPV1Gi
         YRvwE3rUG/JyF9OU1ZbW10c4HS1f1oTUOPwhwyveU7KYTx1UxtYRTDqt514RtEBeAl5H
         1/uCmdBD6edpUkAm0kT5rB/9Qd6Hg3Ie2tYozXdAWhTcKZRmLy6Gee4XVCPmJsUFmHTC
         JSzCHZ3VgcqcuoUnShSzX1/gqv4e3YLGvh98kCvQrpbMdJSQKybJF8k6DQvtvjc/JSnk
         0oxQ==
X-Gm-Message-State: AOJu0YySazyVXIbAVCw9o2a6TufKhGqjFbu8D/MBFDskqd4CD7UqEyp0
	Fsfqp5NSjghXX41GgSSw9nrmtn2j8QwLsDjUMoTgpV/6tmF7eMKGzgQMPXpdINg1MsjFzudnZtJ
	tD5sUKTUQDwZQ/LBXpAFXcEE6xTVyxmURbkNqOvE4
X-Gm-Gg: AY/fxX67L3RGWyjiEDKYhDSKIVsYEBd61ml15RlI/nOlXWTfyX6mSdr1LuS+n+u38RR
	b1PkAOD69NQ2IhkPzWPVkjlmSJgk00UcuwOAE9B1p4wg5RNbrPKLQMCsyDA4c00+FyCp6hmQK00
	jJMcIO6usxG0yMrUM/l5AYjWzghh39O8Y9XE+bUt0oS6c/5lLtHjDwudSbh8HGoqRT/rxx/kgai
	D0wn3VGMcUSp3vKVK82J/Jnulqql1tZaV9aT1WcKg3zJ4F6jR+ucP5aRn64nLocPzNlWkl/RLl4
	NfBIoC4=
X-Received: by 2002:ac8:5f85:0:b0:501:19ce:5bdd with SMTP id
 d75a77b69052e-502a2308428mr882991cf.6.1768504569294; Thu, 15 Jan 2026
 11:16:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251211104710.151771-1-tabba@google.com> <20251211104710.151771-9-tabba@google.com>
 <86h5smlxyo.wl-maz@kernel.org> <CA+EHjTzEtPta5VHr5R0r0v7ui7-8xv5me29uk2devZ=S14RHqw@mail.gmail.com>
 <86fr86lv3d.wl-maz@kernel.org> <CA+EHjTwX-kDg24LMHCyMVP3Xpdpv55WyP2AxeWXa5CKk1yyudQ@mail.gmail.com>
 <86bjiuda8g.wl-maz@kernel.org>
In-Reply-To: <86bjiuda8g.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 15 Jan 2026 19:15:28 +0000
X-Gm-Features: AZwV_QgcKJ5OhA7XfrB4ljMybieHt7byPPTTE3IaEVLHFanD5VjBl9f8hknoheQ
Message-ID: <CA+EHjTzMLEYH7f+=1MMv_oRfk9fEUge325RzhoFbPhNRa0W=aA@mail.gmail.com>
Subject: Re: [PATCH v6 8/9] KVM: arm64: Check whether a VM IOCTL is allowed in pKVM
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	oliver.upton@linux.dev, will@kernel.org, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	vladimir.murzin@arm.com
Content-Type: text/plain; charset="UTF-8"

On Thu, 15 Jan 2026 at 18:03, Marc Zyngier <maz@kernel.org> wrote:
>
> On Thu, 15 Jan 2026 16:14:39 +0000,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > On Thu, 15 Jan 2026 at 16:05, Marc Zyngier <maz@kernel.org> wrote:
> > >
> > > On Thu, 15 Jan 2026 15:19:48 +0000,
> > > Fuad Tabba <tabba@google.com> wrote:
> > > >
> > > > Hi Marc,
> > > >
> > > > On Thu, 15 Jan 2026 at 15:03, Marc Zyngier <maz@kernel.org> wrote:
> > > > >
> > > > > On Thu, 11 Dec 2025 10:47:08 +0000,
> > > > > Fuad Tabba <tabba@google.com> wrote:
> > > > > >
> > > > > > Certain VM IOCTLs are tied to specific VM features. Since pKVM does not
> > > > > > support all features, restrict which IOCTLs are allowed depending on
> > > > > > whether the associated feature is supported.
> > > > > >
> > > > > > Use the existing VM capability check as the source of truth to whether
> > > > > > an IOCTL is allowed for a particular VM by mapping the IOCTLs with their
> > > > > > associated capabilities.
> > > > > >
> > > > > > Suggested-by: Oliver Upton <oupton@kernel.org>
> > > > > > Signed-off-by: Fuad Tabba <tabba@google.com>
> > > > > > ---
> > > > > >  arch/arm64/include/asm/kvm_pkvm.h | 21 +++++++++++++++++++++
> > > > > >  arch/arm64/kvm/arm.c              |  3 +++
> > > > > >  2 files changed, 24 insertions(+)
> > > > > >
> > > > > > diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
> > > > > > index 5b564576160d..0fa8c84816fd 100644
> > > > > > --- a/arch/arm64/include/asm/kvm_pkvm.h
> > > > > > +++ b/arch/arm64/include/asm/kvm_pkvm.h
> > > > > > @@ -9,6 +9,7 @@
> > > > > >  #include <linux/arm_ffa.h>
> > > > > >  #include <linux/memblock.h>
> > > > > >  #include <linux/scatterlist.h>
> > > > > > +#include <asm/kvm_host.h>
> > > > > >  #include <asm/kvm_pgtable.h>
> > > > > >
> > > > > >  /* Maximum number of VMs that can co-exist under pKVM. */
> > > > > > @@ -43,6 +44,7 @@ static inline bool kvm_pkvm_ext_allowed(struct kvm *kvm, long ext)
> > > > > >       case KVM_CAP_ARM_SVE:
> > > > > >       case KVM_CAP_ARM_PTRAUTH_ADDRESS:
> > > > > >       case KVM_CAP_ARM_PTRAUTH_GENERIC:
> > > > > > +     case KVM_CAP_ARM_BASIC:
> > > > >
> > > > > Can we instead rely on an existing VM capability? I'm not overly keen
> > > > > exposing something new to userspace (KVM_CAP_ARM_BASIC) for something
> > > > > that really is KVM's own internal problems.
> > > > >
> > > > > Looking at the history, a bunch of things have always been present:
> > > > > KVM_CAP_NR_VCPUS, for example. You could even #define
> > > > > KVM_CAP_ARM_BASIC to that if you want.
> > > >
> > > > I wasn't too crazy about that either. I like the idea of defining it
> > > > as an alias of KVM_CAP_NR_VCPUS. I'll do that when I respin.
> > >
> > > I've done something [1]. If that works for you, let me know and I'll
> > > just merge that.
> >
> > That works for the previous patch (7/9), which is where you've made
> > the change. But since the alias is defined in `arm.c` it wouldn't work
> > in this patch (8/9), because the function kvm_pkvm_ext_allowed() is
> > defined in  `asm/kvm_pkvm.h`.
>
> I dropped it from patch 8/9 for the reason below.
>
> > Defining the alias in `asm/kvm_pkvm.h`
> > or in `asm/kvm_host.h` should solve this, since both files are visible
> > in arm.c (and in kvm_pkvm.h in both cases).
>
> Nope. The compiler spots that this is the same value twice in the
> switch, and compile fails. I only kept it as syntactic sugar in arm.c,
> but I could otherwise drop it entirely.

I see. Thanks for fixing this Marc!
/fuad
>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
