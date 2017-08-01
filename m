From: Jintack Lim <jintack.lim@linaro.org>
Subject: Re: [RFC PATCH v2 08/38] KVM: arm64: Add EL2 special registers to
 vcpu context
Date: Tue, 1 Aug 2017 10:08:56 -0400
Message-ID: <CAHyh4xgkR4-UcqXoQFhcfv9dpMGRyh2QrdEMs7UK6=VR3qK+0w@mail.gmail.com>
References: <1500397144-16232-1-git-send-email-jintack.lim@linaro.org>
 <1500397144-16232-9-git-send-email-jintack.lim@linaro.org>
 <20170730195955.GG5176@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DF01B49C30
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Aug 2017 10:07:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bFI2Xk6YJPZN for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Aug 2017 10:07:43 -0400 (EDT)
Received: from mail-oi0-f54.google.com (mail-oi0-f54.google.com
 [209.85.218.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8C4C349C2C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Aug 2017 10:07:43 -0400 (EDT)
Received: by mail-oi0-f54.google.com with SMTP id x3so16255151oia.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 01 Aug 2017 07:08:59 -0700 (PDT)
Received: from mail-oi0-f53.google.com (mail-oi0-f53.google.com.
 [209.85.218.53])
 by smtp.gmail.com with ESMTPSA id s69sm37576548ois.15.2017.08.01.07.08.57
 for <kvmarm@lists.cs.columbia.edu>
 (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
 Tue, 01 Aug 2017 07:08:57 -0700 (PDT)
Received: by mail-oi0-f53.google.com with SMTP id e124so16214119oig.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 01 Aug 2017 07:08:57 -0700 (PDT)
In-Reply-To: <20170730195955.GG5176@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>
Cc: KVM General <kvm@vger.kernel.org>, david.daney@cavium.com, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, stefan@hello-penguin.com, Jonathan Corbet <corbet@lwn.net>, Daniel Lezcano <daniel.lezcano@linaro.org>, linux@armlinux.org.uk, arm-mail-list <linux-arm-kernel@lists.infradead.org>, Andy Gross <andy.gross@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, cov@codeaurora.org, wcohen@redhat.com, mchehab@kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-doc@vger.kernel.org, lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, akpm@linux-foundation.org
List-Id: kvmarm@lists.cs.columbia.edu

On Sun, Jul 30, 2017 at 3:59 PM, Christoffer Dall <cdall@linaro.org> wrote:
> On Tue, Jul 18, 2017 at 11:58:34AM -0500, Jintack Lim wrote:
>> To support the virtual EL2 execution, we need to maintain the EL2
>> special registers such as SPSR_EL2, ELR_EL2 and SP_EL2 in vcpu context.
>>
>> Note that SP_EL2 is not accessible in EL2, so we don't need a trap
>> handler for this register.
>
> Actually, it's not accessible *in the MRS/MSR instruction* but it is of
> course accessible as the current stack pointer (which is why you need
> the state, but not the trap handler).

That is correct. I'll fix the commit message.

>
> Otherwise, the patch looks good.

Thanks!

>
> Thanks,
> -Christoffer
>
>>
>> Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
>> ---
>>  arch/arm64/include/asm/kvm_host.h | 12 ++++++++++++
>>  arch/arm64/include/asm/sysreg.h   |  4 ++++
>>  arch/arm64/kvm/sys_regs.c         | 38 +++++++++++++++++++++++++++++++++-----
>>  arch/arm64/kvm/sys_regs.h         |  8 ++++++++
>>  4 files changed, 57 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index 1dc4ed6..57dccde 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -171,6 +171,15 @@ enum vcpu_sysreg {
>>       NR_SYS_REGS     /* Nothing after this line! */
>>  };
>>
>> +enum el2_special_regs {
>> +     __INVALID_EL2_SPECIAL_REG__,
>> +     SPSR_EL2,       /* Saved Program Status Register (EL2) */
>> +     ELR_EL2,        /* Exception Link Register (EL2) */
>> +     SP_EL2,         /* Stack Pointer (EL2) */
>> +
>> +     NR_EL2_SPECIAL_REGS
>> +};
>> +
>>  /* 32bit mapping */
>>  #define c0_MPIDR     (MPIDR_EL1 * 2) /* MultiProcessor ID Register */
>>  #define c0_CSSELR    (CSSELR_EL1 * 2)/* Cache Size Selection Register */
>> @@ -218,6 +227,8 @@ struct kvm_cpu_context {
>>               u64 sys_regs[NR_SYS_REGS];
>>               u32 copro[NR_COPRO_REGS];
>>       };
>> +
>> +     u64 el2_special_regs[NR_EL2_SPECIAL_REGS];
>>  };
>>
>>  typedef struct kvm_cpu_context kvm_cpu_context_t;
>> @@ -307,6 +318,7 @@ struct kvm_vcpu_arch {
>>
>>  #define vcpu_gp_regs(v)              (&(v)->arch.ctxt.gp_regs)
>>  #define vcpu_sys_reg(v,r)    ((v)->arch.ctxt.sys_regs[(r)])
>> +#define vcpu_el2_sreg(v,r)   ((v)->arch.ctxt.el2_special_regs[(r)])
>>  /*
>>   * CP14 and CP15 live in the same array, as they are backed by the
>>   * same system registers.
>> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
>> index 9277c4a..98c32ef 100644
>> --- a/arch/arm64/include/asm/sysreg.h
>> +++ b/arch/arm64/include/asm/sysreg.h
>> @@ -268,6 +268,8 @@
>>
>>  #define SYS_DACR32_EL2                       sys_reg(3, 4, 3, 0, 0)
>>
>> +#define SYS_SPSR_EL2                 sys_reg(3, 4, 4, 0, 0)
>> +#define SYS_ELR_EL2                  sys_reg(3, 4, 4, 0, 1)
>>  #define SYS_SP_EL1                   sys_reg(3, 4, 4, 1, 0)
>>
>>  #define SYS_IFSR32_EL2                       sys_reg(3, 4, 5, 0, 1)
>> @@ -332,6 +334,8 @@
>>  #define SYS_CNTVOFF_EL2                      sys_reg(3, 4, 14, 0, 3)
>>  #define SYS_CNTHCTL_EL2                      sys_reg(3, 4, 14, 1, 0)
>>
>> +#define SYS_SP_EL2                   sys_reg(3, 6, 4, 1, 0)
>> +
>>  /* Common SCTLR_ELx flags. */
>>  #define SCTLR_ELx_EE    (1 << 25)
>>  #define SCTLR_ELx_I  (1 << 12)
>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index 1568f8b..2b3ed70 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
>> @@ -900,15 +900,33 @@ static inline void access_rw(struct sys_reg_params *p, u64 *sysreg)
>>               *sysreg = p->regval;
>>  }
>>
>> +static u64 *get_special_reg(struct kvm_vcpu *vcpu, struct sys_reg_params *p)
>> +{
>> +     u64 reg = sys_reg(p->Op0, p->Op1, p->CRn, p->CRm, p->Op2);
>> +
>> +     switch (reg) {
>> +     case SYS_SP_EL1:
>> +             return &vcpu->arch.ctxt.gp_regs.sp_el1;
>> +     case SYS_ELR_EL2:
>> +             return &vcpu_el2_sreg(vcpu, ELR_EL2);
>> +     case SYS_SPSR_EL2:
>> +             return &vcpu_el2_sreg(vcpu, SPSR_EL2);
>> +     default:
>> +             return NULL;
>> +     };
>> +}
>> +
>>  static bool trap_el2_regs(struct kvm_vcpu *vcpu,
>>                        struct sys_reg_params *p,
>>                        const struct sys_reg_desc *r)
>>  {
>> -     /* SP_EL1 is NOT maintained in sys_regs array */
>> -     if (sys_reg(p->Op0, p->Op1, p->CRn, p->CRm, p->Op2) == SYS_SP_EL1)
>> -             access_rw(p, &vcpu->arch.ctxt.gp_regs.sp_el1);
>> -     else
>> -             access_rw(p, &vcpu_sys_reg(vcpu, r->reg));
>> +     u64 *sys_reg;
>> +
>> +     sys_reg = get_special_reg(vcpu, p);
>> +     if (!sys_reg)
>> +             sys_reg = &vcpu_sys_reg(vcpu, r->reg);
>> +
>> +     access_rw(p, sys_reg);
>>
>>       return true;
>>  }
>> @@ -1116,6 +1134,8 @@ static bool trap_el2_regs(struct kvm_vcpu *vcpu,
>>
>>       { SYS_DESC(SYS_DACR32_EL2), NULL, reset_unknown, DACR32_EL2 },
>>
>> +     { SYS_DESC(SYS_SPSR_EL2), trap_el2_regs, reset_special, SPSR_EL2, 0 },
>> +     { SYS_DESC(SYS_ELR_EL2), trap_el2_regs, reset_special, ELR_EL2, 0 },
>>       { SYS_DESC(SYS_SP_EL1), trap_el2_regs },
>>
>>       { SYS_DESC(SYS_IFSR32_EL2), NULL, reset_unknown, IFSR32_EL2 },
>> @@ -1138,6 +1158,8 @@ static bool trap_el2_regs(struct kvm_vcpu *vcpu,
>>
>>       { SYS_DESC(SYS_CNTVOFF_EL2), trap_el2_regs, reset_val, CNTVOFF_EL2, 0 },
>>       { SYS_DESC(SYS_CNTHCTL_EL2), trap_el2_regs, reset_val, CNTHCTL_EL2, 0 },
>> +
>> +     { SYS_DESC(SYS_SP_EL2), NULL, reset_special, SP_EL2, 0},
>>  };
>>
>>  static bool trap_dbgidr(struct kvm_vcpu *vcpu,
>> @@ -2271,6 +2293,8 @@ void kvm_reset_sys_regs(struct kvm_vcpu *vcpu)
>>
>>       /* Catch someone adding a register without putting in reset entry. */
>>       memset(&vcpu->arch.ctxt.sys_regs, 0x42, sizeof(vcpu->arch.ctxt.sys_regs));
>> +     memset(&vcpu->arch.ctxt.el2_special_regs, 0x42,
>> +            sizeof(vcpu->arch.ctxt.el2_special_regs));
>>
>>       /* Generic chip reset first (so target could override). */
>>       reset_sys_reg_descs(vcpu, sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
>> @@ -2281,4 +2305,8 @@ void kvm_reset_sys_regs(struct kvm_vcpu *vcpu)
>>       for (num = 1; num < NR_SYS_REGS; num++)
>>               if (vcpu_sys_reg(vcpu, num) == 0x4242424242424242)
>>                       panic("Didn't reset vcpu_sys_reg(%zi)", num);
>> +
>> +     for (num = 1; num < NR_EL2_SPECIAL_REGS; num++)
>> +             if (vcpu_el2_sreg(vcpu, num) == 0x4242424242424242)
>> +                     panic("Didn't reset vcpu_el2_sreg(%zi)", num);
>>  }
>> diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
>> index 060f534..827717b 100644
>> --- a/arch/arm64/kvm/sys_regs.h
>> +++ b/arch/arm64/kvm/sys_regs.h
>> @@ -99,6 +99,14 @@ static inline void reset_val(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r
>>       vcpu_sys_reg(vcpu, r->reg) = r->val;
>>  }
>>
>> +static inline void reset_special(struct kvm_vcpu *vcpu,
>> +                              const struct sys_reg_desc *r)
>> +{
>> +     BUG_ON(!r->reg);
>> +     BUG_ON(r->reg >= NR_EL2_SPECIAL_REGS);
>> +     vcpu_el2_sreg(vcpu, r->reg) = r->val;
>> +}
>> +
>>  static inline int cmp_sys_reg(const struct sys_reg_desc *i1,
>>                             const struct sys_reg_desc *i2)
>>  {
>> --
>> 1.9.1
>>
