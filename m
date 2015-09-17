From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: Re: [PATCH v2 00/22] KVM: ARM64: Add guest PMU support
Date: Thu, 17 Sep 2015 14:47:30 +0800
Message-ID: <55FA6202.5090906@huawei.com>
References: <1441961715-11688-1-git-send-email-zhaoshenglong@huawei.com>
 <55F9D9FC.6010905@redhat.com> <55FA1832.3040008@linaro.org>
 <55FA5626.7040105@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A03C4141D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Sep 2015 02:55:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LFGDpps7PjUI for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Sep 2015 02:55:44 -0400 (EDT)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [58.251.152.64])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D24A441390
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Sep 2015 02:55:43 -0400 (EDT)
In-Reply-To: <55FA5626.7040105@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Wei Huang <wei@redhat.com>, Shannon Zhao <shannon.zhao@linaro.org>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Wei,

On 2015/9/17 13:56, Wei Huang wrote:
> 
> 
> On 09/16/2015 08:32 PM, Shannon Zhao wrote:
>> Hi Wei,
>>
>> On 2015/9/17 5:07, Wei Huang wrote:
>>> I am testing this series. 
>> Thanks for your time and help.
>>
>>> The first question is: do you plan to add ACPI
>>> support in QEMU?
> 
> I saw "KVM_{SET/GET}_DEVICE_ATTR failed: Invalid argument" while using
> your QEMU tree (PMU_v2 branch). A quick debugging:
> 
>From this log, it might fail at below check:
+               if (reg < VGIC_NR_SGIS || reg > dev->kvm->arch.vgic.nr_irqs)
+                       return -EINVAL;

> (1) dmesg on host kernel didn't show any vPMU initialization errors. So
> I suspect the problem is related to QEMU.
> (2) Commit 58771bc2a78 worked fine. So probably the problem was
> introduced by new PMU code.
> 
> Have you seen it before?
> 

Oh, I didn't see this. And I checkout the code on git.linaro.org, it's
same with my local code.

Could you add some print in kvm_arm_pmu_set_irq of hw/misc/arm_pmu_kvm.c
and kvm_arm_pmu_set_attr, kvm_arm_pmu_set_irq of virt/kvm/arm/pmu.c.

Thanks,

-- 
Shannon
