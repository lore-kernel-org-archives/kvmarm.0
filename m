Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62E56C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 21 Apr 2022 03:31:35 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DB6404B10C;
	Wed, 20 Apr 2022 23:31:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 36OnI1K+7i7T; Wed, 20 Apr 2022 23:31:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C18A94B1A0;
	Wed, 20 Apr 2022 23:31:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 933B949F22
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Apr 2022 23:31:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fBfk2idBo+4v for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Apr 2022 23:31:31 -0400 (EDT)
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com
 [209.85.167.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6F6B849EEB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Apr 2022 23:31:31 -0400 (EDT)
Received: by mail-lf1-f43.google.com with SMTP id bq30so6399097lfb.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Apr 2022 20:31:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=wWdUpnsb47o1FNM4DoFpuEPQUv5HBP0fq0XE67umR3Y=;
 b=Em7H+xBAsQLN4Gfkl0tOWFxTWA6mp3EJVkxmQrtP7FkeppyKVEhkOkbeDkfOJnIK6e
 4GzQiMgAJRysMw6qNPLW2RQ4BeQcSzeHannnjEvhUUlSea8L/xq6lL84CDPqelwEC66/
 DjpoRulaMnTXmCkyRprav16+4wsDsMY//k2DxY03iB/h550gC8zPbKV8LjoCIo1Xi5s1
 ny0TjWryT9M3G8tYAdPC4Mc4hYySvojuaGF6RUhoe/r0qeVx/o4fLJhE4rRz5szl6b/3
 IMzexZ8YSnVyIih1HgYxFSqH+5p7csAdXh9f2Ig63ym8CG7j9xbBciEtcAMfu5ib1ubL
 qa+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=wWdUpnsb47o1FNM4DoFpuEPQUv5HBP0fq0XE67umR3Y=;
 b=jAaqSGr3ySevMCWXefjs0nFog1cqNiSjo27/ymeLvgC+nwVIpUO/cyWXswLbtR5XFa
 z2LM3ghPA+GX8Dp4//UuYwY52HyJymm7AZmyOCS1Nxt640DEiAECMorDyMkFiVctabCI
 SIdbi3wDVIjd9UNE8quJ6s2JOgf+UjzuGEp+jgXGuoO7oDW7+rVi3Bh1lAmEdzstdiK6
 S7sOi+WOAWY+mSxjwmkGnmzHKiHYk3CdfkwljbyeuWcZMjxGwNdSxAjAtVgFD1e6+5zq
 NlRR4YsG8MFZV+dkzfkqp988DC1SsA7OrtHRShaJllwIT+qFRK1OQYKRBa4B54oIbFsw
 EULQ==
X-Gm-Message-State: AOAM5339QdTJwBbCPMGKBL6htKH0MiCemNBNNG82ZmNblaPvVHrr6d45
 231DGtTt889rl+4mpphhEFlbaPHScJXfCSVsfiSODw==
X-Google-Smtp-Source: ABdhPJx6nIHUt1znd18RCHDSGPMHuur2dCYr/WggeHytHt7gs5Kiuo7HWarJ3QIphs0ibhh1V0k2ShQlVVJDHLWEv84=
X-Received: by 2002:a05:6512:3b9b:b0:471:8e54:2ecf with SMTP id
 g27-20020a0565123b9b00b004718e542ecfmr12971220lfv.286.1650511889850; Wed, 20
 Apr 2022 20:31:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220409184549.1681189-1-oupton@google.com>
 <20220409184549.1681189-4-oupton@google.com>
 <CAAeT=FxQ5qBMrYZpGbDT7i+bGFCyfoV32ddKeeprj7mEemnbEA@mail.gmail.com>
In-Reply-To: <CAAeT=FxQ5qBMrYZpGbDT7i+bGFCyfoV32ddKeeprj7mEemnbEA@mail.gmail.com>
From: Oliver Upton <oupton@google.com>
Date: Wed, 20 Apr 2022 20:31:18 -0700
Message-ID: <CAOQ_QsjzfWH=UV0hemGt5jeSrYrpzzcVLVPdOBe7LV__RkDT+Q@mail.gmail.com>
Subject: Re: [PATCH v5 03/13] KVM: arm64: Track vCPU power state using MP
 state values
To: Reiji Watanabe <reijiw@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Wanpeng Li <wanpengli@tencent.com>,
 kvm@vger.kernel.org, Joerg Roedel <joro@8bytes.org>,
 Peter Shier <pshier@google.com>, kvm-riscv@lists.infradead.org,
 Atish Patra <atishp@atishpatra.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, kvmarm@lists.cs.columbia.edu,
 Jim Mattson <jmattson@google.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Reiji,

Sorry for the late reply.

On Wed, Apr 13, 2022 at 10:26 PM Reiji Watanabe <reijiw@google.com> wrote:

[...]

> > @@ -457,7 +459,7 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
> >
> >         switch (mp_state->mp_state) {
> >         case KVM_MP_STATE_RUNNABLE:
> > -               vcpu->arch.power_off = false;
> > +               vcpu->arch.mp_state = *mp_state;
>
> Nit: It might be a bit odd that KVM_MP_STATE_STOPPED case only copies
> the 'mp_state' field of kvm_mp_state from userspace (that's not a 'copy'
> operation though), while KVM_MP_STATE_RUNNABLE case copies entire
> kvm_mp_state from user space.
> ('mp_state' is the only field of kvm_mp_state though)

I tried my best to leave this all as-is. I hinted at it in another
thread, but I really do think a refactoring would be good to make ARM
actually use the mp_state value instead of relying on vCPU requests. I
completely agree with the nit, but think it might be better to
collapse all of the weirdness around mp_state in a separate
patch/series which will drag the vCPU run loop along.

> Reviewed-by: Reiji Watanabe <reijiw@google.com>

Much appreciated :)

--
Best,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
