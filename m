Return-Path: <SRS0=oZIB=PX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B06BC433F5
	for <kvmarm@archiver.kernel.org>; Thu,  4 Nov 2021 03:47:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0B34A61166
	for <kvmarm@archiver.kernel.org>; Thu,  4 Nov 2021 03:47:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0B34A61166
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 561D44B191;
	Wed,  3 Nov 2021 23:47:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8yWdZTC4gEYr; Wed,  3 Nov 2021 23:47:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 823A94B10A;
	Wed,  3 Nov 2021 23:47:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C1594B0F7
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 23:47:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zxpXWWM1WrGt for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Nov 2021 23:47:48 -0400 (EDT)
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com
 [209.85.214.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3B3BE4B0F5
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 23:47:48 -0400 (EDT)
Received: by mail-pl1-f176.google.com with SMTP id t21so5065589plr.6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 03 Nov 2021 20:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=M0r2p3OOH61oDyvN0PBFDZ4Q0DOlfJgJGVtNc++dJCk=;
 b=mr/KTiNxbDQ4evUG6tUYsyusqMMA37EOsr4ukvw9saX7asucZVYuLBKZI2eht4aPKh
 LthpBG576+NU1DQ8S/EDEtUzOXqIgljstx6070WVHOAkqzbw8IQuSJxktCYuTmNZ65kG
 9NWEDhWL9C6eASsgSelnsnmVvCW0OkHDrIakow//p+o8FVyIlXCdAsMTaxZ2PWSyA3Ks
 bL1r3jAOsQo789iAq7CNU+iwsPCBqbZTj2RZgfuPQN8b/UgkfPdXD3dWW68UvGijRC6G
 NBFpDMLgCAQIywWnO18+ATgJD7R6zenlmHpdFUYf3R3Xow31PL/jaEyO6GkNVXyvE/v/
 dUkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=M0r2p3OOH61oDyvN0PBFDZ4Q0DOlfJgJGVtNc++dJCk=;
 b=jGZeHCMxUzcXl1Oqvlfhp/SpJYEGtzc/toPvk76MLjXm2A2nGd3y0+ObTpS5qHV3jH
 nAgnFGVtgWF1p/pdLhaSikuqaO0Oi8gwa2tC4dgoM4Bqo1slByMBaHjosvS7tD2ti24X
 dMxCHnY9O0aIJiszElzmZL7f6XJ7FuuYfMg1a3eY4+XYaPUjgwrb2aiAF3fN/c8aKkxT
 aCLaqBMOiDLDosGO3cen8MEcjb5h2bCRHM7x/ajM9OAAp7DIoYYXdpRH8qSZy2AUawSS
 /Hi7vEIY3bGnXdoyuNEr4EXTHx5mxo5S6NroA6j9wMTaEZH9h8JnxIOH5neS0qnENnfR
 YDZQ==
X-Gm-Message-State: AOAM5309mUHUNzt74Hp7Ji5WZLVbyvmqSvqY9blowi56c76hKIibsOE4
 qTKioitSfgwj9jIbnoe24g6n5g==
X-Google-Smtp-Source: ABdhPJwlHPu6tW1vJnStRsXPTMgK4BsJQmRUJd5P2uIIae7yUo0eCPgGaA0mOKtJjyoNIGwo7FfonA==
X-Received: by 2002:a17:902:a412:b0:140:a4a:4ba with SMTP id
 p18-20020a170902a41200b001400a4a04bamr42454941plq.52.1635997666974; 
 Wed, 03 Nov 2021 20:47:46 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150])
 by smtp.gmail.com with ESMTPSA id f22sm2932671pgk.21.2021.11.03.20.47.46
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 03 Nov 2021 20:47:46 -0700 (PDT)
Date: Wed, 3 Nov 2021 20:47:42 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH v2 3/6] KVM: arm64: Allow guest to set the OSLK bit
Message-ID: <YYNX3t3yOL9LKKdP@google.com>
References: <20211102094651.2071532-1-oupton@google.com>
 <20211102094651.2071532-4-oupton@google.com>
 <CAAeT=FxdXX77kkANAgLX-xbsvjdeRtCZQ25dZQ1Rqw+-jU=_dg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAAeT=FxdXX77kkANAgLX-xbsvjdeRtCZQ25dZQ1Rqw+-jU=_dg@mail.gmail.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Wed, Nov 03, 2021 at 08:31:35PM -0700, Reiji Watanabe wrote:
> On Tue, Nov 2, 2021 at 2:47 AM Oliver Upton <oupton@google.com> wrote:
> >
> > Allow writes to OSLAR and forward the OSLK bit to OSLSR. Change the
> > reset value of the OSLK bit to 1. Allow the value to be migrated by
> > making OSLSR_EL1.OSLK writable from userspace.
> >
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > ---
> >  arch/arm64/include/asm/sysreg.h |  6 ++++++
> >  arch/arm64/kvm/sys_regs.c       | 35 +++++++++++++++++++++++++--------
> >  2 files changed, 33 insertions(+), 8 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> > index b268082d67ed..6ba4dc97b69d 100644
> > --- a/arch/arm64/include/asm/sysreg.h
> > +++ b/arch/arm64/include/asm/sysreg.h
> > @@ -127,7 +127,13 @@
> >  #define SYS_DBGWCRn_EL1(n)             sys_reg(2, 0, 0, n, 7)
> >  #define SYS_MDRAR_EL1                  sys_reg(2, 0, 1, 0, 0)
> >  #define SYS_OSLAR_EL1                  sys_reg(2, 0, 1, 0, 4)
> > +
> > +#define SYS_OSLAR_OSLK                 BIT(0)
> > +
> >  #define SYS_OSLSR_EL1                  sys_reg(2, 0, 1, 1, 4)
> > +
> > +#define SYS_OSLSR_OSLK                 BIT(1)
> > +
> >  #define SYS_OSDLR_EL1                  sys_reg(2, 0, 1, 3, 4)
> >  #define SYS_DBGPRCR_EL1                        sys_reg(2, 0, 1, 4, 4)
> >  #define SYS_DBGCLAIMSET_EL1            sys_reg(2, 0, 7, 8, 6)
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 0326b3df0736..acd8aa2e5a44 100644
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
> >                                  struct sys_reg_params *params,
> >                                  const struct sys_reg_desc *r)
> > @@ -287,6 +291,24 @@ static bool trap_loregion(struct kvm_vcpu *vcpu,
> >         return trap_raz_wi(vcpu, p, r);
> >  }
> >
> > +static bool trap_oslar_el1(struct kvm_vcpu *vcpu,
> > +                          struct sys_reg_params *p,
> > +                          const struct sys_reg_desc *r)
> > +{
> > +       u64 oslsr;
> > +
> > +       if (!p->is_write)
> > +               return read_from_write_only(vcpu, p, r);
> > +
> > +       /* Forward the OSLK bit to OSLSR */
> > +       oslsr = __vcpu_sys_reg(vcpu, OSLSR_EL1) & ~SYS_OSLSR_OSLK;
> > +       if (p->regval & SYS_OSLAR_OSLK)
> > +               oslsr |= SYS_OSLSR_OSLK;
> > +
> > +       __vcpu_sys_reg(vcpu, OSLSR_EL1) = oslsr;
> > +       return true;
> > +}
> > +
> >  static bool trap_oslsr_el1(struct kvm_vcpu *vcpu,
> >                            struct sys_reg_params *p,
> >                            const struct sys_reg_desc *r)
> > @@ -309,9 +331,10 @@ static int set_oslsr_el1(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> >         if (err)
> >                 return err;
> >
> > -       if (val != rd->val)
> > +       if ((val | SYS_OSLSR_OSLK) != rd->val)
> >                 return -EINVAL;
> >
> > +       __vcpu_sys_reg(vcpu, rd->reg) = val;
> >         return 0;
> >  }
> >
> > @@ -1176,10 +1199,6 @@ static bool access_raz_id_reg(struct kvm_vcpu *vcpu,
> >         return __access_id_reg(vcpu, p, r, true);
> >  }
> >
> > -static int reg_from_user(u64 *val, const void __user *uaddr, u64 id);
> > -static int reg_to_user(void __user *uaddr, const u64 *val, u64 id);
> > -static u64 sys_reg_to_index(const struct sys_reg_desc *reg);
> > -
> >  /* Visibility overrides for SVE-specific control registers */
> >  static unsigned int sve_visibility(const struct kvm_vcpu *vcpu,
> >                                    const struct sys_reg_desc *rd)
> > @@ -1456,8 +1475,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
> >         DBG_BCR_BVR_WCR_WVR_EL1(15),
> >
> >         { SYS_DESC(SYS_MDRAR_EL1), trap_raz_wi },
> > -       { SYS_DESC(SYS_OSLAR_EL1), trap_raz_wi },
> > -       { SYS_DESC(SYS_OSLSR_EL1), trap_oslsr_el1, reset_val, OSLSR_EL1, 0x00000008,
> > +       { SYS_DESC(SYS_OSLAR_EL1), trap_oslar_el1 },
> > +       { SYS_DESC(SYS_OSLSR_EL1), trap_oslsr_el1, reset_val, OSLSR_EL1, 0x0000000A,
> >                 .set_user = set_oslsr_el1, },
> 
> Reviewed-by: Reiji Watanabe <reijiw@google.com>
> 
> I assume the reason why you changed the reset value for the
> register is because Arm ARM says "the On a Cold reset,
> this field resets to 1".
> 
> "4.82 KVM_ARM_VCPU_INIT" in Documentation/virt/kvm/api.rst says:
> -------------------------------------------------------------
>   - System registers: Reset to their architecturally defined
>     values as for a warm reset to EL1 (resp. SVC)
> -------------------------------------------------------------
> 
> Since Arm ARM doesn't say anything about a warm reset for the field,
> I would guess the bit doesn't necessarily need to be set.

That would be great, because it would avoid the migration issue that
Oliver described in [PATCH v2 4/6]:

	There is an issue, though, with migration: older KVM will not show
	OSLSR_EL1 on KVM_GET_REG_LIST. However, in order to provide an
	architectural OS Lock, its reset value must be 1 (enabled). This would
	all have the effect of discarding the guest's OS lock value and
	blocking all debug exceptions intended for the guest until the next
	reboot.

> 
> Thanks,
> Reiji
> 
> 
> >         { SYS_DESC(SYS_OSDLR_EL1), trap_raz_wi },
> >         { SYS_DESC(SYS_DBGPRCR_EL1), trap_raz_wi },
> > @@ -1930,7 +1949,7 @@ static const struct sys_reg_desc cp14_regs[] = {
> >
> >         DBGBXVR(0),
> >         /* DBGOSLAR */
> > -       { Op1( 0), CRn( 1), CRm( 0), Op2( 4), trap_raz_wi },
> > +       { Op1( 0), CRn( 1), CRm( 0), Op2( 4), trap_oslar_el1 },
> >         DBGBXVR(1),
> >         /* DBGOSLSR */
> >         { Op1( 0), CRn( 1), CRm( 1), Op2( 4), trap_oslsr_el1, NULL, OSLSR_EL1 },
> > --
> > 2.33.1.1089.g2158813163f-goog
> >
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
