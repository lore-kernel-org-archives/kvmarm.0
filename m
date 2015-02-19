From: Alexander Graf <agraf@suse.de>
Subject: Re: [RFC/RFT PATCH 0/3] arm64: KVM: work around incoherency with
 uncached guest mappings
Date: Thu, 19 Feb 2015 15:50:47 +0100
Message-ID: <54E5F847.6050602@suse.de>
References: <1424343286-6792-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1424343286-6792-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, lersek@redhat.com, christoffer.dall@linaro.org, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, peter.maydell@linaro.org
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu



On 19.02.15 11:54, Ard Biesheuvel wrote:
> This is a 0th order approximation of how we could potentially force the guest
> to avoid uncached mappings, at least from the moment the MMU is on. (Before
> that, all of memory is implicitly classified as Device-nGnRnE)
> 
> The idea (patch #2) is to trap writes to MAIR_EL1, and replace uncached mappings
> with cached ones. This way, there is no need to mangle any guest page tables.

Would you mind to give a brief explanation on what this does? What
happens to actually assigned devices that need to be mapped as uncached?
What happens to DMA from such devices when the guest assumes that it's
accessing RAM uncached and then triggers DMA?


Alex

> 
> The downside is that, to do this correctly, we need to always trap writes to
> the VM sysreg group, which includes registers that the guest may write to very
> often. To reduce the associated performance hit, patch #1 introduces a fast path
> for EL2 to perform trivial sysreg writes on behalf of the guest, without the
> need for a full world switch to the host and back.
> 
> The main purpose of these patches is to quantify the performance hit, and
> verify whether the MAIR_EL1 handling works correctly. 
> 
> Ard Biesheuvel (3):
>   arm64: KVM: handle some sysreg writes in EL2
>   arm64: KVM: mangle MAIR register to prevent uncached guest mappings
>   arm64: KVM: keep trapping of VM sysreg writes enabled
> 
>  arch/arm/kvm/mmu.c               |   2 +-
>  arch/arm64/include/asm/kvm_arm.h |   2 +-
>  arch/arm64/kvm/hyp.S             | 101 +++++++++++++++++++++++++++++++++++++++
>  arch/arm64/kvm/sys_regs.c        |  63 ++++++++++++++++++++----
>  4 files changed, 156 insertions(+), 12 deletions(-)
> 
