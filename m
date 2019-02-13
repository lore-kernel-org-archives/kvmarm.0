From: Dave P Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v5 5/5] arm64/kvm: control accessibility of ptrauth key
 registers
Date: Wed, 13 Feb 2019 17:54:31 +0000
Message-ID: <20190213175428.GR32634@e103592.cambridge.arm.com>
References: <1548658727-14271-1-git-send-email-amit.kachhap@arm.com>
 <1548658727-14271-6-git-send-email-amit.kachhap@arm.com>
 <6ddfa9ae-5c98-540e-b4aa-8149c8515c9e@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D9A749E3E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Feb 2019 12:54:37 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pwBLnOvXTuJ6 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Feb 2019 12:54:35 -0500 (EST)
Received: from EUR03-DB5-obe.outbound.protection.outlook.com
 (mail-eopbgr40088.outbound.protection.outlook.com [40.107.4.88])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 31A0A40A52
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Feb 2019 12:54:35 -0500 (EST)
In-Reply-To: <6ddfa9ae-5c98-540e-b4aa-8149c8515c9e@arm.com>
Content-Language: en-US
Content-ID: <7CCFAA3A6CDAE249A322E913752952E1@eurprd08.prod.outlook.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Kristina Martsenko <Kristina.Martsenko@arm.com>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>, Catalin Marinas <Catalin.Marinas@arm.com>, Will Deacon <Will.Deacon@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>, Amit Kachhap <Amit.Kachhap@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Feb 13, 2019 at 05:35:46PM +0000, Kristina Martsenko wrote:
> On 28/01/2019 06:58, Amit Daniel Kachhap wrote:
> > According to userspace settings, ptrauth key registers are conditionally
> > present in guest system register list based on user specified flag
> > KVM_ARM_VCPU_PTRAUTH.
> >
> > Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
> > Cc: Mark Rutland <mark.rutland@arm.com>
> > Cc: Christoffer Dall <christoffer.dall@arm.com>
> > Cc: Marc Zyngier <marc.zyngier@arm.com>
> > Cc: Kristina Martsenko <kristina.martsenko@arm.com>
> > Cc: kvmarm@lists.cs.columbia.edu
> > Cc: Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>
> > Cc: Will Deacon <will.deacon@arm.com>
> > ---
> >  Documentation/arm64/pointer-authentication.txt |  3 ++
> >  arch/arm64/kvm/sys_regs.c                      | 42 +++++++++++++++++++-------
> >  2 files changed, 34 insertions(+), 11 deletions(-)
> >

[...]

> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c

[...]

> > @@ -2487,18 +2493,22 @@ static int walk_one_sys_reg(const struct sys_reg_desc *rd,
> >  }
> >
> >  /* Assumed ordered tables, see kvm_sys_reg_table_init. */
> > -static int walk_sys_regs(struct kvm_vcpu *vcpu, u64 __user *uind)
> > +static int walk_sys_regs(struct kvm_vcpu *vcpu, u64 __user *uind,
> > +const struct sys_reg_desc *desc, unsigned int len)
> >  {
> >  const struct sys_reg_desc *i1, *i2, *end1, *end2;
> >  unsigned int total = 0;
> >  size_t num;
> >  int err;
> >
> > +if (desc == ptrauth_reg_descs && !kvm_arm_vcpu_ptrauth_allowed(vcpu))
> > +return total;
> > +
> >  /* We check for duplicates here, to allow arch-specific overrides. */
> >  i1 = get_target_table(vcpu->arch.target, true, &num);
> >  end1 = i1 + num;
> > -i2 = sys_reg_descs;
> > -end2 = sys_reg_descs + ARRAY_SIZE(sys_reg_descs);
> > +i2 = desc;
> > +end2 = desc + len;
> >
> >  BUG_ON(i1 == end1 || i2 == end2);
> >
> > @@ -2526,7 +2536,10 @@ unsigned long kvm_arm_num_sys_reg_descs(struct kvm_vcpu *vcpu)
> >  {
> >  return ARRAY_SIZE(invariant_sys_regs)
> >  + num_demux_regs()
> > -+ walk_sys_regs(vcpu, (u64 __user *)NULL);
> > ++ walk_sys_regs(vcpu, (u64 __user *)NULL, sys_reg_descs,
> > +ARRAY_SIZE(sys_reg_descs))
> > ++ walk_sys_regs(vcpu, (u64 __user *)NULL, ptrauth_reg_descs,
> > +ARRAY_SIZE(ptrauth_reg_descs));
> >  }
> >
> >  int kvm_arm_copy_sys_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
> > @@ -2541,7 +2554,12 @@ int kvm_arm_copy_sys_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
> >  uindices++;
> >  }
> >
> > -err = walk_sys_regs(vcpu, uindices);
> > +err = walk_sys_regs(vcpu, uindices, sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
> > +if (err < 0)
> > +return err;
> > +uindices += err;
> > +
> > +err = walk_sys_regs(vcpu, uindices, ptrauth_reg_descs, ARRAY_SIZE(ptrauth_reg_descs));
> >  if (err < 0)
> >  return err;
> >  uindices += err;
> > @@ -2575,6 +2593,7 @@ void kvm_sys_reg_table_init(void)
> >  BUG_ON(check_sysreg_table(cp15_regs, ARRAY_SIZE(cp15_regs)));
> >  BUG_ON(check_sysreg_table(cp15_64_regs, ARRAY_SIZE(cp15_64_regs)));
> >  BUG_ON(check_sysreg_table(invariant_sys_regs, ARRAY_SIZE(invariant_sys_regs)));
> > +BUG_ON(check_sysreg_table(ptrauth_reg_descs, ARRAY_SIZE(ptrauth_reg_descs)));
> >
> >  /* We abuse the reset function to overwrite the table itself. */
> >  for (i = 0; i < ARRAY_SIZE(invariant_sys_regs); i++)
> > @@ -2616,6 +2635,7 @@ void kvm_reset_sys_regs(struct kvm_vcpu *vcpu)
> >
> >  /* Generic chip reset first (so target could override). */
> >  reset_sys_reg_descs(vcpu, sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
> > +reset_sys_reg_descs(vcpu, ptrauth_reg_descs, ARRAY_SIZE(ptrauth_reg_descs));
> >
> >  table = get_target_table(vcpu->arch.target, true, &num);
> >  reset_sys_reg_descs(vcpu, table, num);
>
> This isn't very scalable, since we'd need to duplicate all the above
> code every time we add new system registers that are conditionally
> accessible.

Agreed, putting feature-specific checks in walk_sys_regs() is probably
best avoided.  Over time we would likely accumulate a fair number of
these checks.

> It seems that the SVE patches [1] solved this problem by adding a
> check_present() callback into struct sys_reg_desc. It probably makes
> sense to rebase onto that patch and just implement the callback for the
> ptrauth key registers as well.
>
> [1] https://lore.kernel.org/linux-arm-kernel/1547757219-19439-13-git-send-email-Dave.Martin@arm.com/

Note, I'm currently refactoring this so that enumeration through
KVM_GET_REG_LIST can be disabled independently of access to the
register.  This may not be the best approach, but for SVE I have a
feature-specific ID register to handle too (ID_AA64ZFR0_EL1), which
needs to be hidden from the enumeration but still accessible with
read-as-zero behaviour.

This changes the API a bit: I move to a .restrictions() callback which
returns flags to say what is disabled, and this callback is used in the
common code so that you don't have repeat your "feature present" check
in every accessor, as is currently the case.

I'm aiming to post a respun series in the next day or two.  The code
may of course change again after it gets reviewed...


Basing on [1] is probably a reasonable starting point, though.

Cheers
---Dave
IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium. Thank you.
