From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [GIT PULL] KVM/ARM pull request for 4.3
Date: Sat, 22 Aug 2015 00:00:23 -0700
Message-ID: <55D81E07.2080002@redhat.com>
References: <1440088143-4722-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1440088143-4722-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Gleb Natapov <gleb@kernel.org>
Cc: =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>, Christoffer Dall <christoffer.dall@linaro.org>, Mario Smarduch <m.smarduch@samsung.com>, "Suzuki K. Poulose" <suzuki.poulose@arm.com>, Vladimir Murzin <vladimir.murzin@arm.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu



On 20/08/2015 09:28, Marc Zyngier wrote:
> Hi Paolo,
>=20
> This is the KVM/ARM pull request for Linux 4.3. Some rather major
> things this time around (guest debug, management of interrupt active
> state, lazy FP save/restore).
>=20
> Thanks!
>=20
> 	M.
>=20
> The following changes since commit bc0195aad0daa2ad5b0d76cce22b167bc3=
435590:
>=20
>   Linux 4.2-rc2 (2015-07-12 15:10:30 -0700)
>=20
> are available in the git repository at:
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tag=
s/kvm-arm-for-4.3
>=20
> for you to fetch changes up to 054167b3d55127feb64978eddf3f9f3a84fe49=
3b:
>=20
>   arm: KVM: keep arm vfp/simd exit handling consistent with arm64 (20=
15-08-19 22:27:58 +0100)

Pulled---for now in kvm/queue until I get Alex's pull request.

Paolo

> ----------------------------------------------------------------
> KVM/ARM changes for 4.3
>=20
> - Full debug support for arm64
> - Active state switching for timer interrupts
> - Lazy FP/SIMD save/restore for arm64
> - Generic ARMv8 target
>=20
> ----------------------------------------------------------------
> Alex Benn=C3=A9e (11):
>       KVM: add comments for kvm_debug_exit_arch struct
>       KVM: arm64: guest debug, define API headers
>       KVM: arm: guest debug, add stub KVM_SET_GUEST_DEBUG ioctl
>       KVM: arm: introduce kvm_arm_init/setup/clear_debug
>       KVM: arm64: guest debug, add SW break point support
>       KVM: arm64: guest debug, add support for single-step
>       KVM: arm64: re-factor hyp.S debug register code
>       KVM: arm64: introduce vcpu->arch.debug_ptr
>       KVM: arm64: guest debug, HW assisted debug support
>       KVM: arm64: enable KVM_CAP_SET_GUEST_DEBUG
>       KVM: arm64: add trace points for guest_debug debug
>=20
> Marc Zyngier (10):
>       arm/arm64: KVM: Fix ordering of timer/GIC on guest entry
>       arm/arm64: KVM: Move vgic handling to a non-preemptible section
>       KVM: arm/arm64: vgic: Convert struct vgic_lr to use bitfields
>       KVM: arm/arm64: vgic: Allow HW irq to be encoded in LR
>       KVM: arm/arm64: vgic: Relax vgic_can_sample_irq for edge IRQs
>       KVM: arm/arm64: vgic: Allow dynamic mapping of physical/virtual=
 interrupts
>       KVM: arm/arm64: vgic: Allow HW interrupts to be queued to a gue=
st
>       KVM: arm/arm64: vgic: Add vgic_{get,set}_phys_irq_active
>       KVM: arm/arm64: vgic: Prevent userspace injection of a mapped i=
nterrupt
>       KVM: arm/arm64: timer: Allow the timer to control the active st=
ate
>=20
> Mario Smarduch (2):
>       arm64: KVM: Optimize arm64 skip 30-50% vfp/simd save/restore on=
 exits
>       arm: KVM: keep arm vfp/simd exit handling consistent with arm64
>=20
> Suzuki K. Poulose (1):
>       arm64/kvm: Add generic v8 KVM target
>=20
> Vladimir Murzin (1):
>       arm64: KVM: remove remaining reference to vgic_sr_vectors
>=20
>  Documentation/virtual/kvm/api.txt      |  15 +-
>  arch/arm/include/asm/kvm_host.h        |   5 +
>  arch/arm/kvm/arm.c                     |  36 +-
>  arch/arm/kvm/guest.c                   |   6 +
>  arch/arm/kvm/interrupts.S              |  14 +-
>  arch/arm/kvm/reset.c                   |   4 +-
>  arch/arm64/include/asm/hw_breakpoint.h |  14 +
>  arch/arm64/include/asm/kvm_arm.h       |   5 +-
>  arch/arm64/include/asm/kvm_asm.h       |  26 +-
>  arch/arm64/include/asm/kvm_host.h      |  42 ++-
>  arch/arm64/include/uapi/asm/kvm.h      |  37 +-
>  arch/arm64/kernel/asm-offsets.c        |   9 +-
>  arch/arm64/kernel/hw_breakpoint.c      |  12 -
>  arch/arm64/kvm/Makefile                |   2 +-
>  arch/arm64/kvm/debug.c                 | 217 ++++++++++++
>  arch/arm64/kvm/guest.c                 |  43 ++-
>  arch/arm64/kvm/handle_exit.c           |  44 +++
>  arch/arm64/kvm/hyp.S                   | 617 ++++++++++++-----------=
----------
>  arch/arm64/kvm/reset.c                 |  20 +-
>  arch/arm64/kvm/sys_regs.c              | 291 ++++++++++++++--
>  arch/arm64/kvm/sys_regs.h              |   6 +
>  arch/arm64/kvm/sys_regs_generic_v8.c   |   2 +
>  arch/arm64/kvm/trace.h                 | 123 +++++++
>  include/kvm/arm_arch_timer.h           |   7 +-
>  include/kvm/arm_vgic.h                 |  39 ++-
>  include/linux/irqchip/arm-gic-v3.h     |   3 +
>  include/linux/irqchip/arm-gic.h        |   3 +-
>  include/uapi/linux/kvm.h               |   5 +
>  virt/kvm/arm/arch_timer.c              |  29 +-
>  virt/kvm/arm/vgic-v2.c                 |  16 +-
>  virt/kvm/arm/vgic-v3.c                 |  21 +-
>  virt/kvm/arm/vgic.c                    | 427 +++++++++++++++++++++--
>  32 files changed, 1596 insertions(+), 544 deletions(-)
>  create mode 100644 arch/arm64/kvm/debug.c
>=20
