From: Sudeep Holla <sudeep.holla@arm.com>
Subject: [PATCH 2/2] arm64: kvm: upgrade csselr and ccsidr to 64-bit values
Date: Fri, 20 Jan 2017 10:50:10 +0000
Message-ID: <1484909410-11673-2-git-send-email-sudeep.holla@arm.com>
References: <1484909410-11673-1-git-send-email-sudeep.holla@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1484909410-11673-1-git-send-email-sudeep.holla@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Sudeep Holla <sudeep.holla@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

csselr and ccsidr are treated as 64-bit values already elsewhere in the
kernel. It also aligns well with the architecture extensions that allow
64-bit format for ccsidr.

This patch upgrades the existing accesses to csselr and ccsidr from
32-bit to 64-bit in preparation to add support to those extensions.

Cc: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 5dca1f10340f..a3559a8a2b0c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -58,15 +58,15 @@
  */
 
 /* 3 bits per cache level, as per CLIDR, but non-existent caches always 0 */
-static u32 cache_levels;
+static u64 cache_levels;
 
 /* CSSELR values; used to index KVM_REG_ARM_DEMUX_ID_CCSIDR */
 #define CSSELR_MAX 	((MAX_CACHE_LEVEL - 1) >> 1)
 
 /* Which cache CCSIDR represents depends on CSSELR value. */
-static u32 get_ccsidr(u32 csselr)
+static u64 get_ccsidr(u64 csselr)
 {
-	u32 ccsidr;
+	u64 ccsidr;
 
 	/* Make sure noone else changes CSSELR during this! */
 	local_irq_disable();
@@ -1952,9 +1952,9 @@ static int set_invariant_sys_reg(u64 id, void __user *uaddr)
 	return 0;
 }
 
-static bool is_valid_cache(u32 val)
+static bool is_valid_cache(u64 val)
 {
-	u32 level, ctype;
+	u64 level, ctype;
 
 	if (val >= CSSELR_MAX)
 		return false;
@@ -1979,8 +1979,8 @@ static bool is_valid_cache(u32 val)
 
 static int demux_c15_get(u64 id, void __user *uaddr)
 {
-	u32 val;
-	u32 __user *uval = uaddr;
+	u64 val;
+	u64 __user *uval = uaddr;
 
 	/* Fail if we have unknown bits set. */
 	if (id & ~(KVM_REG_ARCH_MASK|KVM_REG_SIZE_MASK|KVM_REG_ARM_COPROC_MASK
@@ -2004,8 +2004,8 @@ static int demux_c15_get(u64 id, void __user *uaddr)
 
 static int demux_c15_set(u64 id, void __user *uaddr)
 {
-	u32 val, newval;
-	u32 __user *uval = uaddr;
+	u64 val, newval;
+	u64 __user *uval = uaddr;
 
 	/* Fail if we have unknown bits set. */
 	if (id & ~(KVM_REG_ARCH_MASK|KVM_REG_SIZE_MASK|KVM_REG_ARM_COPROC_MASK
-- 
2.7.4
