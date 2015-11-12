From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v9 0/6] QEMU support for KVM Guest Debug on arm64
Date: Thu, 12 Nov 2015 16:20:45 +0000
Message-ID: <1447345251-22625-1-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: qemu-devel@nongnu.org, qemu-arm@nongnu.org, peter.maydell@linaro.org, christoffer.dall@linaro.org, zhichao.huang@linaro.org
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

Here is the latest patch set to support debugging of KVM guests on
arm64. The main changes since the last post are that the kernel
patches have now been mainlined. As the recent master has synced up
headers they are no longer needed for this series.

I've add a GDB Python based test into tests/guest-debug. However I
haven't plumbed it in to the "make check" machinery as we don't really
have a good solution for adding binaries for testing (especially in
TCG cases). This patch can be dropped if wanted and I'll just keep it
locally.

So in summary the changes are:

  - Kernel ABI now finalised and mainlined
  - Fixed the handling of watchpoints
  - Removed manual array fiddling in favour of g_array
  - Addressed most of Peter Maydell's review comments
  - The patch series is now checkpatch.pl clean

More detailed changelogs are attached to each patch.

GIT Repo:

The patch series is based off a recent master and can be found at:

https://github.com/stsquad/qemu
branch: kvm/guest-debug-v9


Alex Benn=C3=A9e (6):
  target-arm: kvm64 - introduce kvm_arm_init_debug()
  target-arm: kvm - implement software breakpoints
  target-arm: kvm - support for single step
  target-arm: kvm - add support for HW assisted debug
  target-arm: kvm - re-inject guest debug exceptions
  tests/guest-debug: introduce basic gdbstub tests

 target-arm/helper-a64.c           |  12 +-
 target-arm/kvm.c                  | 137 +++++++++++---
 target-arm/kvm64.c                | 366 ++++++++++++++++++++++++++++++=
++++++++
 target-arm/kvm_arm.h              |  38 ++++
 tests/guest-debug/test-gdbstub.py | 171 ++++++++++++++++++
 5 files changed, 696 insertions(+), 28 deletions(-)
 create mode 100644 tests/guest-debug/test-gdbstub.py

--=20
2.6.3

