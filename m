From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH v5 18/18] kvm: arm64: Allow tuning the physical address
 size for VM
Date: Wed, 19 Sep 2018 11:03:11 +0100
Message-ID: <e818aa74-a34e-91fa-ad5a-344816105840@arm.com>
References: <20180917104144.19188-1-suzuki.poulose@arm.com>
 <20180917104144.19188-19-suzuki.poulose@arm.com>
 <CAFEAcA8eWYkzwFYHyP49dasK-NDVbbm=6DbEFNNPq9ZAdUM7JQ@mail.gmail.com>
 <218b64d5-741d-97ef-8aae-bc0a2ac3e56c@arm.com>
 <CAFEAcA8qjJJ0FkQj4yBMKFrwNFiJj3Q4FBi4GbnK2PN3B3J-mg@mail.gmail.com>
 <fec1a2e0-a45a-eb51-6ffe-2ac9b35acc45@arm.com>
 <CAFEAcA_tphfZ_BKfAYuefStTipta0notyAR=NCnWFJ6nRfERpg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 16CE340A6E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Sep 2018 06:02:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id s0RvjgoPEeBa for <kvmarm@lists.cs.columbia.edu>;
 Wed, 19 Sep 2018 06:02:17 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 87CF649F89
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Sep 2018 06:02:17 -0400 (EDT)
In-Reply-To: <CAFEAcA_tphfZ_BKfAYuefStTipta0notyAR=NCnWFJ6nRfERpg@mail.gmail.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Christoffer Dall <cdall@kernel.org>, kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>, Dave P Martin <dave.martin@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 09/18/2018 06:15 PM, Peter Maydell wrote:
> On 18 September 2018 at 17:27, Suzuki K Poulose <Suzuki.Poulose@arm.com> wrote:
>> ---
>>
>> "On arm64, the physical address size for a VM (IPA Size limit) is limited
>> to 40bits by default. The limit can be configured if the host supports the
>> extension KVM_CAP_ARM_VM_IPA_SIZE. When supported, use
>> KVM_VM_TYPE_ARM_IPA_SIZE(IPA_Bits) to set the size in the machine type
>> identifier, where IPA_Bits is the maximum width of any physical
>> address used by the VM. The IPA_Bits is encoded in bits[7-0] of the
>> machine type identifier.
>>
>> e.g, to configure a guest to use 48bit physical address size :
>>
>>          vm_fd = ioctl(dev_fd, KVM_CREATE_VM, KVM_VM_TYPE_ARM_IPA_SIZE(48));
>>
>> The requested size (IPA_Bits) must be :
>>    0 - Implies default 40bits (for backward compatibility)
>>
>>    or
>>
>>    N - Implies N bits, where N is a positive integer such that 32 <= N <=
>> Host_IPA_Limit
>>
>> Host_IPA_Limit is the maximum possible value for IPA_Bits on the host and
>> is dependent on the CPU capability and the kernel configuration. The limit
>> can
>> be retrieved using KVM_CAP_ARM_VM_IPA_SIZE of the KVM_CHECK_EXTENSION
>> ioctl() at run-time.
>>
>> Please note that configuring the IPA size does not affect the capability
>> exposed by the guest CPUs in ID_AA64MMFR0_EL1[PARange]. It only affects
>> the guest to host physical address (stage2) translations setup by the host.
>> "
> 
> Thanks, this is much clearer. The only bit I'm not sure about is that
> last paragraph -- if I ask for a VM with a 48 bit address space why
> don't we tell the guest that that's what it has ?

The point is the IPA Size is not a limit on the CPU's PA size. e.g, if
this guest was a nested hypervisor with 48bit IPA, it could still
support a 52bit IPA nested guest within by simply looking up the CPU
PARange. The IPA size configuration here is simply a hint to the
hypervisor on where the memory banks would be kept. And this certainly
true on real platforms (e.g, my Juno has 42bit PARange on A57, while
A53 reports 40bit, with PA max at 40bits).

Suzuki
