From: Amit Daniel Kachhap <amit.kachhap@arm.com>
Subject: [PATCH v6 0/6] Add ARMv8.3 pointer authentication for kvm guest
Date: Tue, 19 Feb 2019 14:54:25 +0530
Message-ID: <1550568271-5319-1-git-send-email-amit.kachhap@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E574F4A331
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Feb 2019 04:25:05 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id G8HJuoLEGnSH for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Feb 2019 04:25:02 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C1AC64A2E5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Feb 2019 04:25:02 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>, kvmarm@lists.cs.columbia.edu, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, Amit Daniel Kachhap <amit.kachhap@arm.com>, Dave Martin <Dave.Martin@arm.com>, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

This patch series adds pointer authentication support for KVM guest and
is based on top of Linux 5.0-rc6. The basic patches in this series was
originally posted by Mark Rutland earlier[1,2] and contains some history
of this work.

Extension Overview:
=============================================

The ARMv8.3 pointer authentication extension adds functionality to detect
modification of pointer values, mitigating certain classes of attack such as
stack smashing, and making return oriented programming attacks harder.

The extension introduces the concept of a pointer authentication code (PAC),
which is stored in some upper bits of pointers. Each PAC is derived from the
original pointer, another 64-bit value (e.g. the stack pointer), and a secret
128-bit key.

New instructions are added which can be used to:

* Insert a PAC into a pointer
* Strip a PAC from a pointer
* Authenticate and strip a PAC from a pointer

The detailed description of ARMv8.3 pointer authentication support in
userspace/kernel and can be found in Kristina's generic pointer authentication
patch series[3].

KVM guest work:
==============================================

If pointer authentication is enabled for KVM guests then the new PAC instructions
will not trap to EL2. If not then they may be ignored if in HINT region or trapped
in EL2 as illegal instruction. Since KVM guest vcpu runs as a thread so they have
a key initialized which will be used by PAC. When world switch happens between
host and guest then this key is exchanged.

There were some review comments by Christoffer Dall in the original series [1,2,3]
and this patch series tries to implement them.

The current v6 patch series contains most of the suggestions by James Morse,
Kristina, Julien and Dave.

This patch series is based on just a single patch from Dave Martin [8] which add
control checks for accessing sys registers. 

Changes since v5 [7]: Major changes are listed below.

* Split hcr_el2 and mdcr_el2 save/restore in two patches.
* Reverted back save/restore of sys-reg keys as done in V4 [5]. There was
  suggestion by James Morse to use ptrauth utilities in a single place
  in arm core and use them from kvm. However this change deviates from the
  existing sys-reg implementations and is not scalable.
* Invoked the key switch C functions from __guest_enter/__guest_exit assembly.
* Host key save is now done inside vcpu_load.
* Reverted back masking of cpufeature ID registers for ptrauth when disabled
  from userpace.
* Reset of ptrauth key registers not done conditionally.
* Code and Documentation cleanup.

Changes since v4 [6]: Several suggestions from James Morse
* Move host registers to be saved/restored inside struct kvm_cpu_context.
* Similar to hcr_el2, save/restore mdcr_el2 register also.
* Added save routines for ptrauth keys in generic arm core and
  use them during KVM context switch.
* Defined a GCC attribute __no_ptrauth which discards generating
  ptrauth instructions in a function. This is taken from Kristina's
  earlier kernel pointer authentication support patches [4].
* Dropped a patch to mask cpufeature when not enabled from userspace and
  now only key registers are masked from register list.

Changes since v3 [5]:
* Use pointer authentication only when VHE is present as ARM8.3 implies ARM8.1
  features to be present.
* Added lazy context handling of ptrauth instructions from V2 version again. 
* Added more details in Documentation.

Changes since v2 [1,2]:
* Allow host and guest to have different HCR_EL2 settings and not just constant
  value HCR_HOST_VHE_FLAGS or HCR_HOST_NVHE_FLAGS.
* Optimise the reading of HCR_EL2 in host/guest switch by fetching it once
  during KVM initialisation state and using it later.
* Context switch pointer authentication keys when switching between guest
  and host. Pointer authentication was enabled in a lazy context earlier[2] and
  is removed now to make it simple. However it can be revisited later if there
  is significant performance issue.
* Added a userspace option to choose pointer authentication.
* Based on the userspace option, ptrauth cpufeature will be visible.
* Based on the userspace option, ptrauth key registers will be accessible.
* A small document is added on how to enable pointer authentication from
  userspace KVM API.

Looking for feedback and comments.

Thanks,
Amit

[1]: https://lore.kernel.org/lkml/20171127163806.31435-11-mark.rutland@arm.com/
[2]: https://lore.kernel.org/lkml/20171127163806.31435-10-mark.rutland@arm.com/
[3]: https://lkml.org/lkml/2018/12/7/666
[4]: https://lore.kernel.org/lkml/20181005084754.20950-1-kristina.martsenko@arm.com/
[5]: https://lkml.org/lkml/2018/10/17/594
[6]: https://lkml.org/lkml/2018/12/18/80
[7]: https://lkml.org/lkml/2019/1/28/49
[8]: https://lore.kernel.org/linux-arm-kernel/1547757219-19439-13-git-send-email-Dave.Martin@arm.com/


Linux (5.0-rc6 based):

Amit Daniel Kachhap (5):
  arm64/kvm: preserve host HCR_EL2 value
  arm64/kvm: preserve host MDCR_EL2 value
  arm64/kvm: context-switch ptrauth registers
  arm64/kvm: add a userspace option to enable pointer authentication
  arm64/kvm: control accessibility of ptrauth key registers

 Documentation/arm64/pointer-authentication.txt |  13 ++-
 Documentation/virtual/kvm/api.txt              |   4 +
 arch/arm/include/asm/kvm_host.h                |   4 +-
 arch/arm64/include/asm/kvm_asm.h               |   2 +
 arch/arm64/include/asm/kvm_emulate.h           |  22 ++---
 arch/arm64/include/asm/kvm_host.h              |  45 ++++++++--
 arch/arm64/include/asm/kvm_hyp.h               |   9 +-
 arch/arm64/include/uapi/asm/kvm.h              |   1 +
 arch/arm64/kernel/traps.c                      |   1 +
 arch/arm64/kvm/debug.c                         |  28 ++----
 arch/arm64/kvm/guest.c                         |   2 +-
 arch/arm64/kvm/handle_exit.c                   |  21 +++--
 arch/arm64/kvm/hyp/Makefile                    |   1 +
 arch/arm64/kvm/hyp/entry.S                     |  17 ++++
 arch/arm64/kvm/hyp/ptrauth-sr.c                | 115 +++++++++++++++++++++++++
 arch/arm64/kvm/hyp/switch.c                    |  40 ++++-----
 arch/arm64/kvm/hyp/sysreg-sr.c                 |  27 +++++-
 arch/arm64/kvm/hyp/tlb.c                       |   6 +-
 arch/arm64/kvm/reset.c                         |   3 +
 arch/arm64/kvm/sys_regs.c                      |  66 +++++++++++---
 include/uapi/linux/kvm.h                       |   1 +
 virt/kvm/arm/arm.c                             |   4 +-
 22 files changed, 338 insertions(+), 94 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/ptrauth-sr.c

kvmtool:

Repo: git.kernel.org/pub/scm/linux/kernel/git/will/kvmtool.git

Amit Daniel Kachhap (1):
  arm/kvm: arm64: Add a vcpu feature for pointer authentication

 arm/aarch32/include/kvm/kvm-cpu-arch.h    | 1 +
 arm/aarch64/include/asm/kvm.h             | 1 +
 arm/aarch64/include/kvm/kvm-config-arch.h | 4 +++-
 arm/aarch64/include/kvm/kvm-cpu-arch.h    | 1 +
 arm/include/arm-common/kvm-config-arch.h  | 1 +
 arm/kvm-cpu.c                             | 6 ++++++
 include/linux/kvm.h                       | 1 +
 7 files changed, 14 insertions(+), 1 deletion(-)

-- 
2.7.4
