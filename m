From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 0/4] KVM/arm64: Cache maintenance relaxations
Date: Thu, 17 May 2018 11:35:44 +0100
Message-ID: <20180517103548.5622-1-marc.zyngier@arm.com>
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
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Christoffer Dall <christoffer.dall@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

This small series makes use of features recently introduced in the
ARMv8 architecture to relax the cache maintenance operations on CPUs
that implement these features.

FWB is the most important one. It allows stage-2 to enforce the
cacheability of memory, no matter what the guest says. It also
mandates that the whole machine is cache coherent (no non-coherent
I/O), meaning we can drop a whole class of cache maintenance
operations.

FWB, when combined with CTL_EL0.{IDC,DIC} allows the removal of all
cache maintenance and tracking of pages being executed.

We also take the opportunity to drop a few useless CMOs that were
applied to the HYP page tables, but that were never necessary.

Marc Zyngier (4):
  arm64: KVM: Add support for Stage-2 control of memory types and
    cacheability
  arm64: KVM: Avoid marking pages as XN in Stage-2 if CTR_EL0.DIC is set
  KVM: arm/arm64: Remove unnecessary CMOs when creating HYP page tables
  arm64: KVM: Handle Set/Way CMOs as NOPs if FWB is present

 arch/arm64/include/asm/cpucaps.h      |  3 ++-
 arch/arm64/include/asm/kvm_arm.h      |  1 +
 arch/arm64/include/asm/kvm_emulate.h  |  2 ++
 arch/arm64/include/asm/kvm_mmu.h      | 24 +++++++++++++++++-------
 arch/arm64/include/asm/memory.h       |  7 +++++++
 arch/arm64/include/asm/pgtable-prot.h | 24 ++++++++++++++++++++++--
 arch/arm64/include/asm/sysreg.h       |  1 +
 arch/arm64/kernel/cpufeature.c        | 20 ++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c             |  8 +++++++-
 virt/kvm/arm/mmu.c                    |  9 +++++----
 10 files changed, 84 insertions(+), 15 deletions(-)

-- 
2.14.2
