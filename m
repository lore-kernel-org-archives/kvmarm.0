From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 0/2] KVM: arm/arm64: GICv2-on-v3 fixes
Date: Sun, 11 Mar 2018 12:49:54 +0000
Message-ID: <20180311124956.7683-1-marc.zyngier@arm.com>
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
Cc: Eric Auger <eric.auger@redhat.com>, Christoffer Dall <cdall@kernel.org>, Andre Przywara <Andre.Przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

I've been trying to run VMs on a GICv3-based system that offers the
GICv2 compatibility feature, and noticed that they would tend to
slowly die under load, or even without load.

It turned out that this is due to KVM not being exactly true to the
architecture, and ends up injecting multiple SGI with the same vintid,
which the architecture clearly outlines as a "don't do that". This bug
has been there since the first days of the "new vgic". This also
affects GICv2, but for some reason GIC-400 seems quite tolerant, and
GIC-500 much less so.

The fix is a bit tortuous, as we must ensure that we never allow
interrupts of lesser priority to be queued before all the pending
multi-source SGIs are injected (I'd be happy to provide beer to
whoever writes a proper unit test for that one).

Another issue is that we don't use the right barriers when exiting
from the guest, as we only synchronize stores, while the architecture
requires to synchronize both loads and stores. And we miss an isb to
force execution of the previous dsb.

- From v1:
  - Reworked patch #1 after much discussions with Christoffer.

Marc Zyngier (2):
  KVM: arm/arm64: vgic: Don't populate multiple LRs with the same vintid
  kvm: arm/arm64: vgic-v3: Tighten synchronization for guests using v2
    on v3

 include/linux/irqchip/arm-gic-v3.h |  1 +
 include/linux/irqchip/arm-gic.h    |  1 +
 virt/kvm/arm/hyp/vgic-v3-sr.c      |  3 +-
 virt/kvm/arm/vgic/vgic-v2.c        |  9 +++++-
 virt/kvm/arm/vgic/vgic-v3.c        |  9 +++++-
 virt/kvm/arm/vgic/vgic.c           | 61 +++++++++++++++++++++++++++++---------
 virt/kvm/arm/vgic/vgic.h           |  2 ++
 7 files changed, 69 insertions(+), 17 deletions(-)

-- 
2.14.2
