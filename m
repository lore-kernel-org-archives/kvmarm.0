From: Christoffer Dall <cdall@linaro.org>
Subject: Re: consult a question about 'inject_abt64()'
Date: Tue, 19 Sep 2017 00:32:56 +0200
Message-ID: <20170918223256.GI4657@cbox>
References: <a9ec4c60-a1b1-9535-89a2-30db4facaf1f@huawei.com>
 <D8D110F4-5AC4-4AEF-817B-038F506B8D7D@arm.com>
 <1f06664f-c60d-5551-70e7-13219210ef97@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1f06664f-c60d-5551-70e7-13219210ef97@huawei.com>
Sender: kvm-owner@vger.kernel.org
To: gengdongjiu <gengdongjiu@huawei.com>
Cc: Matt Evans <Matt.Evans@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, marc.zyngier@arm.com, linux@armlinux.org.uk, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, James Morse <James.Morse@arm.com>, catalin.marinas@arm.com, Huangshaoyu <huangshaoyu@huawei.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On Mon, Sep 18, 2017 at 09:49:25PM +0800, gengdongjiu wrote:
> To KVM mailing List about below question, thanks.
> 

[Please send properly formatted and written e-mails to this mailing
list instead of just forwarding a conversation withtout futher
explanation.  It would have been more helpful if you had suggested a
patch or at least explained what you concluded from your conversation
with Matt.]

I don't think there's a problem here, because the ESR values are defined
as

#define ESR_ELx_EC_IABT_LOW▸    (0x20)
#define ESR_ELx_EC_IABT_CUR▸    (0x21)
...
#define ESR_ELx_EC_DABT_LOW▸    (0x24)
#define ESR_ELx_EC_DABT_CUR▸    (0x25)

and we just or on the differating bit for a data abort:

if (!is_iabt)
	esr |= ESR_ELx_EC_DABT_LOW << ESR_ELx_EC_SHIFT;

So you'll see that ESR_ELx_EC_IABT_LOW and ESR_ELx_EC_IABT_CUR become
ESR_ELx_EC_DABT_LOW and ESR_ELx_EC_DABT_CUR, respectively.

Thanks,
-Christoffer

> 
> 
> On 2017/9/18 21:17, Matt Evans wrote:
> > Hi Gengdongjiu,
> > 
> > 
> >> On 18 Sep 2017, at 07:39, gengdongjiu <gengdongjiu@huawei.com> wrote:
> >>
> >> Hi Matt,
> >>   sorry to disturb you, I want to consult you a question about the function inject_abt64();
> >> For this function, the abort EC can be ESR_ELx_EC_DABT_LOW or ESR_ELx_EC_DABT_CUR according to *vcpu_cpsr(vcpu);
> >> why it always ESR_ELx_EC_DABT_LOW?  thanks!
> >>
> >> As you can see the Iabort, when injecting the Iabort, it will check the cpsr to decide to inject the ESR_ELx_EC_IABT_LOW or ESR_ELx_EC_IABT_CUR.
> >> but I do not know why the Dabort will always be ESR_ELx_EC_DABT_LOW when injecting.
> >>
> >>        /*
> >>         * Here, the guest runs in AArch64 mode when in EL1. If we get
> >>         * an AArch32 fault, it means we managed to trap an EL0 fault.
> >>         */
> >>        if (is_aarch32 || (cpsr & PSR_MODE_MASK) == PSR_MODE_EL0t)
> >>                esr |= (ESR_ELx_EC_IABT_LOW << ESR_ELx_EC_SHIFT);
> >>        else
> >>                esr |= (ESR_ELx_EC_IABT_CUR << ESR_ELx_EC_SHIFT);
> > 
> > I think you're right.  When I fixed that line I had noticed the lack of left-shift but didn't think about the actual ESR value.
> > 
> > The injected vector is calculated correctly (between current-EL or lower-EL vectors) by get_except_vector() but the EC should also correspond to current-EL or lower-EL.
> > 
> > It is worth following this up on the ARM KVM mailing list!  (To be fair, your question should have been sent there too :) )
> > 
> > Thanks,
> > 
> > 
> > Matt
> > 
> > 
> > 
> >>
> >>
> >>
> >> commit e4fe9e7dc3828bf6a5714eb3c55aef6260d823a2
> >> Author: Matt Evans <matt.evans@arm.com>
> >> Date:   Mon May 16 13:54:56 2016 +0100
> >>
> >>    kvm: arm64: Fix EC field in inject_abt64
> >>
> >>    The EC field of the constructed ESR is conditionally modified by ORing in
> >>    ESR_ELx_EC_DABT_LOW for a data abort.  However, ESR_ELx_EC_SHIFT is missing
> >>    from this condition.
> >>
> >>    Signed-off-by: Matt Evans <matt.evans@arm.com>
> >>    Acked-by: Marc Zyngier <marc.zyngier@arm.com>
> >>    Cc: <stable@vger.kernel.org>
> >>    Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> >>
> >> diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
> >> index 4d1ac81870d2..e9e0e6db73f6 100644
> >> --- a/arch/arm64/kvm/inject_fault.c
> >> +++ b/arch/arm64/kvm/inject_fault.c
> >> @@ -162,7 +162,7 @@ static void inject_abt64(struct kvm_vcpu *vcpu, bool is_iabt, unsigned long addr
> >>                esr |= (ESR_ELx_EC_IABT_CUR << ESR_ELx_EC_SHIFT);
> >>
> >>        if (!is_iabt)
> >> -               esr |= ESR_ELx_EC_DABT_LOW;
> >> +               esr |= ESR_ELx_EC_DABT_LOW << ESR_ELx_EC_SHIFT;
> >>
> >>        vcpu_sys_reg(vcpu, ESR_EL1) = esr | ESR_ELx_FSC_EXTABT;
> >> }
> >>
> > 
> > IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium. Thank you.
> > 
> > 
> 
