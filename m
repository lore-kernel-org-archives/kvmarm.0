Return-Path: <SRS0=P5lD=NZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED2E4C433F5
	for <kvmarm@archiver.kernel.org>; Fri,  3 Sep 2021 23:12:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7E2B56108E
	for <kvmarm@archiver.kernel.org>; Fri,  3 Sep 2021 23:12:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7E2B56108E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2FE6D4B276;
	Fri,  3 Sep 2021 19:12:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KkHTHaSF6CO2; Fri,  3 Sep 2021 19:12:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 440A24B274;
	Fri,  3 Sep 2021 19:12:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 64F714B26D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Sep 2021 19:12:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Z3hdAwbLpgde for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Sep 2021 19:12:19 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 933024B266
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Sep 2021 19:12:19 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 b84-20020a253457000000b0059e6b730d45so874768yba.6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 03 Sep 2021 16:12:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=QkiTTQtXnyEZcRUySewtR+57JtdQhQ0KOdghgRxRcZE=;
 b=IooNTu6FZ9xkgjL3G/epbvjkhF5WJ6iWpr8+VQO6+GaTOokXSzKdEA+bTx1NfAnxY2
 aZlLN+0/c0EBv+91Nu4yVYvuE8Ew2QaKtBC/1lJS6EI007DAbO1McK+JknwcStWLcR+A
 gvG+F3GHevvAgWOzEy/3Y8y3zXPVnVD5qV+oo81ngQGWAmYpw0xRHqT/1uPUkTiNiYM2
 Q+om+Cc2TCagOxgA0MTtJTH5FvDiZY6KN75q5usywBKd8jf1ZlGf9NUn3I0KTkOO5+Wb
 2IXwAp39QdWj9+DhwH+j2KNDwz5DIX77nD+g5mqvkOB0S/nuwIPh5lOBEjWNCNYXfuZJ
 r8Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=QkiTTQtXnyEZcRUySewtR+57JtdQhQ0KOdghgRxRcZE=;
 b=tBSmkXvW7BTVCTgEPlRqBjbX2ExTUIbgZaRJkIkvPYBb4u2Bt9hU7jNVGHSvZ0sx4u
 OyqIsxLqP0gl0akjSdIx2PMX9TNwPvAMZw7JoMSIossx7bo0viNj2LSYe10rYc1BeNiA
 IULRSVeHshuzIqZucxN84+XwCEPsJU2qTH/XMak8ghPrn9Q++qhURjmGaS0NCSTEtwK6
 61SHd6dLXn0DkQxJi+GbP3vxf/9KWCAaRPTTSGjSUx4nH7MUsSTxkughFwgep262GlVx
 0i1SDaT7RS5lzRWvbQ/J5H7zGybaFb1ubCxWXMOjA1HbE50aQUIKB+wT27YkUP19NW3d
 hfDA==
X-Gm-Message-State: AOAM531kbpJuW1Xkua7hDtwQPam5A9T40saNCqRwczEOJg5CdrMKzQ0W
 evI4Afr+fp5CNIGW/VKBwNT/dzIgU3CtVQ==
X-Google-Smtp-Source: ABdhPJyN0dnwoh0+vwNtcBqHpCB38Wsjeqw1QVO8CQwV3gZ9X4JKa4ur2iCwNOdlMkWLD5xvCRjNKIsgX8/JCA==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a25:1bc5:: with SMTP id
 b188mr1813293ybb.267.1630710739159; Fri, 03 Sep 2021 16:12:19 -0700 (PDT)
Date: Fri,  3 Sep 2021 16:11:54 -0700
In-Reply-To: <20210903231154.25091-1-ricarkol@google.com>
Message-Id: <20210903231154.25091-3-ricarkol@google.com>
Mime-Version: 1.0
References: <20210903231154.25091-1-ricarkol@google.com>
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
Subject: [PATCH 2/2] KVM: selftests: build the memslot tests for arm64
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
index 5832f510a16c..e6e88575c40b 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -84,6 +84,8 @@ TEST_GEN_PROGS_x86_64 += set_memory_region_test
 TEST_GEN_PROGS_x86_64 += steal_time
 TEST_GEN_PROGS_x86_64 += kvm_binary_stats_test
 
+TEST_GEN_PROGS_aarch64 += memslot_modification_stress_test
+TEST_GEN_PROGS_aarch64 += memslot_perf_test
 TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
 TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
 TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
-- 
2.33.0.153.gba50c8fa24-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
