From: wanghaibin <wanghaibin.wang@huawei.com>
Subject: [PATCH v2 0/4] kvm: arm/arm64: vgic: APRn uaccess support.
Date: Mon, 17 Jul 2017 18:23:28 +0800
Message-ID: <1500287012-16996-1-git-send-email-wanghaibin.wang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E1F3D40D1A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Jul 2017 06:25:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id I32yiE-wP8HQ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Jul 2017 06:25:38 -0400 (EDT)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 11DC540017
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Jul 2017 06:25:37 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: cdall@linaro.org, marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu
Cc: wu.wubin@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

v2: Split the patch again to make it easier for review
    some fixes were proposed by Marc

v1: the problem describe:
https://lists.cs.columbia.edu/pipermail/kvmarm/2017-July/026295.html

wanghaibin (4):
  kvm: arm/arm64: vgic: Implement the vGICv2 GICC_APRn uaccess
    interface.
  kvm: arm/arm64: vgic-v2: Add GICH_APRn accessors for GICv2
  kvm: arm/arm64: vgic-v3: add ICH_AP[01]Rn accessors for GICv3
  kvm: arm/arm64: vgic: clean up vGICv3 ICC_APRn sysreg uaccess

 arch/arm64/kvm/vgic-sys-reg-v3.c | 25 +++++--------------------
 virt/kvm/arm/vgic/vgic-mmio-v2.c | 22 ++++++++++++++++++++--
 virt/kvm/arm/vgic/vgic-mmio.c    | 28 ++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic-v2.c      | 18 ++++++++++++++++++
 virt/kvm/arm/vgic/vgic-v3.c      | 20 ++++++++++++++++++++
 virt/kvm/arm/vgic/vgic.h         |  7 +++++++
 6 files changed, 98 insertions(+), 22 deletions(-)

-- 
1.8.3.1
