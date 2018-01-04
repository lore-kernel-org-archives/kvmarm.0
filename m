From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v4 03/19] arm64: asm-offsets: Remove potential circular
 dependency
Date: Thu,  4 Jan 2018 18:43:18 +0000
Message-ID: <20180104184334.16571-4-marc.zyngier@arm.com>
References: <20180104184334.16571-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E98D049DA0
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Jan 2018 13:39:27 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eAtSptyRgdYr for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Jan 2018 13:39:26 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E69649DB5
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Jan 2018 13:39:26 -0500 (EST)
In-Reply-To: <20180104184334.16571-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

So far, we've been lucky enough that none of the include files
that asm-offsets.c requires include asm-offsets.h. This is
about to change, and would introduce a nasty circular dependency...

Let's now guard the inclusion of asm-offsets.h so that it never
gets pulled from asm-offsets.c. The same issue exists between
bounce.c and include/generated/bounds.h, and is worked around
by using the existing guard symbol.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/asm-offsets.h | 2 ++
 arch/arm64/kernel/asm-offsets.c      | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/arch/arm64/include/asm/asm-offsets.h b/arch/arm64/include/asm/asm-offsets.h
index d370ee36a182..7d6531a81eb3 100644
--- a/arch/arm64/include/asm/asm-offsets.h
+++ b/arch/arm64/include/asm/asm-offsets.h
@@ -1 +1,3 @@
+#if !defined(__GENERATING_ASM_OFFSETS_H) && !defined(__GENERATING_BOUNDS_H)
 #include <generated/asm-offsets.h>
+#endif
diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
index 742887330101..5ab8841af382 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -18,6 +18,8 @@
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
+#define __GENERATING_ASM_OFFSETS_H	1
+
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/dma-mapping.h>
-- 
2.14.2
