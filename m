From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v2 13/25] KVM: arm64: vgic-v3: Add ICV_BPR0_EL1 handler
Date: Tue, 6 Jun 2017 19:23:48 +0200
Message-ID: <20170606172348.GJ9464@cbox>
References: <20170601102117.17750-1-marc.zyngier@arm.com>
 <20170601102117.17750-14-marc.zyngier@arm.com>
 <20170606121150.GO9464@cbox>
 <7bfbee5d-f765-4fa2-02f0-c76a607658dd@arm.com>
 <20170606154609.GI9464@cbox>
 <CAFEAcA9ZHZTJodXstB2YJRnM8QjZtehUwGwAnKKKceMfpB7=gQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAFEAcA9ZHZTJodXstB2YJRnM8QjZtehUwGwAnKKKceMfpB7=gQ@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvm-devel <kvm@vger.kernel.org>, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Robert Richter <rrichter@cavium.com>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jun 06, 2017 at 04:56:27PM +0100, Peter Maydell wrote:
> On 6 June 2017 at 16:46, Christoffer Dall <cdall@linaro.org> wrote:
> > On Tue, Jun 06, 2017 at 04:15:05PM +0100, Marc Zyngier wrote:
> >> >> +static void __hyp_text __vgic_v3_write_bpr0(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
> >> >> +{
> >> >> +  u64 val = vcpu_get_reg(vcpu, rt);
> >> >> +  u8 bpr_min = 7 - vtr_to_nr_pre_bits(read_gicreg(ICH_VTR_EL2));
> >> >> +
> >> >> +  /* Enforce BPR limiting */
> >> >> +  if (val < bpr_min)
> >> >> +          val = bpr_min;
> >> >> +
> >> >> +  val <<= ICH_VMCR_BPR0_SHIFT;
> >> >> +  val &= ICH_VMCR_BPR0_MASK;
> >> >> +  vmcr &= ~ICH_VMCR_BPR0_MASK;
> >> >> +  vmcr |= val;
> >> >> +
> >> >> +  if (vmcr & ICH_VMCR_CBPR_MASK) {
> >> >> +          val = __vgic_v3_get_bpr1(vmcr);
> >> >> +          val <<= ICH_VMCR_BPR1_SHIFT;
> >> >> +          val &= ICH_VMCR_BPR1_MASK;
> >> >> +          vmcr &= ~ICH_VMCR_BPR1_MASK;
> >> >> +          vmcr |= val;
> >> >> +  }
> >> >
> >> > I don't understand why this block is needed?
> >>
> >> If you have CBPR already set, and then update BPR0, you need to make
> >> sure that BPR1 gets updated as well. You could hope that the HW would do
> >> it for you, but since we're erratum workaround land...
> >>
> >
> > I just didn't read the spec that way, I gathered that the hardware would
> > maintain read-as-written for for bpr1 but use bpr0 to set the binary
> > point when cbpr is set, and just ignore writes to bpr1 for as long as
> > cbpr is set.
> 
> This depends whether you're talking about the ICC/ICV BPR0/BPR1 registers,
> or the fields in the ICH_VMCR*. For the former, if CBPR is set then
> BPR1 reads and writes affect BPR0. 

>From the spec on ICV_BPR1_EL1: "Non-secure EL1 writes are ignored".
Doesn't that mean that reads of BPR1 reflect BPR0 but writes are
ignored?


> For the latter, the two fields
> are both independent and read-as-written regardless of the value
> of CBPR, it's just that the value in the BPR1 field has no effect.
> (The reason for this is for VM state migration: if a guest does:
>   - write X to BPR0
>   - write Y to BPR1
>   - set CBPR
>   - write Z to BPR0
>   - unset CBPR
>   - read BPR1
> it should get back Y still; so EL2 needs to have a way to see
> both the underlying BPR0 and BPR1 values even if CPBR is in effect.)
> 
> So the code above is not correct, I think, because it's making
> writes to BPR0 affect the BPR1 value. Instead what should happen
> is that when we emulate reads and writes to ICC_BPR1 we should pay
> attention to CBPR and work with either the VMCR BPR0 or BPR1 field
> appropriately.

I agree that we should drop the block above, but also think we should do
what we do in patch #5 and ignore writes to BPR1 if CBPR is set.

Thanks,
-Christoffer
