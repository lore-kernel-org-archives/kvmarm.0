From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v2 12/17] kvm: arm/arm64: Expose supported physical
 address limit for VM
Date: Fri, 13 Apr 2018 14:21:48 +0100
Message-ID: <CAFEAcA-jUSHuwRrWCH6vFENmEi7Xskn9s9BgDmBKj3YKCyXHXQ@mail.gmail.com>
References: <1522156531-28348-1-git-send-email-suzuki.poulose@arm.com> <1522156531-28348-13-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1522156531-28348-13-git-send-email-suzuki.poulose@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: arm-mail-list <linux-arm-kernel@lists.infradead.org>, lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>, kvmarm@lists.cs.columbia.edu, kvm-devel <kvm@vger.kernel.org>, Christoffer Dall <cdall@kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Punit Agrawal <punit.agrawal@arm.com>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Kristina Martsenko <kristina.martsenko@arm.com>, Mark Rutland <mark.rutland@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 27 March 2018 at 14:15, Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
> Expose the maximum physical address size supported by the host
> for a VM. This could be later used by the userspace to choose the
> appropriate size for a given VM. The limit is determined as the
> minimum of actual CPU limit, the kernel limit (i.e, either 48 or 52)
> and the stage2 page table support limit (which is 40bits at the moment).
> For backward compatibility, we support a minimum of 40bits. The limit
> will be lifted as we add support for the stage2 to support the host
> kernel PA limit.
>
> This value may be different from what is exposed to the VM via
> CPU ID registers. The limit only applies to the stage2 page table.
>
> Cc: Christoffer Dall <cdall@kernel.org>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Peter Maydel <peter.maydell@linaro.org>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>  Documentation/virtual/kvm/api.txt | 14 ++++++++++++++
>  arch/arm/include/asm/kvm_mmu.h    |  5 +++++
>  arch/arm64/include/asm/kvm_mmu.h  |  5 +++++
>  include/uapi/linux/kvm.h          |  6 ++++++
>  virt/kvm/arm/arm.c                |  6 ++++++
>  5 files changed, 36 insertions(+)
>
> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> index 792fa87..55908a8 100644
> --- a/Documentation/virtual/kvm/api.txt
> +++ b/Documentation/virtual/kvm/api.txt
> @@ -3500,6 +3500,20 @@ Returns: 0 on success; -1 on error
>  This ioctl can be used to unregister the guest memory region registered
>  with KVM_MEMORY_ENCRYPT_REG_REGION ioctl above.
>
> +4.113 KVM_ARM_GET_MAX_VM_PHYS_SHIFT
> +Capability: basic
> +Architectures: arm, arm64
> +Type: system ioctl
> +Parameters: none
> +Returns: log2(Maximum physical address space size) supported by the
> +hyperviosr.

typo: "hypervisor".

> +
> +This ioctl can be used to identify the maximum physical address space size
> +supported by the hypervisor.

Is that the physical address space on the host, or the physical
address space size we present to the guest?

> The returned value indicates the maximum size
> +of the address that can be resolved by the stage2 translation table on
> +arm/arm64. On arm64, the value is decided based on the host kernel
> +configuration and the system wide safe value of ID_AA64MMFR0_EL1:PARange.
> +This may not match the value exposed to the VM in CPU ID registers.

Isn't it likely to confuse the guest if we lie to it about the PA range it
sees? When would the two values differ?

Do we also need a 'set' operation, so userspace can create a VM
that has a 40 bit userspace on a CPU that supports more than that,
or does it just work?

What's the x86 API for KVM to tell userspace about physical address
range restrictions?

thanks
-- PMM
