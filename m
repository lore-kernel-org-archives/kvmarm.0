From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v5 1/5] KVM: x86: select IRQ_BYPASS_MANAGER
Date: Mon, 10 Aug 2015 15:31:03 +0200
Message-ID: <1439213467-13668-2-git-send-email-eric.auger@linaro.org>
References: <1439213467-13668-1-git-send-email-eric.auger@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1439213467-13668-1-git-send-email-eric.auger@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: eric.auger@st.com, eric.auger@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, alex.williamson@redhat.com, pbonzini@redhat.com, feng.wu@intel.com
Cc: linux-kernel@vger.kernel.org, patches@linaro.org, christoffer.dall@linaro.org, marc.zyngier@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

From: Feng Wu <feng.wu@intel.com>

Select IRQ_BYPASS_MANAGER for x86 when CONFIG_KVM is set

Signed-off-by: Feng Wu <feng.wu@intel.com>
---
 arch/x86/kvm/Kconfig  | 2 ++
 arch/x86/kvm/Makefile | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index d8a1d56..c951d44 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -3,6 +3,7 @@
 #
 
 source "virt/kvm/Kconfig"
+source "virt/lib/Kconfig"
 
 menuconfig VIRTUALIZATION
 	bool "Virtualization"
@@ -28,6 +29,7 @@ config KVM
 	select ANON_INODES
 	select HAVE_KVM_IRQCHIP
 	select HAVE_KVM_IRQFD
+	select IRQ_BYPASS_MANAGER
 	select HAVE_KVM_IRQ_ROUTING
 	select HAVE_KVM_EVENTFD
 	select KVM_APIC_ARCHITECTURE
diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 67d215c..05cc2d7 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -6,6 +6,9 @@ CFLAGS_svm.o := -I.
 CFLAGS_vmx.o := -I.
 
 KVM := ../../../virt/kvm
+LIB := ../../../virt/lib
+
+obj-$(CONFIG_IRQ_BYPASS_MANAGER)	+= $(LIB)/
 
 kvm-y			+= $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o \
 				$(KVM)/eventfd.o $(KVM)/irqchip.o $(KVM)/vfio.o
-- 
1.9.1

