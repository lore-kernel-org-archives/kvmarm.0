From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v2 1/2] KVM: arm64: Filter out invalid core register IDs
 in KVM_GET_REG_LIST
Date: Tue, 18 Dec 2018 17:28:10 +0000
Message-ID: <CAFEAcA_VnW4V9h+dkDxEjUk1dX1Tv_NrwzP14JyqV25+KyyFJw@mail.gmail.com>
References: <1544645824-16461-1-git-send-email-Dave.Martin@arm.com>
 <1544645824-16461-2-git-send-email-Dave.Martin@arm.com> <822638a1-dbf0-ed4a-55a4-b908a4f13649@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <822638a1-dbf0-ed4a-55a4-b908a4f13649@arm.com>
Sender: stable-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Dave P Martin <Dave.Martin@arm.com>, kvmarm@lists.cs.columbia.edu, Christoffer Dall <christoffer.dall@arm.com>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, stable@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, 18 Dec 2018 at 14:00, Marc Zyngier <marc.zyngier@arm.com> wrote:
>
> On 12/12/2018 20:17, Dave Martin wrote:
> > Since commit d26c25a9d19b ("arm64: KVM: Tighten guest core register
> > access from userspace"), KVM_{GET,SET}_ONE_REG rejects register IDs
> > that do not correspond to a single underlying architectural register.
> >
> > KVM_GET_REG_LIST was not changed to match however: instead, it
> > simply yields a list of 32-bit register IDs that together cover the
> > whole kvm_regs struct.  This means that if userspace tries to use
> > the resulting list of IDs directly to drive calls to KVM_*_ONE_REG,
> > some of those calls will now fail.
> >
> > This was not the intention.  Instead, iterating KVM_*_ONE_REG over
> > the list of IDs returned by KVM_GET_REG_LIST should be guaranteed
> > to work.
> >
> > This patch fixes the problem by splitting validate_core_reg_id()
> > into a backend core_reg_size_from_offset() which does all of the
> > work except for checking that the size field in the register ID
> > matches, and kvm_arm_copy_reg_indices() and num_core_regs() are
> > converted to use this to enumerate the valid offsets.
> >
> > kvm_arm_copy_reg_indices() now also sets the register ID size field
> > appropriately based on the value returned, so the register ID
> > supplied to userspace is fully qualified for use with the register
> > access ioctls.
> >
> > Cc: stable@vger.kernel.org
> > Fixes: d26c25a9d19b ("arm64: KVM: Tighten guest core register access from userspace")
> > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > ---

> I'm quite keen on queuing this for 4.21, but I'd like Peter's seal of
> approval on it.
>
> Peter?

Sounds plausible, but I'm on holiday now til January, so if you
want a more detailed response than that (or even actual testing
with QEMU) it'll have to wait til next year. (Note that I never
tested d26c25a9d19b with QEMU either...)

thanks
-- PMM
