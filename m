From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v5 0/6] QEMU support for KVM Guest Debug on arm64
Date: Fri, 29 May 2015 16:19:18 +0100
Message-ID: <1432912764-7073-1-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: qemu-devel@nongnu.org, peter.maydell@linaro.org, christoffer.dall@linaro.org, zhichao.huang@linaro.org
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

You may be wondering what happened to v3 and v4. They do exist but
they didn't change much from the the original patches as I've been
mostly looking the kernel side of the equation. So in summary the
changes are:

  - updates to the kernel ABI
  - don't fall over on kernels without debug support
  - better logging, syncing and use of internals.h
  - debug exception re-injection for guest events*

More detailed changelogs are attached to each patch.

* see
  https://lists.cs.columbia.edu/pipermail/kvmarm/2015-May/014807.html

GIT Repos:

The patch series is based off a recent master and can be found at:

https://github.com/stsquad/qemu
branch: kvm/guest-debug-v5

The kernel patches for this series are based off a v4.1-rc5-v5 and can =
be
found at:

https://git.linaro.org/people/alex.bennee/linux.git
branch: guest-debug/4.1-rc5-v5

Alex Benn=C3=A9e (6):
  linux-headers: sync from my kernel tree (DEV)
  target-arm: kvm64: introduce kvm_arm_init_debug()
  target-arm: kvm - implement software breakpoints
  target-arm: kvm - support for single step
  target-arm: kvm - add support for HW assisted debug
  target-arm: kvm - re-inject guest debug exceptions

 include/standard-headers/linux/virtio_balloon.h |  28 ++-
 include/standard-headers/linux/virtio_blk.h     |   8 +-
 include/standard-headers/linux/virtio_ids.h     |   1 +
 include/standard-headers/linux/virtio_input.h   |  76 ++++++
 include/standard-headers/linux/virtio_ring.h    |   2 +-
 linux-headers/asm-arm/kvm.h                     |   9 +-
 linux-headers/asm-arm64/kvm.h                   |  29 ++-
 linux-headers/asm-mips/kvm.h                    | 164 +++++++-----
 linux-headers/asm-s390/kvm.h                    |   4 +
 linux-headers/asm-x86/hyperv.h                  |   2 +
 linux-headers/linux/kvm.h                       |  71 +++++-
 linux-headers/linux/vfio.h                      |   2 +
 target-arm/cpu.h                                |   1 +
 target-arm/helper-a64.c                         |  17 +-
 target-arm/internals.h                          |   1 +
 target-arm/kvm.c                                | 137 ++++++++--
 target-arm/kvm64.c                              | 318 ++++++++++++++++=
++++++++
 target-arm/kvm_arm.h                            |  21 ++
 18 files changed, 790 insertions(+), 101 deletions(-)
 create mode 100644 include/standard-headers/linux/virtio_input.h

--=20
2.4.1

