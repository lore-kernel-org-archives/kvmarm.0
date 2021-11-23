Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2708C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 23 Nov 2021 04:39:49 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E3BC04B153;
	Mon, 22 Nov 2021 23:39:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wmpvOY3bzK2y; Mon, 22 Nov 2021 23:39:47 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C2434B125;
	Mon, 22 Nov 2021 23:39:47 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 520BC4B0EC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Nov 2021 23:39:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9vWHSViFB+cT for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Nov 2021 23:39:45 -0500 (EST)
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com
 [209.85.215.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EB3504B0E6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Nov 2021 23:39:44 -0500 (EST)
Received: by mail-pg1-f174.google.com with SMTP id r138so7595301pgr.13
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Nov 2021 20:39:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=JZECwSvXg0MwYpcw/lT1xG0xEMMAh0EHotR98E/tTUA=;
 b=PWqHevJs+bq9UN9gwN2aFq2+fwq425MeYgrrioyKiiN1cCCza9b42qYr1ENBfAdLHY
 Ejg+Xfy1J/EEVC5Rj55hTArkewbGIfslYO8+e8PJ9+457cGvTOnEwrnYXY+VZKMLZOJQ
 NFQfBJsuSIpbnIMgPtsoq7sHo+wr23hhBiXzabS4JgI5a26+COLpw02rY/Nd8xEyawZq
 jQCXNig79ITPzvs8CzPXDknaxM2JUnxVbQJg3fL+pZoUTOxOm7PtuLISagRd5AIT81sh
 SVzpdwtwvQDHpB+26yyd/L74AGwcefc9jhM+fLFOwZbc5NgfFqg5aTMhkZ1fL3bXigFp
 +yWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=JZECwSvXg0MwYpcw/lT1xG0xEMMAh0EHotR98E/tTUA=;
 b=M6p9KRx900Tl4Mhoh9cqc5TQfVGqX11PdwoattgFvphJdIjzM4zg6qvF4FAehfmpx+
 FoSLrOsVrL+hAb/06oIeoEar9Sx0yZZ1GkCHUStTXQ5ORsmYKsJX9IB2GfiOX6TopGCQ
 fxh0sz0If+pxxb8n1Brx+/4VtPNQ4HroEVKPv9g4sUN0bPSFBVOtsp6xIk4kySbYBSbs
 w3fxKd9GveIXOv1hmUWzk/iS0mHpQnmRWMB2pZrYMXky6asgBh2CeQlgJe8oQ8EDoyog
 3HJFlmqJ7255nQhLjVswit8jWmwZjCjBCDm4Mq561QbJDBf2Sq+1yIyghClyQH4+mKDr
 u8Nw==
X-Gm-Message-State: AOAM532AJFaTYGP4c6i9RvgjRVNmy/Pwi3SrBUJNKH7UtbiSWDSxX4It
 UIYB2k7So2W0QuAUeWmKEf8FRF8M659JGeUk2YzWcg==
X-Google-Smtp-Source: ABdhPJyegAX27Q4ZmfdkoCLcAk4V9INtgvTmDNc65NtpQ43unJw2bVPyzHKuMXESV5tSMJHj1ocMLRNeBY+/ugIckl0=
X-Received: by 2002:aa7:9438:0:b0:4a2:c941:9ac4 with SMTP id
 y24-20020aa79438000000b004a2c9419ac4mr2437622pfo.12.1637642383746; Mon, 22
 Nov 2021 20:39:43 -0800 (PST)
MIME-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com>
 <20211117064359.2362060-3-reijiw@google.com>
 <87lf1hsn11.wl-maz@kernel.org>
In-Reply-To: <87lf1hsn11.wl-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Mon, 22 Nov 2021 20:39:27 -0800
Message-ID: <CAAeT=Fxcd9ExAXP-c6N-LYAT8_SGYUMHHeGO5dCW8=K+m=WTMQ@mail.gmail.com>
Subject: Re: [RFC PATCH v3 02/29] KVM: arm64: Save ID registers' sanitized
 value per vCPU
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Sun, Nov 21, 2021 at 4:37 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Wed, 17 Nov 2021 06:43:32 +0000,
> Reiji Watanabe <reijiw@google.com> wrote:
> >
> > Extend sys_regs[] of kvm_cpu_context for ID registers and save ID
> > registers' sanitized value in the array for the vCPU at the first
> > vCPU reset. Use the saved ones when ID registers are read by
> > userspace (via KVM_GET_ONE_REG) or the guest.
> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h | 10 +++++++
> >  arch/arm64/kvm/sys_regs.c         | 43 +++++++++++++++++++------------
> >  2 files changed, 37 insertions(+), 16 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index edbe2cb21947..72db73c79403 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -146,6 +146,14 @@ struct kvm_vcpu_fault_info {
> >       u64 disr_el1;           /* Deferred [SError] Status Register */
> >  };
> >
> > +/*
> > + * (Op0, Op1, CRn, CRm, Op2) of ID registers is (3, 0, 0, crm, op2),
> > + * where 0<=crm<8, 0<=op2<8.
> > + */
> > +#define KVM_ARM_ID_REG_MAX_NUM 64
> > +#define IDREG_IDX(id)                ((sys_reg_CRm(id) << 3) | sys_reg_Op2(id))
> > +#define IDREG_SYS_IDX(id)    (ID_REG_BASE + IDREG_IDX(id))
> > +
> >  enum vcpu_sysreg {
> >       __INVALID_SYSREG__,   /* 0 is reserved as an invalid value */
> >       MPIDR_EL1,      /* MultiProcessor Affinity Register */
> > @@ -210,6 +218,8 @@ enum vcpu_sysreg {
> >       CNTP_CVAL_EL0,
> >       CNTP_CTL_EL0,
> >
> > +     ID_REG_BASE,
> > +     ID_REG_END = ID_REG_BASE + KVM_ARM_ID_REG_MAX_NUM - 1,
>
> It is rather unclear to me why we want these registers to be
> replicated on a per-CPU basis. Yes, this fits the architecture, but
> that's also a total waste of memory if you have more than a single
> CPU, because we make a point in only exposing homogeneous properties
> to the VM (I don't think anyone intends to support vcpu asymmetry in a
> VM, and 64 registers per vcpu is not an insignificant memory usage).
>
> If there are no reasons for this to be per-CPU, please move it to be
> global to the VM. This also mean that once a vcpu has reset, it
> shouldn't be possible to affect the registers. This shouldn't affect
> the userspace API though.


Currently, userspace can configure different CPU features for each vCPU
with KVM_ARM_VCPU_INIT, which indirectly affect ID registers.
I'm not sure if anyone actually does that though.

Since I personally thought having ID registers per vCPU more naturally
fits the behavior of KVM_ARM_VCPU_INIT and makes more straightforward
behavior of KVM_SET_ONE_REG, I chose that.
(That would be also better in terms of vCPUs scalability for live migration
 considering a case where userspace tries to restore ID registers for
 many vCPUs in parallel during live migration.  Userspace could avoid that,
 and there are ways for KVM to mitigate that though.)

Having ID registers per-VM is of course feasible even while maintaining
the current behavior of KVM_ARM_VCPU_INIT though.

Thanks,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
