From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v8 20/20] KVM: ARM64: Add a new kvm ARM PMU device
Date: Fri, 8 Jan 2016 10:24:01 +0000
Message-ID: <CAFEAcA8DO5VksiP55vnuOD3NERJTfr1q=une4n6N=Oj8JUa1_A@mail.gmail.com>
References: <1450771695-11948-1-git-send-email-zhaoshenglong@huawei.com>
 <1450771695-11948-21-git-send-email-zhaoshenglong@huawei.com>
 <CAFEAcA_MDiOphseZ7RGNE3G=4ZDF5SFV5krOjanPbVuhgg9gnQ@mail.gmail.com>
 <568E7AF1.9040103@huawei.com>
 <CAFEAcA-Qcda7TSFLSeykLHqZYdP6tYdEjPe2uHN6f_+omqWFZg@mail.gmail.com>
 <568F27A8.80808@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 14E5B49840
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jan 2016 05:20:36 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iYNsY8n3Y3fn for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Jan 2016 05:20:34 -0500 (EST)
Received: from mail-vk0-f44.google.com (mail-vk0-f44.google.com
 [209.85.213.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C79104977A
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jan 2016 05:20:34 -0500 (EST)
Received: by mail-vk0-f44.google.com with SMTP id a123so158255137vkh.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Jan 2016 02:24:21 -0800 (PST)
In-Reply-To: <568F27A8.80808@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Shannon Zhao <zhaoshenglong@huawei.com>
Cc: arm-mail-list <linux-arm-kernel@lists.infradead.org>, kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, Shannon Zhao <shannon.zhao@linaro.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 8 January 2016 at 03:06, Shannon Zhao <zhaoshenglong@huawei.com> wrote:
>
>
> On 2016/1/7 22:56, Peter Maydell wrote:
>>>>> +  Errors:
>>>>> >>> +    -ENXIO: Unsupported attribute group
>>>>> >>> +    -EBUSY: The PMU overflow interrupt is already set
>>>>> >>> +    -ENODEV: Getting the PMU overflow interrupt number while it's not set
>>>>> >>> +    -EINVAL: Invalid vcpu_index or PMU overflow interrupt number supplied
>>>> >>
>>>> >> What happens if you create a PMU but then never set the IRQ number?
>>>> >> Is there a default or does the VM refuse to run or something?
>>>> >>
>>> > If userspace doesn't specify the irq number, the guest will not receive
>>> > the PMU interrupt because we check if the irq is initialized when we
>>> > inject the interrupt. But guest could still use the vPMU if QEMU
>>> > generates a proper DTB or ACPI.
>> So is it a valid use case to create a PMU with the interrupt not wired
>> up to anything? (If it's never valid it would be nice to diagnose it
>> rather than just silently letting the guest run but not work right.)
> So how about adding a helper to check if the PMU is completely
> initialized and if not, return trap_raz_wi when guest access PMU registers?

That would still be letting the guest run and not work right.

If we have an "I have now completed config" ioctl like the GIC does,
then you could make that ioctl return an error if the config is not
valid.

thanks
-- PMM
