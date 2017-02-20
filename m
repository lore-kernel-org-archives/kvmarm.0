From: Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 0/2] arm{,64}/kvm: survive unknown traps from guests
Date: Mon, 20 Feb 2017 12:30:10 +0000
Message-ID: <1487593812-9174-1-git-send-email-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6EFCC40B58
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Feb 2017 07:29:27 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Y-Uxp+NNWVol for <kvmarm@lists.cs.columbia.edu>;
 Mon, 20 Feb 2017 07:29:26 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4163E40B3E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Feb 2017 07:29:26 -0500 (EST)
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
Cc: marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, dave.martin@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

As future versions of the architecture add trappable functionality, it is
possible that KVM guests may be able to trigger exceptions that KVM doesn't
currently understand. Currently, we will BUG() if we take such an exception.

While we can't handle such traps very gracefully, we should limit any fallout
to the guest, rather than allowing guests to potentially bring down the host.

These patches try to make arm/arm64 KVM robust in these cases.

Thanks,
Mark.

Mark Rutland (2):
  arm/kvm: survive unknown traps from guests
  arm64/kvm: survive unknown traps from guests

 arch/arm/include/asm/kvm_arm.h |  1 +
 arch/arm/kvm/handle_exit.c     | 19 ++++++++++++-------
 arch/arm64/kvm/handle_exit.c   | 19 ++++++++++++-------
 3 files changed, 25 insertions(+), 14 deletions(-)

-- 
1.9.1
