From: Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 0/3] arm64/kvm spectre-v1 fixes
Date: Wed, 25 Apr 2018 17:13:39 +0100
Message-ID: <20180425161342.38133-1-mark.rutland@arm.com>
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
To: linux-arm-kernel@lists.infradead.org
Cc: mark.rutland@arm.com, cdall@kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

These patches fix arm64-specific potential spectre-v1 gadgets found by
smatch when run over v4.17-rc2.

I'm still building up my smatch database, so it's possible that there are
further gadgets to be found.

For the moment I've ignored issues which appear to be cross-architecture.

Thanks,
Mark.

Mark Rutland (3):
  arm64: fix possible spectre-v1 in ptrace_hbp_get_event()
  KVM: arm/arm64: vgic: fix possible spectre-v1 in vgic_get_irq()
  KVM: arm/arm64: vgic: fix possible spectre-v1 in vgic_mmio_read_apr()

 arch/arm64/kernel/ptrace.c       | 14 ++++++++++----
 virt/kvm/arm/vgic/vgic-mmio-v2.c |  5 +++++
 virt/kvm/arm/vgic/vgic.c         | 14 ++++++++++----
 3 files changed, 25 insertions(+), 8 deletions(-)

-- 
2.11.0
