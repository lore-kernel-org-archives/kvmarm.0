From: Wei Huang <wei@redhat.com>
Subject: Re: [PATCH V1 0/7] Enable ACPI support for ARM KVM GIC
Date: Mon, 8 Feb 2016 10:47:00 -0600
Message-ID: <56B8C684.6060501@redhat.com>
References: <1454692054-8984-1-git-send-email-wei@redhat.com>
 <56B866FD.4070104@arm.com> <56B8C4D2.3070702@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <56B8C4D2.3070702@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Julien Grall <julien.grall@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: christoffer.dall@linaro.org, kvm@vger.kernel.org, hanjun.guo@linaro.org, fu.wei@linaro.org, drjones@redhat.com, al.stone@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu



On 2/8/16 10:39, Julien Grall wrote:
> Hi,
> 
> On 08/02/16 09:59, Marc Zyngier wrote:
>> On 05/02/16 17:07, Wei Huang wrote:
>>> Wei Huang (7):
>>>    KVM: GIC: Move GIC DT probing code to GICv2 and GICv3 files
>>>    KVM: GIC: Add extra fields to store GICH and GICV resource info
>>>    KVM: GIC: Create a common probe function for GIC
>>>    KVM: GICv2: Extract the common code from DT
>>>    KVM: GICv2: Add ACPI probing function
>>>    KVM: GICv3: Extract the common code from DT
>>>    KVM: GICv3: Add ACPI probing function
>>>
>>>   include/kvm/arm_vgic.h      |  14 ++--
>>>   virt/kvm/arm/vgic-v2-emul.c |   4 +-
>>>   virt/kvm/arm/vgic-v2.c      | 186
>>> +++++++++++++++++++++++++++++++++-----------
>>>   virt/kvm/arm/vgic-v3.c      | 159
>>> ++++++++++++++++++++++++++++---------
>>>   virt/kvm/arm/vgic.c         |  22 +-----
>>>   5 files changed, 277 insertions(+), 108 deletions(-)
>>>
>>
>> So when I see this diffstat and the patches that follow, I cannot help
>> but think that we do have a disconnect here. You do add a bunch of ACPI
>> probing in KVM, to which I've already said no.
>>
>> I want to see the probing code in the GIC drivers, exported through a
>> common structure that KVM can then use. That's it. Nothing else.
> 
> I've been working on a patch series which rely on the GIC and arch timer
> drivers to get the necessary information to initialize the different KVM
> components (vGIC + vtimer).
> 
> I think this achieves the goal you have in mind. I will post the series
> in a few minutes.
> 

Julien,

Regarding arch_timer, there is an effort going on by Linaro. It has
impact on KVM arch_timer init. See https://lkml.org/lkml/2016/2/1/658.

-Wei

> Regards,
> 
