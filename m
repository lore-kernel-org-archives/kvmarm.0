From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v5 0/6] QEMU ARM64 Migration Fixes
Date: Mon, 23 Mar 2015 17:05:38 +0000
Message-ID: <1427130344-27986-1-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

=46ollowing some review comments (and a patch) from Peter I've re-spun
this series:

v5
  - Added Peter's SPSR_EL1 state fix for architectural mapping
  - As a result SPSR save/restore no longer does munge
  - FP register save/restore re-done to deal float128 mapping
  - Some minor [ spaces ] added

I submitted the kernel side of this on Friday

Branch: https://github.com/stsquad/qemu/tree/migration/fixes-v5
Kernel: https://git.linaro.org/people/alex.bennee/linux.git/shortlog/re=
fs/heads/migration/kvmarm-fixes-for-4.0-v3

Alex Benn=C3=A9e (5):
  target-arm: kvm: save/restore mp state
  hw/intc: arm_gic_kvm.c restore config first
  target-arm: kvm64 sync FP register state
  target-arm: kvm64 fix save/restore of SPSR regs
  target-arm: cpu.h document why env->spsr exists

Peter Maydell (1):
  target-arm: Store SPSR_EL1 state in banked_spsr[1] (SPSR_svc)

 hw/intc/arm_gic_kvm.c   |   7 ++-
 target-arm/cpu.h        |   5 +++
 target-arm/helper-a64.c |   2 +-
 target-arm/helper.c     |   2 +-
 target-arm/internals.h  |   5 ++-
 target-arm/kvm.c        |  40 +++++++++++++++++
 target-arm/kvm32.c      |   4 ++
 target-arm/kvm64.c      | 111 ++++++++++++++++++++++++++++++++++++++++=
+++++---
 target-arm/kvm_arm.h    |  18 ++++++++
 9 files changed, 184 insertions(+), 10 deletions(-)

--=20
2.3.2

