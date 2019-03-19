From: Amit Daniel Kachhap <amit.kachhap@arm.com>
Subject: [PATCH v7 9/10] KVM: arm64: docs: document KVM support of pointer authentication
Date: Tue, 19 Mar 2019 14:00:42 +0530
Message-ID: <1552984243-7689-10-git-send-email-amit.kachhap@arm.com>
References: <1552984243-7689-1-git-send-email-amit.kachhap@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1552984243-7689-1-git-send-email-amit.kachhap@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Christoffer Dall <christoffer.dall@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andrew Jones <drjones@redhat.com>, Dave Martin <Dave.Martin@arm.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, kvmarm@lists.cs.columbia.edu, Kristina Martsenko <kristina.martsenko@arm.com>, linux-kernel@vger.kernel.org, Amit Daniel Kachhap <amit.kachhap@arm.com>, Mark Rutland <mark.rutland@arm.com>, James Morse <james.morse@arm.com>, Julien Thierry <julien.thierry@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

This adds sections for KVM API extension for pointer authentication.
A brief description about usage of pointer authentication for KVM guests
is added in the arm64 documentations.

Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Christoffer Dall <christoffer.dall@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu
---
 Documentation/arm64/pointer-authentication.txt | 15 +++++++++++----
 Documentation/virtual/kvm/api.txt              |  6 ++++++
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/Documentation/arm64/pointer-authentication.txt b/Documentation/arm64/pointer-authentication.txt
index 5baca42..4b769e6 100644
--- a/Documentation/arm64/pointer-authentication.txt
+++ b/Documentation/arm64/pointer-authentication.txt
@@ -87,7 +87,14 @@ used to get and set the keys for a thread.
 Virtualization
 --------------
 
-Pointer authentication is not currently supported in KVM guests. KVM
-will mask the feature bits from ID_AA64ISAR1_EL1, and attempted use of
-the feature will result in an UNDEFINED exception being injected into
-the guest.
+Pointer authentication is enabled in KVM guest when each virtual cpu is
+initialised by passing flags KVM_ARM_VCPU_PTRAUTH_[ADDRESS/GENERIC] and
+requesting this feature to be enabled. Without this flag, pointer
+authentication is not enabled in KVM guests and attempted use of the
+feature will result in an UNDEFINED exception being injected into the
+guest.
+
+Additionally, when these vcpu feature flags are not set then KVM will
+filter out the Pointer Authentication system key registers from
+KVM_GET/SET_REG_* ioctls and mask those features from cpufeature ID
+register.
diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 7de9eee..b5c66bc 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -2659,6 +2659,12 @@ Possible features:
 	  Depends on KVM_CAP_ARM_PSCI_0_2.
 	- KVM_ARM_VCPU_PMU_V3: Emulate PMUv3 for the CPU.
 	  Depends on KVM_CAP_ARM_PMU_V3.
+	- KVM_ARM_VCPU_PTRAUTH_ADDRESS:
+	- KVM_ARM_VCPU_PTRAUTH_GENERIC:
+	  Enables Pointer authentication for the CPU.
+	  Depends on KVM_CAP_ARM_PTRAUTH and only on arm64 architecture. If
+	  set, then the KVM guest allows the execution of pointer authentication
+	  instructions. Otherwise, KVM treats these instructions as undefined.
 
 
 4.83 KVM_ARM_PREFERRED_TARGET
-- 
2.7.4
