From: Julien Thierry <julien.thierry@arm.com>
Subject: [RESEND PATCH 2/2] arm/arm64: kvm: Disable branch profiling in HYP
 code
Date: Fri, 20 Oct 2017 12:34:17 +0100
Message-ID: <1508499257-10014-3-git-send-email-julien.thierry@arm.com>
References: <1508499257-10014-1-git-send-email-julien.thierry@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CA7A149D3B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Oct 2017 07:33:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wFwgPtj3nTFd for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Oct 2017 07:33:24 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BE79549D29
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Oct 2017 07:33:24 -0400 (EDT)
In-Reply-To: <1508499257-10014-1-git-send-email-julien.thierry@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Julien Thierry <julien.thierry@arm.com>, marc.zyngier@arm.com, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Russell King <linux@armlinux.org.uk>, stable@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

When HYP code runs into branch profiling code, it attempts to jump to
unmapped memory, causing a HYP Panic.

Disable the branch profiling for code designed to run at HYP mode.

Signed-off-by: Julien Thierry <julien.thierry@arm.com>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: <stable@vger.kernel.org>
---
 arch/arm/kvm/hyp/Makefile   | 2 +-
 arch/arm64/kvm/hyp/Makefile | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kvm/hyp/Makefile b/arch/arm/kvm/hyp/Makefile
index 8679405..92eab1d 100644
--- a/arch/arm/kvm/hyp/Makefile
+++ b/arch/arm/kvm/hyp/Makefile
@@ -2,7 +2,7 @@
 # Makefile for Kernel-based Virtual Machine module, HYP part
 #

-ccflags-y += -fno-stack-protector
+ccflags-y += -fno-stack-protector -DDISABLE_BRANCH_PROFILING

 KVM=../../../../virt/kvm

diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
index 14c4e3b..48b0354 100644
--- a/arch/arm64/kvm/hyp/Makefile
+++ b/arch/arm64/kvm/hyp/Makefile
@@ -2,7 +2,7 @@
 # Makefile for Kernel-based Virtual Machine module, HYP part
 #

-ccflags-y += -fno-stack-protector
+ccflags-y += -fno-stack-protector -DDISABLE_BRANCH_PROFILING

 KVM=../../../../virt/kvm

--
1.9.1
