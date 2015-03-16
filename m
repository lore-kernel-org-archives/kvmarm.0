From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v4 0/5] QEMU ARM64 Migration Fixes
Date: Mon, 16 Mar 2015 11:01:51 +0000
Message-ID: <1426503716-13931-1-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

This is hopefully the final update to the series. I've skipped v3 for
the purposes of having a sane relationship to the branch name ;-)

v4
  - Dropped the pl011 IRQ fiddling patch
  - Save/Restore MP STATE
    - moved into kvm.c
    - changed MP_STATE to STOPPED
  - Sync FP State
    - Removed superfluous reg.id++
  - Save/Restore SPSR
    - try and make commentary clearer
    - ensure env->banked_spsr[0] =3D env->spsr before we sync
  - document env->spsr
    - briefer commit message, leaving questions for the list ;-)

I submitted the kernel side of this on Friday

Branch: https://github.com/stsquad/qemu/tree/migration/fixes-v4
Kernel: https://git.linaro.org/people/alex.bennee/linux.git/shortlog/re=
fs/heads/migration/kvmarm-fixes-for-4.0-v3

Alex Benn=C3=A9e (4):
  target-arm: kvm: save/restore mp state
  hw/intc: arm_gic_kvm.c restore config first
  target-arm: kvm64 sync FP register state
  target-arm: cpu.h document why env->spsr exists

Christoffer Dall (1):
  target-arm: kvm64 fix save/restore of SPSR regs

 hw/intc/arm_gic_kvm.c |   7 +++-
 target-arm/cpu.h      |   5 +++
 target-arm/kvm.c      |  40 ++++++++++++++++++
 target-arm/kvm32.c    |   4 ++
 target-arm/kvm64.c    | 111 ++++++++++++++++++++++++++++++++++++++++++=
+++++---
 target-arm/kvm_arm.h  |  18 ++++++++
 6 files changed, 178 insertions(+), 7 deletions(-)

--=20
2.3.2

