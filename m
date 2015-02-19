From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [RFC/RFT PATCH 3/3] arm64: KVM: keep trapping of VM sysreg writes enabled
Date: Thu, 19 Feb 2015 13:44:02 +0000
Message-ID: <CAKv+Gu-vdntgb3TjzmNj6pA3nW-JKUOf+Xiut9BVHBnpR25iGg@mail.gmail.com>
References: <1424343286-6792-1-git-send-email-ard.biesheuvel@linaro.org>
	<1424343286-6792-4-git-send-email-ard.biesheuvel@linaro.org>
	<54E5E7B2.2080501@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <54E5E7B2.2080501@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: "lersek@redhat.com" <lersek@redhat.com>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "peter.maydell@linaro.org" <peter.maydell@linaro.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "agraf@suse.de" <agraf@suse.de>, "pbonzini@redhat.com" <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 19 February 2015 at 13:40, Marc Zyngier <marc.zyngier@arm.com> wrote:
> On 19/02/15 10:54, Ard Biesheuvel wrote:
>> ---
>>  arch/arm/kvm/mmu.c               | 2 +-
>>  arch/arm64/include/asm/kvm_arm.h | 2 +-
>>  2 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
>> index 136662547ca6..fa8ec55220ea 100644
>> --- a/arch/arm/kvm/mmu.c
>> +++ b/arch/arm/kvm/mmu.c
>> @@ -1530,7 +1530,7 @@ void kvm_toggle_cache(struct kvm_vcpu *vcpu, bool was_enabled)
>>               stage2_flush_vm(vcpu->kvm);
>>
>>       /* Caches are now on, stop trapping VM ops (until a S/W op) */
>> -     if (now_enabled)
>> +     if (0)//now_enabled)
>>               vcpu_set_hcr(vcpu, vcpu_get_hcr(vcpu) & ~HCR_TVM);
>>
>>       trace_kvm_toggle_cache(*vcpu_pc(vcpu), was_enabled, now_enabled);
>> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
>> index 8afb863f5a9e..437e1ec17539 100644
>> --- a/arch/arm64/include/asm/kvm_arm.h
>> +++ b/arch/arm64/include/asm/kvm_arm.h
>> @@ -75,7 +75,7 @@
>>   * FMO:              Override CPSR.F and enable signaling with VF
>>   * SWIO:     Turn set/way invalidates into set/way clean+invalidate
>>   */
>> -#define HCR_GUEST_FLAGS (HCR_TSC | HCR_TSW | HCR_TWE | HCR_TWI | HCR_VM | \
>> +#define HCR_GUEST_FLAGS (HCR_TSC | /* HCR_TSW | */ HCR_TWE | HCR_TWI | HCR_VM | \
>
> Why do we stop to trap S/W ops here? We can't let the guest issue those
> without doing anything, as this will break anything that expects the
> data to make it to memory. Think of the 32bit kernel decompressor, for
> example.
>

TBH patch #3 is just a q'n'd hack to ensure that the TVM bit remains
set in HCR. I was assuming that cleaning the entire cache on mmu
enable/disable would be sufficient to quantify the performance impact
and check whether patch #2 works as advertised.

I was wondering: isn't calling stage2_flush_vm() for each set of each
way very costly?
