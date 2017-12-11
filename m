From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 03/19] arm64: asm-offsets: Remove potential circular dependency
Date: Mon, 11 Dec 2017 14:49:21 +0000
Message-ID: <20171211144937.4537-4-marc.zyngier@arm.com>
References: <20171211144937.4537-1-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171211144937.4537-1-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, James Morse <james.morse@arm.com>, Steve Capper <steve.capper@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

So far, we've been lucky enough that none of the include files
that asm-offsets.c requires do include asm-offsets.h. This is
about to change, and would introduce a nasty circular dependency...

Let's now guard the inclusion of asm-offsets.h so that it never
gets pulled from asm-offsets.c.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/asm-offsets.h | 2 ++
 arch/arm64/kernel/asm-offsets.c      | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/arch/arm64/include/asm/asm-offsets.h b/arch/arm64/include/asm/asm-offsets.h
index d370ee36a182..ed8df3a9c95a 100644
--- a/arch/arm64/include/asm/asm-offsets.h
+++ b/arch/arm64/include/asm/asm-offsets.h
@@ -1 +1,3 @@
+#ifndef IN_ASM_OFFSET_GENERATOR
 #include <generated/asm-offsets.h>
+#endif
diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
index 742887330101..74b9a26a84b5 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -18,6 +18,8 @@
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
+#define IN_ASM_OFFSET_GENERATOR	1
+
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/dma-mapping.h>
-- 
2.14.2
