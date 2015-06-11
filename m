From: Hanjun Guo <hanjun.guo@linaro.org>
Subject: Re: [PATCH V2 0/5]  Enable ACPI support for KVM ARM
Date: Thu, 11 Jun 2015 19:47:23 +0800
Message-ID: <5579754B.1040105@linaro.org>
References: <1433909767-12189-1-git-send-email-wei@redhat.com> <20150610132325.GD4307@hawk.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20150610132325.GD4307@hawk.localdomain>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>, Wei Huang <wei@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, marc.zyngier@arm.com, christoffer.dall@linaro.org, pbonzini@redhat.com, a.spyridakis@virtualopensystems.com
List-Id: kvmarm@lists.cs.columbia.edu

On 06/10/2015 09:23 PM, Andrew Jones wrote:
> On Wed, Jun 10, 2015 at 12:16:02AM -0400, Wei Huang wrote:
>> Initial ACPI support for ARM64 has been accepted into Linux kernel recently.
>> Now it is a good time to re-visit ACPI support for KVM. This patchset
>> enables ACPI for both arch_timer and vGIC by probing related ACPI tables
>> and does necessary initialization.
>>
>> Note that Alexander Spyridaki submitted similar patches before. Some of
>> his ideas were borrowed in this patchset, but with substancial changes.
>> In addition we extend support for both GICv2 and GICv3.
>>
>> This patchset would work better on top of recent GIC/IRQCHIP patches by
>> Hanjun Guo, who added support for gic_version in ACPI struct of GIC
>> distributor (search "ACPICA: Introduce GIC version for arm based system").
>>
>> This patchset can be applied cleanly on top of kvmarm.git queue branch.
>>
>> -Wei
>>
>> V1->V2:
>> * Initialize vgic->max_gic_vcpus field in GICv2 code (found by Andrew Jones)
>> * Rewrite arch_timer ACPI PPI parsing code
>> * Verified patches on APM Mustang machine, which has arch_timer & GICv2
>>
>> V1:
>> * Initial patchset
>>
>> Wei Huang (5):
>>    kvm: arm64: Enable ACPI support for virt arch timer
>>    kvm: arm64: Dispatch virt GIC probing to device tree and ACPI
>>    kvm: arm64: Detect GIC version for proper ACPI vGIC probing
>>    kvm: arm64: Implement ACPI probing code for GICv2
>>    kvm: arm64: Implement ACPI probing code for GICv3
>>
>>   include/kvm/arm_vgic.h    |  36 +++++++++---
>>   virt/kvm/arm/arch_timer.c |  75 ++++++++++++++++++++-----
>>   virt/kvm/arm/vgic-v2.c    |  66 ++++++++++++++++++++--
>>   virt/kvm/arm/vgic-v3.c    |  56 +++++++++++++++++--
>>   virt/kvm/arm/vgic.c       | 140 ++++++++++++++++++++++++++++++++++++++++++----
>>   5 files changed, 332 insertions(+), 41 deletions(-)
>
> I've looked over the series and made a couple nits. I think we need to
> wait until "ACPICA: Introduce GIC version for arm based system" is
> accepted, as it may still change, and this series duplicates parts of it.

Yes, it was changed. Part of them is accepted by ACPICA core, but the
new release of ACPICA 20150515 missed some code below,

  include/acpi/actbl1.h | 11 +++++++++++
  1 file changed, 11 insertions(+)

diff --git a/include/acpi/actbl1.h b/include/acpi/actbl1.h
index cadf21c..d382de8 100644
--- a/include/acpi/actbl1.h
+++ b/include/acpi/actbl1.h
@@ -834,6 +834,17 @@ struct acpi_madt_generic_distributor {
         u8 reserved2[3];        /* reserved - must be zero */
  };

+/* Values for Version field above */
+
+enum acpi_madt_gic_version {
+       ACPI_MADT_GIC_VERSION_NONE      = 0,
+       ACPI_MADT_GIC_VERSION_V1        = 1,
+       ACPI_MADT_GIC_VERSION_V2        = 2,
+       ACPI_MADT_GIC_VERSION_V3        = 3,
+       ACPI_MADT_GIC_VERSION_V4        = 4,
+       ACPI_MADT_GIC_VERSION_RESERVED  = 5     /* 5 and greater are 
reserved */
+};
+

it was accepted by ACPICA tools but not ACPICA for linux, I already
send them to Lv and Rafael, hope it can be merged for 4.2.

Thanks
Hanjun
