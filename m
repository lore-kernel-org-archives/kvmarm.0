From: Wei Huang <wei@redhat.com>
Subject: Re: [PATCH V1 0/7] Enable ACPI support for ARM KVM GIC
Date: Mon, 8 Feb 2016 10:35:20 -0600
Message-ID: <56B8C3C8.2070204@redhat.com>
References: <1454692054-8984-1-git-send-email-wei@redhat.com>
 <56B866FD.4070104@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <56B866FD.4070104@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: christoffer.dall@linaro.org, kvm@vger.kernel.org, hanjun.guo@linaro.org, fu.wei@linaro.org, drjones@redhat.com, al.stone@linaro.org, Julien Grall <Julien.Grall@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu



On 2/8/16 03:59, Marc Zyngier wrote:
> Wei,
> 
> On 05/02/16 17:07, Wei Huang wrote:
>> This patch set enables ACPI support for KVM GIC. Note that the patches
>> are in fact the V3 of previously submitted patches (search "Enable ACPI
>> support for KVM ARM"). But because Fu Wei includes the arch_timer part
>> in his series [1] and I have substantially re-written the GIC code in this
>> revision, the version number is reset to v1. 
>>
>> By following Marc's prior comments, the main design idea is to let DT or
>> ACPI code to fill out the "struct vgic_params" which are extended to
>> include all GIC related info.
> 
> I think you misread the comments I gave back in June (!), where I said:
> 
> <quote>
> [...]
> 
> Simply making available a global structure containing the base addresses
> and interrupt should be enough, and could be shared with both DT and
> ACPI. You could start your series by letting both GIC drivers expose
> that information obtained through DT, convert KVM to use this structure,
> and later on let ACPI fill in this structure too.
> 
>> Anyway the difficulty is to find a common place to store and share info
>> between other modules & KVM.
> 
> Indeed. As a rule of thumb, I want to minimize the amount of gratuitous
> divergence between DT and ACPI. So the sooner we extract the required
> information from whatever firmware we have, the better.
> </quote>
> 
>>
>> [1] https://lkml.org/lkml/2016/2/1/658
>>
>> Thanks,
>> -Wei
>>
>> Wei Huang (7):
>>   KVM: GIC: Move GIC DT probing code to GICv2 and GICv3 files
>>   KVM: GIC: Add extra fields to store GICH and GICV resource info
>>   KVM: GIC: Create a common probe function for GIC
>>   KVM: GICv2: Extract the common code from DT
>>   KVM: GICv2: Add ACPI probing function
>>   KVM: GICv3: Extract the common code from DT
>>   KVM: GICv3: Add ACPI probing function
>>
>>  include/kvm/arm_vgic.h      |  14 ++--
>>  virt/kvm/arm/vgic-v2-emul.c |   4 +-
>>  virt/kvm/arm/vgic-v2.c      | 186 +++++++++++++++++++++++++++++++++-----------
>>  virt/kvm/arm/vgic-v3.c      | 159 ++++++++++++++++++++++++++++---------
>>  virt/kvm/arm/vgic.c         |  22 +-----
>>  5 files changed, 277 insertions(+), 108 deletions(-)
>>
> 
> So when I see this diffstat and the patches that follow, I cannot help
> but think that we do have a disconnect here. You do add a bunch of ACPI
> probing in KVM, to which I've already said no.
> 
> I want to see the probing code in the GIC drivers, exported through a
> common structure that KVM can then use. That's it. Nothing else.

OK. I will create a V2 based on that idea.

-Wei

> 
> Thanks,
> 
> 	M.
> 
