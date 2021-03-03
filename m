Return-Path: <SRS0=lGHe=IB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2647DC433DB
	for <kvmarm@archiver.kernel.org>; Wed,  3 Mar 2021 02:42:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 652BF64EBB
	for <kvmarm@archiver.kernel.org>; Wed,  3 Mar 2021 02:42:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 652BF64EBB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D46104B714;
	Tue,  2 Mar 2021 21:42:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2Xkh2ILurEIs; Tue,  2 Mar 2021 21:42:40 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BB20F4B709;
	Tue,  2 Mar 2021 21:42:40 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4DF974B707
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Mar 2021 21:42:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tSmRKDhWcanL for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Mar 2021 21:42:39 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 10F0A4B67B
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Mar 2021 21:42:39 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8D8B71FB;
 Tue,  2 Mar 2021 18:42:38 -0800 (PST)
Received: from entos-ampere-02.shanghai.arm.com
 (entos-ampere-02.shanghai.arm.com [10.169.214.110])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id A34EE3F73B;
 Tue,  2 Mar 2021 18:42:34 -0800 (PST)
From: Jia He <justin.he@arm.com>
To: Marc Zyngier <maz@kernel.org>,
	kvmarm@lists.cs.columbia.edu
Subject: [PATCH] KVM: arm64: Fix unaligned addr case in mmu walking
Date: Wed,  3 Mar 2021 10:42:25 +0800
Message-Id: <20210303024225.2591-1-justin.he@arm.com>
X-Mailer: git-send-email 2.17.1
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Jia He <justin.he@arm.com>,
 Will Deacon <will@kernel.org>
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
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

If the start addr is not aligned with the granule size of that level.
loop step size should be adjusted to boundary instead of simple
kvm_granual_size(level) increment. Otherwise, some mmu entries might miss
the chance to be walked through.
E.g. Assume the unmap range [data->addr, data->end] is
[0xff00ab2000,0xff00cb2000] in level 2 walking and NOT block mapping.
And the 1st part of that pmd entry is [0xff00ab2000,0xff00c00000]. The
pmd value is 0x83fbd2c1002 (not valid entry). In this case, data->addr
should be adjusted to 0xff00c00000 instead of 0xff00cb2000.

Without this fix, userspace "segment fault" error can be easily
triggered by running simple gVisor runsc cases on an Ampere Altra
server:
    docker run --runtime=runsc -it --rm  ubuntu /bin/bash

In container:
    for i in `seq 1 100`;do ls;done

Reported-by: Howard Zhang <Howard.Zhang@arm.com>
Signed-off-by: Jia He <justin.he@arm.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index bdf8e55ed308..4d99d07c610c 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -225,6 +225,7 @@ static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
 		goto out;
 
 	if (!table) {
+		data->addr = ALIGN_DOWN(data->addr, kvm_granule_size(level));
 		data->addr += kvm_granule_size(level);
 		goto out;
 	}
-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
