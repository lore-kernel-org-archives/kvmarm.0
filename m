From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v5 18/18] kvm: arm64: Allow tuning the physical address
 size for VM
Date: Mon, 17 Sep 2018 15:20:15 +0100
Message-ID: <CAFEAcA-AKpkzSpMofMFxxf5XdYPii3PTB8xXDAvmyFWno7nZeA@mail.gmail.com>
References: <20180917104144.19188-1-suzuki.poulose@arm.com> <20180917104144.19188-19-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180917104144.19188-19-suzuki.poulose@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: arm-mail-list <linux-arm-kernel@lists.infradead.org>, kvmarm@lists.cs.columbia.edu, kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <cdall@kernel.org>, Eric Auger <eric.auger@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, James Morse <james.morse@arm.com>, Dave P Martin <dave.martin@arm.com>, julien.grall@arm.com, lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 17 September 2018 at 11:41, Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
> Allow specifying the physical address size limit for a new
> VM via the kvm_type argument for the KVM_CREATE_VM ioctl. This
> allows us to finalise the stage2 page table as early as possible
> and hence perform the right checks on the memory slots
> without complication. The size is ecnoded as Log2(PA_Size) in
> bits[7:0] of the type field. For backward compatibility the
> value 0 is reserved and implies 40bits. Also, lift the limit
> of the IPA to host limit and allow lower IPA sizes (e.g, 32).
>
> The userspace could check the extension KVM_CAP_ARM_VM_PHYS_SHIFT
> for the availability of this feature. The cap check returns the
> maximum limit for the physical address shift supported by the host.
>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Christoffer Dall <cdall@kernel.org>
> Cc: Peter Maydel <peter.maydell@linaro.org>

Typo: my surname has two "l"s in it.

thanks
-- PMM
