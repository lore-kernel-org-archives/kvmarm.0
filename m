From: Andrew Jones <drjones@redhat.com>
Subject: [PATCH 0/3] arm/arm64: rework mmu_enabled, for spinlock speedup
Date: Thu, 25 Jun 2015 20:45:08 +0200
Message-ID: <1435257911-9715-1-git-send-email-drjones@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: christoffer.dall@linaro.org, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Andrew Jones (3):
  arm/arm64: Introduce mmu_disable
  arm/arm64: drop mmu_set_enabled
  arm/arm64: speed up spinlocks and atomic ops

 arm/cstart.S          |  9 +++++++++
 arm/cstart64.S        |  8 ++++++++
 lib/arm/asm/mmu-api.h |  9 +++++++--
 lib/arm/mmu.c         | 32 ++++++++++++++++++++++----------
 lib/arm/smp.c         |  1 -
 5 files changed, 46 insertions(+), 13 deletions(-)

-- 
2.4.3

