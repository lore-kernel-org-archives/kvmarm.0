From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: [PATCH 0/3] arm64: KVM: Support 16-bit VMID
Date: Mon, 16 Nov 2015 11:28:15 +0000
Message-ID: <1447673298-25503-1-git-send-email-vladimir.murzin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C44849444
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2015 06:28:10 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EHK80ZvMod9W for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Nov 2015 06:28:09 -0500 (EST)
Received: from eu-smtp-delivery-143.mimecast.com
 (eu-smtp-delivery-143.mimecast.com [207.82.80.143])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DCEB54852E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2015 06:28:08 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: marc.zyngier@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi

This series is supposed to bring support for 16-bit VMID offered by
the ARMv8.1 architecture extension into KVM.

The first to patches are clean-up to make kvm_arm.h fit into assembly
code nicely. The third patch modifies KVM code to recognise and use
16-bit VMID.

Thanks!

Vladimir Murzin (3):
  kvm: arm: arm64: remove unreferenced S2_PGD_ORDER
  kvm: arm: make kvm_arm.h friendly to assembly code
  arm64: KVM: Add support for 16-bit VMID

 arch/arm/include/asm/kvm_arm.h   |   34 +++++++++++++++++-----------------
 arch/arm/include/asm/kvm_mmu.h   |    5 +++++
 arch/arm/kvm/arm.c               |   10 ++++++++--
 arch/arm/kvm/mmu.c               |    6 +++---
 arch/arm64/include/asm/kvm_arm.h |    3 ++-
 arch/arm64/include/asm/kvm_mmu.h |    9 ++++++++-
 arch/arm64/kvm/hyp-init.S        |    9 +++++++++
 7 files changed, 52 insertions(+), 24 deletions(-)

-- 
1.7.9.5
