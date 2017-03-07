From: linucherian@gmail.com
Subject: [PATCH V3 0/4] KVM: arm64: Increase number of user memslots
Date: Tue,  7 Mar 2017 11:22:40 +0530
Message-ID: <1488865964-17346-1-git-send-email-linucherian@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7731A40A86
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Mar 2017 00:51:59 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4jY1Qk7hTi1n for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Mar 2017 00:51:58 -0500 (EST)
Received: from mail-pf0-f195.google.com (mail-pf0-f195.google.com
 [209.85.192.195])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7D42D40A7F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Mar 2017 00:51:58 -0500 (EST)
Received: by mail-pf0-f195.google.com with SMTP id v190so9050270pfb.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 06 Mar 2017 21:53:19 -0800 (PST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com, rkrcmar@redhat.com
Cc: Linu Cherian <linu.cherian@cavium.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Linu Cherian <linu.cherian@cavium.com>


v2 -> v3:
- Added documentation for KVM_CAP_NR_MEMSLOTS
- Removed KVM_PRIVATE_MEM_SLOTS which is unused
- KVM_USER_MEM_SLOTS changed to 512 from 508
 
v1 -> v2:
- Enabling KVM_CAP_NR_MEMSLOTS for arm/arm64 moved to separate patch.
- Updated commit message so that what is reported to userspace is explicit.



Linu Cherian (4):
  KVM: Add documentation for KVM_CAP_NR_MEMSLOTS
  KVM: arm/arm64: Enable KVM_CAP_NR_MEMSLOTS on arm/arm64
  KVM: arm/arm64: Remove KVM_PRIVATE_MEM_SLOTS definition that are
    unused
  KVM: arm64: Increase number of user memslots to 512

 Documentation/virtual/kvm/api.txt | 4 ++++
 arch/arm/include/asm/kvm_host.h   | 1 -
 arch/arm/kvm/arm.c                | 3 +++
 arch/arm64/include/asm/kvm_host.h | 3 +--
 4 files changed, 8 insertions(+), 3 deletions(-)

-- 
1.9.1
