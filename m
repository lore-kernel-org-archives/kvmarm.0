From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [RFC PATCH v2 38/38] KVM: arm64: Respect the virtual
 CPTR_EL2.TCPAC setting
Date: Tue, 1 Aug 2017 13:20:29 +0200
Message-ID: <20170801112029.GD5176@cbox>
References: <1500397144-16232-1-git-send-email-jintack.lim@linaro.org>
 <1500397144-16232-39-git-send-email-jintack.lim@linaro.org>
 <20170731125920.GX5176@cbox>
 <CAHyh4xj8p0dCxv72jxYnTpmV8Ydhz2yvOLqpBHgDiyUcd6FUgg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHyh4xj8p0dCxv72jxYnTpmV8Ydhz2yvOLqpBHgDiyUcd6FUgg@mail.gmail.com>
Sender: linux-doc-owner@vger.kernel.org
To: Jintack Lim <jintack.lim@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Jonathan Corbet <corbet@lwn.net>, Paolo Bonzini <pbonzini@redhat.com>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, linux@armlinux.org.uk, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, akpm@linux-foundation.org, mchehab@kernel.org, cov@codeaurora.org, Daniel Lezcano <daniel.lezcano@linaro.org>, david.daney@cavium.com, mark.rutland@arm.com, Suzuki K Poulose <suzuki.poulose@arm.com>, stefan@hello-penguin.com, Andy Gross <andy.gross@linaro.org>, wcohen@redhat.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>, shankerd@codeaurora.org, vladimir.murzin@arm.com, james.morse@arm.com, linux-doc@vger.kernel.org, lkml
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Aug 01, 2017 at 07:03:35AM -0400, Jintack Lim wrote:
> Hi Christoffer,
> 
> On Mon, Jul 31, 2017 at 8:59 AM, Christoffer Dall <cdall@linaro.org> wrote:
> > On Tue, Jul 18, 2017 at 11:59:04AM -0500, Jintack Lim wrote:
> >> Forward CPACR_EL1 traps to the virtual EL2 if virtual CPTR_EL2 is
> >> configured to trap CPACR_EL1 accesses from EL1.
> >>
> >> This is for recursive nested virtualization.
> >>
> >> Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
> >> ---
> >>  arch/arm64/kvm/sys_regs.c | 5 +++++
> >>  1 file changed, 5 insertions(+)
> >>
> >> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> >> index 6f67666..ba2966d 100644
> >> --- a/arch/arm64/kvm/sys_regs.c
> >> +++ b/arch/arm64/kvm/sys_regs.c
> >> @@ -1091,6 +1091,11 @@ static bool access_cpacr(struct kvm_vcpu *vcpu,
> >>       if (el12_reg(p) && forward_nv_traps(vcpu))
> >>               return kvm_inject_nested_sync(vcpu, kvm_vcpu_get_hsr(vcpu));
> >>
> >> +     /* Forward this trap to the virtual EL2 if CPTR_EL2.TCPAC is set*/
> >> +     if (!el12_reg(p) && !vcpu_mode_el2(vcpu) &&
> >> +         (vcpu_sys_reg(vcpu, CPTR_EL2) & CPTR_EL2_TCPAC))
> >> +             return kvm_inject_nested_sync(vcpu, kvm_vcpu_get_hsr(vcpu));
> >> +
> >
> > I'm trying to understand what should happen if the VM is in EL1 and
> > accesses CPACR_EL12, but the guest hypervisor did not set
> > CPTR_EL2.TCPAC, why would we get here, and if there's a good reason why
> 
> I guess what you meant is HCR_EL2.NV bit?
> 

No, HCR_EL2.NV is set, then we obviously get here, due to traps on _EL12
registers.

But if that wasn't the case (that's the time you'd be avaluating this
if-statement), then you're checking as part of the if-statement if the
virtual CPTR_EL2.TCPAC is set.  My question is, if the virtual
CPTR_EL2.TCPAC is not set, why would the physical one be set, which must
be the case if we're running this code, right?

> > we god here, is the EL12 access not supposed to undef at EL1 as opposed

I obviously meant *got* here.

> > to actually work, like it seems your code does when it doesn't take the
> > branch?
> 
> IIUC, we need to have this logic
> 
> if (el12_reg() && virtual HCR_EL2.NV == 0)
>    inject_undef();
> 
> This is a good point, and should be applied for all traps controlled by NV bit.
> 

Yes, but can this ever happen?

Thanks,
-Christoffer
