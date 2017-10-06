From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v1 0/2] KVM: arm64: single step emulation instructions
Date: Fri,  6 Oct 2017 12:39:19 +0100
Message-ID: <20171006113921.24880-1-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: julien.thierry@arm.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Julian,

Here are the proposed patches for KVM support. Feel free to merge them
together if you want.

There are two minor wrinkles.

The first is we fake the HSR_EC value to keep QEMU happy. I don't
think this is a major problem because we aren't dealing with a guest
register but the mechanism for the guest debug to know what happened.
In this case we still single-stepped even if an exception wasn't
actually involved.

The second is we have to slightly munge the handling of return
kvm_handle_mmio_return to properly exit the loop on error or 0.

Alex Bennée (2):
  KVM: arm64: handle single-stepping trapped instructions
  kvm: arm64: handle single-step of userspace mmio instructions

 arch/arm/include/asm/kvm_host.h   |  2 ++
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/debug.c            | 21 ++++++++++++++++++
 arch/arm64/kvm/handle_exit.c      | 45 +++++++++++++++++++++++++++------------
 virt/kvm/arm/arm.c                |  2 +-
 virt/kvm/arm/mmio.c               |  3 ++-
 6 files changed, 58 insertions(+), 16 deletions(-)

-- 
2.14.1
