From: Wei Huang <wei@redhat.com>
Subject: [PATCH] arm/arm64: KVM : Enable vhost device selection under KVM config menu
Date: Fri,  9 Oct 2015 10:08:43 -0500
Message-ID: <1444403323-8333-1-git-send-email-wei@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: linux-kernel@vger.kernel.orgn
Cc: christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, catalin.marinas@arm.comn, will.deacon@arm.com, drjones@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

vhost drivers provide guest VMs with better I/O performance and lower
CPU utilization. This patch allows users to select vhost devices under
KVM configuration menu on ARM. This makes vhost support on arm/arm64
on a par with other architectures (e.g. x86, ppc).

Signed-off-by: Wei Huang <wei@redhat.com>
---
 arch/arm/kvm/Kconfig   | 2 ++
 arch/arm64/kvm/Kconfig | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/arch/arm/kvm/Kconfig b/arch/arm/kvm/Kconfig
index 210ecca..68045e7 100644
--- a/arch/arm/kvm/Kconfig
+++ b/arch/arm/kvm/Kconfig
@@ -45,4 +45,6 @@ config KVM_ARM_HOST
 	---help---
 	  Provides host support for ARM processors.
 
+source drivers/vhost/Kconfig
+
 endif # VIRTUALIZATION
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 5c7e920..38102f5 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -41,4 +41,6 @@ config KVM_ARM_HOST
 	---help---
 	  Provides host support for ARM processors.
 
+source drivers/vhost/Kconfig
+
 endif # VIRTUALIZATION
-- 
2.4.3

