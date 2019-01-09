From: Amit Daniel Kachhap <amit.kachhap@arm.com>
Subject: Re: [PATCH v4 4/6] arm64/kvm: enable pointer authentication
 cpufeature conditionally
Date: Wed, 9 Jan 2019 15:46:25 +0530
Message-ID: <CADGdYn6KxdPXdFEgMfVbiynCnq+ODAQUgKHC6AseNEB-i3QHnw@mail.gmail.com>
References: <1545119810-12182-1-git-send-email-amit.kachhap@arm.com>
 <1545119810-12182-5-git-send-email-amit.kachhap@arm.com> <33542a00-23f4-b159-91f5-f05d3afa5b9f@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <33542a00-23f4-b159-91f5-f05d3afa5b9f@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Morse <james.morse@arm.com>
Cc: LAK <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>, kvmarm@lists.cs.columbia.edu, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, Dave Martin <Dave.Martin@arm.com>, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On Fri, Jan 4, 2019 at 11:32 PM James Morse <james.morse@arm.com> wrote:
>
> Hi Amit,
>
> On 18/12/2018 07:56, Amit Daniel Kachhap wrote:
> > According to userspace settings, pointer authentication cpufeature
> > is enabled/disabled from guests.
>
> This reads like the guest is changing something in the host. Isn't this hiding
> the id-register values from the guest?
>
>
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 6af6c7d..ce6144a 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -1066,6 +1066,15 @@ static u64 read_id_reg(struct sys_reg_desc const *r, bool raz)
> >                       kvm_debug("SVE unsupported for guests, suppressing\n");
> >
> >               val &= ~(0xfUL << ID_AA64PFR0_SVE_SHIFT);
> > +     } else if (id == SYS_ID_AA64ISAR1_EL1) {
> > +             const u64 ptrauth_mask = (0xfUL << ID_AA64ISAR1_APA_SHIFT) |
> > +                                      (0xfUL << ID_AA64ISAR1_API_SHIFT) |
> > +                                      (0xfUL << ID_AA64ISAR1_GPA_SHIFT) |
> > +                                      (0xfUL << ID_AA64ISAR1_GPI_SHIFT);
> > +             if (!kvm_arm_vcpu_ptrauth_allowed(vcpu)) {
> > +                     kvm_debug("ptrauth unsupported for guests, suppressing\n");
> > +                     val &= ~ptrauth_mask;
> > +             }
>
> I think this hunk should have been in the previous patch as otherwise its a
> bisection oddity.
>
> Could you merge this hunk with the previous patch, and move the mechanical bits
> that pass vcpu around to a prior preparatory patch.
Yes will do.
>
> (I'm still unsure if we need to hide this as a user-controlled policy)
>
>
> Thanks,
>
> James
//Amit
