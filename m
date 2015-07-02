From: Eric Auger <eric.auger@linaro.org>
Subject: [RFC 10/17] KVM: arm: select IRQ_BYPASS_MANAGER
Date: Thu,  2 Jul 2015 15:17:20 +0200
Message-ID: <1435843047-6327-11-git-send-email-eric.auger@linaro.org>
References: <1435843047-6327-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E733657743
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2015 09:07:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gpxb2QJB3Na8 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Jul 2015 09:07:14 -0400 (EDT)
Received: from mail-wg0-f47.google.com (mail-wg0-f47.google.com [74.125.82.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E7EB757687
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2015 09:06:58 -0400 (EDT)
Received: by wguu7 with SMTP id u7so63056637wgu.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 02 Jul 2015 06:18:15 -0700 (PDT)
In-Reply-To: <1435843047-6327-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, alex.williamson@redhat.com, pbonzini@redhat.com, avi.kivity@gmail.com, mtosatti@redhat.com, feng.wu@intel.com, joro@8bytes.org, b.reynal@virtualopensystems.com
Cc: linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Select IRQ_BYPASS_MANAGER when CONFIG_KVM is set

Signed-off-by: Eric Auger <eric.auger@linaro.org>
---
 arch/arm/kvm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/kvm/Kconfig b/arch/arm/kvm/Kconfig
index bfb915d..7d38d25 100644
--- a/arch/arm/kvm/Kconfig
+++ b/arch/arm/kvm/Kconfig
@@ -31,6 +31,7 @@ config KVM
 	select KVM_VFIO
 	select HAVE_KVM_EVENTFD
 	select HAVE_KVM_IRQFD
+	select IRQ_BYPASS_MANAGER
 	depends on ARM_VIRT_EXT && ARM_LPAE && ARM_ARCH_TIMER
 	---help---
 	  Support hosting virtualized guest machines.
-- 
1.9.1
