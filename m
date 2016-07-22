From: Andrew Jones <drjones@redhat.com>
Subject: [PATCH 0/2] arm64: add pabt injection test
Date: Fri, 22 Jul 2016 10:43:21 -0400
Message-ID: <1469198603-27537-1-git-send-email-drjones@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: marc.zyngier@arm.com, christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Get arm emulation tests kick started by adding a couple pabt injection
tests.

Andrew Jones (2):
  arm64: add start_usr32
  arm64: add pabt injection test

 arm/Makefile.arm64        |  2 +-
 arm/emul-abort.c          | 95 +++++++++++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg         | 25 +++++++++++++
 lib/arm64/asm/processor.h |  1 +
 lib/arm64/processor.c     | 21 +++++++++--
 5 files changed, 139 insertions(+), 5 deletions(-)
 create mode 100644 arm/emul-abort.c

-- 
1.8.3.1

