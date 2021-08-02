Return-Path: <SRS0=xqRQ=MZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E9E8C4338F
	for <kvmarm@archiver.kernel.org>; Mon,  2 Aug 2021 19:28:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 40A3E610A8
	for <kvmarm@archiver.kernel.org>; Mon,  2 Aug 2021 19:28:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 40A3E610A8
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D91D649E8A;
	Mon,  2 Aug 2021 15:28:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cXvWwPbybbs4; Mon,  2 Aug 2021 15:28:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E1CEC4A19E;
	Mon,  2 Aug 2021 15:28:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9DDA64A17F
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Aug 2021 15:28:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id c5MVYhAWxJwT for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Aug 2021 15:28:16 -0400 (EDT)
Received: from mail-il1-f202.google.com (mail-il1-f202.google.com
 [209.85.166.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6BDEF407F1
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Aug 2021 15:28:16 -0400 (EDT)
Received: by mail-il1-f202.google.com with SMTP id
 y6-20020a92d0c60000b029020757e7bf9fso8944026ila.7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 Aug 2021 12:28:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=OUDEC1vqPr7sdUdf2B7zr2nu10+QX6s5o8FUl8jn128=;
 b=UGdnaf0Z5zkw/NSqrI8i5gZcNR0jvyngA3yzdo3qsADSiJEY6hBCd+mpE/zuWfHHRK
 1uu3eDJRyuFQ2ZFJORG7LWmLah5k/+OgglzudgvK4iTfUlNbWqThqIgSaY5vTYXHBOHe
 VSNGHmflOtl8HILOX35h8lv6KZ27Eg6gCVfW1TSSp6TuuN0kIBefed3k0k+pTHI93Ppj
 /YVEfDB/dDnXAWmDJXHRiBWcrGjzys2+pKWHoje00bxlY+OaXkMAzjZqwCsOcjlMqaYu
 sSnh4SFsoRSWsaWU93DH+gz+BGSC54rKvFG6GeqZJVeELDYvCIyKollPVH04QqV4NaTI
 88sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=OUDEC1vqPr7sdUdf2B7zr2nu10+QX6s5o8FUl8jn128=;
 b=p9saevUWs/rrBhLt9YiK9bCMPIpivqxe4h3I44XZwGLmHGOMdAVf4k3VY3e1yohFXv
 CNYs6p+FUX2XdBVFEuKv1yE8R4EBU6iH4ThH9EeCkr9BtvSHWufCIBHFpUgZILHATXIj
 viAJuHDMNryKNzmGYZU3c9jW3Jsc6hyu/rBqtDJfEe8tITYe82J3O/lTbCY5w3NTLVaF
 KSOvLRChlMO4WlmtzblFm2jT8BGdEMere5jeyfcnNa1oBq/PPA5fLoxd8WPlkcAoAMFD
 fGqQ4Mn/UC9anxInHxQBIkwG76b7qiQ0AWuq8v4L5kluiHNapz94toCSdQtliq9U6x+E
 C/5g==
X-Gm-Message-State: AOAM532gvh3Mc35z7/V7+S4GyhCPOfcPiwYnlyI8VzXzLDNmXuv5nWfo
 c6PtA3Irug97blimzmYgJ9vzRGpgD5n1IBMSvSzPKhKI9fjPQp3RflSWVLzUMbACEitReFQAph0
 4g/iSAlLAdWDsRukCctE9BMHLWcV8XRu4wxtVGhl9qNIxY5BKDund3AmX48UUttGeM17A3g==
X-Google-Smtp-Source: ABdhPJw9BuQeA1J7hyFa/wKhd4oWSoC8qIUMN6Ku6i73EKILJHTfLU4lRZ39Qjqel47OyIbrpzh0uk5O0G4=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6602:3404:: with SMTP id
 n4mr724981ioz.31.1627932495517; Mon, 02 Aug 2021 12:28:15 -0700 (PDT)
Date: Mon,  2 Aug 2021 19:28:08 +0000
In-Reply-To: <20210802192809.1851010-1-oupton@google.com>
Message-Id: <20210802192809.1851010-3-oupton@google.com>
Mime-Version: 1.0
References: <20210802192809.1851010-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.554.ge1b32706d8-goog
Subject: [PATCH v3 2/3] entry: KVM: Allow use of generic KVM entry w/o full
 generic support
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: Shakeel Butt <shakeelb@google.com>, kvm@vger.kernel.org,
 Peter Zijlstra <peterz@infradead.org>, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Guangyu Shi <guangyus@google.com>, Will Deacon <will@kernel.org>,
 Andy Lutomirski <luto@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
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

Some architectures (e.g. arm64) have yet to adopt the generic entry
infrastructure. Despite that, it would be nice to use some common
plumbing for guest entry/exit handling. For example, KVM/arm64 currently
does not handle TIF_NOTIFY_PENDING correctly.

Allow use of only the generic KVM entry code by tightening up the
include list. No functional change intended.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 include/linux/entry-kvm.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/linux/entry-kvm.h b/include/linux/entry-kvm.h
index 136b8d97d8c0..0d7865a0731c 100644
--- a/include/linux/entry-kvm.h
+++ b/include/linux/entry-kvm.h
@@ -2,7 +2,11 @@
 #ifndef __LINUX_ENTRYKVM_H
 #define __LINUX_ENTRYKVM_H
 
-#include <linux/entry-common.h>
+#include <linux/static_call_types.h>
+#include <linux/tracehook.h>
+#include <linux/syscalls.h>
+#include <linux/seccomp.h>
+#include <linux/sched.h>
 #include <linux/tick.h>
 
 /* Transfer to guest mode work */
-- 
2.32.0.554.ge1b32706d8-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
