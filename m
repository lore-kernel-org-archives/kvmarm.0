From: Andrew Jones <drjones@redhat.com>
Subject: [PATCH kvm-unit-tests v2 0/2] arm/arm64: introduce PSCI tests
Date: Fri,  3 Mar 2017 15:30:55 +0100
Message-ID: <20170303143057.27275-1-drjones@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: rkrcmar@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Andrew Jones (1):
  arm/arm64: psci: support testing tcg

Levente Kurusa (1):
  arm/arm64: Add PSCI tests

 arm/Makefile.common |   1 +
 arm/psci.c          | 150 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg   |   6 +++
 3 files changed, 157 insertions(+)
 create mode 100644 arm/psci.c

-- 
2.9.3
