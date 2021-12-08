Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30737C433EF
	for <kvmarm@archiver.kernel.org>; Wed,  8 Dec 2021 05:57:56 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 945994B105;
	Wed,  8 Dec 2021 00:57:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qhB5itaICLse; Wed,  8 Dec 2021 00:57:54 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4ED154B0E6;
	Wed,  8 Dec 2021 00:57:54 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 36E7E4B0E6
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Dec 2021 00:57:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EHeWVkbxjdFi for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Dec 2021 00:57:51 -0500 (EST)
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com
 [209.85.210.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3065A4B0B6
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Dec 2021 00:57:51 -0500 (EST)
Received: by mail-pf1-f174.google.com with SMTP id x5so1606426pfr.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 07 Dec 2021 21:57:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=4xExbZbYSIl7+isCfcQ0r5xhwgvFT61AQ+ndN1ml1Rc=;
 b=gT29oLzeevjk6z2PGvpVuz1CA/d+35zpdtN/kx3V68ESfFYMvuA4f+DwmzKe1mvAAK
 8UnUgGL2KXP5jh6lrP0BWNN0c/nAJEL2dCbm4ccWU8/EIMUpSMU/iQ/bgYUkG31+WwHP
 AZE4Vt//VAgpw53JVEs4EVZowhpqWiLO/UcfvIXH6Bmu/Tt7ShhBPoXabWXCRPimCB1v
 E8Vy7DPBtNGAfxPu9KbTbLubB/2f4q4478kVOrPyEpuHqlkGcIV/tCCyLOl/zArgHU+6
 QACq/3M6mBg/hqlOUWB2psEFGAs8MEPcMUFTBc2/oDAZGMrRaL2tek3cf5PFc7YA6OEL
 M7Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=4xExbZbYSIl7+isCfcQ0r5xhwgvFT61AQ+ndN1ml1Rc=;
 b=vrTw3lvOqmlZLSwI5WEpAOFp4F+ktR1UJ1Qf3AA2Hl87KGxZDvLROlrlxe/7GLAfJ7
 34NDudziSa5WnhKb7FAk0nS3I58a1/XKB/6ptA0dvQjnHISlDuZA6nKy8u6Fuh/vxZlm
 ihTkiYcQw689Fx0HcLM6pZRvrT5ccVrvWflhv/yeA+kHDyPby8TnjqeDdaBqAF/GcQhu
 PMK5n9nMfaWW0jIDr5LySNKdELckEZsJo7jPGL/42v7GWX9E4ouqYTMhEVXMwoY0+U1T
 aO8yZROQ996XUfr9tmAGN+Y7dGtp9YhwLltYU4uKNFktLzaEG9I6RhdCF2WDdKY5njyA
 xcnw==
X-Gm-Message-State: AOAM533T91bxxcfk7QPGFfWgjHzEobrws8eAfAlaTGxkDIEM2iZKLo3Y
 WvieKX4hzq8Oy+LZd674SmAjH8i+AuVtOqkpjbLl8Q==
X-Google-Smtp-Source: ABdhPJxog3kPZtqJ6petGP4FrRVJyn+G9uTEaIlF+0dV7QE4Gz49Ro7vWeaKxcvnSunSmfngitcgU7s1ur1MH/sH+2w=
X-Received: by 2002:a63:8b42:: with SMTP id j63mr27984759pge.514.1638943069917; 
 Tue, 07 Dec 2021 21:57:49 -0800 (PST)
MIME-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com>
 <20211117064359.2362060-3-reijiw@google.com>
 <9f6e8b7e-c2b3-5883-f934-5b537c4ce19b@redhat.com>
 <CAAeT=Fw+zW+CDnye+XzokmQtQYBfzrEEfLr=78UfFQZsQb_wuA@mail.gmail.com>
 <e0a5817e-27c1-8181-a595-f38c2d399b90@redhat.com>
In-Reply-To: <e0a5817e-27c1-8181-a595-f38c2d399b90@redhat.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Tue, 7 Dec 2021 21:57:33 -0800
Message-ID: <CAAeT=FzLt8ePO=-VguWp+CZmfab62P+5wcxyBHm3hoQgPd1x_w@mail.gmail.com>
Subject: Re: [RFC PATCH v3 02/29] KVM: arm64: Save ID registers' sanitized
 value per vCPU
To: Eric Auger <eauger@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

Hi Eric,

On Tue, Dec 7, 2021 at 1:34 AM Eric Auger <eauger@redhat.com> wrote:
>
> Hi Reiji,
>
> On 12/4/21 2:45 AM, Reiji Watanabe wrote:
> > Hi Eric,
> >
> > On Thu, Dec 2, 2021 at 2:58 AM Eric Auger <eauger@redhat.com> wrote:
> >>
> >> Hi Reiji,
> >>
> >> On 11/17/21 7:43 AM, Reiji Watanabe wrote:
> >>> Extend sys_regs[] of kvm_cpu_context for ID registers and save ID
> >>> registers' sanitized value in the array for the vCPU at the first
> >>> vCPU reset. Use the saved ones when ID registers are read by
> >>> userspace (via KVM_GET_ONE_REG) or the guest.
> >>>
> >>> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> >>> ---
> >>>  arch/arm64/include/asm/kvm_host.h | 10 +++++++
> >>>  arch/arm64/kvm/sys_regs.c         | 43 +++++++++++++++++++------------
> >>>  2 files changed, 37 insertions(+), 16 deletions(-)
> >>>
> >>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> >>> index edbe2cb21947..72db73c79403 100644
> >>> --- a/arch/arm64/include/asm/kvm_host.h
> >>> +++ b/arch/arm64/include/asm/kvm_host.h
> >>> @@ -146,6 +146,14 @@ struct kvm_vcpu_fault_info {
> >>>       u64 disr_el1;           /* Deferred [SError] Status Register */
> >>>  };
> >>>
> >>> +/*
> >>> + * (Op0, Op1, CRn, CRm, Op2) of ID registers is (3, 0, 0, crm, op2),
> >>> + * where 0<=crm<8, 0<=op2<8.
> >>> + */
> >>> +#define KVM_ARM_ID_REG_MAX_NUM 64
> >>> +#define IDREG_IDX(id)                ((sys_reg_CRm(id) << 3) | sys_reg_Op2(id))
> >>> +#define IDREG_SYS_IDX(id)    (ID_REG_BASE + IDREG_IDX(id))
> >>> +
> >>>  enum vcpu_sysreg {
> >>>       __INVALID_SYSREG__,   /* 0 is reserved as an invalid value */
> >>>       MPIDR_EL1,      /* MultiProcessor Affinity Register */
> >>> @@ -210,6 +218,8 @@ enum vcpu_sysreg {
> >>>       CNTP_CVAL_EL0,
> >>>       CNTP_CTL_EL0,
> >>>
> >>> +     ID_REG_BASE,
> >>> +     ID_REG_END = ID_REG_BASE + KVM_ARM_ID_REG_MAX_NUM - 1,
> >>>       /* Memory Tagging Extension registers */
> >>>       RGSR_EL1,       /* Random Allocation Tag Seed Register */
> >>>       GCR_EL1,        /* Tag Control Register */
> >>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> >>> index e3ec1a44f94d..5608d3410660 100644
> >>> --- a/arch/arm64/kvm/sys_regs.c
> >>> +++ b/arch/arm64/kvm/sys_regs.c
> >>> @@ -33,6 +33,8 @@
> >>>
> >>>  #include "trace.h"
> >>>
> >>> +static u64 __read_id_reg(const struct kvm_vcpu *vcpu, u32 id);
> >>> +
> >>>  /*
> >>>   * All of this file is extremely similar to the ARM coproc.c, but the
> >>>   * types are different. My gut feeling is that it should be pretty
> >>> @@ -273,7 +275,7 @@ static bool trap_loregion(struct kvm_vcpu *vcpu,
> >>>                         struct sys_reg_params *p,
> >>>                         const struct sys_reg_desc *r)
> >>>  {
> >>> -     u64 val = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
> >>> +     u64 val = __read_id_reg(vcpu, SYS_ID_AA64MMFR1_EL1);
> >>>       u32 sr = reg_to_encoding(r);
> >>>
> >>>       if (!(val & (0xfUL << ID_AA64MMFR1_LOR_SHIFT))) {
> >>> @@ -1059,17 +1061,9 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
> >>>       return true;
> >>>  }
> >>>
> >>> -/* Read a sanitised cpufeature ID register by sys_reg_desc */
> >>> -static u64 read_id_reg(const struct kvm_vcpu *vcpu,
> >>> -             struct sys_reg_desc const *r, bool raz)
> >>> +static u64 __read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
> >>>  {
> >>> -     u32 id = reg_to_encoding(r);
> >>> -     u64 val;
> >>> -
> >>> -     if (raz)
> >>> -             return 0;
> >>> -
> >>> -     val = read_sanitised_ftr_reg(id);
> >>> +     u64 val = __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id));
> >>>
> >>>       switch (id) {
> >>>       case SYS_ID_AA64PFR0_EL1:
> >>> @@ -1119,6 +1113,14 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
> >>>       return val;
> >>>  }
> >>>
> >>> +static u64 read_id_reg(const struct kvm_vcpu *vcpu,
> >>> +                    struct sys_reg_desc const *r, bool raz)
> >>> +{
> >>> +     u32 id = reg_to_encoding(r);
> >>> +
> >>> +     return raz ? 0 : __read_id_reg(vcpu, id);
> >>> +}
> >>> +
> >>>  static unsigned int id_visibility(const struct kvm_vcpu *vcpu,
> >>>                                 const struct sys_reg_desc *r)
> >>>  {
> >>> @@ -1178,6 +1180,16 @@ static unsigned int sve_visibility(const struct kvm_vcpu *vcpu,
> >>>       return REG_HIDDEN;
> >>>  }
> >>>
> >>> +static void reset_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd)
> >>> +{
> >>> +     u32 id = reg_to_encoding(rd);
> >>> +
> >>> +     if (vcpu_has_reset_once(vcpu))
> >>> +             return;
> >> The KVM API allows to call VCPU_INIT several times (with same
> >> target/feature). With above check on the second call the ID_REGS won't
> >> be reset. Somehow this is aligned with target/feature behavior. However
> >> if this is what we want, I think we would need to document it in the KVM
> >> API doc.
> >
> > Thank you for the comment.
> >
> > That is what we want.  Since ID registers are read only registers,
> > their values must not change across the reset.
> >
> > '4.82 KVM_ARM_VCPU_INIT' in api.rst says:
> >
> >   System registers: Reset to their architecturally defined
> >   values as for a warm reset to EL1 (resp. SVC)
> >
> > Since this reset behavior for the ID registers follows what is
> > described above, I'm not sure if we need to document the reset
> > behavior of the ID registers specifically.
> > If KVM changes the values across the resets, I would think it
> > rather needs to be documented though.
>
> Makes sense to freeze the ID REGs on the 1st reset. Was just wondering
> if we shouldn't add that the ID REG values are immutable after the 1st
> VCPU_INIT.

> Makes sense to freeze the ID REGs on the 1st reset. Was just wondering
> if we shouldn't add that the ID REG values are immutable after the 1st
> VCPU_INIT.

Even after the 1st VCPU_INIT, ID REG values can be changed by
KVM_SET_ONE_REG (KVM_SET_ONE_REG/KVM_GET_ONE_REG are allowed
only after the 1st VCPU_INIT).

The ID REG values are immutable after the 1st KVM_RUN,
and I think we should document that.  Is that what you meant ?

Thanks,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
