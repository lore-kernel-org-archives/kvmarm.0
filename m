From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: Re: [PATCH v8 20/20] KVM: ARM64: Add a new kvm ARM PMU device
Date: Fri, 8 Jan 2016 11:06:16 +0800
Message-ID: <568F27A8.80808@huawei.com>
References: <1450771695-11948-1-git-send-email-zhaoshenglong@huawei.com>
 <1450771695-11948-21-git-send-email-zhaoshenglong@huawei.com>
 <CAFEAcA_MDiOphseZ7RGNE3G=4ZDF5SFV5krOjanPbVuhgg9gnQ@mail.gmail.com>
 <568E7AF1.9040103@huawei.com>
 <CAFEAcA-Qcda7TSFLSeykLHqZYdP6tYdEjPe2uHN6f_+omqWFZg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F1CA149803
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Jan 2016 22:03:52 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1aSNFKjp6lsI for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Jan 2016 22:03:51 -0500 (EST)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [58.251.152.64])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9B95B497F8
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Jan 2016 22:03:49 -0500 (EST)
In-Reply-To: <CAFEAcA-Qcda7TSFLSeykLHqZYdP6tYdEjPe2uHN6f_+omqWFZg@mail.gmail.com>
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
Cc: arm-mail-list <linux-arm-kernel@lists.infradead.org>, kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, Shannon Zhao <shannon.zhao@linaro.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu



On 2016/1/7 22:56, Peter Maydell wrote:
>>>> +  Errors:
>>>> >>> +    -ENXIO: Unsupported attribute group
>>>> >>> +    -EBUSY: The PMU overflow interrupt is already set
>>>> >>> +    -ENODEV: Getting the PMU overflow interrupt number while it's not set
>>>> >>> +    -EINVAL: Invalid vcpu_index or PMU overflow interrupt number supplied
>>> >>
>>> >> What happens if you create a PMU but then never set the IRQ number?
>>> >> Is there a default or does the VM refuse to run or something?
>>> >>
>> > If userspace doesn't specify the irq number, the guest will not receive
>> > the PMU interrupt because we check if the irq is initialized when we
>> > inject the interrupt. But guest could still use the vPMU if QEMU
>> > generates a proper DTB or ACPI.
> So is it a valid use case to create a PMU with the interrupt not wired
> up to anything? (If it's never valid it would be nice to diagnose it
> rather than just silently letting the guest run but not work right.)
So how about adding a helper to check if the PMU is completely
initialized and if not, return trap_raz_wi when guest access PMU registers?

Thanks,
-- 
Shannon
