From: "Suzuki K. Poulose" <suzuki.poulose@arm.com>
Subject: [PATCH 07/14] arm64: Kconfig: Fix help text about AArch32 support
 with 64K pages
Date: Thu, 13 Aug 2015 12:33:57 +0100
Message-ID: <1439465645-22584-8-git-send-email-suzuki.poulose@arm.com>
References: <1439465645-22584-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5ED155AE40
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Aug 2015 07:21:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7MN+DZiJCiIT for <kvmarm@lists.cs.columbia.edu>;
 Thu, 13 Aug 2015 07:21:28 -0400 (EDT)
Received: from eu-smtp-delivery-143.mimecast.com
 (eu-smtp-delivery-143.mimecast.com [146.101.78.143])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 92E2E5AE17
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Aug 2015 07:21:28 -0400 (EDT)
In-Reply-To: <1439465645-22584-1-git-send-email-suzuki.poulose@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

From: "Suzuki K. Poulose" <suzuki.poulose@arm.com>

Update the help text for ARM64_64K_PAGES to reflect the reality
about AArch32 support.

Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Suzuki K. Poulose <suzuki.poulose@arm.com>
---
 arch/arm64/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index d1fb2a3..b247897 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -449,8 +449,8 @@ config ARM64_64K_PAGES
 	help
 	  This feature enables 64KB pages support (4KB by default)
 	  allowing only two levels of page tables and faster TLB
-	  look-up. AArch32 emulation is not available when this feature
-	  is enabled.
+	  look-up. AArch32 emulation requires applications compiled
+	  with 64K aligned segments.
 
 endchoice
 
-- 
1.7.9.5
