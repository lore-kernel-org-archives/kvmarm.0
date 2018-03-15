From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH v1 13/16] kvm: arm64: Configure VTCR per VM
Date: Thu, 15 Mar 2018 15:24:58 +0000
Message-ID: <514dda83-dd08-3318-b5a2-6c41fc1c992d@arm.com>
References: <20180109190414.4017-1-suzuki.poulose@arm.com>
 <20180109190414.4017-14-suzuki.poulose@arm.com>
 <CAMJs5B_yvM8XNT=g8uN63G1G6uwGQcYF_0dxbC1Gaeb+j6UvpQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAMJs5B_yvM8XNT=g8uN63G1G6uwGQcYF_0dxbC1Gaeb+j6UvpQ@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christoffer Dall <cdall@kernel.org>
Cc: Linux ARM <linux-arm-kernel@lists.infradead.org>, KVM <kvm@vger.kernel.org>, kvmarm@lists.cs.columbia.edu, Marc Zyngier <marc.zyngier@arm.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kristina Martsenko <kristina.martsenko@arm.com>, Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu


Hi Christoffer,

On 08/02/18 18:04, Christoffer Dall wrote:
> On Tue, Jan 09, 2018 at 07:04:08PM +0000, Suzuki K Poulose wrote:
>> We set VTCR_EL2 very early during the stage2 init and don't
>> touch it ever. This is fine as we had a fixed IPA size. This
>> patch changes the behavior to set the VTCR for a given VM,
>> depending on its stage2 table. The common configuration for
>> VTCR is still performed during the early init. But the SL0
>> and T0SZ are programmed for each VM and is cleared once we
>> exit the VM.
>>
>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>> Cc: Christoffer Dall <cdall@linaro.org>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>

>> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
>> index f7c651f3a8c0..523471f0af7b 100644
>> --- a/arch/arm64/kvm/hyp/switch.c
>> +++ b/arch/arm64/kvm/hyp/switch.c
>> @@ -157,11 +157,20 @@ static void __hyp_text __deactivate_traps(struct kvm_vcpu *vcpu)
>>   static void __hyp_text __activate_vm(struct kvm_vcpu *vcpu)
>>   {
>>    struct kvm *kvm = kern_hyp_va(vcpu->kvm);
>> + u64 vtcr = read_sysreg(vtcr_el2);
>> +
>> + vtcr &= ~VTCR_EL2_PRIVATE_MASK;
>> + vtcr |= VTCR_EL2_SL0(stage2_pt_levels(kvm)) |
>> + VTCR_EL2_T0SZ(kvm_phys_shift(kvm));
>> + write_sysreg(vtcr, vtcr_el2);
> 
> If we're writing VTCR_EL2 on each entry, do we really need to read the
> value back first and calculate things on every entry to the VM?  It
> seems to me we should be able to compute the vtcr_el2 and store it on
> struct kvm, and simply restore that per-VM value upon entering the VM?

I took a look at this and we need to do this to make sure we retain the
Hardware update of Access flags for stage2 (VTCR_EL2_HA) bits on the CPUs
that has it and it is safe to run a mix of CPUs with and without the feature.

>>    write_sysreg(kvm->arch.vttbr, vttbr_el2);
>>   }
>>
>>   static void __hyp_text __deactivate_vm(struct kvm_vcpu *vcpu)
>>   {
>> + u64 vtcr = read_sysreg(vtcr_el2) & ~VTCR_EL2_PRIVATE_MASK;
>> +
>> + write_sysreg(vtcr, vtcr_el2);
> 
> Why do we need to care about restoring VTCR when returning to the host?

Yes, this can be skipped.

Cheers
Suzuki
