From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v4 1/5] KVM: x86: select IRQ_BYPASS_MANAGER
Date: Mon,  3 Aug 2015 19:20:40 +0200
Message-ID: <1438622444-25444-2-git-send-email-eric.auger@linaro.org>
References: <1438622444-25444-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ECE5B59EEE
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Aug 2015 13:08:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EyDan-aRb0qA for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Aug 2015 13:08:53 -0400 (EDT)
Received: from mail-wi0-f169.google.com (mail-wi0-f169.google.com
 [209.85.212.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C2D4659EF0
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Aug 2015 13:08:53 -0400 (EDT)
Received: by wicgj17 with SMTP id gj17so115085294wic.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 03 Aug 2015 10:21:35 -0700 (PDT)
In-Reply-To: <1438622444-25444-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, alex.williamson@redhat.com, feng.wu@intel.com, pbonzini@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: patches@linaro.org, marc.zyngier@arm.com, joro@8bytes.org, mtosatti@redhat.com, linux-kernel@vger.kernel.org, avi.kivity@gmail.com
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
