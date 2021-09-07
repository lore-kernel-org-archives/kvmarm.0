Return-Path: <SRS0=lhJk=N5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F0E4C433FE
	for <kvmarm@archiver.kernel.org>; Tue,  7 Sep 2021 18:10:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CEBC761100
	for <kvmarm@archiver.kernel.org>; Tue,  7 Sep 2021 18:10:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org CEBC761100
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E9E14B139;
	Tue,  7 Sep 2021 14:10:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xNO8iUMftTXN; Tue,  7 Sep 2021 14:10:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 835354B13A;
	Tue,  7 Sep 2021 14:10:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 13D194B086
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Sep 2021 14:10:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id p9oor+Ld6n5V for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Sep 2021 14:10:06 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D3F1D4B1C9
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Sep 2021 14:10:05 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 g192-20020a25dbc9000000b0059bd2958c8aso184554ybf.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 07 Sep 2021 11:10:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=1uFfaY/CovA+5IRgcetklkh/mmF9o80NZlcBkfT1O4k=;
 b=lqWJXZALiaVw/thW4AlSJVx2csOcUTLC8gGFw2k2qok7tIRUmDd79x8MBXSsqbsadO
 H0j0Ud0zFUeB7tei+pZ/amtAgtojA0KqfiwwNLwvhmInpbd7YZVthRogTGyP0NRVHbO7
 mnvgp6UGg4Mi6M8IYiu/xA2towCK2Pqmwo3rjnlL/kTphVOVhZDy30W6js+zm7gYtmHY
 il2qjR1iAgevs6kf3GdwSiYuMKwrI5xaVymzq2DeKhFMBhhLxCOl5yI5q9OU1AdypEmd
 9+ejT/DsGzLHNschhhkRZI86EI0+rJWc5BTnAaTrJ0oD3Cg/wowg/gj7Jv1ZVKHd/pMC
 cyCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=1uFfaY/CovA+5IRgcetklkh/mmF9o80NZlcBkfT1O4k=;
 b=sKN5KrrFqpbkHWTXje8wBvGq25H1LLJdLdl2vGmVAdRSzBnWz6UjF6coPmeP1F3q2j
 TEiRvKOn3XkCJ3a3CFgNhRmZU0H3o97vYcV+KPyamqjeMAVP8M1mvpc22hRC51zzvtNu
 rv/RK9Lzbj7uYsQE18kHEaAxrFA0GHQgVcR1tnwK/wI0trTOS6diToyYnvy0UBbl7o2K
 WeaO4FqPcM7VHA79unbAfv4kYMMmmswUNw+Nl+Z4RKkek5hOFLYmzAhjj+2LIKLhy6n/
 MVYVrFD2j7NVvMN9jFPOWGCOYfEVa2Q+jDALXh6KQnU9HlJl/YCAoL+nN4Q9n1AysTn0
 wYCg==
X-Gm-Message-State: AOAM5323Y+/y9HqECLf0wK3Sz1xV4icGkjj16acPgxtp7udOJX/IQJBV
 5SA/nwacus7y8jQN7KjdVla/aMxTloJs9g==
X-Google-Smtp-Source: ABdhPJyadT6SGgfRjBZaa5CqgsqP4c1HP4Y8XQA8avzsmPqGIbF0Sp0hAb5f8uuPoDPcrKeTXyJErM/l/NEZaw==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a25:b98b:: with SMTP id
 r11mr23645830ybg.189.1631038205374; Tue, 07 Sep 2021 11:10:05 -0700 (PDT)
Date: Tue,  7 Sep 2021 11:09:57 -0700
In-Reply-To: <20210907180957.609966-1-ricarkol@google.com>
Message-Id: <20210907180957.609966-3-ricarkol@google.com>
Mime-Version: 1.0
References: <20210907180957.609966-1-ricarkol@google.com>
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
Subject: [PATCH v2 2/2] KVM: selftests: build the memslot tests for arm64
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: maz@kernel.org, pshier@google.com, Paolo Bonzini <pbonzini@redhat.com>,
 maciej.szmigiero@oracle.com
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

Add memslot_perf_test and memslot_modification_stress_test to the list
of aarch64 selftests.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 tools/testing/selftests/kvm/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 5832f510a16c..5ed203b9314c 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -92,6 +92,8 @@ TEST_GEN_PROGS_aarch64 += dirty_log_test
 TEST_GEN_PROGS_aarch64 += dirty_log_perf_test
 TEST_GEN_PROGS_aarch64 += kvm_create_max_vcpus
 TEST_GEN_PROGS_aarch64 += kvm_page_table_test
+TEST_GEN_PROGS_aarch64 += memslot_modification_stress_test
+TEST_GEN_PROGS_aarch64 += memslot_perf_test
 TEST_GEN_PROGS_aarch64 += set_memory_region_test
 TEST_GEN_PROGS_aarch64 += steal_time
 TEST_GEN_PROGS_aarch64 += kvm_binary_stats_test
-- 
2.33.0.153.gba50c8fa24-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
