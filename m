Return-Path: <SRS0=HJUM=DC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4F92C4363D
	for <kvmarm@archiver.kernel.org>; Fri, 25 Sep 2020 16:01:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3E8E222B2D
	for <kvmarm@archiver.kernel.org>; Fri, 25 Sep 2020 16:01:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3E8E222B2D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B8744B446;
	Fri, 25 Sep 2020 12:01:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SKixblECNL85; Fri, 25 Sep 2020 12:01:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 281034B418;
	Fri, 25 Sep 2020 12:01:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1AF3D4B418
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Sep 2020 12:01:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fITq5BVkk2ly for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 Sep 2020 12:01:10 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D61104B407
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Sep 2020 12:01:10 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 55525101E;
 Fri, 25 Sep 2020 09:01:10 -0700 (PDT)
Received: from eglon.eretz (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 131293F718;
 Fri, 25 Sep 2020 09:01:08 -0700 (PDT)
From: James Morse <james.morse@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu
Subject: [PATCH] KVM: arm64: Hide unsupported MPAM from the guest
Date: Fri, 25 Sep 2020 17:01:02 +0100
Message-Id: <20200925160102.118858-1-james.morse@arm.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Anshuman Khandual <anshuman.khandual@arm.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Commit 011e5f5bf529 ("arm64/cpufeature: Add remaining feature bits in
ID_AA64PFR0 register") proactively added published features to the
cpufeature id registers.

If the platform supports these features, they are visible in the
sanitised ID registers that are exposed to KVM guests. This is a
problem as KVM doesn't support MPAM.

The hardware reset behaviour of MPAM is to be disabled at EL3. It
is unlikely anyone would ship a platform without firmware support,
the necessary initialisation has been upstream in the TF-A project
for over a year.

Firmware configures the EL2 registers to trap EL1 and EL0 access
to EL2. As KVM doesn't support MPAM, it doesn't change these
registers. Booting an MPAM capable kernel as a guest of mainline
causes KVM to take an unknown trap from an EL1 guest, and inject
an undef in response:
host:
| kvm [126]: Unsupported guest sys_reg access at: ffff800010093f24 [00000005]
|  { Op0( 3), Op1( 0), CRn(10), CRm( 5), Op2( 0), func_read },

guest:
| ------------[ cut here ]------------
| kernel BUG at arch/arm64/kernel/traps.c:409!
| Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
| Modules linked in:
| CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.6.0-rc1-00152-g570fa7e2d2ad #11605
| Hardware name: linux,dummy-virt (DT)
| pstate: 00000005 (nzcv daif -PAN -UAO)
| pc : do_undefinstr+0x2ec/0x310
| lr : do_undefinstr+0x2f8/0x310
...

This is a tad unfair on the guest as KVM said it supported the
feature. Mask out the MPAM feature.

Fixes: 011e5f5bf529 ("arm64/cpufeature: Add remaining feature bits in
ID_AA64PFR0 register")
Cc: <stable@vger.kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: James Morse <james.morse@arm.com>

---
I'll be back at rc1 with the minimal KVM support to ensure the traps
are enabled and handled islently.
---
 arch/arm64/kvm/sys_regs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 077293b5115f..f736791f37ca 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1131,6 +1131,7 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
 		if (!vcpu_has_sve(vcpu))
 			val &= ~(0xfUL << ID_AA64PFR0_SVE_SHIFT);
 		val &= ~(0xfUL << ID_AA64PFR0_AMU_SHIFT);
+		val &= ~(0xfUL << ID_AA64PFR0_MPAM_SHIFT);
 	} else if (id == SYS_ID_AA64ISAR1_EL1 && !vcpu_has_ptrauth(vcpu)) {
 		val &= ~((0xfUL << ID_AA64ISAR1_APA_SHIFT) |
 			 (0xfUL << ID_AA64ISAR1_API_SHIFT) |
-- 
2.28.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
