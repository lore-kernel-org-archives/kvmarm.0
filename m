From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [RFC/RFT PATCH 0/3] arm64: KVM: work around incoherency with
 uncached guest mappings
Date: Thu, 19 Feb 2015 14:56:32 +0000
Message-ID: <CAKv+Gu9zciD-KuRXbQhLJBgW6i4jk0-=hG6UrBWr6-g-uZkO1A@mail.gmail.com>
References: <1424343286-6792-1-git-send-email-ard.biesheuvel@linaro.org>
	<54E5F847.6050602@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <54E5F847.6050602@suse.de>
Sender: kvm-owner@vger.kernel.org
To: Alexander Graf <agraf@suse.de>
Cc: Laszlo Ersek <lersek@redhat.com>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Peter Maydell <peter.maydell@linaro.org>, KVM devel mailing list <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 19 February 2015 at 14:50, Alexander Graf <agraf@suse.de> wrote:
>
>
> On 19.02.15 11:54, Ard Biesheuvel wrote:
>> This is a 0th order approximation of how we could potentially force the guest
>> to avoid uncached mappings, at least from the moment the MMU is on. (Before
>> that, all of memory is implicitly classified as Device-nGnRnE)
>>
>> The idea (patch #2) is to trap writes to MAIR_EL1, and replace uncached mappings
>> with cached ones. This way, there is no need to mangle any guest page tables.
>
> Would you mind to give a brief explanation on what this does? What
> happens to actually assigned devices that need to be mapped as uncached?
> What happens to DMA from such devices when the guest assumes that it's
> accessing RAM uncached and then triggers DMA?
>

On ARM, stage 2 mappings that are more strict will supersede stage 1
mappings, so the idea is to use cached mappings exclusively for stage
1 so that the host is fully in control of the actual memory attributes
by setting the attributes at stage 2. This also makes sense because
the host will ultimately know better whether some range that the guest
thinks is a device is actually a device or just emulated (no stage 2
mapping), backed by host memory (such as the NOR flash read case) or
backed by a passthrough device.

-- 
Ard.


>>
>> The downside is that, to do this correctly, we need to always trap writes to
>> the VM sysreg group, which includes registers that the guest may write to very
>> often. To reduce the associated performance hit, patch #1 introduces a fast path
>> for EL2 to perform trivial sysreg writes on behalf of the guest, without the
>> need for a full world switch to the host and back.
>>
>> The main purpose of these patches is to quantify the performance hit, and
>> verify whether the MAIR_EL1 handling works correctly.
>>
>> Ard Biesheuvel (3):
>>   arm64: KVM: handle some sysreg writes in EL2
>>   arm64: KVM: mangle MAIR register to prevent uncached guest mappings
>>   arm64: KVM: keep trapping of VM sysreg writes enabled
>>
>>  arch/arm/kvm/mmu.c               |   2 +-
>>  arch/arm64/include/asm/kvm_arm.h |   2 +-
>>  arch/arm64/kvm/hyp.S             | 101 +++++++++++++++++++++++++++++++++++++++
>>  arch/arm64/kvm/sys_regs.c        |  63 ++++++++++++++++++++----
>>  4 files changed, 156 insertions(+), 12 deletions(-)
>>
