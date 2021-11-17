Return-Path: <SRS0=Jx+E=QE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B175C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 15:37:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3D27E61BFE
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 15:37:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3D27E61BFE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E54D44B154;
	Wed, 17 Nov 2021 10:37:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id t-r1EUvk4pGd; Wed, 17 Nov 2021 10:37:37 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E1184B176;
	Wed, 17 Nov 2021 10:37:36 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C858B4B162
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 10:37:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Wdj2QtRNO4h1 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Nov 2021 10:37:34 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C7B14B172
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 10:37:33 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D1C081FB;
 Wed, 17 Nov 2021 07:37:32 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 843C03F5A1;
 Wed, 17 Nov 2021 07:37:31 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 will@kernel.org, mark.rutland@arm.com
Subject: [RFC PATCH v5 18/38] KVM: arm64: Expose SPE version to guests
Date: Wed, 17 Nov 2021 15:38:22 +0000
Message-Id: <20211117153842.302159-19-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211117153842.302159-1-alexandru.elisei@arm.com>
References: <20211117153842.302159-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
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

Set the ID_AA64DFR0_EL1.PMSVer field to a non-zero value if the VCPU SPE
feature is set. SPE version is capped at FEAT_SPEv1p1 because KVM doesn't
yet implement freezing of PMU event counters on a SPE buffer management
event.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index e3ec1a44f94d..c36df734c1ad 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1105,8 +1105,10 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
 		val = cpuid_feature_cap_perfmon_field(val,
 						      ID_AA64DFR0_PMUVER_SHIFT,
 						      kvm_vcpu_has_pmu(vcpu) ? ID_AA64DFR0_PMUVER_8_4 : 0);
-		/* Hide SPE from guests */
-		val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_PMSVER);
+		/* Limit guests to SPE for ARMv8.3 */
+		val = cpuid_feature_cap_perfmon_field(val,
+						      ID_AA64DFR0_PMSVER_SHIFT,
+						      kvm_vcpu_has_spe(vcpu) ? ID_AA64DFR0_PMSVER_8_3 : 0);
 		break;
 	case SYS_ID_DFR0_EL1:
 		/* Limit guests to PMUv3 for ARMv8.4 */
-- 
2.33.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
