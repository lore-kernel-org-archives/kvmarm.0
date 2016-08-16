From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH 0/2] Rework vgic_attr_regs_access
Date: Tue, 16 Aug 2016 17:10:32 +0200
Message-ID: <20160816151034.16930-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0911A49B32
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Aug 2016 11:01:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EpZbAiEYup0c for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Aug 2016 11:01:13 -0400 (EDT)
Received: from mail-wm0-f41.google.com (mail-wm0-f41.google.com [74.125.82.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 51CE849B2F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Aug 2016 11:01:13 -0400 (EDT)
Received: by mail-wm0-f41.google.com with SMTP id o80so174465795wme.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Aug 2016 08:08:39 -0700 (PDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: vijay.kilari@gmail.com
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Two small patches to split up the functionality in vgic_attr_regs_access to
make life simpler when having to deal with GICv3 save/restore.

Christoffer Dall (2):
  KVM: arm/arm64: Factor out vgic_attr_regs_access functionality
  KVM: arm/arm64: Rename vgic_attr_regs_access to
    vgic_attr_regs_access_v2

 virt/kvm/arm/vgic/vgic-kvm-device.c | 125 +++++++++++++++++++++++++-----------
 1 file changed, 87 insertions(+), 38 deletions(-)

-- 
2.9.0
