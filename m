From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 15/20] kvm: arm/arm64: Allow tuning the physical
 address size for VM
Date: Mon, 2 Jul 2018 14:13:59 +0100
Message-ID: <f7715da8-73ea-28fb-9883-8d0c048e0792@arm.com>
References: <1530270944-11351-1-git-send-email-suzuki.poulose@arm.com>
 <1530270944-11351-16-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1530270944-11351-16-git-send-email-suzuki.poulose@arm.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Suzuki K Poulose <suzuki.poulose@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, james.morse@arm.com, cdall@kernel.org, eric.auger@redhat.com, julien.grall@arm.com, will.deacon@arm.com, catalin.marinas@arm.com, punit.agrawal@arm.com, qemu-devel@nongnu.org, Peter Maydel <peter.maydell@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 29/06/18 12:15, Suzuki K Poulose wrote:
> Allow specifying the physical address size for a new VM via
> the kvm_type argument for KVM_CREATE_VM ioctl. This allows
> us to finalise the stage2 page table format as early as possible
> and hence perform the right checks on the memory slots without
> complication. The size is encoded as Log2(PA_Size) in the bits[7:0]
> of the type field and can encode more information in the future if
> required. The IPA size is still capped at 40bits.

Can't we relax this? There is no technical reason (AFAICS) not to allow
going down to 36bit IPA if the user has requested it.

If we run on a 36bit IPA system, the default would fail. But if the user
specified "please give me a 36bit IPA VM", we could satisfy that
requirement and allow them to run their stupidly small guest!

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
