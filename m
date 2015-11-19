From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v4 01/13] KVM: arm/arm64: select IRQ_BYPASS_MANAGER
Date: Thu, 19 Nov 2015 14:53:51 +0000
Message-ID: <1447944843-17731-2-git-send-email-eric.auger@linaro.org>
References: <1447944843-17731-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 48897499E0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Nov 2015 09:53:34 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hKR2U3gXBaYi for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Nov 2015 09:53:32 -0500 (EST)
Received: from mail-wm0-f41.google.com (mail-wm0-f41.google.com [74.125.82.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 804304989E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Nov 2015 09:53:32 -0500 (EST)
Received: by wmec201 with SMTP id c201so121297803wme.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Nov 2015 06:54:11 -0800 (PST)
In-Reply-To: <1447944843-17731-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, alex.williamson@redhat.com, b.reynal@virtualopensystems.com, christoffer.dall@linaro.org, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: andre.przywara@arm.com, linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Select IRQ_BYPASS_MANAGER when CONFIG_KVM is set

Signed-off-by: Eric Auger <eric.auger@linaro.org>
---
 arch/arm/kvm/Kconfig   | 2 ++
 arch/arm64/kvm/Kconfig | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/arch/arm/kvm/Kconfig b/arch/arm/kvm/Kconfig
index 95a0005..73d7201 100644
--- a/arch/arm/kvm/Kconfig
+++ b/arch/arm/kvm/Kconfig
@@ -3,6 +3,7 @@
 #
 
 source "virt/kvm/Kconfig"
+source "virt/lib/Kconfig"
 
 menuconfig VIRTUALIZATION
 	bool "Virtualization"
@@ -32,6 +33,7 @@ config KVM
 	select KVM_VFIO
 	select HAVE_KVM_EVENTFD
 	select HAVE_KVM_IRQFD
+	select IRQ_BYPASS_MANAGER
 	depends on ARM_VIRT_EXT && ARM_LPAE && ARM_ARCH_TIMER
 	---help---
 	  Support hosting virtualized guest machines.
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index a5272c0..64f460d 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -3,6 +3,7 @@
 #
 
 source "virt/kvm/Kconfig"
+source "virt/lib/Kconfig"
 
 menuconfig VIRTUALIZATION
 	bool "Virtualization"
@@ -36,6 +37,7 @@ config KVM
 	select HAVE_KVM_EVENTFD
 	select HAVE_KVM_IRQFD
 	select KVM_ARM_VGIC_V3
+	select IRQ_BYPASS_MANAGER
 	---help---
 	  Support hosting virtualized guest machines.
 	  We don't support KVM with 16K page tables yet, due to the multiple
-- 
1.9.1
