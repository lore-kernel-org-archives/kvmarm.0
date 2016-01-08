From: Shannon Zhao <shannon.zhao@linaro.org>
Subject: Re: [PATCH v8 20/20] KVM: ARM64: Add a new kvm ARM PMU device
Date: Fri, 08 Jan 2016 20:15:29 +0800
Message-ID: <568FA861.1080307@linaro.org>
References: <1450771695-11948-1-git-send-email-zhaoshenglong@huawei.com> <1450771695-11948-21-git-send-email-zhaoshenglong@huawei.com> <CAFEAcA_MDiOphseZ7RGNE3G=4ZDF5SFV5krOjanPbVuhgg9gnQ@mail.gmail.com> <568E7AF1.9040103@huawei.com> <CAFEAcA-Qcda7TSFLSeykLHqZYdP6tYdEjPe2uHN6f_+omqWFZg@mail.gmail.com> <568F27A8.80808@huawei.com> <CAFEAcA8DO5VksiP55vnuOD3NERJTfr1q=une4n6N=Oj8JUa1_A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <CAFEAcA8DO5VksiP55vnuOD3NERJTfr1q=une4n6N=Oj8JUa1_A@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
To: Peter Maydell <peter.maydell@linaro.org>, Shannon Zhao <zhaoshenglong@huawei.com>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, kvm-devel <kvm@vger.kernel.org>, Will Deacon <will.deacon@arm.com>, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu



On 2016/1/8 18:24, Peter Maydell wrote:
> On 8 January 2016 at 03:06, Shannon Zhao<zhaoshenglong@huawei.com>  wrote:
>> >
>> >
>> >On 2016/1/7 22:56, Peter Maydell wrote:
>>>>>> >>>>>+  Errors:
>>>>>>>>> >>>>> >>>+    -ENXIO: Unsupported attribute group
>>>>>>>>> >>>>> >>>+    -EBUSY: The PMU overflow interrupt is already set
>>>>>>>>> >>>>> >>>+    -ENODEV: Getting the PMU overflow interrupt number while it's not set
>>>>>>>>> >>>>> >>>+    -EINVAL: Invalid vcpu_index or PMU overflow interrupt number supplied
>>>>>>> >>>> >>
>>>>>>> >>>> >>What happens if you create a PMU but then never set the IRQ number?
>>>>>>> >>>> >>Is there a default or does the VM refuse to run or something?
>>>>>>> >>>> >>
>>>>> >>> >If userspace doesn't specify the irq number, the guest will not receive
>>>>> >>> >the PMU interrupt because we check if the irq is initialized when we
>>>>> >>> >inject the interrupt. But guest could still use the vPMU if QEMU
>>>>> >>> >generates a proper DTB or ACPI.
>>> >>So is it a valid use case to create a PMU with the interrupt not wired
>>> >>up to anything? (If it's never valid it would be nice to diagnose it
>>> >>rather than just silently letting the guest run but not work right.)
>> >So how about adding a helper to check if the PMU is completely
>> >initialized and if not, return trap_raz_wi when guest access PMU registers?
> That would still be letting the guest run and not work right.
>
> If we have an "I have now completed config" ioctl like the GIC does,
> then you could make that ioctl return an error if the config is not
> valid.

Firstly, userspace will call kvm device ioctl to create the PMU device, 
if it fails it will return an error.
Secondly, userspace will call SET_DEVICE_ATTR ioctl to configure the PMU 
irq number. If the irq is invalid, this will return an error and the 
userspace will stop if it takes care the error. If the irq is valid, the 
PMU is well initialized.

If userspace doesn't call SET_ATTR ioctl to configure the PMU irq, the 
PMU is not well initialized and guest can't use the PMU.

I didn't see anywhere that needs to call something like 
KVM_DEV_ARM_VGIC_CTRL_INIT to let kvm initialize PMU because it will be 
initialized when userspace configure the irq correctly. This is a little 
different with the vGIC I think.

Thanks,
-- 
Shannon
