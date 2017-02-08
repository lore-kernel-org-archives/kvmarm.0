From: linucherian@gmail.com
Subject: [PATCH V2 0/2] KVM: arm64: Increase number of user memslots
Date: Wed,  8 Feb 2017 12:45:39 +0530
Message-ID: <1486538141-30627-1-git-send-email-linucherian@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 657B540962
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Feb 2017 02:15:55 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xVo+Vd+P3Eqt for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Feb 2017 02:15:54 -0500 (EST)
Received: from mail-pg0-f65.google.com (mail-pg0-f65.google.com [74.125.83.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3C63D4092C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Feb 2017 02:15:54 -0500 (EST)
Received: by mail-pg0-f65.google.com with SMTP id v184so14378395pgv.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 07 Feb 2017 23:16:27 -0800 (PST)
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
Cc: sunil.goutham@cavium.com, linu.cherian@cavium.com
List-Id: kvmarm@lists.cs.columbia.edu

From: Linu Cherian <linu.cherian@cavium.com>

v1 -> v2:
- Enabling KVM_CAP_NR_MEMSLOTS for arm/arm64 moved to separate patch.
- Updated commit message so that what is reported to userspace is explicit. 

Linu Cherian (2):
  KVM: arm/arm64: Enable KVM_CAP_NR_MEMSLOTS on arm/arm64
  KVM: arm64: Increase number of user memslots to 508

 arch/arm/kvm/arm.c                | 3 +++
 arch/arm64/include/asm/kvm_host.h | 2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

-- 
1.9.1
