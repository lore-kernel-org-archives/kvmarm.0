From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH 0/4] VFIO platform reset module rework
Date: Sun, 18 Oct 2015 18:00:11 +0200
Message-ID: <1445184015-24414-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 15F6641280
 for <kvmarm@lists.cs.columbia.edu>; Sun, 18 Oct 2015 11:58:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id n89JrPSsKfXQ for <kvmarm@lists.cs.columbia.edu>;
 Sun, 18 Oct 2015 11:58:14 -0400 (EDT)
Received: from mail-wi0-f182.google.com (mail-wi0-f182.google.com
 [209.85.212.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E8E9B411AA
 for <kvmarm@lists.cs.columbia.edu>; Sun, 18 Oct 2015 11:58:13 -0400 (EDT)
Received: by wicll6 with SMTP id ll6so65669428wic.0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 18 Oct 2015 09:00:40 -0700 (PDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, alex.williamson@redhat.com, b.reynal@virtualopensystems.com, arnd@arndb.de, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

This series fixes the current implementation by getting rid of the
usage of __symbol_get which caused a compilation issue with
CONFIG_MODULES disabled. On top of this, the usage of MODULE_ALIAS makes
possible to add a new reset module without being obliged to update the
framework. The new implementation relies on the reset module registering
its reset function to the vfio-platform driver.

The series is available at

https://git.linaro.org/people/eric.auger/linux.git/shortlog/refs/heads/v4.3-rc5-rework-xgbe-v2

Best Regards

Eric


Eric Auger (4):
  vfio: platform: add capability to register a reset function
  vfio: platform: reset: calxedaxgmac: add reset function registration
  vfio: platform: add compat in vfio_platform_device
  vfio: platform: use list of registered reset function

 .../platform/reset/vfio_platform_calxedaxgmac.c    |  40 +++++++-
 drivers/vfio/platform/vfio_platform_common.c       | 112 ++++++++++++++++-----
 drivers/vfio/platform/vfio_platform_private.h      |  16 +++
 3 files changed, 140 insertions(+), 28 deletions(-)

-- 
1.9.1
