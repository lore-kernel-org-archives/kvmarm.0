Return-Path: <SRS0=QgbO=ID=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2F2FC433DB
	for <kvmarm@archiver.kernel.org>; Fri,  5 Mar 2021 18:53:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3BF926509A
	for <kvmarm@archiver.kernel.org>; Fri,  5 Mar 2021 18:53:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3BF926509A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C27244B66D;
	Fri,  5 Mar 2021 13:53:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id y5eHOEFXkJ4D; Fri,  5 Mar 2021 13:53:14 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 81F744B45D;
	Fri,  5 Mar 2021 13:53:13 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EB0DD4B6D6
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Mar 2021 13:53:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7y82ChVNqaiW for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Mar 2021 13:53:10 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6A5344B702
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Mar 2021 13:53:07 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 92BB6650AC;
 Fri,  5 Mar 2021 18:53:06 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1lIFZQ-00HYFA-Qa; Fri, 05 Mar 2021 18:53:04 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 8/8] KVM: arm64: Fix range alignment when walking page tables
Date: Fri,  5 Mar 2021 18:52:54 +0000
Message-Id: <20210305185254.3730990-9-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210305185254.3730990-1-maz@kernel.org>
References: <87eegtzbch.wl-maz@kernel.org>
 <20210305185254.3730990-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com,
 andre.przywara@arm.com, ascull@google.com, catalin.marinas@arm.com,
 christoffer.dall@arm.com, Howard.Zhang@arm.com, justin.he@arm.com,
 mark.rutland@arm.com, qperret@google.com, shameerali.kolothum.thodi@huawei.com,
 suzuki.poulose@arm.com, will@kernel.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, kernel-team@android.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Jia He <justin.he@arm.com>, kvm@vger.kernel.org,
 Will Deacon <will@kernel.org>, Andre Przywara <andre.przywara@arm.com>,
 Howard Zhang <Howard.Zhang@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 stable@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

From: Jia He <justin.he@arm.com>

When walking the page tables at a given level, and if the start
address for the range isn't aligned for that level, we propagate
the misalignment on each iteration at that level.

This results in the walker ignoring a number of entries (depending
on the original misalignment) on each subsequent iteration.

Properly aligning the address before the next iteration addresses
this issue.

Cc: stable@vger.kernel.org
Reported-by: Howard Zhang <Howard.Zhang@arm.com>
Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Jia He <justin.he@arm.com>
Fixes: b1e57de62cfb ("KVM: arm64: Add stand-alone page-table walker infrastructure")
[maz: rewrite commit message]
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20210303024225.2591-1-justin.he@arm.com
---
 arch/arm64/kvm/hyp/pgtable.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 4d177ce1d536..926fc07074f5 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -223,6 +223,7 @@ static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
 		goto out;
 
 	if (!table) {
+		data->addr = ALIGN_DOWN(data->addr, kvm_granule_size(level));
 		data->addr += kvm_granule_size(level);
 		goto out;
 	}
-- 
2.29.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
