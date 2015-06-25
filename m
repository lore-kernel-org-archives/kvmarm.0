From: Andrew Jones <drjones@redhat.com>
Subject: [PATCH 0/3] arm/arm64: tcg_baremetal_tests inspired patches
Date: Thu, 25 Jun 2015 18:12:16 +0200
Message-ID: <1435248739-25425-1-git-send-email-drjones@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: christoffer.dall@linaro.org, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

While porting the test in virtualopensystems' tcg_baremetal_tests
to kvm-unit-tests, I found a couple places to improve the spinlock
implementation. I also added a way to build a single test that
doesn't necessary have an entry in the makefile, which should be handy
for experimental tests.

Andrew Jones (3):
  arm/arm64: spinlocks: fix memory barriers
  arm/arm64: allow building a single test
  arm/arm64: speed up spinlocks and atomic ops

 config/config-arm-common.mak | 6 ++++++
 lib/arm/asm/mmu-api.h        | 4 ++++
 lib/arm/mmu.c                | 3 +++
 lib/arm/spinlock.c           | 8 ++++----
 lib/arm64/spinlock.c         | 5 ++---
 5 files changed, 19 insertions(+), 7 deletions(-)

-- 
2.4.3

