From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v3 15/20] kvm: arm/arm64: Allow tuning the physical
 address size for VM
Date: Wed, 4 Jul 2018 16:51:04 +0100
Message-ID: <20180704155104.GN4828@arm.com>
References: <1530270944-11351-1-git-send-email-suzuki.poulose@arm.com>
 <1530270944-11351-16-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1530270944-11351-16-git-send-email-suzuki.poulose@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, james.morse@arm.com, marc.zyngier@arm.com, cdall@kernel.org, eric.auger@redhat.com, julien.grall@arm.com, catalin.marinas@arm.com, punit.agrawal@arm.com, qemu-devel@nongnu.org, Peter Maydel <peter.maydell@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Suzuki,

On Fri, Jun 29, 2018 at 12:15:35PM +0100, Suzuki K Poulose wrote:
> Allow specifying the physical address size for a new VM via
> the kvm_type argument for KVM_CREATE_VM ioctl. This allows
> us to finalise the stage2 page table format as early as possible
> and hence perform the right checks on the memory slots without
> complication. The size is encoded as Log2(PA_Size) in the bits[7:0]
> of the type field and can encode more information in the future if
> required. The IPA size is still capped at 40bits.
> 
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Christoffer Dall <cdall@kernel.org>
> Cc: Peter Maydel <peter.maydell@linaro.org>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Radim Krčmář <rkrcmar@redhat.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>  arch/arm/include/asm/kvm_mmu.h   |  2 ++
>  arch/arm64/include/asm/kvm_arm.h | 10 +++-------
>  arch/arm64/include/asm/kvm_mmu.h |  2 ++
>  include/uapi/linux/kvm.h         | 10 ++++++++++
>  virt/kvm/arm/arm.c               | 24 ++++++++++++++++++++++--
>  5 files changed, 39 insertions(+), 9 deletions(-)

[...]

> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 4df9bb6..fa4cab0 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -751,6 +751,16 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_S390_SIE_PAGE_OFFSET 1
>  
>  /*
> + * On arm/arm64, machine type can be used to request the physical
> + * address size for the VM. Bits [7-0] have been reserved for the
> + * PA size shift (i.e, log2(PA_Size)). For backward compatibility,
> + * value 0 implies the default IPA size, which is 40bits.
> + */
> +#define KVM_VM_TYPE_ARM_PHYS_SHIFT_MASK	0xff
> +#define KVM_VM_TYPE_ARM_PHYS_SHIFT(x)		\
> +	((x) & KVM_VM_TYPE_ARM_PHYS_SHIFT_MASK)

This seems like you're allocating quite a lot of bits in a non-extensible
interface to a fairly esoteric parameter. Would it be better to add another
ioctl, or condense the number of sizes you support instead?

Will
