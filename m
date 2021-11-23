Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ECFDC433F5
	for <kvmarm@archiver.kernel.org>; Tue, 23 Nov 2021 17:13:19 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 965384B1E1;
	Tue, 23 Nov 2021 12:13:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DJr8PykpIcfN; Tue, 23 Nov 2021 12:13:17 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A1524B201;
	Tue, 23 Nov 2021 12:13:17 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 883B74B1E1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Nov 2021 12:13:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id htIF5XNh4nHK for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Nov 2021 12:13:15 -0500 (EST)
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com
 [209.85.214.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DB3734B18A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Nov 2021 12:13:14 -0500 (EST)
Received: by mail-pl1-f174.google.com with SMTP id o14so17627777plg.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Nov 2021 09:13:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=Fv8jHJnT3Eva2oaobFBXfDkuR9RNjkJvSl3tDLrQc7A=;
 b=NJo/Ri2OK5QjvagXOJR7sjckD5MHFxoeoaed7q56nfJgpAAvhgb0/PSStStdVFT51F
 xI9tQf5K2pq/P8LJg0Iscf7x6/TmbxgDihx7Qz99u5jrCgDQmNEjEHEYkm7bx+erYs6h
 3J79Xm1VfHwKvZjX/admw8cnxdFmksCn2XHrei5Sm96S9S/6GntqqYqkvV2cyzG69LVR
 5fv0Uhh4ZuRXw2WiZRCtbH4QsMeC+2W+IC+/wiDNET5yyNLZOAXK3ruhatdZMcgsWvzr
 IlLOmi6ezrvlivdxLRDT+8DAyTEnz+80ZTMARp14egKXvyC4JUncP+Fzm+jNndJ2PEF8
 a3CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=Fv8jHJnT3Eva2oaobFBXfDkuR9RNjkJvSl3tDLrQc7A=;
 b=vP34oHr/InenHP/M/gbn+o3GyChTxEX3Ri7zV4FsPHaasAHToGjGPQnZgBFuILbo+I
 b2PfHI4BVVNDdxDZ3/LiShnfg0KDUWKGSAS2hpubpMeiJTtYgf0uvKItlw1joh2n2PjR
 8pZir3s+1gIJL+2q24ifE8A2NVmnO6ZBZLf1ZmXQRGIulL5hkCNTHkXGPZWJ5qU36ePG
 A88x6UOgjxteqvXsFohB/RczWCmkXhjWxUaBspCIQ4wiHWbbAKa+0g6sLFfOfoumSb2d
 buZ75zARqiynw1pftTfo2YY99Y23u2JQhT8kWDybvvhpKKuLQvstdXI/kxcasP4/mYlx
 2doA==
X-Gm-Message-State: AOAM5307ajNsbvfHJ01mnm+1+RgNBthEdyFBy3WI1dAhHA9KS3kgV0Y/
 qcbO3LXP6DasbO0riGAGmAqp0TFecRq38F3YyvUnDJ7cuxr2+VyU
X-Google-Smtp-Source: ABdhPJwGNpwXwzgcbpUJXRwFkigAhlLEETdVhhn3ua5dVVlxqditNpcRsDJafoTxLjrJHMyDiMB3dAQp3IG3EeeChIE=
X-Received: by 2002:a17:90b:380d:: with SMTP id
 mq13mr4956330pjb.110.1637687593623; 
 Tue, 23 Nov 2021 09:13:13 -0800 (PST)
MIME-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com>
 <20211117064359.2362060-3-reijiw@google.com>
 <87lf1hsn11.wl-maz@kernel.org>
 <CAAeT=Fxcd9ExAXP-c6N-LYAT8_SGYUMHHeGO5dCW8=K+m=WTMQ@mail.gmail.com>
 <87o86bchok.wl-maz@kernel.org>
In-Reply-To: <87o86bchok.wl-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Tue, 23 Nov 2021 09:12:56 -0800
Message-ID: <CAAeT=FzoafZXEoG+xxiQywEpLBaQEE=0bu9c+O6UraDE1BN3_A@mail.gmail.com>
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

On Tue, Nov 23, 2021 at 2:03 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Tue, 23 Nov 2021 04:39:27 +0000,
> Reiji Watanabe <reijiw@google.com> wrote:
> >
> > On Sun, Nov 21, 2021 at 4:37 AM Marc Zyngier <maz@kernel.org> wrote:
> > >
> > > On Wed, 17 Nov 2021 06:43:32 +0000,
> > > Reiji Watanabe <reijiw@google.com> wrote:
> > > >
> > > > Extend sys_regs[] of kvm_cpu_context for ID registers and save ID
> > > > registers' sanitized value in the array for the vCPU at the first
> > > > vCPU reset. Use the saved ones when ID registers are read by
> > > > userspace (via KVM_GET_ONE_REG) or the guest.
> > > >
> > > > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > > > ---
> > > >  arch/arm64/include/asm/kvm_host.h | 10 +++++++
> > > >  arch/arm64/kvm/sys_regs.c         | 43 +++++++++++++++++++------------
> > > >  2 files changed, 37 insertions(+), 16 deletions(-)
> > > >
> > > > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > > > index edbe2cb21947..72db73c79403 100644
> > > > --- a/arch/arm64/include/asm/kvm_host.h
> > > > +++ b/arch/arm64/include/asm/kvm_host.h
> > > > @@ -146,6 +146,14 @@ struct kvm_vcpu_fault_info {
> > > >       u64 disr_el1;           /* Deferred [SError] Status Register */
> > > >  };
> > > >
> > > > +/*
> > > > + * (Op0, Op1, CRn, CRm, Op2) of ID registers is (3, 0, 0, crm, op2),
> > > > + * where 0<=crm<8, 0<=op2<8.
> > > > + */
> > > > +#define KVM_ARM_ID_REG_MAX_NUM 64
> > > > +#define IDREG_IDX(id)                ((sys_reg_CRm(id) << 3) | sys_reg_Op2(id))
> > > > +#define IDREG_SYS_IDX(id)    (ID_REG_BASE + IDREG_IDX(id))
> > > > +
> > > >  enum vcpu_sysreg {
> > > >       __INVALID_SYSREG__,   /* 0 is reserved as an invalid value */
> > > >       MPIDR_EL1,      /* MultiProcessor Affinity Register */
> > > > @@ -210,6 +218,8 @@ enum vcpu_sysreg {
> > > >       CNTP_CVAL_EL0,
> > > >       CNTP_CTL_EL0,
> > > >
> > > > +     ID_REG_BASE,
> > > > +     ID_REG_END = ID_REG_BASE + KVM_ARM_ID_REG_MAX_NUM - 1,
> > >
> > > It is rather unclear to me why we want these registers to be
> > > replicated on a per-CPU basis. Yes, this fits the architecture, but
> > > that's also a total waste of memory if you have more than a single
> > > CPU, because we make a point in only exposing homogeneous properties
> > > to the VM (I don't think anyone intends to support vcpu asymmetry in a
> > > VM, and 64 registers per vcpu is not an insignificant memory usage).
> > >
> > > If there are no reasons for this to be per-CPU, please move it to be
> > > global to the VM. This also mean that once a vcpu has reset, it
> > > shouldn't be possible to affect the registers. This shouldn't affect
> > > the userspace API though.
> >
> >
> > Currently, userspace can configure different CPU features for each vCPU
> > with KVM_ARM_VCPU_INIT, which indirectly affect ID registers.
> > I'm not sure if anyone actually does that though.
>
> But the way the ID regs are affected is always global AFAICT. For
> example, if you instantiate a PMU, you do so on all vcpus, even of the
> architecture allows you to build something completely asymmetric.
>
> > Since I personally thought having ID registers per vCPU more naturally
> > fits the behavior of KVM_ARM_VCPU_INIT and makes more straightforward
> > behavior of KVM_SET_ONE_REG, I chose that.
>
> I agree that this is the logical approach from an architectural PoV.
>
> > (That would be also better in terms of vCPUs scalability for live migration
> >  considering a case where userspace tries to restore ID registers for
> >  many vCPUs in parallel during live migration.  Userspace could avoid that,
> >  and there are ways for KVM to mitigate that though.)
>
> I think these are orthogonal things. We can expose a per-vcpu view,
> but there is no need to have per-vcpu storage and to allow asymmetric
> VMs. If I have anything to say about the future of KVM/arm64, it will
> be that I don't want to support this at all.
>
> > Having ID registers per-VM is of course feasible even while maintaining
> > the current behavior of KVM_ARM_VCPU_INIT though.
>
> Exactly. per-VM storage, and per-vcpu visibility. It will prevent all
> sort of odd behaviours.

Thank you so much for all your comments.
I will make it per VM storage.

Regards,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
