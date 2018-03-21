From: Dave Martin <Dave.Martin@arm.com>
Subject: [RFC PATCH 0/4] KVM: arm64: Optimise FPSIMD context switching
Date: Wed, 21 Mar 2018 17:47:29 +0000
Message-ID: <1521654453-3837-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <cdall@kernel.org>, linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

This is the second spin of my attempt to improve FPSIMD context handling
for KVM.  It is different enough from the previous attempt that I don't
claim it's a v2 of the same RFC.

The patches are based on Christoffer's VHE optimisation series.

See the final patch of the series for the bulk of the explanation for
these changes.

Some things definitely aren't right yet:

 * Handling of the host SVE state is incomplete: the Hyp code still
   needs to be taught how to save back the host SVE state in the right
   place.  This will eliminate redundant work in some scenarios and
   obviate the need for sve_flush_cpu_state().

 * TIF_SVE is probably not set/cleared in exactly the correct places
   (not tested/exercised, because SVE in general doesn't work here yet).

 * A few open-coded sequences of calls to fpsimd.c helpers should be
   wrapped up in new helper functions and moved to fpsimd.h or fpsimd.c.

 * task_fpsimd_save() now appears misnamed, but in lieu of having
   decided on a better name I've just exported this function from
   fpsimd.c for now.

 * arm64-specific code has been splatted down in parts of arm.c that
   need to work on arm too, so this series probably breaks arm right
   now.

Christoffer raised some concerns on the previous RFC regarding new
conditional code being added on the critical path.  I believe this is
now mostly or completely gone, with new conditional code displacing
conditional code that the series removes elsewhere.

Due to the various interacting changes made by the final patch it has a
confusing, monster commit message, but I've struggled to split the
changes up in a sensible way.

Any feedback appreciated!

Cheers
---Dave

Christoffer Dall (1):
  KVM: arm/arm64: Introduce kvm_arch_vcpu_run_pid_change

Dave Martin (3):
  KVM: arm64: Convert lazy FPSIMD context switch trap to C
  arm64: fpsimd: Split cpu field out from struct fpsimd_state
  KVM: arm64: Optimise FPSIMD context switching

 arch/arm64/include/asm/fpsimd.h    | 34 ++++----------------
 arch/arm64/include/asm/kvm_host.h  |  7 ++++
 arch/arm64/include/asm/processor.h |  4 +--
 arch/arm64/kernel/fpsimd.c         | 66 +++++++++++++++++++++++---------------
 arch/arm64/kernel/ptrace.c         | 10 +++---
 arch/arm64/kernel/signal.c         |  3 +-
 arch/arm64/kernel/signal32.c       |  3 +-
 arch/arm64/kvm/Kconfig             |  1 +
 arch/arm64/kvm/hyp/entry.S         | 57 +++++++++++++-------------------
 arch/arm64/kvm/hyp/switch.c        | 60 ++++++++++++++++++++++++++--------
 include/linux/kvm_host.h           |  9 ++++++
 virt/kvm/Kconfig                   |  3 ++
 virt/kvm/arm/arm.c                 | 58 +++++++++++++++++++++++++++++++++
 virt/kvm/kvm_main.c                |  7 +++-
 14 files changed, 210 insertions(+), 112 deletions(-)

-- 
2.1.4
