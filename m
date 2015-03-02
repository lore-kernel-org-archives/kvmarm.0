From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v2 0/5] KVM ARM64 Migration Fixes
Date: Mon,  2 Mar 2015 13:28:59 +0000
Message-ID: <1425302944-6276-1-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

An update to the patch posted earlier this week. Result is textually
identical but

  - split out the vgic_queue_irq_to_lr re-factoring
  - merged doc changes into earlier patch
  - added Acked-by tags

Christoffer,

Are you ok with the split?

The branch I've been working with can be found at:

  http://git.linaro.org/people/alex.bennee/linux.git
  branch: migration/kvmarm-fixes-for-4.0-v2

It includes the two patches from the current kvmarm/master branch.

Alex Benn=C3=A9e (2):
  arm: KVM: export vcpi->pause state via MP_STATE ioctls
  arm: KVM: add a common vgic_queue_irq_to_lr fn

Christoffer Dall (3):
  arm/arm64: KVM: Implement support for unqueueing active IRQs
  arm/arm64: KVM: Fix migration race in the arch timer
  arm/arm64: KVM: Keep elrsr/aisr in sync with software model

 Documentation/virtual/kvm/api.txt |  24 +++-
 arch/arm/kvm/arm.c                |  23 +++-
 include/kvm/arm_arch_timer.h      |   7 ++
 include/kvm/arm_vgic.h            |  16 ++-
 virt/kvm/arm/arch_timer.c         |  45 +++++--
 virt/kvm/arm/vgic-v2-emul.c       |  20 +++-
 virt/kvm/arm/vgic-v2.c            |   8 ++
 virt/kvm/arm/vgic-v3.c            |   8 ++
 virt/kvm/arm/vgic.c               | 245 ++++++++++++++++++++++++++++++=
+-------
 virt/kvm/arm/vgic.h               |   8 ++
 10 files changed, 342 insertions(+), 62 deletions(-)

--=20
2.3.0

