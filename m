From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH V2 0/5]  Enable ACPI support for KVM ARM
Date: Wed, 10 Jun 2015 15:23:25 +0200
Message-ID: <20150610132325.GD4307@hawk.localdomain>
References: <1433909767-12189-1-git-send-email-wei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1433909767-12189-1-git-send-email-wei@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Wei Huang <wei@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, marc.zyngier@arm.com, christoffer.dall@linaro.org, pbonzini@redhat.com, a.spyridakis@virtualopensystems.com, hanjun.guo@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jun 10, 2015 at 12:16:02AM -0400, Wei Huang wrote:
> Initial ACPI support for ARM64 has been accepted into Linux kernel recently.
> Now it is a good time to re-visit ACPI support for KVM. This patchset
> enables ACPI for both arch_timer and vGIC by probing related ACPI tables
> and does necessary initialization.
> 
> Note that Alexander Spyridaki submitted similar patches before. Some of
> his ideas were borrowed in this patchset, but with substancial changes.
> In addition we extend support for both GICv2 and GICv3.
> 
> This patchset would work better on top of recent GIC/IRQCHIP patches by
> Hanjun Guo, who added support for gic_version in ACPI struct of GIC
> distributor (search "ACPICA: Introduce GIC version for arm based system").
> 
> This patchset can be applied cleanly on top of kvmarm.git queue branch.
> 
> -Wei
> 
> V1->V2:
> * Initialize vgic->max_gic_vcpus field in GICv2 code (found by Andrew Jones)
> * Rewrite arch_timer ACPI PPI parsing code
> * Verified patches on APM Mustang machine, which has arch_timer & GICv2
> 
> V1:
> * Initial patchset
> 
> Wei Huang (5):
>   kvm: arm64: Enable ACPI support for virt arch timer
>   kvm: arm64: Dispatch virt GIC probing to device tree and ACPI
>   kvm: arm64: Detect GIC version for proper ACPI vGIC probing
>   kvm: arm64: Implement ACPI probing code for GICv2
>   kvm: arm64: Implement ACPI probing code for GICv3
> 
>  include/kvm/arm_vgic.h    |  36 +++++++++---
>  virt/kvm/arm/arch_timer.c |  75 ++++++++++++++++++++-----
>  virt/kvm/arm/vgic-v2.c    |  66 ++++++++++++++++++++--
>  virt/kvm/arm/vgic-v3.c    |  56 +++++++++++++++++--
>  virt/kvm/arm/vgic.c       | 140 ++++++++++++++++++++++++++++++++++++++++++----
>  5 files changed, 332 insertions(+), 41 deletions(-)

I've looked over the series and made a couple nits. I think we need to
wait until "ACPICA: Introduce GIC version for arm based system" is
accepted, as it may still change, and this series duplicates parts of it.

Thanks,
drew
