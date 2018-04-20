From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 0/5] KVM/arm fixes for 4.17-rc2
Date: Fri, 20 Apr 2018 17:07:08 +0100
Message-ID: <20180420160713.17884-1-marc.zyngier@arm.com>
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
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Stefano Stabellini <sstabellini@kernel.org>, Christoffer Dall <cdall@kernel.org>, kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, Shannon Zhao <zhaoshenglong@huawei.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Radim, Paolo,

Here is the first batch of KVM/arm fixes post 4.17 merge window. Not a
lot to report, apart from the slightly scary VMID allocation race that
has been sitting there from day 1.

Please pull.

	M.

The following changes since commit 60cc43fc888428bb2f18f08997432d426a243338:

  Linux 4.17-rc1 (2018-04-15 18:24:20 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-for-4.17-1

for you to fetch changes up to 85bd0ba1ff9875798fad94218b627ea9f768f3c3:

  arm/arm64: KVM: Add PSCI version selection API (2018-04-20 16:32:23 +0100)

----------------------------------------------------------------
KVM/arm fixes for 4.17, take #1

- PSCI selection API, a leftover from 4.16
- Kick vcpu on active interrupt affinity change
- Plug a VMID allocation race on oversubscribed systems
- Silence debug messages
- Update Christoffer's email address

----------------------------------------------------------------
Andre Przywara (1):
      KVM: arm/arm64: vgic: Kick new VCPU on interrupt migration

Christoffer Dall (1):
      MAINTAINERS: Update e-mail address for Christoffer Dall

Marc Zyngier (3):
      KVM: arm/arm64: Close VMID generation race
      arm64: KVM: Demote SVE and LORegion warnings to debug only
      arm/arm64: KVM: Add PSCI version selection API

 Documentation/virtual/kvm/api.txt      |  9 ++++-
 Documentation/virtual/kvm/arm/psci.txt | 30 +++++++++++++++++
 MAINTAINERS                            |  4 +--
 arch/arm/include/asm/kvm_host.h        |  3 ++
 arch/arm/include/uapi/asm/kvm.h        |  6 ++++
 arch/arm/kvm/guest.c                   | 13 ++++++++
 arch/arm64/include/asm/kvm_host.h      |  3 ++
 arch/arm64/include/uapi/asm/kvm.h      |  6 ++++
 arch/arm64/kvm/guest.c                 | 14 +++++++-
 arch/arm64/kvm/sys_regs.c              |  6 ++--
 include/kvm/arm_psci.h                 | 16 +++++++--
 virt/kvm/arm/arm.c                     | 15 ++++++---
 virt/kvm/arm/psci.c                    | 60 ++++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic.c               |  8 +++++
 14 files changed, 178 insertions(+), 15 deletions(-)
 create mode 100644 Documentation/virtual/kvm/arm/psci.txt
