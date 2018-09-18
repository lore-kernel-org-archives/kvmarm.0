From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v5 18/18] kvm: arm64: Allow tuning the physical address
 size for VM
Date: Tue, 18 Sep 2018 18:15:04 +0100
Message-ID: <CAFEAcA_tphfZ_BKfAYuefStTipta0notyAR=NCnWFJ6nRfERpg@mail.gmail.com>
References: <20180917104144.19188-1-suzuki.poulose@arm.com>
 <20180917104144.19188-19-suzuki.poulose@arm.com> <CAFEAcA8eWYkzwFYHyP49dasK-NDVbbm=6DbEFNNPq9ZAdUM7JQ@mail.gmail.com>
 <218b64d5-741d-97ef-8aae-bc0a2ac3e56c@arm.com> <CAFEAcA8qjJJ0FkQj4yBMKFrwNFiJj3Q4FBi4GbnK2PN3B3J-mg@mail.gmail.com>
 <fec1a2e0-a45a-eb51-6ffe-2ac9b35acc45@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <fec1a2e0-a45a-eb51-6ffe-2ac9b35acc45@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Cc: arm-mail-list <linux-arm-kernel@lists.infradead.org>, kvmarm@lists.cs.columbia.edu, kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <cdall@kernel.org>, Eric Auger <eric.auger@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, James Morse <james.morse@arm.com>, Dave P Martin <dave.martin@arm.com>, julien.grall@arm.com, lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 18 September 2018 at 17:27, Suzuki K Poulose <Suzuki.Poulose@arm.com> wrote:
> ---
>
> "On arm64, the physical address size for a VM (IPA Size limit) is limited
> to 40bits by default. The limit can be configured if the host supports the
> extension KVM_CAP_ARM_VM_IPA_SIZE. When supported, use
> KVM_VM_TYPE_ARM_IPA_SIZE(IPA_Bits) to set the size in the machine type
> identifier, where IPA_Bits is the maximum width of any physical
> address used by the VM. The IPA_Bits is encoded in bits[7-0] of the
> machine type identifier.
>
> e.g, to configure a guest to use 48bit physical address size :
>
>         vm_fd = ioctl(dev_fd, KVM_CREATE_VM, KVM_VM_TYPE_ARM_IPA_SIZE(48));
>
> The requested size (IPA_Bits) must be :
>   0 - Implies default 40bits (for backward compatibility)
>
>   or
>
>   N - Implies N bits, where N is a positive integer such that 32 <= N <=
> Host_IPA_Limit
>
> Host_IPA_Limit is the maximum possible value for IPA_Bits on the host and
> is dependent on the CPU capability and the kernel configuration. The limit
> can
> be retrieved using KVM_CAP_ARM_VM_IPA_SIZE of the KVM_CHECK_EXTENSION
> ioctl() at run-time.
>
> Please note that configuring the IPA size does not affect the capability
> exposed by the guest CPUs in ID_AA64MMFR0_EL1[PARange]. It only affects
> the guest to host physical address (stage2) translations setup by the host.
> "

Thanks, this is much clearer. The only bit I'm not sure about is that
last paragraph -- if I ask for a VM with a 48 bit address space why
don't we tell the guest that that's what it has ?

thanks
-- PMM
