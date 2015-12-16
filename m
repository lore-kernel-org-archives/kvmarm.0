From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: Re: [PATCH v7 19/19] KVM: ARM64: Add a new kvm ARM PMU device
Date: Wed, 16 Dec 2015 16:06:49 +0800
Message-ID: <56711B99.1000608@huawei.com>
References: <1450169379-12336-1-git-send-email-zhaoshenglong@huawei.com>
 <1450169379-12336-20-git-send-email-zhaoshenglong@huawei.com>
 <567032AD.8000206@arm.com> <567036DE.80605@linaro.org>
 <567038E3.3010102@arm.com> <20151215204739.GK4120@cbox>
 <56711348.6010406@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 529034130A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Dec 2015 03:09:05 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FlUf-Rbqg9gy for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Dec 2015 03:09:03 -0500 (EST)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [119.145.14.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 61DF8412D6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Dec 2015 03:09:01 -0500 (EST)
In-Reply-To: <56711348.6010406@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, will.deacon@arm.com, Shannon Zhao <shannon.zhao@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 2015/12/16 15:31, Shannon Zhao wrote:
>>>> >> > But in this case, you're returning an error if it is *not* initialized.
>>>> >> > I understand that in that case you cannot return an interrupt number (-1
>>>> >> > would be weird), but returning -EBUSY feels even more weird.
>>>> >> > 
>>>> >> > I'd settle for -ENOXIO, or something similar. Anyone having a better idea?
>>>> >> > 
>> > ENXIO or ENODEV would be my choice too, and add that to the
>> > Documentation clearly describing when this error code is used.
>> > 
>> > By the way, why do you loop over all VCPUS to set the same value when
>> > you can't do anything per VCPU anyway?  It seems to me it's either a
>> > per-VM property (that you can store on the VM data structure) or it's a
>> > true per-VCPU property?
> This is a per-VCPU property. PMU interrupt could be PPI or SPI. For PPI
> the interrupt numbers are same for each vcpu, while for SPI they are
> different, so it needs to set them separately. I planned to support both
> PPI and SPI. I think I should add support for SPI at this moment and let
> users (QEMU) to set these interrupts for each one.

How about below vPMU Documentation?

ARM Virtual Performance Monitor Unit (vPMU)
===========================================

Device types supported:
  KVM_DEV_TYPE_ARM_PMU_V3         ARM Performance Monitor Unit v3

Instantiate one PMU instance for per VCPU through this API.

Groups:
  KVM_DEV_ARM_PMU_GRP_IRQ
  Attributes:
    The attr field of kvm_device_attr encodes two values:
    bits:     | 63 .... 32 | 31 .... 0 |
    values:   | vcpu_index |  irq_num  |
    The irq_num describes the PMU overflow interrupt number for the
specified
    vcpu_index vcpu. This interrupt could be a PPI or SPI, but for one
VM the
    interrupt type must be same for each vcpu.

  Errors:
    -ENXIO: Getting or setting this attribute is not yet supported
    -ENODEV: Getting the PMU overflow interrupt number while it's not set
    -EBUSY: The PMU overflow interrupt is already set
    -EINVAL: Invalid vcpu_index or irq_num supplied


-- 
Shannon
