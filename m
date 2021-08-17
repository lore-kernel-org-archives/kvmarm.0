Return-Path: <SRS0=6VsV=NI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A94DC4338F
	for <kvmarm@archiver.kernel.org>; Tue, 17 Aug 2021 08:11:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A818B60F41
	for <kvmarm@archiver.kernel.org>; Tue, 17 Aug 2021 08:11:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A818B60F41
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 493A44B145;
	Tue, 17 Aug 2021 04:11:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sVomKyCyDqeU; Tue, 17 Aug 2021 04:11:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D25F4B150;
	Tue, 17 Aug 2021 04:11:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 71B864B13E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Aug 2021 04:11:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DoVqOsag4K31 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Aug 2021 04:11:40 -0400 (EDT)
Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com
 [209.85.219.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6E1484B141
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Aug 2021 04:11:40 -0400 (EDT)
Received: by mail-qv1-f73.google.com with SMTP id
 r14-20020a0c8d0e0000b02902e82df307f0so14313998qvb.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Aug 2021 01:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=gw2LswsJmGwYXUvemUxTnggwwTkhoQCT+deYh5e54GU=;
 b=IvyYurtwJCZW0dkFujHS6ilPFANox0AtHkdYRyiKJCtJ4973Eso0xUyexV0vfmzgs2
 7o386Y9WY1mm0cmgG9RC9amfrRtuCbPVCQ2C/eRwIk88QzxGonk9hA/22vGzDOHPmdAU
 dVS3o36GV566Rg5ZaLyKERcqv1hYP7WpCWZqEoGne3aYYHrvkQoKYvBFKPPuCfGn+MfN
 pwKF71bqOZoGFZ1tVpTMYhrXQjRYP8EnW5XgIBvImeout1vK3T7MlcnrWnSgXqL7co66
 0xYQngJRfHHibCgF/64bHJCcsGYuBoOtej+9PWwthQiMwn68ajx0PSncD6C+gMt774KJ
 Z5Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=gw2LswsJmGwYXUvemUxTnggwwTkhoQCT+deYh5e54GU=;
 b=Z5V2BlgraQjPfwSLPs6nvytjnwfqDC396dCiE2Q0BC9o8yVuATjFXIpgwlQ5ZUUgiF
 ZO/B4FI+N5XEt5DYNB4zQ6f5GDU1sHUNV2l/0DVwjLU70qX6NtHB61nWqCFcpz0QlNTj
 JJVuV3Gz0R2/U8mH8zU+X/QSpU70RV6dx5FUViqAanxP56ATqRGd6WsEQSK+mIzkorbi
 gUbwjM3MJjOnjqrGGb4kex1Ijfl8+2im0x06QJtLTKVd/5YTurcg899sUUPmxkz8HbIV
 3I/Uc5dZm7Gez4ViClNTdvvs3cWvubUpW6VVdNPUcSwGUA5ATFqFc/RXgFjVCt640hza
 6dgw==
X-Gm-Message-State: AOAM533AXysZCTYq3176wem4uv9YTk6N4NS1+4upUQGRzCvgA2wE3kAz
 /9KdRwfCUG7a7Dsq3678noVcZ6uCNNwJDWUB7JOWPpQkF7mHIxJcnrznWWdR3HiZD1JEaRi33AB
 3LsGGT857cln4WLymaZ+zrLOFW7aamcTO/cNKJnHgELv0iH5znP8HVDj8oSG0lvFJPQw=
X-Google-Smtp-Source: ABdhPJwEf+noobKDIMb8yGxWg5hsBK+Cx5/cHbuKhsdc9IPXIZtXX4a8CpfwqCj/Z6egtP8X7XkIYRMzCQ==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:ad4:58cc:: with SMTP id
 dh12mr2069199qvb.32.1629187899986; 
 Tue, 17 Aug 2021 01:11:39 -0700 (PDT)
Date: Tue, 17 Aug 2021 09:11:21 +0100
In-Reply-To: <20210817081134.2918285-1-tabba@google.com>
Message-Id: <20210817081134.2918285-3-tabba@google.com>
Mime-Version: 1.0
References: <20210817081134.2918285-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v4 02/15] KVM: arm64: Remove trailing whitespace in comment
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 pbonzini@redhat.com, will@kernel.org, linux-arm-kernel@lists.infradead.org
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

Remove trailing whitespace from comment in trap_dbgauthstatus_el1().

No functional change intended.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/sys_regs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index f6f126eb6ac1..80a6e41cadad 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -318,14 +318,14 @@ static bool trap_dbgauthstatus_el1(struct kvm_vcpu *vcpu,
 /*
  * We want to avoid world-switching all the DBG registers all the
  * time:
- * 
+ *
  * - If we've touched any debug register, it is likely that we're
  *   going to touch more of them. It then makes sense to disable the
  *   traps and start doing the save/restore dance
  * - If debug is active (DBG_MDSCR_KDE or DBG_MDSCR_MDE set), it is
  *   then mandatory to save/restore the registers, as the guest
  *   depends on them.
- * 
+ *
  * For this, we use a DIRTY bit, indicating the guest has modified the
  * debug registers, used as follow:
  *
-- 
2.33.0.rc1.237.g0d66db33f3-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
