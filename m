From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH 0/3] Fix KVM_GET_REG_LIST invalid register ID regression
Date: Tue, 11 Dec 2018 15:41:23 +0000
Message-ID: <1544542886-28882-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3AAAB4A2E9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Dec 2018 10:41:33 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Pc9c4p4tvlA0 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Dec 2018 10:41:32 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F1A894A2BD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Dec 2018 10:41:31 -0500 (EST)
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
Cc: Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Since commit d26c25a9d19b ("arm64: KVM: Tighten guest core register
access from userspace"), KVM_{GET,SET}_ONE_REG rejects register IDs
that do not correspond to a single underlying architectural register.

This series proposed a fix for this regression along with some related
refactoring.

For ease of review, the series is expanded out a little more than
necessary.  I also want a clean base to build SVE support on, since
SVE needs to do some additional filtering to remove FPSIMD V-regs from
KVM_GET_REG_LIST: thus, this series does a bit of refactoring beyond
the basic needs of the fix.

An equivalent fix should go to stable, but we may want something more
self-contained for that case.

Comments welcome.

This series has not been tested yet.


Dave Martin (3):
  KVM: arm64: Factor out core register size determination and validation
  KVM: arm64: Factor out KVM_GET_REG_LIST core register enumeration
  KVM: arm64: Filter out invalid core register IDs in KVM_GET_REG_LIST

 arch/arm64/kvm/guest.c | 96 +++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 71 insertions(+), 25 deletions(-)

-- 
2.1.4
