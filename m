From: Pavel Fedin <p.fedin@samsung.com>
Subject: [PATCH 0/2] KVM: arm/arm64: Clean up some obsolete code
Date: Fri, 02 Oct 2015 17:44:27 +0300
Message-ID: <cover.1443796321.git.p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6095B4169C
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Oct 2015 10:42:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ax6iHgkb6ufx for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Oct 2015 10:42:53 -0400 (EDT)
Received: from mailout4.w1.samsung.com (mailout4.w1.samsung.com
 [210.118.77.14])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 67B7540FF5
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Oct 2015 10:42:53 -0400 (EDT)
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NVL00LCBKYA9550@mailout4.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Fri, 02 Oct 2015 15:44:34 +0100 (BST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Current KVM code has lots of old redundancies, which can be cleaned up.
This patchset is actually a better alternative to
http://www.spinics.net/lists/arm-kernel/msg430726.html, which allows to
keep piggy-backed LRs. The idea is based on the fact that our code also
maintains LR state in elrsr, and this information is enough to track LR
usage.

This patchset is made against linux-next of 02.10.2015. Thanks to Andre
for pointing out some 4.3 specifics.

Pavel Fedin (2):
  Optimize away redundant LR tracking
  Merge vgic_set_lr() and vgic_sync_lr_elrsr()

 include/kvm/arm_vgic.h |   7 ----
 virt/kvm/arm/vgic-v2.c |   5 ---
 virt/kvm/arm/vgic-v3.c |   5 ---
 virt/kvm/arm/vgic.c    | 104 +++++++++++++++----------------------------------
 4 files changed, 32 insertions(+), 89 deletions(-)

-- 
2.4.4
