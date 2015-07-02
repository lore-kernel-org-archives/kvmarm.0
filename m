From: Eric Auger <eric.auger@linaro.org>
Subject: [RFC 11/17] VFIO: platform: select IRQ_BYPASS_MANAGER
Date: Thu,  2 Jul 2015 15:17:21 +0200
Message-ID: <1435843047-6327-12-git-send-email-eric.auger@linaro.org>
References: <1435843047-6327-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 425E65768C
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2015 09:07:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0Sq3AdjgiXdW for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Jul 2015 09:07:18 -0400 (EDT)
Received: from mail-wg0-f41.google.com (mail-wg0-f41.google.com [74.125.82.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0D2745771D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2015 09:07:00 -0400 (EDT)
Received: by wgjx7 with SMTP id x7so62923000wgj.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 02 Jul 2015 06:18:17 -0700 (PDT)
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

Select IRQ_BYPASS_MANAGER when CONFIG_VFIO_PLATFORM is set

Signed-off-by: Eric Auger <eric.auger@linaro.org>
---
 drivers/vfio/platform/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vfio/platform/Kconfig b/drivers/vfio/platform/Kconfig
index bb30128..c2f3dce 100644
--- a/drivers/vfio/platform/Kconfig
+++ b/drivers/vfio/platform/Kconfig
@@ -2,6 +2,7 @@ config VFIO_PLATFORM
 	tristate "VFIO support for platform devices"
 	depends on VFIO && EVENTFD && (ARM || ARM64)
 	select VFIO_VIRQFD
+	select IRQ_BYPASS_MANAGER
 	help
 	  Support for platform devices with VFIO. This is required to make
 	  use of platform devices present on the system using the VFIO
-- 
1.9.1
