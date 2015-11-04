From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 09/21] arm/arm64: KVM : Enable vhost device selection under KVM
 config menu
Date: Wed,  4 Nov 2015 15:49:48 +0100
Message-ID: <1446648600-27297-10-git-send-email-christoffer.dall@linaro.org>
References: <1446648600-27297-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5908949938
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2015 09:49:57 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ljy6H0A2HSvx for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Nov 2015 09:49:56 -0500 (EST)
Received: from mail-wi0-f173.google.com (mail-wi0-f173.google.com
 [209.85.212.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 57454499E0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2015 09:49:54 -0500 (EST)
Received: by wikq8 with SMTP id q8so93798856wik.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 Nov 2015 06:53:07 -0800 (PST)
In-Reply-To: <1446648600-27297-1-git-send-email-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Wei Huang <wei@redhat.com>

vhost drivers provide guest VMs with better I/O performance and lower
CPU utilization. This patch allows users to select vhost devices under
KVM configuration menu on ARM. This makes vhost support on arm/arm64
on a par with other architectures (e.g. x86, ppc).

Signed-off-by: Wei Huang <wei@redhat.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/kvm/Kconfig   | 2 ++
 arch/arm64/kvm/Kconfig | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/arch/arm/kvm/Kconfig b/arch/arm/kvm/Kconfig
index 356970f..95a0005 100644
--- a/arch/arm/kvm/Kconfig
+++ b/arch/arm/kvm/Kconfig
@@ -46,4 +46,6 @@ config KVM_ARM_HOST
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
2.1.2.330.g565301e.dirty
