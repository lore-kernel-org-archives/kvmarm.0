From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v3 0/5] KVM ARM64 Migration Fixes
Date: Fri, 13 Mar 2015 17:02:51 +0000
Message-ID: <1426266176-14933-1-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Some fairly minor updates from the last series I sent out:

  - Re-based on v4.0-rc3
  - Use KVM_MP_STATE_STOPPED instead of KVM_MP_STATE_HALTED
  - Some minor textual tidy ups on commit msgs and comments
  - Move the re-factored vgic_queue_irq_to_lr to before the active chan=
ges

The branch I've been working with can be found at:

  http://git.linaro.org/people/alex.bennee/linux.git
  branch: migration/kvmarm-fixes-for-4.0-v3

Alex Benn=C3=A9e (2):
  arm/arm64: KVM: export VCPU power state via MP_STATE ioctl
  arm/arm64: KVM: add a common vgic_queue_irq_to_lr fn

Christoffer Dall (3):
  arm/arm64: KVM: support for un-queuing active IRQs
  arm/arm64: KVM: Fix migration race in the arch timer
  arm/arm64: KVM: Keep elrsr/aisr in sync with software model

 Documentation/virtual/kvm/api.txt |  16 ++-
 arch/arm/kvm/arm.c                |  23 +++-
 include/kvm/arm_arch_timer.h      |   7 ++
 include/kvm/arm_vgic.h            |  16 ++-
 virt/kvm/arm/arch_timer.c         |  45 +++++--
 virt/kvm/arm/vgic-v2-emul.c       |  20 +++-
 virt/kvm/arm/vgic-v2.c            |   8 ++
 virt/kvm/arm/vgic-v3.c            |   8 ++
 virt/kvm/arm/vgic.c               | 244 ++++++++++++++++++++++++++++++=
+-------
 virt/kvm/arm/vgic.h               |   8 ++
 10 files changed, 335 insertions(+), 60 deletions(-)

--=20
2.3.2

