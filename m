Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 702A1C43217
	for <kvmarm@archiver.kernel.org>; Sat, 19 Nov 2022 01:35:02 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E2E584BB4B;
	Fri, 18 Nov 2022 20:35:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QaZpbf6Ru2UG; Fri, 18 Nov 2022 20:35:00 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AF92A4BB6F;
	Fri, 18 Nov 2022 20:35:00 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D38B4BB4B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Nov 2022 20:34:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6HHKtWNp14oZ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Nov 2022 20:34:57 -0500 (EST)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5592B4BB4A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Nov 2022 20:34:57 -0500 (EST)
Received: by mail-pj1-f73.google.com with SMTP id
 q93-20020a17090a1b6600b0021311ab9082so3818704pjq.7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Nov 2022 17:34:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
 bh=3L4OGgzlwO72UOhCz/yhgDnemDx1svOqEC1kNqY2LlY=;
 b=TVbNKYXyk9Av6G9IU5hbcSdtY604tXdeCj/mxuYUgo562vyrKEnoOwdFmmSYRnZrhU
 LBAmImeVeqCcB52XaO11Dmz+EQI28t/X/Gs+d5+qZTdOdJf7GMrh0NFsTqYcRXm4daLY
 1hASafr2iIbEc1hm+AW2G4MQ9J2SaNiShD66DGhZuBIFahYe4A7PKc4KgX+70SodAs71
 LXrpBgaC8CNiujzkmhmqZsdDxNiUEsMLzhgiL5qXrHvOT5DFgOO6Q4QTpk/DiS8A560t
 FkLFabDChtATnitORRutffp7/vTBioX1ecxNmZ4lOUjomxAKyCBVCCd95HwPrc++VJ5O
 5zWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=3L4OGgzlwO72UOhCz/yhgDnemDx1svOqEC1kNqY2LlY=;
 b=S42WXK1Vi5wexi3QaX3f1Uvf3KmnRjVvIuzuBRVk5X7GYI3Mh3tD6WpBmAg4kPPfFi
 krgNEff7C6K8kzuYX7aIu137fXTA3p6TMIZcEJyPQtdTYMXE0IoznNm+A6SYWjElHYdV
 tr8Gl417lrzYRs3CYqnd7LcFJovWE0a7r4wWaPBfDXU/8B+qbUtXDgLpaXb53fdup5At
 Igf93/H7eQRr5GJxHX9X94xqrJaV0AK5SFpPlbUy663oASnD7BQq6gayVeUBb7/s5XlU
 GXg70nhcQ0AWP2hSybDcUlVehAd1FV44+LBGM5LRviRLjy9/FGkMHXS2vR0pD5PTiLmA
 fSnQ==
X-Gm-Message-State: ANoB5plMS7gtRt/0yreSc6rEeFc/ofqXRjOoIVqpNOFIq9u9qu72YxS7
 M9d8k5EtVciIp/Qn+N4d9VIO+1GFe84=
X-Google-Smtp-Source: AA0mqf4a3EuImoG/D3FXOGGiQ5UvajgyaUYXWjbOt902dSxf64funzGHz6rGaLtUr696UrpKBN8u95QEt7U=
X-Received: from zagreus.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:4615:b0:218:8f4:bad5 with SMTP id
 w21-20020a17090a461500b0021808f4bad5mr16521916pjg.55.1668821696975; Fri, 18
 Nov 2022 17:34:56 -0800 (PST)
Date: Sat, 19 Nov 2022 01:34:43 +0000
In-Reply-To: <20221119013450.2643007-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221119013450.2643007-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221119013450.2643007-3-seanjc@google.com>
Subject: [PATCH 2/9] KVM: selftests: Remove unused "vcpu" param to fix build
 error
From: Sean Christopherson <seanjc@google.com>
To: Yury Norov <yury.norov@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org,
 linux-perf-users@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
 kvmarm@lists.linux.dev, Namhyung Kim <namhyung@kernel.org>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Sean Christopherson <seanjc@google.com>
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

Drop the vcpu param in the Hyper-V TLB flush test's call to
vm_get_page_table_entry().  Commit 751f280017b6 ("KVM: selftests: Drop
reserved bit checks from PTE accessor") eliminated the param, but the
in-flight patch to add the Hyper-V test didn't get the memo.

Fixes: a105ac64bef6 ("KVM: selftests: Hyper-V PV TLB flush selftest")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86_64/hyperv_tlb_flush.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_tlb_flush.c b/tools/testing/selftests/kvm/x86_64/hyperv_tlb_flush.c
index 44525255f5c8..68f97ff720a7 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_tlb_flush.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_tlb_flush.c
@@ -625,7 +625,7 @@ int main(int argc, char *argv[])
 	 */
 	gva = vm_vaddr_unused_gap(vm, NTEST_PAGES * PAGE_SIZE, KVM_UTIL_MIN_VADDR);
 	for (i = 0; i < NTEST_PAGES; i++) {
-		pte = vm_get_page_table_entry(vm, vcpu[0], data->test_pages + i * PAGE_SIZE);
+		pte = vm_get_page_table_entry(vm, data->test_pages + i * PAGE_SIZE);
 		gpa = addr_hva2gpa(vm, pte);
 		__virt_pg_map(vm, gva + PAGE_SIZE * i, gpa & PAGE_MASK, PG_LEVEL_4K);
 		data->test_pages_pte[i] = gva + (gpa & ~PAGE_MASK);
-- 
2.38.1.584.g0f3c55d4c2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
