From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH 0/3] KVM: arm64: vgic-its fixes
Date: Wed,  3 Aug 2016 18:13:22 +0200
Message-ID: <20160803161325.14933-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AC02F41267
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Aug 2016 12:04:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8FIX8WFNr33e for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Aug 2016 12:04:57 -0400 (EDT)
Received: from mail-wm0-f50.google.com (mail-wm0-f50.google.com [74.125.82.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4331E4113E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Aug 2016 12:04:56 -0400 (EDT)
Received: by mail-wm0-f50.google.com with SMTP id i5so343575214wmg.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 03 Aug 2016 09:11:47 -0700 (PDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Here are three small fixes resulting from looking at the pull request of
kvmarm/next into kvm/next.

They basically deal with corner cases in the reference count handling and
atomicity issues.

Christoffer Dall (3):
  KVM: arm64: vgic-its: Handle errors from vgic_add_lpi
  KVM: arm64: vgic-its: Plug race in vgic_put_irq
  KVM: arm64: vgic-its: Make updates to propbaser/pendbaser atomic

 virt/kvm/arm/vgic/vgic-its.c     | 18 ++++++++++++++----
 virt/kvm/arm/vgic/vgic-mmio-v3.c | 10 ++++++++--
 virt/kvm/arm/vgic/vgic.c         | 20 ++++++++++----------
 3 files changed, 32 insertions(+), 16 deletions(-)

-- 
2.9.0
