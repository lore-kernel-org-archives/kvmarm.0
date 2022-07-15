Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5AAFC433EF
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jul 2022 23:58:36 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 19E7F4C332;
	Fri, 15 Jul 2022 19:58:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id luO3cVPz11v7; Fri, 15 Jul 2022 19:58:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1EC854C338;
	Fri, 15 Jul 2022 19:58:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 05CD94C332
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 19:58:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id E4CpNF+57elW for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jul 2022 19:58:32 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D23254C32C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 19:58:32 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 k13-20020a056902024d00b0066fa7f50b97so4840255ybs.6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 16:58:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=4Gh4HGzCqCiR1aMRIxtcGB+xW1TuymtOUOGGi3XUe+w=;
 b=laaDvU+ra+tX4Ugt/hApPQt2F+7sMcLjlMfErCxQ6ZAH13Fl9Hv7omF2Saquz513mu
 J+bzAYxUx7CJ7btjmdncYrC4Y1veu4NHmQSeNXnOpqCAxzIaB5YMd/l72BqrmAcB25Re
 aNK+JcXfLhxCXei0o7ELRQeRTW82+RLqR5IixgRFrLcuYYER2aDhKQ486g/VCwUqVWtH
 tasGaqajdMOPcNItlrkBHc6TN6iHktOIIjVTgbV/GxxseQ1L4UA2gFqmJgw62Ugr1v/5
 6gP6onX2YcRMENGDJD/h2b8G3wSA1GpfizjMN4ihAYbf/2VUfRAwE7VGIPqLL9iTf/e3
 aq7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=4Gh4HGzCqCiR1aMRIxtcGB+xW1TuymtOUOGGi3XUe+w=;
 b=dQey7A45rtoQ/EizY2DRvjpUCbhRVpc2+5Vw5+Ag027OQVFqwaJ9/BpQt7mMGZAqWI
 loFkt8qE0si1pVGIsua2GYASBFsX/w4fgFtwC7E5L0bwfEns15QXAiaE2ShjROL3N/34
 ZIXK6DHzOV+v6Cnj3I2iu8Mh2Oemxj3q5eeoZ+/Gc3KNdKnmDqBwe5DMYh+k9DAI7Fy9
 Qfjpx3PQ6c8+QQw5DyXkyZq0geHc+8VXCiL5YJza20VAvUhuwJ7bj7Wads01NByVgG1F
 dheSEwAHVEqhekso1wDWK7uKwn2bw8sCA+2Yt4iy6kPS9TaJu0QFz9F9SLcgqbZLaAVe
 1oVQ==
X-Gm-Message-State: AJIora8SMyaCi1bMYr4MVlaGntGFTRuZwS4OHkAHJJTi6wKLSG5c7Sub
 6ELbGFsvM4AJzvqqmxWGc4CiwlRL5zFq1R6lsA==
X-Google-Smtp-Source: AGRyM1vkyU/rsorWG73TjyeqssO4W2twt9Xtdrwt2iDSADe0KqgrXHN+i9CgnK6UL1nt08B+26vBLjDJeLP2QInhhQ==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:dbad:2778:c9ea:c5e9])
 (user=kaleshsingh job=sendgmr) by 2002:a25:cb85:0:b0:66f:fffd:a726 with SMTP
 id b127-20020a25cb85000000b0066ffffda726mr3177720ybg.287.1657929512302; Fri,
 15 Jul 2022 16:58:32 -0700 (PDT)
Date: Fri, 15 Jul 2022 16:58:24 -0700
Message-Id: <20220715235824.2549012-1-kaleshsingh@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH] KVM: arm64: Fix hypervisor address symbolization
From: Kalesh Singh <kaleshsingh@google.com>
To: maz@kernel.org, mark.rutland@arm.com, broonie@kernel.org, 
 madvenka@linux.microsoft.com, tabba@google.com
Cc: android-mm@google.com, Catalin Marinas <catalin.marinas@arm.com>,
 will@kernel.org, linux-kernel@vger.kernel.org, kernel-team@android.com,
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

With CONFIG_RANDOMIZE_BASE=y vmlinux addresses will resolve correctly
from kallsyms. Fix this by adding the KASLR offset before printing the
symbols.

Based on arm64 for-next/stacktrace.

Fixes: 6ccf9cb557bd ("KVM: arm64: Symbolize the nVHE HYP addresses")
Reported-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
---
 arch/arm64/kvm/handle_exit.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index f66c0142b335..e43926ef2bc2 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -347,10 +347,10 @@ void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr,
 			kvm_err("nVHE hyp BUG at: %s:%u!\n", file, line);
 		else
 			kvm_err("nVHE hyp BUG at: [<%016llx>] %pB!\n", panic_addr,
-					(void *)panic_addr);
+					(void *)(panic_addr + kaslr_offset()));
 	} else {
 		kvm_err("nVHE hyp panic at: [<%016llx>] %pB!\n", panic_addr,
-				(void *)panic_addr);
+				(void *)(panic_addr + kaslr_offset()));
 	}
 
 	/*

base-commit: 82a592c13b0aeff94d84d54183dae0b26384c95f
-- 
2.37.0.170.g444d1eabd0-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
