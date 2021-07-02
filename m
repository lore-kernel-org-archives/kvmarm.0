Return-Path: <SRS0=R38U=L2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB7B6C07E95
	for <kvmarm@archiver.kernel.org>; Fri,  2 Jul 2021 20:10:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4FFCD61260
	for <kvmarm@archiver.kernel.org>; Fri,  2 Jul 2021 20:10:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4FFCD61260
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A760C4B085;
	Fri,  2 Jul 2021 16:10:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ATnggTGsA7wj; Fri,  2 Jul 2021 16:10:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B361B4A023;
	Fri,  2 Jul 2021 16:10:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 262BE49D50
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Jul 2021 16:10:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id a0T734hUCvBO for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Jul 2021 16:10:47 -0400 (EDT)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D78E44A418
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Jul 2021 16:10:46 -0400 (EDT)
Received: by mail-pl1-f201.google.com with SMTP id
 t10-20020a170902b20ab029011b9ceafaafso4813089plr.11
 for <kvmarm@lists.cs.columbia.edu>; Fri, 02 Jul 2021 13:10:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=fpTMG9fTauuJitLgUq7zAvCgQyWDpOArBs49FPLP0Y8=;
 b=cWJYhK77Lz48nM1zUfdkD63tuVW35Zj5TXtFYFq1P1W1qtHaQbo8Q4WJrRC6q6uhMh
 nYZkiJaDnODzk3LqLzFd8rBN/LALvb5DN7FOiYvEiXblBhWLwR85YfH6LbnQdAU6Nq8U
 SALRKARCEvW5YH7ztZq5c7EXdzD27ik79eRm4bY/LsydzA5vr3HpnbK+ck59+PJi4Rn2
 nJJrU3MeSy027Xdk2w7pI5CqqYjTYvhtjyi98TKLF/Z2q2xWRimt3P6xSuqO+2AMoeFl
 p1EY3lSvlgrNMTbeuqsaUhOwHDSBTkP5FaIejRDb3qnyEfcSrchzR9+uBo6psxj/R2Fw
 GC9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=fpTMG9fTauuJitLgUq7zAvCgQyWDpOArBs49FPLP0Y8=;
 b=TVg7RQJff3gtNSTuKWPjs9DkT0c6rv7fJtjFcmkAC4MtaA/nwivq1FcJ/KObltl9gK
 cCjiro+zgxfQ1w2pTQkedT+r9h+zdB0YbVsv5dULAM+/awX+g+hAiYbtI57hmA+/hnkM
 SXDFXcwBVh8jNfGzH1+TWJ59II3jRehjklyq6Qoi2OFsCVz0NFaZGqvQFWwSRJXTjIyk
 /XTVYYZ60Dpg3ukx0Q4TFgifTcpuDsFNgCmTuH8g2NiDLE2c8LRLBFgZ+RDKTTgxhOqH
 DkFeem2pqJtXXH2Q5xhmOO9JD/t9J2dZyvzihQe52BAxTHv16b4aojvvwBKyrQ3j8GoT
 TU9w==
X-Gm-Message-State: AOAM533mzLmOiHEXfiAL3qQC83iaCi3KnvemgLX/OFahSGtfGAv8CWND
 +VQey6P+VmyoLv6Tzt7kzS9UAhcM+dIVQw==
X-Google-Smtp-Source: ABdhPJxGiYdV5yfa5L2g288Y7UPX8c8X/2XRZTO42+QGgpt9/aMwR4B2q9GbJz60UPQnwc7tat7p1qqFeRBQKw==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a05:6a00:1411:b029:302:d9d6:651d with
 SMTP id l17-20020a056a001411b0290302d9d6651dmr1254121pfu.56.1625256645780;
 Fri, 02 Jul 2021 13:10:45 -0700 (PDT)
Date: Fri,  2 Jul 2021 13:10:42 -0700
Message-Id: <20210702201042.4036162-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH] KVM: selftests: Address extra memslot parameters in
 vm_vaddr_alloc
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org
Cc: maz@kernel.org, seanjc@google.com, pbonzini@redhat.com,
 kvmarm@lists.cs.columbia.edu
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

Commit a75a895e6457 ("KVM: selftests: Unconditionally use memslot 0 for
vaddr allocations") removed the memslot parameters from vm_vaddr_alloc.
It addressed all callers except one under lib/aarch64/, due to a race
with commit e3db7579ef35 ("KVM: selftests: Add exception handling
support for aarch64")

Fix the vm_vaddr_alloc call in lib/aarch64/processor.c.

Reported-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 tools/testing/selftests/kvm/lib/aarch64/processor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 9f49f6caafe5..632b74d6b3ca 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -401,7 +401,7 @@ void route_exception(struct ex_regs *regs, int vector)
 void vm_init_descriptor_tables(struct kvm_vm *vm)
 {
 	vm->handlers = vm_vaddr_alloc(vm, sizeof(struct handlers),
-			vm->page_size, 0, 0);
+			vm->page_size);
 
 	*(vm_vaddr_t *)addr_gva2hva(vm, (vm_vaddr_t)(&exception_handlers)) = vm->handlers;
 }
-- 
2.32.0.93.g670b81a890-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
