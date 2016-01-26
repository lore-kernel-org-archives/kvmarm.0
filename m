From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: Re: [PATCH v9 21/21] KVM: ARM64: Add a new vcpu device control group
 for PMUv3
Date: Tue, 26 Jan 2016 11:33:47 +0800
Message-ID: <56A6E91B.3050705@huawei.com>
References: <1452839275-19368-1-git-send-email-zhaoshenglong@huawei.com> <1452839275-19368-22-git-send-email-zhaoshenglong@huawei.com> <CAFEAcA-rVDLajQ7s5KcwkVsACtRtEqN+wkpR6RWMkvBBPJY8fA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <CAFEAcA-rVDLajQ7s5KcwkVsACtRtEqN+wkpR6RWMkvBBPJY8fA@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
To: Peter Maydell <peter.maydell@linaro.org>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, kvm-devel <kvm@vger.kernel.org>, Will Deacon <will.deacon@arm.com>, Andrew Jones <drjones@redhat.com>, Wei Huang <wei@redhat.com>, Christopher Covington <cov@codeaurora.org>, Shannon Zhao <shannon.zhao@linaro.org>, "Huangpeng (Peter)" <peter.huangpeng@huawei.com>, hangaohuai@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu



On 2016/1/26 0:53, Peter Maydell wrote:
> On 15 January 2016 at 06:27, Shannon Zhao <zhaoshenglong@huawei.com> wrote:
>> > From: Shannon Zhao <shannon.zhao@linaro.org>
>> >
>> > To configure the virtual PMUv3 overflow interrupt number, we use the
>> > vcpu kvm_device ioctl, encapsulating the KVM_ARM_VCPU_PMU_V3_IRQ
>> > attribute within the KVM_ARM_VCPU_PMU_V3_CTRL group.
>> >
>> > After configuring the PMUv3, call the vcpu iotcl with attribute
>> > KVM_ARM_VCPU_PMU_V3_INIT to initialize the PMUv3.
>> >
>> > Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
>> > ---
>> > CC: Peter Maydell <peter.maydell@linaro.org>
>> > ---
>> >  Documentation/virtual/kvm/devices/vcpu.txt |  24 ++++++
>> >  arch/arm/include/asm/kvm_host.h            |  15 ++++
>> >  arch/arm/kvm/arm.c                         |   3 +
>> >  arch/arm64/include/asm/kvm_host.h          |   6 ++
>> >  arch/arm64/include/uapi/asm/kvm.h          |   5 ++
>> >  arch/arm64/kvm/guest.c                     |  51 ++++++++++++
>> >  include/kvm/arm_pmu.h                      |  23 ++++++
>> >  virt/kvm/arm/pmu.c                         | 128 +++++++++++++++++++++++++++++
>> >  8 files changed, 255 insertions(+)
>> >
>> > diff --git a/Documentation/virtual/kvm/devices/vcpu.txt b/Documentation/virtual/kvm/devices/vcpu.txt
>> > index 3cc59c5..60cbac8 100644
>> > --- a/Documentation/virtual/kvm/devices/vcpu.txt
>> > +++ b/Documentation/virtual/kvm/devices/vcpu.txt
>> > @@ -6,3 +6,27 @@ KVM_GET_DEVICE_ATTR, and KVM_HAS_DEVICE_ATTR. The interface uses the same struct
>> >  kvm_device_attr as other devices, but targets VCPU-wide settings and controls.
>> >
>> >  The groups and attributes per virtual cpu, if any, are architecture specific.
>> > +
>> > +1. GROUP: KVM_ARM_VCPU_PMU_V3_CTRL
>> > +Architectures: ARM64
>> > +
>> > +1.1. ATTRIBUTE: KVM_ARM_VCPU_PMU_V3_IRQ
>> > +Parameters: in kvm_device_attr.addr the address for PMU overflow interrupt
>> > +Returns: -EBUSY: The PMU overflow interrupt is already set
>> > +         -ENODEV: Not set the corresponding vcpu feature bit or getting the PMU
>> > +                  overflow interrupt number while it's not set
>> > +         -EINVAL: Invalid PMU overflow interrupt number supplied
>> > +
>> > +A value describing the PMUv3 (Performance Monitor Unit v3) overflow interrupt
>> > +number for this vcpu. This interrupt could be a PPI or SPI, but the interrupt
>> > +type must be same for each vcpu. As a PPI, the interrupt number is same for all
>> > +vcpus, while as a SPI it must be different for each vcpu.
>> > +
>> > +1.2 ATTRIBUTE: KVM_ARM_VCPU_PMU_V3_INIT
>> > +Parameters: no additional parameter in kvm_device_attr.addr
>> > +Returns: -ENODEV: No PMUv3 supported
>> > +         -ENXIO: PMUv3 not properly configured as required prior to calling this
>> > +                 attribute
>> > +         -EBUSY: PMUv3 already initialized
>> > +
>> > +Request the initialization of the PMUv3.
> The other thing we could do here (now the PMU is part of the vCPU 'device'
> rather than its own thing) is to have a single INIT ioctl that says
> "we're done doing all the SET_DEVICE_ATTR calls to configure the vCPU".
> But I'm fine with this way too.
> 
> You can have my
> Acked-by: Peter Maydell <peter.maydell@linaro.org>
> 
> for the userspace API parts of patches 19, 20 and 21 (with the minor typo
> fixes etc Andrew has posted).
Thanks a lot!

-- 
Shannon

