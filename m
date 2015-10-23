From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v3 0/7] VFIO platform reset module rework
Date: Fri, 23 Oct 2015 14:37:08 +0200
Message-ID: <1445603835-14506-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 42EB0411E2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Oct 2015 08:34:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RTwACE2iytQV for <kvmarm@lists.cs.columbia.edu>;
 Fri, 23 Oct 2015 08:34:42 -0400 (EDT)
Received: from mail-wi0-f180.google.com (mail-wi0-f180.google.com
 [209.85.212.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2304340C9D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Oct 2015 08:34:41 -0400 (EDT)
Received: by wicll6 with SMTP id ll6so29613678wic.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Oct 2015 05:37:21 -0700 (PDT)
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

https://git.linaro.org/people/eric.auger/linux.git/shortlog/refs/heads/v4.3-rc6-rework-v3

Best Regards

Eric

v2 -> v3:
- use driver_mutex instead of reset_mutex
- style fixes: single mutex_unlock
- use static nodes; vfio_platform_register_reset now is a macro
- vfio_platform_reset_private.h removed since reset_module_(un)register
  disappear. No use of symbol_get anymore
- new patch introducing vfio-platform-base
- reset look-up moved back at vfio-platform probe time
- new patch featuring dev_info/dev_warn

v1 -> v2:
* in vfio_platform_common.c:
  - move reset lookup at load time and put reset at release: this is to
    prevent a race between the 2 load module loads
  - reset_list becomes static
  - vfio_platform_register/unregister_reset take a const char * as compat
  - fix node link
  - remove old combo struct and cleanup proto of vfio_platform_get_reset
  - add mutex to protect the reset list
* in calxeda xgmac reset module
  - introduce vfio_platform_reset_private.h
  - use module_vfio_reset_handler macro
  - do not export vfio_platform_calxedaxgmac_reset symbol anymore
  - add a pr_info to show the device is reset by vfio reset module


Eric Auger (7):
  vfio: platform: introduce vfio-platform-base module
  vfio: platform: add capability to register a reset function
  vfio: platform: introduce module_vfio_reset_handler macro
  vfio: platform: reset: calxedaxgmac: add reset function registration
  vfio: platform: add compat in vfio_platform_device
  vfio: platform: use list of registered reset function
  vfio: platform: add dev_info on device reset

 drivers/vfio/platform/Makefile                     |   6 +-
 .../platform/reset/vfio_platform_calxedaxgmac.c    |   5 +-
 drivers/vfio/platform/vfio_amba.c                  |   1 +
 drivers/vfio/platform/vfio_platform.c              |   1 +
 drivers/vfio/platform/vfio_platform_common.c       | 118 +++++++++++++++------
 drivers/vfio/platform/vfio_platform_private.h      |  40 ++++++-
 6 files changed, 129 insertions(+), 42 deletions(-)

-- 
1.9.1
