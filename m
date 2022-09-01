Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41243ECAAD4
	for <kvmarm@archiver.kernel.org>; Sat,  3 Sep 2022 08:46:57 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 95B8E40E62;
	Sat,  3 Sep 2022 04:46:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HjmniduA48ir; Sat,  3 Sep 2022 04:46:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 748354B2AE;
	Sat,  3 Sep 2022 04:46:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E8F654BAD2
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Sep 2022 03:46:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kaup5O8IrYiQ for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Sep 2022 03:46:49 -0400 (EDT)
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com
 [209.85.215.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C474A4BA16
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Sep 2022 03:46:49 -0400 (EDT)
Received: by mail-pg1-f179.google.com with SMTP id q63so15622826pga.9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 01 Sep 2022 00:46:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:from:to:cc:subject:date;
 bh=v+aLW6XSZxp9QimTfsr5QzeEYxLaT3pFWzo7n2FYHsg=;
 b=Sjc4P9vtTICGifkH/YlHUrvW6OqfseM+FUoA8uWncagd1YTJp0Kgr4uTUIbN9ylss7
 eQXw9QMRS0E2AWBdLonQ9moT7U9gFzLZBm++KmQZ37P904d7Sp+eQVaVaFQ8BZRNBaDT
 krAmrWoTEI0qUA5b/WAN9ijYM1xXjw7uDvrlP+PGqJ9cRZ7X1IWM6K3dtNuWFRs2AThH
 MNu0s2f3t2XwprPZcROE56ggj7q3uSI2f2rjvBVmc5Xs8234YsqLnV+9y9yun4j3bklv
 e2zygYkUqqE9JmxutNE0rTL5r8/HzvRl0CELOu2JKlWBskZIydTaXZ6rGaUxpEWTilHo
 b6Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:x-gm-message-state:from:to:cc:subject:date;
 bh=v+aLW6XSZxp9QimTfsr5QzeEYxLaT3pFWzo7n2FYHsg=;
 b=YcQc4IjZf1RT69M0fTRALZaZn69nE7yM8qzEowZ+ZBJiU0JN+f6Lex5uAVkNITOGnF
 6gaCCFcgrbM+UGzZuioeL6tpQFm4g9GCWts66R1rSJszKJlVnrg5h+7dV83uVnxxURxG
 R+fgr0L4wQmdRoxIQts1UZfQc0kHzU4wo9qU9DbUnkwbPvOqoINZi5l03GBG7m4KCm+6
 D610lm97zMf/xwhr+Afq6ieD5vJQ6obEyD7gsmSFNnVJ8zG9cg1AOA3CeF4MyD2UuQWR
 ZSB+LEWjAx7hpify3C0JwYeQXLs2IlY9OcVL0FF7HVYEecgzU9RKKiKQLsaDryBzPoFE
 DldQ==
X-Gm-Message-State: ACgBeo1tGLVA7gVN8xh9wO0vfFUbdv6r5M/u8pNqYxYMf3kln5RBd4mY
 RJqKKGuIF02o5GrYjn/DVCk=
X-Google-Smtp-Source: AA6agR610XS+pdZVYOD8grBauRiJL+ULVLoy8BvDYGZJcvsyMHlC68ot6TWwzHzgvhHPp0QvhAfWFw==
X-Received: by 2002:a65:6bc4:0:b0:3c2:2f7c:cc74 with SMTP id
 e4-20020a656bc4000000b003c22f7ccc74mr24864261pgw.307.1662018408485; 
 Thu, 01 Sep 2022 00:46:48 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
 by smtp.gmail.com with ESMTPSA id
 w18-20020a1709027b9200b001728ac8af94sm12920079pll.248.2022.09.01.00.46.46
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 01 Sep 2022 00:46:48 -0700 (PDT)
From: cgel.zte@gmail.com
X-Google-Original-From: ye.xingchen@zte.com.cn
To: maz@kernel.org
Subject: [PATCH linux-next] KVM: arm64: Remove the unneeded result variable
Date: Thu,  1 Sep 2022 07:46:43 +0000
Message-Id: <20220901074643.313329-1-ye.xingchen@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-Mailman-Approved-At: Sat, 03 Sep 2022 04:46:54 -0400
Cc: will@kernel.org, Zeal Robot <zealci@zte.com.cn>,
 linux-kernel@vger.kernel.org, ye xingchen <ye.xingchen@zte.com.cn>,
 catalin.marinas@arm.com, gankulkarni@os.amperecomputing.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

From: ye xingchen <ye.xingchen@zte.com.cn>

Return the value kvm_pgtable_walk() directly instead of storing it in
another redundant variable.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: ye xingchen <ye.xingchen@zte.com.cn>
---
 arch/arm64/kvm/hyp/pgtable.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 2cb3867eb7c2..a5fa05e34de9 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -925,7 +925,6 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 int kvm_pgtable_stage2_set_owner(struct kvm_pgtable *pgt, u64 addr, u64 size,
 				 void *mc, u8 owner_id)
 {
-	int ret;
 	struct stage2_map_data map_data = {
 		.phys		= KVM_PHYS_INVALID,
 		.mmu		= pgt->mmu,
@@ -945,8 +944,7 @@ int kvm_pgtable_stage2_set_owner(struct kvm_pgtable *pgt, u64 addr, u64 size,
 	if (owner_id > KVM_MAX_OWNER_ID)
 		return -EINVAL;
 
-	ret = kvm_pgtable_walk(pgt, addr, size, &walker);
-	return ret;
+	return kvm_pgtable_walk(pgt, addr, size, &walker);
 }
 
 static int stage2_unmap_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
-- 
2.25.1
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
