From: Dave P Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v6 4/6] arm64/kvm: add a userspace option to enable
 pointer authentication
Date: Fri, 1 Mar 2019 12:22:13 +0000
Message-ID: <20190301122211.GT16031@e103592.cambridge.arm.com>
References: <1550568271-5319-1-git-send-email-amit.kachhap@arm.com>
 <1550568271-5319-5-git-send-email-amit.kachhap@arm.com>
 <20190221155350.GY3567@e103592.cambridge.arm.com>
 <56edb86f-7205-4714-823a-d26005d175ab@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F90F4A456
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Mar 2019 07:22:18 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LpU1kb44oF9j for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Mar 2019 07:22:17 -0500 (EST)
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
 (mail-eopbgr130079.outbound.protection.outlook.com [40.107.13.79])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AE65C4A408
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Mar 2019 07:22:16 -0500 (EST)
In-Reply-To: <56edb86f-7205-4714-823a-d26005d175ab@arm.com>
Content-Language: en-US
Content-ID: <54399122237D6D478067621271C8CF64@eurprd08.prod.outlook.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Amit Kachhap <Amit.Kachhap@arm.com>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>, Catalin Marinas <Catalin.Marinas@arm.com>, Will Deacon <Will.Deacon@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kristina Martsenko <Kristina.Martsenko@arm.com>, Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Mar 01, 2019 at 09:41:20AM +0000, Amit Daniel Kachhap wrote:
> Hi,
>
> On 2/21/19 9:23 PM, Dave Martin wrote:
> > On Tue, Feb 19, 2019 at 02:54:29PM +0530, Amit Daniel Kachhap wrote:
> >> This feature will allow the KVM guest to allow the handling of
> >> pointer authentication instructions or to treat them as undefined
> >> if not set. It uses the existing vcpu API KVM_ARM_VCPU_INIT to
> >> supply this parameter instead of creating a new API.
> >>
> >> A new register is not created to pass this parameter via
> >> SET/GET_ONE_REG interface as just a flag (KVM_ARM_VCPU_PTRAUTH)
> >> supplied is enough to enable this feature.
> >>
> >> Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
> >> Cc: Mark Rutland <mark.rutland@arm.com>
> >> Cc: Marc Zyngier <marc.zyngier@arm.com>
> >> Cc: Christoffer Dall <christoffer.dall@arm.com>
> >> Cc: kvmarm@lists.cs.columbia.edu

[...]

> >> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> >> index 12529df..f7bcc60 100644
> >> --- a/arch/arm64/kvm/sys_regs.c
> >> +++ b/arch/arm64/kvm/sys_regs.c
> >> @@ -1055,7 +1055,7 @@ static bool access_cntp_cval(struct kvm_vcpu *vcpu,
> >>   }
> >>
> >>   /* Read a sanitised cpufeature ID register by sys_reg_desc */
> >> -static u64 read_id_reg(struct sys_reg_desc const *r, bool raz)
> >> +static u64 read_id_reg(struct kvm_vcpu *vcpu, struct sys_reg_desc const *r, bool raz)
> >>   {
> >>   u32 id = sys_reg((u32)r->Op0, (u32)r->Op1,
> >>    (u32)r->CRn, (u32)r->CRm, (u32)r->Op2);
> >> @@ -1071,7 +1071,7 @@ static u64 read_id_reg(struct sys_reg_desc const *r, bool raz)
> >>    (0xfUL << ID_AA64ISAR1_API_SHIFT) |
> >>    (0xfUL << ID_AA64ISAR1_GPA_SHIFT) |
> >>    (0xfUL << ID_AA64ISAR1_GPI_SHIFT);
> >> -if (!kvm_supports_ptrauth()) {
> >> +if (!kvm_arm_vcpu_ptrauth_allowed(vcpu)) {
> >>   kvm_debug("ptrauth unsupported for guests, suppressing\n");
> >>   val &= ~ptrauth_mask;
> >>   }
> >> @@ -1095,7 +1095,7 @@ static bool __access_id_reg(struct kvm_vcpu *vcpu,
> >>   if (p->is_write)
> >>   return write_to_read_only(vcpu, p, r);
> >>
> >> -p->regval = read_id_reg(r, raz);
> >> +p->regval = read_id_reg(vcpu, r, raz);
> >>   return true;
> >>   }
> >
> > The SVE KVM series makes various overlapping changes to propagate vcpuo
> > into the relevant places, but hopefully the rebase is not too painful.
> > Many of the changes are probably virtually identical between the two
> > series.
> >
> > See for example [1].  Maybe you could cherry-pick and drop the
> > equivalent changes here (though if your series is picked up first, I
> > will live with it ;)
> Yes no issue. I will cherry-pick your specific patch and rebase mine on it.

OK, thanks.

Unfortunately it is likely to churn a bit due to review-- my v6 series
will rename some stuff.  Hopefully it will be stable from then on.

Cheers
---Dave
IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium. Thank you.
