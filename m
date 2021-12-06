Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11395C433F5
	for <kvmarm@archiver.kernel.org>; Mon,  6 Dec 2021 17:39:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C37B4A524;
	Mon,  6 Dec 2021 12:39:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nV0Uby5eEC3W; Mon,  6 Dec 2021 12:39:21 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E75DF4B0B4;
	Mon,  6 Dec 2021 12:39:21 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B2734B091
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Dec 2021 12:39:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id esr+aFp1St+P for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Dec 2021 12:39:18 -0500 (EST)
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com
 [209.85.167.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 720E64A524
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Dec 2021 12:39:18 -0500 (EST)
Received: by mail-lf1-f41.google.com with SMTP id z21so5101395lfu.8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 06 Dec 2021 09:39:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=V8ITWY1n7ElqH5jSN7uTqFl2PNx7VzHtpjwf2mxeU8M=;
 b=jJPpyokIq63kXOSFeG7lUivGCPniPsIubHsaWC0fMcY4BMBcRpAvIcJ2Rn6sw41+2i
 m4VFflr9mD+M2IFw+W8rk2V/ubDs7NbfsiaGx2B+jMORpvwzMWSF0I2sV8V5GCJv7d3e
 P5qvQvbWcnd7zmQstHfoXfQOHSGLO/zey1h5PFfnh5kJwCwtVTddMt/ZuEA7XF7KcPg/
 t3eRtY1ibrnbRL/sQFa0Hc1muQ8idM96iHwksGXPz10sMfVqJ3dCRe+mt68Zjnw0O3Wj
 tWW8kGlt8SDRGONRj0TVSmjfzdIrPIrsnZyGxkWGVLtHibsydgE9GF+zW72NrDmMZfLH
 4Zhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=V8ITWY1n7ElqH5jSN7uTqFl2PNx7VzHtpjwf2mxeU8M=;
 b=YLDlChfi2G8SXJ+jedGlmbUujLFQbyR+zYVr7bEQbapyhS65h6MeDbKaEaj8XzyYpr
 +q/ArTKawCdNO+wsacO094XWPtrcbqFMUFZviNCTaa8V0a4tq0+1Jg0w4G0hZW8HN/4A
 SioL59Eto45EmvzTT9cecJhg3nn8VqBosefD6QFWvxrb6b0TWsKcQbeIsTwjVFNIbXa3
 edi2A3eLy5XwlZTM67SfI0cQa0sVByJKv0zxFqUXehfT0FGBNui38By5eYcLT4C7mqoM
 0nlQ1z9FPMYakWsLkbWPoSf7tmuYhxeOsx2xLPFFnTyfM09re1fgmY1txdu3Q9Qy3lyO
 hwLQ==
X-Gm-Message-State: AOAM530WbApfXN8mPf4UTIaliZIqQVgusuqIY3IpQjFGF1Tc885wUL/J
 g7irynKiXpkhXDELWJG6JdbdvU//2gcsZMSC3a1sgA==
X-Google-Smtp-Source: ABdhPJwxe4ROo4pJKyCW8GvGf0UwCWi8Cc6Xt9Bo9sWnzPx9YXaV4yhm5kpG3LgnK36VFpltmyhSXL2oN+p0CXGrQYc=
X-Received: by 2002:ac2:42c6:: with SMTP id n6mr35910253lfl.553.1638812356891; 
 Mon, 06 Dec 2021 09:39:16 -0800 (PST)
MIME-Version: 1.0
References: <20211123210109.1605642-1-oupton@google.com>
 <20211123210109.1605642-4-oupton@google.com>
 <87sfvfmb8d.wl-maz@kernel.org>
In-Reply-To: <87sfvfmb8d.wl-maz@kernel.org>
From: Oliver Upton <oupton@google.com>
Date: Mon, 6 Dec 2021 11:39:05 -0600
Message-ID: <CAOQ_QshFFOwyK-Uf3HqHoEpuj5Jv9opUspSmcHdTwkr1vNS1vA@mail.gmail.com>
Subject: Re: [PATCH v3 3/6] KVM: arm64: Allow guest to set the OSLK bit
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, Peter Shier <pshier@google.com>,
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

On Mon, Nov 29, 2021 at 5:51 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Tue, 23 Nov 2021 21:01:06 +0000,
> Oliver Upton <oupton@google.com> wrote:
> >
> > Allow writes to OSLAR and forward the OSLK bit to OSLSR. Do nothing with
> > the value for now.
> >
> > Reviewed-by: Reiji Watanabe <reijiw@google.com>
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > ---
> >  arch/arm64/include/asm/sysreg.h |  6 ++++++
> >  arch/arm64/kvm/sys_regs.c       | 33 ++++++++++++++++++++++++++-------
> >  2 files changed, 32 insertions(+), 7 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> > index 16b3f1a1d468..9fad61a82047 100644
> > --- a/arch/arm64/include/asm/sysreg.h
> > +++ b/arch/arm64/include/asm/sysreg.h
> > @@ -129,7 +129,13 @@
> >  #define SYS_DBGWCRn_EL1(n)           sys_reg(2, 0, 0, n, 7)
> >  #define SYS_MDRAR_EL1                        sys_reg(2, 0, 1, 0, 0)
> >  #define SYS_OSLAR_EL1                        sys_reg(2, 0, 1, 0, 4)
> > +
> > +#define SYS_OSLAR_OSLK                       BIT(0)
> > +
> >  #define SYS_OSLSR_EL1                        sys_reg(2, 0, 1, 1, 4)
> > +
> > +#define SYS_OSLSR_OSLK                       BIT(1)
> > +
> >  #define SYS_OSDLR_EL1                        sys_reg(2, 0, 1, 3, 4)
> >  #define SYS_DBGPRCR_EL1                      sys_reg(2, 0, 1, 4, 4)
> >  #define SYS_DBGCLAIMSET_EL1          sys_reg(2, 0, 7, 8, 6)
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 7bf350b3d9cd..5dbdb45d6d44 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -44,6 +44,10 @@
> >   * 64bit interface.
> >   */
> >
> > +static int reg_from_user(u64 *val, const void __user *uaddr, u64 id);
> > +static int reg_to_user(void __user *uaddr, const u64 *val, u64 id);
> > +static u64 sys_reg_to_index(const struct sys_reg_desc *reg);
> > +
> >  static bool read_from_write_only(struct kvm_vcpu *vcpu,
> >                                struct sys_reg_params *params,
> >                                const struct sys_reg_desc *r)
> > @@ -287,6 +291,24 @@ static bool trap_loregion(struct kvm_vcpu *vcpu,
> >       return trap_raz_wi(vcpu, p, r);
> >  }
> >
> > +static bool trap_oslar_el1(struct kvm_vcpu *vcpu,
> > +                        struct sys_reg_params *p,
> > +                        const struct sys_reg_desc *r)
> > +{
> > +     u64 oslsr;
> > +
> > +     if (!p->is_write)
> > +             return read_from_write_only(vcpu, p, r);
> > +
> > +     /* Forward the OSLK bit to OSLSR */
> > +     oslsr = __vcpu_sys_reg(vcpu, OSLSR_EL1) & ~SYS_OSLSR_OSLK;
> > +     if (p->regval & SYS_OSLAR_OSLK)
> > +             oslsr |= SYS_OSLSR_OSLK;
> > +
> > +     __vcpu_sys_reg(vcpu, OSLSR_EL1) = oslsr;
> > +     return true;
> > +}
> > +
> >  static bool trap_oslsr_el1(struct kvm_vcpu *vcpu,
> >                          struct sys_reg_params *p,
> >                          const struct sys_reg_desc *r)
> > @@ -309,9 +331,10 @@ static int set_oslsr_el1(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> >       if (err)
> >               return err;
> >
> > -     if (val != rd->val)
> > +     if ((val & ~SYS_OSLSR_OSLK) != rd->val)
> >               return -EINVAL;
>
> This looks odd. It means that once I have set the lock from userspace,
> I can't clear it?

This does read weird, but I believe it makes sense still. rd->val is
the value of the register after warm reset, and does not store the
current value of the actual register. The true value is stashed in
kvm_cpu_context. Really, what I'm asserting here is that the only RW
bit is the OSLK bit. If any of the other bits are changed it should
return an error.

I can either add a comment or make a macro for the expected register
value (or both) to make this more clear.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
