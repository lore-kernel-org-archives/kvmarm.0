From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 0/8] KVM/ARM Fixes for v4.14
Date: Mon, 30 Oct 2017 03:55:55 +0100
Message-ID: <20171030025603.23550-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Paolo and Radim,

Here are the fixes we've been trying to get ready for v4.14 for a while;
sorry about sending these so late.

We're fixing:

 - a number of issues with saving/restoring the ITS
 - a bug in KVM/ARM when branch profiling is enabled in Hyp mode
 - an emulation bug for 32-bit guests when injecting aborts
 - a failure to check if a kmalloc succeeds in the ITS emulation

The following changes since commit 8a5776a5f49812d29fe4b2d0a2d71675c3facf3f:

  Linux 4.14-rc4 (2017-10-08 20:53:29 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvm-arm-fixes-for-v4.14

for you to fetch changes up to c2385eaa6c5a87cdc4e04ed589ae103ca3297c84:

  KVM: arm/arm64: vgic-its: Check GITS_BASER Valid bit before saving tables (2017-10-29 03:25:06 +0100)


Thanks,
-Christoffer

Christoffer Dall (1):
      KVM: arm64: its: Fix missing dynamic allocation check in scan_its_table

Dongjiu Geng (1):
      arm/arm64: KVM: set right LR register value for 32 bit guest when inject abort

Eric Auger (3):
      KVM: arm/arm64: vgic-its: Fix vgic_its_restore_collection_table returned value
      KVM: arm/arm64: vgic-its: Check CBASER/BASER validity before enabling the ITS
      KVM: arm/arm64: vgic-its: Check GITS_BASER Valid bit before saving tables

Julien Thierry (2):
      arm/arm64: kvm: Move initialization completion message
      arm/arm64: kvm: Disable branch profiling in HYP code

wanghaibin (1):
      KVM: arm/arm64: vgic-its: Fix return value for device table restore

 arch/arm/kvm/emulate.c        |  6 ++--
 arch/arm/kvm/hyp/Makefile     |  2 +-
 arch/arm64/kvm/hyp/Makefile   |  2 +-
 arch/arm64/kvm/inject_fault.c | 16 +++++++++-
 virt/kvm/arm/arm.c            | 31 +++++++++---------
 virt/kvm/arm/vgic/vgic-its.c  | 73 ++++++++++++++++++++++++++++---------------
 6 files changed, 81 insertions(+), 49 deletions(-)
