From: James Morse <james.morse@arm.com>
Subject: [PATCH] arm64: KVM: Guests can skip __install_bp_hardening_cb()s HYP
 work
Date: Fri, 21 Sep 2018 21:49:19 +0100
Message-ID: <20180921204919.5790-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4633C4A23E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Sep 2018 16:49:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Q-igkDkL6DJc for <kvmarm@lists.cs.columbia.edu>;
 Fri, 21 Sep 2018 16:49:28 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3ED264A239
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Sep 2018 16:49:28 -0400 (EDT)
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

enable_smccc_arch_workaround_1() passes NULL as the hyp_vecs start and
end if the HVC conduit is in use, and ARM_SMCCC_ARCH_WORKAROUND_1 is
detected.

If the guest kernel happened to be built with KVM_INDIRECT_VECTORS,
we go on to allocate a slot, memcpy() the empty workaround in and
do the appropriate cache maintenance.

This works as we always tell memcpy() the range is 0, so it never
accesses the NULL src pointer, but we still do the cache maintenance.

If hyp_vecs_start is NULL we know we're a guest, just update the fn
like the !KVM_INDIRECT_VECTORS version.

Signed-off-by: James Morse <james.morse@arm.com>
Reviewed-by: Julien Thierry <julien.thierry@arm.com>
---
 arch/arm64/kernel/cpu_errata.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index dec10898d688..25305f8a8670 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -116,6 +116,15 @@ static void __install_bp_hardening_cb(bp_hardening_cb_t fn,
 	static DEFINE_SPINLOCK(bp_lock);
 	int cpu, slot = -1;
 
+	/*
+	 * enable_smccc_arch_workaround_1() passes NULL for the hyp_vecs
+	 * start/end if we're a guest. Skip the hyp-vectors work.
+	 */
+	if (!hyp_vecs_start) {
+		__this_cpu_write(bp_hardening_data.fn, fn);
+		return;
+	}
+
 	spin_lock(&bp_lock);
 	for_each_possible_cpu(cpu) {
 		if (per_cpu(bp_hardening_data.fn, cpu) == fn) {
-- 
2.18.0
