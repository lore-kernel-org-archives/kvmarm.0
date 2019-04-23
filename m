From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v10 2/5] KVM: arm/arm64: context-switch ptrauth registers
Date: Tue, 23 Apr 2019 16:44:30 +0100
Message-ID: <20190423154430.GM3567@e103592.cambridge.arm.com>
References: <1555994558-26349-1-git-send-email-amit.kachhap@arm.com>
 <1555994558-26349-3-git-send-email-amit.kachhap@arm.com>
 <8636m9awmu.wl-marc.zyngier@arm.com>
 <c961a9d1-8cc8-6e40-de1d-527f7feb0f41@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <c961a9d1-8cc8-6e40-de1d-527f7feb0f41@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Amit Daniel Kachhap <amit.kachhap@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>, kvmarm@lists.cs.columbia.edu, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Apr 23, 2019 at 03:54:32PM +0530, Amit Daniel Kachhap wrote:
> Hi Mark,
> 
> On 4/23/19 3:09 PM, Marc Zyngier wrote:
> >On Tue, 23 Apr 2019 05:42:35 +0100,
> >Amit Daniel Kachhap <amit.kachhap@arm.com> wrote:
> >>
> >>From: Mark Rutland <mark.rutland@arm.com>
> >>
> >>When pointer authentication is supported, a guest may wish to use it.
> >>This patch adds the necessary KVM infrastructure for this to work, with
> >>a semi-lazy context switch of the pointer auth state.
> >>
> >>Pointer authentication feature is only enabled when VHE is built
> >>in the kernel and present in the CPU implementation so only VHE code
> >>paths are modified.
> >>
> >>When we schedule a vcpu, we disable guest usage of pointer
> >>authentication instructions and accesses to the keys. While these are
> >>disabled, we avoid context-switching the keys. When we trap the guest
> >>trying to use pointer authentication functionality, we change to eagerly
> >>context-switching the keys, and enable the feature. The next time the
> >>vcpu is scheduled out/in, we start again. However the host key save is
> >>optimized and implemented inside ptrauth instruction/register access
> >>trap.
> >>
> >>Pointer authentication consists of address authentication and generic
> >>authentication, and CPUs in a system might have varied support for
> >>either. Where support for either feature is not uniform, it is hidden
> >>from guests via ID register emulation, as a result of the cpufeature
> >>framework in the host.
> >>
> >>Unfortunately, address authentication and generic authentication cannot
> >>be trapped separately, as the architecture provides a single EL2 trap
> >>covering both. If we wish to expose one without the other, we cannot
> >>prevent a (badly-written) guest from intermittently using a feature
> >>which is not uniformly supported (when scheduled on a physical CPU which
> >>supports the relevant feature). Hence, this patch expects both type of
> >>authentication to be present in a cpu.
> >>
> >>This switch of key is done from guest enter/exit assembly as preparation
> >>for the upcoming in-kernel pointer authentication support. Hence, these
> >>key switching routines are not implemented in C code as they may cause
> >>pointer authentication key signing error in some situations.
> >>
> >>Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> >>[Only VHE, key switch in full assembly, vcpu_has_ptrauth checks
> >>, save host key in ptrauth exception trap]
> >>Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
> >>Reviewed-by: Julien Thierry <julien.thierry@arm.com>
> >>Cc: Marc Zyngier <marc.zyngier@arm.com>
> >>Cc: Christoffer Dall <christoffer.dall@arm.com>
> >>Cc: kvmarm@lists.cs.columbia.edu
> >>---
> >>Changes since v9:
> >>
> >>* Removed hardcoding of enum values[Mark Zyngier].
> >>* Changed kvm_ptrauth_asm.h to kvm_ptrauth.h[Mark Zyngier].
> >>* Removed macro __ptrauth_save_state and applied inline [Marc Zyngier].
> >>* Moved kvm_arm_vcpu_ptrauth_setup_lazy, kvm_arm_vcpu_ptrauth_enable and
> >>   kvm_arm_vcpu_ptrauth_disable from *.c to kvm_emulate.h file [Marc Zyngier].
> >>* Added/Modified comments at few places [Marc Zyngier].
> >>
> >>  arch/arm/include/asm/kvm_emulate.h   |   2 +
> >>  arch/arm64/Kconfig                   |   5 +-
> >>  arch/arm64/include/asm/kvm_emulate.h |  16 ++++++
> >>  arch/arm64/include/asm/kvm_host.h    |  14 +++++
> >>  arch/arm64/include/asm/kvm_ptrauth.h | 108 +++++++++++++++++++++++++++++++++++
> >>  arch/arm64/kernel/asm-offsets.c      |   6 ++
> >>  arch/arm64/kvm/handle_exit.c         |  36 +++++++++---
> >>  arch/arm64/kvm/hyp/entry.S           |  15 +++++
> >>  arch/arm64/kvm/sys_regs.c            |  43 +++++++++++++-
> >>  virt/kvm/arm/arm.c                   |   2 +
> >>  10 files changed, 234 insertions(+), 13 deletions(-)
> >>  create mode 100644 arch/arm64/include/asm/kvm_ptrauth.h

[...]

> >>diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> >>index 7e34b9e..3cfe2eb 100644
> >>--- a/arch/arm64/Kconfig
> >>+++ b/arch/arm64/Kconfig
> >>@@ -1301,8 +1301,9 @@ config ARM64_PTR_AUTH
> >>  	  context-switched along with the process.
> >>  	  The feature is detected at runtime. If the feature is not present in
> >>-	  hardware it will not be advertised to userspace nor will it be
> >>-	  enabled.
> >>+	  hardware it will not be advertised to userspace/KVM guest nor will it
> >>+	  be enabled. However, KVM guest also require VHE mode and hence
> >>+	  CONFIG_ARM64_VHE=y option to use this feature.
> >
> >SVE seems to have the exact same requirements, and has
> >
> >	depends on !KVM || ARM64_VHE
> >
> >Why don't we have that for PTR_AUTH too?
> This point came up earlier also and it was suggested by  Dave[1] to leave
> userspace ptrauth for non-vhe mode as that would bring regression now.
> [1]:https://lkml.org/lkml/2019/3/27/583

I see Marc applied this change in
https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git/commit/?h=queue&id=e19b245fa4c61558536bd34f80845f0c41eab65f0

The risk here is that someone has a custom config from an old kernel
that explicitly turns CONFIG_ARM64_VHE off, and that try to use that
config with this patch.

I'm not sure how much we care about that.

Otherwise, blocking this config so that people don't accidentally rely
on it seems sensible.

[...]

Cheers
---Dave
