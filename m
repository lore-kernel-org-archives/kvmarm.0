From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v4 2/6] arm64: KVM: Handle Set/Way CMOs as NOPs if FWB is
 present
Date: Mon,  2 Jul 2018 16:02:46 +0100
Message-ID: <20180702150250.16550-3-marc.zyngier@arm.com>
References: <20180702150250.16550-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B44D34A0C8
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Jul 2018 10:51:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UnfJ1doWfDVR for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Jul 2018 10:50:42 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D5494A054
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Jul 2018 10:50:42 -0400 (EDT)
In-Reply-To: <20180702150250.16550-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Set/Way handling is one of the ugliest corners of KVM. We shouldn't
have to handle that, but better safe than sorry.

Thankfully, FWB fixes this for us by not requiering any maintenance
(the guest is forced to use cacheable memory, no matter what it says,
and the whole system is garanteed to be cache coherent), which means
we don't have to emulate S/W CMOs, and don't have to track VM ops either.

We still have to trap S/W though, if only to prevent the guest from
doing something bad.

Reviewed-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index a4363735d3f8..774d72155904 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -194,7 +194,16 @@ static bool access_dcsw(struct kvm_vcpu *vcpu,
 	if (!p->is_write)
 		return read_from_write_only(vcpu, p, r);
 
-	kvm_set_way_flush(vcpu);
+	/*
+	 * Only track S/W ops if we don't have FWB. It still indicates
+	 * that the guest is a bit broken (S/W operations should only
+	 * be done by firmware, knowing that there is only a single
+	 * CPU left in the system, and certainly not from non-secure
+	 * software).
+	 */
+	if (!cpus_have_const_cap(ARM64_HAS_STAGE2_FWB))
+		kvm_set_way_flush(vcpu);
+
 	return true;
 }
 
-- 
2.17.1
