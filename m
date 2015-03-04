From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v9 1/5] KVM: arm/arm64: unset CONFIG_HAVE_KVM_IRQCHIP
Date: Wed,  4 Mar 2015 11:14:32 +0100
Message-ID: <1425464076-20558-2-git-send-email-eric.auger@linaro.org>
References: <1425464076-20558-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BFEB84793F
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Mar 2015 05:11:14 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VTXmrxU+n8xT for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Mar 2015 05:11:13 -0500 (EST)
Received: from mail-wg0-f50.google.com (mail-wg0-f50.google.com [74.125.82.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9D30247936
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Mar 2015 05:11:13 -0500 (EST)
Received: by wghn12 with SMTP id n12so45643893wgh.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 Mar 2015 02:17:14 -0800 (PST)
In-Reply-To: <1425464076-20558-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: gleb@kernel.org, andre.przywara@arm.com, pbonzini@redhat.com, linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

CONFIG_HAVE_KVM_IRQCHIP is needed to support IRQ routing (along
with irq_comm.c and irqchip.c usage). This is not the case for
arm/arm64 currently.

This patch unsets the flag for both arm and arm64.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
Acked-by: Will Deacon <will.deacon@arm.com>
---
 arch/arm/kvm/Kconfig   | 2 --
 arch/arm64/kvm/Kconfig | 1 -
 2 files changed, 3 deletions(-)

diff --git a/arch/arm/kvm/Kconfig b/arch/arm/kvm/Kconfig
index 338ace7..aae5242 100644
--- a/arch/arm/kvm/Kconfig
+++ b/arch/arm/kvm/Kconfig
@@ -58,7 +58,6 @@ config KVM_ARM_MAX_VCPUS
 config KVM_ARM_VGIC
 	bool "KVM support for Virtual GIC"
 	depends on KVM_ARM_HOST && OF
-	select HAVE_KVM_IRQCHIP
 	default y
 	---help---
 	  Adds support for a hardware assisted, in-kernel GIC emulation.
@@ -66,7 +65,6 @@ config KVM_ARM_VGIC
 config KVM_ARM_TIMER
 	bool "KVM support for Architected Timers"
 	depends on KVM_ARM_VGIC && ARM_ARCH_TIMER
-	select HAVE_KVM_IRQCHIP
 	default y
 	---help---
 	  Adds support for the Architected Timers in virtual machines
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index f5590c8..039d8cf 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -53,7 +53,6 @@ config KVM_ARM_MAX_VCPUS
 config KVM_ARM_VGIC
 	bool
 	depends on KVM_ARM_HOST && OF
-	select HAVE_KVM_IRQCHIP
 	---help---
 	  Adds support for a hardware assisted, in-kernel GIC emulation.
 
-- 
1.9.1
