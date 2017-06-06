From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 13/25] KVM: arm64: vgic-v3: Add ICV_BPR0_EL1 handler
Date: Tue, 6 Jun 2017 17:56:54 +0100
Message-ID: <4c7fc091-524c-6780-3fbd-e8c27e400138@arm.com>
References: <20170601102117.17750-1-marc.zyngier@arm.com>
 <20170601102117.17750-14-marc.zyngier@arm.com> <20170606121150.GO9464@cbox>
 <7bfbee5d-f765-4fa2-02f0-c76a607658dd@arm.com> <20170606154609.GI9464@cbox>
 <CAFEAcA9ZHZTJodXstB2YJRnM8QjZtehUwGwAnKKKceMfpB7=gQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <CAFEAcA9ZHZTJodXstB2YJRnM8QjZtehUwGwAnKKKceMfpB7=gQ@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
To: Peter Maydell <peter.maydell@linaro.org>, Christoffer Dall <cdall@linaro.org>
Cc: kvm-devel <kvm@vger.kernel.org>, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Robert Richter <rrichter@cavium.com>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 06/06/17 16:56, Peter Maydell wrote:
> On 6 June 2017 at 16:46, Christoffer Dall <cdall@linaro.org> wrote:
>> On Tue, Jun 06, 2017 at 04:15:05PM +0100, Marc Zyngier wrote:
>>>>> +static void __hyp_text __vgic_v3_write_bpr0(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
>>>>> +{
>>>>> +  u64 val = vcpu_get_reg(vcpu, rt);
>>>>> +  u8 bpr_min = 7 - vtr_to_nr_pre_bits(read_gicreg(ICH_VTR_EL2));
>>>>> +
>>>>> +  /* Enforce BPR limiting */
>>>>> +  if (val < bpr_min)
>>>>> +          val = bpr_min;
>>>>> +
>>>>> +  val <<= ICH_VMCR_BPR0_SHIFT;
>>>>> +  val &= ICH_VMCR_BPR0_MASK;
>>>>> +  vmcr &= ~ICH_VMCR_BPR0_MASK;
>>>>> +  vmcr |= val;
>>>>> +
>>>>> +  if (vmcr & ICH_VMCR_CBPR_MASK) {
>>>>> +          val = __vgic_v3_get_bpr1(vmcr);
>>>>> +          val <<= ICH_VMCR_BPR1_SHIFT;
>>>>> +          val &= ICH_VMCR_BPR1_MASK;
>>>>> +          vmcr &= ~ICH_VMCR_BPR1_MASK;
>>>>> +          vmcr |= val;
>>>>> +  }
>>>>
>>>> I don't understand why this block is needed?
>>>
>>> If you have CBPR already set, and then update BPR0, you need to make
>>> sure that BPR1 gets updated as well. You could hope that the HW would do
>>> it for you, but since we're erratum workaround land...
>>>
>>
>> I just didn't read the spec that way, I gathered that the hardware would
>> maintain read-as-written for for bpr1 but use bpr0 to set the binary
>> point when cbpr is set, and just ignore writes to bpr1 for as long as
>> cbpr is set.
> 
> This depends whether you're talking about the ICC/ICV BPR0/BPR1 registers,
> or the fields in the ICH_VMCR*. For the former, if CBPR is set then
> BPR1 reads and writes affect BPR0. For the latter, the two fields
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

The BPR1 accessors are already behaving that way (write ignored and read
as BPR0+1 if CBPR is set). But I didn't realize that you could mess with
CBPR and BPR0, and yet have ICH_VMCR_EL2.VBPR1 be unaffected.

I'll drop that hunk.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
