Return-Path: <SRS0=cl91=3T=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4ADBC47409
	for <kvmarm@archiver.kernel.org>; Thu, 30 Jan 2020 13:29:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6D89421734
	for <kvmarm@archiver.kernel.org>; Thu, 30 Jan 2020 13:29:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="K/T3DV97"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6D89421734
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 279E84AED2;
	Thu, 30 Jan 2020 08:29:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qrSLQvmDCuWX; Thu, 30 Jan 2020 08:29:33 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EE3E84AECB;
	Thu, 30 Jan 2020 08:29:33 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C5E124AEDD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jan 2020 08:29:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3TZRuvatu7Cl for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Jan 2020 08:29:30 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0BEC64AECC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jan 2020 08:29:30 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 3A52D206D3;
 Thu, 30 Jan 2020 13:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1580390969;
 bh=QGmoD2g147nn2rXQotyPQlmpUS1aCJlneMZQNHauFhw=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=K/T3DV9793fRN0Lqcry0p0lpZmnmsieQCmXNKEi8q3O9nmOTKAvs16zlpdo1tZt2i
 KcJ+RkYMLYlXRcezty7yq/J+T06aHM0pM3QjDd4Ooy5KKIG1iK6LUObYkfdNmRNTD1
 3qQW1I6mGTIgE6JBUxwhRm5z8aOEludcAD6Xc4LE=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1ix9q0-002BmW-Vp; Thu, 30 Jan 2020 13:26:29 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 18/23] KVM: arm: Make inject_abt32() inject an external abort
 instead
Date: Thu, 30 Jan 2020 13:25:53 +0000
Message-Id: <20200130132558.10201-19-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200130132558.10201-1-maz@kernel.org>
References: <20200130132558.10201-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com,
 drjones@redhat.com, andrew.murray@arm.com, beata.michalska@linaro.org,
 christoffer.dall@arm.com, eric.auger@redhat.com, gshan@redhat.com,
 wanghaibin.wang@huawei.com, james.morse@arm.com, broonie@kernel.org,
 mark.rutland@arm.com, rmk+kernel@armlinux.org.uk,
 shannon.zhao@linux.alibaba.com, steven.price@arm.com, will@kernel.org,
 yuehaibing@huawei.com, yuzenghui@huawei.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Gavin Shan <gshan@redhat.com>, kvm@vger.kernel.org,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 YueHaibing <yuehaibing@huawei.com>, Steven Price <steven.price@arm.com>,
 Shannon Zhao <shannon.zhao@linux.alibaba.com>,
 Russell King <rmk+kernel@armlinux.org.uk>, Mark Brown <broonie@kernel.org>,
 linux-arm-kernel@lists.infradead.org, Andrew Murray <andrew.murray@arm.com>
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

From: James Morse <james.morse@arm.com>

KVM's inject_abt64() injects an external-abort into an aarch64 guest.
The KVM_CAP_ARM_INJECT_EXT_DABT is intended to do exactly this, but
for an aarch32 guest inject_abt32() injects an implementation-defined
exception, 'Lockdown fault'.

Change this to external abort. For non-LPAE we now get the documented:
| Unhandled fault: external abort on non-linefetch (0x008) at 0x9c800f00
and for LPAE:
| Unhandled fault: synchronous external abort (0x210) at 0x9c800f00

Fixes: 74a64a981662a ("KVM: arm/arm64: Unify 32bit fault injection")
Reported-by: Beata Michalska <beata.michalska@linaro.org>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20200121123356.203000-3-james.morse@arm.com
---
 virt/kvm/arm/aarch32.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/arm/aarch32.c b/virt/kvm/arm/aarch32.c
index 2da482ca7067..0a356aa91aa1 100644
--- a/virt/kvm/arm/aarch32.c
+++ b/virt/kvm/arm/aarch32.c
@@ -15,6 +15,10 @@
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_hyp.h>
 
+#define DFSR_FSC_EXTABT_LPAE	0x10
+#define DFSR_FSC_EXTABT_nLPAE	0x08
+#define DFSR_LPAE		BIT(9)
+
 /*
  * Table taken from ARMv8 ARM DDI0487B-B, table G1-10.
  */
@@ -182,10 +186,10 @@ static void inject_abt32(struct kvm_vcpu *vcpu, bool is_pabt,
 	/* Give the guest an IMPLEMENTATION DEFINED exception */
 	is_lpae = (vcpu_cp15(vcpu, c2_TTBCR) >> 31);
 	if (is_lpae) {
-		*fsr = 1 << 9 | 0x34;
+		*fsr = DFSR_LPAE | DFSR_FSC_EXTABT_LPAE;
 	} else {
-		/* Surprise! DFSR's FS[4] lives in bit 10 */
-		*fsr = BIT(10) | 0x4; /* 0x14 */
+		/* no need to shuffle FS[4] into DFSR[10] as its 0 */
+		*fsr = DFSR_FSC_EXTABT_nLPAE;
 	}
 }
 
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
