From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC 8/8] KVM: arm/arm64: Emulate the EL1 phys timer register
 access
Date: Tue, 10 Jan 2017 20:40:40 +0100
Message-ID: <20170110194040.GP4348@cbox>
References: <1482772326-29110-1-git-send-email-jintack@cs.columbia.edu>
 <1482772326-29110-9-git-send-email-jintack@cs.columbia.edu>
 <20170109121612.GG4348@cbox>
 <CAHyh4xhNUTuzaf=JJKidHj1fnOgoe_8aTZamnnGsc6C+iKL1BA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 142D240296
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Jan 2017 14:39:01 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iPnRdPZKq+Z9 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 Jan 2017 14:38:59 -0500 (EST)
Received: from mail-lf0-f46.google.com (mail-lf0-f46.google.com
 [209.85.215.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ABADE40295
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Jan 2017 14:38:59 -0500 (EST)
Received: by mail-lf0-f46.google.com with SMTP id o140so67595892lff.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Jan 2017 11:40:43 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <CAHyh4xhNUTuzaf=JJKidHj1fnOgoe_8aTZamnnGsc6C+iKL1BA@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Jintack Lim <jintack@cs.columbia.edu>
Cc: KVM General <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, will.deacon@arm.com, linux@armlinux.org.uk, linux-kernel@vger.kernel.org, andre.przywara@arm.com, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jan 10, 2017 at 12:36:36PM -0500, Jintack Lim wrote:
> On Mon, Jan 9, 2017 at 7:16 AM, Christoffer Dall
> <christoffer.dall@linaro.org> wrote:
> > On Mon, Dec 26, 2016 at 12:12:06PM -0500, Jintack Lim wrote:
> >> Emulate read and write operations to CNTP_TVAL, CNTP_CVAL and CNTP_CTL.
> >> Now the VM is able to use the EL1 physical timer.
> >>
> >> Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
> >> ---
> >>  arch/arm64/kvm/sys_regs.c    | 35 ++++++++++++++++++++++++++++++++---
> >>  include/kvm/arm_arch_timer.h |  3 +++
> >>  virt/kvm/arm/arch_timer.c    |  4 ++--
> >>  3 files changed, 37 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> >> index fd9e747..7cef94f 100644
> >> --- a/arch/arm64/kvm/sys_regs.c
> >> +++ b/arch/arm64/kvm/sys_regs.c
> >> @@ -824,7 +824,15 @@ static bool access_cntp_tval(struct kvm_vcpu *vcpu,
> >>               struct sys_reg_params *p,
> >>               const struct sys_reg_desc *r)
> >>  {
> >> -     kvm_inject_undefined(vcpu);
> >> +     struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
> >> +     cycle_t now = kvm_phys_timer_read();
> >> +
> >> +     if (p->is_write) {
> >> +             ptimer->cnt_cval = p->regval + now;
> >> +             kvm_timer_emulate(vcpu, ptimer);
> >
> > Hmm, do we really need those calls here?
> >
> > I guess I'm a little confused about exactly what the kvm_timer_emulate()
> > function is supposed to do, and it feels to me like these handlers
> > should just record what the guest is asking the kernel to do and the
> > logic of handling the additional timer should be moved into the run path
> > as much as possible.
> 
> I think it's a design decision. As you suggested, it's simple to do
> set up the background timer on entry to the VM, cancel it on exit, but
> since that's on the critical path it may have some impact on the
> performance, especially the world switch cost. To avoid
> canceling/setting up timer every world switch, I choose to schedule
> the physical timer here. I haven't compared the cost of the two
> alternatives, though.
> 

I'd definitely like to avoid us scheduling soft timers on the host if
that's not even necessary in the first place, so I'd like to get that
clear first, and as I said on the previous patch I think it's better to
get a working solution that we understand firt, and then optimize on
that later based on real results.

-Christoffer
