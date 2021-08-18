Return-Path: <SRS0=mpH5=NJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CA2BC4338F
	for <kvmarm@archiver.kernel.org>; Wed, 18 Aug 2021 21:29:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F3B996104F
	for <kvmarm@archiver.kernel.org>; Wed, 18 Aug 2021 21:29:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org F3B996104F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A6014B0E2;
	Wed, 18 Aug 2021 17:29:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zhmEo2Wtesw8; Wed, 18 Aug 2021 17:29:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8372A4B0D0;
	Wed, 18 Aug 2021 17:29:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 24C254B0AC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Aug 2021 17:29:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dBuYW-+8VzCJ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Aug 2021 17:29:43 -0400 (EDT)
Received: from mail-io1-f74.google.com (mail-io1-f74.google.com
 [209.85.166.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1AEA14B0D4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Aug 2021 17:29:43 -0400 (EDT)
Received: by mail-io1-f74.google.com with SMTP id
 d23-20020a056602281700b005b5b34670c7so1993428ioe.12
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Aug 2021 14:29:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=r0FgUlCJu9+wIAf52h2bi1oS9KbPICUGE0YYTryeif4=;
 b=GGlQqDPl+00f6Sw7Ej0S+LP6MVGJpkd0Q6zAxuztEEw0vrQohIjWqGQtZaUDxPJmBM
 liFqt/gLOvHtLDd3mhe+QH4v24BGdhFnuF4aQUyAnx9fU/JAZjQ+ie+aGO/8dET0tNug
 5/bibVsZwTNmAszZouYcnULfpF/eTGM95aptt9UHk0trQ5h9sX0RfzPVdzEm9rqJU7lh
 jzEAfEMiRGTvGK4tI6rAunZip4C7M9te4LxqdiZ0mF8e7R/nWRl7dc5nu7QIAwNO/4RK
 qlRQ1++dsIzwypVhhXnuYXLG4Iii0HvJy21Jx4itlXOjU5k9POjUu0MSDLvtdc5+zpsQ
 0V0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=r0FgUlCJu9+wIAf52h2bi1oS9KbPICUGE0YYTryeif4=;
 b=qcJvTTXMPmf3U/fAI71ruwcTeKVF25U981dU+teLUbGIyh6+mAJ3rxk0jWQsQYd3yW
 8+ltHrLNHMD098wRWb/rWVdtiQPOvKvQqx8e1SVQuJ2QAmimEMXWjb9k7Bp4qZgmwvnW
 Y3QqjDJsRFLD4mOZ+r4rSKmCHNVeXaQ8S6za0P3oH3JA14/vtlZu19rL916p5312Ejyt
 Z4oyKgAfWMRU+FFIGxc1l8N520TKdjYq9iKEdyogoSRfQKBpoNKraeIdmpcvt+m1XGdp
 4CCt+pkAQ1Y4/OtEdqWp/ld5giplzNS2HNVQe69Tut8CT46gGe+/zC84E4OS9/P+K9OE
 9K2Q==
X-Gm-Message-State: AOAM5308licYLBl3/kffC8CFzCm0pk6RXi8JWT/x9ZjvYvShX+dh1GQt
 EqaOKAeb7WsxkLU0Qh4KOCJp/VD//BQ=
X-Google-Smtp-Source: ABdhPJz3u9ty537z/NPYa/tLv11Wq28UhMlKAPaNZSneh5bzjU0yVDovnyinmUVLtziNrE8PCJFBj/VpU1g=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a02:860d:: with SMTP id
 e13mr9986329jai.12.1629322182458; 
 Wed, 18 Aug 2021 14:29:42 -0700 (PDT)
Date: Wed, 18 Aug 2021 21:29:40 +0000
Message-Id: <20210818212940.1382549-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH] selftests: KVM: Gracefully handle missing vCPU features
From: Oliver Upton <oupton@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 Raghavendra Rao Anata <rananta@google.com>
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

An error of ENOENT for the KVM_ARM_VCPU_INIT ioctl indicates that one of
the requested feature flags is not supported by the kernel/hardware.
Detect the case when KVM doesn't support the requested features and skip
the test rather than failing it.

Cc: Andrew Jones <drjones@redhat.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
Applies to 5.14-rc6. Tested by running all selftests on an Ampere Mt.
Jade system.

 .../testing/selftests/kvm/lib/aarch64/processor.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 632b74d6b3ca..b1064a0c5e62 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -216,6 +216,7 @@ void aarch64_vcpu_setup(struct kvm_vm *vm, int vcpuid, struct kvm_vcpu_init *ini
 {
 	struct kvm_vcpu_init default_init = { .target = -1, };
 	uint64_t sctlr_el1, tcr_el1;
+	int ret;
 
 	if (!init)
 		init = &default_init;
@@ -226,7 +227,19 @@ void aarch64_vcpu_setup(struct kvm_vm *vm, int vcpuid, struct kvm_vcpu_init *ini
 		init->target = preferred.target;
 	}
 
-	vcpu_ioctl(vm, vcpuid, KVM_ARM_VCPU_INIT, init);
+	ret = _vcpu_ioctl(vm, vcpuid, KVM_ARM_VCPU_INIT, init);
+
+	/*
+	 * Missing kernel feature support should result in skipping the test,
+	 * not failing it.
+	 */
+	if (ret && errno == ENOENT) {
+		print_skip("requested vCPU features not supported; skipping test.");
+		exit(KSFT_SKIP);
+	}
+
+	TEST_ASSERT(!ret, "KVM_ARM_VCPU_INIT failed, rc: %i errno: %i (%s)",
+		    ret, errno, strerror(errno));
 
 	/*
 	 * Enable FP/ASIMD to avoid trapping when accessing Q0-Q15
-- 
2.33.0.rc1.237.g0d66db33f3-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
